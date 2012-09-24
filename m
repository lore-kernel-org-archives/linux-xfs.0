Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ONcJb1229927 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 18:38:20 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id aDlq18pdZU2WFAGb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 16:39:36 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 48BB733D3E0
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 23:39:35 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 2/3] respect DESTDIR when installing
Date: Mon, 24 Sep 2012 19:39:37 -0400
Message-Id: <1348529978-30048-2-git-send-email-vapier@gentoo.org>
In-Reply-To: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
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

This makes the `make install DESTDIR=...` form work.  It keeps support
for all previous forms too (like DIST_ROOT).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/install-sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/install-sh b/include/install-sh
index 18c051f..c952a71 100755
--- a/include/install-sh
+++ b/include/install-sh
@@ -85,6 +85,8 @@ REAL_UID=$OWNER
 INSTALL=true
 MANIFEST=:
 
+: ${DIST_ROOT:=${DESTDIR}}
+
 [ -n "$DIST_MANIFEST" -a -z "$DIST_ROOT" ] && INSTALL=false
 [ -n "$DIST_MANIFEST" ] && MANIFEST="_manifest"
 
-- 
1.7.12

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
