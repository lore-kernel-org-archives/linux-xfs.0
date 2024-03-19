Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98DC2F2C
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710807437; cv=none; b=fJZRUJ6hnXriVnkJmt8fqCbj3I4yIefNzzxAhLp3T01tkJMN3lLVzv1SWGPe+oW1nRxqfNuhOFDJNVySA/rlHDYouo01aMB0EdUkDEDNA500pPCN+nznH5kG5I0wGc99u1yuIFLaE9CA0kAM2x41uOnttC7u/dYdc2i5wym+NSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710807437; c=relaxed/simple;
	bh=lxuYIAuL1kM9hp2A0Y+zXc4bmexOZVuPGoTV6tYyaL0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=App5+1JLt+x4OvoYrQctpHeRPNoucrPB8KoixbY7pZuCRdfR9el3p3GekNpOai2w1DomI+df5Gil6reiJiqknwEvpWLQYablfHKYE/syWmVlHw/5Y7bOP3lTYS5HclSC82c6NKSQybbztKtP1t30aFg++yNtHt7MuG8fxe1idBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=De4pTrCT; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="De4pTrCT"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5a0932aa9ecso1913903eaf.3
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710807433; x=1711412233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DpRkxRNrSAm/FKzDVegPZPmXRFDr56kqZzAnl/Q5SLs=;
        b=De4pTrCTOZMGajY4Jg4sQeXiLrvSiOJIpIj1cwoYJ68KhGmwc0IkABjVh2Nd0tyrDe
         Mabsr4ulEm/S/k6+dn7gQJ0OI6a1BFb5fWj2CZMP1TgrFqxqgyC7JlqtriwGGL+lqzqE
         KVijVmqM2ozz4s2gCtLK/pZJEVGafkfA4HSlEmYs2DAKVLq3c1PjBTGAH1KfufLZfSsN
         Ky+wNz0wMssGNuAt63mikyi/a4EcEPaRFGKzQTMZUUjUWSz/V2EJ9X5YjTXZ7n1AFCRE
         ZytqUDla9qkAN4673H2yoASFTJXk+AwVIZnz0Ap4u0H+9CIM5XCP5ivnz8QsKDbvePTP
         5QMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710807433; x=1711412233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DpRkxRNrSAm/FKzDVegPZPmXRFDr56kqZzAnl/Q5SLs=;
        b=RNQJ7Fg1RZm0WbZGPMTO7Po3L/TW7RIAnO9p/vXJ6V9R+d7i76zLQfjuyOnHB9Js+1
         5YXev0mjlaGm2txP/Q5PNnWYYcuJLZft4Rli/UDmm0V8tWFEQdfdjMaCHkcscRStE3pm
         OWvoJ+SlD+0S2CN71bFL+GMzZh72VJx3kEpNHz/lQyXnV/C23srF/1/ZXq886TQUzNr3
         cEW3g4B8lfKaVqyjHc5Vjd07WkZPMq8LleXn4Ns03+pjujFDJPmxGN/kCyu51DkGBCyh
         NsYD0g75xF7t3P284dme71uTmQoEJjoVBnQqbEaK/jpqyprtYO2OEGKSB4/q+CU7cj2L
         lX5w==
X-Gm-Message-State: AOJu0YzLsxVqHqWPgOPhvav/+YEE0Hr+C0HEdYq0URBQh6f9oyO1zgoS
	Equ8Vm+KUAj/aeSC1hbhyhg+xGC37bSwJdnQBe/KpZYdVfUTxVGWvPmR31G2ioFUI7k2i+f1kY+
	1
X-Google-Smtp-Source: AGHT+IHOP4a3BifE6dr1TwkUOGQ2KhjQxlzP8TPA/X9gY+shKv47GYtyi2f4zCoufvC3PHUWQ2qF8Q==
X-Received: by 2002:a05:6870:2046:b0:21e:7156:a69f with SMTP id l6-20020a056870204600b0021e7156a69fmr14900371oad.42.1710807432665;
        Mon, 18 Mar 2024 17:17:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id a26-20020a62e21a000000b006e6ae26625asm8443304pfi.68.2024.03.18.17.17.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 17:17:11 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmNAD-003pkt-34
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmNAD-0000000EONZ-1njG
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:17:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from xfs_iget
Date: Tue, 19 Mar 2024 11:16:00 +1100
Message-ID: <20240319001707.3430251-5-david@fromorbit.com>
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
 fs/xfs/xfs_icache.c | 110 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 87 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7359753b892b..56de3e843df2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -63,6 +63,8 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
 					 XFS_ICWALK_FLAG_RECLAIM_SICK | \
 					 XFS_ICWALK_FLAG_UNION)
 
+static void xfs_inodegc_queue(struct xfs_inode *ip);
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -325,6 +327,7 @@ xfs_reinit_inode(
 	return error;
 }
 
+
 /*
  * Carefully nudge an inode whose VFS state has been torn down back into a
  * usable state.  Drops the i_flags_lock and the rcu read lock.
@@ -388,7 +391,82 @@ xfs_iget_recycle(
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
+	 * If the inode has been unlinked, then the lookup must not find it
+	 * until inactivation has actually freed the inode.
+	 */
+	if (VFS_I(ip)->i_nlink == 0) {
+		spin_unlock(&ip->i_flags_lock);
+		rcu_read_unlock();
+		return -ENOENT;
+	}
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
+		trace_xfs_iget_recycle_fail(ip);
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
 
@@ -526,15 +604,6 @@ xfs_iget_cache_hit(
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
-
 	/*
 	 * Check the inode free state is valid. This also detects lookup
 	 * racing with unlinks.
@@ -545,11 +614,18 @@ xfs_iget_cache_hit(
 
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
@@ -578,23 +654,11 @@ xfs_iget_cache_hit(
 
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

