Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98821C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 01:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6941060EFE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 01:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhHRBZv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 21:25:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45812 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234120AbhHRBZv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Aug 2021 21:25:51 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E4E6186A443;
        Wed, 18 Aug 2021 11:25:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGAKR-001xEW-16; Wed, 18 Aug 2021 11:25:15 +1000
Date:   Wed, 18 Aug 2021 11:25:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <20210818012515.GO3657114@dread.disaster.area>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-4-david@fromorbit.com>
 <20210812002727.GV3601466@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812002727.GV3601466@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=wP7iaQ4VJwqcddS0s5kA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 11, 2021 at 05:27:27PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 10, 2021 at 03:24:38PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The attr2 feature is somewhat unique in that it has both a superblock
> > feature bit to enable it and mount options to enable and disable it.
> > 
> > Back when it was first introduced in 2005, attr2 was disabled unless
> > either the attr2 superblock feature bit was set, or the attr2 mount
> > option was set. If the superblock feature bit was not set but the
> > mount option was set, then when the first attr2 format inode fork
> > was created, it would set the superblock feature bit. This is as it
> > should be - the superblock feature bit indicated the presence of the
> > attr2 on disk format.
> > 
> > The noattr2 mount option, however, did not affect the superblock
> > feature bit. If noattr2 was specified, the on-disk superblock
> > feature bit was ignored and the code always just created attr1
> > format inode forks.  If neither of the attr2 or noattr2 mounts
> > option were specified, then the behaviour was determined by the
> > superblock feature bit.
> > 
> > This was all pretty sane.
> > 
> > Fast foward 3 years, and we are dealing with fallout from the
> > botched sb_features2 addition and having to deal with feature
> > mismatches between the sb_features2 and sb_bad_features2 fields. The
> > attr2 feature bit was one of these flags. The reconciliation was
> > done well after mount option parsing and, unfortunately, the feature
> > reconciliation had a bug where it ignored the noattr2 mount option.
> > 
> > For reasons lost to the mists of time, it was decided that resolving
> > this issue in commit 7c12f296500e ("[XFS] Fix up noattr2 so that it
> > will properly update the versionnum and features2 fields.") required
> > noattr2 to clear the superblock attr2 feature bit.  This greatly
> > complicated the attr2 behaviour and broke rules about feature bits
> > needing to be set when those specific features are present in the
> > filesystem.
> > 
> > By complicated, I mean that it introduced problems due to feature
> > bit interactions with log recovery. All of the superblock feature
> > bit checks are done prior to log recovery, but if we crash after
> > removing a feature bit, then on the next mount we see the feature
> > bit in the unrecovered superblock, only to have it go away after the
> > log has been replayed.  This means our mount time feature processing
> > could be all wrong.
> 
> Speaking of log recovery...
> 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 74349eab5b58..f2b3a7932f3b 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -773,6 +756,16 @@ xfs_mountfs(
> >  	if (error)
> >  		goto out_fail_wait;
> >  
> > +	/*
> > +	 * Now that we've recovered any pending superblock feature bit
> > +	 * additions, we can finish setting up the attr2 behaviour for the
> > +	 * mount. If no attr2 mount options were specified, the we use the
> > +	 * behaviour specified by the superblock feature bit.
> > +	 */
> > +	if (!(mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) &&
> > +	    xfs_sb_version_hasattr2(&mp->m_sb))
> > +		mp->m_flags |= XFS_MOUNT_ATTR2;
> 
> ...shouldn't this come /after/ the call to xfs_log_mount?

Hmmm - that smeels like a mis-merge on top of the inodegc
modifications.

/me goes and looks at v1

Yup, rebase dumped it before log recovery when the original v1 patch
had it correctly placed after the xfs_log_mount() call.

Good catch, fixed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
