Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C00FA7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 08:09:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 935018F8037
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 06:09:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xBJd0iI2aCHZH8VV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 06:09:00 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id CF659B0439
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 13:08:59 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] mkfs: update manpage for -i size
Date: Mon,  6 Jun 2016 15:08:51 +0200
Message-Id: <1465218531-16192-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

Adding CRC changed the minimum size for inode size from 256 to 512 bytes, but
it is not mentioned in the man page.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 man/man8/mkfs.xfs.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 980b0e1..c3629d9 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -358,7 +358,7 @@ or as the number fitting in a filesystem block with
 .BR perblock= .
 The minimum (and default)
 .I value
-is 256 bytes.
+is 256 bytes without crc, 512 bytes with crc enabled.
 The maximum
 .I value
 is 2048 (2 KiB) subject to the restriction that
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
