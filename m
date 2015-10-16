Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABC4F7FE5
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:23:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B90D8F8068
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:23:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xgE5YszK43gHMj8q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:23:46 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 47/48] nfs: Add richacl support
Date: Fri, 16 Oct 2015 17:18:25 +0200
Message-Id: <1445008706-15115-48-git-send-email-agruenba@redhat.com>
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

Add support for the "system.richacl" xattr in nfs.  The existing
"system.nfs4_acl" xattr on nfs doesn't map user and group names to uids
and gids; the "system.richacl" xattr does, and only keeps the
on-the-wire names when there is no mapping.  This allows to copy
permissions across different file systems.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/nfs/inode.c            |   3 -
 fs/nfs/nfs4proc.c         | 731 ++++++++++++++++++++++++++++++++++------------
 fs/nfs/nfs4xdr.c          | 178 +++++++++--
 fs/nfs/super.c            |   4 +-
 include/linux/nfs_fs.h    |   1 -
 include/linux/nfs_fs_sb.h |   2 +
 include/linux/nfs_xdr.h   |   9 +-
 7 files changed, 701 insertions(+), 227 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 326d9e1..843d15d 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1852,9 +1852,6 @@ struct inode *nfs_alloc_inode(struct super_block *sb)
 		return NULL;
 	nfsi->flags = 0UL;
 	nfsi->cache_validity = 0UL;
-#if IS_ENABLED(CONFIG_NFS_V4)
-	nfsi->nfs4_acl = NULL;
-#endif /* CONFIG_NFS_V4 */
 	return &nfsi->vfs_inode;
 }
 EXPORT_SYMBOL_GPL(nfs_alloc_inode);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index eec5c4c..7bb2dea 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -55,6 +55,9 @@
 #include <linux/xattr.h>
 #include <linux/utsname.h>
 #include <linux/freezer.h>
+#include <linux/richacl.h>
+#include <linux/richacl_xattr.h>
+#include <linux/nfs4acl.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
@@ -2982,15 +2985,18 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 			res.attr_bitmask[2] &= FATTR4_WORD2_NFS42_MASK;
 		}
 		memcpy(server->attr_bitmask, res.attr_bitmask, sizeof(server->attr_bitmask));
-		server->caps &= ~(NFS_CAP_ACLS|NFS_CAP_HARDLINKS|
-				NFS_CAP_SYMLINKS|NFS_CAP_FILEID|
+		server->caps &= ~(NFS_CAP_ALLOW_ACLS|NFS_CAP_DENY_ACLS|
+				NFS_CAP_HARDLINKS|NFS_CAP_SYMLINKS|NFS_CAP_FILEID|
 				NFS_CAP_MODE|NFS_CAP_NLINK|NFS_CAP_OWNER|
 				NFS_CAP_OWNER_GROUP|NFS_CAP_ATIME|
 				NFS_CAP_CTIME|NFS_CAP_MTIME|
 				NFS_CAP_SECURITY_LABEL);
-		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL &&
-				res.acl_bitmask & ACL4_SUPPORT_ALLOW_ACL)
-			server->caps |= NFS_CAP_ACLS;
+		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL) {
+			if (res.acl_bitmask & ACL4_SUPPORT_ALLOW_ACL)
+				server->caps |= NFS_CAP_ALLOW_ACLS;
+			if (res.acl_bitmask & ACL4_SUPPORT_DENY_ACL)
+				server->caps |= NFS_CAP_DENY_ACLS;
+		}
 		if (res.has_links != 0)
 			server->caps |= NFS_CAP_HARDLINKS;
 		if (res.has_symlinks != 0)
@@ -4518,45 +4524,11 @@ static int nfs4_proc_renew(struct nfs_client *clp, struct rpc_cred *cred)
 	return 0;
 }
 
-static inline int nfs4_server_supports_acls(struct nfs_server *server)
-{
-	return server->caps & NFS_CAP_ACLS;
-}
-
-/* Assuming that XATTR_SIZE_MAX is a multiple of PAGE_SIZE, and that
- * it's OK to put sizeof(void) * (XATTR_SIZE_MAX/PAGE_SIZE) bytes on
- * the stack.
+/* A arbitrary limit; we allocate at most DIV_ROUND_UP(NFS4ACL_SIZE_MAX,
+ * PAGE_SIZE) pages and put an array of DIV_ROUND_UP(NFS4ACL_SIZE_MAX,
+ * PAGE_SIZE) pages on the stack when encoding or decoding acls.
  */
