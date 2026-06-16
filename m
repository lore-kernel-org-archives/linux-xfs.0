Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E499B3C277B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 03:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781581128; cv=none; b=KJSSqdSR7fx/XHKPzj4WHcztTPLIMHnfdQqrxxYEoyDEmt7U99n5cKR/cWBJvLqrtfgdCSEPW5ZNz1mlLdu0o0JrLEJUtSG/VWqmDWYGPHlV/8h1jIvsCRoWeD5R7LiRehrw+UXQCnTMNaOObeLZFminTRlRi0LDaIWKh1ZFa3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781581128; c=relaxed/simple;
	bh=4YugNqzpU/MUU8LPDCZyOxYQnpDvya+z7cWnHsiF4do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2AH0BBgBh5RfbLEYplZ6+bZrEdz2TefQ7N5mR8VK2D7fFcnDFEC8a7KnkTwcAs6s7qHeimgr9vkCJFoNopmkBHOZdUqjfyAs04in1/ZqKlFqye9UT38+CbCkueF46r3dqbQ0+/ulX4wS3BOSIpRAUnvj9J9QO6Yt0Y4En7rK6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6nX7kAw; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6nX7kAw"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c8587427468so1639448a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 20:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781581126; x=1782185926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iIvjY/yXmZebAH6dkGtl5V3Mcnn9oZGqccC0KLbuVys=;
        b=B6nX7kAwps9xUaZM5wXjMYlU+74/npn7BSHkUWhiC01V0ZXNkgC6cIXyryoDAVN7Tp
         dQP2PmB7rI7pgRk1oHBSSIcDbgBAx+sufddGlKJiVs5CYnN2ZHOxvG121lL+vDodZNIk
         Yb5xJGw+PcODgwHQGujw2tUTwZCxLgV11N4XiwcaGtNxiILnjTp0Ww57z2l8JdjIf5eE
         T1WeKzpaKAtKn4GsUB1KWoDmvn69LZne2jQ8Qjm5CW3SrXrgmZAlJGDqpcxKgN2EYqmK
         eNaEdze/XUR3kBYbj4suiQwMJfp8qeS1MVR9bWdM34Had8GtS4/c2EgidpBaRm5GposD
         yU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781581126; x=1782185926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iIvjY/yXmZebAH6dkGtl5V3Mcnn9oZGqccC0KLbuVys=;
        b=dEUMJNBfQXAAWW7LGlLLscSZcr7UpvZTI7llptpiYptb/VUH9SITuUa9it5T3QaxWP
         IERyFJWF+7YywRuhXeZvqR8cwDD/hZbp8zGJVCWfSuyG8XxDBwEwmNMdbQAaPviD8BMw
         51DkntxZ1G7/eYtivfVc2z6k0EKPfA/VqaCoWYnvfOemyUykg/I3jWLEc815ip43eEFp
         TDVqH4TPhi0YFYZ1mNQ8Mizuk677ufBRQ6QIlyaISQtHqcjIVwFv2JrxZuOKC9ygUUcB
         l1Gv6yTtaUQGPGocGobnyF2S5PQpGLMl/Je1hN8MaaFYSnEutaXT9eIqky/Um9nRd4ue
         fgzg==
X-Gm-Message-State: AOJu0YzflySN3ztxTAHC2g4q3o9451FDPYHveUX96IbXiq8A5VWELGtc
	22HUrQDNouj+YDE64ql6NtIK6LrZDSqzdjqOrsgmy2W4Fpb4lU+SL/Z7
