Return-Path: <xfs-bounces@oss.sgi.com>
Received: from nfs10.americas.sgi.com (nfs10.americas.sgi.com [128.162.245.67])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9IpTjK245695 for <xfs@oss.sgi.com>; Wed, 9 Nov 2011 12:51:30 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH] xfsprogs: add .ltdep to .gitignore
Date: Wed,  9 Nov 2011 13:03:58 -0600
Message-Id: <1320865438-27014-1-git-send-email-bpm@sgi.com>
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
Cc: bpm@sgi.com, aelder@sgi.com, arenaud@sgi.com

Make git ignore all .ltdep files which are created as part of the build
process.

~/xfsprogs # find | grep ltdep
./libxcmd/.ltdep
./libxfs/.ltdep
./libhandle/.ltdep
./libdisk/.ltdep
./libxlog/.ltdep

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index aa6cd35..22b4f65 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,6 +1,7 @@
 # object files
 *.o
 .dep
+.ltdep
 
 # build system
 .census
-- 
1.7.8.rc0.46.g5ae0f

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