-#define NFS4ACL_MAXPAGES DIV_ROUND_UP(XATTR_SIZE_MAX, PAGE_SIZE)
-
-static int buf_to_pages_noslab(const void *buf, size_t buflen,
-		struct page **pages)
-{
-	struct page *newpage, **spages;
-	int rc = 0;
-	size_t len;
-	spages = pages;
-
-	do {
-		len = min_t(size_t, PAGE_SIZE, buflen);
-		newpage = alloc_page(GFP_KERNEL);
-
-		if (newpage == NULL)
-			goto unwind;
-		memcpy(page_address(newpage), buf, len);
-                buf += len;
-                buflen -= len;
-		*pages++ = newpage;
-		rc++;
-	} while (buflen != 0);
-
-	return rc;
-
-unwind:
-	for(; rc > 0; rc--)
-		__free_page(spages[rc-1]);
-	return -ENOMEM;
-}
+#define NFS4ACL_SIZE_MAX 65536
 
 struct nfs4_cached_acl {
 	int cached;
@@ -4564,66 +4536,9 @@ struct nfs4_cached_acl {
 	char data[0];
 };
 
-static void nfs4_set_cached_acl(struct inode *inode, struct nfs4_cached_acl *acl)
-{
-	struct nfs_inode *nfsi = NFS_I(inode);
-
-	spin_lock(&inode->i_lock);
-	kfree(nfsi->nfs4_acl);
-	nfsi->nfs4_acl = acl;
-	spin_unlock(&inode->i_lock);
-}
-
 static void nfs4_zap_acl_attr(struct inode *inode)
 {
-	nfs4_set_cached_acl(inode, NULL);
-}
-
-static inline ssize_t nfs4_read_cached_acl(struct inode *inode, char *buf, size_t buflen)
-{
-	struct nfs_inode *nfsi = NFS_I(inode);
-	struct nfs4_cached_acl *acl;
-	int ret = -ENOENT;
-
-	spin_lock(&inode->i_lock);
-	acl = nfsi->nfs4_acl;
-	if (acl == NULL)
-		goto out;
-	if (buf == NULL) /* user is just asking for length */
-		goto out_len;
-	if (acl->cached == 0)
-		goto out;
-	ret = -ERANGE; /* see getxattr(2) man page */
-	if (acl->len > buflen)
-		goto out;
-	memcpy(buf, acl->data, acl->len);
-out_len:
-	ret = acl->len;
-out:
-	spin_unlock(&inode->i_lock);
-	return ret;
-}
-
-static void nfs4_write_cached_acl(struct inode *inode, struct page **pages, size_t pgbase, size_t acl_len)
-{
-	struct nfs4_cached_acl *acl;
-	size_t buflen = sizeof(*acl) + acl_len;
-
-	if (buflen <= PAGE_SIZE) {
-		acl = kmalloc(buflen, GFP_KERNEL);
-		if (acl == NULL)
-			goto out;
-		acl->cached = 1;
-		_copy_from_pages(acl->data, pages, pgbase, acl_len);
-	} else {
-		acl = kmalloc(sizeof(*acl), GFP_KERNEL);
-		if (acl == NULL)
-			goto out;
-		acl->cached = 0;
-	}
-	acl->len = acl_len;
-out:
-	nfs4_set_cached_acl(inode, acl);
+	forget_cached_richacl(inode);
 }
 
 /*
@@ -4636,121 +4551,269 @@ out:
  * length. The next getxattr call will then produce another round trip to
  * the server, this time with the input buf of the required size.
  */
-static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t buflen)
+static struct richacl *__nfs4_get_acl_uncached(struct inode *inode)
 {
-	struct page *pages[NFS4ACL_MAXPAGES] = {NULL, };
+	struct nfs_server *server = NFS_SERVER(inode);
+	struct page *pages[DIV_ROUND_UP(NFS4ACL_SIZE_MAX, PAGE_SIZE)] = {};
 	struct nfs_getaclargs args = {
 		.fh = NFS_FH(inode),
 		.acl_pages = pages,
-		.acl_len = buflen,
+		.acl_len = ARRAY_SIZE(pages) * PAGE_SIZE,
 	};
 	struct nfs_getaclres res = {
-		.acl_len = buflen,
+		.server = server,
 	};
 	struct rpc_message msg = {
 		.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_GETACL],
 		.rpc_argp = &args,
 		.rpc_resp = &res,
 	};
-	unsigned int npages = DIV_ROUND_UP(buflen, PAGE_SIZE);
-	int ret = -ENOMEM, i;
-
-	/* As long as we're doing a round trip to the server anyway,
-	 * let's be prepared for a page of acl data. */
-	if (npages == 0)
-		npages = 1;
-	if (npages > ARRAY_SIZE(pages))
-		return -ERANGE;
+	int err, i;
 
-	for (i = 0; i < npages; i++) {
-		pages[i] = alloc_page(GFP_KERNEL);
-		if (!pages[i])
+	if (ARRAY_SIZE(pages) > 1) {
+		/* for decoding across pages */
+		res.acl_scratch = alloc_page(GFP_KERNEL);
+		err = -ENOMEM;
+		if (!res.acl_scratch)
 			goto out_free;
 	}
 
-	/* for decoding across pages */
-	res.acl_scratch = alloc_page(GFP_KERNEL);
-	if (!res.acl_scratch)
-		goto out_free;
-
-	args.acl_len = npages * PAGE_SIZE;
-
-	dprintk("%s  buf %p buflen %zu npages %d args.acl_len %zu\n",
-		__func__, buf, buflen, npages, args.acl_len);
-	ret = nfs4_call_sync(NFS_SERVER(inode)->client, NFS_SERVER(inode),
+	dprintk("%s  args.acl_len %zu\n",
+		__func__, args.acl_len);
+	err = nfs4_call_sync(NFS_SERVER(inode)->client, NFS_SERVER(inode),
 			     &msg, &args.seq_args, &res.seq_res, 0);
-	if (ret)
+	if (err)
 		goto out_free;
 
-	/* Handle the case where the passed-in buffer is too short */
-	if (res.acl_flags & NFS4_ACL_TRUNC) {
-		/* Did the user only issue a request for the acl length? */
-		if (buf == NULL)
-			goto out_ok;
-		ret = -ERANGE;
-		goto out_free;
-	}
-	nfs4_write_cached_acl(inode, pages, res.acl_data_offset, res.acl_len);
-	if (buf) {
-		if (res.acl_len > buflen) {
-			ret = -ERANGE;
-			goto out_free;
-		}
-		_copy_from_pages(buf, pages, res.acl_data_offset, res.acl_len);
-	}
-out_ok:
-	ret = res.acl_len;
+	richacl_compute_max_masks(res.acl);
+	/* FIXME: Set inode->i_mode from res->mode?  */
+	set_cached_richacl(inode, res.acl);
+	err = 0;
+
 out_free:
-	for (i = 0; i < npages; i++)
-		if (pages[i])
-			__free_page(pages[i]);
+	if (err) {
+		richacl_put(res.acl);
+		res.acl = ERR_PTR(err);
+	}
+	for (i = 0; i < ARRAY_SIZE(pages) && pages[i]; i++)
+		__free_page(pages[i]);
 	if (res.acl_scratch)
 		__free_page(res.acl_scratch);
-	return ret;
+	return res.acl;
 }
 
-static ssize_t nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t buflen)
+static struct richacl *nfs4_get_acl_uncached(struct inode *inode)
 {
 	struct nfs4_exception exception = { };
-	ssize_t ret;
+	struct richacl *acl;
 	do {
-		ret = __nfs4_get_acl_uncached(inode, buf, buflen);
-		trace_nfs4_get_acl(inode, ret);
-		if (ret >= 0)
+		acl = __nfs4_get_acl_uncached(inode);
+		trace_nfs4_get_acl(inode, IS_ERR(acl) ? PTR_ERR(acl) : 0);
+		if (!IS_ERR(acl))
 			break;
-		ret = nfs4_handle_exception(NFS_SERVER(inode), ret, &exception);
+		acl = ERR_PTR(nfs4_handle_exception(NFS_SERVER(inode),
+			      PTR_ERR(acl), &exception));
 	} while (exception.retry);
-	return ret;
+	return acl;
 }
 
