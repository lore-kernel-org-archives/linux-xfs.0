Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4P7Ioj5044147 for <xfs@oss.sgi.com>; Fri, 25 May 2012 02:18:50 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id o3BJTQ2g2LDbQzc8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 00:18:48 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/6] build: use new autoconf constructs
Date: Fri, 25 May 2012 09:18:39 +0200
Message-Id: <1337930323-575-3-git-send-email-jengelh@inai.de>
In-Reply-To: <1337930323-575-1-git-send-email-jengelh@inai.de>
References: <1337930323-575-1-git-send-email-jengelh@inai.de>
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
Cc: jengelh@inai.de

Looks like AC_CONFIG_FILES existed since 2.14 already.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 664c0e9..c1181f4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,8 @@
-AC_INIT(include/libxfs.h)
+AC_INIT([xfsprogs], [3.1.8])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
+AC_CONFIG_SRCDIR([include/libxfs.h])
 AC_CONFIG_HEADER(include/platform_defs.h)
 AC_PREFIX_DEFAULT(/usr)
 
@@ -116,4 +117,5 @@ AC_TYPE_U32
 AC_SIZEOF_POINTERS_AND_LONG
 AC_MANUAL_FORMAT
 
-AC_OUTPUT(include/builddefs)
+AC_CONFIG_FILES([include/builddefs])
+AC_OUTPUT
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