X-Gm-Gg: Acq92OGJbY9IswySiDMYLjoqwiOjx/USVKxDokRh7IEOA67R3quswm16iae5iyBrtlt
	h1Nx3i+SxiAFBD10QoxXZM+Ah3uJEv/G/TRr/rYibDppo+iMrcveFWuGEYadMVlKGeNTG4zc+9c
	a/YxamgwpSJXyqhjT47o8Jk1CWr9Tj1yIyUkmq+T05sF+rHXRWb2QOWFW+pIXn9h7JHDgKPt0tB
	UukTEdghNp/Ut44BKN1vNqO2GZXwe+TP/g2TxMbuw8emKn0eZx5LK0FIdOCFQxY3WpPQaROanm0
	f1E5s1NmLXJQnvToaeion80rguPyyrmS7ZpAb5yCPgMytV+S0wSfhsLp67MCoeW/yCg4gdgISzZ
	ebYMcVocYFHEPrebntarY5LUbeAStxyIdQo/b5UxYTPAEKuoWR6Gb422Xlz4XsGSRXGz+ivD/lD
	1/B7YuWVYmx5t6tWUFb3g0jlPTUlZZeFmMJlrcfUMxyrTUjGFK0UwOTQKEn4OhlKUL4Y4kcrqXB
	WZqfHDTYoh97frQCkCK4RskJBjbBrAUil47sZZ4xKluLEr0bg0joPI/3rL+PloOdXQnQObGZzyi
	jtMj+Fd+RTrNNMKnqBjUoPL/hzqPaEEWN6lhjYk10sJUtRo=
X-Received: by 2002:a05:6300:408d:b0:3b4:b26e:bab2 with SMTP id adf61e73a8af0-3b7e4951a26mr2018884637.2.1781581126219;
        Mon, 15 Jun 2026 20:38:46 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (229.231.21.34.bc.googleusercontent.com. [34.21.231.229])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c866325d156sm10304173a12.13.2026.06.15.20.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 20:38:45 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v4 1/2] xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
Date: Tue, 16 Jun 2026 03:38:19 +0000
Message-ID: <20260616033821.2238-2-aditya.ansh182@gmail.com>
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

Introduce a new transaction allocation flag, XFS_TRANS_WRITECOUNT_TRYLOCK.
When this flag is specified, __xfs_trans_alloc() attempts to obtain
freeze protection using sb_start_intwrite_trylock() instead of blocking
indefinitely on sb_start_intwrite().

If the trylock fails, the allocation is aborted gracefully: the freshly
allocated transaction handle is freed, and the function returns the
appropriate error pointer ERR_PTR(-EAGAIN), which is then propagated
to the caller by xfs_trans_alloc().

Also add an assertion in __xfs_trans_alloc() to ensure that both
XFS_TRANS_NO_WRITECOUNT and XFS_TRANS_WRITECOUNT_TRYLOCK are never
specified at the same time, as they are mutually exclusive.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/xfs/libxfs/xfs_shared.h |  3 +++
 fs/xfs/xfs_trans.c         | 12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index b1e0d9bc1f7d..68d22b6cddd3 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -164,6 +164,9 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 /* Transaction has locked the rtbitmap and rtsum inodes */
 #define XFS_TRANS_RTBITMAP_LOCKED	(1u << 9)
 
+/* Try lock filesystem superblock for freeze protection */
+#define XFS_TRANS_WRITECOUNT_TRYLOCK	(1u << 10)
+
 /*
  * Field values for xfs_trans_mod_sb.
  */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 148cc32449c1..3860e44d6439 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -216,10 +216,18 @@ __xfs_trans_alloc(
 	struct xfs_trans	*tp;
 
 	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp));
+	ASSERT(!((flags & XFS_TRANS_NO_WRITECOUNT) &&
+		 (flags & XFS_TRANS_WRITECOUNT_TRYLOCK)));
 
 	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
-	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
+	if (flags & XFS_TRANS_WRITECOUNT_TRYLOCK) {
+		if (!sb_start_intwrite_trylock(mp->m_super)) {
+			kmem_cache_free(xfs_trans_cache, tp);
+			return ERR_PTR(-EAGAIN);
+		}
+	} else if (!(flags & XFS_TRANS_NO_WRITECOUNT)) {
 		sb_start_intwrite(mp->m_super);
+	}
 	xfs_trans_set_context(tp);
 	tp->t_flags = flags;
 	tp->t_mountp = mp;
@@ -252,6 +260,8 @@ xfs_trans_alloc(
 	 */
 retry:
 	tp = __xfs_trans_alloc(mp, flags);
+	if (IS_ERR(tp))
+		return PTR_ERR(tp);
 	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error == -ENOSPC && want_retry) {
-- 
2.47.3

