Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60930 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbeF0DZ4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jun 2018 23:25:56 -0400
Subject: Re: [PATCH 10/10] xfs_repair: use libxfs extsize/cowextsize
 validation helpers
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <153006773373.20121.9221765170427426584.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2b1b768b-2b32-2f1a-fa4d-f3e4372c84c7@sandeen.net>
Date: Tue, 26 Jun 2018 22:25:54 -0500
MIME-Version: 1.0
In-Reply-To: <153006773373.20121.9221765170427426584.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/26/18 9:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've ported the extent size hint verifiers to libxfs, call

*almost* ;)

> them from xfs_repair instead of open-coding the checks.

*nod*

> Tweak the
> repair message slightly to reflect the fact that we zero the field and
> clear the inode flag if the hint is garbage or is inconsistent with the
> inode flags.  Also clear the extent size hints when we're zapping the
> inode core since we clear the associated flags.

So for that last clause, the fix to clear_dinode_core, I wonder if it should
be a separate patch, possibly even merged before the libxfs changes.

I guess I can't prove that it's an existing bug prior to adding the extent
size hints to the verifier, but it seems weird for clear_dinode_core to
/not/ clear the extent size hint, doesn't it?

The only advantage is we could avoid any regression point for xfs/033
(which is how I found this) if we fixed up clear_dinode_core, then
added the extent size hint validation to the verifier, and then taught
xfs_repair to use the new extent size hint validation function.

Does that seem worth it?

The patch all looks fine, just wondering if we should structure/sequence
the changes more nicely.

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    2 +
>  repair/dinode.c          |   85 +++++++++++++++++++---------------------------
>  2 files changed, 38 insertions(+), 49 deletions(-)
> 
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index e5cf1554..fe8336ab 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -98,6 +98,8 @@
>  #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
>  #define xfs_idata_realloc		libxfs_idata_realloc
>  #define xfs_idestroy_fork		libxfs_idestroy_fork
> +#define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
> +#define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
>  
>  #define xfs_rmap_ag_owner		libxfs_rmap_ag_owner
>  #define xfs_rmap_alloc			libxfs_rmap_alloc
> diff --git a/repair/dinode.c b/repair/dinode.c
> index f9b2bac0..14c055bd 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -194,6 +194,11 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
>  		dinoc->di_anextents = 0;
>  	}
>  
> +	if (be32_to_cpu(dinoc->di_extsize) != 0)  {
> +		__dirty_no_modify_ret(dirty);
> +		dinoc->di_extsize = 0;
> +	}
> +
>  	if (dinoc->di_version > 1 &&
>  			be32_to_cpu(dinoc->di_nlink) != 0)  {
>  		__dirty_no_modify_ret(dirty);
> @@ -237,6 +242,11 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
>  		dinoc->di_changecount = 0;
>  	}
>  
> +	if (be32_to_cpu(dinoc->di_cowextsize) != 0)  {
> +		__dirty_no_modify_ret(dirty);
> +		dinoc->di_cowextsize = 0;
> +	}
> +
>  	return dirty;
>  }
>  
> @@ -2843,24 +2853,21 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  	 * only regular files with REALTIME or EXTSIZE flags set can have
>  	 * extsize set, or directories with EXTSZINHERIT.
>  	 */
> -	if (be32_to_cpu(dino->di_extsize) != 0) {
> -		if ((type == XR_INO_RTDATA) ||
> -		    (type == XR_INO_DIR && (be16_to_cpu(dino->di_flags) &
> -					XFS_DIFLAG_EXTSZINHERIT)) ||
> -		    (type == XR_INO_DATA && (be16_to_cpu(dino->di_flags) &
> -				 XFS_DIFLAG_EXTSIZE)))  {
> -			/* s'okay */ ;
> -		} else {
> -			do_warn(
> -_("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
> -					be32_to_cpu(dino->di_extsize), lino);
> -			if (!no_modify)  {
> -				do_warn(_("resetting to zero\n"));
> -				dino->di_extsize = 0;
> -				*dirty = 1;
> -			} else
> -				do_warn(_("would reset to zero\n"));
> -		}
> +	if (libxfs_inode_validate_extsize(mp,
> +			be32_to_cpu(dino->di_extsize),
> +			be16_to_cpu(dino->di_mode),
> +			be16_to_cpu(dino->di_flags)) != NULL) {
> +		do_warn(
> +_("Bad extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
> +				be32_to_cpu(dino->di_extsize), lino);
> +		if (!no_modify)  {
> +			do_warn(_("resetting to zero\n"));
> +			dino->di_extsize = 0;
> +			dino->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
> +						       XFS_DIFLAG_EXTSZINHERIT);
> +			*dirty = 1;
> +		} else
> +			do_warn(_("would reset to zero\n"));
>  	}
>  
>  	/*
> @@ -2868,41 +2875,21 @@ _("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
>  	 * set can have extsize set.
>  	 */
>  	if (dino->di_version >= 3 &&
> -	    be32_to_cpu(dino->di_cowextsize) != 0) {
> -		if ((type == XR_INO_DIR || type == XR_INO_DATA) &&
> -		    (be64_to_cpu(dino->di_flags2) &
> -					XFS_DIFLAG2_COWEXTSIZE)) {
> -			/* s'okay */ ;
> -		} else {
> -			do_warn(
> -_("Cannot have non-zero CoW extent size %u on non-cowextsize inode %" PRIu64 ", "),
> -					be32_to_cpu(dino->di_cowextsize), lino);
> -			if (!no_modify)  {
> -				do_warn(_("resetting to zero\n"));
> -				dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
> -				dino->di_cowextsize = 0;
> -				*dirty = 1;
> -			} else
> -				do_warn(_("would reset to zero\n"));
> -		}
> -	}
> -
> -	/*
> -	 * Can't have the COWEXTSIZE flag set with no hint.
> -	 */
> -	if (dino->di_version >= 3 &&
> -	    be32_to_cpu(dino->di_cowextsize) == 0 &&
> -	    (be64_to_cpu(dino->di_flags2) & XFS_DIFLAG2_COWEXTSIZE)) {
> +	    libxfs_inode_validate_cowextsize(mp,
> +			be32_to_cpu(dino->di_cowextsize),
> +			be16_to_cpu(dino->di_mode),
> +			be16_to_cpu(dino->di_flags),
> +			be64_to_cpu(dino->di_flags2)) != NULL) {
>  		do_warn(
> -_("Cannot have CoW extent size of zero on cowextsize inode %" PRIu64 ", "),
> -				lino);
> +_("Bad CoW extent size %u on non-cowextsize inode %" PRIu64 ", "),
> +				be32_to_cpu(dino->di_cowextsize), lino);
>  		if (!no_modify)  {
> -			do_warn(_("clearing cowextsize flag\n"));
> +			do_warn(_("resetting to zero\n"));
>  			dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
> +			dino->di_cowextsize = 0;
>  			*dirty = 1;
> -		} else {
> -			do_warn(_("would clear cowextsize flag\n"));
> -		}
> +		} else
> +			do_warn(_("would reset to zero\n"));
>  	}
>  
>  	/* nsec fields cannot be larger than 1 billion */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
