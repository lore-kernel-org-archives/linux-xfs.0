Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36A12F5B
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710807435; cv=none; b=gEVMGtiyvn2nQPKx5RQ61Oi2ZyGXMfaSxpSM8HbTSa3PMvWITCblbMfT8wZ0mSy3ySysNHvd7BG8xoj+ZWynxoYhDAm+huggiVfOzZrXRiNcPysuYHtNjDjRIbEbcu4FRKGMBKsv+Tn7Yb0ZuOKVX3cDL1QYkVn56I0niPJJpzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710807435; c=relaxed/simple;
	bh=PSvqTpkS4fozP/IBctLIB4nZm9FVIu6ICdCwOUPt784=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNyYdxOqJHgy14e8cyVWC1Y3Qp79j4Zr3AGi6AO1EHYlnPTVnNNY5qAX2zf4jvCfPoVK0Q4+gwomGsV5nDO0P8oymHE09Lf0zEuOlqfGoVUJZqQy/Vnf4jOHlJdJXXSitJxxozSbCk+unWFa8SjpvjsrDyUapl/KqTF4eq0SWs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ZtNsj+0l; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ZtNsj+0l"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dde26f7e1dso35134335ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710807433; x=1711412233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jNiN0Kr8TGljxcsoI4JBbWsa1vOCRxTDW+ISsIi2EQs=;
        b=ZtNsj+0ldwbvfpukaVh1oMj2In9NiAkSKL1oCBQ5SNSzB9yX1qaQfYeAvPyFDMLYj2
         HtKJbb/zF5OdZlEM/6VkzLiytQNPhcjCB2prIJ2UkkKXQvjvCjFM0xTOBpnRfxgAICmh
         e3q6i+dNqbZfTWKiJ/IHX60acZ7KaSJFHCOZaCpFdUCSfasjXRmoLw+bXmmzfJCTk6I7
         gUcfo3rnsRiGZzjQXlu3L/q+gXOA409tOikhVXQR80I6nS9p3SpNfK7Aqd4dfR9wd3Xw
         uWVG/u36ZNwMz/PRJ556mR2IXuxxh5dKOk2jYJiIe4MUjCzf+frqB9r3uBUihMUn/JO5
         AuaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710807433; x=1711412233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jNiN0Kr8TGljxcsoI4JBbWsa1vOCRxTDW+ISsIi2EQs=;
        b=hwGEMMgO/j4+DZBMIqUKkxxchNLzqi4x/uVPrX30aSf3cEKmS7ObWgsMDsVPXzP5Sp
         vlh8J2mRFfYWfTvE8EJySgWzQD8vJFUY8AEGoqG03eKuZ2FU0U0t6j/PIBhHr+VrO5pS
         HNGmPm2Gsvb8KoJoeHkrR7iD/B+gbqCkhOj8Wg42AKPuS80dN+m0Zc6tNlb8xz04rHaz
         4YHkI/6rhUFLtRT9ZLgUzL73Geliseb7baO69SnYlvkm3HmrII8Dp6AbOKwmWVHpS4/3
         8I7uLTr/T8zgFaeNZ2AS6gP8X08FLZ4W53cT+x3142QjE2QBORqmDAMO8xrurgUpS4UM
         PB/Q==
X-Gm-Message-State: AOJu0YxJve2pVTMaS0eZIJJxMaP8QEpv/tD2s1BrDRe56bv3nizphipK
	PFCiMYUKB3940nbinwRWeA3WGm3NPzapU29Y71QpEj1NC05U0XFAJYoygJUQJ56iKDE3vJepM6l
	I
X-Google-Smtp-Source: AGHT+IFa/GDzICRw7RfNEjQOaAryiOwHcU7Brcbk2pvfBT3AtD5ab/qltp7I+9SN+IHA1GX5QGKrYw==
X-Received: by 2002:a17:902:c952:b0:1dd:6765:103 with SMTP id i18-20020a170902c95200b001dd67650103mr13199835pla.48.1710807433072;
        Mon, 18 Mar 2024 17:17:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id km12-20020a17090327cc00b001dd5ba34f3esm9900935plb.278.2024.03.18.17.17.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 17:17:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmNAD-003pkj-2k
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmNAD-0000000EONN-1MyD
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: make inode inactivation state changes atomic
Date: Tue, 19 Mar 2024 11:15:57 +1100
Message-ID: <20240319001707.3430251-2-david@fromorbit.com>
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

