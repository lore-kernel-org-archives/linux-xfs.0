Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6015F8004
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:22:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22BAE304053
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:22:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vwd5KkQ5EAYl7sEp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:22:20 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 34/48] nfsd: Use richacls as internal acl representation
Date: Fri, 16 Oct 2015 17:18:12 +0200
Message-Id: <1445008706-15115-35-git-send-email-agruenba@redhat.com>
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

When converting from NFSv4 ACLs to POSIX ACLs, nfsd so far was using
struct nfs4_acl as its internal representation. This representation is a
subset of richacls, so get rid of struct nfs4_acl. Richacls even have a
more compact in-memory representation, so a few more ACL entries can
easily be supported.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Acked-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/Kconfig              |   6 +
 fs/nfs_common/Makefile  |   1 +
 fs/nfs_common/nfs4acl.c |  44 ++++++
 fs/nfsd/Kconfig         |   1 +
 fs/nfsd/acl.h           |  24 ++--
 fs/nfsd/nfs4acl.c       | 368 ++++++++++++++++++++++--------------------------
 fs/nfsd/nfs4proc.c      |  15 +-
 fs/nfsd/nfs4xdr.c       |  64 +++------
 fs/nfsd/xdr4.h          |   6 +-
 include/linux/nfs4.h    |  23 ---
 include/linux/nfs4acl.h |   7 +
 11 files changed, 274 insertions(+), 285 deletions(-)
 create mode 100644 fs/nfs_common/nfs4acl.c
 create mode 100644 include/linux/nfs4acl.h

diff --git a/fs/Kconfig b/fs/Kconfig
index bff2879..68bc3e1 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -265,6 +265,12 @@ config NFS_COMMON
 	depends on NFSD || NFS_FS || LOCKD
 	default y
 
+config NFS_RICHACL
+	bool
+	depends on NFSD_V4 || NFS_V4
+	select FS_RICHACL
+	default y
+
 source "net/sunrpc/Kconfig"
 source "fs/ceph/Kconfig"
 source "fs/cifs/Kconfig"
diff --git a/fs/nfs_common/Makefile b/fs/nfs_common/Makefile
index d153ca3..e055139 100644
--- a/fs/nfs_common/Makefile
+++ b/fs/nfs_common/Makefile
@@ -4,5 +4,6 @@
 
 obj-$(CONFIG_NFS_ACL_SUPPORT) += nfs_acl.o
 nfs_acl-objs := nfsacl.o
+obj-$(CONFIG_NFS_RICHACL) += nfs4acl.o
 
 obj-$(CONFIG_GRACE_PERIOD) += grace.o
diff --git a/fs/nfs_common/nfs4acl.c b/fs/nfs_common/nfs4acl.c
new file mode 100644
index 0000000..02df064
--- /dev/null
+++ b/fs/nfs_common/nfs4acl.c
@@ -0,0 +1,44 @@
+#include <linux/fs.h>
+#include <linux/richacl.h>
+#include <linux/nfs4acl.h>
+
+static struct special_id {
+	char *who;
+	int   len;
+} special_who_map[] = {
+	[RICHACE_OWNER_SPECIAL_ID] = {
+		.who = "OWNER@",
+		.len = sizeof("OWNER@") - 1 },
+	[RICHACE_GROUP_SPECIAL_ID] = {
+		.who = "GROUP@",
+		.len = sizeof("GROUP@") - 1 },
+	[RICHACE_EVERYONE_SPECIAL_ID] = {
+		.who = "EVERYONE@",
+		.len = sizeof("EVERYONE@") - 1 }
+};
+
+int nfs4acl_who_to_special_id(const char *who, u32 len)
+{
+	int n;
+
+	for (n = 0; n < ARRAY_SIZE(special_who_map); n++) {
+		if (len == special_who_map[n].len &&
+		    !memcmp(who, special_who_map[n].who, len))
+			return n;
+	}
+	return -1;
+}
+EXPORT_SYMBOL(nfs4acl_who_to_special_id);
+
+bool nfs4acl_special_id_to_who(unsigned int special_who,
+			       const char **who, unsigned int *len)
+{
+	struct special_id *special = &special_who_map[special_who];
+
+	if (special_who > ARRAY_SIZE(special_who_map) || !special->len)
+		return false;
+	*who = special->who;
+	*len = special->len;
+	return true;
+}
+EXPORT_SYMBOL(nfs4acl_special_id_to_who);
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index a0b77fc..811379a 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -70,6 +70,7 @@ config NFSD_V4
 	depends on NFSD && PROC_FS
 	select NFSD_V3
 	select FS_POSIX_ACL
+	select FS_RICHACL
 	select SUNRPC_GSS
 	select CRYPTO
 	select GRACE_PERIOD
diff --git a/fs/nfsd/acl.h b/fs/nfsd/acl.h
index 4cd7c69..1c5deb5 100644
--- a/fs/nfsd/acl.h
+++ b/fs/nfsd/acl.h
@@ -35,25 +35,27 @@
 #ifndef LINUX_NFS4_ACL_H
 #define LINUX_NFS4_ACL_H
 
-struct nfs4_acl;
+struct richacl;
+struct richace;
 struct svc_fh;
 struct svc_rqst;
 
 /*
  * Maximum ACL we'll accept from a client; chosen (somewhat
  * arbitrarily) so that kmalloc'ing the ACL shouldn't require a
- * high-order allocation.  This allows 204 ACEs on x86_64:
+ * high-order allocation.  This allows 339 ACEs on x86_64:
  */
-#define NFS4_ACL_MAX ((PAGE_SIZE - sizeof(struct nfs4_acl)) \
-			/ sizeof(struct nfs4_ace))
+#define NFSD4_ACL_MAX ((PAGE_SIZE - sizeof(struct richacl)) \
+			/ sizeof(struct richace))
 
