Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17AF27F3F
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 13:59:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B815030405F
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 11:59:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8woXLwMV0eZD31TG for
	<xfs@oss.sgi.com>; Thu, 15 May 2014 11:59:35 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4FIxXQX028283
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 15 May 2014 14:59:34 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4FIxWx0009304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 14:59:33 -0400
Message-ID: <53750E9F.3010301@redhat.com>
Date: Thu, 15 May 2014 13:59:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: don't let bplist index go negative in prefetch
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

After:

bbd3275 repair: don't unlock prefetch tree to read discontig buffers

Coverity spotted that it's possible for us to arrive at the loop
below with num == 1, and then we decrement it to 0, and try to
index bplist[num-1].

I think this was possible before the change, i.e. it's probably
not a regression.

Fix this by not trying to shrink the window unless we have
more than one buffer in the array.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/repair/prefetch.c b/repair/prefetch.c
index 4595310..b6d4755 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -505,7 +505,7 @@ pf_batch_read(
 		first_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[0]));
 		last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
 			XFS_BUF_SIZE(bplist[num-1]);
-		while (last_off - first_off > pf_max_bytes) {
+		while (num > 1 && last_off - first_off > pf_max_bytes) {
 			num--;
 			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
 				XFS_BUF_SIZE(bplist[num-1]);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
