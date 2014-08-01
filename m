Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E23BC7F55
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 09:59:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C1BA48F8084
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 07:59:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BIb2PNDe9MOCSeeu for <xfs@oss.sgi.com>;
	Fri, 01 Aug 2014 07:59:22 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/6] libhandle: Fix handle leak in path_to_fshandle error paths
Date: Fri,  1 Aug 2014 09:59:17 -0500
Message-Id: <1406905159-12415-5-git-send-email-sandeen@redhat.com>
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

path_to_fshandle calls obj_to_handle, which potentially
allocates a handle, but the handle isn't freed on
a subsequent error path.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libhandle/handle.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/libhandle/handle.c b/libhandle/handle.c
index 9f81483..3c1395a 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -97,6 +97,7 @@ path_to_fshandle(
 		/* new filesystem. add it to the cache */
 		fdhp = malloc(sizeof(struct fdhash));
 		if (fdhp == NULL) {
+			free(*fshanp);
 			close(fd);
 			errno = ENOMEM;
 			return -1;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
