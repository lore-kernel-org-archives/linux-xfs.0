Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DEB517CE2
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35BDEAC003
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:50 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id yx07wpOReHblVTgc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:48 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id E8C0A20A94
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:47 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQW3f0CzysK
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:47 +0200 (CEST)
Message-Id: <381255cfec13dc45dd4fe2232e94dc6ead92952b.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 13:03:16 +0200
Subject: [PATCH xfsprogs 10/14] replace sendfile64 by equivalent sendfile
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

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 io/sendfile.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/sendfile.c b/io/sendfile.c
index c082acf..edd31c9 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -56,11 +56,11 @@ send_buffer(
 
 	*total = 0;
 	while (count > 0) {
-		bytes = sendfile64(file->fd, fd, &off, bytes_remaining);
+		bytes = sendfile(file->fd, fd, &off, bytes_remaining);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
-			perror("sendfile64");
+			perror("sendfile");
 			return -1;
 		}
 		ops++;
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
