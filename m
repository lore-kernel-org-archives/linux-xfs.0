Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3141FC8
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 00:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706748746; cv=none; b=pgI2HPoEUfJ6CQXZY+7PnQqQVaGLsdxgaZp0qJOOp4JAVZZIEJRm9P7HYaPODt01FH9hjucY+tmjA0uwsfWihiml/ewreP3o+vl1ABuYrG0rGtAyKq86U9BRfj1AwOS/esfxMafJn1sXw9XJ2r/Tf066ZyJN4tMr4mnfarY/kug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706748746; c=relaxed/simple;
	bh=snSGpR9js7NT7WX03++8NLBT5BAjnWzdA3ku62siDZ8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubcCtV/m1Oe4qyeuZMEe0ChtsZdBio2hEWNsKrQlq4Q8bbFAdrHOJbK3lMBYSeMRpjjFMEndENhAn1ijwd1MU7jf2+eBQsVV9FeF/UQcl7hXvq6R1sxurThvstNf89I/SRm+h6gvWgpW1IA3zyCAhhmft5SykNOfw//igV2ovHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eF6MtPrH; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eF6MtPrH"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d934c8f8f7so3720645ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 16:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706748743; x=1707353543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DZ/i8uevVboeYT6hQ4wlxhvkJnImI+U1YC/Xo8sMnug=;
        b=eF6MtPrHdEmZAcuAJjhjWFVmk5+hI4WfiWhb9sP5ADCdtjcY2y1fFO6HvXgcKiTmwA
         2njfWQgHZNa0fwqLWfERHAGxYLCz8mMU9WuUD9g1xBnB7Ru1ZpFuck1rEi1SCktw94Ec
         oyfW0kFHdOS8C91d91ArMC8aqWDAKU2zE6nPWxbO1b9hXYTs0CkRMgOmu4thrVb4Qs0Q
         DvEW3XDcRdX5utIcIXCUse1+vko8CEkGGO6uYRR1TXd3sxWpNUjVbq0GtxH9FAULKChC
         eQVKysDeasdJlVcnPFrcvQPeILcvBJLZVe290SCuYxdRhlVJbIo+jgPumol28l1mILr/
         OhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706748743; x=1707353543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZ/i8uevVboeYT6hQ4wlxhvkJnImI+U1YC/Xo8sMnug=;
        b=CaPMmB8EuUoUnYJFuZ+wcqyFyfaJI61Ofjvzcf97ArKwLxmOpkXiH2r0FZdYaar3QZ
         8TUHtonuvth3Rl0TrQjP1HBUt34OocDyiWQ2uv7lWLUeXxLXfP2A2SkRX116tvrg4NDD
         g7wd+x66dFv4DEHa9+ftsqiIx8KP+V3Ccil3u6kUuR2uqoxFvUqJXZJ3qvSJhIEuwUrh
         Wkt8+UcbD5zixqgN45qfKWCdIoC4RyL7BKxNXMUVm6MeN6SVJjCH2NnGVWF798Hd4SdV
         i9UXJ8LtzFOxPFOtCtYaJXaW2zvvO9zZ/7F8pW1BK2KhmSK23pqk/0OwUl87mpEjcye9
         suzw==
X-Gm-Message-State: AOJu0YwdyCUDw23SLAUmhrzl7pdjWxCH+VWSCtfEGkRFfXVkhj3JR5fg
	C2pt4Jo3WOvgULcABh/wQXb/HcnMsTexPPrjTGNyLDJ+irZJnwlDvkrwKXhQ7sft/t31P3W4+M4
	y
X-Google-Smtp-Source: AGHT+IG6w7UgvXWndN8SFh6JHZ5N5K6ekOmh21mXvK93UDft3HsxQNSNUwc6NywsCavWA9iLX8OxPA==
X-Received: by 2002:a17:902:8602:b0:1d3:45c8:bc0f with SMTP id f2-20020a170902860200b001d345c8bc0fmr703907plo.46.1706748743593;
        Wed, 31 Jan 2024 16:52:23 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id jd6-20020a170903260600b001d8f82f90ddsm648759plb.183.2024.01.31.16.52.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 16:52:22 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rVLJU-000O7m-00
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rVLJT-00000004WRB-24RA
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from xfs_iget
Date: Thu,  1 Feb 2024 11:30:16 +1100
Message-ID: <20240201005217.1011010-5-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201005217.1011010-1-david@fromorbit.com>
References: <20240201005217.1011010-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

When xfs_iget() finds an inode that is queued for inactivation, it
issues an inodegc flush to trigger the inactivation work and then
retries the lookup.

However, when the filesystem is frozen, inodegc is turned off and
the flush does nothing and does not block. This results in lookup
spinning on NEED_INACTIVE inodes and being unable to make progress
until the filesystem is thawed. This is less than ideal.

