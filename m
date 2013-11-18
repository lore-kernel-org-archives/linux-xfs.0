Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 510E329E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 09:06:05 -0600 (CST)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 321728F8033
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 07:06:02 -0800 (PST)
Message-Id: <20131118150313.940966335@sgi.com>
Date: Mon, 18 Nov 2013 09:03:13 -0600
From: rjohnston@sgi.com
Subject: [patch 1/1] xfsprogs: update version for 3.2.0-alpha2
References: <20131118150313.940966335@sgi.com>
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

Update the VERSION, configure.ac and doc/CHANGES file for alpha
release, 3.2.0-alpha2

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
diff --git a/VERSION b/VERSION
index f4ab52c..f3b53c1 100644
--- a/VERSION
+++ b/VERSION
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=2
-PKG_REVISION=0-alpha1
+PKG_REVISION=0-alpha2
 PKG_BUILD=1
diff --git a/configure.ac b/configure.ac
index 949dd06..ae17c68 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,4 +1,4 @@
-AC_INIT([xfsprogs], [3.2.0-alpha1])
+AC_INIT([xfsprogs], [3.2.0-alpha2])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
diff --git a/doc/CHANGES b/doc/CHANGES
index 5a292d7..4d4648f 100644
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,7 @@
+xfsprogs-3.2.0-alpha2 (18 November 2013)
+	- Alpha release for the purpose of testing the CRC feature during the
+	  v3.12 kernel -rc series.
+
 xfsprogs-3.2.0-alpha1 (26 September 2013)
 	- Alpha release for the purpose of testing the CRC feature during the
 	  v3.12 kernel -rc series.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
