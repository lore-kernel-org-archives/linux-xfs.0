Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 757227FF9
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:23:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 579D5304062
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:23:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6qGZpzHBiUygeHIo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:23:33 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 45/48] nfs: Remove unused xdr page offsets in
	getacl/setacl arguments
Date: Fri, 16 Oct 2015 17:18:23 +0200
Message-Id: <1445008706-15115-46-git-send-email-agruenba@redhat.com>
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

The arguments passed around for getacl and setacl xdr encoding, struct
nfs_setaclargs and struct nfs_getaclargs, both contain an array of
pages, an offset into the first page, and the length of the page data.
The offset is unused as it is always zero; remove it.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/nfs/nfs4proc.c       | 5 ++---
 fs/nfs/nfs4xdr.c        | 4 ++--
 include/linux/nfs_xdr.h | 2 --
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5133bb1..eec5c4c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4530,7 +4530,7 @@ static inline int nfs4_server_supports_acls(struct nfs_server *server)
 #define NFS4ACL_MAXPAGES DIV_ROUND_UP(XATTR_SIZE_MAX, PAGE_SIZE)
 
 static int buf_to_pages_noslab(const void *buf, size_t buflen,
-		struct page **pages, unsigned int *pgbase)
+		struct page **pages)
 {
 	struct page *newpage, **spages;
 	int rc = 0;
@@ -4674,7 +4674,6 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bu
 		goto out_free;
 
 	args.acl_len = npages * PAGE_SIZE;
-	args.acl_pgbase = 0;
 
 	dprintk("%s  buf %p buflen %zu npages %d args.acl_len %zu\n",
 		__func__, buf, buflen, npages, args.acl_len);
@@ -4766,7 +4765,7 @@ static int __nfs4_proc_set_acl(struct inode *inode, const void *buf, size_t bufl
 		return -EOPNOTSUPP;
 	if (npages > ARRAY_SIZE(pages))
 		return -ERANGE;
-	i = buf_to_pages_noslab(buf, buflen, arg.acl_pages, &arg.acl_pgbase);
+	i = buf_to_pages_noslab(buf, buflen, arg.acl_pages);
 	if (i < 0)
 		return i;
 	nfs4_inode_return_delegation(inode);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 6f6d921..eefed15 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -1659,7 +1659,7 @@ encode_setacl(struct xdr_stream *xdr, struct nfs_setaclargs *arg, struct compoun
 	*p = cpu_to_be32(FATTR4_WORD0_ACL);
 	p = reserve_space(xdr, 4);
 	*p = cpu_to_be32(arg->acl_len);
-	xdr_write_pages(xdr, arg->acl_pages, arg->acl_pgbase, arg->acl_len);
+	xdr_write_pages(xdr, arg->acl_pages, 0, arg->acl_len);
 }
 
 static void
@@ -2491,7 +2491,7 @@ static void nfs4_xdr_enc_getacl(struct rpc_rqst *req, struct xdr_stream *xdr,
 	encode_getattr_two(xdr, FATTR4_WORD0_ACL, 0, &hdr);
 
 	xdr_inline_pages(&req->rq_rcv_buf, replen << 2,
-		args->acl_pages, args->acl_pgbase, args->acl_len);
+		args->acl_pages, 0, args->acl_len);
 
 	encode_nops(&hdr);
 }
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 52faf7e..090ade4 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -685,7 +685,6 @@ struct nfs_setaclargs {
 	struct nfs4_sequence_args	seq_args;
 	struct nfs_fh *			fh;
 	size_t				acl_len;
-	unsigned int			acl_pgbase;
 	struct page **			acl_pages;
 };
 
@@ -697,7 +696,6 @@ struct nfs_getaclargs {
 	struct nfs4_sequence_args 	seq_args;
 	struct nfs_fh *			fh;
 	size_t				acl_len;
-	unsigned int			acl_pgbase;
 	struct page **			acl_pages;
 };
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
