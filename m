Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 920E67F5D
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 08:41:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 311A2AC001
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 06:41:19 -0700 (PDT)
Received: from mail-pd0-f177.google.com (mail-pd0-f177.google.com
	[209.85.192.177]) by cuda.sgi.com with ESMTP id
	IraRMbLIXsAqjjiG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Sep 2013 06:41:18 -0700 (PDT)
Received: by mail-pd0-f177.google.com with SMTP id y10so5128110pdj.22
	for <xfs@oss.sgi.com>; Sun, 08 Sep 2013 06:41:17 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v3 0/7] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE) for
	fallocate
Date: Sun,  8 Sep 2013 22:40:46 +0900
Message-Id: <1378647647-2556-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch series is in response of the following post:
http://lwn.net/Articles/556136/
"ext4: introduce two new ioctls"

Dave chinner suggested that truncate_block_range (which was one of the ioctls name)
should be an fallocate operation and not any fs specific ioctl, hence
we add this functionality to fallocate.

This patch series introduces new flag FALLOC_FL_COLLAPSE_RANGE for fallocate
and implements it for XFS and Ext4.

The semantics of this flag are following:
1) It collapses the range lying between offset and length by removing any data
   blocks which are present in this range and than updates all the logical
   offsets of extents beyond "offset + len" to nullify the hole created by
   removing blocks. In short, it does not leave a hole.
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned.

This new functionality of collapsing range could be used by media editing tools
which does non linear editing to quickly purge and edit parts of a media file.
This will immensely improve the performance of these operations.
The limitation of fs block size aligned offsets can be easily handled
by media codecs which are encapsulated in a conatiner as they have to
just change the offset to next keyframe value to match the proper alignment.

Change log
v3:
 Fix checkpatch.pl errors

v2:
 Fix review points from Dave Chinner.
  - merge adjacent extents
  - fix journal log usage.
  - change reasonable function name.
  - update xfsio, xfstest, manpage
  - etc.

Namjae Jeon (7):
  fs: add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
  xfs: add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
  ext4: add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
  xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE for fallocate
  xfstest: Add test case to check various corner cases for collapsing range
  xfstest: Add test case to test multiple collapse range call
  manpage: update FALLOC_FL_COLLAPSE_RANGE flag in fallocate

-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
