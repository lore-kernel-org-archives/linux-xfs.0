Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4HFtR1j189564 for <xfs@oss.sgi.com>; Thu, 17 May 2012 10:55:27 -0500
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1FB78F8035
	for <xfs@oss.sgi.com>; Thu, 17 May 2012 08:55:23 -0700 (PDT)
Date: Thu, 17 May 2012 11:00:02 -0500
From: Ben Myers <bpm@sgi.com>
Subject: xfs: assertion failed in xfs_file_dio_aio_write
Message-ID: <20120517160002.GL16099@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Folks,

Here's an interesting assert that I hit overnight:

[89045.383286] XFS: Assertion failed: ret < 0 || ret == count, file: /root/xfs/fs/xfs/xfs_file.c, line: 705
[89045.392866] ------------[ cut here ]------------
[89045.396761] kernel BUG at /root/xfs/fs/xfs/xfs_message.c:100!
[89045.396761] invalid opcode: 0000 [#1] SMP 
[89045.396761] CPU 1 
[89045.408007] Modules linked in: xfs(O) exportfs af_packet fuse loop dm_mod e1000 shpchp iTCO_wdt tpm_tis sg pci_hotplug sr_mod iTCO_vendor_support intel_rng tpm tpm_bios e752x_edac mic
rocode floppy cdrom pcspkr serio_raw container edac_core i2c_i801 i2c_core button uhci_hcd ehci_hcd sd_mod crc_t10dif usbcore usb_common edd ext3 mbcache jbd fan processor ide_pci_generi
c piix ide_core ata_generic ata_piix libata aic79xx scsi_transport_spi scsi_mod thermal thermal_sys hwmon [last unloaded: xfs]
[89045.408007] 
[89045.408007] Pid: 26996, comm: dd Tainted: G           O 3.4.0-rc2-0.7-default+ #20 Supermicro X6DHR-8G/X6DHR-8GS/X6DHR-8G/X6DHR-8GS
[89045.408007] RIP: 0010:[<ffffffffa0309bdd>]  [<ffffffffa0309bdd>] assfail+0x1d/0x30 [xfs]
[89045.408007] RSP: 0000:ffff880220d3dcd8  EFLAGS: 00010296
[89045.408007] RAX: 0000000000000072 RBX: 0000000000000000 RCX: 0000000000000086
[89045.408007] RDX: 00000000000087ac RSI: 0000000000000046 RDI: 0000000000000246
[89045.408007] RBP: ffff880220d3dcd8 R08: 0000000000000000 R09: 0000000000000000
[89045.408007] R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
[89045.408007] R13: ffff88022ee11388 R14: ffff88022ee11100 R15: 0000000000100000
[89045.408007] FS:  00007fc8e1342700(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
[89045.408007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[89045.408007] CR2: 00007fe7b0dc6a02 CR3: 0000000220cd9000 CR4: 00000000000007e0
[89045.408007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[89045.408007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[89045.408007] Process dd (pid: 26996, threadinfo ffff880220d3c000, task ffff880220c26080)
[89045.408007] Stack:
[89045.408007]  ffff880220d3dd58 ffffffffa02fffe7 0000000000100000 0000000000000029
[89045.408007]  ffff880220d3ded8 ffff880220d3ddf8 0000000020d3dd38 000000000e100000
[89045.408007]  0000000000000001 0000000000100000 0000000223c72e98 fffffffffffffffb
[89045.408007] Call Trace:
[89045.408007]  [<ffffffffa02fffe7>] xfs_file_dio_aio_write+0x147/0x290 [xfs]
[89045.408007]  [<ffffffffa030031a>] xfs_file_aio_write+0x1ea/0x1f0 [xfs]
[89045.408007]  [<ffffffff810e4b06>] ? __vm_enough_memory+0x36/0x170
[89045.408007]  [<ffffffff8110e5d9>] do_sync_write+0xd9/0x120
[89045.408007]  [<ffffffff81194bfd>] ? security_file_permission+0x1d/0xa0
[89045.408007]  [<ffffffff8110ec0b>] vfs_write+0xcb/0x180
[89045.408007]  [<ffffffff8110edb0>] sys_write+0x50/0x90
[89045.408007]  [<ffffffff813b27f9>] system_call_fastpath+0x16/0x1b
[89045.408007] Code: 00 00 00 48 89 45 c8 e8 72 fc ff ff c9 c3 55 41 89 d0 48 89 f1 48 89 fa 48 c7 c6 e0 a2 37 a0 31 ff 48 89 e5 31 c0 e8 93 ff ff ff <0f> 0b eb fe 90 90 90 90 90 90 90 9
0 90 90 90 90 90 90 90 55 4c 
[89045.408007] RIP  [<ffffffffa0309bdd>] assfail+0x1d/0x30 [xfs]
[89045.408007]  RSP <ffff880220d3dcd8>

This assertion failed while I was running xfstests -g auto in a loop.  Looks
like test 247 was running at the time of the crash. 

~/xfstests # while true
> do
> ./check -g auto
> done
SRC           -- /root/xfs
BRANCH        -- refs/heads/master
DESC          -- v3.4-rc2-54-g1307bbd
PATCHES:
/root/xfs/patches/xfs-fix-delalloc-quota-accounting-on-failure.patch
        md5sum:         edbb56145eedc2e79960821246b25425
        X-Patchwork-Id:
        Message-Id:     <1336474133-27732-1-git-send-email-david@fromorbit.com>
/root/xfs/patches/xfs-fix-memory-reclaim-deadlock-on-agi-buffer.patch
        md5sum:         6157ca5a97fbec939bf046cbd59faa66
        X-Patchwork-Id:
        Message-Id:     <1336421497-1554-1-git-send-email-treestem@gmail.com>
/root/xfs/patches/xfs-add-trace-points-for-log-forces.patch
        md5sum:         84bb6825bc550f47ebca16f5678d96f0
        X-Patchwork-Id:
        Message-Id:     <1335249220-22274-2-git-send-email-david@fromorbit.com>
/root/xfs/patches/xfs-use-iolock-on-xfs_ioc_allocsp-calls.patch
        md5sum:         19602e6e5ffcc242b2d2f5680bd9f708
        X-Patchwork-Id:
        Message-Id:     <1334051449-26631-1-git-send-email-david@fromorbit.com>
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 nfs10 3.4.0-rc2-0.7-default+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb4
MOUNT_OPTIONS -- /dev/sdb4 /mnt/scratch
...
243 1s ... 0s
244 2s ... 2s
245 0s ... 1s
246 0s ... 1s
247 31s ...Write failed: Broken pipe


 625 STATIC ssize_t
 626 xfs_file_dio_aio_write(
 627         struct kiocb            *iocb,
 628         const struct iovec      *iovp,
 629         unsigned long           nr_segs,
 630         loff_t                  pos,
 631         size_t                  ocount)
 632 {
...
 698         ret = generic_file_direct_write(iocb, iovp,
 699                         &nr_segs, pos, &iocb->ki_pos, count, ocount);
 700 
 701 out:
 702         xfs_rw_iunlock(ip, iolock);
 703 
 704         /* No fallback to buffered IO on errors for XFS. */
 705         ASSERT(ret < 0 || ret == count);
 706         return ret;
 707 }


Something to keep an eye out for.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
