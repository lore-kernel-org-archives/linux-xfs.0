Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9484C7CA1
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 12:07:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6759C8F8033
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 10:07:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S7DXQ5NHI5gcMIS2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 23 Jun 2016 10:07:12 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id A60DB3F745
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 17:07:11 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-49-102.rdu2.redhat.com
	[10.10.49.102])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u5NH7Blk024982
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 13:07:11 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH] xfs_repair: resolve Coverity OVERFLOW_BEFORE_WIDEN
Date: Thu, 23 Jun 2016 12:07:10 -0500
Message-Id: <1466701630-6380-1-git-send-email-billodo@redhat.com>
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

Coverity complains that when multiplying two 32 bit values that
eventually will be stored in a 64 bit value that it's possible
the math could overflow unless one of the values being multiplied
is type cast to the proper size.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 repair/sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/sb.c b/repair/sb.c
index 3965953..8d4843c 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -230,7 +230,7 @@ find_secondary_sb(xfs_sb_t *rsb)
 	do_warn(_("\nattempting to find secondary superblock...\n"));
 
 	if (verify_sb_blocksize(rsb) == 0) {
-		skip = rsb->sb_agblocks * rsb->sb_blocksize;
+		skip = (__uint64_t)rsb->sb_agblocks * rsb->sb_blocksize;
 		if (skip >= XFS_AG_MIN_BYTES && skip <= XFS_AG_MAX_BYTES)
 			retval = __find_secondary_sb(rsb, skip, skip);
 	}
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
