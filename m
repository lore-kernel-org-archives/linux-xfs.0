Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728452AbeGZC7A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 22:59:00 -0400
Subject: Re: [PATCH 12/10] xfs_repair: use libxfs extsize/cowextsize
 validation helpers
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <20180628173008.GJ5711@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <6c0bc803-dd19-2b1f-a843-b5c555fab25a@redhat.com>
Date: Wed, 25 Jul 2018 18:44:33 -0700
MIME-Version: 1.0
In-Reply-To: <20180628173008.GJ5711@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/28/18 10:30 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've ported the extent size hint verifiers to libxfs, call
> them from xfs_repair instead of open-coding the checks.  Tweak the
> repair message slightly to reflect the fact that we zero the field and
> clear the inode flag if the hint is garbage or is inconsistent with the
> inode flags.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    2 +
>  repair/dinode.c          |   75 ++++++++++++++++------------------------------
>  2 files changed, 28 insertions(+), 49 deletions(-)
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

oh hey, I stepped on this with my later patches didn't I, sorry. I'll sort it out.

>  
>  #define xfs_rmap_ag_owner		libxfs_rmap_ag_owner
>  #define xfs_rmap_alloc			libxfs_rmap_alloc
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 4118db7c..14c055bd 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2853,24 +2853,21 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
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

Failure doesn't mean it's "non-realtime/extsize" right?  It could
in fact be flagged as extsize but with a bad value?

> +		if (!no_modify)  {
> +			do_warn(_("resetting to zero\n"));
> +			dino->di_extsize = 0;
> +			dino->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
> +						       XFS_DIFLAG_EXTSZINHERIT);
> +			*dirty = 1;
> +		} else
> +			do_warn(_("would reset to zero\n"));
...

> -_("Cannot have CoW extent size of zero on cowextsize inode %" PRIu64 ", "),
> -				lino);
> +_("Bad CoW extent size %u on non-cowextsize inode %" PRIu64 ", "),
> +				be32_to_cpu(dino->di_cowextsize), lino);

Ditto ...

The test could also fail for a cowextsize inode if the size is not
legit, right?  I'm not sure why this says "non-cowextsize inode."

So maybe just:

+_("Bad extent size %u for inode %" PRIu64 ", "),
+_("Bad CoW extent size %u on inode %" PRIu64 ", "),

? Unless you really want to keep track of "is it flagged?" and print a
different message based on flagged-or-not?

-Eric
