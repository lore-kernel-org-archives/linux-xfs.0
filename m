Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B6FD29E66
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 09:22:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D310BAC001
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:22:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QplrGERyiFKMcQ8M (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 07:22:09 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v13 39/51] nfsd: Add support for the v4.1 dacl attribute
Date: Tue,  3 Nov 2015 16:17:15 +0100
Message-Id: <1446563847-14005-40-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Richacls support the Automatic Inheritance permission propagation
mechanism as specified in NFSv4.1.  Over NFS, this requires support for
the dacl attribute: compared to the acl attribute, the dacl attribute
has an additional flags field which indicates when Automatic Inheritance
is in use.

The server will only indicate dacl attribute support in protocol version
4.1 and later, on file systems with richacl support.

This commit also adds support for the NFSv4.1 NFS4_ACE_WRITE_RETENTION
and NFS4_ACE_WRITE_RETENTION_HOLD ACL permissions.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Acked-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/nfsd/nfs4proc.c        |   3 +-
 fs/nfsd/nfs4xdr.c         | 219 ++++++++++++++++++++++++++++++----------------
 fs/nfsd/nfsd.h            |   6 +-
 include/linux/nfs4.h      |   1 +
 include/uapi/linux/nfs4.h |   3 +-
 5 files changed, 155 insertions(+), 77 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 1bcfda2..a053e78 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1781,7 +1781,8 @@ static inline u32 nfsd4_getattr_rsize(struct svc_rqst *rqstp,
 	u32 bmap0 = bmap[0], bmap1 = bmap[1], bmap2 = bmap[2];
 	u32 ret = 0;
 
-	if (bmap0 & FATTR4_WORD0_ACL)
+	if (bmap0 & FATTR4_WORD0_ACL ||
+	    bmap1 & FATTR4_WORD1_DACL)
 		return svc_max_payload(rqstp);
 	if (bmap0 & FATTR4_WORD0_FS_LOCATIONS)
 		return svc_max_payload(rqstp);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 682a7d8..33d028c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -301,6 +301,68 @@ nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 	DECODE_TAIL;
 }
 
+static unsigned int
+nfsd4_ace_mask(int minorversion)
+{
+	return minorversion == 0 ?  NFS40_ACE_MASK_ALL : NFS4_ACE_MASK_ALL;
+}
+
+static __be32
+nfsd4_decode_acl_entries(struct nfsd4_compoundargs *argp, struct richacl **acl,
+			 unsigned short flags_mask, unsigned int ace_mask,
+			 int *plen)
+{
+	struct richace *ace;
+	u32 dummy32;
+	char *buf;
+	int len = 0;
+
+	DECODE_HEAD;
+
+	flags_mask &= RICHACE_VALID_FLAGS & ~RICHACE_SPECIAL_WHO;
+
+	READ_BUF(4); len += 4;
+	dummy32 = be32_to_cpup(p++);
+
+	if (dummy32 > NFSD4_ACL_MAX)
+		return nfserr_fbig;
+
+	*acl = svcxdr_alloc_richacl(argp, dummy32);
+	if (*acl == NULL)
+		return nfserr_jukebox;
+
+	richacl_for_each_entry(ace, *acl) {
+		READ_BUF(16); len += 16;
+
+		dummy32 = be32_to_cpup(p++);
+		if (dummy32 > RICHACE_ACCESS_DENIED_ACE_TYPE)
+			return nfserr_inval;
+		ace->e_type = dummy32;
+
+		dummy32 = be32_to_cpup(p++);
+		if (dummy32 & ~flags_mask)
+			return nfserr_inval;
+		ace->e_flags = dummy32;
+
+		dummy32 = be32_to_cpup(p++);
+		if (dummy32 & ~ace_mask)
+			return nfserr_inval;
+		ace->e_mask = dummy32;
+
+		dummy32 = be32_to_cpup(p++);
+		READ_BUF(dummy32);
+		len += XDR_QUADLEN(dummy32) << 2;
+		READMEM(buf, dummy32);
+		status = nfsd4_decode_ace_who(ace, argp->rqstp,
+					      buf, dummy32);
+		if (status)
+			return status;
+	}
+	*plen += len;
+
+	DECODE_TAIL;
+}
+
 static __be32
 nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		   struct iattr *iattr, struct richacl **acl,
