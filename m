Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372E1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 21:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiD0V4e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 17:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiD0V4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 17:56:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2B54F445
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 14:53:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB9A8B82ADA
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 21:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9086BC385AF;
        Wed, 27 Apr 2022 21:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651096396;
        bh=QWcyH4f76w+kBjRsxrdzQqXWlSvbsGi0RGl/llFW/50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sQOLiRuAZ3j6yYg93wGP5lW9of168emkat3v7b8a61BC3ZOyhST3fXJSkzG2TE8oV
         HTHCQAYVEf3/rzv5gvMqt354aK+L7MBFdF7oBeKHo2bZ9VN7v3rl6WsBgRnWZvw4GJ
         2xKsR9pH6LCiCXBMHeoGXssvtVgxQOhyw7KiCEiHPMNY+JpCb2jcPbD63CTC48Bxx1
         o6jgu3/ZPEWZyVZbpW8syVbYe891c4f9XKQme+o9HC4qjLXGEpXRdT3vpuep8OXuIV
         6fWw9PmPQ8lvN68KPIMuXw1yDXoeGYeBZP3OPRFUcePz6oBD/ctkXS6LsgXumkknq3
         F6jKxURnLsoXA==
Date:   Wed, 27 Apr 2022 14:53:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next tree updated to a44a027a8b2a
Message-ID: <20220427215316.GM17025@magnolia>
References: <20220425231714.GK1544202@dread.disaster.area>
 <20220427183222.GJ17025@magnolia>
 <20220427212538.GP1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427212538.GP1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 28, 2022 at 07:25:38AM +1000, Dave Chinner wrote:
> On Wed, Apr 27, 2022 at 11:32:22AM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 26, 2022 at 09:17:14AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > I just pushed out a new for-next branch for the XFS tree. It
> > > contains:
> > > 
> > > - pending fixes for 5.18
> > > - various miscellaneous fixes
> > > - xlog_write() rework
> > > - conversions to unsigned for trace_printk flags
> > > - large on-disk extent counts
> > > 
> > > This all passes my local regression testing, though further smoke
> > > testing in different environments would be appreaciated.
> > > 
> > > I haven't pulled in fixes from late last week yet - I'll work
> > > through those in the next couple of days to get them into the tree
> > > as well.
> > > 
> > > If I've missed anything you were expecting to see in this update,
> > > let me know and I'll get them sorted for the next update.
> > 
> > Hmm.  I saw the following crash on an arm64 VM with 64k page size and an
> > 8k blocksize:
> 
> Ok, that's a whacky config I can't directly test here. 

Heh. :/

> > run fstests xfs/502 at 2022-04-26 20:54:15
> > spectre-v4 mitigation disabled by command-line option
> > XFS (sda2): Mounting V5 Filesystem
> > XFS (sda2): Ending clean mount
> > XFS (sda3): Mounting V5 Filesystem
> > XFS (sda3): Ending clean mount
> > XFS (sda3): Quotacheck needed: Please wait.
> > XFS (sda3): Quotacheck: Done.
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> > XFS: Assertion failed: IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)), file: fs/xfs/xfs_log_cil.c, line: 431
> 
> Huh. That implies that memory allocation for the shadow buffer
> wasn't 8 byte aligned because:
> 
>                         lv->lv_buf = (char *)lv +
> 					xlog_cil_iovec_space(lv->lv_niovecs);
> 
> And:
> 
> static inline int
> xlog_cil_iovec_space(
>         uint    niovecs)
> {
>         return round_up((sizeof(struct xfs_log_vec) +
>                                         niovecs * sizeof(struct xfs_log_iovec)),
>                         sizeof(uint64_t));
> }
> 
> So the length returned by xlog_cil_iovec_space() is always a
> multiple of 8 bytes. Hence the only way lv->lv_buf would not be
> aligned to 8 bytes is if the original allocation was not aligned.
> 
> That buffer comes from:
> 
> static inline void *
> xlog_cil_kvmalloc(
>         size_t          buf_size)
> {
>         gfp_t           flags = GFP_KERNEL;
>         void            *p;
> 
>         flags &= ~__GFP_DIRECT_RECLAIM;
>         flags |= __GFP_NOWARN | __GFP_NORETRY;
>         do {
>                 p = kmalloc(buf_size, flags);
>                 if (!p)
>                         p = vmalloc(buf_size);
>         } while (!p);
> 
>         return p;
> }
> 
> vmalloc() guarantees alignment of the returned buffer, so this must
> have come from a heap allocation via kmalloc() and that must have
> returned something that is not 8 byte aligned...
> 
> Oh, after the XFS assert, a second oops happened, this time in
> kmalloc():
> 
> > Unable to handle kernel paging request at virtual address 9ac7c01eb06874e8
> > Mem abort info:
> >   ESR = 0x96000004
> >   EC = 0x25: DABT (current EL), IL = 32 bits
> >   SET = 0, FnV = 0
> >   EA = 0, S1PTW = 0
> >   FSC = 0x04: level 0 translation fault
> > Data abort info:
> >   ISV = 0, ISS = 0x00000004
> >   CM = 0, WnR = 0
> > [9ac7c01eb06874e8] address between user and kernel address ranges
> > Internal error: Oops: 96000004 [#1] PREEMPT SMP
> > Dumping ftrace buffer:
> >    (ftrace buffer empty)
> > Modules linked in: xfs dm_delay dm_zero dm_flakey dm_snapshot dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c xt_REDIRECT iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 rputh_rpcgss xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip6table_filter ip6_tables bfq iptable_filter crct10dif_ce sch_fq_codel efivarfs ip_tables x_tables overlay nfsv4 [last unloaded: xfs]
> > CPU: 1 PID: 3168300 Comm: t_open_tmpfiles Tainted: G        W         5.17.0-xfsa #5.17.0 0288cc936a4dc1878aaf6a4c6fa6235f949bf1e9
> > Hardware name: QEMU KVM Virtual Machine, BIOS 1.5.1 06/16/2021
> > pstate: a0401005 (NzCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
> > pc : __kmalloc+0x120/0x3f0
> > lr : __kmalloc+0xe8/0x3f0
> > sp : fffffe00213ef840
> > x29: fffffe00213ef840 x28: 0000000000000002 x27: fffffe0008fe6000
> > x26: fffffc00e8740000 x25: fffffe00090e9000 x24: fffffe0001523c44
> > x23: 0000000000000150 x22: 00000000000128c0 x21: 0000000000000000
> > x20: 9ac7c01eb06874e8 x19: fffffc00e0010400 x18: 0000000000000000
> > x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> > x14: 0000000000000000 x13: 0000f0ffffffffff x12: 0000000000000040
> > x11: fffffc0133b5c678 x10: fffffc0133b5c67a x9 : fffffe0008294814
> > x8 : 0000000000000001 x7 : fffffe01f68d0000 x6 : 8d4857517c5941da
> > x5 : 00000000019ff6ec x4 : 0000000000000100 x3 : 0000000000000000
> > x2 : e87468b01ec0c79a x1 : 0000000003a724a9 x0 : 9ac7c01eb06873e8
> > Call trace:
> >  __kmalloc+0x120/0x3f0
> >  xlog_cil_commit+0x144/0x9b0 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]
> 
> This smells like heap corruption has occurred and the CIL commit
> code was the unfortunate victim that tripped over it first. That
> would explain the unaligned object being returned from kmalloc().
> 
> Did you have any memory debugging options turned on?

Nope.  I'll run them again tonight with KASAN enabled and see if that
shakes anything out.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
