Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E4BCA7F37
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 16:40:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3E1E30407A
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 14:40:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IM3IEWWgANahlawP for <xfs@oss.sgi.com>;
	Sat, 26 Jan 2013 14:40:34 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 6/8] xfs_fsr: check strdup results properly in initallfs()
Date: Sat, 26 Jan 2013 16:40:30 -0600
Message-Id: <1359240032-11576-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>

initallfs() does 2 strdups, but then checks the result
of one of them twice, rather then checking each one.
Fix this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fsr/xfs_fsr.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 843f57d..b5aa3db 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -470,10 +470,14 @@ initallfs(char *mtab)
 		fs->dev = strdup(mp->mnt_fsname);
 		fs->mnt = strdup(mp->mnt_dir);
 
-		if (fs->mnt == NULL || fs->mnt == NULL) {
+		if (fs->dev == NULL) {
 			fsrprintf(_("strdup(%s) failed\n"), mp->mnt_fsname);
 			exit(1);
 		}
+		if (fs->mnt == NULL) {
+			fsrprintf(_("strdup(%s) failed\n"), mp->mnt_dir);
+			exit(1);
+		}
 		mi++;
 		fs++;
 	}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
