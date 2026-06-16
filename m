Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053B13D4103
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 05:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781588364; cv=none; b=m7yMAztiF+A85+64jPOoFsPGUZ6A/Xr2ploHy8Kw8mPrqINE9bzZc3YoTZGJrzbZeDzjvLotPlZjtLS8UoGKPAEr0JlsZLAat7MvhfAF4POiWG4q4yODBnkak55gNpocr/VQVfR1Km+R/LblvXJN8HBx201dHMLkMKPKPH2KvdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781588364; c=relaxed/simple;
	bh=Alq/LRIA2V0vvxuYB0suRH6nNWfSBOUVt0FfRx+jbb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PF02YAVh7I0I8QB+gVQSwcv14p1pZpLEk7TZedqm2Z4NrSRR6PDd/pBIkHv/RiknyD/BYs8g1Hoj8xWtW/6TaXqfLnZ1JG3xgoFZb/NdTh5tJ2tEjHVgAw2Gbyq9gZNzotPmZeup8C7U7AGCM/zxcB5bsWpmiALk9F5kOTraWtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7K0zhLb; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7K0zhLb"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36d98b68d68so2746899a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 22:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781588360; x=1782193160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWhmAHAEZoGqgosBK8sQXv9J28IjF7TWzqkC6E9HiXc=;
        b=d7K0zhLbVZ4ul8tCgV/d9xjoL8yvlbxihMfQa/k0WZcF9L0HDvvGf4xsRoFWrEA57J
         mImlQFVRgStS+hMdV7ZT4fngVmuGU1XMxoaI3PQQjYwti4SHGYUrhIZY92zEDasvR9oS
         /N+6cNRJ3RoX7mEuhB/6l8dQYgayW4nbMAJpf15yrdFrsWO8clFNKc7FHf/pIxSdCvZG
         ZSQGdn1i7UL2hO5D57egykDRXMCpBckgL5NDqHS8alfGOLX8YS3BP+EI2ZUfpxZpmH1v
         16H0J+TSReiFpLBB09QLku7R0Wi/0ztgE002Aq3ikIiWTQK3SKa6YhPZoD4xCwROQWkQ
         xdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781588360; x=1782193160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nWhmAHAEZoGqgosBK8sQXv9J28IjF7TWzqkC6E9HiXc=;
        b=XnF2WxScXL5NHMrn89b3dxbUsUGF9e/IGj8VWHkKb3Yn7Mlfb4TBrE8bXmW3iLb++A
         8mVjihuu65Bye7nzn+nJqtqm40w8BZEieGsKXwvLuaz5R9WuEcbXZI34Lq5yFpYfahPA
         9yFT+z6cW55wafD6NoMZjbAf/HLTwwvKb8Pc5yMPjvlttFtw/SnbpSyXCKL6qNljv9A+
         tb4BrYgSRAtvrUP4EjR0mANIqLIFPGKUldcNvasINcymqucto7YalmK2K0KoinhoYXbw
         4OPBF1cON2RN54fR6oGWkxdcKF0iVezDJMZT/hT3uQ+8/GJGNyOTBPGjwGHxeMxEbAsu
         Md0w==
X-Gm-Message-State: AOJu0YwxASCO1IDfhIKq1un0OyCuZ6K3OIm8ANFr2e4+NFR9vksMiKLi
	gLdX8MoAfkm0VPMF2exEVLsYET5zJ0+hyVidCIB6m88yv8emd2H+S319i/6nSRV7ft4=
X-Gm-Gg: Acq92OHBWsbcFJetTiuw9bomSXptqKae6cstagZOgrZTy9lmL8lfrPcVlNVt/2Juy4v
	MMHPa5n9VEDs4bnNoLt679kg1kCmV6mRZoGGFoeM6PFcnWZeC2YQ1cOW76QibD8nrYKI1vQleWk
	37wyaGuoG8t6FQ59r4uiFb6B/iMq4IMn7Hm6b3nmEqCoHZGcjXP1M6ezgUczRUToaDPfPjieHZH
	+Rf6vWsgozz4RE/NDtrBu6HsrJsAd1H+rPvKSb0XeN2YOnSr6bHwTQ6yPDrA5/DNMcAjN1X5TK6
	jhLF4q+eOLIN7nMuLROaq0jTQDMZGsllt7VZeVIC7O2FJLU1MfEtb5DH5QNR1xxlp1DrquJhX09
	fYQSPIQr/NeqElPc/jaaHhjijuhLC6IvTEfS0sHR+MEWDMdRvYC13crP2RpzQnjap/pqmqj2f6m
	DxoLnfKegVxBrcF7WCqOfDhvpo1dmMHmIADapQm0MHE0ChWVZRvS+Yhhs7ts7gsPEz1iEFUas8+
	YDR0k5JQpRC8R8jEmL0qF33XbbEuPJMbITvB62oLGetGHIJpLjVnRTITyPGZ8J3iW24lMdAVuH1
	mMvgldssmdvz+dK0DpH+QJtUc1efrDhRYOOhZPJEJCVs9Ef15A==
