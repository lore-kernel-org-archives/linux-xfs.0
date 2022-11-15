Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564BBC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 14:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKOOMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 09:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiKOOM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 09:12:27 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEDA2BB25
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 06:12:14 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBSm66nnrzmW0x;
        Tue, 15 Nov 2022 22:11:50 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 15 Nov
 2022 22:12:11 +0800
Date:   Tue, 15 Nov 2022 22:33:38 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     <djwong@kernel.org>, <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <guoxuenan@huawei.com>, <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <20221115143338.GB1723222@ceph-admin>
References: <20221107143648.GA2013250@ceph-admin>
 <20221111205250.GO3600936@dread.disaster.area>
 <20221114133417.GA1723222@ceph-admin>
 <20221115002313.GS3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221115002313.GS3600936@dread.disaster.area>
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2022 at 11:23:13AM +1100, Dave Chinner wrote:
> On Mon, Nov 14, 2022 at 09:34:17PM +0800, Long Li wrote:
> > On Sat, Nov 12, 2022 at 07:52:50AM +1100, Dave Chinner wrote:
> > > On Mon, Nov 07, 2022 at 10:36:48PM +0800, Long Li wrote:
> > > > The following error occurred during the fsstress test:
> > > > 
> > > > XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2925
> > > > 
> > > > The problem was that inode race condition causes incorrect i_nlink to be
> > > > written to disk, and then it is read into memory. Consider the following
> > > > call graph, inodes that are marked as both XFS_IFLUSHING and
> > > > XFS_IRECLAIMABLE, i_nlink will be reset to 1 and then restored to original
> > > > value in xfs_reinit_inode(). Therefore, the i_nlink of directory on disk
> > > > may be set to 1.
> > > > 
> > > >   xfsaild
> > > >       xfs_inode_item_push
> > > >           xfs_iflush_cluster
> > > >               xfs_iflush
> > > >                   xfs_inode_to_disk
> > > > 
> > > >   xfs_iget
> > > >       xfs_iget_cache_hit
> > > >           xfs_iget_recycle
> > > >               xfs_reinit_inode
> > > >   	          inode_init_always
> > > > 
> > > > So skip inodes that being flushed and markded as XFS_IRECLAIMABLE, prevent
> > > > concurrent read and write to inodes.
> > > 
> > > urk.
> > > 
> > > xfs_reinit_inode() needs to hold the ILOCK_EXCL as it is changing
> > > internal inode state and can race with other RCU protected inode
> > > lookups. Have a look at what xfs_iflush_cluster() does - it
> > > grabs the ILOCK_SHARED while under rcu + ip->i_flags_lock, and so
> > > xfs_iflush/xfs_inode_to_disk() are protected from racing inode
> > > updates (during transactions) by that lock.
> > > 
> > > Hence it looks to me that I_FLUSHING isn't the problem here - it's
> > > that we have a transient modified inode state in xfs_reinit_inode()
> > > that is externally visisble...
> > 
> > Before xfs_reinit_inode(), XFS_IRECLAIM will be set in ip->i_flags, this 
> > looks like can prevent race with other RCU protected inode lookups.  
> 
> That only protects against new lookups - it does not protect against the
> IRECLAIM flag being set *after* the lookup in xfs_iflush_cluster()
> whilst the inode is being flushed to the cluster buffer. That's why
> xfs_iflush_cluster() does:
> 
> 	rcu_read_lock()
> 	lookup inode
> 	spinlock(ip->i_flags_lock);
> 	check IRECLAIM|IFLUSHING
> >>>>>>	xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)     <<<<<<<<
> 	set IFLUSHING
> 	spin_unlock(ip->i_flags_lock)
> 	rcu_read_unlock()
> 
> At this point, the only lock that is held is XFS_ILOCK_SHARED, and
> it's the only lock that protects the inode state outside the lookup
> scope against concurrent changes.
> 
> Essentially, xfs_reinit_inode() needs to add a:
> 
> 	xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)
> 
> before it set IRECLAIM - if it fails to get the ILOCK_EXCL, then we
> need to skip the inode, drop out of RCU scope, delay and retry the
> lookup.
> 
> > Can it be considered that don't modifying the information about the on-disk
> > values in the VFS inode in xfs_reinit_inode()? if so lock can be avoided.
> 
> We have to reinit the VFS inode because it has gone through
> ->destroy_inode and so the state has been trashed. We have to bring
> it back as an I_NEW inode, which requires reinitialising everything.
> THe issue is that we store inode state information (like nlink) in
> the VFS inode instead of the XFS inode portion of the structure (to
> minimise memory footprint), and that means xfs_reinit_inode() has a
> transient state where the VFS inode is not correct. We can avoid
> that simply by holding the XFS_ILOCK_EXCL, guaranteeing nothing in
> XFS should be trying to read/modify the internal metadata state
> while we are reinitialising the VFS inode portion of the
> structure...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Thanks for the detailed and clear explanation, holding ILOCK_EXCL lock
in xfs_reinit_inode() can solve the problem simply, I will resend a 
patch. :)

Thanks,
Long Li
