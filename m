Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E9B97F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:14:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E19E0304075
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:14:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zMxH92Kl1umFU7Il for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:14:54 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Tue, 25 Feb 2014 20:14:33 +0100
Message-Id: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com

Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
functionality as xfs ioctl XFS_IOC_ZERO_RANGE.

It can be used to convert a range of file to zeros preferably without
issuing data IO. Blocks should be preallocated for the regions that span
holes in the file, and the entire range is preferable converted to
unwritten extents - even though file system may choose to zero out the
extent or do whatever which will result in reading zeros from the range
while the range remains allocated for the file.

This can be also used to preallocate blocks past EOF in the same way as
with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
size to remain the same.

You can test this feature yourself using xfstests, of fallocate(1) however
you'll need patches for util_linux, xfsprogs and xfstests which are going to
follow soon.

I tested this mostly with a subset of xfstests using fsx and fsstress and
even with new generic/290 which is just a copy of xfs/290 using fzero
command for xfs_io instead of zero (which uses ioctl). I was testing on
x86_64 and ppc64 with block sizes of 1024, 2048 and 4096.

./check generic/076 generic/232 generic/013 generic/070 generic/269 generic/083
generic/117 generic/068 generic/231 generic/127 generic/091 generic/075
generic/112 generic/263 generic/091 generic/075 generic/256 generic/255
generic/316 generic/300 generic/290 ext4/242;

Note that there is a work in progress on FALLOC_FL_COLLAPSE_RANGE which
touches the same area as this pach set does, so we should figure out
which one should go first and modify the other on top of it.

This has been based on top of xfs-collapse-range so it does not contain ext4
collapse range changes.

Thanks!
-Lukas

Changelog:

v2:
 - rebased on top of collapse_range changes
 - make varisou ext4 functions static
 - flag testing changes in do_fallocate

-- 
[PATCH 1/6] ext4: Update inode i_size after the preallocation
[PATCH 2/6] ext4: refactor ext4_fallocate code
[PATCH 3/6] ext4: translate fallocate mode bits to strings
[PATCH 4/6] fs: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
[PATCH 5/6] ext4: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
[PATCH 6/6] xfs: Add support for FALLOC_FL_ZERO_RANGE

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