The only reason we can't immediately recycle the inode is that it
queued on a lockless list we can't remove it from. However, those
lists now support lazy removal, and so we can now modify the lookup
code to reactivate inode queued for inactivation. The process is
identical to how we recycle reclaimable inodes from xfs_iget(), so
this ends up being a relatively simple change to make.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 98 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 10588f78f679..1fc55ed0692c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -64,6 +64,8 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
 					 XFS_ICWALK_FLAG_RECLAIM_SICK | \
 					 XFS_ICWALK_FLAG_UNION)
 
+static void xfs_inodegc_queue(struct xfs_inode *ip);
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -328,6 +330,7 @@ xfs_reinit_inode(
 	return error;
 }
 
+
 /*
  * Carefully nudge an inode whose VFS state has been torn down back into a
  * usable state.  Drops the i_flags_lock and the rcu read lock.
@@ -391,7 +394,71 @@ xfs_iget_recycle(
 	inode->i_state = I_NEW;
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
+	XFS_STATS_INC(mp, xs_ig_frecycle);
+	return 0;
+}
 
+static int
+xfs_iget_reactivate(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip) __releases(&ip->i_flags_lock)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	int			error;
+
+	trace_xfs_iget_recycle(ip);
+
+	/*
+	 * Take the ILOCK here to serialise against lookup races with putting
+	 * the inode back on the inodegc queue during error handling.
+	 */
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+		return -EAGAIN;
+
+	/*
+	 * Move the state to inactivating so both inactivation and racing
+	 * lookups will skip over this inode until we've finished reactivating
+	 * it and can return it to the XFS_INEW state.
+	 */
+	ip->i_flags &= ~XFS_NEED_INACTIVE;
+	ip->i_flags |= XFS_INACTIVATING;
+	spin_unlock(&ip->i_flags_lock);
+	rcu_read_unlock();
+
+	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
+	error = xfs_reinit_inode(mp, inode);
+	if (error) {
+		/*
+		 * Well, that sucks. Put the inode back on the inactive queue.
+		 * Do this while still under the ILOCK so that we can set the
+		 * NEED_INACTIVE flag and clear the INACTIVATING flag an not
+		 * have another lookup race with us before we've finished
+		 * putting the inode back on the inodegc queue.
+		 */
+		spin_unlock(&ip->i_flags_lock);
+		ip->i_flags |= XFS_NEED_INACTIVE;
+		ip->i_flags &= ~XFS_INACTIVATING;
+		spin_unlock(&ip->i_flags_lock);
+
+		xfs_inodegc_queue(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+		return error;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * Reset the inode state to new so that xfs_iget() will complete
+	 * the required remaining inode initialisation before it returns the
+	 * inode to the caller.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
+	ip->i_flags |= XFS_INEW;
+	inode->i_state = I_NEW;
+	spin_unlock(&ip->i_flags_lock);
+	XFS_STATS_INC(mp, xs_ig_frecycle);
 	return 0;
 }
 
@@ -523,14 +590,6 @@ xfs_iget_cache_hit(
 	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING))
 		goto out_skip;
 
-	if (ip->i_flags & XFS_NEED_INACTIVE) {
-		/* Unlinked inodes cannot be re-grabbed. */
-		if (VFS_I(ip)->i_nlink == 0) {
-			error = -ENOENT;
-			goto out_error;
-		}
-		goto out_inodegc_flush;
-	}
 
 	/*
 	 * Check the inode free state is valid. This also detects lookup
@@ -542,11 +601,18 @@ xfs_iget_cache_hit(
 
 	/* Skip inodes that have no vfs state. */
 	if ((flags & XFS_IGET_INCORE) &&
-	    (ip->i_flags & XFS_IRECLAIMABLE))
+	    (ip->i_flags & (XFS_IRECLAIMABLE | XFS_NEED_INACTIVE)))
 		goto out_skip;
 
 	/* The inode fits the selection criteria; process it. */
-	if (ip->i_flags & XFS_IRECLAIMABLE) {
+	if (ip->i_flags & XFS_NEED_INACTIVE) {
+		/* Drops i_flags_lock and RCU read lock. */
+		error = xfs_iget_reactivate(pag, ip);
+		if (error == -EAGAIN)
+			goto out_skip;
+		if (error)
+			return error;
+	} else if (ip->i_flags & XFS_IRECLAIMABLE) {
 		/* Drops i_flags_lock and RCU read lock. */
 		error = xfs_iget_recycle(pag, ip);
 		if (error == -EAGAIN)
@@ -575,23 +641,11 @@ xfs_iget_cache_hit(
 
 out_skip:
 	trace_xfs_iget_skip(ip);
-	XFS_STATS_INC(mp, xs_ig_frecycle);
 	error = -EAGAIN;
 out_error:
 	spin_unlock(&ip->i_flags_lock);
 	rcu_read_unlock();
 	return error;
-
-out_inodegc_flush:
-	spin_unlock(&ip->i_flags_lock);
-	rcu_read_unlock();
-	/*
-	 * Do not wait for the workers, because the caller could hold an AGI
-	 * buffer lock.  We're just going to sleep in a loop anyway.
-	 */
-	if (xfs_is_inodegc_enabled(mp))
-		xfs_inodegc_queue_all(mp);
-	return -EAGAIN;
 }
 
 static int
-- 
2.43.0

