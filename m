Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 148D37F56
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 16:43:31 -0500 (CDT)
Message-ID: <5320D4FE.3070002@sgi.com>
Date: Wed, 12 Mar 2014 16:43:26 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Possible XFS bug encountered in 3.14.0-rc3+
References: <33A0129EBFD46748804DE81B354CA1B21C0DC77A@SACEXCMBX06-PRD.hq.netapp.com>
In-Reply-To: <33A0129EBFD46748804DE81B354CA1B21C0DC77A@SACEXCMBX06-PRD.hq.netapp.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Mears, Morgan" <Morgan.Mears@netapp.com>
Cc: Jie Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 03/12/14 15:14, Mears, Morgan wrote:
> Hi,
>
> Please CC me on any responses; I don't subscribe to this list.
>
> I ran into a possible XFS bug while doing some Oracle benchmarking.  My test
> system is running a 3.14.0-rc3+ kernel built from the for-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
> on 2014-02-19 (last commit 1342f11e713792e53e4b7aa21167fe9caca81c4a).
>
> The XFS instance in question is 200 GB and should have all default
> parameters (mkfs.xfs /dev/mapper/<my_lun_partition>).  It contains Oracle
> binaries and trace files.  At the time the issue occurred I had been
> running Oracle with SQL*NET server tracing enabled.  The affected XFS
> had filled up 100% with trace files several times; I was periodically
> executing rm -f * in the trace file directory, which would reduce the
> file system occupancy from 100% to 3%.  I had an Oracle load generating
> tool running, so new log files were being created with some frequency.
>
> The issue occurred during one of my rm -f * executions; afterwards the
> file system would only produce errors.  Here is the traceback:
>
> [1552067.297192] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa04c4905
> [1552067.297203] CPU: 13 PID: 699 Comm: rm Not tainted 3.14.0-rc3+ #1
> [1552067.297206] Hardware name: FUJITSU PRIMERGY RX300 S7/D2939-A1, BIOS V4.6.5.3 R1.19.0 for D2939-A1x 12/06/2012
> [1552067.297210]  0000000000069ff9 ffff8817740e1b88 ffffffff815f1eb5 0000000000000001
> [1552067.297222]  ffff8817740e1ba0 ffffffffa04aac7b ffffffffa04c4905 ffff8817740e1c38
> [1552067.297229]  ffffffffa04c3399 ffff882022dae000 ffff8810247d2d00 ffff8810239c4840
> [1552067.297236] Call Trace:
> [1552067.297248]  [<ffffffff815f1eb5>] dump_stack+0x45/0x56
> [1552067.297311]  [<ffffffffa04aac7b>] xfs_error_report+0x3b/0x40 [xfs]
> [1552067.297344]  [<ffffffffa04c4905>] ? xfs_free_extent+0xc5/0xf0 [xfs]
> [1552067.297373]  [<ffffffffa04c3399>] xfs_free_ag_extent+0x1e9/0x710 [xfs]
> [1552067.297401]  [<ffffffffa04c4905>] xfs_free_extent+0xc5/0xf0 [xfs]
> [1552067.297425]  [<ffffffffa04a4b0f>] xfs_bmap_finish+0x13f/0x190 [xfs]
> [1552067.297461]  [<ffffffffa04f281d>] xfs_itruncate_extents+0x16d/0x2a0 [xfs]
> [1552067.297503]  [<ffffffffa04f29dd>] xfs_inactive_truncate+0x8d/0x120 [xfs]
> [1552067.297534]  [<ffffffffa04f3188>] xfs_inactive+0x138/0x160 [xfs]
> [1552067.297562]  [<ffffffffa04bbed0>] xfs_fs_evict_inode+0x80/0xc0 [xfs]
> [1552067.297570]  [<ffffffff811dc0f3>] evict+0xa3/0x1a0
> [1552067.297575]  [<ffffffff811dc925>] iput+0xf5/0x180
> [1552067.297582]  [<ffffffff811cf4fe>] do_unlinkat+0x18e/0x2a0
> [1552067.297590]  [<ffffffff811c6ba5>] ? SYSC_newfstatat+0x25/0x30
> [1552067.297596]  [<ffffffff811d28eb>] SyS_unlinkat+0x1b/0x40
> [1552067.297602]  [<ffffffff816024a9>] system_call_fastpath+0x16/0x1b
> [1552067.297610] XFS (dm-7): xfs_do_force_shutdown(0x8) called from line 138 of file fs/xfs/xfs_bmap_util.c.  Return address = 0xffffffffa04a4b48
> [1552067.298378] XFS (dm-7): Corruption of in-memory data detected.  Shutting down filesystem
> [1552067.298385] XFS (dm-7): Please umount the filesystem and rectify the problem(s)

Partial free extent. Lots of unused sequential blocks listed in 
sequential inodes. Are you sure there are no errors in the device mapper 
layer?


> I was unable to umount, even with -f; failed with EBUSY and couldn't unbusy
> as the fs was unresponsive (and happens to contain the Oracle management
> tools necessary to close all open descriptors).  Accordingly I rebooted.

You are the second person in 2-3 weeks to hit this unmount issue.
Unmatched EFI in the AIL keeps the unmount from completing.

Jeff are you still looking at this?

