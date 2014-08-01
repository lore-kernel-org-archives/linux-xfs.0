Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F11367F58
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 09:59:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DECD78F8089
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 07:59:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AB3g992LHLcpQrHx for <xfs@oss.sgi.com>;
	Fri, 01 Aug 2014 07:59:22 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/6] xfs_fsr: free handlep in fsrfs
Date: Fri,  1 Aug 2014 09:59:16 -0500
Message-Id: <1406905159-12415-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406905159-12415-1-git-send-email-sandeen@redhat.com>
References: <1406905159-12415-1-git-send-email-sandeen@redhat.com>
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

We leaked the fshandlep in both error returns and
normal function exit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fsr/xfs_fsr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 752d2db..580604c 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -702,6 +702,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 	if ((fsfd = open(mntdir, O_RDONLY)) < 0) {
 		fsrprintf(_("unable to open: %s: %s\n"),
 		          mntdir, strerror( errno ));
+		free(fshandlep);
 		return -1;
 	}
 
@@ -709,6 +710,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
 			  mntdir);
 		close(fsfd);
+		free(fshandlep);
 		return -1;
 	}
 
@@ -774,6 +776,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 out0:
 	tmp_close(mntdir);
 	close(fsfd);
+	free(fshandlep);
 	return 0;
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
