Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20852 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdAUINp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:13:45 -0500
Subject: [PATCH 8/9] common/populate: create attrs in different namespaces
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:11:11 -0800
Message-ID: <148498627121.17109.8806204856360094221.stgit@birch.djwong.org>
In-Reply-To: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)


diff --git a/common/populate b/common/populate
index 8602f8a..e99ce68 100644
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

