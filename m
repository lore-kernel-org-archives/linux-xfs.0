Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93CnMGi241619 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 07:49:22 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 2/6] xfsprogs: libxcmd: avoid using strtok()
Date: Mon,  3 Oct 2011 07:49:16 -0500
Message-Id: <eba9155609154e80e0c529039ae98e1be8b3984c.1317646036.git.aelder@sgi.com>
In-Reply-To: <1317646160-5437-1-git-send-email-aelder@sgi.com>
References: <1317646160-5437-1-git-send-email-aelder@sgi.com>
In-Reply-To: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
References: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
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
Cc: Alex Elder <aelder@sgi.com>

The strtok() library routine overwrites delimiting bytes in the
string it is supplied.  It is also not length-constrained.

Since we're making a duplicate of the string anyway, and since we
are only finding the end of a single token, we can do both without
the need to modify the passed-in mount entry structure.

Add checking for memory allocation failures, and if one occurs just
exit (as is the practice elsewhere in this file).

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index ae9db32..ed93110 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -216,12 +216,21 @@ fs_extract_mount_options(
 
 	/* Do this only after we've finished processing mount options */
 	if (fslog) {
-		strtok(fslog, " ,");
-		fslog = strdup(fslog);
+		fslog = strndup(fslog, strcspn(fslog, " ,"));
+		if (!fslog) {
+			fprintf(stderr, _("%s: %s: out of memory (fslog)\n"),
+				    progname, __func__);
+			exit(1);
+		}
 	}
 	if (fsrt) {
-		strtok(fsrt, " ,");
-		fsrt = strdup(fsrt);
+		fsrt = strndup(fsrt, strcspn(fsrt, " ,"));
+		if (!fsrt) {
+			fprintf(stderr, _("%s: %s: out of memory (fsrt)\n"),
+				    progname, __func__);
+			free(fslog);
+			exit(1);
+		}
 	}
 
 	*logp = fslog;
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
