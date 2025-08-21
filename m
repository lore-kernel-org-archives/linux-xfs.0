Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FE838C619
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807644; cv=none; b=uoZi4u93cfeWzTpSgVD2V6CCKKDdiBM2FKrLFDihP96UcwN3oGtIo2wfv4/oXC5O5u9InMPve3HiJHseveGM20b36sETG6Bk7sgcDU//NdF7CQ0n2HVBx5yytMrrnVhv1Yh+eoQHOdVNb7uKRWnOf0LzB73DDTQgCFrlt8niUBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807644; c=relaxed/simple;
	bh=Kg4HyI9QpVcllETBw5mmbw49cjWo/i+7w3jN/b+fpXI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u35fcgkKe9Ppw3AGzPYq/ynBESKOdzYrul97/R68+2gJTbNEdf69RZBrU1imk9q7AcQZi6cWw+ZwrO9UzLSRj+f6yXxmPoJUxY230AyN54jPCC9gEt6YPtmsxKPhLCggBR76vBiwQ5Gq9Jwe6Ary8r5Wt8JFGVtZLnxoHOxCXs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=fLhSWod+; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="fLhSWod+"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-71d603cebd9so15886227b3.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807642; x=1756412442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m6vlOFADLX5mw52k/m7fuDkR4/0v4QldE+cL7IA9Qp0=;
        b=fLhSWod+pQMoyGzM3hk9LBm4L4ngCrAN9KmjeLb00BIqvIqbedRyP1Nt2qCIbl3RzQ
         DJd2/8Ij92Ppe46a6hMYU8d2OLkRRVDfN5Y0rsNfadrltY1MPVP/ruxdohH5IqjKDndA
         +eg2lx1VJK/LEToVAFUMEe/0p1WqUb1Z54TaNJkarRNcvE3bGPuQRaV12wI6rlecTBMh
         TEzBaqiQJBFxR7q2BCj41/uDz2z02RkS2V2zRAESnnnoUSO6gv4SAOrkvLt5r7R4qJQl
         bGDGhQhNJgLtYiNrsxgR4/k94JMZo+hGzQjRt+Dy20p0WSZocjHOq+B8DUjKSSEUblhn
         Mi1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807642; x=1756412442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m6vlOFADLX5mw52k/m7fuDkR4/0v4QldE+cL7IA9Qp0=;
        b=PXLY12J20VnrGtFE6c/5D9+9Vvgjknjira+YNczeVgWMTHuwK1NJeTydf/MkisH3pw
         aroSbKoY7C3ODVrOUfq2Gxev0FmJtT2k5sYbT1EeMCE8vwcQCteSBFXxquwOJqo0FQrN
         VZI6mD47AFsem/pVpqBxS5iCPFcn7v1mqqccmRNKMiraBgGzBn2b0OACaL6dzffTJ5bt
         YOK2YwKF3G9bosKCKZi8OM766UsF7wM9SlsatHF+qDvILa45LrTBEBXZJgzkn+Rft61i
         F0FxnZMER068WVdtkjNLFEvHAx350jHAcf+HwYcJ3FO/YAA55o0Yw/CJrNuMq11IMul7
         ejSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDsKpfpwW2tRkAzaOQgE0MvC5ftZXsETZg6LW/jcGfBNSR3khYReU78jyUZmBSv15OOZYibjVJMxE=@vger.kernel.org
X-Gm-Message-State: AOJu0YznmlQArZGB1InOg0Kop7wgodX5a+lsn+XPGS87t9/ztjfnOnLd
	NJMZFhv50i+dzVZid4FHm8meXQwoGwgpKad6EM5put8AirmJitOSnmynxRl/EqhX+RprL02qsZa
	sfFKTJPO4sw==
X-Gm-Gg: ASbGncty4d3URUEue5l3mSNXDiGnxzAdXWGJgD2KUHYMy8D7J5pnUdTZIV0RCUKafPb
	YBMrN3AVpRKBbgv5WGPG6qT3zZkkxBARdXik/LzxMS+Zn95HQDd1mZ6GWarYNQKC8A5x1wZRoIs
	cfYKTel7/3i8qErTaQuv0dflWdlVB850erSZEZt2Bg4z7Ci8bS59kNq++3VjepcsNe2dU6SD14h
	JqrRf8705jokl19SZkf2+o7PKV0kUNPF0JW0EQmM2GLDAXReybqtoIfJm+M1jC3SKoBqY9Kaa8m
	fJmnchDu5jZ4VfsY9vI49dAxgSQIqZEdJ60KTI95Rzq1hF2P4AJ5jCB6ZzoV+MBDj1zlWSwCGgt
	1MJjHjS4r17P3D3H/7XRsYYSwWJv/7ba1EFit4KHLnPbsCrwRv+JCsir2RiQ=
