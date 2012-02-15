Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FCQt7M175478 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 06:26:55 -0600
MIME-Version: 1.0
In-Reply-To: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
References: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
Date: Wed, 15 Feb 2012 17:56:51 +0530
Message-ID: <CADDb1s2_rQJsvLxCFgc1jreMx1vNvQV2YA50Z6k8BcMinQbsiw@mail.gmail.com>
Subject: Re: [PATCH 1/1] xfs: fix buffer flushing during log unmount
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Cc: Nam-Jae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>

Errror logs on 3.0.18
Architecture: ARM
Just tried to mount a corrupted USB HDD - which resulted in the below
mentioned behaviour.

#> mount -t xfs /dev/sdb3 /mnt/
XFS (sdb3): Mounting Filesystem
XFS (sdb3): Starting recovery (logdev: internal)
e420d000: 3f b5 ce 5d 15 3b 64 e2 bb b4 f2 9b a0 97 f5 f4  ?..].;d.........
XFS (sdb3): Internal error xfs_btree_check_sblock at line 120 of file
fs/xfs/xfs_btree.c.  Caller 0xc012c444

[<c003a008>] (unwind_backtrace+0x0/0xe4) from [<c013c990>]
(xfs_corruption_error+0x54/0x70)
[<c013c990>] (xfs_corruption_error+0x54/0x70) from [<c012c310>]
(xfs_btree_check_sblock+0xe4/0xf8)
[<c012c310>] (xfs_btree_check_sblock+0xe4/0xf8) from [<c012c444>]
(xfs_btree_read_buf_block+0x78/0x98)
[<c012c444>] (xfs_btree_read_buf_block+0x78/0x98) from [<c012e0b0>]
(xfs_btree_rshift+0xb0/0x508)
[<c012e0b0>] (xfs_btree_rshift+0xb0/0x508) from [<c012e5c4>]
(xfs_btree_make_block_unfull+0xbc/0x168)
[<c012e5c4>] (xfs_btree_make_block_unfull+0xbc/0x168) from
[<c012e854>] (xfs_btree_insrec+0x1e4/0x504)
[<c012e854>] (xfs_btree_insrec+0x1e4/0x504) from [<c012ebd8>]
(xfs_btree_insert+0x64/0x15c)
[<c012ebd8>] (xfs_btree_insert+0x64/0x15c) from [<c011a51c>]
(xfs_free_ag_extent+0x478/0x5a8)
[<c011a51c>] (xfs_free_ag_extent+0x478/0x5a8) from [<c011af1c>]
(xfs_free_extent+0xcc/0x108)
[<c011af1c>] (xfs_free_extent+0xcc/0x108) from [<c014d2b4>]
(xlog_recover_process_efi+0x168/0x1d4)
[<c014d2b4>] (xlog_recover_process_efi+0x168/0x1d4) from [<c014d380>]
(xlog_recover_process_efis+0x60/0xac)
[<c014d380>] (xlog_recover_process_efis+0x60/0xac) from [<c014d8b4>]
(xlog_recover_finish+0x18/0x90)
[<c014d8b4>] (xlog_recover_finish+0x18/0x90) from [<c0154390>]
(xfs_mountfs+0x4c8/0x5c4)
[<c0154390>] (xfs_mountfs+0x4c8/0x5c4) from [<c0167c5c>]
(xfs_fs_fill_super+0x150/0x244)
[<c0167c5c>] (xfs_fs_fill_super+0x150/0x244) from [<c00c05f4>]
(mount_bdev+0x120/0x19c)
[<c00c05f4>] (mount_bdev+0x120/0x19c) from [<c0166198>] (xfs_fs_mount+0x10/=
0x18)
[<c0166198>] (xfs_fs_mount+0x10/0x18) from [<c00bf39c>] (mount_fs+0x10/0xb8)
[<c00bf39c>] (mount_fs+0x10/0xb8) from [<c00d6d50>] (vfs_kern_mount+0x50/0x=
88)
[<c00d6d50>] (vfs_kern_mount+0x50/0x88) from [<c00d700c>]
(do_kern_mount+0x34/0xc8)
[<c00d700c>] (do_kern_mount+0x34/0xc8) from [<c00d8420>] (do_mount+0x620/0x=
688)
[<c00d8420>] (do_mount+0x620/0x688) from [<c00d850c>] (sys_mount+0x84/0xc4)
[<c00d850c>] (sys_mount+0x84/0xc4) from [<c0034260>] (ret_fast_syscall+0x0/=
0x30)
XFS (sdb3): Corruption detected. Unmount and run xfs_repair
XFS (sdb3): Internal error xfs_trans_cancel at line 1928 of file
fs/xfs/xfs_trans.c.  Caller 0xc014d314

