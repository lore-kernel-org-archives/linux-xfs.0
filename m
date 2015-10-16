Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 143937FF9
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:23:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D273C8F8066
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:23:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uK0B1BAo4Ztjhpom (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:23:19 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 43/48] sunrpc: Add xdr_init_encode_pages
Date: Fri, 16 Oct 2015 17:18:21 +0200
Message-Id: <1445008706-15115-44-git-send-email-agruenba@redhat.com>
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

Initialize xdr_stream and xdr_buf from a pages array, for encoding into
the pages.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/sunrpc/xdr.h |  2 ++
 net/sunrpc/xdr.c           | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 70c6b92..2c99cff 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -214,6 +214,8 @@ typedef void	(*kxdreproc_t)(void *rqstp, struct xdr_stream *xdr, void *obj);
 typedef int	(*kxdrdproc_t)(void *rqstp, struct xdr_stream *xdr, void *obj);
 
 extern void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p);
+extern void xdr_init_encode_pages(struct xdr_stream *xdr, struct xdr_buf *buf,
+				  struct page **pages, unsigned int len);
 extern __be32 *xdr_reserve_space(struct xdr_stream *xdr, size_t nbytes);
 extern void xdr_commit_encode(struct xdr_stream *xdr);
 extern void xdr_truncate_encode(struct xdr_stream *xdr, size_t len);
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 63c1c36..f97b96b 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -483,6 +483,31 @@ void xdr_init_encode(struct xdr_stream *xdr, struct xdr_buf *buf, __be32 *p)
 EXPORT_SYMBOL_GPL(xdr_init_encode);
 
 /**
+ * xdr_init_encode_pages - Initialize struct xdr_stream for encoding into pages
+ * @xdr: pointer to xdr_stream struct
+ * @buf: pointer to XDR buffer in which to encode data
+ * @pages: pages array in which to encode
+ * @len: maximum length of @buf
+ *
+ * Initialize @xdr and @buf for encoding into the @pages array.  If a
+ * page in @pages is NULL, it will be allocated on demand.
+ */
+void xdr_init_encode_pages(struct xdr_stream *xdr, struct xdr_buf *buf,
+			   struct page **pages, unsigned int len)
+{
+	memset(buf, 0, sizeof(*buf));
+	buf->pages = pages;
+	buf->page_len = len;
+	buf->buflen = len;
+
+	memset(xdr, 0, sizeof(*xdr));
+	xdr->buf = buf;
+	xdr->iov = buf->head;
+	xdr->page_ptr = pages - 1;
+}
+EXPORT_SYMBOL_GPL(xdr_init_encode_pages);
+
+/**
  * xdr_commit_encode - Ensure all data is written to buffer
  * @xdr: pointer to xdr_stream
  *
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
