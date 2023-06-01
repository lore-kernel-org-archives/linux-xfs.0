Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84510C77B7E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 08:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjFAIAG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 04:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjFAH7m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 03:59:42 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B041BC6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 00:57:40 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QWz4w42VGz4f3l8F
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 15:57:36 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgAHvbBwT3hk1Di5Kg--.4761S3;
        Thu, 01 Jun 2023 15:57:37 +0800 (CST)
Date:   Thu, 1 Jun 2023 15:55:53 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v3] xfs: fix ag count overflow during growfs
Message-ID: <20230601075553.GB3861632@ceph-admin>
References: <20230524121041.GA4128075@ceph-admin>
 <20230524144800.GG11620@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230524144800.GG11620@frogsfrogsfrogs>
X-CM-TRANSID: gCh0CgAHvbBwT3hk1Di5Kg--.4761S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr1fCFW7JFW8JryUGFW5trb_yoW7XrWxpF
        93Ka1jkr1DGw1aya92vw10qFn8Aw4SyF1xCrykJr17J3W5tryxXFyqyr1Y9as7CrWUZr1F
        9F45uF9rZan5AaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUglb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1j6r18M7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
        Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
        AY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
        cVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJw
        CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVF
        xhVjvjDU0xZFpf9x07UE9a9UUUUU=
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, Darrick

I realized there may be a problem with my email so you may not receive my
previous reply. So I'm replying to you with another email address, and if
you received my previous reply, you can ignore this email. Thank you very much!

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

OK, it is undoubtedly better to follow the definition in xfsprogs, which will
be modified in the next version.

> 
> since it already exists in multidisk.h from xfsprogs.
> xfs_validate_sb_common probably ought to validate that
> sb_agcount <= XFS_MAX_AGNUMBER as well.

In my understanding the range of sb_agcount should be [1, 0xFFFFFFFF], it
should validate that sb_agcount <= (XFS_MAX_AGNUMBER + 1) , so it's not necessary
to check the upper limit of the sb_agcount.

Thanks,
Long Li

> 
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