Here and in xlog_recover_process_efi(), the EFD will never happened 
because of the xfs_free_extent error. A manual removal of the EFI from 
the AIL in these cases has to be done. Christoph's proposed EFI/EFD 
recovery changed will not change the need to remove the EFI from the AIL 
in recovery because at this point he does put the EFI on the AIL.

Case 2 is a bit trickier. The EFI has a matching EFD. The EFI makes it 
to AIL but the EFD is on the CIL when there is a forced shutdown. The 
EFD will not remove the EFI in this case. We cannot check if the EFI on 
the AIL in the iop_{committed | unlink} for EFI/EFD pairs that on the 
CIL at forced shutdown because the check would be a use after free on 
the EFI.

The EFD being aborted on a bad xlog buffer write is another path, but 
that is pretty much the same as the case #2.

> I captured a post-reboot xfs_metadump before attempting any other operations
> on the partition.  It is here:
>
> https://dl.dropboxusercontent.com/u/31522929/xfs-double-free-xfs_metadump-before-repair.gz
>
> Attempting to mount in order to replay the log resulted in mount hanging,
> and another traceback, as follows:
>
> [  921.672867] XFS (dm-9): Mounting Filesystem
> [  921.707326] XFS (dm-9): Starting recovery (logdev: internal)
> [  921.721596] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa035d905
> [  921.721607] CPU: 3 PID: 8569 Comm: mount Not tainted 3.14.0-rc3+ #1
> [  921.721610] Hardware name: FUJITSU PRIMERGY RX300 S7/D2939-A1, BIOS V4.6.5.3 R1.19.0 for D2939-A1x 12/06/2012
> [  921.721614]  0000000000069ff9 ffff88102698fb30 ffffffff815f1eb5 0000000000000001
> [  921.721625]  ffff88102698fb48 ffffffffa0343c7b ffffffffa035d905 ffff88102698fbe0
> [  921.721632]  ffffffffa035c399 ffff881021928800 ffff881017847900 ffff881029304f00
> [  921.721639] Call Trace:
> [  921.721650]  [<ffffffff815f1eb5>] dump_stack+0x45/0x56
> [  921.721713]  [<ffffffffa0343c7b>] xfs_error_report+0x3b/0x40 [xfs]
> [  921.721746]  [<ffffffffa035d905>] ? xfs_free_extent+0xc5/0xf0 [xfs]
> [  921.721820]  [<ffffffffa035c399>] xfs_free_ag_extent+0x1e9/0x710 [xfs]
> [  921.721877]  [<ffffffffa035d905>] xfs_free_extent+0xc5/0xf0 [xfs]
> [  921.721912]  [<ffffffffa0390f50>] xlog_recover_process_efi+0x170/0x1b0 [xfs]
> [  921.721948]  [<ffffffffa03a0434>] ? xfs_trans_ail_cursor_init+0x24/0x30 [xfs]
> [  921.721981]  [<ffffffffa0392e84>] xlog_recover_process_efis.isra.27+0x64/0xb0 [xfs]
> [  921.722023]  [<ffffffffa0396041>] xlog_recover_finish+0x21/0xb0 [xfs]
> [  921.722055]  [<ffffffffa039aa34>] xfs_log_mount_finish+0x34/0x50 [xfs]
> [  921.722082]  [<ffffffffa035327d>] xfs_mountfs+0x47d/0x710 [xfs]
> [  921.722109]  [<ffffffffa03565c2>] xfs_fs_fill_super+0x2b2/0x330 [xfs]
> [  921.722121]  [<ffffffff811c4db4>] mount_bdev+0x194/0x1d0
> [  921.722161]  [<ffffffffa0356310>] ? xfs_parseargs+0xbd0/0xbd0 [xfs]
> [  921.722190]  [<ffffffffa0354605>] xfs_fs_mount+0x15/0x20 [xfs]
> [  921.722200]  [<ffffffff811c57d9>] mount_fs+0x39/0x1b0
> [  921.722208]  [<ffffffff81172090>] ? __alloc_percpu+0x10/0x20
> [  921.722219]  [<ffffffff811dfe67>] vfs_kern_mount+0x67/0x100
> [  921.722226]  [<ffffffff811e24be>] do_mount+0x23e/0xad0
> [  921.722233]  [<ffffffff8116c2fb>] ? strndup_user+0x4b/0xf0
> [  921.722240]  [<ffffffff811e3073>] SyS_mount+0x83/0xc0
> [  921.722248]  [<ffffffff816024a9>] system_call_fastpath+0x16/0x1b
> [  921.722262] XFS (dm-9): Failed to recover EFIs
> [  921.722266] XFS (dm-9): log mount finish failed

The unmount from this failed recovery could hang also see case #1 above.

>
> I ran xfs_repair -n; the output is here:
>
> https://dl.dropboxusercontent.com/u/31522929/xfs_repair-n-output
>
> xfs_repair with no args failed because there was still content in the logs.
>
> xfs_repair -L succeeded; the output is here:
>
> https://dl.dropboxusercontent.com/u/31522929/xfs_repair-L-output
>
> Afterwards I was able to mount the file system and start Oracle from it.
>

Interesting.

> Regards,
> Morgan Mears

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
