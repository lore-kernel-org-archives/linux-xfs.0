Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4EF3C81AD
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 11:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263418; cv=none; b=Lu7Dg5QXeRGmxY2wlJc2JQ/sMWKtGYM2xp09X/S5DY1zCQtPP2eZiRQFZ+U8irp1hhV5MgrT/ByYiQ6rajeqPopvqsv2FZBrN50A7A3GOQrJuj2JnWQ0CL6cezeXqJj0cl7AbfV+uVKfAWfnVyg3x1nE0DEi9qmgg1W7uWXqIMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263418; c=relaxed/simple;
	bh=nsdGdRnewbkphCvqP+UZ2H9JLYrAPvPh7iBMkhu9FiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEq/3QqoE+0en6+76GlC23kD3MStP7hdr+MOH60BSZumH0fmxd267lexV/1F/YsLFQ0UyugppPObGGxxKwEHPU3lBrA3ojEri3qH2mzxKoORG1Z5ZQ91M9OWHhYmVdKlK9RfPvrsCHMftM+zmlRFU7Pj6qsYCHRMJp9P7ACiABk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OnnMsP3x; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnnMsP3x"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c85a2ca7bf7so349853a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 04:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781263413; x=1781868213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQOC3hYWZyES9WLzkPg8MyHU7k3IwFGtS7FQklxrDKo=;
        b=OnnMsP3xQ3rGMyqfx1dDlT/9hYQEG8OV4gVMDQupx5dlxqwvDap1YmXmihp1IvgEQB
         oPsAw7nFCgsliTJYN18siaqKWzJwvgYkZ2m9HV1TKOl9D+LNTWAWOksogjehYVv2UwpU
         Iu4+MzFyAO+UrRHShGgs9NQaUDuQurSM7ktvOjf5gHIo4u5ZY+AcheKReYNbok7y7aN+
         +fzvKi9kAb1WbIpVVN8PNc3zlgheon5nSaPxpQIrNazNBl1tSuk+hTqAdMQouYlZJlPv
         ZBGOPP0XFSneLF/95l7loqM1dvBjlW1UwYlozUu5DHcY0T4KvvL7m6XzU5Dl1ML5bVqI
         1Hdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263413; x=1781868213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fQOC3hYWZyES9WLzkPg8MyHU7k3IwFGtS7FQklxrDKo=;
        b=HaQDMZKYwN9zj+bG0d2VzW8oJAMhu19nxHpbe12PlaFWgd080pv1w94jl4MCzGvUZz
         SiatwsIPNpLZOMRgz7A/p/wOH84vNFoNtJ5zXkFyBoFYgfw8R0dsU0P4Vz5Vh5896W/a
         eQViVBeDOv1FQOoLm4ejCb4fjF53/Uo7Z3go1mHzz/xUckNJWtGOMaXXVGEbmcRaB98T
         Yr92F0vDE7xEpEhWfPFQcEKkwLRnTeL2p9K1O31km3gbmCfgFkzd2bISoJiYPpWOF4Vy
         aBCQLW+oCIidfbM1a7lWFxBnGceth/Q2jpg5HN8vgorqftE4KU4Img+Fa6zQaSwatxC8
         iDbg==
X-Forwarded-Encrypted: i=1; AFNElJ9nU/cI05u5HnEz1SqC4f3HXTwjWgDAKwVTopXOxfRemCA1sgyZlgaUS7M/qQf7qThi51P8TEVCtcY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgaHhnm33dGAlP1dZNZGHDIFj8kpThBVok5zoKaZR4jgATYaXt
	xdK+x6Z9Bqe3nDRM/dSauo2QX4lqURxWT8tnW8vOVIUMuOTHWcAp9wxf
X-Gm-Gg: Acq92OGBJ7lbPemyfesTwHFZ8WAUn8x/IMXP3rNyHX2hr7Uiwq0sfLt/+qjTZRMIPai
	zHdEx8A6kWooXfWcrQynySfLYDmM2iHPly/rrVMk1yWho3WG0C1QXkGucChn8tMvJnRq7Ye2tt7
	gBQN63i/3epmobec1MgQCHgx6Rf367z4MzKdw5KIW/lYlUFCTcjzzVYkm2uTK6pogRvbrBu+CWO
	LMWivrVCTlirc+n+Pe3//lLBZHR9Px7m4pwUEkfTL3Em7Z896SmcXqojVx32VnbsyKskXCivzuz
	8ws89czIGHxRD0Q5Z+yKq7rGUsWb9ekg8pyW/6rRo/gTucD7C7h/UhiRvQgyuxNZT1gEge7tq/k
	XQdJbSDxWB+F1FxvI9xsyWAj/qVJPMRPu8aPWTsyJFUfopqdT8nC0UoJy7gMzwoV5Cu7kkvT/h/
	VzoIUCoEaHIj0KyXVyUDeN2sRRsOh9p6hXmOYEy+o29fk+36RzibpgvxprvRTIXLy4FWD2pUPFl
	wO45bXIIU/VS+K42d2RXAEa0WHiQ742YE66i1f3+nDz3BtIaBnuiKHwSOkoZFSAU/W4cRw2l6qL
	y9klekhODYcphxW04IEOeCojKqvvonlvVnMyuRoDXSZGLUo=
X-Received: by 2002:a05:6a20:939a:b0:3a2:d68d:9e78 with SMTP id adf61e73a8af0-3b783b30f96mr3075079637.4.1781263413266;
        Fri, 12 Jun 2026 04:23:33 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c866519ef8dsm1808822a12.25.2026.06.12.04.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 04:23:32 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH 2/2] xfs: prevent close() from hanging on frozen filesystems
Date: Fri, 12 Jun 2026 11:22:52 +0000
Message-ID: <20260612112252.1697-3-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260612112252.1697-1-aditya.ansh182@gmail.com>
References: <20260612112252.1697-1-aditya.ansh182@gmail.com>
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

