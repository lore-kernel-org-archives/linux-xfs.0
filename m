Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D2A07F4E
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 09:41:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 750298F8037
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 07:41:57 -0700 (PDT)
Received: from mail-pb0-f46.google.com (mail-pb0-f46.google.com
	[209.85.160.46]) by cuda.sgi.com with ESMTP id N6imZM9GBIrd39ae
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 31 Jul 2013 07:41:56 -0700 (PDT)
Received: by mail-pb0-f46.google.com with SMTP id rq2so852432pbb.5
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 07:41:56 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 0/3] fs: New flag FALLOC_FL_COLLAPSE_RANGE for fallocate
Date: Wed, 31 Jul 2013 23:40:29 +0900
Message-Id: <1375281629-15804-1-git-send-email-linkinjeon@gmail.com>
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
To: tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
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
4) It wokrs beyond "EOF", so the extents which are pre-allocated beyond "EOF"
   are also updated.
5) It reduces the i_size of inode by the amount of collapse range which lies
   within i_size. So, if offset >= i_size, i_size won't be changed at all.

This new functionality of collapsing range could be used by media editing tools
which does non linear editing to quickly purge and edit parts of a media file.
This will immensely improve the performance of these operations.
The limitation of fs block size aligned offsets can be easily handled
by media codecs which are encapsulated in a conatiner as they have to
just change the offset to next keyframe value to match the proper alignment.

Namjae Jeon (3):
  fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
  xfs: Implement FALLOC_FL_COLLAPSE_RANGE
  ext4: Implement FALLOC_FL_COLLAPSE_RANGE

-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
