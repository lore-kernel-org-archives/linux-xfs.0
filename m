Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9CLqtmG173501 for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 16:52:55 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BEB4AC048
	for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 14:54:01 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id BABD07001CC3
	for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 16:54:00 -0500 (CDT)
Message-Id: <20101012215400.430780299@sgi.com>
Date: Tue, 12 Oct 2010 16:53:23 -0500
From: wkendall@sgi.com
Subject: [PATCH 1/2] xfsrestore: turn off NODECHK
References: <20101012215322.749700656@sgi.com>
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
development/debugging.  Having it on limits xfsrestore to
268 million directory entries instead of 4 billion. 

Signed-off-by: Bill Kendall <wkendall@sgi.com>

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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
