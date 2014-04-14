Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 81E787F4E
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 09:48:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5E7F38F8049
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 07:48:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id U1b5XZwKEtn64IGD for <xfs@oss.sgi.com>;
	Mon, 14 Apr 2014 07:48:27 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6A4D063C5FC4
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 09:48:27 -0500 (CDT)
Message-ID: <534BF53C.4000706@sandeen.net>
Date: Mon, 14 Apr 2014 09:48:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mkfs.xfs: prevent close(-1) on protofile error path
References: <534BF472.8030908@sandeen.net>
In-Reply-To: <534BF472.8030908@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

My previous cleanups introduced this; in the case where
fd=open() failed, the out_fail: path would try to close(-1).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 308325b..5a47e27 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -84,7 +84,8 @@ setup_proto(
 	return buf;
 
 out_fail:
-	close(fd);
+	if (fd >= 0)
+		close(fd);
 	free(buf);
 	exit(1);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
