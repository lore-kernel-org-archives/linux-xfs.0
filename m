Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449663B1002
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 11:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265023; cv=none; b=mEMWMrKBKutGtlzVYbvFmmW1V/DHu7ozbtbRtORU5d3sOXJM5C/R7zKki/ojhZ/haIToakKfRkgbjUazg443InHb5enBt+fg/6CB/vqKtBmCrSVWVrX2jKNAqe8kGzapcuzLfLFfp53xeNEE7wYCAu0m8lbajTFyva+MutKdArg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265023; c=relaxed/simple;
	bh=nsdGdRnewbkphCvqP+UZ2H9JLYrAPvPh7iBMkhu9FiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFA2Z4tMdonXQGVCNA2Jn+cbWOecxLTZUWvDueEdOFff01EwGbeJhxHezFpVfaVKnCJYS9kKDjjdUoiUVBXsIe76lZd80hDAyRezFGTIjQYM2IQbKT0ITcr31R9vNe0S6ZsiKaHe2/fs6OF5UMK0ZPh95irgjHgYEFG3/BjVyDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jL7oTEH0; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jL7oTEH0"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bf77d4a4e2so10646955ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 04:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781265022; x=1781869822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQOC3hYWZyES9WLzkPg8MyHU7k3IwFGtS7FQklxrDKo=;
        b=jL7oTEH0tAM+7GR/fnBFAAaMhXxpOQSihQH306qeG8rsr1DvPY4w73WN/fe8E929Qn
         VrfGXnkYBgKMGx3KzuATpBj3qw0kH6WiOdfGPlYrMdifccKDK3R0DBJ9jBXonqANf7kT
         3BE3WOZndDYwTOjjjzmTyhwsTTOpM60NRGT/Y0b6ByXQFO58yBTydkKL4w6pnopvev4r
         sN5eWAEIr2oVTFuD1b1eNSwGs6ZcImcldVZJj3gUCElDJdScRSfI+A64jEgs9O8NduGc
         VOhZ+O/r5cX1A/Hl+98QMHszQzFf4cPw6nKBRk0vmtH1cKL9sTe3+58Od9l2JVmL/AvF
         N7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781265022; x=1781869822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fQOC3hYWZyES9WLzkPg8MyHU7k3IwFGtS7FQklxrDKo=;
        b=i8AXs5kYNu0BtQL+3tXiFPL8DOcPAjjaOuJH3ptYGkp4PrOj7gcV/c+tAlkh21SOpT
         GzchM5IuNP4pXxZxQewtdcayi7fwGmjKQPZp9EdcPQLrjcUg5fxFvpLwj41c4n0bCYSC
         DWYL08D/9VKlVGCxz+I7NYsiEOu9d88llxUkftDUFdey9VBLhwClyuRSUZRLzWkKKRqT
         WgLV6fWTyJ21BPwcpl4/xidsLnCC8bAaNw5vZSxmAk4EYruakQE5jGUs5PpAmvT9T6aV
         +J9+JBRRWFBl7+1537IsE3671hdDARrkNX3IMnBgPtAvgyIKpgE+qxwSLm8Wa98noXpP
         m4Ng==
X-Forwarded-Encrypted: i=1; AFNElJ+HRfKNEyPht9Te6Va5wYuefZhny30Qlv7wjgeSYiFXLbGGPVjleXHjGNbEV1cy//05bRlXXk1UqdQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YywfX94URT/Axt62HYVyNfGg9vlR7YKIFBypjYKnXO35F569a15
	W7hAIE+MPlTyPhKm/Cey2ASUyVQWALqv+79ev8GDNR+/u0o/0H0Bc5n4
X-Gm-Gg: Acq92OEgEuqzV7Q7LGMq+N6ZNwnaAO3TkqLUJBz4BGvoDKr56gvbhq8yp3RuIFI78WX
	idIpTUkkWLj5ypDsY5+0+fFpFFR5009aFCzQM6RfbpJVNLDZX0bZkCX0HL/dhHxOFmD6/Fgt1dS
	q7QN8RrQ+8HrHf1ftcsLb/8nMeAFplIkA2/TzDwnCLjh3N3kvRD0ICBpcbGnmDzS9mdjsZgNDOd
	vV33NxxwaZQddFnxOojl4GW2FLkc1MBZjvAqrhOUUhT/7XHmzDhE00WRF+pSxEbTigtD7JAMr2M
	XsR+s6vexmhmsY/lLB9wKjQltpWo1zP70aSorvW7oPxpkjeDLqTbNAl+eq5kvMAiKOlz68k5I5P
	7rAwj86lqUzlInQ9XOKONb4AnY5B7dH/jUgLm5b0Oq3XvX0++2qygy/Qr5hFke8yeNvwpCga1jE
	nYyUdcO52s6UYeWyTSadiIc96aAdxYb3g5fKjy1B7bhCu8Z9p5mdg6LtPUgTHjfW6+ui7TF+7nC
	johDPzpGn/lLWY7aQ26eyJinFGVwsKwKXSY3a65XXsm2t1HHR42FtWPNWn8XuiEVzW6vU84mnf0
	Cr9eSJJL/9spVLiKsHRxhyGbpE5UAEN8VY7s
X-Received: by 2002:a17:903:2ec6:b0:2c1:41f8:7ef5 with SMTP id d9443c01a7336-2c3fd1304f7mr28480935ad.22.1781265021627;
        Fri, 12 Jun 2026 04:50:21 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c43307a259sm19993085ad.68.2026.06.12.04.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 04:50:21 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v2 2/2] xfs: prevent close() from hanging on frozen filesystems
Date: Fri, 12 Jun 2026 11:49:17 +0000
Message-ID: <20260612114917.2192-3-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260612114917.2192-1-aditya.ansh182@gmail.com>
References: <20260612114917.2192-1-aditya.ansh182@gmail.com>
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

