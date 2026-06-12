Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F21237CD3A
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 12:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265955; cv=none; b=czHiEJhMe56odhl3jjp4LojCbXI/XGo/g39qrz3860TvAAzmIrIQBg8v9kqGjjNXBSyAj9cc+SMyXPED1hOZlv4RMXhMbi9MVzF9cLEn8bcLRCMCZ6dpM0WSMrVvkd1rl+BBppJa4JZam4LApfJPntaYG/VHTx9/EK2SlLgP8N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265955; c=relaxed/simple;
	bh=nsdGdRnewbkphCvqP+UZ2H9JLYrAPvPh7iBMkhu9FiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sJRjnL4OWhDNGfiZle7AaMcG0z6HwGU6A3CIkODJvExNzkMkgkARutYiwwf3eL97xbxjKv81vmfTsjWsh1lpmW645xWWlyyQudE10wDY9qpw06cy2mpGcBFOT8lXrFF12mFur3vBscf4Ex7ZJiOZi+bFQC0AA0zDoic6vknXc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QYOWVfN9; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYOWVfN9"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c0c2c7e0c5so5703425ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 05:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781265954; x=1781870754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fQOC3hYWZyES9WLzkPg8MyHU7k3IwFGtS7FQklxrDKo=;
        b=QYOWVfN99EoK6wrdmmtNi880fpY9wgDqf4T+3LXVvkrDYIqeP5DTsr2CDDCLrc7IDl
         UZbJkh5MWbPbSt8LAXZBd2z5QJkEkG+j3yOuICEjKr6GGtO+2TuTktvzZVq/Js5FjKdC
         YFKrBgxhM/goz9J/AMEp04Ag6NWtxM4Uzvd13c6PdCeIXNc3awNhWKbAubEPDd/1dG5j
         +kYR4e2dhoEPAE7Q6YJfVFoSzASnJEi4ZSeDpYh6i15DI/OtE5lqxW6D/Cv3zBPZ7cKr
         2kgjUswLpVa6Mf63RU2jJxoIvUn9pXCLV3tbzo+EkHfAJr68mbnJosrYvjNYA21Noq+A
         bWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781265954; x=1781870754;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQOC3hYWZyES9WLzkPg8MyHU7k3IwFGtS7FQklxrDKo=;
        b=d9Zvb2z+xG7apnjuAxXqWNWeEBBBqPyyin7TcGa10sZ0Oc+nrJMiO+etJkMYalIfum
         Mpr0uRlNQWqYl+ZP02PWAf1RUMWpCf4Itpn+YS2Sg67NGJJnVC3McQSR+kyTbUU+ynV5
         gUWohr3FaLqSWDNQ++1JHYC+PDQ7rCMLVgrQWcBBXFMfNxY/7RF6jIkNXaGv/c2Mi3+W
         +V2BOp+Kgi/LGR/gaSmuz+d3FzTOC9V+bm2i6ASIAdF5BaIARNBneaNEf/7jF74kVdr1
         zzPYmWRooet0OT4tHOiKuGRs6DZ5UtHJzbY8xbgTfaUkVYUhEtZucAdw0RVc+69tdVGt
         Z9FQ==
X-Forwarded-Encrypted: i=1; AFNElJ/agdKKFBYzCYJBmVdk9bTGH+NXjLA/nf8ELrhfSSqrgmCG6M1q6T+6J0Gt+NpV1VZQH3GTVpArULA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSmwIdvH2tOVOv979ReO5BNSXJaqnQpHmBRqhSGClPEl/nI22x
	VLFi2K0HMpbQuBjQCwgW2soAXDenR7SuSskD3/WqkqE0h//okL4t3v04hQ+qehQdPJpjIg==
X-Gm-Gg: Acq92OF49QCWNi030booNEFJzaDzDTwECQJHJyREedL/5xC1vZNwHB9mBCGPtOJjiRU
	UXpUXGBR/GWNKfvb03XSoR3uHyRgeql3yEmSeJWtlcEtCWSCaghDCDm4zV9rbdrGI0af/p2St88
	gNCRsioJKhHLzmpufbNL7GIoPVQ1xJ4NqG0GUlDAahUM4Y4fJw4lB38tXMmrlssvMwJ27i5Q3Xj
	wLdD4E3rAzuwxVS6/DxdDX2WkFX6V/JUQHNQuhmyj0EgXOWJvJUgnv8/VkF+ogFpx2c6gbpGrlh
	1GExszEFpkf2sWaSAzNg9SIU/6fYyU/mAx69Lsn+qQTSqxsqHiwQx/0rlM9EoWs4rAi7raUqEAY
	UHh7BIYibiR4qxvQfPv3kvwez/K90RMzS2TMANu247R9Um49KArQ3AnpSJTkPOvj8jIHWQ8L/2m
	IWjHnIijBweNWBznUejyHhcRpf/vJAF/bQczgAONA1MUggrjQstyXwzhC4mU3ygr29mjAr/+Omy
	WrjK6QYJSVrH2FV4JJ/thu7HzZ/pfd9HBbxZdoKYfm5NXGAYcCMgH9O6Yn8/RUe94RwsAo7Jhbd
	fEzHgVjVCuHo2KiW89uRdp+QrQKyxowMc+vQ
X-Received: by 2002:a17:902:e807:b0:2b2:ec46:dfed with SMTP id d9443c01a7336-2c4126540abmr29253775ad.31.1781265953660;
        Fri, 12 Jun 2026 05:05:53 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f1f0f24sm19145025ad.3.2026.06.12.05.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 05:05:53 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v3 2/2] xfs: prevent close() from hanging on frozen filesystems
Date: Fri, 12 Jun 2026 12:05:39 +0000
Message-ID: <20260612120540.2319-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
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
index 9978ac1422fc..1c75f51af4d7 100644
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

