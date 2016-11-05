Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17405 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752127AbcKEASL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:18:11 -0400
Subject: [PATCH 9/9] common/populate: create attrs in different namespaces
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:18:06 -0700
Message-ID: <147830508692.1919.4613412398519603461.stgit@birch.djwong.org>
In-Reply-To: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
References: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
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
index 7d103f0..a1987e7 100644
--- a/common/populate
+++ b/common/populate
@@ -160,6 +160,9 @@ _scratch_xfs_populate() {
 	mknod "${SCRATCH_MNT}/S_IFCHR" c 1 1
 	mknod "${SCRATCH_MNT}/S_IFBLK" c 1 1
 
+	# special file with an xattr
+	setfacl -P -m u:nobody:r ${SCRATCH_MNT}/S_IFCHR
+
 	# Attribute formats
 	# LOCAL
 	echo "+ local attr"
@@ -177,6 +180,18 @@ _scratch_xfs_populate() {
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
@@ -299,6 +314,9 @@ _scratch_ext4_populate() {
 	mknod "${SCRATCH_MNT}/S_IFCHR" c 1 1
 	mknod "${SCRATCH_MNT}/S_IFBLK" c 1 1
 
+	# special file with an xattr
+	setfacl -P -m u:nobody:r ${SCRATCH_MNT}/S_IFCHR
+
 	# Attribute formats
 	# LOCAL
 	echo "+ local attr"
@@ -308,6 +326,18 @@ _scratch_ext4_populate() {
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

