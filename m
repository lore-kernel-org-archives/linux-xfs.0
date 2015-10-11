Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A0B829E29
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:04:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06A11AC001
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 16:04:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BmYVpNy5I9RDiHuw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2015 16:04:24 -0700 (PDT)
From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: [PATCH v10 45/46] nfs: Add support for the v4.1 dacl attribute
Date: Mon, 12 Oct 2015 00:58:56 +0200
Message-Id: <1444604337-17651-46-git-send-email-andreas.gruenbacher@gmail.com>
In-Reply-To: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

The dacl attribute includes Automatic Inheritance flags not supported by
the acl attribute.  it is only supported in NFS version 4.1 and higher.
On systems where NFS version 4.0 is still the default, an additional
mount option is needed:

    mount -t nfs4 -o vers=4.1 [...]

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/nfs/nfs4proc.c       |  2 +-
 fs/nfs/nfs4xdr.c        | 55 ++++++++++++++++++++++++++++++++++++++++++-------
 include/linux/nfs_xdr.h |  2 +-
 3 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a686251..6af222c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4556,7 +4556,7 @@ static struct richacl *__nfs4_get_acl_uncached(struct inode *inode)
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct page *pages[DIV_ROUND_UP(NFS4ACL_SIZE_MAX, PAGE_SIZE)] = {};
 	struct nfs_getaclargs args = {
-		.fh = NFS_FH(inode),
+		.inode = inode,
 		.acl_pages = pages,
 		.acl_len = ARRAY_SIZE(pages) * PAGE_SIZE,
 	};
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index f2507d7..d855c6b 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -1661,9 +1661,16 @@ encode_setacl(struct xdr_stream *xdr, struct nfs_setaclargs *arg, struct compoun
 	encode_nfs4_stateid(xdr, &zero_stateid);
 
 	/* Encode attribute bitmap. */
-	p = reserve_space(xdr, 2*4);
-	*p++ = cpu_to_be32(1);
-	*p = cpu_to_be32(FATTR4_WORD0_ACL);
+	if (arg->server->attr_bitmask[1] & FATTR4_WORD1_DACL) {
+		p = reserve_space(xdr, 3*4);
+		*p++ = cpu_to_be32(2);
+		*p++ = 0;
+		*p = cpu_to_be32(FATTR4_WORD1_DACL);
+	} else {
+		p = reserve_space(xdr, 2*4);
+		*p++ = cpu_to_be32(1);
+		*p = cpu_to_be32(FATTR4_WORD0_ACL);
+	}
 
 	attrlen_offset = xdr->buf->len;
 	xdr_reserve_space(xdr, 4);  /* to be backfilled later */
@@ -2498,9 +2505,12 @@ static void nfs4_xdr_enc_getacl(struct rpc_rqst *req, struct xdr_stream *xdr,
 
 	encode_compound_hdr(xdr, req, &hdr);
 	encode_sequence(xdr, &args->seq_args, &hdr);
-	encode_putfh(xdr, args->fh, &hdr);
+	encode_putfh(xdr, NFS_FH(args->inode), &hdr);
 	replen = hdr.replen + op_decode_hdr_maxsz + 1;
-	encode_getattr_two(xdr, FATTR4_WORD0_ACL, FATTR4_WORD1_MODE, &hdr);
+	if (NFS_SERVER(args->inode)->attr_bitmask[1] & FATTR4_WORD1_DACL)
+		encode_getattr_two(xdr, 0, FATTR4_WORD1_MODE | FATTR4_WORD1_DACL, &hdr);
+	else
+		encode_getattr_two(xdr, FATTR4_WORD0_ACL, FATTR4_WORD1_MODE, &hdr);
 
 	xdr_inline_pages(&req->rq_rcv_buf, replen << 2,
 		args->acl_pages, 0, args->acl_len);
@@ -5408,14 +5418,28 @@ static int decode_getacl(struct xdr_stream *xdr, struct rpc_rqst *req,
 
 	if (unlikely(bitmap[0] & (FATTR4_WORD0_ACL - 1U)))
 		return -EIO;
-	if (likely(bitmap[0] & FATTR4_WORD0_ACL)) {
+
+	if (bitmap[0] & FATTR4_WORD0_ACL) {
+		struct richace *ace;
+
+		if (bitmap[1] & FATTR4_WORD1_DACL)
+			return -EIO;
+
 		acl = decode_acl_entries(xdr, res->server);
 		status = PTR_ERR(acl);
 		if (IS_ERR(acl))
 			goto out;
+
+		status = -EIO;
+		richacl_for_each_entry(ace, acl) {
+			if (ace->e_flags & RICHACE_INHERITED_ACE)
+				goto out;
+		}
 		bitmap[0] &= ~FATTR4_WORD0_ACL;
-	} else
+	} else if (!(bitmap[1] & FATTR4_WORD1_DACL)) {
 		status = -EOPNOTSUPP;
+		goto out;
+	}
 
 	status = -EIO;
 	if (unlikely(bitmap[0]))
@@ -5424,6 +5448,23 @@ static int decode_getacl(struct xdr_stream *xdr, struct rpc_rqst *req,
 	status = decode_attr_mode(xdr, bitmap, &res->mode);
 	if (status < 0)
 		goto out;
+	if (bitmap[1] & FATTR4_WORD1_DACL) {
+		unsigned int flags;
+		__be32 *p;
+
+		p = xdr_inline_decode(xdr, 4);
+		status = -EIO;
+		if (unlikely(!p))
+			goto out;
+		flags = be32_to_cpup(p);
+
+		acl = decode_acl_entries(xdr, res->server);
+		status = PTR_ERR(acl);
+		if (IS_ERR(acl))
+			goto out;
+		acl->a_flags = flags;
+		bitmap[1] &= ~FATTR4_WORD1_DACL;
+	}
 	status = 0;
 
 out:
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 337c341..9c2a078 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -695,7 +695,7 @@ struct nfs_setaclres {
 
 struct nfs_getaclargs {
 	struct nfs4_sequence_args 	seq_args;
-	struct nfs_fh *			fh;
+	struct inode *			inode;
 	size_t				acl_len;
 	struct page **			acl_pages;
 };
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
