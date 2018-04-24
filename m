Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:39617 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752135AbeDXIES (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Apr 2018 04:04:18 -0400
Received: by mail-wr0-f196.google.com with SMTP id q3-v6so38013571wrj.6
        for <linux-xfs@vger.kernel.org>; Tue, 24 Apr 2018 01:04:18 -0700 (PDT)
Date: Tue, 24 Apr 2018 10:04:14 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: generic/388 panic
Message-ID: <20180424080414.ciiotbnhycjbmdn3@odin.usersys.redhat.com>
References: <20180423123602.cuibxc5mo2t6pldt@odin.usersys.redhat.com>
 <20180423200353.GD26268@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423200353.GD26268@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 01:03:53PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 23, 2018 at 02:36:02PM +0200, Carlos Maiolino wrote:
> > Hi.
> > 
> > Past week Darrick mentioned to me a problem he has been seen with generic/388
> > hanging on XFS filesystems with quotas enabled.
> > 
> > I couldn't hit something hanging until now, but I'm sporadically seeing some
> > kernel panics after running generic/388 in a loop:
> > 
> > [ 5913.170041] Kernel panic - not syncing: xfs_bmap_check_leaf_extents: CORRUPTED BTREE OR SOMETHING
> 
> Yep, that's one of the things I'm seeing.  It seems easier to make it
> reproduce if you turn on rmap and reflink too....

K, I'll try it and see wth is going on, thanks for confirming.

Cheers

> 
> --D
> 
> > [ 5913.176441] CPU: 2 PID: 24611 Comm: fsstress Kdump: loaded Not tainted 4.17.0-rc1t450s #94
> > [ 5913.178443] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
> > [ 5913.184533] Call Trace:
> > [ 5913.185400]  dump_stack+0x5c/0x7b
> > [ 5913.190164]  panic+0xe4/0x252
> > [ 5913.190644]  xfs_bmap_check_leaf_extents+0x323/0x5c0
> > [ 5913.191365]  xfs_bmap_add_extent_hole_real+0x7b0/0xa60
> > [ 5913.192106]  xfs_bmapi_write+0xb2e/0x12e0
> > [ 5913.192716]  xfs_qm_dqalloc+0x176/0x350
> > [ 5913.193292]  ? xfs_bmapi_read+0x1e0/0x3e0
> > [ 5913.193919]  xfs_qm_dqtobp+0x1e0/0x410
> > [ 5913.195406]  xfs_qm_dqread+0x19b/0x420
> > [ 5913.196028]  xfs_qm_dqget+0x417/0x7b0
> > [ 5913.196610]  xfs_qm_vop_dqalloc+0x156/0x5b0
> > [ 5913.198640]  xfs_setattr_nonsize+0x2fd/0x6d0
> > [ 5913.202750]  notify_change+0x303/0x420
> > [ 5913.206278]  chown_common.isra.17+0xec/0x1a0
> > [ 5913.207945]  do_fchownat+0xd3/0xf0
> > [ 5913.208633]  __x64_sys_lchown+0x21/0x30
> > [ 5913.210993]  do_syscall_64+0x5b/0x180
> > [ 5913.213991]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [ 5913.215453] RIP: 0033:0x7fa4ff459397
> > [ 5913.215958] RSP: 002b:00007fff311d65e8 EFLAGS: 00000206 ORIG_RAX: 000000000000005e
> > [ 5913.225089] RAX: ffffffffffffffda RBX: 000000000009db9c RCX: 00007fa4ff459397
> > [ 5913.234352] RDX: 000000000009db9c RSI: 0000000000099ef5 RDI: 000000000116b170
> > [ 5913.244177] RBP: 00007fff311d6740 R08: 0000000000000010 R09: 00007fff311d673c
> > [ 5913.247929] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000099ef5
> > [ 5913.249091] R13: 000000000009db9c R14: 0000000000000000 R15: 0000000000000000
> > 
> > 
> > Darrick, is this something similar with what you have mentioned? Or is this
> > something different?
> > 
> > Cheers
> > 
> > -- 
> > Carlos
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
