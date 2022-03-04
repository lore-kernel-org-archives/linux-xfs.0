Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667B4C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 07:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbiCDHQh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Mar 2022 02:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238796AbiCDHQb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Mar 2022 02:16:31 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DB2F192E15
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 23:14:31 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1FC8510E24A2;
        Fri,  4 Mar 2022 18:14:28 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nQ28x-001Kd5-MO; Fri, 04 Mar 2022 18:14:27 +1100
Date:   Fri, 4 Mar 2022 18:14:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V7 12/17] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <20220304071427.GH59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-13-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-13-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6221bc56
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=GaA1DH8mTb5M3p1a5NAA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:33PM +0530, Chandan Babu R wrote:
> This commit introduces new fields in the on-disk inode format to support
> 64-bit data fork extent counters and 32-bit attribute fork extent
> counters. The new fields will be used only when an inode has
> XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
> data fork extent counters and 16-bit attribute fork extent counters.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h      | 33 ++++++++++++--
>  fs/xfs/libxfs/xfs_inode_buf.c   | 49 ++++++++++++++++++--
>  fs/xfs/libxfs/xfs_inode_fork.h  |  6 +++
>  fs/xfs/libxfs/xfs_log_format.h  | 33 ++++++++++++--
>  fs/xfs/xfs_inode_item.c         | 23 ++++++++--
>  fs/xfs/xfs_inode_item_recover.c | 79 ++++++++++++++++++++++++++++-----
>  6 files changed, 196 insertions(+), 27 deletions(-)

.....

> +static xfs_failaddr_t
> +xfs_dinode_verify_nrext64(
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	*dip)
> +{
> +	if (xfs_dinode_has_nrext64(dip)) {
> +		if (!xfs_has_nrext64(mp))
> +			return __this_address;
> +		if (dip->di_nrext64_pad != 0)
> +			return __this_address;
> +	} else if (dip->di_version >= 3) {
> +		if (dip->di_v3_pad != 0)
> +			return __this_address;
> +	}
> +
> +	return NULL;
> +}

Shouldn't this also check that di_v2_pad is zero if it's a v2 inode?

Also, this isn't verifying the actual extent count range. Maybe
that's done somewhere else now, and if so, shouldn't we move all the
extent count verification checks into a single function called,
say, xfs_dinode_verify_extent_counts()?

> @@ -348,21 +366,60 @@ xlog_recover_inode_commit_pass2(
>  			goto out_release;
>  		}
>  	}
> -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
> +
> +	if (xfs_log_dinode_has_nrext64(ldip)) {
> +		if (!xfs_has_nrext64(mp) || (ldip->di_nrext64_pad != 0)) {
> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",

Can we have a meaningful error like "Bad log dinode large extent
count format" rather than something we have to go look up the source
code to understand when someone reports a problem?

> +				     XFS_ERRLEVEL_LOW, mp, ldip,
> +				     sizeof(*ldip));
> +			xfs_alert(mp,
> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
> +				"ino %Ld, xfs_has_nrext64(mp) = %d, "
> +				"ldip->di_nrext64_pad = %u",

What's the point of printing pointers here? Just print the inode
number and the bad values - we log the pointers in the
the log recovery tracepoints so there's no need to print them in
user facing errors because we can't do anything with them without a
debugger attached.

Hence we really only need to dump the inode number and the bad extent
format information - we already have the error context/location from
the corruption error report above. Hence all we need here is:

			xfs_alert(mp,
				"Bad inode 0x%llx, nrext64 %d, padding 0x%x"
				in_f->ilf_ino, xfs_has_nrext64(mp).
				ldip->di_nrext64_pad);

The other new alerts can be cleaned up like this, too.

> +				__func__, item, dip, bp, in_f->ilf_ino,
> +				xfs_has_nrext64(mp), ldip->di_nrext64_pad);
> +			error = -EFSCORRUPTED;
> +			goto out_release;
> +		}
> +	} else {
> +		if (ldip->di_version == 3 && ldip->di_big_nextents != 0) {
> +			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
> +				     XFS_ERRLEVEL_LOW, mp, ldip,
> +				     sizeof(*ldip));
> +			xfs_alert(mp,
> +				"%s: Bad inode log record, rec ptr "PTR_FMT", "
> +				"dino ptr "PTR_FMT", dino bp "PTR_FMT", "
> +				"ino %Ld, ldip->di_big_dextcnt = %llu",
> +				__func__, item, dip, bp, in_f->ilf_ino,
> +				ldip->di_big_nextents);
> +			error = -EFSCORRUPTED;
> +			goto out_release;
> +		}
> +	}
> +
> +	if (xfs_log_dinode_has_nrext64(ldip)) {
> +		nextents = ldip->di_big_nextents;
> +		anextents = ldip->di_big_anextents;
> +	} else {
> +		nextents = ldip->di_nextents;
> +		anextents = ldip->di_anextents;
> +	}

Also, this can be put in the above if statements, it does not need
a separate identical if clause.
> +
> +	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
>  		xfs_alert(mp,
>  	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
> -	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
> +	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
>  			__func__, item, dip, bp, in_f->ilf_ino,
> -			ldip->di_nextents + ldip->di_anextents,
> -			ldip->di_nblocks);
> +			nextents + anextents, ldip->di_nblocks);
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}

ALso, I think that xlog_recover_inode_commit_pass2() is already too
big without adding this new verification to it. Can we factor this
into a separate function (say xlog_dinode_verify_extent_counts()) 


>  	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(8)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
>  		xfs_alert(mp,
> @@ -374,7 +431,7 @@ xlog_recover_inode_commit_pass2(
>  	}
>  	isize = xfs_log_dinode_size(mp);
>  	if (unlikely(item->ri_buf[1].i_len > isize)) {
> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
> +		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(9)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
>  		xfs_alert(mp,

And this is exactly why I don't like these numbered warnings. Make
the warning descriptive rather than numbered -
changing/adding/removing a warning shouldn't force us to change a
bunch of unrelated warninngs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
