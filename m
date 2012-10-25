Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PIZiOC136890 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 13:35:44 -0500
Message-Id: <20121025183726.890367820@sgi.com>
Date: Thu, 25 Oct 2012 13:36:36 -0500
From: bpm@sgi.com
Subject: [patch 2/4] [PATCH] xfstests: rename configure.in to configure.ac
References: <20121025183634.486901001@sgi.com>
Content-Disposition: inline;
	filename=0001-xfstests-rename-configure.in-to-configure.ac.patch
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
Cc: Mike Frysinger <vapier@gentoo.org>

configure.in has been renamed to configure.ac.  Update the Makefile.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1490e21..36a26c8 100644
--- a/Makefile
+++ b/Makefile
@@ -41,7 +41,7 @@ endif
 
 TESTS = $(shell sed -n -e '/^[0-9][0-9][0-9]*/s/ .*//p' group)
 CONFIGURE = configure include/builddefs include/config.h
-LSRCFILES = configure configure.in aclocal.m4 README VERSION
+LSRCFILES = configure configure.ac aclocal.m4 README VERSION
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* check.log check.time
 
@@ -70,7 +70,7 @@ else
 clean:  # if configure hasn't run, nothing to clean
 endif
 
-configure: configure.in
+configure: configure.ac
 	autoheader
 	autoconf
 
-- 
1.7.7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