@@ -312,6 +374,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 
 	DECODE_HEAD;
 	iattr->ia_valid = 0;
+	*acl = NULL;
 	if ((status = nfsd4_decode_bitmap(argp, bmval)))
 		return status;
 
@@ -325,50 +388,18 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		iattr->ia_valid |= ATTR_SIZE;
 	}
 	if (bmval[0] & FATTR4_WORD0_ACL) {
-		u32 nace;
-		struct richace *ace;
-
-		READ_BUF(4); len += 4;
-		nace = be32_to_cpup(p++);
-
-		if (nace > NFSD4_ACL_MAX)
-			return nfserr_fbig;
+		if (bmval[1] & FATTR4_WORD1_DACL)
+			return nfserr_inval;
 
-		*acl = svcxdr_alloc_richacl(argp, nace);
-		if (*acl == NULL)
+		status = nfsd4_decode_acl_entries(argp, acl,
+				~NFS4_ACE_INHERITED_ACE,
+				nfsd4_ace_mask(argp->minorversion),
+				&len);
+		if (status)
+			return status;
+		else if (*acl == NULL)
 			return nfserr_jukebox;
-
-		richacl_for_each_entry(ace, *acl) {
-			READ_BUF(16); len += 16;
-
-			dummy32 = be32_to_cpup(p++);
-			if (dummy32 > RICHACE_ACCESS_DENIED_ACE_TYPE)
-				return nfserr_inval;
-			ace->e_type = dummy32;
-
-			dummy32 = be32_to_cpup(p++);
-			if (dummy32 & (~RICHACE_VALID_FLAGS |
-				       RICHACE_INHERITED_ACE |
-				       RICHACE_SPECIAL_WHO))
-				return nfserr_inval;
-			ace->e_flags = dummy32;
-
-			dummy32 = be32_to_cpup(p++);
-			if (dummy32 & ~NFS4_ACE_MASK_ALL)
-				return nfserr_inval;
-			ace->e_mask = dummy32;
-
-			dummy32 = be32_to_cpup(p++);
-			READ_BUF(dummy32);
-			len += XDR_QUADLEN(dummy32) << 2;
-			READMEM(buf, dummy32);
-			status = nfsd4_decode_ace_who(ace, argp->rqstp,
-						      buf, dummy32);
-			if (status)
-				return status;
-		}
-	} else
-		*acl = NULL;
+	}
 	if (bmval[1] & FATTR4_WORD1_MODE) {
 		READ_BUF(4);
 		len += 4;
@@ -436,6 +467,22 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			goto xdr_error;
 		}
 	}
+	if (bmval[1] & FATTR4_WORD1_DACL) {
+		READ_BUF(4);
+		len += 4;
+		dummy32 = be32_to_cpup(p++);
+		if (dummy32 & (~RICHACL_VALID_FLAGS | RICHACL_MASKED))
+			return nfserr_inval;
+		status = nfsd4_decode_acl_entries(argp, acl,
+				~0,
+				nfsd4_ace_mask(argp->minorversion),
+				&len);
+		if (status)
+			return status;
+		else if (*acl == NULL)
+			return nfserr_jukebox;
+		(*acl)->a_flags = dummy32;
+	}
 
 	label->len = 0;
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
@@ -2272,6 +2319,42 @@ out_resource:
 	return nfserr_resource;
 }
 