[<c003a008>] (unwind_backtrace+0x0/0xe4) from [<c0156e34>]
(xfs_trans_cancel+0x70/0xfc)
[<c0156e34>] (xfs_trans_cancel+0x70/0xfc) from [<c014d314>]
(xlog_recover_process_efi+0x1c8/0x1d4)
[<c014d314>] (xlog_recover_process_efi+0x1c8/0x1d4) from [<c014d380>]
(xlog_recover_process_efis+0x60/0xac)
[<c014d380>] (xlog_recover_process_efis+0x60/0xac) from [<c014d8b4>]
(xlog_recover_finish+0x18/0x90)
[<c014d8b4>] (xlog_recover_finish+0x18/0x90) from [<c0154390>]
(xfs_mountfs+0x4c8/0x5c4)
[<c0154390>] (xfs_mountfs+0x4c8/0x5c4) from [<c0167c5c>]
(xfs_fs_fill_super+0x150/0x244)
[<c0167c5c>] (xfs_fs_fill_super+0x150/0x244) from [<c00c05f4>]
(mount_bdev+0x120/0x19c)
[<c00c05f4>] (mount_bdev+0x120/0x19c) from [<c0166198>] (xfs_fs_mount+0x10/=
0x18)
[<c0166198>] (xfs_fs_mount+0x10/0x18) from [<c00bf39c>] (mount_fs+0x10/0xb8)
[<c00bf39c>] (mount_fs+0x10/0xb8) from [<c00d6d50>] (vfs_kern_mount+0x50/0x=
88)
[<c00d6d50>] (vfs_kern_mount+0x50/0x88) from [<c00d700c>]
(do_kern_mount+0x34/0xc8)
[<c00d700c>] (do_kern_mount+0x34/0xc8) from [<c00d8420>] (do_mount+0x620/0x=
688)
[<c00d8420>] (do_mount+0x620/0x688) from [<c00d850c>] (sys_mount+0x84/0xc4)
[<c00d850c>] (sys_mount+0x84/0xc4) from [<c0034260>] (ret_fast_syscall+0x0/=
0x30)
XFS (sdb3): xfs_do_force_shutdown(0x8) called from line 1929 of file
fs/xfs/xfs_trans.c.  Return address =3D 0xc0156e48
XFS (sdb3): Corruption of in-memory data detected.  Shutting down filesystem
XFS (sdb3): Please umount the filesystem and rectify the problem(s)
XFS (sdb3): Failed to recover EFIs
XFS (sdb3): log mount finish failed
Unable to handle kernel paging request at virtual address ffffffff
pgd =3D e80bc000
[ffffffff] *pgd=3D68ffc821, *pte=3D00000000, *ppte=3D00000000
Internal error: Oops: 17 [#1] PREEMPT SMP
Modules linked in:
CPU: 1    Not tainted  (3.0.18 #17)
PC is at strnlen+0x10/0x28
LR is at string+0x34/0xcc
pc : [<c01964e0>]    lr : [<c0197ad8>]    psr: a0000093
sp : e424fca0  ip : 00000000  fp : 00000400
r10: e424fd8c  r9 : 00000002  r8 : ffffffff
r7 : 00000000  r6 : 0000ffff  r5 : c03abca8  r4 : c03ab8b0
r3 : 00000000  r2 : ffffffff  r1 : ffffffff  r0 : ffffffff
Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c53c7d  Table: 680bc04a  DAC: 00000015
Process mount (pid: 656, stack limit =3D 0xe424e2f0)
Stack: (0xe424fca0 to 0xe4250000)
...
...
ffe0: 00000000 be88470c 000436dc 00009604 a0000010 be884b4f 45d65600 040000=
00
[<c01964e0>] (strnlen+0x10/0x28) from [<c0197ad8>] (string+0x34/0xcc)
[<c0197ad8>] (string+0x34/0xcc) from [<c0198874>] (vsnprintf+0x1bc/0x344)
[<c0198874>] (vsnprintf+0x1bc/0x344) from [<c0198a68>] (vscnprintf+0xc/0x24)
[<c0198a68>] (vscnprintf+0xc/0x24) from [<c0057424>] (vprintk+0x14c/0x3fc)
[<c0057424>] (vprintk+0x14c/0x3fc) from [<c0293820>] (printk+0x18/0x24)
[<c0293820>] (printk+0x18/0x24) from [<c01660c8>] (xfs_alert_tag+0x64/0x98)
[<c01660c8>] (xfs_alert_tag+0x64/0x98) from [<c0158034>]
(xfs_trans_ail_delete_bulk+0x74/0x118)
[<c0158034>] (xfs_trans_ail_delete_bulk+0x74/0x118) from [<c012fe80>]
(xfs_buf_iodone+0x2c/0x38)
[<c012fe80>] (xfs_buf_iodone+0x2c/0x38) from [<c012fe30>]
(xfs_buf_do_callbacks+0x28/0x38)
[<c012fe30>] (xfs_buf_do_callbacks+0x28/0x38) from [<c012fffc>]
(xfs_buf_iodone_callbacks+0x13c/0x164)
[<c012fffc>] (xfs_buf_iodone_callbacks+0x13c/0x164) from [<c015ffc4>]
(xfs_buf_iodone_work+0x1c/0x40)
[<c015ffc4>] (xfs_buf_iodone_work+0x1c/0x40) from [<c0160194>]
(xfs_bioerror+0x44/0x4c)
[<c0160194>] (xfs_bioerror+0x44/0x4c) from [<c016075c>]
(xfs_flush_buftarg+0xcc/0x148)
[<c016075c>] (xfs_flush_buftarg+0xcc/0x148) from [<c01607f8>]
(xfs_free_buftarg+0x20/0x5c)
[<c01607f8>] (xfs_free_buftarg+0x20/0x5c) from [<c0167cd8>]
(xfs_fs_fill_super+0x1cc/0x244)
[<c0167cd8>] (xfs_fs_fill_super+0x1cc/0x244) from [<c00c05f4>]
(mount_bdev+0x120/0x19c)
[<c00c05f4>] (mount_bdev+0x120/0x19c) from [<c0166198>] (xfs_fs_mount+0x10/=
0x18)
[<c0166198>] (xfs_fs_mount+0x10/0x18) from [<c00bf39c>] (mount_fs+0x10/0xb8)
[<c00bf39c>] (mount_fs+0x10/0xb8) from [<c00d6d50>] (vfs_kern_mount+0x50/0x=
88)
[<c00d6d50>] (vfs_kern_mount+0x50/0x88) from [<c00d700c>]
(do_kern_mount+0x34/0xc8)
[<c00d700c>] (do_kern_mount+0x34/0xc8) from [<c00d8420>] (do_mount+0x620/0x=
688)
[<c00d8420>] (do_mount+0x620/0x688) from [<c00d850c>] (sys_mount+0x84/0xc4)
[<c00d850c>] (sys_mount+0x84/0xc4) from [<c0034260>] (ret_fast_syscall+0x0/=
0x30)
Code: e3a03000 e1510003 e0832000 0a000003 (e7d0c003)
---[ end trace 9fae26d925820746 ]---
note: mount[656] exited with preempt_count 2
Segmentation fault
#>
#>

Regards,
Amit Sahrawat

On Wed, Feb 15, 2012 at 5:26 PM, Amit Sahrawat
<amit.sahrawat83@gmail.com> wrote:
> Whenever there is a mount/unmount failure - there is a chance of calling =
the
> callbacks functions once - transaction ail mount pointer is destroyed. So=
, it results
> in NULL pointer exception followed by hang. So, before unmount of the log=
 - flush all
> the pending buffers.
>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
> =A0fs/xfs/xfs_log.c =A0 | =A0 10 ++++++++++
> =A0fs/xfs/xfs_mount.c | =A0 =A09 ---------
> =A02 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e2cc356..b924a5b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -739,6 +739,16 @@ xfs_log_unmount_write(xfs_mount_t *mp)
> =A0void
> =A0xfs_log_unmount(xfs_mount_t *mp)
> =A0{
> + =A0 =A0 =A0 int error =3D 0;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Make sure all buffers have been flushed and completed =
before
> + =A0 =A0 =A0 =A0* unmounting the log.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 error =3D xfs_flush_buftarg(mp->m_ddev_targp, 1);
> + =A0 =A0 =A0 if (error)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmn_err(CE_WARN, "%d busy buffers during lo=
g unmount.", error);
> + =A0 =A0 =A0 xfs_wait_buftarg(mp->m_ddev_targp);
> +
> =A0 =A0 =A0 =A0xfs_trans_ail_destroy(mp);
> =A0 =A0 =A0 =A0xlog_dealloc_log(mp->m_log);
> =A0}
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index d06afbc..3bd2246 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1519,15 +1519,6 @@ xfs_unmountfs(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Freespace=
 may not be correct on next mount.");
> =A0 =A0 =A0 =A0xfs_unmountfs_writesb(mp);
>
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* Make sure all buffers have been flushed and completed =
before
> - =A0 =A0 =A0 =A0* unmounting the log.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 error =3D xfs_flush_buftarg(mp->m_ddev_targp, 1);
> - =A0 =A0 =A0 if (error)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_warn(mp, "%d busy buffers during unmoun=
t.", error);
> - =A0 =A0 =A0 xfs_wait_buftarg(mp->m_ddev_targp);
> -
> =A0 =A0 =A0 =A0xfs_log_unmount_write(mp);
> =A0 =A0 =A0 =A0xfs_log_unmount(mp);
> =A0 =A0 =A0 =A0xfs_uuid_unmount(mp);
> --
> 1.7.2.3
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
