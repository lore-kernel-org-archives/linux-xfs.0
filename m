Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PIZjXc136915 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 13:35:45 -0500
Message-Id: <20121025183727.315188527@sgi.com>
Date: Thu, 25 Oct 2012 13:36:38 -0500
From: bpm@sgi.com
Subject: [patch 4/4] [PATCH] xfsdump: rename configure.in to configure.ac
References: <20121025183634.486901001@sgi.com>
Content-Disposition: inline;
	filename=0001-xfsdump-rename-configure.in-to-configure.ac.patch
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
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index b1a7350..39881af 100644
--- a/Makefile
+++ b/Makefile
@@ -28,7 +28,7 @@ SRCDIR = $(PKG_NAME)-$(PKG_VERSION)
 SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
 
 CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
-LSRCFILES = configure.in release.sh README VERSION $(CONFIGURE)
+LSRCFILES = configure.ac release.sh README VERSION $(CONFIGURE)
 
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* built .census install.* install-dev.* *.gz \
-- 
1.7.7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
