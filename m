Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CBA4B7F5F
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 20:12:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8D8B8F8065
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 18:12:07 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HMxTwwDDFyPYBZZx for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 18:12:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ud9Bx-0007LJ-8K
	for xfs@oss.sgi.com; Fri, 17 May 2013 11:10:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ud9Bn-0002bq-5T
	for xfs@oss.sgi.com; Fri, 17 May 2013 11:10:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: Don't reference the EFI after it is freed
Date: Fri, 17 May 2013 11:10:27 +1000
Message-Id: <1368753029-9977-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1368753029-9977-1-git-send-email-david@fromorbit.com>
References: <1368753029-9977-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Checking the EFI for whether it is being released from recovery
after we've already released the known active reference is a mistake
worthy of a brown paper bag. Fix the (now) obvious use after free
that it can cause.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extfree_item.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index c0f3750..452920a 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -305,11 +305,12 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
 {
 	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
 	if (atomic_sub_and_test(nextents, &efip->efi_next_extent)) {
-		__xfs_efi_release(efip);
-
 		/* recovery needs us to drop the EFI reference, too */
 		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
 			__xfs_efi_release(efip);
+
+		__xfs_efi_release(efip);
+		/* efip may now have been freed, do not reference it again. */
 	}
 }
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
