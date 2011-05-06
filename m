Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p46Gddot203751 for <xfs@oss.sgi.com>; Fri, 6 May 2011 11:39:39 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2EB8B8F8094
	for <xfs@oss.sgi.com>; Fri,  6 May 2011 09:43:16 -0700 (PDT)
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsprogs: fix open_by_handle memory leak
Date: Fri,  6 May 2011 11:42:57 -0500
Message-Id: <1304700177-8505-1-git-send-email-wkendall@sgi.com>
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

open_by_handle() calls handle_to_fshandle() which
allocates an fshandle on the heap, which is never
freed by open_by_handle(). There is no need to
call handle_to_fshandle() though, just pass the
fhandle (rather than fshandle) to handle_to_fsfd(),
like the other *_by_handle() functions do.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 libhandle/handle.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/libhandle/handle.c b/libhandle/handle.c
index c3a6129..b1ec5f2 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -292,14 +292,9 @@ open_by_handle(
 {
 	int		fsfd;
 	char		*path;
-	void		*fshanp;
-	size_t		fshlen;
 	xfs_fsop_handlereq_t hreq;
 
-	if (handle_to_fshandle(hanp, hlen, &fshanp, &fshlen) != 0)
-		return -1;
-
-	if ((fsfd = handle_to_fsfd(fshanp, &path)) < 0)
+	if ((fsfd = handle_to_fsfd(hanp, &path)) < 0)
 		return -1;
 
 	hreq.fd       = 0;
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
