Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 764B47CBC
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:25:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A57A304048
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:47 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id mBvZexGpprrszPNx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:45 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 2B36B2098D
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:44 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTDR4KKtz104W
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:43 +0200 (CEST)
Resent-Message-ID: <20160813172446.GF3858@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <4606f95e95d055534c17ed8a998351824298f627.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 13:03:16 +0200
Subject: [PATCHv2 xfsprogs 08/14] replace sendfile64 by equivalent sendfile
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
