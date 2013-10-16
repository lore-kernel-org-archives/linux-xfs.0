Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ACC037F50
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 17:47:47 -0500 (CDT)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 867DB304032
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 15:47:47 -0700 (PDT)
Received: from eagdhcp-232-150.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-150.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r9GMllL4004632
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 17:47:47 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-150.americas.sgi.com)
Message-Id: <20131016223654.505433792@sgi.com>
Date: Wed, 16 Oct 2013 17:36:54 -0500
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
