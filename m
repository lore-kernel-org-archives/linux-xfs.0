Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Nov 2006 10:40:05 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA2IdwaG023870
	for <xfs@oss.sgi.com>; Thu, 2 Nov 2006 10:39:59 -0800
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F998D1BB033
	for <xfs@oss.sgi.com>; Thu,  2 Nov 2006 10:39:13 -0800 (PST)
Message-ID: <454A3B28.7010405@sandeen.net>
Date: Thu, 02 Nov 2006 12:38:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mount failed after xfs_growfs beyond 16 TB
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de>
In-Reply-To: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: christian.guggenberger@physik.uni-regensburg.de
Cc: xfs@oss.sgi.com

Christian Guggenberger wrote:
> Hi,
> 
> a colleague recently tried to grow a 16 TB filesystem (x86, 32bit) on
> top of lvm2 to 17TB. (I am not even sure if that's supposed work with
> linux-2.6, 32bit)

If you have CONFIG_LBD enabled (do you?), it should in theory, barring
bugs :)

> used kernel seems to be debian sarge's 2.6.8

hmm old....

> xfs_growfs seemed to succeed (AFAIK..)

trace below looks like not...

> however, the fs shut down:
> 
> XFS internal error
> XFS_WANT_CORRUPTED_GOTO at line 1583 of file fs/xfs/xfs_alloc.c.  Caller
> 0xf89978a8
> [__crc_pm_idle+550816/2056674] xfs_free_ag_extent+0x454/0x78a [xfs]
> [__crc_pm_idle+555561/2056674] xfs_free_extent+0xea/0x10f [xfs]
> [__crc_pm_idle+555561/2056674] xfs_free_extent+0xea/0x10f [xfs]
> [__crc_pm_idle+553757/2056674] xfs_alloc_read_agf+0xbe/0x1e4 [xfs]

in the growfs thread here

> [__crc_pm_idle+764480/2056674] xfs_growfs_data_private+0xd80/0xec0 [xfs]
> [pty_write+305/307] pty_write+0x131/0x133
> [opost+154/428] opost+0x9a/0x1ac
> [__crc_pm_idle+765024/2056674] xfs_growfs_data+0x3f/0x5e [xfs]
> [__crc_pm_idle+972873/2056674] xfs_ioctl+0x256/0x860 [xfs]
> [tty_write+436/788] tty_write+0x1b4/0x314
> [write_chan+0/538] write_chan+0x0/0x21a
> [__crc_pm_idle+968754/2056674] linvfs_ioctl+0x78/0x101 [xfs]
> [sys_ioctl+315/675] sys_ioctl+0x13b/0x2a3
> [syscall_call+7/11] syscall_call+0x7/0xb
> xfs_force_shutdown(dm-1,0x8) called
> from line 1088 of file fs/xfs/xfs_trans.c.  Return address = 0xf8a01c3c
> Filesystem "dm-1": Corruption of
> in-memory data detected.  Shutting down filesystem: dm-1
> Please umount the filesystem, and
> rectify the problem(s)
> xfs_force_shutdown(dm-1,0x1) called
> from line 353 of file fs/xfs/xfs_rw.c.  Return address = 0xf8a01c3c
> 
> mounting fails with:
> 
> XFS: SB sanity check 2 failed

This is checking:

        if (unlikely(
            sbp->sb_dblocks == 0 ||
            sbp->sb_dblocks >
             (xfs_drfsbno_t)sbp->sb_agcount * sbp->sb_agblocks ||
            sbp->sb_dblocks < (xfs_drfsbno_t)(sbp->sb_agcount - 1) *
                              sbp->sb_agblocks + XFS_MIN_AG_BLOCKS)) {
                xfs_fs_mount_cmn_err(flags, "SB sanity check 2 failed");
                return XFS_ERROR(EFSCORRUPTED);
        }

can you point xfs_db -r /dev/dm-1 and then:

xfs_db> sb 0
xfs_db> p

let's see what you've got.

Also how big does /proc/partitions think your new device is?

> Filesystem "dm-1": XFS internal error
> xfs_mount_validate_sb(4) at line 277 of file fs/xfs/xfs_mount.c.  Caller
> 0xf89e568c
> [__crc_pm_idle+872883/2056674] xfs_mount_validate_sb+0x21d/0x39a [xfs]
> [__crc_pm_idle+874509/2056674] xfs_readsb+0xee/0x1f9 [xfs]
> [__crc_pm_idle+874509/2056674] xfs_readsb+0xee/0x1f9 [xfs]
> [__crc_pm_idle+908971/2056674] xfs_mount+0x282/0x5d4 [xfs]
> [__crc_pm_idle+989973/2056674] vfs_mount+0x34/0x38 [xfs]
> [__crc_pm_idle+989973/2056674] vfs_mount+0x34/0x38 [xfs]
> [__crc_pm_idle+989534/2056674] linvfs_fill_super+0xa1/0x1ee [xfs]
> [snprintf+39/43] snprintf+0x27/0x2b
> [disk_name+169/171] disk_name+0xa9/0xab
> [sb_set_blocksize+46/93] sb_set_blocksize+0x2e/0x5d
> [get_sb_bdev+262/313] get_sb_bdev+0x106/0x139
> [__crc_pm_idle+989914/2056674] linvfs_get_sb+0x2f/0x36 [xfs]
> [__crc_pm_idle+989373/2056674] linvfs_fill_super+0x0/0x1ee [xfs]
> [do_kern_mount+162/354] do_kern_mount+0xa2/0x162
> [do_new_mount+115/181] do_new_mount+0x73/0xb5
> [do_mount+370/446] do_mount+0x172/0x1be
> [copy_mount_options+99/188] copy_mount_options+0x63/0xbc
> [sys_mount+212/344] sys_mount+0xd4/0x158
> [syscall_call+7/11] syscall_call+0x7/0xb
> XFS: SB validate failed
> XFS: SB sanity check 2 failed
> 
> and finally, xfs_repair stops at
> 
> bad primary superblock: inconsistent file geometrie information
> 
> found candidate secondary superblock...
> superblock read failed, offset 10093861404672, size 2048, ag 0, rval 29

hmm that offset is about 9.4 terabytes.

any kernel messages when this happens?

rval 29 is ESPIPE / illegal seek.

-Eric

> thanks in advance,
> 
>  - Christian
> 
> 
> 
