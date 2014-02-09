Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C26FA7F4E
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 17:57:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D09F304048
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 15:57:37 -0800 (PST)
Received: from mail-oa0-f53.google.com (mail-oa0-f53.google.com
	[209.85.219.53]) by cuda.sgi.com with ESMTP id 9AoGUrWtX11oKeJP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 09 Feb 2014 15:57:36 -0800 (PST)
Received: by mail-oa0-f53.google.com with SMTP id m1so6802972oag.12
	for <xfs@oss.sgi.com>; Sun, 09 Feb 2014 15:57:35 -0800 (PST)
Received: from [192.168.0.129] (rrcs-97-79-21-178.se.biz.rr.com.
	[97.79.21.178])
	by mx.google.com with ESMTPSA id tr7sm14562948oec.0.2014.02.09.15.57.34
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Sun, 09 Feb 2014 15:57:35 -0800 (PST)
Message-ID: <52F815EE.3030600@gmail.com>
Date: Sun, 09 Feb 2014 18:57:34 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: XFS on 3.14.0-rc1 (x86): xfs_isilocked() assertion on realtime
	subvolume
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Hi!  I was working with realtime subvolumes on a 3.14.0-rc1+ kernel, doing 
something like this...

mkfs.xfs -l logdev=$TEST_LOGDEV -r rtdev=$TEST_RTDEV $TEST_DEV
mount -t xfs -o logdev=$TEST_LOGDEV -o rtdev=$TEST_RTDEV $TEST_DEV $TEST_DIR

cd $TEST_DIR
mkdir testrtdir
xfs_io -c 'chattr +t' testrtdir
cd testrtdir
dd if=/dev/zero of=testrtfile bs=512 count=65536

...and was greeted by this:

XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL), file: fs/xfs/xfs_bmap.c, line: 4016
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:107!
invalid opcode: 0000 [#1] 
CPU: 0 PID: 279 Comm: dd Not tainted 3.13.0+ #11
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
task: c6044f40 ti: c6088000 task.ti: c6088000
EIP: 0060:[<79150f60>] EFLAGS: 00010286 CPU: 0
EIP is at assfail+0x2b/0x2d
EAX: 0000006e EBX: c6a7e500 ECX: 794ecef0 EDX: 794e9aa4
ESI: 00000000 EDI: c6001800 EBP: c60898e0 ESP: c60898cc
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
CR0: 8005003b CR2: 0804cad0 CR3: 4d4f6000 CR4: 000007d0
Stack:
 00000000 794876b0 7948a814 7947fe84 00000fb0 c6089978 7916e73c c60fa2c0
 c60fa2c0 c60e1e00 c6089918 c6c01e80 c606c000 c60fa2c0 c606c000 c6089918
 79157bb8 c60fa2c0 c60e1e00 c6089930 791a7a79 00000001 00000000 00000000
Call Trace:
 [<7916e73c>] xfs_bmapi_read+0x89/0x39f
 [<79157bb8>] ? xfs_trans_add_item+0x58/0x82
 [<791a7a79>] ? _xfs_trans_bjoin+0xa5/0xb0
 [<791a803c>] ? xfs_trans_read_buf_map+0x2fe/0x54b
 [<791a4e14>] ? xfs_buf_item_free+0x2d/0x30
 [<791b421d>] xfs_rtbuf_get+0x59/0x132
 [<791a83fb>] ? xfs_trans_brelse+0x172/0x1c0
 [<791b46b7>] ? xfs_rtfind_forw+0x130/0x275
 [<791b4860>] xfs_rtmodify_summary+0x64/0xcb
 [<791b2742>] xfs_rtallocate_range+0xb4/0x17b
 [<791b2a26>] xfs_rtallocate_extent_exact+0xa4/0xe8
 [<791b2aee>] xfs_rtallocate_extent_near+0x84/0x317
 [<791588a4>] ? kmem_zone_alloc+0x64/0xe0
 [<791588a4>] ? kmem_zone_alloc+0x64/0xe0
 [<791b3be1>] xfs_rtallocate_extent+0x1e9/0x233
 [<7913c6a5>] xfs_bmap_rtalloc+0x193/0x2d7
 [<7916e24b>] xfs_bmap_alloc+0x26/0x2c
 [<7916f260>] __xfs_bmapi_allocate+0xca/0x32f
 [<7919c80e>] ? xfs_perag_get+0x1e/0xa7
 [<7913c864>] xfs_bmapi_allocate+0x7b/0x81
 [<7916fc77>] xfs_bmapi_write+0x648/0xa76
 [<7914cd96>] xfs_iomap_write_direct+0x276/0x44b
 [<7913a4ce>] __xfs_get_blocks+0x398/0x5d3
 [<7913a728>] xfs_get_blocks+0x1f/0x25
 [<790e39d8>] __block_write_begin+0x10b/0x2d9
 [<7913aa57>] xfs_vm_write_begin+0x66/0xdf
 [<7913a709>] ? __xfs_get_blocks+0x5d3/0x5d3
 [<79093ace>] generic_file_buffered_write+0xcd/0x1fe
 [<791457da>] xfs_file_buffered_aio_write+0xf5/0x16b
 [<791458f9>] xfs_file_aio_write+0xa9/0xe8
 [<790bde06>] do_sync_write+0x56/0x79
 [<790bddb0>] ? vfs_read+0x10d/0x10d
 [<790bdfab>] vfs_write+0x9e/0x189
 [<790bddb0>] ? vfs_read+0x10d/0x10d
 [<790be160>] SyS_write+0x49/0x81
 [<79385538>] sysenter_do_call+0x12/0x26
Code: 55 89 e5 83 ec 14 3e 8d 74 26 00 89 4c 24 10 89 54 24 0c 89 44 24 08 c7 44 24 04 b0 76 48 79 c7 04 24 00 00 00 00 e8 ad fd ff ff <0f> 0b 55 89 e5 83 ec 14 3e 8d 74 26 00 c7 44 24 10 01 00 00 00
EIP: [<79150f60>] assfail+0x2b/0x2d SS:ESP 0068:c60898cc

A bisect brought me here:

root@plbearer:/usr/src/kernel-git/linux# git bisect good
eef334e5776c8ef547ada4cec17549929fe590b4 is the first bad commit
commit eef334e5776c8ef547ada4cec17549929fe590b4
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:17 2013 -0800

    xfs: assert that we hold the ilock for extent map access

    Make sure that xfs_bmapi_read has the ilock held in some way, and that
    xfs_bmapi_write, xfs_bmapi_delay, xfs_bunmapi and xfs_iread_extents are
    called with the ilock held exclusively.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

:040000 040000 5e579f7be412556585187374aec9ba314a66ddaf 449dc42e832d92fb2d6f8551708135d2ce7d2f79 M      fs

I scanned over the patch, and indeed, it's almost nothing but new 
assertions.  Very good!

Is this particular assert a false positive, or is it a sign that the 
ilock usage by realtime subvolumes needs to be reviewed?

This issue was found and bisected using v4-superblock XFS.  A quick 
test on v5-superblock XFS exhibited the same behavior.

The PC was an i686 Pentium 4 running Slackware 14.1.  Memory is hazy, 
but I think that $TEST_DEV was around 19 GB, $TEST_LOGDEV was 128 MB, 
and $TEST_RTDEV was 1 GB, all normal GPT partitions.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
