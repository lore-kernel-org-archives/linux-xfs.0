Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CLiAv6033555 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 15:44:11 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201002122145.o1CLjMRf028235@stout.americas.sgi.com>
Date: Fri, 12 Feb 2010 15:45:22 -0600
Subject: [PATCH] xfstests: clean up dmapi Makefile
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The Makefile for the dmapi subdirectory gets generated
by the build process.  It should be cleaned up when
doing a distclean.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 Makefile |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -99,3 +99,7 @@ install-dev install-lib:
 realclean distclean: clean
 	rm -f $(LDIRT) $(CONFIGURE)
 	rm -rf autom4te.cache Logs
+ifeq ($(HAVE_DMAPI), true)
+	rm -f $(DMAPI_MAKEFILE)
+endif
+

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
