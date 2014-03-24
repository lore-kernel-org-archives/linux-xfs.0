Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E46A429DF7
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2014 16:36:49 -0500 (CDT)
Message-ID: <5330A56E.4010403@sgi.com>
Date: Mon, 24 Mar 2014 16:36:46 -0500
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

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


This is very interesting. From your first occurrence of the problem, there
are 3 groups of duplicate allocated blocks in AG14. Remove both
duplicates and the XFS_WANT_CORRUPTED_GOTO is triggered.

In the first group, inode 940954751 maps fsb 58817713 for a length of 1920
and most of these blocks are allocated elsewhere in small lengths.

In the second group, inode 940954759 is maps fsb 58822053 for a length 39,
and most of these blocks are allocated elsewhere.

In the third group there are smaller (1, 2, 3, 10) blocks of overlaps.
The last 2 blocks of this group are allocated to inode 941385832 and are
also listed as being free in the cntbr/bnobt at the same time.

To make things more interesting, there a several cases where the first inode
of an inode chunk has a single block mapped and that block is a 
duplicate for
another active inode chunk block. Example of this is inode 941083520 maps
fsb 58817724, but that block is also the inode chunk for inodes starting
at 941083584.

The earlier found interesting duplicate is the user data block, fsb
58836692 in inode 941386494 that is also a directory block 11 in inode
940862056. The user block was written last which is now garbage for the
directory.

I don't know any more why we are duplicate mapping.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
