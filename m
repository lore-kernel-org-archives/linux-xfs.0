Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 99D087FA7
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 14:24:13 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F460304051
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 12:24:10 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r7MJO9SC002944
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 14:24:09 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130822185026.111080968@sgi.com>
Date: Thu, 22 Aug 2013 13:50:26 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 0/2] xfsprogs: field types in the directory under v4
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

These patches turn on the field types in the directory feature.

Patch one adds the field type feature bit and feature check.
	  this is just like the kernel version.

Patch two adds the feature to mkfs.xfs using a new "-n ftype=1" option.
	  always enable the feature in v5.

These are additions to Dave's Linux 3.12 and field type support patches:
	http://oss.sgi.com/archives/xfs/2013-07/msg00454.html.

01-49-xfsprogs-introduce-xfs_icreate.h.patch
..
47-49-xfs-Add-read-only-support-for-dirent-filetype-field.patch
# patch one below
47-add-dir-filetype-to-inode-v2.patch
48-49-xfs-Add-write-support-for-dirent-filetype-field.patch
49-49-xfsprogs-add-dtype-support-to-mkfs-and-db.patch
# patch two below
49-add-dir-filetype-to-inode-v2.patch

Minor syncing of the 49 patch series is required due to recent commits.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
