Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B32C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 23:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiF1XUW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 19:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiF1XUS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 19:20:18 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 756BC2FE74
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 16:20:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 968075ECDA7;
        Wed, 29 Jun 2022 09:20:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6KVD-00CFh6-8Q; Wed, 29 Jun 2022 09:20:15 +1000
Date:   Wed, 29 Jun 2022 09:20:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_repair: always rewrite secondary supers when
 needsrepair is set
Message-ID: <20220628232015.GT227878@dread.disaster.area>
References: <165644943454.1091715.4250245702579572029.stgit@magnolia>
 <165644944011.1091715.17634098731085183377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644944011.1091715.17634098731085183377.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62bb8cb0
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=20KFwNOVAAAA:8 a=lBQhdA5cqTFVXKMa4asA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:50:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Dave Chinner complained about xfs_scrub failures coming from xfs/158.
> That test induces xfs_repair to fail while upgrading a filesystem to
> have the inobtcount feature, and then restarts xfs_repair to finish the
> upgrade.  When the second xfs_repair run starts, it will find that the
> primary super has NEEDSREPAIR set, along with whatever new feature that
> we were trying to add to the filesystem.
> 
> From there, repair completes the upgrade in much the same manner as the
> first repair run would have, with one big exception -- it forgets to set
> features_changed to trigger rewriting of the secondary supers at the end
> of repair.  This results in discrepancies between the supers:
> 
> # XFS_REPAIR_FAIL_AFTER_PHASE=2 xfs_repair -c inobtcount=1 /dev/sdf
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Adding inode btree counts to filesystem.
> Killed
> # xfs_repair /dev/sdf
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> clearing needsrepair flag and regenerating metadata
> bad inobt block count 0, saw 1
> bad finobt block count 0, saw 1
> bad inobt block count 0, saw 1
> bad finobt block count 0, saw 1
> bad inobt block count 0, saw 1
> bad finobt block count 0, saw 1
> bad inobt block count 0, saw 1
> bad finobt block count 0, saw 1
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 1
>         - agno = 2
>         - agno = 0
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> # xfs_db -c 'sb 0' -c 'print' -c 'sb 1' -c 'print' /dev/sdf | \
> 	egrep '(features_ro_compat|features_incompat)'
> features_ro_compat = 0xd
> features_incompat = 0xb
> features_ro_compat = 0x5
> features_incompat = 0xb
> 
> Curiously, re-running xfs_repair will not trigger any warnings about the
> featureset mismatch between the primary and secondary supers.  xfs_scrub
> immediately notices, which is what causes xfs/158 to fail.
> 
> This discrepancy doesn't happen when the upgrade completes successfully
> in a single repair run, so we need to teach repair to rewrite the
> secondaries at the end of repair any time needsrepair was set.
> 
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/agheader.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 36da1395..e91509d0 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -552,6 +552,14 @@ secondary_sb_whack(
>  			else
>  				do_warn(
>  	_("would clear needsrepair flag and regenerate metadata\n"));
> +			/*
> +			 * If needsrepair is set on the primary super, there's
> +			 * a possibility that repair crashed during an upgrade.
> +			 * Set features_changed to ensure that the secondary
> +			 * supers are rewritten with the new feature bits once
> +			 * we've finished the upgrade.
> +			 */
> +			features_changed = true;
>  		} else {
>  			/*
>  			 * Quietly clear needsrepair on the secondary supers as
> 
> 

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
