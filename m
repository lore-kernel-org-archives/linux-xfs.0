Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0038DC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Nov 2022 13:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbiKNNNL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 08:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbiKNNMw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 08:12:52 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65392B1B9
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 05:12:51 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N9qQ81tfxzqSMk;
        Mon, 14 Nov 2022 21:09:04 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 14 Nov
 2022 21:12:49 +0800
Date:   Mon, 14 Nov 2022 21:34:17 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     <djwong@kernel.org>, <houtao1@huawei.com>, <yi.zhang@huawei.com>,
        <guoxuenan@huawei.com>, <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <20221114133417.GA1723222@ceph-admin>
References: <20221107143648.GA2013250@ceph-admin>
 <20221111205250.GO3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221111205250.GO3600936@dread.disaster.area>
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 12, 2022 at 07:52:50AM +1100, Dave Chinner wrote:
> On Mon, Nov 07, 2022 at 10:36:48PM +0800, Long Li wrote:
> > The following error occurred during the fsstress test:
> > 
> > XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2925
> > 
> > The problem was that inode race condition causes incorrect i_nlink to be
> > written to disk, and then it is read into memory. Consider the following
> > call graph, inodes that are marked as both XFS_IFLUSHING and
> > XFS_IRECLAIMABLE, i_nlink will be reset to 1 and then restored to original
> > value in xfs_reinit_inode(). Therefore, the i_nlink of directory on disk
> > may be set to 1.
> > 
> >   xfsaild
> >       xfs_inode_item_push
> >           xfs_iflush_cluster
> >               xfs_iflush
> >                   xfs_inode_to_disk
> > 
> >   xfs_iget
> >       xfs_iget_cache_hit
> >           xfs_iget_recycle
> >               xfs_reinit_inode
> >   	          inode_init_always
> > 
> > So skip inodes that being flushed and markded as XFS_IRECLAIMABLE, prevent
> > concurrent read and write to inodes.
> 
> urk.
> 
> xfs_reinit_inode() needs to hold the ILOCK_EXCL as it is changing
> internal inode state and can race with other RCU protected inode
> lookups. Have a look at what xfs_iflush_cluster() does - it
> grabs the ILOCK_SHARED while under rcu + ip->i_flags_lock, and so
> xfs_iflush/xfs_inode_to_disk() are protected from racing inode
> updates (during transactions) by that lock.
> 
> Hence it looks to me that I_FLUSHING isn't the problem here - it's
> that we have a transient modified inode state in xfs_reinit_inode()
> that is externally visisble...

Before xfs_reinit_inode(), XFS_IRECLAIM will be set in ip->i_flags, this 
looks like can prevent race with other RCU protected inode lookups.  
Can it be considered that don't modifying the information about the on-disk
values in the VFS inode in xfs_reinit_inode()? if so lock can be avoided.

Thanks,
Long Li

