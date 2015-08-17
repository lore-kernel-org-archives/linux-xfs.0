Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 920AD29E03
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 11:23:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 747378F8033
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 09:23:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OqAVLS4sVlC5q5Xk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 09:23:50 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 03/11] xfsprogs: Change OS X-specific CFLAGS/LDFLAGS
Date: Mon, 17 Aug 2015 18:23:18 +0200
Message-Id: <1439828606-7886-4-git-send-email-jtulak@redhat.com>
In-Reply-To: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

OS X uses clang as a default compiler.
So remove incompatible options.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/builddefs.in | 2 +-
 libhandle/Makefile   | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index cdf2d41..c644a17 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -118,7 +118,7 @@ ifeq ($(PKG_PLATFORM),gnukfreebsd)
 PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
 endif
 ifeq ($(PKG_PLATFORM),darwin)
-PCFLAGS = -traditional-cpp $(GCCFLAGS)
+PCFLAGS = $(GCCFLAGS)
 DEPENDFLAGS = -D__APPLE__
 endif
 ifeq ($(PKG_PLATFORM),irix)
diff --git a/libhandle/Makefile b/libhandle/Makefile
index cc4ad1d..fe1a2af 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -10,7 +10,11 @@ LT_CURRENT = 1
 LT_REVISION = 3
 LT_AGE = 0
 
+ifeq ($(PKG_PLATFORM),darwin)
+LTLDFLAGS += -Wl,libhandle.sym
+else
 LTLDFLAGS += -Wl,--version-script,libhandle.sym
+endif
 
 CFILES = handle.c jdm.c
 LSRCFILES = libhandle.sym
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
