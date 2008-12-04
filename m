Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB47mXcP003069 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 01:48:39 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id A43978F8081
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 23:48:26 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id SAA21936 for <xfs@oss.sgi.com>;
	Thu, 4 Dec 2008 18:48:25 +1100
Message-ID: <49378B60.1060603@sgi.com>
Date: Thu, 04 Dec 2008 18:48:48 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Fix off by one error in page_region_mask()
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

final is calculated to be the last bit to set (ie inclusive) but when we
do the mask shifting final really needs to be first bit not to set.

For example if first and final are both bit 0 (ie only first bit to be set)
then mask is completely shifted and becomes all zeroes.

Or if first is 0 and final is 63 then the mask is shifted one bit when it
shouldn't be shifted at all.

--- xfs-fix.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ xfs-fix/fs/xfs/linux-2.6/xfs_buf.c
@@ -129,15 +129,17 @@ page_region_mask(
  	int		first, final;

  	first = BTOPR(offset);
-	final = BTOPRT(offset + length - 1);
-	first = min(first, final);
+	final = BTOPRT(offset + length);
+
+	if (first >= final)
+		return 0UL;

  	mask = ~0UL;
  	mask <<= BITS_PER_LONG - (final - first);
  	mask >>= BITS_PER_LONG - (final);

  	ASSERT(offset + length <= PAGE_CACHE_SIZE);
-	ASSERT((final - first) < BITS_PER_LONG && (final - first) >= 0);
+	ASSERT((final - first) <= BITS_PER_LONG && (final - first) > 0);

  	return mask;
  }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
