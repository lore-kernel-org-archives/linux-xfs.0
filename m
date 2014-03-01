Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2AEB97F3F
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2014 04:57:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4393AC002
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2014 02:57:13 -0800 (PST)
Received: from mail-wg0-f51.google.com (mail-wg0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id 8kzx2eGALu7AwIsD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 01 Mar 2014 02:57:12 -0800 (PST)
Received: by mail-wg0-f51.google.com with SMTP id a1so1444263wgh.22
	for <xfs@oss.sgi.com>; Sat, 01 Mar 2014 02:57:10 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: make defrag not fragment files when using prealloc
	extents
Date: Sat,  1 Mar 2014 10:57:03 +0000
Message-Id: <1393671423-7349-1-git-send-email-fdmanana@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, linux-btrfs@vger.kernel.org

When using prealloc extents, a file defragment operation may actually
fragment the file and increase the amount of data space used by the file.
This change fixes that behaviour.

Example:

$ mkfs.btrfs -f /dev/sdb3
$ mount /dev/sdb3 /mnt
$ cd /mnt
$ xfs_io -f -c 'falloc 0 1048576' foobar && sync
$ xfs_io -c 'pwrite -S 0xff -b 100000 5000 100000' foobar
$ xfs_io -c 'pwrite -S 0xac -b 100000 200000 100000' foobar
$ xfs_io -c 'pwrite -S 0xe1 -b 100000 900000 100000' foobar && sync

Before defragmenting the file:

$ btrfs filesystem df /mnt
Data, single: total=8.00MiB, used=1.25MiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.00GiB, used=112.00KiB
Metadata, single: total=8.00MiB, used=0.00

$ btrfs-debug-tree /dev/sdb3
(...)
	item 6 key (257 EXTENT_DATA 0) itemoff 15810 itemsize 53
		prealloc data disk byte 12845056 nr 1048576
		prealloc data offset 0 nr 4096
	item 7 key (257 EXTENT_DATA 4096) itemoff 15757 itemsize 53
		extent data disk byte 12845056 nr 1048576
		extent data offset 4096 nr 102400 ram 1048576
		extent compression 0
	item 8 key (257 EXTENT_DATA 106496) itemoff 15704 itemsize 53
		prealloc data disk byte 12845056 nr 1048576
		prealloc data offset 106496 nr 90112
	item 9 key (257 EXTENT_DATA 196608) itemoff 15651 itemsize 53
		extent data disk byte 12845056 nr 1048576
		extent data offset 196608 nr 106496 ram 1048576
		extent compression 0
	item 10 key (257 EXTENT_DATA 303104) itemoff 15598 itemsize 53
		prealloc data disk byte 12845056 nr 1048576
		prealloc data offset 303104 nr 593920
	item 11 key (257 EXTENT_DATA 897024) itemoff 15545 itemsize 53
		extent data disk byte 12845056 nr 1048576
		extent data offset 897024 nr 106496 ram 1048576
		extent compression 0
	item 12 key (257 EXTENT_DATA 1003520) itemoff 15492 itemsize 53
		prealloc data disk byte 12845056 nr 1048576
		prealloc data offset 1003520 nr 45056
(...)

Now defragmenting the file results in more data space used than before:

$ btrfs filesystem defragment -f foobar && sync
$ btrfs filesystem df /mnt
Data, single: total=8.00MiB, used=1.55MiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.00GiB, used=112.00KiB
Metadata, single: total=8.00MiB, used=0.00

And the corresponding file extent items are now no longer perfectly sequential
as before, and we're now needlessly using more space from data block groups:

$ btrfs-debug-tree /dev/sdb3
(...)
	item 6 key (257 EXTENT_DATA 0) itemoff 15810 itemsize 53
		extent data disk byte 12845056 nr 1048576
		extent data offset 0 nr 4096 ram 1048576
		extent compression 0
	item 7 key (257 EXTENT_DATA 4096) itemoff 15757 itemsize 53
		extent data disk byte 13893632 nr 102400
		extent data offset 0 nr 102400 ram 102400
		extent compression 0
	item 8 key (257 EXTENT_DATA 106496) itemoff 15704 itemsize 53
		extent data disk byte 12845056 nr 1048576
		extent data offset 106496 nr 90112 ram 1048576
		extent compression 0
	item 9 key (257 EXTENT_DATA 196608) itemoff 15651 itemsize 53
		extent data disk byte 13996032 nr 106496
		extent data offset 0 nr 106496 ram 106496
		extent compression 0
	item 10 key (257 EXTENT_DATA 303104) itemoff 15598 itemsize 53
		prealloc data disk byte 12845056 nr 1048576
		prealloc data offset 303104 nr 593920
	item 11 key (257 EXTENT_DATA 897024) itemoff 15545 itemsize 53
		extent data disk byte 14102528 nr 106496
		extent data offset 0 nr 106496 ram 106496
		extent compression 0
	item 12 key (257 EXTENT_DATA 1003520) itemoff 15492 itemsize 53
		extent data disk byte 12845056 nr 1048576
		extent data offset 1003520 nr 45056 ram 1048576
		extent compression 0
(...)

With this change, the above example will no longer cause allocation of new data
space nor change the sequentiality of the file extents, that is, defragment will
be effectless, leaving all extent items pointing to the extent starting at disk
byte 12845056.

In a 20Gb filesystem I had, mounted with the autodefrag option and 20 files of
400Mb each, initially consisting of a single prealloc extent of 400Mb, having
random writes happening at a low rate, lead to a total of over ~17Gb of data
space used, not far from eventually reaching an ENOSPC state.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f914b5d..1ae45bd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -983,7 +983,8 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em)
 		return false;
 
 	next = defrag_lookup_extent(inode, em->start + em->len);
-	if (!next || next->block_start >= EXTENT_MAP_LAST_BYTE)
+	if (!next || next->block_start >= EXTENT_MAP_LAST_BYTE ||
+	    (em->block_start + em->block_len == next->block_start))
 		ret = false;
 
 	free_extent_map(next);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
