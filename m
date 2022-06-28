Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7C0C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 23:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiF1XVw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 19:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiF1XVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 19:21:52 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 385913122B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 16:21:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4FC765ECDE9;
        Wed, 29 Jun 2022 09:21:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6KWj-00CFhx-6f; Wed, 29 Jun 2022 09:21:49 +1000
Date:   Wed, 29 Jun 2022 09:21:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_repair: don't flag log_incompat inconsistencies
 as corruptions
Message-ID: <20220628232149.GU227878@dread.disaster.area>
References: <165644943454.1091715.4250245702579572029.stgit@magnolia>
 <165644944566.1091715.13366185007838438636.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644944566.1091715.13366185007838438636.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62bb8d0e
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=J7ooh1Ka7AzZspc6tB4A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:50:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While testing xfs/233 and xfs/127 with LARP mode enabled, I noticed
> errors such as the following:
> 
> xfs_growfs --BlockSize=4096 --Blocks=8192
> data blocks changed from 8192 to 2579968
> meta-data=/dev/sdf               isize=512    agcount=630, agsize=4096 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1
> data     =                       bsize=4096   blocks=2579968, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=3075, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> _check_xfs_filesystem: filesystem on /dev/sdf is inconsistent (r)
> *** xfs_repair -n output ***
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
>         - 23:03:47: zeroing log - 3075 of 3075 blocks done
>         - scan filesystem freespace and inode maps...
> would fix log incompat feature mismatch in AG 30 super, 0x0 != 0x1
> would fix log incompat feature mismatch in AG 8 super, 0x0 != 0x1
> would fix log incompat feature mismatch in AG 12 super, 0x0 != 0x1
> would fix log incompat feature mismatch in AG 24 super, 0x0 != 0x1
> would fix log incompat feature mismatch in AG 18 super, 0x0 != 0x1
> <snip>
> 
> 0x1 corresponds to XFS_SB_FEAT_INCOMPAT_LOG_XATTRS, which is the feature
> bit used to indicate that the log contains extended attribute log intent
> items.  This is a mechanism to prevent older kernels from trying to
> recover log items that they won't know how to recover.
> 
> I thought about this a little bit more, and realized that log_incompat
> features bits are set on the primary sb prior to writing certain types
> of log records, and cleared once the log has written the committed
> changes back to the filesystem.  If the secondary superblocks are
> updated at any point during that interval (due to things like growfs or
> setting labels), the log_incompat field will now be set on the secondary
> supers.
> 
> Due to the ephemeral nature of the current log_incompat feature bits,
> a discrepancy between the primary and secondary supers is not a
> corruption.  If we're in dry run mode, we should log the discrepancy,
> but that's not a reason to end with EXIT_FAILURE.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/agheader.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/repair/agheader.c b/repair/agheader.c
> index e91509d0..76290158 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -285,15 +285,24 @@ check_v5_feature_mismatch(
>  		}
>  	}
>  
> +	/*
> +	 * Log incompat feature bits are set and cleared from the primary super
> +	 * as needed to protect against log replay on old kernels finding log
> +	 * records that they cannot handle.  Secondary sb resyncs performed as
> +	 * part of a geometry update to the primary sb (e.g. growfs, label/uuid
> +	 * changes) will copy the log incompat feature bits, but it's not a
> +	 * corruption for a secondary to have a bit set that is clear in the
> +	 * primary super.
> +	 */
>  	if (mp->m_sb.sb_features_log_incompat != sb->sb_features_log_incompat) {
>  		if (no_modify) {
> -			do_warn(
> -	_("would fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
> +			do_log(
> +	_("would sync log incompat feature in AG %u super, 0x%x != 0x%x\n"),
>  					agno, mp->m_sb.sb_features_log_incompat,
>  					sb->sb_features_log_incompat);
>  		} else {
>  			do_warn(
> -	_("will fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
> +	_("will sync log incompat feature in AG %u super, 0x%x != 0x%x\n"),
>  					agno, mp->m_sb.sb_features_log_incompat,
>  					sb->sb_features_log_incompat);
>  			dirty = true;

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
