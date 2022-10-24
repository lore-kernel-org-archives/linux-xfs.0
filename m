Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F66FA373D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJXEHp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJXEHo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:07:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED535808A
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E30760BC2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 04:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAE3C433D6;
        Mon, 24 Oct 2022 04:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666584462;
        bh=X+ePf1bkNiQO2P7j2zBqJ2e8PoqlYMIf65m8xeDHHBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mo3g56Amyfe5GuEMsuOiXP/jVjQfSiuRsFepo869h3bJPq6dPNxA8blw9+RSmNHCl
         Q+t5cp5ERta0TfMG8JPBVgJZxwI7ak87OL1erSgTl64G7gMotazntOYihzUsz29NDy
         tIKQrvptrAFeRw9NGGGUYSSWwEBuHRzo2hFOB3qGzKsrqtlrMdkYKLaynGSDg7QZMY
         88QMI2+biB1BD4E4S7iyirDyMy/jCag23QG5ROx3Tc7LLyBtRbNeQblPscLzwaRLQ4
         gkuSjV4BpNle1CM4FCrIUMCgp7m+3qUmJr+H+rnBUoNKMNFY4lhh7HhTHO2/4KoKhS
         DTe4dE6AN5pbA==
Date:   Sun, 23 Oct 2022 21:07:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Long Li <leo.lilong@huawei.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v1] xfs: fix sb write verify for lazysbcount
Message-ID: <Y1YPjkiiN3FyMBfG@magnolia>
References: <20221022020345.GA2699923@ceph-admin>
 <Y1NSBMwgUYxhW4PE@magnolia>
 <20221022120125.GA2052581@ceph-admin>
 <20221022211613.GW3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221022211613.GW3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 23, 2022 at 08:16:13AM +1100, Dave Chinner wrote:
> On Sat, Oct 22, 2022 at 08:01:25PM +0800, Long Li wrote:
> > On Fri, Oct 21, 2022 at 07:14:28PM -0700, Darrick J. Wong wrote:
> > > On Sat, Oct 22, 2022 at 10:03:45AM +0800, Long Li wrote:
> > > > When lazysbcount is enabled, multiple threads stress test the xfs report
> > > > the following problems:
> 
> We've had lazy sb counters for 15 years and just about every XFS
> filesystem in production uses them, so providing us with some idea
> of the scope of the problem and how to reproduce it would be greatly
> appreciated.
> 
> What stress test are you running? What filesystem config does it
> manifest on (other than lazysbcount=1)?  How long does the stress
> test run for, and where/why does log recovery get run in this stress
> test?
> 
> > > > XFS (loop0): SB summary counter sanity check failed
> > > > XFS (loop0): Metadata corruption detected at xfs_sb_write_verify
> > > > 	     +0x13b/0x460, xfs_sb block 0x0
> > > > XFS (loop0): Unmount and run xfs_repair
> > > > XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > > > 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 28 00 00  XFSB.........(..
> > > > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > > 00000020: 69 fb 7c cd 5f dc 44 af 85 74 e0 cc d4 e3 34 5a  i.|._.D..t....4Z
> > > > 00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
> > > > 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> > > > 00000050: 00 00 00 01 00 0a 00 00 00 00 00 04 00 00 00 00  ................
> > > > 00000060: 00 00 0a 00 b4 b5 02 00 02 00 00 08 00 00 00 00  ................
> > > > 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
> > > > XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply
> > > > 	+0xe1e/0x10e0 (fs/xfs/xfs_buf.c:1580).  Shutting down filesystem.
> > > > XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> > > > XFS (loop0): log mount/recovery failed: error -117
> > > > XFS (loop0): log mount failed
> > > > 
> > > > The cause of the problem is that during the log recovery process, incorrect
> > > > icount and ifree are recovered from the log and fail to pass the size check
> > > 
> > > Are you saying that the log contained a transaction in which ifree >
> > > icount?
> > 
> > Yes, this situation is possible. For example consider the following sequence:
> > 
> >  CPU0				    CPU1
> >  xfs_log_sb			    xfs_trans_unreserve_and_mod_sb
> >  ----------			    ------------------------------
> >  percpu_counter_sum(&mp->m_icount)
> > 				    percpu_counter_add(&mp->m_icount, idelta)
> > 				    percpu_counter_add_batch(&mp->m_icount,
> > 						  idelta, XFS_ICOUNT_BATCH)
> >  percpu_counter_sum(&mp->m_ifree)
> 
> What caused the xfs_log_sb() to be called? Very few things
> actually log the superblock this way at runtime - it's generally
> only logged directly like this when a feature bit changes during a
> transaction (rare) or at a synchronisation point when everything
> else is idle and there's no chance of a race like this occurring...
> 
> I can see a couple of routes to this occurring via feature bit
> modification, but I don't see them being easy to hit or something
> that would exist for very long in the journal. Hence I'm wondering
> if there should be runtime protection for xfs_log_sb() to avoid
> these problems....

Maybe.  Or perhaps we sample m_i{count,free} until they come up with a
value that will pass the verifier, and only then log the new values to
the primary super xfs_buf?

> > > > in xfs_validate_sb_write().
> > > > 
> > > > With lazysbcount is enabled, There is no additional lock protection for
> > > > reading m_ifree and m_icount in xfs_log_sb(), if other threads modifies
> > > > the m_ifree between the read m_icount and the m_ifree, this will make the
> > > > m_ifree larger than m_icount and written to the log. If we have an unclean
> > > > shutdown, this will be corrected by xfs_initialize_perag_data() rebuilding
> > > > the counters from the AGF block counts, and the correction is later than
> > > > log recovery. During log recovery, incorrect ifree/icount may be restored
> > > > from the log and written to the super block, since ifree and icount have
> > > > not been corrected at this time, the relationship between ifree and icount
> > > > cannot be checked in xfs_validate_sb_write().
> > > > 
> > > > So, don't check the size between ifree and icount in xfs_validate_sb_write()
> > > > when lazysbcount is enabled.
> > > 
> > > Um, doesn't that neuter a sanity check on all V5 filesystems?
> >
> > Yes, such modifications don't look like the best way, all sb write checks 
> > will be affect. Maybe it can increase the judgment of clean mount and reduce
> > the scope of influence, but this requires setting the XFS_OPSTATE_CLEAN after
> > re-initialise incore superblock counters, like this:
> 
> I'm not sure that silencing the warning and continuing log recovery
> with an invalid accounting state is the best way to proceed. We
> haven't yet recovered unlinked inodes at the time this warning
> fires. If ifree really is larger than icount, then we've got a
> real problem at this point in log recovery.
> 
> Hence I suspect that we should be looking at fixing the runtime race
> condition that leads to the problem, not trying to work around
> inconsistency in the recovery code.

Agreed.  Higher level code shouldn't be storing garbage ifree/icount to
the primary superblock xfs_buf, period.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
