Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B8D157F51
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 09:10:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 994378F8039
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 07:10:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vipCa4EyGQR83zIa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 07:10:48 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 79B363672B2
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 14:10:47 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 12/11] xfsprogs: Update doc for OS X
Date: Thu, 13 Aug 2015 16:10:43 +0200
Message-Id: <1439475043-5473-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

Update build info and limitations.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 doc/INSTALL | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/doc/INSTALL b/doc/INSTALL
index ba3472b..b0443a3 100644
--- a/doc/INSTALL
+++ b/doc/INSTALL
@@ -52,12 +52,16 @@ Mac OS X Instructions
 =====================
 
 0. Note:  since there is no XFS implementation on Mac OS X, you are
-   severely limited in what you can do.  mkfs.xfs(8), xfs_db(8) and 
+   severely limited in what you can do.  mkfs.xfs(8), xfs_db(8) and
    xfs_repair(8) are the only functional tools on this platform, as
    they do not interact with the XFS kernel code at all.  Still, it
    can be useful to have access to these utilities from Mac OS X in
    a dual boot configuration, for example.
 
+   However, keep on mind that mkfs.xfs on Mac OS X has disabled
+   device access, although you can create a filesystem in a file.
+   Also note that existing filesystem detection is disabled.
+
 1. Configure, build and install the package
 
    The xfsprogs package uses autoconf/configure and expects a GNU build
@@ -65,7 +69,8 @@ Mac OS X Instructions
    and glibtool). 
 
    You will also need to have built and installed the UUID library which
-   is provided by the e2fsprogs source package.
+   is provided by the e2fsprogs source package. (Or use Homebrew, Macports
+   or any other 3rd party package manager.)
 
    Building libuuid:
 
@@ -84,7 +89,7 @@ Mac OS X Instructions
 	TAR=/usr/bin/gnutar
 	LIBTOOL=/usr/bin/glibtool
 	INSTALL_GROUP=wheel
-	LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no"
+	LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --enable-blkid=no"
 
 	$ make
 	$ su root
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
