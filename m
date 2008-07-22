Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 19:10:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6M2AG7G032087
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:10:17 -0700
Message-ID: <4885430D.7000506@sgi.com>
Date: Tue, 22 Jul 2008 12:16:45 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Do not access buffers after dropping reference count
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

We should not access a buffer after dropping it's reference count otherwise
we could race with another thread that releases the final reference count
and frees the buffer causing us to access potentially unmapped memory.

Lachlan

--- fs/xfs/linux-2.6/xfs_buf.c_1.257	2008-07-16 17:38:00.000000000 +1000
+++ fs/xfs/linux-2.6/xfs_buf.c	2008-07-22 12:05:50.000000000 +1000
@@ -839,6 +839,7 @@ xfs_buf_rele(
 		return;
 	}
 
+	ASSERT(atomic_read(&bp->b_hold) > 0);
 	if (atomic_dec_and_lock(&bp->b_hold, &hash->bh_lock)) {
 		if (bp->b_relse) {
 			atomic_inc(&bp->b_hold);
@@ -852,11 +853,6 @@ xfs_buf_rele(
 			spin_unlock(&hash->bh_lock);
 			xfs_buf_free(bp);
 		}
-	} else {
-		/*
-		 * Catch reference count leaks
-		 */
-		ASSERT(atomic_read(&bp->b_hold) >= 0);
 	}
 }
 
