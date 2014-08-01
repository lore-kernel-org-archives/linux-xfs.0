Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0ABEF7F59
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 09:59:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DECBD8F8087
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 07:59:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AaYn0icRcb7CeThx for <xfs@oss.sgi.com>;
	Fri, 01 Aug 2014 07:59:22 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/6] xfs_io: free fshandlep in parent_check()
Date: Fri,  1 Aug 2014 09:59:14 -0500
Message-Id: <1406905159-12415-2-git-send-email-sandeen@redhat.com>
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

The allocated fshandle wasn't freed in either normal
exit or error paths.

Do this, and consolidate cleanup into an out: target.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/parent.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/io/parent.c b/io/parent.c
index ca989e9..56e126d 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -258,9 +258,8 @@ parent_check(void)
 	if (!bstatbuf || !parentbuf) {
 		fprintf(stderr, _("unable to allocate buffers: %s\n"),
 			strerror(errno));
-		free(bstatbuf);
-		free(parentbuf);
-		return 1;
+		err_status = 1;
+		goto out;
 	}
 
 	if (do_bulkstat(parentbuf, &parentbuf_size, bstatbuf, fsfd, fshandlep) != 0)
@@ -272,8 +271,10 @@ parent_check(void)
 		printf(_("succeeded checking %llu inodes\n"),
 			(unsigned long long) inodes_checked);
 
+out:
 	free(bstatbuf);
 	free(parentbuf);
+	free(fshandlep);
 	return err_status;
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
