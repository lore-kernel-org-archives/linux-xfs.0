Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 90DA57F6A
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:29:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A8BDAC003
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 08:29:36 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 60h7Cub0RdHMJEAW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 08:29:35 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/18] nfsd: factor out a helper to decode nfstime4 values
Date: Tue,  6 Jan 2015 17:28:26 +0100
Message-Id: <1420561721-9150-4-git-send-email-hch@lst.de>
In-Reply-To: <1420561721-9150-1-git-send-email-hch@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/nfs4xdr.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 15f7b73..fe31178 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -235,6 +235,22 @@ static char *savemem(struct nfsd4_compoundargs *argp, __be32 *p, int nbytes)
 }
 
 static __be32
+nfsd4_decode_time(struct nfsd4_compoundargs *argp, struct timespec *tv)
+{
+	DECODE_HEAD;
+	u64 sec;
+
+	READ_BUF(12);
+	p = xdr_decode_hyper(p, &sec);
+	tv->tv_sec = sec;
+	tv->tv_nsec = be32_to_cpup(p++);
+	if (tv->tv_nsec >= (u32)1000000000)
+		return nfserr_inval;
+
+	DECODE_TAIL;
+}
+
+static __be32
 nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 {
 	u32 bmlen;
@@ -267,7 +283,6 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 {
 	int expected_len, len = 0;
 	u32 dummy32;
-	u64 sec;
 	char *buf;
 
 	DECODE_HEAD;
@@ -358,15 +373,10 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		dummy32 = be32_to_cpup(p++);
 		switch (dummy32) {
 		case NFS4_SET_TO_CLIENT_TIME:
-			/* We require the high 32 bits of 'seconds' to be 0, and we ignore
-			   all 32 bits of 'nseconds'. */
-			READ_BUF(12);
 			len += 12;
-			p = xdr_decode_hyper(p, &sec);
-			iattr->ia_atime.tv_sec = (time_t)sec;
-			iattr->ia_atime.tv_nsec = be32_to_cpup(p++);
-			if (iattr->ia_atime.tv_nsec >= (u32)1000000000)
-				return nfserr_inval;
+			status = nfsd4_decode_time(argp, &iattr->ia_atime);
+			if (status)
+				return status;
 			iattr->ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
 			break;
 		case NFS4_SET_TO_SERVER_TIME:
@@ -382,15 +392,10 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		dummy32 = be32_to_cpup(p++);
 		switch (dummy32) {
 		case NFS4_SET_TO_CLIENT_TIME:
-			/* We require the high 32 bits of 'seconds' to be 0, and we ignore
-			   all 32 bits of 'nseconds'. */
-			READ_BUF(12);
 			len += 12;
-			p = xdr_decode_hyper(p, &sec);
-			iattr->ia_mtime.tv_sec = sec;
-			iattr->ia_mtime.tv_nsec = be32_to_cpup(p++);
-			if (iattr->ia_mtime.tv_nsec >= (u32)1000000000)
-				return nfserr_inval;
+			status = nfsd4_decode_time(argp, &iattr->ia_mtime);
+			if (status)
+				return status;
 			iattr->ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET);
 			break;
 		case NFS4_SET_TO_SERVER_TIME:
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
