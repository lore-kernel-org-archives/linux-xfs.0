Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24578C7EE2C
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 07:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjEYH6x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 03:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjEYH6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 03:58:52 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCA3183
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 00:58:50 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QRgPp3NQWzLmRF;
        Thu, 25 May 2023 15:57:18 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 25 May
 2023 15:58:47 +0800
Date:   Thu, 25 May 2023 15:57:13 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>, <guoxuenan@huawei.com>
Subject: Re: [PATCH v3] xfs: fix ag count overflow during growfs
Message-ID: <20230525075713.GA2894753@ceph-admin>
References: <20230524121041.GA4128075@ceph-admin>
 <20230524144800.GG11620@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230524144800.GG11620@frogsfrogsfrogs>
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 24, 2023 at 07:48:00AM -0700, Darrick J. Wong wrote:
> On Wed, May 24, 2023 at 08:10:41PM +0800, Long Li wrote:
> > I found a corruption during growfs:
> > 
> >  XFS (loop0): Internal error agbno >= mp->m_sb.sb_agblocks at line 3661 of
> >    file fs/xfs/libxfs/xfs_alloc.c.  Caller __xfs_free_extent+0x28e/0x3c0
> >  CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
> >  Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x50/0x70
> >   xfs_corruption_error+0x134/0x150
> >   __xfs_free_extent+0x2c1/0x3c0
> >   xfs_ag_extend_space+0x291/0x3e0
> >   xfs_growfs_data+0xd72/0xe90
> >   xfs_file_ioctl+0x5f9/0x14a0
> >   __x64_sys_ioctl+0x13e/0x1c0
> >   do_syscall_64+0x39/0x80
> >   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >  XFS (loop0): Corruption detected. Unmount and run xfs_repair
> >  XFS (loop0): Internal error xfs_trans_cancel at line 1097 of file
> >    fs/xfs/xfs_trans.c.  Caller xfs_growfs_data+0x691/0xe90
> >  CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
> >  Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x50/0x70
> >   xfs_error_report+0x93/0xc0
> >   xfs_trans_cancel+0x2c0/0x350
> >   xfs_growfs_data+0x691/0xe90
> >   xfs_file_ioctl+0x5f9/0x14a0
> >   __x64_sys_ioctl+0x13e/0x1c0
> >   do_syscall_64+0x39/0x80
> >   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >  RIP: 0033:0x7f2d86706577
> > 
> > The bug can be reproduced with the following sequence:
> > 
> >  # truncate -s  1073741824 xfs_test.img
> >  # mkfs.xfs -f -b size=1024 -d agcount=4 xfs_test.img
> >  # truncate -s 2305843009213693952  xfs_test.img
> >  # mount -o loop xfs_test.img /mnt/test
> >  # xfs_growfs -D  1125899907891200  /mnt/test
> > 
> > The root cause is that during growfs, user space passed in a large value
> > of newblcoks to xfs_growfs_data_private(), due to current sb_agblocks is
> > too small, new AG count will exceed UINT_MAX. Because of AG number type
> > is unsigned int and it would overflow, that caused nagcount much smaller
> > than the actual value. During AG extent space, delta blocks in
> > xfs_resizefs_init_new_ags() will much larger than the actual value due to
> > incorrect nagcount, even exceed UINT_MAX. This will cause corruption and
> > be detected in __xfs_free_extent. Fix it by growing the filesystem to up
> > to the maximally allowed AGs when new AG count overflow.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> > v3:
> > - Ensure that the performance is consisent before and after the modification
> >   when nagcount just overflows and 0 < nb_mod < XFS_MIN_AG_BLOCKS. 
> > - Based on Darrick's advice, growing the filesystem to up to the maximally
> >   allowed AGs when new AG count overflow.
> > 
> >  fs/xfs/libxfs/xfs_fs.h |  3 +++
> >  fs/xfs/xfs_fsops.c     | 13 +++++++++----
> >  2 files changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 1cfd5bc6520a..36ec2b1f7e68 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -248,6 +248,9 @@ typedef struct xfs_fsop_resblks {
> >  #define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
> >  #define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
> >  
> > +/* Maximum number of AGs */
> > +#define XFS_AGNUMBER_MAX	((xfs_agnumber_t)(-1U))
> 
> My apologies, I led you astray.  This should be:
> 
> #define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
> 
OK, it is undoubtedly better to follow the definition in xfsprogs, which will
be modified in the next version.

> since it already exists in multidisk.h from xfsprogs.
> xfs_validate_sb_common probably ought to validate that
> sb_agcount <= XFS_MAX_AGNUMBER as well.
> 
In my understanding the range of sb_agcount should be [1, 0xFFFFFFFF], it
should validate that sb_agcount <= (XFS_MAX_AGNUMBER + 1) , so it's not necessary
to check the upper limit of the sb_agcount.

> > +
> >  /*
> >   * Limits on sb_agblocks/sb_agblklog -- mkfs won't format AGs smaller than
> >   * 16MB or larger than 1TB.
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 13851c0d640b..2b37d3e61bdf 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -115,11 +115,16 @@ xfs_growfs_data_private(
> >  
> >  	nb_div = nb;
> >  	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> > -	nagcount = nb_div + (nb_mod != 0);
> > -	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> > -		nagcount--;
> > -		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > +	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
> > +		nb_div++;
> > +	else if (nb_mod)
> > +		nb = nb_div * mp->m_sb.sb_agblocks;
> > +
> > +	if (nb_div > XFS_AGNUMBER_MAX) {
> > +		nb_div = XFS_AGNUMBER_MAX;
> > +		nb = nb_div * mp->m_sb.sb_agblocks;
> >  	}
> > +	nagcount = nb_div;
> >  	delta = nb - mp->m_sb.sb_dblocks;
> >  	/*
> >  	 * Reject filesystems with a single AG because they are not
> > -- 
> > 2.31.1
> > 
