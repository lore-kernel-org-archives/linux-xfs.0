Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 82E177F54
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 16:40:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 626BF8F8033
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 14:40:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vD9OwdV0jCGs4wJp for <xfs@oss.sgi.com>;
	Sat, 26 Jan 2013 14:40:34 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/8] libhandle: Guard against string overflow in
	path_to_fspath()
Date: Sat, 26 Jan 2013 16:40:25 -0600
Message-Id: <1359240032-11576-2-git-send-email-sandeen@redhat.com>
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

path_to_fspath does a blind strcpy into an array of
MAXPATHLEN; we should be sure to limit this so that it
does not go over the size of the array.

I don't think I see a way to get here today with a too-long
path, but I don't think it'll hurt to be defensive.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libhandle/handle.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/libhandle/handle.c b/libhandle/handle.c
index b1ec5f2..9a232fa 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -158,7 +158,8 @@ path_to_fspath(char *path)
 	if (S_ISREG(statbuf.st_mode) || S_ISDIR(statbuf.st_mode))
 		return path;
 
-	strcpy(dirpath, path);
+	strncpy(dirpath, path, MAXPATHLEN);
+	dirpath[MAXPATHLEN-1] = '\0';
 	return dirname(dirpath);
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