X-Received: by 2002:a17:90b:1cc5:b0:36b:8baa:a683 with SMTP id 98e67ed59e1d1-37c2bd08184mr14639363a91.19.1781588360228;
        Mon, 15 Jun 2026 22:39:20 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (107.43.110.136.bc.googleusercontent.com. [136.110.43.107])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c5220edd1sm1386518a91.12.2026.06.15.22.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:39:19 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen filesystems
Date: Tue, 16 Jun 2026 05:38:50 +0000
Message-ID: <20260616053850.2188-3-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616053850.2188-1-aditya.ansh182@gmail.com>
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

When a file with active speculative post-EOF preallocations is closed,
xfs_file_release() synchronously triggers xfs_free_eofblocks() to clean
them up. This requires allocating a write transaction (xfs_trans_alloc),
which blocks indefinitely if the filesystem is currently frozen or in the
process of freezing, as it waits to acquire the superblock's write lock.

As a result, a close() system call on a read-write file descriptor can
hang indefinitely in percpu_rwsem_wait() until the filesystem is thawed,
even if the file is closed by a non-writer process or after all writing
activity has already ceased.

To fix this properly and avoid any potential race conditions where a freeze
might come in immediately after a writable check, pass the new
XFS_TRANS_WRITECOUNT_TRYLOCK flag to xfs_trans_alloc() when freeing
speculative preallocations in xfs_file_release().

If xfs_free_eofblocks() returns -EAGAIN on a trylock failure, we cleanly
bypass setting XFS_EOFBLOCKS_RELEASED on the inode, ensuring subsequent
releases or the background blockgc garbage collector can successfully retry
the cleanup once the filesystem thaws.

Also, add the new trans_flags parameter to xfs_free_eofblocks() to make
its usage stand out, and update existing callers to pass 0 to preserve
standard blocking paths.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205833
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1474726
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_file.c      |  8 +++++---
 fs/xfs/xfs_icache.c    |  2 +-
 fs/xfs/xfs_inode.c     |  2 +-
 5 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0ab00615f1ad..a99aae4a1631 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -574,7 +574,8 @@ xfs_can_free_eofblocks(
  */
 int
 xfs_free_eofblocks(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	uint			trans_flags)
 {
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -604,9 +605,10 @@ xfs_free_eofblocks(
 		return 0;
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0,
+				trans_flags, &tp);
 	if (error) {
-		ASSERT(xfs_is_shutdown(mp));
+		ASSERT(error == -EAGAIN || xfs_is_shutdown(mp));
 		return error;
 	}
 
@@ -928,7 +930,7 @@ xfs_prepare_shift(
 	 * into the accessible region of the file.
 	 */
 	if (xfs_can_free_eofblocks(ip)) {
-		error = xfs_free_eofblocks(ip);
+		error = xfs_free_eofblocks(ip, 0);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b3361630..c13774aa0892 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -66,7 +66,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
-int	xfs_free_eofblocks(struct xfs_inode *ip);
+int	xfs_free_eofblocks(struct xfs_inode *ip, uint trans_flags);
 
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 			 struct xfs_swapext *sx);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..76c9b2fe7c51 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1806,9 +1806,11 @@ xfs_file_release(
 	 */
 	if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-		if (xfs_can_free_eofblocks(ip) &&
-		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
-			xfs_free_eofblocks(ip);
+		if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
+		    xfs_can_free_eofblocks(ip) &&
+		    !xfs_free_eofblocks(ip, XFS_TRANS_WRITECOUNT_TRYLOCK))
+			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
+
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2040a9292ee6..c575b4acb24c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1259,7 +1259,7 @@ xfs_inode_free_eofblocks(
 	*lockflags |= XFS_IOLOCK_EXCL;
 
 	if (xfs_can_free_eofblocks(ip))
-		return xfs_free_eofblocks(ip);
+		return xfs_free_eofblocks(ip, 0);
 
 	/* inode could be preallocated */
 	trace_xfs_inode_free_eofblocks_invalid(ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ddf2707c8894..14d3cd04a79f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1423,7 +1423,7 @@ xfs_inactive(
 		 * reference to the inode at this point anyways.
 		 */
 		if (xfs_can_free_eofblocks(ip))
-			error = xfs_free_eofblocks(ip);
+			error = xfs_free_eofblocks(ip, 0);
 
 		goto out;
 	}
-- 
2.47.3

