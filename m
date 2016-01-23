Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 952C67F62
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:35:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44114AC004
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:35:38 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GZmwrTRI7sv1zJY1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:35:35 -0800 (PST)
Subject: [PATCH 5/5] xfs_io: print dedupe errors to stderr, not stdout
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:35:31 -0800
Message-ID: <20160123003531.2475.59752.stgit@birch.djwong.org>
In-Reply-To: <20160123003502.2475.99558.stgit@birch.djwong.org>
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/reflink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/io/reflink.c b/io/reflink.c
index def01be..a09e82d 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -78,11 +78,13 @@ dedupe_ioctl(
 			goto done;
 		}
 		if (info->status < 0) {
-			printf("dedupe: %s\n", _(strerror(-info->status)));
+			fprintf(stderr, "dedupe: %s\n",
+					_(strerror(-info->status)));
 			goto done;
 		}
 		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
-			printf(_("Extents did not match.\n"));
+			fprintf(stderr, "dedupe: %s\n",
+					_("Extents did not match."));
 			goto done;
 		}
 		if (args->length != 0 &&

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