-static ssize_t nfs4_proc_get_acl(struct inode *inode, void *buf, size_t buflen)
+static struct richacl *nfs4_proc_get_acl(struct inode *inode)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
+	struct richacl *acl;
 	int ret;
 
-	if (!nfs4_server_supports_acls(server))
-		return -EOPNOTSUPP;
+	if (!(server->caps & (NFS_CAP_ALLOW_ACLS | NFS_CAP_DENY_ACLS)))
+		return ERR_PTR(-EOPNOTSUPP);
 	ret = nfs_revalidate_inode(server, inode);
 	if (ret < 0)
-		return ret;
+		return ERR_PTR(ret);
 	if (NFS_I(inode)->cache_validity & NFS_INO_INVALID_ACL)
 		nfs_zap_acl_cache(inode);
-	ret = nfs4_read_cached_acl(inode, buf, buflen);
-	if (ret != -ENOENT)
-		/* -ENOENT is returned if there is no ACL or if there is an ACL
-		 * but no cached acl data, just the acl length */
-		return ret;
-	return nfs4_get_acl_uncached(inode, buf, buflen);
+	acl = get_cached_richacl(inode);
+	if (acl != ACL_NOT_CACHED)
+		return acl;
+	return nfs4_get_acl_uncached(inode);
+}
+
+static int
+richacl_supported(struct nfs_server *server, struct richacl *acl)
+{
+	struct richace *ace;
+
+	if (!(server->caps & (NFS_CAP_ALLOW_ACLS | NFS_CAP_DENY_ACLS)))
+		return -EOPNOTSUPP;
+
+	richacl_for_each_entry(ace, acl) {
+		if (richace_is_allow(ace)) {
+			if (!(server->caps & NFS_CAP_ALLOW_ACLS))
+				return -EINVAL;
+		} else if (richace_is_deny(ace)) {
+			if (!(server->caps & NFS_CAP_DENY_ACLS))
+				return -EINVAL;
+		} else
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+nfs4_encode_user(struct xdr_stream *xdr, const struct nfs_server *server,
+		 kuid_t uid)
+{
+	char name[IDMAP_NAMESZ];
+	int len;
+	__be32 *p;
+
+	len = nfs_map_uid_to_name(server, uid, name, IDMAP_NAMESZ);
+	if (len < 0) {
+		dprintk("nfs: couldn't resolve uid %d to string\n",
+				from_kuid(&init_user_ns, uid));
+		return -ENOENT;
+	}
+	p = xdr_reserve_space(xdr, 4 + len);
+	if (!p)
+		return -EIO;
+	p = xdr_encode_opaque(p, name, len);
+	return 0;
+}
+
+static int
+nfs4_encode_group(struct xdr_stream *xdr, const struct nfs_server *server,
+		  kgid_t gid)
+{
+	char name[IDMAP_NAMESZ];
+	int len;
+	__be32 *p;
+
+	len = nfs_map_gid_to_group(server, gid, name, IDMAP_NAMESZ);
+	if (len < 0) {
+		dprintk("nfs: couldn't resolve gid %d to string\n",
+				from_kgid(&init_user_ns, gid));
+		return -ENOENT;
+	}
+	p = xdr_reserve_space(xdr, 4 + len);
+	if (!p)
+		return -EIO;
+	p = xdr_encode_opaque(p, name, len);
+	return 0;
+}
+
+static unsigned int
+nfs4_ace_mask(int minorversion)
+{
+	return minorversion == 0 ? NFS40_ACE_MASK_ALL : NFS4_ACE_MASK_ALL;
+}
+
+static int
+nfs4_encode_ace_who(struct xdr_stream *xdr, const struct nfs_server *server,
+		    struct richace *ace, struct richacl *acl)
+{
+	const char *who;
+	__be32 *p;
+
+	if (ace->e_flags & RICHACE_SPECIAL_WHO) {
+		unsigned int special_id = ace->e_id.special;
+		const char *who;
+		unsigned int len;
+
+		if (!nfs4acl_special_id_to_who(special_id, &who, &len)) {
+			WARN_ON_ONCE(1);
+			return -EIO;
+		}
+		p = xdr_reserve_space(xdr, 4 + len);
+		if (!p)
+			return -EIO;
+		xdr_encode_opaque(p, who, len);
+		return 0;
+	} else {
+		who = richace_unmapped_identifier(ace, acl);
+		if (who) {
+			unsigned int len = strlen(who);
+
+			p = xdr_reserve_space(xdr, 4 + len);
+			if (!p)
+				return -EIO;
+			xdr_encode_opaque(p, who, len);
+			return 0;
+		} else if (ace->e_flags & RICHACE_IDENTIFIER_GROUP)
+			return nfs4_encode_group(xdr, server, ace->e_id.gid);
+		else
+			return nfs4_encode_user(xdr, server, ace->e_id.uid);
+	}
+}
+
+static int
+nfs4_encode_acl(struct page **pages, unsigned int len, struct richacl *acl,
+		const struct nfs_server *server)
+{
+	int minorversion = server->nfs_client->cl_minorversion;
+	unsigned int ace_mask = nfs4_ace_mask(minorversion);
+	struct xdr_stream xdr;
+	struct xdr_buf buf;
+	__be32 *p;
+	struct richace *ace;
+
+	/* Reject acls not understood by the server */
+	if (server->attr_bitmask[1] & FATTR4_WORD1_DACL) {
+		BUILD_BUG_ON(NFS4_ACE_MASK_ALL != RICHACE_VALID_MASK);
+	} else {
+		if (acl->a_flags)
+			return -EINVAL;
+		richacl_for_each_entry(ace, acl) {
+			if (ace->e_flags & RICHACE_INHERITED_ACE)
+				return -EINVAL;
+		}
+	}
+	richacl_for_each_entry(ace, acl) {
+		if (ace->e_mask & ~ace_mask)
+			return -EINVAL;
+	}
+
+	xdr_init_encode_pages(&xdr, &buf, pages, len);
+
+	if (server->attr_bitmask[1] & FATTR4_WORD1_DACL) {
+		p = xdr_reserve_space(&xdr, 4);
+		if (!p)
+			goto fail;
+		*p = cpu_to_be32(acl ? acl->a_flags : 0);
+	}
+
+	p = xdr_reserve_space(&xdr, 4);
+	if (!p)
+		goto fail;
+	if (!acl) {
+		*p++ = cpu_to_be32(0);
+		return buf.len;
+	}
+	*p++ = cpu_to_be32(acl->a_count);
+
+	richacl_for_each_entry(ace, acl) {
+		p = xdr_reserve_space(&xdr, 4*3);
+		if (!p)
+			goto fail;
+		*p++ = cpu_to_be32(ace->e_type);
+		*p++ = cpu_to_be32(ace->e_flags &
+			~(RICHACE_SPECIAL_WHO | RICHACE_UNMAPPED_WHO));
+		*p++ = cpu_to_be32(ace->e_mask & NFS4_ACE_MASK_ALL);
+		if (nfs4_encode_ace_who(&xdr, server, ace, acl) != 0)
+			goto fail;
+	}
+
+	return buf.len;
+
+fail:
+	return -ENOMEM;
 }
 
-static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t buflen)
+static int __nfs4_proc_set_acl(struct inode *inode, struct richacl *acl)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
-	struct page *pages[NFS4ACL_MAXPAGES];
+	struct page *pages[DIV_ROUND_UP(NFS4ACL_SIZE_MAX, PAGE_SIZE) + 1 /* scratch */] = {};
 	struct nfs_setaclargs arg = {
+		.server		= server,
 		.fh		= NFS_FH(inode),
 		.acl_pages	= pages,
-		.acl_len	= buflen,
 	};
 	struct nfs_setaclres res;
 	struct rpc_message msg = {
@@ -4758,16 +4821,20 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
 		.rpc_argp	= &arg,
 		.rpc_resp	= &res,
 	};
-	unsigned int npages = DIV_ROUND_UP(buflen, PAGE_SIZE);
 	int ret, i;
 
-	if (!nfs4_server_supports_acls(server))
-		return -EOPNOTSUPP;
-	if (npages > ARRAY_SIZE(pages))
-		return -ERANGE;
-	i = buf_to_pages_noslab(buf, buflen, arg.acl_pages);
-	if (i < 0)
-		return i;
+	ret = richacl_supported(server, acl);
+	if (ret)
+		return ret;
+
+	ret = nfs4_encode_acl(pages, NFS4ACL_SIZE_MAX, acl, server);
+	if (ret < 0) {
+		for (i = 0; i < ARRAY_SIZE(pages) && pages[i]; i++)
+			put_page(pages[i]);
+		return ret;
+	}
+	arg.acl_len = ret;
+
 	nfs4_inode_return_delegation(inode);
 	ret = nfs4_call_sync(server->client, server, &msg, &arg.seq_args, &res.seq_res, 1);
 
@@ -4775,8 +4842,8 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
 	 * Free each page after tx, so the only ref left is
 	 * held by the network stack
 	 */
-	for (; i > 0; i--)
-		put_page(pages[i-1]);
+	for (i = 0; i < ARRAY_SIZE(pages) && pages[i]; i++)
+		put_page(pages[i]);
 
 	/*
 	 * Acl update can result in inode attribute update.
@@ -4790,12 +4857,12 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
 	return ret;
 }
 
-static int nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t buflen)
+static int nfs4_proc_set_acl(struct inode *inode, struct richacl *acl)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
-		err = __nfs4_proc_set_acl(inode, buf, buflen);
+		err = __nfs4_proc_set_acl(inode, acl);
 		trace_nfs4_set_acl(inode, err);
 		err = nfs4_handle_exception(NFS_SERVER(inode), err,
 				&exception);
@@ -6257,34 +6324,316 @@ nfs4_release_lockowner(struct nfs_server *server, struct nfs4_lock_state *lsp)
 	rpc_call_async(server->client, &msg, 0, &nfs4_release_lockowner_ops, data);
 }
 
+static int nfs4_xattr_set_richacl(struct dentry *dentry, const char *key,
+				  const void *buf, size_t buflen,
+				  int flags, int handler_flags)
+{
+	struct inode *inode = d_inode(dentry);
+	struct richacl *acl;
+	int error;
+
+	if (strcmp(key, "") != 0)
+		return -EINVAL;
+
+	if (buf) {
+		acl = richacl_from_xattr(&init_user_ns, buf, buflen);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		error = richacl_apply_masks(&acl, inode->i_uid);
+	} else {
+		/*
+		 * "Remove the acl"; only permissions granted by the mode
+		 * remain.  We are using the cached mode here which could be
+		 * outdated; should we do a GETATTR first to narrow down the
+		 * race window?
+		 */
+		acl = richacl_from_mode(inode->i_mode);
+		error = 0;
+	}
+
+	if (!error)
+		error = nfs4_proc_set_acl(inode, acl);
+	richacl_put(acl);
+	return error;
+}
+
+static int nfs4_xattr_get_richacl(struct dentry *dentry, const char *key,
+				  void *buf, size_t buflen, int handler_flags)
+{
+	struct inode *inode = d_inode(dentry);
+	struct richacl *acl;
+	int error;
+	umode_t mode = inode->i_mode & S_IFMT;
+
+	if (strcmp(key, "") != 0)
+		return -EINVAL;
+
+	acl = nfs4_proc_get_acl(inode);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+	error = -ENODATA;
+	if (richacl_equiv_mode(acl, &mode) == 0 &&
+	    ((mode ^ inode->i_mode) & S_IRWXUGO) == 0)
+		goto out;
+	error = richacl_to_xattr(&init_user_ns, acl, buf, buflen);
+out:
+	richacl_put(acl);
+	return error;
+}
+
+static size_t nfs4_xattr_list_richacl(struct dentry *dentry, char *list,
+				      size_t list_len, const char *name,
+				      size_t name_len, int handler_flags)
+{
+	struct nfs_server *server = NFS_SERVER(d_inode(dentry));
+	size_t len = sizeof(XATTR_NAME_RICHACL);
+
+	if (!(server->caps & (NFS_CAP_ALLOW_ACLS | NFS_CAP_DENY_ACLS)))
+		return 0;
+
+	if (list && len <= list_len)
+		memcpy(list, XATTR_NAME_RICHACL, len);
+	return len;
+}
+
 #define XATTR_NAME_NFSV4_ACL "system.nfs4_acl"
 
