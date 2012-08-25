Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7PN6SSf176656 for <xfs@oss.sgi.com>; Sat, 25 Aug 2012 18:06:28 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id Okz9hZ8LH7FH3tLw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Aug 2012 16:07:16 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id AEBAB33D3E6
	for <xfs@oss.sgi.com>; Sat, 25 Aug 2012 23:07:13 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] libxcmd: link against readline
Date: Sat, 25 Aug 2012 19:07:30 -0400
Message-Id: <1345936050-15139-1-git-send-email-vapier@gentoo.org>
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

This library uses readline funcs (the input.c file), so we need to link
this shared library against it.

URL: https://bugs.gentoo.org/432644
Reported-by: David Badia <dbadia@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 libxcmd/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index b3544f4..ce082a5 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -22,10 +22,12 @@ endif
 
 ifeq ($(ENABLE_READLINE),yes)
 LCFLAGS += -DENABLE_READLINE
+LTLIBS += $(LIBREADLINE) $(LIBTERMCAP)
 endif
 
 ifeq ($(ENABLE_EDITLINE),yes)
 LCFLAGS += -DENABLE_EDITLINE
+LTLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
 default: ltdepend $(LTLIBRARY)
-- 
1.7.9.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