X-Google-Smtp-Source: AGHT+IEaCpm4qmdeQmTjz+kVkgMRNomqyiidl3fTCdzZLNucs5oGAQlKaflKfo8a3BN1zA6M3Ppw9A==
X-Received: by 2002:a05:690c:688c:b0:71a:323a:b297 with SMTP id 00721157ae682-71fdc2f10e1mr5550167b3.7.1755807642271;
        Thu, 21 Aug 2025 13:20:42 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5f52b9fdedbsm53508d50.5.2025.08.21.13.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:41 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 18/50] fs: disallow 0 reference count inodes
Date: Thu, 21 Aug 2025 16:18:29 -0400
Message-ID: <6f4fb1baddecbdab4231c6094bbb05a98bbb7365.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we take a full reference for inodes on the LRU, move the logic
to add the inode to the LRU to before we drop our last reference. This
allows us to ensure that if the inode has a reference count it can be
used, and we no longer hold onto inodes that have a 0 reference count.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 53 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index de0ec791f9a3..b4145ddbaf8e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -614,7 +614,7 @@ static void __inode_add_lru(struct inode *inode, bool rotate)
 
 	if (inode->i_state & (I_FREEING | I_WILL_FREE))
 		return;
-	if (atomic_read(&inode->i_count))
+	if (atomic_read(&inode->i_count) != 1)
 		return;
 	if (inode->__i_nlink == 0)
 		return;
@@ -1966,28 +1966,11 @@ EXPORT_SYMBOL(generic_delete_inode);
  * in cache if fs is alive, sync and evict if fs is
  * shutting down.
  */
-static void iput_final(struct inode *inode, bool skip_lru)
+static void iput_final(struct inode *inode, bool drop)
 {
-	struct super_block *sb = inode->i_sb;
-	const struct super_operations *op = inode->i_sb->s_op;
 	unsigned long state;
-	int drop;
 
 	WARN_ON(inode->i_state & I_NEW);
-
-	if (op->drop_inode)
-		drop = op->drop_inode(inode);
-	else
-		drop = generic_drop_inode(inode);
-
-	if (!drop && !skip_lru &&
-	    !(inode->i_state & I_DONTCACHE) &&
-	    (sb->s_flags & SB_ACTIVE)) {
-		__inode_add_lru(inode, true);
-		spin_unlock(&inode->i_lock);
-		return;
-	}
-
 	WARN_ON(!list_empty(&inode->i_lru));
 
 	state = inode->i_state;
@@ -2009,8 +1992,29 @@ static void iput_final(struct inode *inode, bool skip_lru)
 	evict(inode);
 }
 
+static bool maybe_add_lru(struct inode *inode, bool skip_lru)
+{
+	const struct super_operations *op = inode->i_sb->s_op;
+	struct super_block *sb = inode->i_sb;
+	bool drop = false;
+
+	if (op->drop_inode)
+		drop = op->drop_inode(inode);
+	else
+		drop = generic_drop_inode(inode);
+
+	if (!drop && !skip_lru &&
+	    !(inode->i_state & I_DONTCACHE) &&
+	    (sb->s_flags & SB_ACTIVE))
+		__inode_add_lru(inode, true);
+
+	return drop;
+}
+
 static void __iput(struct inode *inode, bool skip_lru)
 {
+	bool drop;
+
 	if (!inode)
 		return;
 	BUG_ON(inode->i_state & I_CLEAR);
@@ -2026,8 +2030,17 @@ static void __iput(struct inode *inode, bool skip_lru)
 	}
 
 	spin_lock(&inode->i_lock);
+
+	/*
+	 * If we want to keep the inode around on an LRU we will grab a ref to
+	 * the inode when we add it to the LRU list, so we can safely drop the
+	 * callers reference after this. If we didn't add the inode to the LRU
+	 * then the refcount will still be 1 and we can do the final iput.
+	 */
+	drop = maybe_add_lru(inode, skip_lru);
+
 	if (atomic_dec_and_test(&inode->i_count))
-		iput_final(inode, skip_lru);
+		iput_final(inode, drop);
 	else
 		spin_unlock(&inode->i_lock);
 
-- 
2.49.0