-int nfs4_acl_bytes(int entries);
-int nfs4_acl_get_whotype(char *, u32);
-__be32 nfs4_acl_write_who(struct xdr_stream *xdr, int who);
+__be32 nfsd4_decode_ace_who(struct richace *ace, struct svc_rqst *rqstp,
+			    char *who, u32 len);
+__be32 nfsd4_encode_ace_who(struct xdr_stream *xdr, struct svc_rqst *rqstp,
+			    struct richace *ace);
 
-int nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry,
-		struct nfs4_acl **acl);
-__be32 nfsd4_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct nfs4_acl *acl);
+int nfsd4_get_acl(struct svc_rqst *rqstp, struct dentry *dentry,
+		  struct richacl **acl);
+__be32 nfsd4_set_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		     struct richacl *acl);
 
 #endif /* LINUX_NFS4_ACL_H */
diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index 6adabd6..6d3bb72 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -37,46 +37,50 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/posix_acl.h>
+#include <linux/nfs_fs.h>
+#include <linux/richacl_compat.h>
+#include <linux/nfs4acl.h>
 
 #include "nfsfh.h"
 #include "nfsd.h"
+#include "idmap.h"
 #include "acl.h"
 #include "vfs.h"
 
-#define NFS4_ACL_TYPE_DEFAULT	0x01
-#define NFS4_ACL_DIR		0x02
-#define NFS4_ACL_OWNER		0x04
+#define FLAG_DEFAULT_ACL	0x01
+#define FLAG_DIRECTORY		0x02
+#define FLAG_OWNER		0x04
 
 /* mode bit translations: */
-#define NFS4_READ_MODE (NFS4_ACE_READ_DATA)
-#define NFS4_WRITE_MODE (NFS4_ACE_WRITE_DATA | NFS4_ACE_APPEND_DATA)
-#define NFS4_EXECUTE_MODE NFS4_ACE_EXECUTE
-#define NFS4_ANYONE_MODE (NFS4_ACE_READ_ATTRIBUTES | NFS4_ACE_READ_ACL | NFS4_ACE_SYNCHRONIZE)
-#define NFS4_OWNER_MODE (NFS4_ACE_WRITE_ATTRIBUTES | NFS4_ACE_WRITE_ACL)
+#define RICHACE_READ_MODE (RICHACE_READ_DATA)
+#define RICHACE_WRITE_MODE (RICHACE_WRITE_DATA | RICHACE_APPEND_DATA)
+#define RICHACE_EXECUTE_MODE RICHACE_EXECUTE
+#define RICHACE_ANYONE_MODE (RICHACE_READ_ATTRIBUTES | RICHACE_READ_ACL | RICHACE_SYNCHRONIZE)
+#define RICHACE_OWNER_MODE (RICHACE_WRITE_ATTRIBUTES | RICHACE_WRITE_ACL)
 
 /* flags used to simulate posix default ACLs */
-#define NFS4_INHERITANCE_FLAGS (NFS4_ACE_FILE_INHERIT_ACE \
-		| NFS4_ACE_DIRECTORY_INHERIT_ACE)
-
-#define NFS4_SUPPORTED_FLAGS (NFS4_INHERITANCE_FLAGS \
-		| NFS4_ACE_INHERIT_ONLY_ACE \
-		| NFS4_ACE_IDENTIFIER_GROUP)
+#define RICHACE_SUPPORTED_FLAGS (		\
+	RICHACE_FILE_INHERIT_ACE |		\
+	RICHACE_DIRECTORY_INHERIT_ACE |		\
+	RICHACE_INHERIT_ONLY_ACE |		\
+	RICHACE_IDENTIFIER_GROUP |		\
+	RICHACE_SPECIAL_WHO)
 
 static u32
 mask_from_posix(unsigned short perm, unsigned int flags)
 {
-	int mask = NFS4_ANYONE_MODE;
+	int mask = RICHACE_ANYONE_MODE;
 
-	if (flags & NFS4_ACL_OWNER)
-		mask |= NFS4_OWNER_MODE;
+	if (flags & FLAG_OWNER)
+		mask |= RICHACE_OWNER_MODE;
 	if (perm & ACL_READ)
-		mask |= NFS4_READ_MODE;
+		mask |= RICHACE_READ_MODE;
 	if (perm & ACL_WRITE)
-		mask |= NFS4_WRITE_MODE;
-	if ((perm & ACL_WRITE) && (flags & NFS4_ACL_DIR))
-		mask |= NFS4_ACE_DELETE_CHILD;
+		mask |= RICHACE_WRITE_MODE;
+	if ((perm & ACL_WRITE) && (flags & FLAG_DIRECTORY))
+		mask |= RICHACE_DELETE_CHILD;
 	if (perm & ACL_EXECUTE)
-		mask |= NFS4_EXECUTE_MODE;
+		mask |= RICHACE_EXECUTE_MODE;
 	return mask;
 }
 
@@ -86,13 +90,13 @@ deny_mask_from_posix(unsigned short perm, u32 flags)
 	u32 mask = 0;
 
 	if (perm & ACL_READ)
-		mask |= NFS4_READ_MODE;
+		mask |= RICHACE_READ_MODE;
 	if (perm & ACL_WRITE)
-		mask |= NFS4_WRITE_MODE;
-	if ((perm & ACL_WRITE) && (flags & NFS4_ACL_DIR))
-		mask |= NFS4_ACE_DELETE_CHILD;
+		mask |= RICHACE_WRITE_MODE;
+	if ((perm & ACL_WRITE) && (flags & FLAG_DIRECTORY))
+		mask |= RICHACE_DELETE_CHILD;
 	if (perm & ACL_EXECUTE)
-		mask |= NFS4_EXECUTE_MODE;
+		mask |= RICHACE_EXECUTE_MODE;
 	return mask;
 }
 
