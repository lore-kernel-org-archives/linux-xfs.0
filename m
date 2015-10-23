Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B41229E59
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 13:46:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF492AC002
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 11:46:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ssiihzI93BuJopNy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2015 11:46:42 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v12 40/49] nfsd: Add support for unmapped richace identifiers
Date: Fri, 23 Oct 2015 20:41:53 +0200
Message-Id: <1445625722-13791-41-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445625722-13791-1-git-send-email-agruenba@redhat.com>
References: <1445625722-13791-1-git-send-email-agruenba@redhat.com>
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

Add support for encoding unmapped identifiers in richacl entries: local
filesystems are not usually supposed to store unmapped identifiers, but
allowing that for debugging purposes can be useful; for that, nfsd must
also be able to encode them.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/nfsd/acl.h     |  2 +-
 fs/nfsd/nfs4acl.c | 17 +++++++++++------
 fs/nfsd/nfs4xdr.c |  4 ++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/acl.h b/fs/nfsd/acl.h
index d73c664..4935144 100644
--- a/fs/nfsd/acl.h
+++ b/fs/nfsd/acl.h
@@ -51,7 +51,7 @@ struct svc_rqst;
 __be32 nfsd4_decode_ace_who(struct richace *ace, struct svc_rqst *rqstp,
 			    char *who, u32 len);
 __be32 nfsd4_encode_ace_who(struct xdr_stream *xdr, struct svc_rqst *rqstp,
-			    struct richace *ace);
+			    struct richace *ace, struct richacl *acl);
 
 struct richacl *nfsd4_get_acl(struct svc_rqst *rqstp, struct dentry *dentry);
 __be32 nfsd4_set_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index f017a76..3cc83fd 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -885,17 +885,22 @@ __be32 nfsd4_decode_ace_who(struct richace *ace, struct svc_rqst *rqstp,
 }
 
 __be32 nfsd4_encode_ace_who(struct xdr_stream *xdr, struct svc_rqst *rqstp,
-			    struct richace *ace)
+			    struct richace *ace, struct richacl *acl)
 {
-	if (ace->e_flags & RICHACE_SPECIAL_WHO) {
-		unsigned int special_id = ace->e_id.special;
+	if (ace->e_flags & (RICHACE_SPECIAL_WHO | RICHACE_UNMAPPED_WHO)) {
 		const char *who;
 		unsigned int len;
 		__be32 *p;
 
-		if (!nfs4acl_special_id_to_who(special_id, &who, &len)) {
-			WARN_ON_ONCE(1);
-			return nfserr_serverfault;
+		if (ace->e_flags & RICHACE_SPECIAL_WHO) {
+			if (!nfs4acl_special_id_to_who(ace->e_id.special,
+						       &who, &len)) {
+				WARN_ON_ONCE(1);
+				return nfserr_serverfault;
+			}
+		} else {
+			who = richace_unmapped_identifier(ace, acl);
+			len = strlen(who);
 		}
 		p = xdr_reserve_space(xdr, len + 4);
 		if (!p)
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 33d028c..8728d0e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2325,7 +2325,7 @@ static __be32 nfsd4_encode_acl_entries(struct xdr_stream *xdr,
 {
 	__be32 *p;
 
-	flags_mask &= ~RICHACE_SPECIAL_WHO;
+	flags_mask &= ~(RICHACE_SPECIAL_WHO | RICHACE_UNMAPPED_WHO);
 
 	p = xdr_reserve_space(xdr, 4);
 	if (!p)
@@ -2347,7 +2347,7 @@ static __be32 nfsd4_encode_acl_entries(struct xdr_stream *xdr,
 			*p++ = cpu_to_be32(ace->e_type);
 			*p++ = cpu_to_be32(ace->e_flags & flags_mask);
 			*p++ = cpu_to_be32(ace->e_mask & ace_mask);
-			status = nfsd4_encode_ace_who(xdr, rqstp, ace);
+			status = nfsd4_encode_ace_who(xdr, rqstp, ace, acl);
 			if (status)
 				return status;
 		}
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