We need the XFS_NEED_INACTIVE flag to correspond to whether the
inode is on the inodegc queues so that we can then use this state
for lazy removal.

To do this, move the addition of the inode to the inodegc queue
under the ip->i_flags_lock so that it is atomic w.r.t. setting
the XFS_NEED_INACTIVE flag.

Then, when we remove the inode from the inodegc list to actually run
inactivation, clear the XFS_NEED_INACTIVE at the same time we are
setting XFS_INACTIVATING to indicate that inactivation is in
progress.

These changes result in all the state changes and inodegc queuing
being atomic w.r.t. each other and inode lookups via the use of the
ip->i_flags lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 16 ++++++++++++++--
 fs/xfs/xfs_inode.h  | 11 +++++++----
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6c87b90754c4..9a362964f656 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1880,7 +1880,12 @@ xfs_inodegc_worker(
 	llist_for_each_entry_safe(ip, n, node, i_gclist) {
 		int	error;
 
-		xfs_iflags_set(ip, XFS_INACTIVATING);
+		/* Switch state to inactivating. */
+		spin_lock(&ip->i_flags_lock);
+		ip->i_flags |= XFS_INACTIVATING;
+		ip->i_flags &= ~XFS_NEED_INACTIVE;
+		spin_unlock(&ip->i_flags_lock);
+
 		error = xfs_inodegc_inactivate(ip);
 		if (error && !gc->error)
 			gc->error = error;
@@ -2075,9 +2080,14 @@ xfs_inodegc_queue(
 	unsigned long		queue_delay = 1;
 
 	trace_xfs_inode_set_need_inactive(ip);
+
+	/*
+	 * Put the addition of the inode to the gc list under the
+	 * ip->i_flags_lock so that the state change and list addition are
+	 * atomic w.r.t. lookup operations under the ip->i_flags_lock.
+	 */
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags |= XFS_NEED_INACTIVE;
-	spin_unlock(&ip->i_flags_lock);
 
 	cpu_nr = get_cpu();
 	gc = this_cpu_ptr(mp->m_inodegc);
@@ -2086,6 +2096,8 @@ xfs_inodegc_queue(
 	WRITE_ONCE(gc->items, items + 1);
 	shrinker_hits = READ_ONCE(gc->shrinker_hits);
 
+	spin_unlock(&ip->i_flags_lock);
+
 	/*
 	 * Ensure the list add is always seen by anyone who finds the cpumask
 	 * bit set. This effectively gives the cpumask bit set operation
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 94fa79ae1591..b0943d888f5c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -349,10 +349,13 @@ static inline bool xfs_inode_has_forcealign(struct xfs_inode *ip)
 
 /*
  * If we need to update on-disk metadata before this IRECLAIMABLE inode can be
- * freed, then NEED_INACTIVE will be set.  Once we start the updates, the
- * INACTIVATING bit will be set to keep iget away from this inode.  After the
- * inactivation completes, both flags will be cleared and the inode is a
- * plain old IRECLAIMABLE inode.
+ * freed, then NEED_INACTIVE will be set. If the inode is accessed via iget
+ * whilst NEED_INACTIVE is set, the inode will be reactivated and become a
+ * normal inode again. Once we start the inactivation, the INACTIVATING bit will
+ * be set and the NEED_INACTIVE bit will be cleared. The INACTIVATING bit will
+ * keep iget away from this inode whilst inactivation is in progress.  After the
+ * inactivation completes, INACTIVATING will be cleared and the inode
+ * transitions to a plain old IRECLAIMABLE inode.
  */
 #define XFS_INACTIVATING	(1 << 13)
 
-- 
2.43.0

