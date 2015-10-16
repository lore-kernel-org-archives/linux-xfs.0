Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AAB427FF9
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:23:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53875AC004
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:23:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id slTChW8By1n3ldLl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:23:26 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 44/48] nfs: Fix GETATTR bitmap verification
Date: Fri, 16 Oct 2015 17:18:22 +0200
Message-Id: <1445008706-15115-45-git-send-email-agruenba@redhat.com>
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

When decoding GETATTR replies, the client checks the attribute bitmap
for which attributes the server has sent.  It misses bits at the word
boundaries, though; fix that.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/nfs/nfs4xdr.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 788adf3..6f6d921 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4375,6 +4375,11 @@ static int decode_statfs(struct xdr_stream *xdr, struct nfs_fsstat *fsstat)
 		goto xdr_error;
 	if ((status = decode_attr_files_total(xdr, bitmap, &fsstat->tfiles)) != 0)
 		goto xdr_error;
+
+	status = -EIO;
+	if (unlikely(bitmap[0]))
+		goto xdr_error;
+
 	if ((status = decode_attr_space_avail(xdr, bitmap, &fsstat->abytes)) != 0)
 		goto xdr_error;
 	if ((status = decode_attr_space_free(xdr, bitmap, &fsstat->fbytes)) != 0)
@@ -4574,6 +4579,10 @@ static int decode_getfattr_attrs(struct xdr_stream *xdr, uint32_t *bitmap,
 		goto xdr_error;
 	fattr->valid |= status;
 
+	status = -EIO;
+	if (unlikely(bitmap[0]))
+		goto xdr_error;
+
 	status = decode_attr_mode(xdr, bitmap, &fmode);
 	if (status < 0)
 		goto xdr_error;
@@ -4627,6 +4636,10 @@ static int decode_getfattr_attrs(struct xdr_stream *xdr, uint32_t *bitmap,
 		goto xdr_error;
 	fattr->valid |= status;
 
+	status = -EIO;
+	if (unlikely(bitmap[1]))
+		goto xdr_error;
+
 	status = decode_attr_mdsthreshold(xdr, bitmap, fattr->mdsthreshold);
 	if (status < 0)
 		goto xdr_error;
@@ -4789,12 +4802,22 @@ static int decode_fsinfo(struct xdr_stream *xdr, struct nfs_fsinfo *fsinfo)
 	if ((status = decode_attr_maxwrite(xdr, bitmap, &fsinfo->wtmax)) != 0)
 		goto xdr_error;
 	fsinfo->wtpref = fsinfo->wtmax;
+
+	status = -EIO;
+	if (unlikely(bitmap[0]))
+		goto xdr_error;
+
 	status = decode_attr_time_delta(xdr, bitmap, &fsinfo->time_delta);
 	if (status != 0)
 		goto xdr_error;
 	status = decode_attr_pnfstype(xdr, bitmap, &fsinfo->layouttype);
 	if (status != 0)
 		goto xdr_error;
+
+	status = -EIO;
+	if (unlikely(bitmap[1]))
+		goto xdr_error;
+
 	status = decode_attr_layout_blksize(xdr, bitmap, &fsinfo->blksize);
 	if (status)
 		goto xdr_error;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
