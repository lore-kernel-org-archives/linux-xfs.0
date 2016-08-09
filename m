Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 277D37CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 09:43:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DE054304051
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 07:43:55 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id vNTQ9LLNJPBl4uax (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 07:43:49 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id D1204340BF6
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 14:43:47 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH xfsprogs] libxcmd: link against used libs
Date: Tue,  9 Aug 2016 22:43:43 +0800
Message-Id: <20160809144343.2228-1-vapier@gentoo.org>
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

Since this lib uses symbols from libxfs (platform_findsizes) and many
symbols from libblkid, link against both.  Otherwise, the resulting
shared lib has missing symbols which makes linking against annoying.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 libxcmd/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index aab8d6d63624..46ba138a37e2 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -12,6 +12,8 @@ LT_AGE = 0
 
 CFILES = command.c input.c paths.c projects.c help.c quit.c topology.c
 
+LTLIBS = $(LIBXFS) $(LIBBLKID)
+
 ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
 endif
-- 
2.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