@@ -108,32 +112,33 @@ deny_mask_from_posix(unsigned short perm, u32 flags)
 static void
 low_mode_from_nfs4(u32 perm, unsigned short *mode, unsigned int flags)
 {
-	u32 write_mode = NFS4_WRITE_MODE;
+	u32 write_mode = RICHACE_WRITE_MODE;
 
-	if (flags & NFS4_ACL_DIR)
-		write_mode |= NFS4_ACE_DELETE_CHILD;
+	if (flags & FLAG_DIRECTORY)
+		write_mode |= RICHACE_DELETE_CHILD;
 	*mode = 0;
-	if ((perm & NFS4_READ_MODE) == NFS4_READ_MODE)
+	if ((perm & RICHACE_READ_MODE) == RICHACE_READ_MODE)
 		*mode |= ACL_READ;
 	if ((perm & write_mode) == write_mode)
 		*mode |= ACL_WRITE;
-	if ((perm & NFS4_EXECUTE_MODE) == NFS4_EXECUTE_MODE)
+	if ((perm & RICHACE_EXECUTE_MODE) == RICHACE_EXECUTE_MODE)
 		*mode |= ACL_EXECUTE;
 }
 
-static short ace2type(struct nfs4_ace *);
-static void _posix_to_nfsv4_one(struct posix_acl *, struct nfs4_acl *,
+static short ace2type(struct richace *);
+static void _posix_to_richacl_one(struct posix_acl *, struct richacl_alloc *,
 				unsigned int);
 
 int
-nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry,
-		struct nfs4_acl **acl)
+nfsd4_get_acl(struct svc_rqst *rqstp, struct dentry *dentry,
+	      struct richacl **acl)
 {
 	struct inode *inode = d_inode(dentry);
 	int error = 0;
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
+	struct richacl_alloc alloc;
 	unsigned int flags = 0;
-	int size = 0;
+	int count;
 
 	pacl = get_acl(inode, ACL_TYPE_ACCESS);
 	if (!pacl)
@@ -143,10 +148,10 @@ nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry,
 		return PTR_ERR(pacl);
 
 	/* allocate for worst case: one (deny, allow) pair each: */
-	size += 2 * pacl->a_count;
+	count = 2 * pacl->a_count;
 
 	if (S_ISDIR(inode->i_mode)) {
-		flags = NFS4_ACL_DIR;
+		flags = FLAG_DIRECTORY;
 		dpacl = get_acl(inode, ACL_TYPE_DEFAULT);
 		if (IS_ERR(dpacl)) {
 			error = PTR_ERR(dpacl);
@@ -154,20 +159,20 @@ nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry,
 		}
 
 		if (dpacl)
-			size += 2 * dpacl->a_count;
+			count += 2 * dpacl->a_count;
 	}
 
-	*acl = kmalloc(nfs4_acl_bytes(size), GFP_KERNEL);
-	if (*acl == NULL) {
+	if (!richacl_prepare(&alloc, count)) {
 		error = -ENOMEM;
 		goto out;
 	}
-	(*acl)->naces = 0;
 
-	_posix_to_nfsv4_one(pacl, *acl, flags & ~NFS4_ACL_TYPE_DEFAULT);
+	_posix_to_richacl_one(pacl, &alloc, flags);
 
 	if (dpacl)
-		_posix_to_nfsv4_one(dpacl, *acl, flags | NFS4_ACL_TYPE_DEFAULT);
+		_posix_to_richacl_one(dpacl, &alloc, flags | FLAG_DEFAULT_ACL);
+
+	*acl = alloc.acl;
 
 out:
 	posix_acl_release(dpacl);
@@ -230,21 +235,22 @@ summarize_posix_acl(struct posix_acl *acl, struct posix_acl_summary *pas)
 
 /* We assume the acl has been verified with posix_acl_valid. */
 static void
-_posix_to_nfsv4_one(struct posix_acl *pacl, struct nfs4_acl *acl,
-						unsigned int flags)
+_posix_to_richacl_one(struct posix_acl *pacl, struct richacl_alloc *alloc,
+		unsigned int flags)
 {
 	struct posix_acl_entry *pa, *group_owner_entry;
-	struct nfs4_ace *ace;
+	struct richace *ace;
 	struct posix_acl_summary pas;
 	unsigned short deny;
-	int eflag = ((flags & NFS4_ACL_TYPE_DEFAULT) ?
-		NFS4_INHERITANCE_FLAGS | NFS4_ACE_INHERIT_ONLY_ACE : 0);
+	int e_flags = ((flags & FLAG_DEFAULT_ACL) ?
+		       (RICHACE_FILE_INHERIT_ACE |
+		        RICHACE_DIRECTORY_INHERIT_ACE |
+		        RICHACE_INHERIT_ONLY_ACE) : 0);
 
 	BUG_ON(pacl->a_count < 3);
 	summarize_posix_acl(pacl, &pas);
 
 	pa = pacl->a_entries;
-	ace = acl->aces + acl->naces;
 
 	/* We could deny everything not granted by the owner: */
 	deny = ~pas.owner;
@@ -254,42 +260,35 @@ _posix_to_nfsv4_one(struct posix_acl *pacl, struct nfs4_acl *acl,
 	 */
 	deny &= pas.users | pas.group | pas.groups | pas.other;
 	if (deny) {
-		ace->type = NFS4_ACE_ACCESS_DENIED_ACE_TYPE;
-		ace->flag = eflag;
-		ace->access_mask = deny_mask_from_posix(deny, flags);
-		ace->whotype = NFS4_ACL_WHO_OWNER;
-		ace++;
-		acl->naces++;
+		ace = richacl_append_entry(alloc);
+		ace->e_type = RICHACE_ACCESS_DENIED_ACE_TYPE;
+		ace->e_flags = e_flags | RICHACE_SPECIAL_WHO;
+		ace->e_mask = deny_mask_from_posix(deny, flags);
+		ace->e_id.special = RICHACE_OWNER_SPECIAL_ID;
 	}
 
-	ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
-	ace->flag = eflag;
-	ace->access_mask = mask_from_posix(pa->e_perm, flags | NFS4_ACL_OWNER);
-	ace->whotype = NFS4_ACL_WHO_OWNER;
-	ace++;
-	acl->naces++;
+	ace = richacl_append_entry(alloc);
+	ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+	ace->e_flags = e_flags | RICHACE_SPECIAL_WHO;
+	ace->e_mask = mask_from_posix(pa->e_perm, flags | FLAG_OWNER);
+	ace->e_id.special = RICHACE_OWNER_SPECIAL_ID;
 	pa++;
 
 	while (pa->e_tag == ACL_USER) {
 		deny = ~(pa->e_perm & pas.mask);
 		deny &= pas.groups | pas.group | pas.other;
 		if (deny) {
-			ace->type = NFS4_ACE_ACCESS_DENIED_ACE_TYPE;
-			ace->flag = eflag;
-			ace->access_mask = deny_mask_from_posix(deny, flags);
-			ace->whotype = NFS4_ACL_WHO_NAMED;
-			ace->who_uid = pa->e_uid;
-			ace++;
-			acl->naces++;
+			ace = richacl_append_entry(alloc);
+			ace->e_type = RICHACE_ACCESS_DENIED_ACE_TYPE;
+			ace->e_flags = e_flags;
+			ace->e_mask = deny_mask_from_posix(deny, flags);
+			ace->e_id.uid = pa->e_uid;
 		}
-		ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
-		ace->flag = eflag;
-		ace->access_mask = mask_from_posix(pa->e_perm & pas.mask,
-						   flags);
-		ace->whotype = NFS4_ACL_WHO_NAMED;
-		ace->who_uid = pa->e_uid;
-		ace++;
-		acl->naces++;
+		ace = richacl_append_entry(alloc);
+		ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+		ace->e_flags = e_flags;
+		ace->e_mask = mask_from_posix(pa->e_perm & pas.mask, flags);
+		ace->e_id.uid = pa->e_uid;
 		pa++;
 	}
 
@@ -300,23 +299,19 @@ _posix_to_nfsv4_one(struct posix_acl *pacl, struct nfs4_acl *acl,
 
 	group_owner_entry = pa;
 
-	ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
-	ace->flag = eflag;
-	ace->access_mask = mask_from_posix(pas.group, flags);
-	ace->whotype = NFS4_ACL_WHO_GROUP;
-	ace++;
-	acl->naces++;
+	ace = richacl_append_entry(alloc);
+	ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+	ace->e_flags = e_flags | RICHACE_SPECIAL_WHO;
+	ace->e_mask = mask_from_posix(pas.group, flags);
+	ace->e_id.special = RICHACE_GROUP_SPECIAL_ID;
 	pa++;
 
 	while (pa->e_tag == ACL_GROUP) {
-		ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
-		ace->flag = eflag | NFS4_ACE_IDENTIFIER_GROUP;
-		ace->access_mask = mask_from_posix(pa->e_perm & pas.mask,
-						   flags);
-		ace->whotype = NFS4_ACL_WHO_NAMED;
-		ace->who_gid = pa->e_gid;
-		ace++;
-		acl->naces++;
+		ace = richacl_append_entry(alloc);
+		ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+		ace->e_flags = e_flags | RICHACE_IDENTIFIER_GROUP;
+		ace->e_mask = mask_from_posix(pa->e_perm & pas.mask, flags);
+		ace->e_id.gid = pa->e_gid;
 		pa++;
 	}
 
@@ -326,12 +321,11 @@ _posix_to_nfsv4_one(struct posix_acl *pacl, struct nfs4_acl *acl,
 
 	deny = ~pas.group & pas.other;
 	if (deny) {
-		ace->type = NFS4_ACE_ACCESS_DENIED_ACE_TYPE;
-		ace->flag = eflag;
-		ace->access_mask = deny_mask_from_posix(deny, flags);
-		ace->whotype = NFS4_ACL_WHO_GROUP;
-		ace++;
-		acl->naces++;
+		ace = richacl_append_entry(alloc);
+		ace->e_type = RICHACE_ACCESS_DENIED_ACE_TYPE;
+		ace->e_flags = e_flags | RICHACE_SPECIAL_WHO;
+		ace->e_mask = deny_mask_from_posix(deny, flags);
+		ace->e_id.special = RICHACE_GROUP_SPECIAL_ID;
 	}
 	pa++;
 
@@ -339,24 +333,22 @@ _posix_to_nfsv4_one(struct posix_acl *pacl, struct nfs4_acl *acl,
 		deny = ~(pa->e_perm & pas.mask);
 		deny &= pas.other;
 		if (deny) {
-			ace->type = NFS4_ACE_ACCESS_DENIED_ACE_TYPE;
-			ace->flag = eflag | NFS4_ACE_IDENTIFIER_GROUP;
-			ace->access_mask = deny_mask_from_posix(deny, flags);
-			ace->whotype = NFS4_ACL_WHO_NAMED;
-			ace->who_gid = pa->e_gid;
-			ace++;
-			acl->naces++;
+			ace = richacl_append_entry(alloc);
+			ace->e_type = RICHACE_ACCESS_DENIED_ACE_TYPE;
+			ace->e_flags = e_flags | RICHACE_IDENTIFIER_GROUP;
+			ace->e_mask = deny_mask_from_posix(deny, flags);
+			ace->e_id.gid = pa->e_gid;
 		}
 		pa++;
 	}
 
 	if (pa->e_tag == ACL_MASK)
 		pa++;
-	ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
-	ace->flag = eflag;
-	ace->access_mask = mask_from_posix(pa->e_perm, flags);
-	ace->whotype = NFS4_ACL_WHO_EVERYONE;
-	acl->naces++;
+	ace = richacl_append_entry(alloc);
+	ace->e_type = RICHACE_ACCESS_ALLOWED_ACE_TYPE;
+	ace->e_flags = e_flags | RICHACE_SPECIAL_WHO;
+	ace->e_mask = mask_from_posix(pa->e_perm, flags);
+	ace->e_id.special = RICHACE_EVERYONE_SPECIAL_ID;
 }
 
 static bool
@@ -500,7 +492,7 @@ posix_state_to_acl(struct posix_acl_state *state, unsigned int flags)
 	 * and effective cases: when there are no inheritable ACEs,
 	 * calls ->set_acl with a NULL ACL structure.
 	 */
-	if (state->empty && (flags & NFS4_ACL_TYPE_DEFAULT))
+	if (state->empty && (flags & FLAG_DEFAULT_ACL))
 		return NULL;
 
 	/*
@@ -619,24 +611,24 @@ static void allow_bits_array(struct posix_ace_state_array *a, u32 mask)
 }
 
 static void process_one_v4_ace(struct posix_acl_state *state,
-				struct nfs4_ace *ace)
+				struct richace *ace)
 {
-	u32 mask = ace->access_mask;
+	u32 mask = ace->e_mask;
 	int i;
 
 	state->empty = 0;
 
 	switch (ace2type(ace)) {
 	case ACL_USER_OBJ:
-		if (ace->type == NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE) {
+		if (ace->e_type == RICHACE_ACCESS_ALLOWED_ACE_TYPE) {
 			allow_bits(&state->owner, mask);
 		} else {
 			deny_bits(&state->owner, mask);
 		}
 		break;
 	case ACL_USER:
-		i = find_uid(state, ace->who_uid);
-		if (ace->type == NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE) {
+		i = find_uid(state, ace->e_id.uid);
+		if (ace->e_type == RICHACE_ACCESS_ALLOWED_ACE_TYPE) {
 			allow_bits(&state->users->aces[i].perms, mask);
 		} else {
 			deny_bits(&state->users->aces[i].perms, mask);
@@ -645,7 +637,7 @@ static void process_one_v4_ace(struct posix_acl_state *state,
 		}
 		break;
 	case ACL_GROUP_OBJ:
-		if (ace->type == NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE) {
+		if (ace->e_type == RICHACE_ACCESS_ALLOWED_ACE_TYPE) {
 			allow_bits(&state->group, mask);
 		} else {
 			deny_bits(&state->group, mask);
@@ -657,8 +649,8 @@ static void process_one_v4_ace(struct posix_acl_state *state,
 		}
 		break;
 	case ACL_GROUP:
-		i = find_gid(state, ace->who_gid);
-		if (ace->type == NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE) {
+		i = find_gid(state, ace->e_id.gid);
+		if (ace->e_type == RICHACE_ACCESS_ALLOWED_ACE_TYPE) {
 			allow_bits(&state->groups->aces[i].perms, mask);
 		} else {
 			deny_bits(&state->groups->aces[i].perms, mask);
@@ -671,7 +663,7 @@ static void process_one_v4_ace(struct posix_acl_state *state,
 		}
 		break;
 	case ACL_OTHER:
-		if (ace->type == NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE) {
+		if (ace->e_type == RICHACE_ACCESS_ALLOWED_ACE_TYPE) {
 			allow_bits(&state->owner, mask);
 			allow_bits(&state->group, mask);
 			allow_bits(&state->other, mask);
@@ -689,32 +681,33 @@ static void process_one_v4_ace(struct posix_acl_state *state,
 	}
 }
 
-static int nfs4_acl_nfsv4_to_posix(struct nfs4_acl *acl,
+static int nfs4_richacl_to_posix(struct richacl *acl,
 		struct posix_acl **pacl, struct posix_acl **dpacl,
 		unsigned int flags)
 {
 	struct posix_acl_state effective_acl_state, default_acl_state;
-	struct nfs4_ace *ace;
+	struct richace *ace;
 	int ret;
 
-	ret = init_state(&effective_acl_state, acl->naces);
+	ret = init_state(&effective_acl_state, acl->a_count);
 	if (ret)
 		return ret;
-	ret = init_state(&default_acl_state, acl->naces);
+	ret = init_state(&default_acl_state, acl->a_count);
 	if (ret)
 		goto out_estate;
 	ret = -EINVAL;
-	for (ace = acl->aces; ace < acl->aces + acl->naces; ace++) {
-		if (ace->type != NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE &&
-		    ace->type != NFS4_ACE_ACCESS_DENIED_ACE_TYPE)
+	richacl_for_each_entry(ace, acl) {
+		if (ace->e_type != RICHACE_ACCESS_ALLOWED_ACE_TYPE &&
+		    ace->e_type != RICHACE_ACCESS_DENIED_ACE_TYPE)
 			goto out_dstate;
-		if (ace->flag & ~NFS4_SUPPORTED_FLAGS)
+		if (ace->e_flags & ~RICHACE_SUPPORTED_FLAGS)
 			goto out_dstate;
-		if ((ace->flag & NFS4_INHERITANCE_FLAGS) == 0) {
+		if ((ace->e_flags & (RICHACE_FILE_INHERIT_ACE |
+				     RICHACE_DIRECTORY_INHERIT_ACE)) == 0) {
 			process_one_v4_ace(&effective_acl_state, ace);
 			continue;
 		}
-		if (!(flags & NFS4_ACL_DIR))
+		if (!(flags & FLAG_DIRECTORY))
 			goto out_dstate;
 		/*
 		 * Note that when only one of FILE_INHERIT or DIRECTORY_INHERIT
@@ -723,7 +716,7 @@ static int nfs4_acl_nfsv4_to_posix(struct nfs4_acl *acl,
 		 */
 		process_one_v4_ace(&default_acl_state, ace);
 
-		if (!(ace->flag & NFS4_ACE_INHERIT_ONLY_ACE))
+		if (!(ace->e_flags & RICHACE_INHERIT_ONLY_ACE))
 			process_one_v4_ace(&effective_acl_state, ace);
 	}
 	*pacl = posix_state_to_acl(&effective_acl_state, flags);
@@ -733,7 +726,7 @@ static int nfs4_acl_nfsv4_to_posix(struct nfs4_acl *acl,
 		goto out_dstate;
 	}
 	*dpacl = posix_state_to_acl(&default_acl_state,
-						flags | NFS4_ACL_TYPE_DEFAULT);
+						flags | FLAG_DEFAULT_ACL);
 	if (IS_ERR(*dpacl)) {
 		ret = PTR_ERR(*dpacl);
 		*dpacl = NULL;
@@ -752,8 +745,7 @@ out_estate:
 }
 
 __be32
-nfsd4_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct nfs4_acl *acl)
+nfsd4_set_acl(struct svc_rqst *rqstp, struct svc_fh *fhp, struct richacl *acl)
 {
 	__be32 error;
 	int host_error;
@@ -774,9 +766,9 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		return nfserr_attrnotsupp;
 
 	if (S_ISDIR(inode->i_mode))
-		flags = NFS4_ACL_DIR;
+		flags = FLAG_DIRECTORY;
 
-	host_error = nfs4_acl_nfsv4_to_posix(acl, &pacl, &dpacl, flags);
+	host_error = nfs4_richacl_to_posix(acl, &pacl, &dpacl, flags);
 	if (host_error == -EINVAL)
 		return nfserr_attrnotsupp;
 	if (host_error < 0)
@@ -803,82 +795,62 @@ out_nfserr:
 
 
 static short
-ace2type(struct nfs4_ace *ace)
+ace2type(struct richace *ace)
 {
-	switch (ace->whotype) {
-		case NFS4_ACL_WHO_NAMED:
-			return (ace->flag & NFS4_ACE_IDENTIFIER_GROUP ?
-					ACL_GROUP : ACL_USER);
-		case NFS4_ACL_WHO_OWNER:
+	if (ace->e_flags & RICHACE_SPECIAL_WHO) {
+		switch (ace->e_id.special) {
+		case RICHACE_OWNER_SPECIAL_ID:
 			return ACL_USER_OBJ;
-		case NFS4_ACL_WHO_GROUP:
+		case RICHACE_GROUP_SPECIAL_ID:
 			return ACL_GROUP_OBJ;
-		case NFS4_ACL_WHO_EVERYONE:
+		case RICHACE_EVERYONE_SPECIAL_ID:
 			return ACL_OTHER;
+		default:
+			BUG();
+		}
 	}
-	BUG();
-	return -1;
-}
-
-/*
- * return the size of the struct nfs4_acl required to represent an acl
- * with @entries entries.
- */
-int nfs4_acl_bytes(int entries)
-{
-	return sizeof(struct nfs4_acl) + entries * sizeof(struct nfs4_ace);
+	return ace->e_flags & RICHACE_IDENTIFIER_GROUP ? ACL_GROUP : ACL_USER;
 }
 
-static struct {
-	char *string;
-	int   stringlen;
-	int type;
-} s2t_map[] = {
-	{
-		.string    = "OWNER@",
-		.stringlen = sizeof("OWNER@") - 1,
-		.type      = NFS4_ACL_WHO_OWNER,
-	},
-	{
-		.string    = "GROUP@",
-		.stringlen = sizeof("GROUP@") - 1,
-		.type      = NFS4_ACL_WHO_GROUP,
-	},
-	{
-		.string    = "EVERYONE@",
-		.stringlen = sizeof("EVERYONE@") - 1,
-		.type      = NFS4_ACL_WHO_EVERYONE,
-	},
-};
-
-int
-nfs4_acl_get_whotype(char *p, u32 len)
+__be32 nfsd4_decode_ace_who(struct richace *ace, struct svc_rqst *rqstp,
+			    char *who, u32 len)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(s2t_map); i++) {
-		if (s2t_map[i].stringlen == len &&
-				0 == memcmp(s2t_map[i].string, p, len))
-			return s2t_map[i].type;
+	int special_id;
+
+	special_id = nfs4acl_who_to_special_id(who, len);
+	if (special_id >= 0) {
+		ace->e_flags |= RICHACE_SPECIAL_WHO;
+		ace->e_flags &= ~RICHACE_IDENTIFIER_GROUP;
+		ace->e_id.special = special_id;
+		return nfs_ok;
 	}
-	return NFS4_ACL_WHO_NAMED;
+	if (ace->e_flags & RICHACE_IDENTIFIER_GROUP)
+		return nfsd_map_name_to_gid(rqstp, who, len, &ace->e_id.gid);
+	else
+		return nfsd_map_name_to_uid(rqstp, who, len, &ace->e_id.uid);
 }
 
-__be32 nfs4_acl_write_who(struct xdr_stream *xdr, int who)
+__be32 nfsd4_encode_ace_who(struct xdr_stream *xdr, struct svc_rqst *rqstp,
+			    struct richace *ace)
 {
-	__be32 *p;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(s2t_map); i++) {
-		if (s2t_map[i].type != who)
-			continue;
-		p = xdr_reserve_space(xdr, s2t_map[i].stringlen + 4);
+	if (ace->e_flags & RICHACE_SPECIAL_WHO) {
+		unsigned int special_id = ace->e_id.special;
+		const char *who;
+		unsigned int len;
+		__be32 *p;
+
+		if (!nfs4acl_special_id_to_who(special_id, &who, &len)) {
+			WARN_ON_ONCE(1);
+			return nfserr_serverfault;
+		}
+		p = xdr_reserve_space(xdr, len + 4);
 		if (!p)
 			return nfserr_resource;
-		p = xdr_encode_opaque(p, s2t_map[i].string,
-					s2t_map[i].stringlen);
+		p = xdr_encode_opaque(p, who, len);
 		return 0;
 	}
-	WARN_ON_ONCE(1);
-	return nfserr_serverfault;
+	if (ace->e_flags & RICHACE_IDENTIFIER_GROUP)
+		return nfsd4_encode_group(xdr, rqstp, ace->e_id.gid);
+	else
+		return nfsd4_encode_user(xdr, rqstp, ace->e_id.uid);
 }
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 4ce6b97..2430235 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -159,12 +159,12 @@ is_create_with_attrs(struct nfsd4_open *open)
  * in the returned attr bitmap.
  */
 static void
-do_set_nfs4_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct nfs4_acl *acl, u32 *bmval)
+do_set_acl(struct svc_rqst *rqstp, struct svc_fh *fhp, struct richacl *acl,
+	   u32 *bmval)
 {
 	__be32 status;
 
-	status = nfsd4_set_nfs4_acl(rqstp, fhp, acl);
+	status = nfsd4_set_acl(rqstp, fhp, acl);
 	if (status)
 		/*
 		 * We should probably fail the whole open at this point,
@@ -299,7 +299,7 @@ do_open_lookup(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate, stru
 		goto out;
 
 	if (is_create_with_attrs(open) && open->op_acl != NULL)
-		do_set_nfs4_acl(rqstp, *resfh, open->op_acl, open->op_bmval);
+		do_set_acl(rqstp, *resfh, open->op_acl, open->op_bmval);
 
 	nfsd4_set_open_owner_reply_cache(cstate, open, *resfh);
 	accmode = NFSD_MAY_NOP;
@@ -672,8 +672,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		nfsd4_security_inode_setsecctx(&resfh, &create->cr_label, create->cr_bmval);
 
 	if (create->cr_acl != NULL)
-		do_set_nfs4_acl(rqstp, &resfh, create->cr_acl,
-				create->cr_bmval);
+		do_set_acl(rqstp, &resfh, create->cr_acl, create->cr_bmval);
 
 	fh_unlock(&cstate->current_fh);
 	set_change_info(&create->cr_cinfo, &cstate->current_fh);
@@ -938,8 +937,8 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		goto out;
 
 	if (setattr->sa_acl != NULL)
-		status = nfsd4_set_nfs4_acl(rqstp, &cstate->current_fh,
-					    setattr->sa_acl);
+		status = nfsd4_set_acl(rqstp, &cstate->current_fh,
+				       setattr->sa_acl);
 	if (status)
 		goto out;
 	if (setattr->sa_label.len)
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b8db5a7..8603f40 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -303,7 +303,7 @@ nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 
 static __be32
 nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
-		   struct iattr *iattr, struct nfs4_acl **acl,
+		   struct iattr *iattr, struct richacl **acl,
 		   struct xdr_netobj *label)
 {
 	int expected_len, len = 0;
@@ -326,38 +326,31 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 	}
 	if (bmval[0] & FATTR4_WORD0_ACL) {
 		u32 nace;
-		struct nfs4_ace *ace;
+		struct richace *ace;
 
 		READ_BUF(4); len += 4;
 		nace = be32_to_cpup(p++);
 
-		if (nace > NFS4_ACL_MAX)
+		if (nace > NFSD4_ACL_MAX)
 			return nfserr_fbig;
 
-		*acl = svcxdr_tmpalloc(argp, nfs4_acl_bytes(nace));
+		*acl = svcxdr_alloc_richacl(argp, nace);
 		if (*acl == NULL)
 			return nfserr_jukebox;
 
-		(*acl)->naces = nace;
-		for (ace = (*acl)->aces; ace < (*acl)->aces + nace; ace++) {
+		richacl_for_each_entry(ace, *acl) {
 			READ_BUF(16); len += 16;
-			ace->type = be32_to_cpup(p++);
-			ace->flag = be32_to_cpup(p++);
-			ace->access_mask = be32_to_cpup(p++);
+			ace->e_type = be32_to_cpup(p++);
+			ace->e_flags = be32_to_cpup(p++);
+			ace->e_mask = be32_to_cpup(p++);
+			if (ace->e_flags & RICHACE_SPECIAL_WHO)
+				return nfserr_inval;
 			dummy32 = be32_to_cpup(p++);
 			READ_BUF(dummy32);
 			len += XDR_QUADLEN(dummy32) << 2;
 			READMEM(buf, dummy32);
-			ace->whotype = nfs4_acl_get_whotype(buf, dummy32);
-			status = nfs_ok;
-			if (ace->whotype != NFS4_ACL_WHO_NAMED)
-				;
-			else if (ace->flag & NFS4_ACE_IDENTIFIER_GROUP)
-				status = nfsd_map_name_to_gid(argp->rqstp,
-						buf, dummy32, &ace->who_gid);
-			else
-				status = nfsd_map_name_to_uid(argp->rqstp,
-						buf, dummy32, &ace->who_uid);
+			status = nfsd4_decode_ace_who(ace, argp->rqstp,
+						      buf, dummy32);
 			if (status)
 				return status;
 		}
@@ -2148,18 +2141,6 @@ static u32 nfs4_file_type(umode_t mode)
 }
 
 static inline __be32
-nfsd4_encode_aclname(struct xdr_stream *xdr, struct svc_rqst *rqstp,
-		     struct nfs4_ace *ace)
-{
-	if (ace->whotype != NFS4_ACL_WHO_NAMED)
-		return nfs4_acl_write_who(xdr, ace->whotype);
-	else if (ace->flag & NFS4_ACE_IDENTIFIER_GROUP)
-		return nfsd4_encode_group(xdr, rqstp, ace->who_gid);
-	else
-		return nfsd4_encode_user(xdr, rqstp, ace->who_uid);
-}
-
-static inline __be32
 nfsd4_encode_layout_type(struct xdr_stream *xdr, enum pnfs_layouttype layout_type)
 {
 	__be32 *p;
@@ -2303,7 +2284,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 	u32 rdattr_err = 0;
 	__be32 status;
 	int err;
-	struct nfs4_acl *acl = NULL;
+	struct richacl *acl = NULL;
 	void *context = NULL;
 	int contextlen;
 	bool contextsupport = false;
@@ -2349,7 +2330,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		fhp = tempfh;
 	}
 	if (bmval0 & FATTR4_WORD0_ACL) {
-		err = nfsd4_get_nfs4_acl(rqstp, dentry, &acl);
+		err = nfsd4_get_acl(rqstp, dentry, &acl);
 		if (err == -EOPNOTSUPP)
 			bmval0 &= ~FATTR4_WORD0_ACL;
 		else if (err == -EINVAL) {
@@ -2504,7 +2485,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		*p++ = cpu_to_be32(rdattr_err);
 	}
 	if (bmval0 & FATTR4_WORD0_ACL) {
-		struct nfs4_ace *ace;
+		struct richace *ace;
 
 		if (acl == NULL) {
 			p = xdr_reserve_space(xdr, 4);
@@ -2517,17 +2498,16 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		p = xdr_reserve_space(xdr, 4);
 		if (!p)
 			goto out_resource;
-		*p++ = cpu_to_be32(acl->naces);
+		*p++ = cpu_to_be32(acl->a_count);
 
-		for (ace = acl->aces; ace < acl->aces + acl->naces; ace++) {
+		richacl_for_each_entry(ace, acl) {
 			p = xdr_reserve_space(xdr, 4*3);
 			if (!p)
 				goto out_resource;
-			*p++ = cpu_to_be32(ace->type);
-			*p++ = cpu_to_be32(ace->flag);
-			*p++ = cpu_to_be32(ace->access_mask &
-							NFS4_ACE_MASK_ALL);
-			status = nfsd4_encode_aclname(xdr, rqstp, ace);
+			*p++ = cpu_to_be32(ace->e_type);
+			*p++ = cpu_to_be32(ace->e_flags & ~RICHACE_SPECIAL_WHO);
+			*p++ = cpu_to_be32(ace->e_mask & NFS4_ACE_MASK_ALL);
+			status = nfsd4_encode_ace_who(xdr, rqstp, ace);
 			if (status)
 				goto out;
 		}
@@ -2792,7 +2772,7 @@ out:
 	if (context)
 		security_release_secctx(context, contextlen);
 #endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
-	kfree(acl);
+	richacl_put(acl);
 	if (tempfh) {
 		fh_put(tempfh);
 		kfree(tempfh);
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index b698585..c311066 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -118,7 +118,7 @@ struct nfsd4_create {
 	u32		cr_bmval[3];        /* request */
 	struct iattr	cr_iattr;           /* request */
 	struct nfsd4_change_info  cr_cinfo; /* response */
-	struct nfs4_acl *cr_acl;
+	struct richacl *cr_acl;
 	struct xdr_netobj cr_label;
 };
 #define cr_datalen	u.link.datalen
@@ -248,7 +248,7 @@ struct nfsd4_open {
 	struct nfs4_file *op_file;          /* used during processing */
 	struct nfs4_ol_stateid *op_stp;	    /* used during processing */
 	struct nfs4_clnt_odstate *op_odstate; /* used during processing */
-	struct nfs4_acl *op_acl;
+	struct richacl *op_acl;
 	struct xdr_netobj op_label;
 };
 
@@ -332,7 +332,7 @@ struct nfsd4_setattr {
 	stateid_t	sa_stateid;         /* request */
 	u32		sa_bmval[3];        /* request */
 	struct iattr	sa_iattr;           /* request */
-	struct nfs4_acl *sa_acl;
+	struct richacl *sa_acl;
 	struct xdr_netobj sa_label;
 };
 
diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index 00121f2..1422fc6 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -16,29 +16,6 @@
 #include <linux/uidgid.h>
 #include <uapi/linux/nfs4.h>
 
-enum nfs4_acl_whotype {
-	NFS4_ACL_WHO_NAMED = 0,
-	NFS4_ACL_WHO_OWNER,
-	NFS4_ACL_WHO_GROUP,
-	NFS4_ACL_WHO_EVERYONE,
-};
-
-struct nfs4_ace {
-	uint32_t	type;
-	uint32_t	flag;
-	uint32_t	access_mask;
-	int		whotype;
-	union {
-		kuid_t	who_uid;
-		kgid_t	who_gid;
-	};
-};
-
-struct nfs4_acl {
-	uint32_t	naces;
-	struct nfs4_ace	aces[0];
-};
-
 #define NFS4_MAXLABELLEN	2048
 
 struct nfs4_label {
diff --git a/include/linux/nfs4acl.h b/include/linux/nfs4acl.h
new file mode 100644
index 0000000..db9f9a6
--- /dev/null
+++ b/include/linux/nfs4acl.h
@@ -0,0 +1,7 @@
+#ifndef __LINUX_NFS4ACL_H
+#define __LINUX_NFS4ACL_H
+
+int nfs4acl_who_to_special_id(const char *, u32);
+bool nfs4acl_special_id_to_who(unsigned int, const char **, unsigned int *);
+
+#endif
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
