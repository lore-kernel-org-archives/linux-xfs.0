Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA5GZLx8209002 for <xfs@oss.sgi.com>; Fri, 5 Nov 2010 11:35:21 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF670304048
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 09:36:43 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id A89C8700372C
	for <xfs@oss.sgi.com>; Fri,  5 Nov 2010 11:36:43 -0500 (CDT)
Message-Id: <20101105163643.135791532@sgi.com>
Date: Fri, 05 Nov 2010 11:35:01 -0500
From: wkendall@sgi.com
Subject: [PATCH v2 1/9] xfsrestore: turn off NODECHK
References: <20101105163500.747192954@sgi.com>
Content-Disposition: inline; filename=no_node_check
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The NODECHK macro should only be enabled as needed for
development/debugging. Having it on limits xfsrestore to dumps
with 268 million directory entries instead of 4 billion. 

Signed-off-by: Bill Kendall <wkendall@sgi.com>

---
 restore/Makefile |    2 +-
 restore/node.c   |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: xfsdump-kernel.org/restore/Makefile
===================================================================
--- xfsdump-kernel.org.orig/restore/Makefile
+++ xfsdump-kernel.org/restore/Makefile
@@ -103,7 +103,7 @@ LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBA
 LTDEPENDENCIES = $(LIBRMT)
 
 LCFLAGS = -DRESTORE -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DPIPEINVFIX \
-	-DEOMFIX -DSESSCPLT -DWHITEPARSE -DNODECHK -DDIRENTHDR_CHECKSUM \
+	-DEOMFIX -DSESSCPLT -DWHITEPARSE -DDIRENTHDR_CHECKSUM \
 	-DF_FSSETDM
 
 default: depend $(LTCOMMAND)
Index: xfsdump-kernel.org/restore/node.c
===================================================================
--- xfsdump-kernel.org.orig/restore/node.c
+++ xfsdump-kernel.org/restore/node.c
@@ -42,7 +42,9 @@ extern size_t pgmask;
 
 /* macros for manipulating node handles when handle consistency
  * checking is enabled. the upper bits of a handle will be loaded
- * with the node gen count, described below.
+ * with the node gen count, described below. this should not be
+ * used for production code, it cuts into the number of dirents
+ * that xfsrestore can handle.
  */
 #define HDLGENCNT		4
 #define	HDLGENSHIFT		( NBBY * sizeof ( nh_t ) - HDLGENCNT )

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