+static __be32 *richacl_put_nfs4_ace(__be32 *p, const struct richace *ace)
+{
+	*p++ = cpu_to_be32(ace->e_type);
+	*p++ = cpu_to_be32(ace->e_flags &
+			   ~(RICHACE_INHERITED_ACE |
+			     RICHACE_UNMAPPED_WHO |
+			     RICHACE_SPECIAL_WHO));
+	*p++ = cpu_to_be32(ace->e_mask);
+
+	return p;
+}
+
+static __be32 *richacl_put_name(__be32 *p, const char *who, int who_len)
+{
+	unsigned int padding = -who_len & 3;
+
+	*p++ = cpu_to_be32(who_len);
+	memcpy(p, who, who_len);
+	memset((char *)p + who_len, 0, padding);
+	p += DIV_ROUND_UP(who_len, 4);
+
+	return p;
+}
+
+static int richacl_to_nfs4_acl(struct nfs_server *server,
+			       const struct richacl *acl,
+			       void *buf, size_t buflen)
+{
+	const struct richace *ace;
+	__be32 *p = buf;
+	size_t size = 0;
+
+	size += 4;
+	if (buflen >= size)
+		*p++ = cpu_to_be32(acl->a_count);
+
+	richacl_for_each_entry(ace, acl) {
+		char who_buf[IDMAP_NAMESZ];
+		const char *who = who_buf;
+		int who_len;
+
+		size += 3 * 4;
+		if (buflen >= size)
+			p = richacl_put_nfs4_ace(p, ace);
+
+		if (richace_is_unix_user(ace)) {
+			who_len = nfs_map_uid_to_name(server, ace->e_id.uid,
+						      who_buf, sizeof(who_buf));
+			if (who_len < 0)
+				return -EIO;
+		} else if (richace_is_unix_group(ace)) {
+			who_len = nfs_map_gid_to_group(server, ace->e_id.gid,
+						       who_buf, sizeof(who_buf));
+			if (who_len < 0)
+				return -EIO;
+		} else if (ace->e_flags & RICHACE_SPECIAL_WHO) {
+			if (!nfs4acl_special_id_to_who(ace->e_id.special,
+						       &who, &who_len))
+				return -EIO;
+		} else {
+			who = richace_unmapped_identifier(ace, acl);
+			if (who)
+				who_len = strlen(who);
+			else
+				return -EIO;
+		}
+
+		size += 4 + ALIGN(who_len, 4);
+		if (buflen >= size)
+			p = richacl_put_name(p, who, who_len);
+	}
+	if (buflen && buflen < size)
+		return -ERANGE;
+	return size;
+}
+
+static int richace_get_nfs4_ace(struct richace *ace, const __be32 **pp,
+				size_t *buflen)
+{
+	const __be32 *p = *pp;
+
+	if (*buflen < 3 * 4)
+		return -EINVAL;
+	ace->e_type = be32_to_cpu(*p++);
+	ace->e_flags = be32_to_cpu(*p++);
+	if (ace->e_flags & (RICHACE_SPECIAL_WHO | RICHACE_UNMAPPED_WHO))
+		return -EINVAL;
+	ace->e_mask = be32_to_cpu(*p++);
+	*pp = p;
+	*buflen -= 3 * 4;
+
+	return 0;
+}
+
+static ssize_t richace_get_who(struct nfs_server *server, struct richacl *acl,
+			       struct richace *ace, const __be32 **pp,
+			       size_t *buflen)
+{
+	const __be32 *p = *pp;
+	u32 who_len, size;
+	int err, special_id;
+	char *who;
+
+	if (*buflen < 4)
+		return -EINVAL;
+	who_len = be32_to_cpu(*p++);
+	*buflen -= 4;
+	size = ALIGN(who_len, 4);
+	if (*buflen < size || size == 0)
+		return -EINVAL;
+	who = (char *)p;
+	special_id = nfs4acl_who_to_special_id(who, who_len);
+	if (special_id >= 0) {
+		ace->e_flags |= RICHACE_SPECIAL_WHO;
+		ace->e_id.special = special_id;
+		goto out;
+	}
+
+	if (ace->e_flags & RICHACE_IDENTIFIER_GROUP) {
+		err = nfs_map_group_to_gid(server, who, who_len,
+					   &ace->e_id.gid);
+		if (err && err != -ENOENT) {
+			dprintk("%s: nfs_map_group_to_gid "
+				"failed!\n", __func__);
+			return err;
+		}
+	} else {
+		err = nfs_map_name_to_uid(server, who, who_len,
+					  &ace->e_id.uid);
+		if (err && err != -ENOENT) {
+			dprintk("%s: nfs_map_name_to_gid "
+				"failed!\n", __func__);
+			return err;
+		}
+	}
+
+	if (err == -ENOENT) {
+		err = -ENOMEM;
+		if (richacl_add_unmapped_identifier(&acl, &ace,
+			who, who_len, GFP_NOFS))
+			return err;
+	}
+
+out:
+	*pp = p + size / 4;
+	*buflen -= size;
+	return 0;
+}
+
+static struct richacl *richacl_from_nfs4_acl(struct nfs_server *server,
+					     const void *buf, size_t buflen)
+{
+	struct richacl *acl = NULL;
+	struct richace *ace;
+	const __be32 *p = buf;
+	int count, err;
+
+	if (buflen < 4)
+		return ERR_PTR(-EINVAL);
+	count = be32_to_cpu(*p++);
+	if (count > RICHACL_XATTR_MAX_COUNT)
+		return ERR_PTR(-EINVAL);
+	buflen -= 4;
+	acl = richacl_alloc(count, GFP_NOFS);
+	if (!acl)
+		return ERR_PTR(-ENOMEM);
+	richacl_for_each_entry(ace, acl) {
+		err = richace_get_nfs4_ace(ace, &p, &buflen);
+		if (err)
+			goto out;
+		err = richace_get_who(server, acl, ace, &p, &buflen);
+		if (err)
+			goto out;
+
+	}
+	err = -EINVAL;
+	if (buflen != 0)
+		goto out;
+	err = 0;
+
+out:
+	if (err) {
+		richacl_put(acl);
+		acl = ERR_PTR(err);
+	}
+	return acl;
+}
+
 static int nfs4_xattr_set_nfs4_acl(struct dentry *dentry, const char *key,
 				   const void *buf, size_t buflen,
 				   int flags, int type)
 {
-	if (strcmp(key, "") != 0)
+	struct inode *inode = d_inode(dentry);
+	struct richacl *acl;
+	int error;
+
+	if (!buf || strcmp(key, "") != 0)
 		return -EINVAL;
 
-	return nfs4_proc_set_acl(d_inode(dentry), buf, buflen);
+	acl = richacl_from_nfs4_acl(NFS_SERVER(inode), (void *)buf, buflen);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	error = nfs4_proc_set_acl(inode, acl);
+	richacl_put(acl);
+	return error;
 }
 
 static int nfs4_xattr_get_nfs4_acl(struct dentry *dentry, const char *key,
 				   void *buf, size_t buflen, int type)
 {
+	struct inode *inode = d_inode(dentry);
+	struct richacl *acl;
+	int error;
+
 	if (strcmp(key, "") != 0)
 		return -EINVAL;
-
-	return nfs4_proc_get_acl(d_inode(dentry), buf, buflen);
+	acl = nfs4_proc_get_acl(inode);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+	error = richacl_to_nfs4_acl(NFS_SERVER(inode), acl, buf, buflen);
+	richacl_put(acl);
+	return error;
 }
 
 static size_t nfs4_xattr_list_nfs4_acl(struct dentry *dentry, char *list,
 				       size_t list_len, const char *name,
 				       size_t name_len, int type)
 {
+	struct nfs_server *server = NFS_SERVER(d_inode(dentry));
 	size_t len = sizeof(XATTR_NAME_NFSV4_ACL);
 
-	if (!nfs4_server_supports_acls(NFS_SERVER(d_inode(dentry))))
+	if (!(server->caps & (NFS_CAP_ALLOW_ACLS | NFS_CAP_DENY_ACLS)))
 		return 0;
 
 	if (list && len <= list_len)
@@ -8837,6 +9186,13 @@ const struct nfs_rpc_ops nfs_v4_clientops = {
 	.clone_server	= nfs_clone_server,
 };
 
+static const struct xattr_handler nfs4_xattr_richacl_handler = {
+	.prefix	= XATTR_NAME_RICHACL,
+	.list	= nfs4_xattr_list_richacl,
+	.get	= nfs4_xattr_get_richacl,
+	.set	= nfs4_xattr_set_richacl,
+};
+
 static const struct xattr_handler nfs4_xattr_nfs4_acl_handler = {
 	.prefix	= XATTR_NAME_NFSV4_ACL,
 	.list	= nfs4_xattr_list_nfs4_acl,
@@ -8845,6 +9201,7 @@ static const struct xattr_handler nfs4_xattr_nfs4_acl_handler = {
 };
 
 const struct xattr_handler *nfs4_xattr_handlers[] = {
+	&nfs4_xattr_richacl_handler,
 	&nfs4_xattr_nfs4_acl_handler,
 #ifdef CONFIG_NFS_V4_SECURITY_LABEL
 	&nfs4_xattr_nfs4_label_handler,
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index adeb894..2f1d6be 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -52,6 +52,10 @@
 #include <linux/nfs.h>
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
+#include <linux/nfs_idmap.h>
+#include <linux/richacl.h>
+#include <linux/richacl_xattr.h>  /* for RICHACL_XATTR_MAX_COUNT */
+#include <linux/nfs4acl.h>
 
 #include "nfs4_fs.h"
 #include "internal.h"
@@ -1650,16 +1654,24 @@ encode_restorefh(struct xdr_stream *xdr, struct compound_hdr *hdr)
 static void
 encode_setacl(struct xdr_stream *xdr, struct nfs_setaclargs *arg, struct compound_hdr *hdr)
 {
-	__be32 *p;
+	int attrlen_offset;
+	__be32 attrlen, *p;
 
 	encode_op_hdr(xdr, OP_SETATTR, decode_setacl_maxsz, hdr);
 	encode_nfs4_stateid(xdr, &zero_stateid);
+
+	/* Encode attribute bitmap. */
 	p = reserve_space(xdr, 2*4);
 	*p++ = cpu_to_be32(1);
 	*p = cpu_to_be32(FATTR4_WORD0_ACL);
-	p = reserve_space(xdr, 4);
-	*p = cpu_to_be32(arg->acl_len);
+
+	attrlen_offset = xdr->buf->len;
+	xdr_reserve_space(xdr, 4);  /* to be backfilled later */
+
 	xdr_write_pages(xdr, arg->acl_pages, 0, arg->acl_len);
+
+	attrlen = htonl(xdr->buf->len - attrlen_offset - 4);
+	write_bytes_to_xdr_buf(xdr->buf, attrlen_offset, &attrlen, 4);
 }
 
 static void
@@ -2488,7 +2500,7 @@ static void nfs4_xdr_enc_getacl(struct rpc_rqst *req, struct xdr_stream *xdr,
 	encode_sequence(xdr, &args->seq_args, &hdr);
 	encode_putfh(xdr, args->fh, &hdr);
 	replen = hdr.replen + op_decode_hdr_maxsz + 1;
-	encode_getattr_two(xdr, FATTR4_WORD0_ACL, 0, &hdr);
+	encode_getattr_two(xdr, FATTR4_WORD0_ACL, FATTR4_WORD1_MODE, &hdr);
 
 	xdr_inline_pages(&req->rq_rcv_buf, replen << 2,
 		args->acl_pages, 0, args->acl_len);
@@ -5262,50 +5274,156 @@ decode_restorefh(struct xdr_stream *xdr)
 	return decode_op_hdr(xdr, OP_RESTOREFH);
 }
 
+static int
+nfs4_decode_ace_who(struct richace *ace,
+		    const char **unmapped, unsigned int *unmapped_len,
+		    const struct nfs_server *server,
+		    struct xdr_stream *xdr)
+{
+	char *who;
+	u32 len;
+	int special_id;
+	__be32 *p;
+	int error;
+
+	p = xdr_inline_decode(xdr, 4);
+	if (!p)
+		return -ENOMEM;  /* acl truncated */
+	len = be32_to_cpup(p++);
+	if (len >= XDR_MAX_NETOBJ) {
+		dprintk("%s: name too long (%u)!\n",
+			__func__, len);
+		return -EIO;
+	}
+	who = (char *)xdr_inline_decode(xdr, len);
+	if (!who)
+		return -ENOMEM;  /* acl truncated */
+
+	special_id = nfs4acl_who_to_special_id(who, len);
+	if (special_id >= 0) {
+		ace->e_flags |= RICHACE_SPECIAL_WHO;
+		ace->e_flags &= ~RICHACE_IDENTIFIER_GROUP;
+		ace->e_id.special = special_id;
+		return 0;
+	}
+	if (ace->e_flags & RICHACE_IDENTIFIER_GROUP) {
+		error = nfs_map_group_to_gid(server, who, len, &ace->e_id.gid);
+		if (error && error != -ENOENT) {
+			dprintk("%s: nfs_map_group_to_gid failed!\n",
+					__func__);
+			return error;
+		}
+	} else {
+		error = nfs_map_name_to_uid(server, who, len, &ace->e_id.uid);
+		if (error && error != -ENOENT) {
+			dprintk("%s: nfs_map_name_to_uid failed!\n",
+					__func__);
+			return error;
+		}
+	}
+	if (error == -ENOENT) {
+		*unmapped = who;
+		*unmapped_len = len;
+	}
+	return 0;
+}
+
+static struct richacl *
+decode_acl_entries(struct xdr_stream *xdr, const struct nfs_server *server)
+{
+	struct richacl *acl;
+	struct richace *ace;
+	uint32_t count;
+	__be32 *p;
+	int status;
+
+	p = xdr_inline_decode(xdr, 4);
+	if (unlikely(!p))
+		return ERR_PTR(-ENOMEM);  /* acl truncated */
+	count = be32_to_cpup(p);
+	if (count > RICHACL_XATTR_MAX_COUNT)
+		return ERR_PTR(-EIO);
+	acl = richacl_alloc(count, GFP_NOFS);
+	if (!acl)
+		return ERR_PTR(-ENOMEM);
+	richacl_for_each_entry(ace, acl) {
+		const char *unmapped = NULL;
+		unsigned int unmapped_len;
+
+		p = xdr_inline_decode(xdr, 4*3);
+		status = -ENOMEM;
+		if (unlikely(!p))
+			goto out;  /* acl truncated */
+		ace->e_type = be32_to_cpup(p++);
+		ace->e_flags = be32_to_cpup(p++);
+		status = -EIO;
+		if (ace->e_flags &
+		    (RICHACE_SPECIAL_WHO | RICHACE_UNMAPPED_WHO))
+			goto out;
+		ace->e_mask = be32_to_cpup(p++);
+		status = nfs4_decode_ace_who(ace, &unmapped,
+					     &unmapped_len, server,
+					     xdr);
+		if (status)
+			goto out;
+		if (unmapped) {
+			status = -ENOMEM;
+			if (richacl_add_unmapped_identifier(&acl, &ace,
+					unmapped, unmapped_len,
+					GFP_NOFS))
+				goto out;
+		}
+	}
+	status = 0;
+
+out:
+	if (status) {
+		richacl_put(acl);
+		acl = ERR_PTR(status);
+	}
+	return acl;
+}
+
 static int decode_getacl(struct xdr_stream *xdr, struct rpc_rqst *req,
 			 struct nfs_getaclres *res)
 {
 	unsigned int savep;
 	uint32_t attrlen,
 		 bitmap[3] = {0};
+	struct richacl *acl = NULL;
 	int status;
-	unsigned int pg_offset;
 
-	res->acl_len = 0;
 	if ((status = decode_op_hdr(xdr, OP_GETATTR)) != 0)
-		goto out;
-
-	xdr_enter_page(xdr, xdr->buf->page_len);
-
-	/* Calculate the offset of the page data */
-	pg_offset = xdr->buf->head[0].iov_len;
-
+		return status;
 	if ((status = decode_attr_bitmap(xdr, bitmap)) != 0)
-		goto out;
+		return status;
 	if ((status = decode_attr_length(xdr, &attrlen, &savep)) != 0)
-		goto out;
+		return status;
 
 	if (unlikely(bitmap[0] & (FATTR4_WORD0_ACL - 1U)))
 		return -EIO;
 	if (likely(bitmap[0] & FATTR4_WORD0_ACL)) {
-
-		/* The bitmap (xdr len + bitmaps) and the attr xdr len words
-		 * are stored with the acl data to handle the problem of
-		 * variable length bitmaps.*/
-		res->acl_data_offset = xdr_stream_pos(xdr) - pg_offset;
-		res->acl_len = attrlen;
-
-		/* Check for receive buffer overflow */
-		if (res->acl_len > (xdr->nwords << 2) ||
-		    res->acl_len + res->acl_data_offset > xdr->buf->page_len) {
-			res->acl_flags |= NFS4_ACL_TRUNC;
-			dprintk("NFS: acl reply: attrlen %u > page_len %u\n",
-					attrlen, xdr->nwords << 2);
-		}
+		acl = decode_acl_entries(xdr, res->server);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		bitmap[0] &= ~FATTR4_WORD0_ACL;
 	} else
-		status = -EOPNOTSUPP;
+		return -EOPNOTSUPP;
+
+	status = -EIO;
+	if (unlikely(bitmap[0]))
+		goto out;
+
+	status = decode_attr_mode(xdr, bitmap, &res->mode);
+	if (status < 0)
+		goto out;
+	status = 0;
 
 out:
+	if (status)
+		richacl_put(acl);
+	else
+		res->acl = acl;
 	return status;
 }
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 383a027..8ced33d 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2319,7 +2319,7 @@ void nfs_fill_super(struct super_block *sb, struct nfs_mount_info *mount_info)
 		/* The VFS shouldn't apply the umask to mode bits. We will do
 		 * so ourselves when necessary.
 		 */
-		sb->s_flags |= MS_POSIXACL;
+		sb->s_flags |= MS_RICHACL;
 		sb->s_time_gran = 1;
 	}
 
@@ -2346,7 +2346,7 @@ void nfs_clone_super(struct super_block *sb, struct nfs_mount_info *mount_info)
 		/* The VFS shouldn't apply the umask to mode bits. We will do
 		 * so ourselves when necessary.
 		 */
-		sb->s_flags |= MS_POSIXACL;
+		sb->s_flags |= MS_RICHACL;
 	}
 
  	nfs_initialise_sb(sb);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index c0e9614..b84e194 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -176,7 +176,6 @@ struct nfs_inode {
 	wait_queue_head_t	waitqueue;
 
 #if IS_ENABLED(CONFIG_NFS_V4)
-	struct nfs4_cached_acl	*nfs4_acl;
         /* NFSv4 state */
 	struct list_head	open_states;
 	struct nfs_delegation __rcu *delegation;
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index c7d42b7..cb282e1 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -244,5 +244,7 @@ struct nfs_server {
 #define NFS_CAP_ALLOCATE	(1U << 20)
 #define NFS_CAP_DEALLOCATE	(1U << 21)
 #define NFS_CAP_LAYOUTSTATS	(1U << 22)
+#define NFS_CAP_ALLOW_ACLS	(1U << 23)
+#define NFS_CAP_DENY_ACLS	(1U << 24)
 
 #endif
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 090ade4..337c341 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -683,9 +683,10 @@ struct nfs_setattrargs {
 
 struct nfs_setaclargs {
 	struct nfs4_sequence_args	seq_args;
+	const struct nfs_server *	server;
 	struct nfs_fh *			fh;
-	size_t				acl_len;
 	struct page **			acl_pages;
+	size_t				acl_len;
 };
 
 struct nfs_setaclres {
@@ -703,9 +704,9 @@ struct nfs_getaclargs {
 #define NFS4_ACL_TRUNC		0x0001	/* ACL was truncated */
 struct nfs_getaclres {
 	struct nfs4_sequence_res	seq_res;
-	size_t				acl_len;
-	size_t				acl_data_offset;
-	int				acl_flags;
+	const struct nfs_server *	server;
+	struct richacl *		acl;
+	umode_t				mode;
 	struct page *			acl_scratch;
 };
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