+static __be32 nfsd4_encode_acl_entries(struct xdr_stream *xdr,
+		struct richacl *acl, struct svc_rqst *rqstp,
+		unsigned short flags_mask, unsigned int ace_mask)
+{
+	__be32 *p;
+
+	flags_mask &= ~RICHACE_SPECIAL_WHO;
+
+	p = xdr_reserve_space(xdr, 4);
+	if (!p)
+		return nfserr_resource;
+
+	if (acl == NULL) {
+		*p++ = cpu_to_be32(0);
+	} else {
+		struct richace *ace;
+
+		*p++ = cpu_to_be32(acl->a_count);
+
+		richacl_for_each_entry(ace, acl) {
+			__be32 status;
+
+			p = xdr_reserve_space(xdr, 4*3);
+			if (!p)
+				return nfserr_resource;
+			*p++ = cpu_to_be32(ace->e_type);
+			*p++ = cpu_to_be32(ace->e_flags & flags_mask);
+			*p++ = cpu_to_be32(ace->e_mask & ace_mask);
+			status = nfsd4_encode_ace_who(xdr, rqstp, ace);
+			if (status)
+				return status;
+		}
+	}
+	return 0;
+}
+
 /*
  * Note: @fhp can be NULL; in this case, we might have to compose the filehandle
  * ourselves.
@@ -2342,15 +2425,16 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 			goto out;
 		fhp = tempfh;
 	}
-	if (bmval0 & FATTR4_WORD0_ACL) {
+	if ((bmval0 & FATTR4_WORD0_ACL) || (bmval1 & FATTR4_WORD1_DACL)) {
 		acl = nfsd4_get_acl(rqstp, dentry);
 		if (IS_ERR(acl)) {
 			err = PTR_ERR(acl);
 			acl = NULL;
 		}
-		if (err == -EOPNOTSUPP)
+		if (err == -EOPNOTSUPP) {
 			bmval0 &= ~FATTR4_WORD0_ACL;
-		else if (err == -EINVAL) {
+			bmval1 &= ~FATTR4_WORD1_DACL;
+		} else if (err == -EINVAL) {
 			status = nfserr_attrnotsupp;
 			goto out;
 		} else if (err != 0)
@@ -2389,6 +2473,8 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 
 		if (!IS_ACL(d_inode(dentry)))
 			word0 &= ~FATTR4_WORD0_ACL;
+		if (!IS_RICHACL(d_inode(dentry)))
+			word1 &= ~FATTR4_WORD1_DACL;
 		if (!contextsupport)
 			word2 &= ~FATTR4_WORD2_SECURITY_LABEL;
 		if (!word2) {
@@ -2502,35 +2588,12 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		*p++ = cpu_to_be32(rdattr_err);
 	}
 	if (bmval0 & FATTR4_WORD0_ACL) {
-		struct richace *ace;
-
-		if (acl == NULL) {
-			p = xdr_reserve_space(xdr, 4);
-			if (!p)
-				goto out_resource;
-
-			*p++ = cpu_to_be32(0);
-			goto out_acl;
-		}
-		p = xdr_reserve_space(xdr, 4);
-		if (!p)
-			goto out_resource;
-		*p++ = cpu_to_be32(acl->a_count);
-
-		richacl_for_each_entry(ace, acl) {
-			p = xdr_reserve_space(xdr, 4*3);
-			if (!p)
-				goto out_resource;
-			*p++ = cpu_to_be32(ace->e_type);
-			*p++ = cpu_to_be32(ace->e_flags &
-				~(RICHACE_SPECIAL_WHO | RICHACE_INHERITED_ACE));
-			*p++ = cpu_to_be32(ace->e_mask & NFS4_ACE_MASK_ALL);
-			status = nfsd4_encode_ace_who(xdr, rqstp, ace);
-			if (status)
-				goto out;
-		}
+		status = nfsd4_encode_acl_entries(xdr, acl, rqstp,
+				~NFS4_ACE_INHERITED_ACE,
+				nfsd4_ace_mask(minorversion));
+		if (status)
+			goto out;
 	}
-out_acl:
 	if (bmval0 & FATTR4_WORD0_ACLSUPPORT) {
 		p = xdr_reserve_space(xdr, 4);
 		if (!p)
@@ -2746,6 +2809,16 @@ out_acl:
 		}
 		p = xdr_encode_hyper(p, ino);
 	}
+	if (bmval1 & FATTR4_WORD1_DACL) {
+		p = xdr_reserve_space(xdr, 4);
+		if (!p)
+			goto out_resource;
+		*p++ = cpu_to_be32(acl->a_flags);
+		status = nfsd4_encode_acl_entries(xdr, acl, rqstp,
+				~0, nfsd4_ace_mask(minorversion));
+		if (status)
+			goto out;
+	}
 #ifdef CONFIG_NFSD_PNFS
 	if (bmval1 & FATTR4_WORD1_FS_LAYOUT_TYPES) {
 		status = nfsd4_encode_layout_type(xdr, exp->ex_layout_type);
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index cf98052..cb5c3ed 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -339,7 +339,8 @@ void		nfsd_lockd_shutdown(void);
 	NFSD4_SUPPORTED_ATTRS_WORD0
 
 #define NFSD4_1_SUPPORTED_ATTRS_WORD1 \
-	(NFSD4_SUPPORTED_ATTRS_WORD1	| PNFSD_SUPPORTED_ATTRS_WORD1)
+	(NFSD4_SUPPORTED_ATTRS_WORD1	| PNFSD_SUPPORTED_ATTRS_WORD1 | \
+	 FATTR4_WORD1_DACL)
 
 #define NFSD4_1_SUPPORTED_ATTRS_WORD2 \
 	(NFSD4_SUPPORTED_ATTRS_WORD2	| PNFSD_SUPPORTED_ATTRS_WORD2 | \
@@ -386,7 +387,8 @@ static inline u32 nfsd_suppattrs2(u32 minorversion)
 	(FATTR4_WORD0_SIZE | FATTR4_WORD0_ACL)
 #define NFSD_WRITEABLE_ATTRS_WORD1 \
 	(FATTR4_WORD1_MODE | FATTR4_WORD1_OWNER | FATTR4_WORD1_OWNER_GROUP \
-	| FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_MODIFY_SET)
+	| FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_MODIFY_SET \
+	| FATTR4_WORD1_DACL)
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 #define NFSD_WRITEABLE_ATTRS_WORD2 FATTR4_WORD2_SECURITY_LABEL
 #else
diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index 1422fc6..682ced3 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -394,6 +394,7 @@ enum lock_type4 {
 #define FATTR4_WORD1_TIME_MODIFY        (1UL << 21)
 #define FATTR4_WORD1_TIME_MODIFY_SET    (1UL << 22)
 #define FATTR4_WORD1_MOUNTED_ON_FILEID  (1UL << 23)
+#define FATTR4_WORD1_DACL               (1UL << 26)
 #define FATTR4_WORD1_FS_LAYOUT_TYPES    (1UL << 30)
 #define FATTR4_WORD2_LAYOUT_TYPES       (1UL << 0)
 #define FATTR4_WORD2_LAYOUT_BLKSIZE     (1UL << 1)
diff --git a/include/uapi/linux/nfs4.h b/include/uapi/linux/nfs4.h
index 2b871e0..b850ffd 100644
--- a/include/uapi/linux/nfs4.h
+++ b/include/uapi/linux/nfs4.h
@@ -121,7 +121,8 @@
 #define NFS4_ACE_GENERIC_READ                 0x00120081
 #define NFS4_ACE_GENERIC_WRITE                0x00160106
 #define NFS4_ACE_GENERIC_EXECUTE              0x001200A0
-#define NFS4_ACE_MASK_ALL                     0x001F01FF
+#define NFS40_ACE_MASK_ALL                    0x001F01FF
+#define NFS4_ACE_MASK_ALL                     0x001F07FF
 
 #define EXCHGID4_FLAG_SUPP_MOVED_REFER		0x00000001
 #define EXCHGID4_FLAG_SUPP_MOVED_MIGR		0x00000002
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
