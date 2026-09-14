Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A7236F42A
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789374557; cv=none; b=JB1MI53XQmLR4b4PvMeLU6k3FDM6VfO2XC6/s3B6CIV+oxzWwEPgE7HzL7/WPrKd0jCKU+WzKJy33WOqgXyB7IM5JCqu4XPjtkPwW4teYo7YMfOFrBIdLCqwVFw2nLafNzcniMP4d9CFM9MPMDq52ooSxl+1psX19jUmhjPIS4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789374557; c=relaxed/simple;
	bh=ThjuJJIilkFnb3x21CQlJpZVJrdeK0DbvDM3qFJoTpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0S+ZwNvk0HdOELqfuM51Iv4dKWF6fEd0t4H4NRtoKATUWBHJoPWTw6REafqla7mBAxr8eMYXL1XwVpP+aE3hatltDr0VxH4SsUEKsGGb3s7csNaJk/bFEA334TI2NT6n2PsNPk2SvuRWBtDhXdX66ojPIT8XCopSZrQ4gDVg/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sHroQjuI; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sHroQjuI"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd53691be5so14878035ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 01:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789374555; x=1789979355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VIqJAEv0wE0GewharGE+LoF/XSc70c9h3/w9GQFRHEs=;
        b=sHroQjuIbiEQXSi22SU9sWidRXpp5zHr7SJ6AsJNq9LF1pd3/023NoAUtdDkYCcxiJ
         49KTlwKA6UeVZTkn4CAbe5vlA7q94Ybk9pkOkVp9aQ51rhCEgbMUlZF6duFaNngUXmP/
         ekRFobmrIYqjF5ZgNudTj1Ne1nA8/WGIY8yHv47Ab0bs32M/ImQKJ4RbYanlV0WntBse
         BvxS4PkVUzW0A33Q0qvkDVjLLmHUTIerDMltROeuh/5ZIuZY3CwzY5T9SRDO0UWx/AO4
         xufhw4hJH04yjTr9TGp+waczB/JJ0mYa6vgT/cUxma7RHu/TqSp+u+cxaWLMDNqfPO1T
         +kfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789374555; x=1789979355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VIqJAEv0wE0GewharGE+LoF/XSc70c9h3/w9GQFRHEs=;
        b=Vx98VeQaM8HCpQdAt+HHBjzLhgi0O+Hc5x1JWKPsg/6Gs7DptNpmgS3Zys+xEcVz2a
         GoKAu9SrmiWLkJJWxy5lMpLXfRV8oNTQbZbV05xrTLq8MbKlpakKCcGTa/ijI0+lsRdR
         T3mLjwnx6hGSXY3c6SUkjqrG1lUGYzvZNHdJFM/n22G8KaHS30/ILlunLzL/UuAfZ91l
         Cap7CshGu73QwgRDMR+il3kTrVjY7lVlO13VbwZoG/pScPeBATdMR/pB2C70UCQaPhsB
         Q2peWv9XTXclAt9HRkaceQ0enPBRCw4SlMkhGhegv3p87PnBVordPbc8PZT6qvrkFswy
         s9sw==
X-Forwarded-Encrypted: i=1; AKwUvBw1RJ+FxSDIVPWuWbKksS9GkOK+o8Av2Dg5WNyqM/GEmBAV8cO/J45WuvEhB98+642+s48PHLK00Oc=@vger.kernel.org
X-Gm-Message-State: AFuF++mQzeneixUXtw1yB4g/aShv9JFhAqPFdps7FUUD9ltkpmd/NhzL
	n6vTUmim2Yk/H8ZDnrNZSYFAJL1cMxHZr2/nSkVE1XQpvU/vJMK8g0N3
X-Gm-Gg: AYBFou0zA8GHTroKuMOEXtifBN1qNxN0l2ZZglLXEWac9ZP6JWhTcL0C9Q6HcsDfKbJ
	rJWFX6HzWjw3gMnEfeYp6dGKRB23EYpneCs1iQjv0yxWQWlDXXjV/sA3Lp0h7mbiMnSJ1X07nqS
	DA9gSTCH5LKZJjal8AihdEhQrqB12UxiyzCSR+PUckV3hKTrm6EOYgBIT/F8jTYA+ZM+C6TeoCa
	6pX+tWpanq3MVX5FxCjmNgkaqf/9n1BWX0JtXPLYWx+BSoXDSS3x3ymFGal327Dol2bsIviXZoP
	iy8z00CSvoLBaPB5IFbndYaLHkN85eOrjZi1XQazPH8Lj2EYJbixxBvUehZsNaMbG+JYiy7OH/p
	Wr8UCcBtGyAywEG915peTfHGfVLTDgiqG9ZXb7FiKyBl5x2WAcyzNUfK/zutr0PTdUQLp9jhZv4
	PeK/Z80Tu4OEBiJi9jLve4KtdslyxqXG0T29np0vO5x5fVbA/RPEENweq8D1CST733AW+t+Dxzr
	ktshTMBZI15+WRbywhMu4ijvb721rS+qGyrfB7ByfNu45ghzH+JKhQsJnZUJUfQ0YS4jno6FLrq
	PoNVw7qxOE22Iv6eEM2mFOjsEwJ0l7m2hcTHENgjCXSax1QIwfi0F+L5lXRxxqLLYpc/1OYENo5
	hwt6x/3nd
X-Received: by 2002:a17:90b:1a85:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-39debf9ca9cmr3433982a91.9.1789374555059;
        Mon, 14 Sep 2026 01:29:15 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.t54fbfa9bf0658dcb-tp.internal (189.207.21.34.bc.googleusercontent.com. [34.21.207.189])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d994872e0sm19843658a91.8.2026.09.14.01.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 01:29:14 -0700 (PDT)
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH] xfs: prevent close() from hanging on frozen filesystems
Date: Mon, 14 Sep 2026 08:28:36 +0000
Message-ID: <20260914082836.1658-2-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914082836.1658-1-aditya.ansh182@gmail.com>
References: <20260914082836.1658-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a file is closed, xfs_file_release() attempts to trim speculative
post-EOF blocks. This requires allocating a transaction, which blocks
indefinitely if the filesystem is frozen.

Fix the hang by wrapping the preallocation cleanup block with
sb_start_write_trylock() and xfs_ilock_nowait() to bypass the trim
best-effort when the filesystem is frozen or locking fails.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/xfs/xfs_file.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d8202da15aca..dd6d2e08faff 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1872,17 +1872,21 @@ xfs_file_release(
 		return 0;
 
 	/*
-	 * If we can't get the iolock just skip truncating the blocks past EOF
-	 * because we could deadlock with the mmap_lock otherwise. We'll get
-	 * another chance to drop them once the last reference to the inode is
-	 * dropped, so we'll never leak blocks permanently.
+	 * If we can't get the iolock or if the filesystem is frozen, just skip
+	 * truncating the blocks past EOF because we could deadlock with the
+	 * mmap_lock or hang the close() call. We'll get another chance to drop
+	 * them once the last reference to the inode is dropped, so we'll never
+	 * leak blocks permanently.
 	 */
 	if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
-	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-		if (xfs_can_free_eofblocks(ip) &&
-		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
-			xfs_free_eofblocks(ip);
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	    sb_start_write_trylock(mp->m_super)) {
+		if (xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+			if (xfs_can_free_eofblocks(ip) &&
+			    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
+				xfs_free_eofblocks(ip);
+			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		}
+		sb_end_write(mp->m_super);
 	}
 
 	return 0;
-- 
2.47.3

