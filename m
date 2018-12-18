Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbeLRTJp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 14:09:45 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 62CD613AA1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Dec 2018 19:09:45 +0000 (UTC)
Subject: [PATCH 2/2] xfs: clear XFS_ILOG_[AD]OWNER for non-btree formats
References: <81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <31aaeb46-8fb5-79f5-66bd-d594b9a6cc89@redhat.com>
Date: Tue, 18 Dec 2018 13:09:40 -0600
MIME-Version: 1.0
In-Reply-To: <81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

If an inode had been in btree format and had a data fork owner change
logged, that flag must be cleared if the inode changes format to
non-btree.  Otherwise we hit the old ASSERT (now changed to
corruption detection) in xfs_recover_inode_owner_change() which
enforces that if XFS_ILOG_[AD]OWNER is set, XFS_ILOG_[AD]BROOT
must be as well.

(Or, put more plainly, changing the fork owner is nonsensical
for inodes which have no such fork.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fa1c4fe2ffbf..82a13b7ad321 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -144,7 +144,8 @@ xfs_inode_item_format_data_fork(
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		iip->ili_fields &=
-			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
+			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
+			  XFS_ILOG_DEV | XFS_ILOG_DOWNER);
 
 		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
 		    ip->i_d.di_nextents > 0 &&
@@ -185,7 +186,8 @@ xfs_inode_item_format_data_fork(
 		break;
 	case XFS_DINODE_FMT_LOCAL:
 		iip->ili_fields &=
-			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
+			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
+			  XFS_ILOG_DEV | XFS_ILOG_DOWNER);
 		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0) {
 			/*
@@ -206,7 +208,8 @@ xfs_inode_item_format_data_fork(
 		break;
 	case XFS_DINODE_FMT_DEV:
 		iip->ili_fields &=
-			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEXT);
+			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
+			  XFS_ILOG_DEXT | XFS_ILOG_DOWNER);
 		if (iip->ili_fields & XFS_ILOG_DEV)
 			ilf->ilf_u.ilfu_rdev = sysv_encode_dev(VFS_I(ip)->i_rdev);
 		break;
@@ -229,7 +232,7 @@ xfs_inode_item_format_attr_fork(
 	switch (ip->i_d.di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
 		iip->ili_fields &=
-			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
+			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AOWNER);
 
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
 		    ip->i_d.di_anextents > 0 &&
@@ -268,7 +271,7 @@ xfs_inode_item_format_attr_fork(
 		break;
 	case XFS_DINODE_FMT_LOCAL:
 		iip->ili_fields &=
-			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
+			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT | XFS_ILOG_AOWNER);
 
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_afp->if_bytes > 0) {
