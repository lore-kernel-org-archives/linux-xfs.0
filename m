Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7E33C4167
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 03:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781581139; cv=none; b=dCi2AWvSuUoBPomJQha6nAKf07LJxao4uIcbO0bD4I5h5SPlPgNi+x3SyF/X48DsozPXo4O0siEf+EZ/S/CzAGy2lsURbTqQ34basgF1itWETIlmWdnE+8ltcnKtkxGxvpyrzeqKDKMhYZrg0w7J+6QIPOeGAizC49BK2OEGxbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781581139; c=relaxed/simple;
	bh=NRpQ4bcKaxM9rzsLKBPD50pO/rDuLFCdxtCZT+fhA/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHB66B5KISeWUkjch+mCtrxOOvQ+qaHiXf+kFAbCHkXnjNokOHL7yvJdcdTj1RHb4DXLeQ1oMeKL1G+Jj3DF9Zi21crzyBTjhwv0WE63AU/g/hunwjs1lJBoB6Z2LomVl6XtsHCf2v/p5blO6E7XVh4TUyg7uUX6GoIV5IpLSEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q9UMj5/t; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q9UMj5/t"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c8587427468so1639498a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 20:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781581137; x=1782185937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pii4XoTYSZsJsKO3DszZ6XB2u4tCiGbMIZlm+pRMrL4=;
        b=Q9UMj5/tdKsFAU8Yy2SGrGTPWjmJ9KX+3h4GL+joH+irLnRXUdqnYMfKB1Kn0zNE/I
         H0ViaeU6kyspDEV7abcAU21U+r38frEz3zV7kJ6F2KXlMS0CVr8xigVXfzUp+e9ETcrZ
         II2WXfGPEBsH+ffkUzJo3JgDq2MjbZUEi0cW1zXgHrqUibsstOj9iIk6fIEDp7hJTCZT
         tB63ugee9G+hR/djkat7/U5rpUxjfgmXIO1q4c6IcvsaXafdB1oXudgDVdGklBznPH58
         uCInx7V1IpFUZXzyxFNgfQcr3aCdJbSfsc3yj4JoTuUYbuDwI0kqoWQrY+b1cyU/e/tI
         k4oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781581137; x=1782185937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pii4XoTYSZsJsKO3DszZ6XB2u4tCiGbMIZlm+pRMrL4=;
        b=s+jl+zhHbQetsF8o79M+/DRQylRTs0drEBCB2/0j8KPMGDUCnvze057Pi3qj/YK16V
         xcibQJYJgUQ3X+VXPAz2F4cGOeHfjyFOfcMR8tbtOuJOk1GJJksEIdtaf+J1bcqw6d8n
         nO7NfgakUNX1aMSbazTENhCPMtWtj8UQPfYlpMk3M8lYKGIj3qZ6Ic260tcRHSoi+kXg
         2sqdBOQS1rHdsUUkY5OBdLBIDw11NSKuLj2NoYH2RhCIefmOXGSbNz7sFJcynJCa/7v4
         Jj/1qn6pCZL6CN50K83flJaNT6CuX40RZ+LuQFuraVdVTqbnGbiyftf1QZ4CF4/xOQR5
         fnhA==
X-Gm-Message-State: AOJu0YwrHVsjnhZezA7mEwejFcSc5i4FAwXNvoSPorcEVlcBjNdQ/XAZ
	h+NKi3tx6jie7wAhAwC0tws/hduccNaKD6U8ugY0VeHP7RhPdQZ/O7Sr
X-Gm-Gg: Acq92OEGeY8A+rNq2YooAo3g6V2RI/Xu7BIajms3NWXVluvMeTVaJysTPoXgIvFU1KV
	FhlsiHanEBQZ5nPuH6NKbAK6kbuMClhZWOzm3k1H/TyeZhE+z2WULKjmhjIyY6t4FmpZ3IhE7XU
	4nXRi0sfX8c1P9+nTZld0AKGPGcYidCOwJy12zouz3Vz3AGV3d1Bf5nUyuMDVs8oaVPUILWRkw9
	ONn2HU8ydpUJR4u5hDAhFRmeXzGIhPt/dZ/sVI6T81ngMo4bViEj4EAHwdHEAGxna0xy+H7YHPm
	F5GpuXq4y1z2Owo7aVrUq0CA0qbDo41cGXdIjxXcasATarouvMeM25js8LhIgZBoB/66iGIED2i
	rDlT2vbsHvpph61nJ52iupU3DjeDF0rMAp5QYuDIuHobj0KFYSM+iD3Z4sBiFssgsgTeW1lR4O5
	OxZGm0ovdbEeyM6MpUsjJopsSCLhY9HGvDylV0m4hyZx0uHkXbEsHJ+KHinaVLuF/j/+Jgnjugv
	8wRP04FVq69foaAFee0UOXRW9dIs9A86D6yGrqo6g4kd+BHjFbzwXk0XRD/glXETLvKaLByBqvZ
	x+/CrNSLopFXBkp/QIdWtrcbw5q+/inhMXFO
X-Received: by 2002:a05:6a21:4e01:b0:3b7:99af:2d26 with SMTP id adf61e73a8af0-3b7e49dd31amr2050894637.15.1781581137488;
        Mon, 15 Jun 2026 20:38:57 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (229.231.21.34.bc.googleusercontent.com. [34.21.231.229])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c866325d156sm10304173a12.13.2026.06.15.20.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 20:38:57 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v4 2/2] xfs: prevent close() from hanging on frozen filesystems
Date: Tue, 16 Jun 2026 03:38:20 +0000
Message-ID: <20260616033821.2238-3-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616033821.2238-1-aditya.ansh182@gmail.com>
References: <20260616033821.2238-1-aditya.ansh182@gmail.com>
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

Also, rename the flags parameter in xfs_free_eofblocks() to trans_flags as
suggested to make its usage stand out, and update existing callers to
pass 0 to preserve standard blocking paths.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205833
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1474726
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/xfs/xfs_bmap_util.c | 9 +++++----
 fs/xfs/xfs_bmap_util.h | 2 +-
 fs/xfs/xfs_file.c      | 8 +++++---
 fs/xfs/xfs_icache.c    | 2 +-
 fs/xfs/xfs_inode.c     | 2 +-
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0ab00615f1ad..faf0630717dc 100644
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
@@ -604,9 +605,9 @@ xfs_free_eofblocks(
 		return 0;
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, trans_flags, &tp);
 	if (error) {
-		ASSERT(xfs_is_shutdown(mp));
+		ASSERT(error == -EAGAIN || xfs_is_shutdown(mp));
 		return error;
 	}
 
@@ -928,7 +929,7 @@ xfs_prepare_shift(
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

