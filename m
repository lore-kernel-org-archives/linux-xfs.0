Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752607AbdCHNTj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 08:19:39 -0500
Date: Wed, 8 Mar 2017 08:17:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: 4.11.0-rc1 boot resulted in WARNING: CPU: 14 PID: 1722 at
 fs/sysfs/dir.c:31 .sysfs_warn_dup+0x78/0xb0
Message-ID: <20170308131705.GB23404@bfoster.bfoster>
References: <1488904264.3961.17.camel@abdul-ThinkPad-T450>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488904264.3961.17.camel@abdul-ThinkPad-T450>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, mpe@ellerman.id, linux-kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Tue, Mar 07, 2017 at 10:01:04PM +0530, Abdul Haleem wrote:
> 
> Hi,
> 
> Today's mainline (4.11.0-rc1) booted with warnings on Power7 LPAR.
> 
> Issue is not reproducible all the time.
> 
> traces:
> --------
> Found device VDASD 5.
> Mounting /home...
> Reached target Swap.
> Found device VDASD 2.
> 
> Mounting /boot...
> 
> sysfs: cannot create duplicate filename '/fs/xfs/sda'

That is strange. The sysfs name is ultimately based on the superblock id
(sb->s_id), which afaik should reflect the underlying device and thus be
unique. Just to be sure, do you otherwise have a mounted and functional
sysfs dir?

I assume after this boot you have a mounted 'sda' device somewhere.. If
so, what content already exists under the sysfs fs/xfs/sda subdir when
the duplicate warning occurs? Has the associated device been
mounted/unmounted before this occurs, or is there anything abnormal
going on during boot up, such as device repartitioning, devices coming
and going, etc..?

What does 'mount' show for this system when the problem occurs vs. when
it doesn't? It might be useful to post the full boot log for when this
occurs as well.

Brian

> ------------[ cut here ]------------
> WARNING: CPU: 14 PID: 1722 at fs/sysfs/dir.c:31 .sysfs_warn_dup
> +0x78/0xb0
> Modules linked in: sg(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E)
> grace(E) sunrpc(E) binfmt_misc(E) ip_tables(E) ext4(E) mbcache(E)
> jbd2(E) sd_mod(E) ibmvscsi(E) ibmveth(E) scsi_transport_srp(E)
> CPU: 14 PID: 1722 Comm: mount Tainted: G        W   E   4.11.0-rc1-autotest #1
> task: c0000009ed3f9c80 task.stack: c0000009ed430000
> NIP: c0000000003a6c68 LR: c0000000003a6c64 CTR: 0000000001764c5c
> REGS: c0000009ed4333c0 TRAP: 0700   Tainted: G        W   E    (4.11.0-rc1-autotest)
> MSR: 800000000282b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>
>   CR: 22022822  XER: 00000006
> CFAR: c000000000994958 SOFTE: 1
> GPR00: c0000000003a6c64 c0000009ed433640 c00000000138a500 0000000000000035
> GPR04: c0000009ff88ada0 c0000009ff8a1658 00000000014cfc2c 0000000000000000
> GPR08: 0000000000000000 c000000000dd146c 00000009feac0000 0000000000003fef
> GPR12: 0000000022022844 c00000000e9f7e00 0000000037409c40 0000000037409c30
> GPR16: 0000000037409c28 ffffffffffffffff 0000000000000000 000000003741f1c8
> GPR20: 00000100147d1270 0000000000000000 00000000c0ed0000 00003fffa0f53384
> GPR24: c00000000394d178 c000000000c054c0 c000000001742e68 c0000000ff3ea640
> GPR28: c00000000394d640 c0000013eec28c28 c0000009f2ab0148 c000000003833000
> NIP [c0000000003a6c68] .sysfs_warn_dup+0x78/0xb0
> LR [c0000000003a6c64] .sysfs_warn_dup+0x74/0xb0
> Call Trace:
> [c0000009ed433640] [c0000000003a6c64] .sysfs_warn_dup+0x74/0xb0 (unreliable)
> [c0000009ed4336d0] [c0000000003a6de4] .sysfs_create_dir_ns+0xc4/0xd0
> [c0000009ed433760] [c000000000551048] .kobject_add_internal+0xd8/0x450
> [c0000009ed433800] [c00000000055141c] .kobject_init_and_add+0x5c/0x90
> [c0000009ed433890] [c00000000044ac54] .xfs_mountfs+0x224/0xa30
> [c0000009ed433960] [c000000000452a90] .xfs_fs_fill_super+0x490/0x620
> [c0000009ed433a10] [c0000000002fefc0] .mount_bdev+0x220/0x260
> [c0000009ed433ac0] [c0000000004509b8] .xfs_fs_mount+0x18/0x30
> [c0000009ed433b30] [c000000000300520] .mount_fs+0x70/0x210
> [c0000009ed433bf0] [c000000000325930] .vfs_kern_mount+0x60/0x1c0
> [c0000009ed433cb0] [c00000000032a458] .do_mount+0x268/0xee0
> [c0000009ed433d90] [c00000000032b4ec] .SyS_mount+0x8c/0x100
> [c0000009ed433e30] [c00000000000b184] system_call+0x38/0xe0
> Instruction dump:
> 7fa3eb78 38800000 7fe5fb78 38c01000 4bffa929 60000000 3c62ff8b 7fe4fb78
> 38636ec8 7fc5f378 485edcb9 60000000 <0fe00000> 7fe3fb78 4bf1fb01 60000000
> ---[ end trace 78f08bafbc2388f3 ]---
> kobject_add_internal failed for sda with -EEXIST, don't try to register
> things with the same name in the same directory.
> 
> 
> -- 
> Regard's
> 
> Abdul Haleem
> IBM Linux Technology Centre
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
