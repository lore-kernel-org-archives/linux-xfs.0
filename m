Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AAEF37F51
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 16:07:03 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A0968F8040
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 14:07:00 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r8JL6xmk003420
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 16:06:59 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130919211523.407741285@sgi.com>
Date: Thu, 19 Sep 2013 16:05:23 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 0/3] xfsprogs: v4 inode type in directory
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

Here are the patches that enable the inode in the directory
feature in v4 superblocks.

 patch 1: add the entries to xfs_sb.h (sync with kernel)
 patch 2: add the XFS_FSOP_GEOM_FLAGS_FTYPE to xfs_fs.h (sync with kernel)
	  add the entry to repair so that xfs_info reports the feature
 patch 3: add the feature to mkfs.xfs and manual page.
          note: this new feature is ignored for superblock v5
		automatically turns on this feature.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
