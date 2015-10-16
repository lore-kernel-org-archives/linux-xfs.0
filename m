Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 414FC7F75
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:19:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEE15AC001
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:19:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NkJFcGwUzBI8cuC0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:19:22 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 07/48] richacl: Permission mapping functions
Date: Fri, 16 Oct 2015 17:17:45 +0200
Message-Id: <1445008706-15115-8-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

We need to map from POSIX permissions to NFSv4 permissions when a
chmod() is done, from NFSv4 permissions to POSIX permissions when an acl
is set (which implicitly sets the file permission bits), and from the
MAY_READ/MAY_WRITE/MAY_EXEC/MAY_APPEND flags to NFSv4 permissions when
doing an access check in a richacl.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/richacl_base.c            | 118 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h      |   3 ++
 include/uapi/linux/richacl.h |  49 ++++++++++++++++++
 3 files changed, 170 insertions(+)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 6d9a073..dd99773 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -65,3 +65,121 @@ richace_copy(struct richace *to, const struct richace *from)
 {
 	memcpy(to, from, sizeof(struct richace));
 }
+
+/*
+ * richacl_mask_to_mode  -  compute the file permission bits from mask
+ * @mask:	%RICHACE_* permission mask
+ *
+ * Compute the file permission bits corresponding to a particular set of
+ * richacl permissions.
+ *
+ * See richacl_masks_to_mode().
+ */
+static int
+richacl_mask_to_mode(unsigned int mask)
+{
+	int mode = 0;
+
+	if (mask & RICHACE_POSIX_MODE_READ)
+		mode |= S_IROTH;
+	if (mask & RICHACE_POSIX_MODE_WRITE)
+		mode |= S_IWOTH;
+	if (mask & RICHACE_POSIX_MODE_EXEC)
+		mode |= S_IXOTH;
+
+	return mode;
+}
+
+/**
+ * richacl_masks_to_mode  -  compute file permission bits from file masks
+ *
+ * When setting a richacl, we set the file permission bits to indicate maximum
+ * permissions: for example, we set the Write permission when a mask contains
+ * RICHACE_APPEND_DATA even if it does not also contain RICHACE_WRITE_DATA.
+ *
+ * Permissions which are not in RICHACE_POSIX_MODE_READ,
+ * RICHACE_POSIX_MODE_WRITE, or RICHACE_POSIX_MODE_EXEC cannot be represented
+ * in the file permission bits.  Such permissions can still be effective, but
+ * not for new files or after a chmod(); they must be explicitly enabled in the
+ * richacl.
+ */
+int
+richacl_masks_to_mode(const struct richacl *acl)
+{
+	return richacl_mask_to_mode(acl->a_owner_mask) << 6 |
+	       richacl_mask_to_mode(acl->a_group_mask) << 3 |
+	       richacl_mask_to_mode(acl->a_other_mask);
+}
+EXPORT_SYMBOL_GPL(richacl_masks_to_mode);
+
+/**
+ * richacl_mode_to_mask  - compute a file mask from the lowest three mode bits
+ * @mode:	mode to convert to richacl permissions
+ *
+ * When the file permission bits of a file are set with chmod(), this specifies
+ * the maximum permissions that processes will get.  All permissions beyond
+ * that will be removed from the file masks, and become ineffective.
+ */
+unsigned int
+richacl_mode_to_mask(umode_t mode)
+{
+	unsigned int mask = 0;
+
+	if (mode & S_IROTH)
+		mask |= RICHACE_POSIX_MODE_READ;
+	if (mode & S_IWOTH)
+		mask |= RICHACE_POSIX_MODE_WRITE;
+	if (mode & S_IXOTH)
+		mask |= RICHACE_POSIX_MODE_EXEC;
+
+	return mask;
+}
+
+/**
+ * richacl_want_to_mask  - convert the iop->permission want argument to a mask
+ * @want:	@want argument of the permission inode operation
+ *
+ * When checking for append, @want is (MAY_WRITE | MAY_APPEND).
+ *
+ * Richacls use the iop->may_create and iop->may_delete hooks which are used
+ * for checking if creating and deleting files is allowed.  These hooks do not
+ * use richacl_want_to_mask(), so we do not have to deal with mapping MAY_WRITE
+ * to RICHACE_ADD_FILE, RICHACE_ADD_SUBDIRECTORY, and RICHACE_DELETE_CHILD
+ * here.
+ */
+unsigned int
+richacl_want_to_mask(unsigned int want)
+{
+	unsigned int mask = 0;
+
+	if (want & MAY_READ)
+		mask |= RICHACE_READ_DATA;
+	if (want & MAY_DELETE_SELF)
+		mask |= RICHACE_DELETE;
+	if (want & MAY_TAKE_OWNERSHIP)
+		mask |= RICHACE_WRITE_OWNER;
+	if (want & MAY_CHMOD)
+		mask |= RICHACE_WRITE_ACL;
+	if (want & MAY_SET_TIMES)
+		mask |= RICHACE_WRITE_ATTRIBUTES;
+	if (want & MAY_EXEC)
+		mask |= RICHACE_EXECUTE;
+	/*
+	 * differentiate MAY_WRITE from these request
+	 */
+	if (want & (MAY_APPEND |
+		    MAY_CREATE_FILE | MAY_CREATE_DIR |
+		    MAY_DELETE_CHILD)) {
+		if (want & MAY_APPEND)
+			mask |= RICHACE_APPEND_DATA;
+		if (want & MAY_CREATE_FILE)
+			mask |= RICHACE_ADD_FILE;
+		if (want & MAY_CREATE_DIR)
+			mask |= RICHACE_ADD_SUBDIRECTORY;
+		if (want & MAY_DELETE_CHILD)
+			mask |= RICHACE_DELETE_CHILD;
+	} else if (want & MAY_WRITE)
+		mask |= RICHACE_WRITE_DATA;
+	return mask;
+}
+EXPORT_SYMBOL_GPL(richacl_want_to_mask);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 6109f84..c75b40c 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -212,5 +212,8 @@ richace_is_same_identifier(const struct richace *a, const struct richace *b)
 extern struct richacl *richacl_alloc(int, gfp_t);
 extern struct richacl *richacl_clone(const struct richacl *, gfp_t);
 extern void richace_copy(struct richace *, const struct richace *);
