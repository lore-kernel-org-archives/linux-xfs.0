Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AAFC87CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 14:46:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43D59AC004
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:46:26 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id oATAZtjgpU0G7XtK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:46:24 -0800 (PST)
Subject: [PATCH 2/3] punch-alternating: use the block size reported by the
	fs for punching
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Feb 2016 12:46:21 -0800
Message-ID: <20160215204621.7977.91236.stgit@birch.djwong.org>
In-Reply-To: <20160215204608.7977.2802.stgit@birch.djwong.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

When we're trying to punch alternating blocks out of a file, use the
bsize reported by fstatfs so that we can punch out single blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/punch-alternating.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/src/punch-alternating.c b/src/punch-alternating.c
index 9566310..4148622 100644
--- a/src/punch-alternating.c
+++ b/src/punch-alternating.c
@@ -14,6 +14,7 @@
 int main(int argc, char *argv[])
 {
 	struct stat	s;
+	struct statfs	sf;
 	off_t		offset;
 	int		fd;
 	blksize_t	blksz;
@@ -35,8 +36,12 @@ int main(int argc, char *argv[])
 	if (error)
 		goto err;
 
+	error = fstatfs(fd, &sf);
+	if (error)
+		goto err;
+
 	sz = s.st_size;
-	blksz = s.st_blksize;
+	blksz = sf.f_bsize;
 
 	mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 	for (offset = 0; offset < sz; offset += blksz * 2) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
