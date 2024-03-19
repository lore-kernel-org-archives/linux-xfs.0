Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFD92F26
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710807435; cv=none; b=n+IBnRa7rjsp2Ab3gL73lrxzTJHUQuLqsJIKey678c+Oqvp/KmGprhdhyezfcCPKkI0JjKxAaKEUCeFeOF6iU68z4dLUDv5Msy3cBtHhwn88dRDNzA3CZt7P+yx7QPumaS+VsaEKNaQ3gT9KfOX1vwISawiLjPsloqB51QBuDIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710807435; c=relaxed/simple;
	bh=wHqVaMI4xy3U1hWGEDchFJ1oRdRvPb042b0MHihlk7E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/B+EsZsBV/6fZ3Zv2ayKstQCrfjosIGiduqkcq0mtlX3xg7+HO1zWH29orO+FvIm7sWHLQ53Pftx6nJXtv8k6bqWHwuvB6yaNi4d+OyUYAckzvL2wV/Evet9R0NS3Dhn642UdbvLCnqe+TOSjKRp8nzizy+etCPJxkjXkl4OSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=bld66Bbf; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="bld66Bbf"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3bbbc6b4ed1so3821011b6e.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710807432; x=1711412232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vYVju6Qwf9lti2OS9PrCiq/kBri8X1HE/SQhRJwCOeE=;
        b=bld66BbfSwNW3v5jC2zNREZw/FNUJIn88mPqWtDfMSbGKrp6bE+GvB5E1hqiV9zuV+
         WHJRTdrQ0nBXIKuGJ6vZPaggKrPdTIYTFHWnxOS4P7hGksICTHxrzQFxLx7PhYPWtm6B
         F0zBSKIbodTMyT1+KbMr+0MKrhka6aCwMxsWLV6r2RZ4rZozHSVBY2HSfn5sTWOF7DrK
         8+RWyjKju7ltAyY4S/eAM7T79hmnXOneYC1Zd7HJf4QEM5XGvwROmN0pMJ9U0pTxzXB5
         TQUwVccp56uqDltiQzQ/Z3AuxBhVCBlnUNZaXUHxQC0PhIjbT/ooxhdmdxEVLdE+urR7
         nUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710807432; x=1711412232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vYVju6Qwf9lti2OS9PrCiq/kBri8X1HE/SQhRJwCOeE=;
        b=tEJVjvT31O7P3KFNE3XmPm7me/VW1qgVeZzxdimqydBufMS8HzFHpGBORVcG+Ra6vJ
         Z6cUqrMvYVI6dHrGNKmI8UQ8kn2+9EbSLp2TfodtY7dVesVR2F/GRAqWsD/1beg53Bdy
         QlivDV5YwBKfFhTFrVSwdDHt2a5twhhw438+dGE9xzkUkqF8ACxjJ4Ox/D2f4fczKVSv
         rIYMgB5yIuwTWfyrm0fCWZJrJE3qjGdj/Yq+F2ysMxkzpmoun9ftiRJxKrOWwtBG6kRa
         mUMt3nDYXyZRkuPkEVlvumpNTvVglWOruX9Dg555w/+ZPFbePIQlfVawgrVRB+rmhinJ
         Hxig==
X-Gm-Message-State: AOJu0Yzhp57RSCSf4V1tzO/NDlzHCnOp1w1xzrIJVrIbptC/ufHBSnhG
	Dk4pt4PObtnqTc9pyE/PwPjo+5Pbt6+0OIt8ETSqpahZ0w/lATdIl1xtsxKiVoLDGbiviGrdb8m
	C