+extern int richacl_masks_to_mode(const struct richacl *);
+extern unsigned int richacl_mode_to_mask(umode_t);
+extern unsigned int richacl_want_to_mask(unsigned int);
 
 #endif /* __RICHACL_H */
diff --git a/include/uapi/linux/richacl.h b/include/uapi/linux/richacl.h
index de29a17..6887f88 100644
--- a/include/uapi/linux/richacl.h
+++ b/include/uapi/linux/richacl.h
@@ -18,6 +18,9 @@
 #define __UAPI_RICHACL_H
 
 /* a_flags values */
+#define RICHACL_AUTO_INHERIT			0x01
+#define RICHACL_PROTECTED			0x02
+#define RICHACL_DEFAULTED			0x04
 #define RICHACL_WRITE_THROUGH			0x40
 #define RICHACL_MASKED				0x80
 
@@ -31,6 +34,8 @@
 #define RICHACE_NO_PROPAGATE_INHERIT_ACE	0x0004
 #define RICHACE_INHERIT_ONLY_ACE		0x0008
 #define RICHACE_IDENTIFIER_GROUP		0x0040
+#define RICHACE_INHERITED_ACE			0x0080
+#define RICHACE_UNMAPPED_WHO			0x2000
 #define RICHACE_SPECIAL_WHO			0x4000
 
 /* e_mask bitflags */
@@ -59,4 +64,48 @@
 #define RICHACE_GROUP_SPECIAL_ID		1
 #define RICHACE_EVERYONE_SPECIAL_ID		2
 
+/*
+ * The POSIX permissions are supersets of the following richacl permissions:
+ *
+ *  - MAY_READ maps to READ_DATA or LIST_DIRECTORY, depending on the type
+ *    of the file system object.
+ *
+ *  - MAY_WRITE maps to WRITE_DATA or RICHACE_APPEND_DATA for files, and to
+ *    ADD_FILE, RICHACE_ADD_SUBDIRECTORY, or RICHACE_DELETE_CHILD for directories.
+ *
+ *  - MAY_EXECUTE maps to RICHACE_EXECUTE.
+ *
+ *  (Some of these richacl permissions have the same bit values.)
+ */
+#define RICHACE_POSIX_MODE_READ (			\
+		RICHACE_READ_DATA |			\
+		RICHACE_LIST_DIRECTORY)
+#define RICHACE_POSIX_MODE_WRITE (			\
+		RICHACE_WRITE_DATA |			\
+		RICHACE_ADD_FILE |			\
+		RICHACE_APPEND_DATA |			\
+		RICHACE_ADD_SUBDIRECTORY |		\
+		RICHACE_DELETE_CHILD)
+#define RICHACE_POSIX_MODE_EXEC RICHACE_EXECUTE
+#define RICHACE_POSIX_MODE_ALL (			\
+		RICHACE_POSIX_MODE_READ |		\
+		RICHACE_POSIX_MODE_WRITE |		\
+		RICHACE_POSIX_MODE_EXEC)
+
+/*
+ * These permissions are always allowed no matter what the acl says.
+ */
+#define RICHACE_POSIX_ALWAYS_ALLOWED (			\
+		RICHACE_SYNCHRONIZE |			\
+		RICHACE_READ_ATTRIBUTES |		\
+		RICHACE_READ_ACL)
+
+/*
+ * The owner is implicitly granted these permissions under POSIX.
+ */
+#define RICHACE_POSIX_OWNER_ALLOWED (			\
+		RICHACE_WRITE_ATTRIBUTES |		\
+		RICHACE_WRITE_OWNER |			\
+		RICHACE_WRITE_ACL)
+
 #endif /* __UAPI_RICHACL_H */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
