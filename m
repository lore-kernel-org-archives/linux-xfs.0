Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E3F627F56
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 09:59:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C19EA8F8081
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 07:59:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BjV2QovJXtGYtDbT for <xfs@oss.sgi.com>;
	Fri, 01 Aug 2014 07:59:23 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/6] xfs_io: fix leaks in parent_list()
Date: Fri,  1 Aug 2014 09:59:18 -0500
Message-Id: <1406905159-12415-6-git-send-email-sandeen@redhat.com>
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

parent_list() has instances where a handle is leaked,
both by going out of scope, and on error paths.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/parent.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/io/parent.c b/io/parent.c
index 56e126d..0313119 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -293,7 +293,7 @@ print_parent_entry(parent_t *parent, int fullpath)
 static int
 parent_list(int fullpath)
 {
-	void *handlep;
+	void *handlep = NULL;
 	size_t handlen;
 	int error, i;
 	int retval = 1;
@@ -313,6 +313,7 @@ parent_list(int fullpath)
 				progname, path, strerror(errno));
 			goto error;
 		}
+		free_handle(fshandle, fshlen);
 	}
 
 	if (path_to_handle(path, &handlep, &handlen) != 0) {
@@ -325,7 +326,7 @@ parent_list(int fullpath)
 		if (!parentbuf) {
 			fprintf(stderr, _("%s: unable to allocate parent buffer: %s\n"),
 				progname, strerror(errno));
-			return 1;
+			goto error;
 		}
 
 		if (fullpath) {
@@ -365,6 +366,7 @@ parent_list(int fullpath)
 
 	retval = 0;
 error:
+	free(handlep);
 	free(parentbuf);
 	return retval;
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