X-Google-Smtp-Source: AGHT+IH4Daa4k669sfTI/Mi/dmDnC8nkhWr4Gi0GFBIOJUmbfkfMmH99LZnT9T6BYUVcmrttv7LZ3g==
X-Received: by 2002:a05:6808:3011:b0:3c2:400f:5302 with SMTP id ay17-20020a056808301100b003c2400f5302mr16974514oib.33.1710807432252;
        Mon, 18 Mar 2024 17:17:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id b18-20020a630c12000000b005dca5caed40sm7700427pgl.81.2024.03.18.17.17.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 17:17:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmNAD-003pkq-2y
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmNAD-0000000EONV-1eiL
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: allow lazy removal of inodes from the inodegc queues
Date: Tue, 19 Mar 2024 11:15:59 +1100
Message-ID: <20240319001707.3430251-4-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319001707.3430251-1-david@fromorbit.com>
References: <20240319001707.3430251-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

To allow us to recycle inodes that are awaiting inactivation, we
need to enable lazy removal of inodes from the list. Th elist is a
lockless single linked variant, so we can't just remove inodes from
the list at will.

Instead, we can remove them lazily whenever inodegc runs by enabling
the inodegc processing to determine whether inactivation needs to be
done at processing time rather than queuing time.

We've already modified the queuing code to only queue the inode if
it isn't already queued, so here all we need to do is modify the
queue processing to determine if inactivation needs to be done.

Hence we introduce the behaviour that we can cancel inactivation
processing simply by clearing the XFS_NEED_INACTIVE flag on the
inode. Processing will check this flag and skip inactivation
processing if it is not set. The flag is always set at queuing time,
regardless of whether the inode is already one the queues or not.
Hence if it is not set at processing time, it means that something
has cancelled the inactivation and we should just remove it from the
list and then leave it alone.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 559b8f71dc91..7359753b892b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1882,13 +1882,21 @@ xfs_inodegc_worker(
 		int	error;
 
 		/*
-		 * Switch state to inactivating and remove the inode from the
-		 * gclist. This allows the use of llist_on_list() in the queuing
-		 * code to determine if the inode is already on an inodegc
-		 * queue.
+		 * Remove the inode from the gclist and determine if it needs to
+		 * be processed. The XFS_NEED_INACTIVE flag gets cleared if the
+		 * inode is reactivated after queuing, but the list removal is
+		 * lazy and left up to us.
+		 *
+		 * We always remove the inode from the list to allow the use of
+		 * llist_on_list() in the queuing code to determine if the inode
+		 * is already on an inodegc queue.
 		 */
 		spin_lock(&ip->i_flags_lock);
 		init_llist_node(&ip->i_gclist);
+		if (!(ip->i_flags & XFS_NEED_INACTIVE)) {
+			spin_unlock(&ip->i_flags_lock);
+			continue;
+		}
 		ip->i_flags |= XFS_INACTIVATING;
 		ip->i_flags &= ~XFS_NEED_INACTIVE;
 		spin_unlock(&ip->i_flags_lock);
@@ -2160,7 +2168,6 @@ xfs_inode_mark_reclaimable(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			need_inactive;
 
 	XFS_STATS_INC(mp, vn_reclaim);
 
@@ -2169,8 +2176,23 @@ xfs_inode_mark_reclaimable(
 	 */
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_ALL_IRECLAIM_FLAGS));
 
-	need_inactive = xfs_inode_needs_inactive(ip);
-	if (need_inactive) {
+	/*
+	 * If the inode is already queued for inactivation because it was
+	 * re-activated and is now being reclaimed again (e.g. fs has been
+	 * frozen for a while) we must ensure that the inode waits for inodegc
+	 * to be run and removes it from the inodegc queue before it moves to
+	 * the reclaimable state and gets freed.
+	 *
+	 * We don't care about races here. We can't race with a list addition
+	 * because only one thread can be evicting the inode from the VFS cache,
+	 * hence false negatives can't occur and we only need to worry about
+	 * list removal races.  If we get a false positive from a list removal
+	 * race, then the inode goes through the inactive list whether it needs
+	 * to or not. This will slow down reclaim of this inode slightly but
+	 * should have no other side effects.
+	 */
+	if (llist_on_list(&ip->i_gclist) ||
+	    xfs_inode_needs_inactive(ip)) {
 		xfs_inodegc_queue(ip);
 		return;
 	}
-- 
2.43.0

