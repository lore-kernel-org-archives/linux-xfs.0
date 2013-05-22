Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 093FE7CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 16:08:05 -0500 (CDT)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6D29304039
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 14:08:01 -0700 (PDT)
Message-Id: <20130522205819.586978467@gulag1.americas.sgi.com>
Date: Wed, 22 May 2013 15:58:19 -0500
From: rjohnston@sgi.com
Subject: [PATCH] xfsprogs: libhandle/Makefile - fix make install
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
To: xfs@oss.sgi.com

In the default section of libhandle/Makefile, ltdepend prevented
libhandle.so from being installed properly so remove it.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
--
diff --git a/libhandle/Makefile b/libhandle/Makefile
index 865ca22..2f39173 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -15,7 +15,7 @@ LTLDFLAGS += -Wl,--version-script,libhandle.sym
 CFILES = handle.c jdm.c
 LSRCFILES = libhandle.sym
 
-default: ltdepend $(LTLIBRARY)
+default: $(LTLIBRARY)
 
 include $(BUILDRULES)
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
