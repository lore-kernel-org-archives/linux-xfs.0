Return-Path: <xfs-bounces@oss.sgi.com>
Received: from nfs10.americas.sgi.com (nfs10.americas.sgi.com [128.162.245.67])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEGgwNZ219365 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 10:42:58 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH] xfsdump: add .ltdep to .gitignore
Date: Mon, 14 Nov 2011 10:55:30 -0600
Message-Id: <1321289730-12687-1-git-send-email-bpm@sgi.com>
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
Cc: Ben Myers <bpm@sgi.com>

Make git ignore all .ltdep files.  They are created as part of the build
process:

	inventory/.ltdep
	librmt/.ltdep

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index f721c3f..77e3848 100644
--- a/.gitignore
+++ b/.gitignore
@@ -33,6 +33,7 @@ ltmain.sh
 *.lo
 *.la
 .libs
+.ltdep
 
 # gettext
 po/xfsdump.pot
-- 
1.7.8.rc0.46.g5ae0f

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
