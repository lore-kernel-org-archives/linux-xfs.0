Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00FF20E4
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706748745; cv=none; b=j6ZDCQD6bGK6FVla2hDFk1E0AaxY9JruJuy/tMBjWsNcj2dmbXTOuWxkyzav5+zoAoZ7ttyZDaEbP5Tzx7gecl5mfckdlyu5WOhHXfr2UsROGxc84jocc8ToKz1YZFlbTX7MIivtedPMn8/ifmVszq/E/8PZkXREj5yk81pLh3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706748745; c=relaxed/simple;
	bh=YHrhVtnHgUDECedFFl3FPDgqodwDEXvumw14k492qQU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1VbFfmDeCe5oK3mcm7C7xAwJEVDmT72CL7Yav4JJvomVNkHabLaTjPQhkosA4mE7HhsT8p4kYjvW1r+NZuobWaHi1yGYWXcK0OLQTIqfQTe3dGYvk5Ai4M0rwQrLIQcAX3zAiDj36VErJaZs0nVVgCway8QiAbOmM90kZEhWmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rhxiKR6x; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rhxiKR6x"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6dde65d585bso239245b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 16:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706748743; x=1707353543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8GfLuidVgU3QQjG8OB1BYAY9NjlVsXF0JVas6KZwVV4=;
        b=rhxiKR6xMtsvE26YNSTSw1xF3F+jaHJEAoYYvr3r/0gO0XmSu7u1zOkrfm52hsWg7a
         5bvQ0mFxHlZuiDGE6yquiVA++aP2RZByMjIH99QsP/HOBg0r9J6pIHw44mAR3GnKgFrj
         +ccJ9YAnRyqzCEBE9K55+AkembnWOk+D/Kz3fnyRNsrVVk3EkUXvQLNpiUpnWMNS7hEM
         XPIdrPAmGw0Tdio5RkBNoNWztTr/m7bUxvi0CghbKWulZAehHsFasc/bnFXWiuRdSy3D
         qizsOcp+2UjNyIidDKB6ShY5SlRq3BXp/8xg30LzL/qOn5EUkknqhQYVl+7RwzvwrOE2
         DUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706748743; x=1707353543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GfLuidVgU3QQjG8OB1BYAY9NjlVsXF0JVas6KZwVV4=;
        b=nPxj6qHNYzUMEi8bdFYPlKNPEoRPux/xl0KWcfe45J/cEgpMqEv+zWk5c4LCSJOJCW
         7xtMpCglW/uw5LRHW2UEneaTjeS8C03eNaSsbotQflXDZOWk30jg/pqaA/ZXsC+sHIVZ
         0Jal/6VMaRSnQ96B+ry+BnY/LPjT3/FJjpGl0I57tvUydLBUekKJro8Pr1OffoYbu7Xy
         yTtS+QYSzC5ltbh/bNK2x1TRJqCXHCYm8Qnwbzmz/nsbaprH5Pt+83sYaly0eUPGzRZ4
         SLGDe8JcZjZkwBEC0bvP+iA+rvcuSMPBOIqm4YYuQ/Z3NMNitMYI3wTR68yNH3YfT8b/
         9cHQ==
X-Gm-Message-State: AOJu0Ywus311rS9L5siULXqKf0LfdRNpGBcpHTy2xWMHt1pTIQWItC8g
	k5KPNDlcJKa2MXzBdCAdF5G7bJZ3APaXpfgdXVnzMwiT9J63GcbXdX7Zzmie/+5SVVQbibQtLvE
	N
X-Google-Smtp-Source: AGHT+IHaSfGa271viEAn7pXOByZkJdZ3cg1+4IWYjmb+7h38AQZ4TITaGFHbbmGVSimloNtIWhMSUQ==
X-Received: by 2002:a62:cd4f:0:b0:6de:1d05:580c with SMTP id o76-20020a62cd4f000000b006de1d05580cmr3340994pfg.29.1706748743001;
        Wed, 31 Jan 2024 16:52:23 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id u13-20020a63454d000000b005cd86cd9055sm11170149pgk.1.2024.01.31.16.52.22
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 16:52:22 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rVLJT-000O7f-31
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rVLJT-00000004WR5-1q3h
	for linux-xfs@vger.kernel.org;
	Thu, 01 Feb 2024 11:52:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: allow lazy removal of inodes from the inodegc queues
Date: Thu,  1 Feb 2024 11:30:15 +1100
Message-ID: <20240201005217.1011010-4-david@fromorbit.com>
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
---
 fs/xfs/xfs_icache.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2dd1559aade2..10588f78f679 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1877,15 +1877,23 @@ xfs_inodegc_worker(
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
+		init_llist_node(&ip->i_gclist);
+		if (!(ip->i_flags & XFS_NEED_INACTIVE)) {
+			spin_unlock(&ip->i_flags_lock);
+			continue;
+		}
 		ip->i_flags |= XFS_INACTIVATING;
 		ip->i_flags &= ~XFS_NEED_INACTIVE;
-		init_llist_node(&ip->i_gclist);
 		spin_unlock(&ip->i_flags_lock);
 
 		error = xfs_inodegc_inactivate(ip);
@@ -2153,7 +2161,6 @@ xfs_inode_mark_reclaimable(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			need_inactive;
 
 	XFS_STATS_INC(mp, vn_reclaim);
 
@@ -2162,8 +2169,23 @@ xfs_inode_mark_reclaimable(
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

