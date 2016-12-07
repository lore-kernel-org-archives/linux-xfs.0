Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23806 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752018AbcLGATU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 19:19:20 -0500
Subject: [PATCH 10/11] common/populate: create attrs in different namespaces
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Dec 2016 16:19:14 -0800
Message-ID: <148106995441.19334.5444383157369397166.stgit@birch.djwong.org>
In-Reply-To: <148106989109.19334.6839386416313318071.stgit@birch.djwong.org>
References: <148106989109.19334.6839386416313318071.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)


diff --git a/common/populate b/common/populate
index 0e6bcfd..f0a9f68 100644
--- a/common/populate
+++ b/common/populate
@@ -166,6 +166,9 @@ _scratch_xfs_populate() {
 	mknod "${SCRATCH_MNT}/S_IFCHR" c 1 1
 	mknod "${SCRATCH_MNT}/S_IFBLK" c 1 1
 
+	# special file with an xattr
+	setfacl -P -m u:nobody:r ${SCRATCH_MNT}/S_IFCHR
+
 	# Attribute formats
 	# LOCAL
 	echo "+ local attr"
@@ -183,6 +186,18 @@ _scratch_xfs_populate() {
 	echo "+ btree attr"
 	__populate_create_attr "${SCRATCH_MNT}/ATTR.FMT_BTREE" "$((64 * blksz / 40))" true
 
+	# trusted namespace
+	touch ${SCRATCH_MNT}/ATTR.TRUSTED
+	setfattr -n trusted.moo -v urk ${SCRATCH_MNT}/ATTR.TRUSTED
+
+	# security namespace
+	touch ${SCRATCH_MNT}/ATTR.SECURITY
+	setfattr -n security.foo -v bar ${SCRATCH_MNT}/ATTR.SECURITY
+
+	# system namespace
+	touch ${SCRATCH_MNT}/ATTR.SYSTEM
+	setfacl -m u:root:r ${SCRATCH_MNT}/ATTR.SYSTEM
+
 	# FMT_EXTENTS with a remote less-than-a-block value
 	echo "+ attr extents with a remote less-than-a-block value"
 	touch "${SCRATCH_MNT}/ATTR.FMT_EXTENTS_REMOTE3K"
@@ -305,6 +320,9 @@ _scratch_ext4_populate() {
 	mknod "${SCRATCH_MNT}/S_IFCHR" c 1 1
 	mknod "${SCRATCH_MNT}/S_IFBLK" c 1 1
 
+	# special file with an xattr
+	setfacl -P -m u:nobody:r ${SCRATCH_MNT}/S_IFCHR
+
 	# Attribute formats
 	# LOCAL
 	echo "+ local attr"
@@ -314,6 +332,18 @@ _scratch_ext4_populate() {
 	echo "+ block attr"
 	__populate_create_attr "${SCRATCH_MNT}/ATTR.FMT_BLOCK" "$((blksz / 40))"
 
+	# trusted namespace
+	touch ${SCRATCH_MNT}/ATTR.TRUSTED
+	setfattr -n trusted.moo -v urk ${SCRATCH_MNT}/ATTR.TRUSTED
+
+	# security namespace
+	touch ${SCRATCH_MNT}/ATTR.SECURITY
+	setfattr -n security.foo -v bar ${SCRATCH_MNT}/ATTR.SECURITY
+
+	# system namespace
+	touch ${SCRATCH_MNT}/ATTR.SYSTEM
+	setfacl -m u:root:r ${SCRATCH_MNT}/ATTR.SYSTEM
+
 	# Make an unused inode
 	echo "+ empty file"
 	touch "${SCRATCH_MNT}/unused"

