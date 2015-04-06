Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F18B29E01
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 17:43:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E02A1AC003
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 15:43:52 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id aXFCobA2st8GdFp8 for
	<xfs@oss.sgi.com>; Mon, 06 Apr 2015 15:43:51 -0700 (PDT)
From: Sage Weil <sage@redhat.com>
Subject: [PATCH] libhandle: add fd_to_handle to handle.h
Date: Mon,  6 Apr 2015 15:43:01 -0700
Message-Id: <1428360181-10401-1-git-send-email-sage@redhat.com>
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
Cc: Sage Weil <sage@redhat.com>

It's on the man page but strangely missing from the header.

Signed-off-by: Sage Weil <sage@redhat.com>
---
 include/handle.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/handle.h b/include/handle.h
index b211a2f..ee69a11 100644
--- a/include/handle.h
+++ b/include/handle.h
@@ -28,6 +28,7 @@ struct parent;
 
 extern int  path_to_handle (char *__path, void **__hanp, size_t *__hlen);
 extern int  path_to_fshandle (char *__path, void **__fshanp, size_t *__fshlen);
+extern int  fd_to_handle (int fd, void **hanp, size_t *hlen);
 extern int  handle_to_fshandle (void *__hanp, size_t __hlen, void **__fshanp,
 				size_t *__fshlen);
 extern void free_handle (void *__hanp, size_t __hlen);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
