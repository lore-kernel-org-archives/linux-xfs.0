Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 00F867CA2
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 18:58:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83F86AC003
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 16:58:51 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7ZqMjszJcgjyqtHc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 16:58:49 -0800 (PST)
Date: Tue, 26 Jan 2016 16:58:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/5 v2] xfs_io: detect the '-R' option in getopt
Message-ID: <20160127005845.GC5852@birch.djwong.org>
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160123003502.2475.99558.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Configure getopt to accept the -R argument to pwrite.

v2: Accept -F and -B while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/pwrite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/pwrite.c b/io/pwrite.c
index fd9114d..4fc8de6 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -259,7 +259,7 @@ pwrite_f(
 	init_cvtnum(&fsblocksize, &fssectsize);
 	bsize = fsblocksize;
 
-	while ((c = getopt(argc, argv, "b:Cdf:i:qs:S:uV:wWZ:")) != EOF) {
+	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
 		switch (c) {
 		case 'b':
 			tmp = cvtnum(fsblocksize, fssectsize, optarg);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
