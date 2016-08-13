Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A31BD7CB8
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:25:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19DD5AC003
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:50 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id K8hBJMtDsAUdBiqb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:48 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 5B16620449
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:47 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTDV6DKfz104d
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:46 +0200 (CEST)
Resent-Message-ID: <20160813172450.GG3858@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <94800ca4e791ebca9ad6503afba31ebdfad672f7.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 13 Aug 2016 18:03:16 +0200
Subject: [PATCHv2 xfsprogs 09/14] fadvise.c: replace posix_fadvise64 by
	equivalent posix_fadvise
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

also fixes a compile failure on FreeBSD

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 io/fadvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/fadvise.c b/io/fadvise.c
index d59d1ff..46174f3 100644
--- a/io/fadvise.c
+++ b/io/fadvise.c
@@ -103,7 +103,7 @@ fadvise_f(
 		return command_usage(&fadvise_cmd);
 	}
 
-	if (posix_fadvise64(file->fd, offset, length, advise) < 0) {
+	if (posix_fadvise(file->fd, offset, length, advise) < 0) {
 		perror("fadvise");
 		return 0;
 	}
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
