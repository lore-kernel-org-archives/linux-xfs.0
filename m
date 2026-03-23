Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF55E3164B4
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 07:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774250841; cv=none; b=PRb2GT/x5hTkIolCkoavyF2A9PB0DOfs/L7Foxq/83iTcDSzo9ZXSRQWOjSbm4yOC6YsyEAdjxP9ptn8ioSq7kinB9RaDGD0gI3Xn3GiKSVV4ikgpcdusEJ+N3b8giZCGlzMMiAs53OoUfxHT9JvQZ/toOg+Jy0pJS8ztGxdX98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774250841; c=relaxed/simple;
	bh=7WPWs1Sp1g3Vl1AoHyo6/B00u7Vy9BnNDHYKrKY47ok=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O6xHPVMxckpHht+WYwKP8l/4xKGdd9/TR9Kylsqwh95Dk8EXwEgJ/OTFONxCngFr6Xi/ZVKPaIhEga/sZ3PfHGOgJLxJG2wXXzsU+2qDxBctlmlmnfPEdY66p5HFFR4yCWLueCnCYMENVA4IP05doxjTNn7V5KhT4g/bMIxkabw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dHbLkvav; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHbLkvav"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8296d553142so1630140b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 00:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774250839; x=1774855639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HyN15G+MEDzt2QKd8l7H0bzTezImqr3C5TjJ8HaJLCg=;
        b=dHbLkvavK8hiB0mZq62JFtDHaaCwcZTq2ar5ujnBjh8qfQ1yAoOn+RZhXM/hEYGWEr
         KtTq7RizxKxt56I8rCXaiBbbPj+MeISlutNH478JKy9M9phykRjdnDii+2VQcK2lFEUf
         VBGjtCKOX96Sgh9DKFwRuaXKzHcLuRfnuh89NcxYlip6rnDit2PNxRGaRnz2GMTxVyRm
         rcwqk8wiXK7eEZcOlUxfnKwfaC/k9VEysxhmOxyMj5xYhVfkepb5Dr1dTwDA3rhMIYqq
         wnd+KX/7R+OWSzpe3v8Uoc87xBTdECrZdE90p86BkzOgWUgyzBEnyG4rACVfpQMsa4sP
         M9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774250839; x=1774855639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HyN15G+MEDzt2QKd8l7H0bzTezImqr3C5TjJ8HaJLCg=;
        b=A81baswoGOgKAQ740Bw9Y081+eUon+s8xmGpPVKY86goczMM6uigm02c4RemOACJiv
         aY4/kf4rlmFiV5os6TYVymcTFUBI4qJmE0uQ8PL+ASQkMw96pQ8OaE+lNEx3nZvj1Syp
         bNCm4WboQKpE6OIzLgM9Tlmpegwk+YF9tNM4C1Dl1b/7FZeq7PHFNUYF3eBNhPKWP39M
         bk16B9HCSuIcatQlzQYRPP0+hS7q4P99MosHBwNY5kmktwGXBMgfueej+EFz0aOucSBW
         iBPPju1uUzX1VxOP80CQ/7hvk0xUrzMOJ9fFx9Jodh/SZUc+pxnoamAw4v43aG/6iXLy
         KwAw==
X-Gm-Message-State: AOJu0Yw5pLNKBa+pgnJFjNJSsBN0gBY5v3E0UtXpqkC5zYYS3OWwqc6Q
	Wyt648vrxmfNaYahHyLKXz1kv5kUntqC1jCPPq7thjpZJR0vL9PB+EDq
X-Gm-Gg: ATEYQzw6t4of8WY0S3h/RxBo2JYzv/rg8tlGlj5GYknr9U7xdhdof4jicValU4rXwTl
	58X45DYmFk90Fqx1tFN306D4+W5QeM/vZl8MguLqcW9wfPrtBIGPB3u+FiZjSsqDlYm3yrNWyAy
	u6Hj5kUbEkVuor1FK83633x6i+wC97aTOtjdGAWR4PZv1uzddc3/4JIZEIOcNgFE5KDgrOCqwJd
	bIm9gaBVz5rlB7U5LKzPzkIJrqfj1IvzwzzI7mu3sCMz4wiEVlYoj4wm+LCHLyvIHl90tfiVfce
	F554T+WfFiyKuRbX00n1f2xL4Zpvj9kvQcE7I7niG29uEAdRRg4Am3YS76Ev98rA5MzfKGra7+G
	2Hdk1FwHhl0XrUpo+SiGmjEZCypKctaKAjZXlGV+GZ8KPCmmjzedslrwRh4BXwPKFKHe+49DRV4
	gQ2ptzDSwZ0zovbuR2Uw==
X-Received: by 2002:a05:6a00:2349:b0:824:4a22:ec02 with SMTP id d2e1a72fcca58-82a8c3878camr9366286b3a.42.1774250839210;
        Mon, 23 Mar 2026 00:27:19 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03aa5aa7sm8476962b3a.1.2026.03.23.00.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 00:27:18 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: use xfs_trans_ail_copy_lsn for lockless li_lsn read in CIL formatting
Date: Mon, 23 Mar 2026 15:09:49 +0800
Message-Id: <20260323070949.3769170-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_inode_item_format_core() reads lip->li_lsn without holding any lock
to embed the last on-disk LSN into the log dinode during CIL commit:

    xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);

Concurrently, xfs_trans_ail_update_bulk() writes lip->li_lsn under
ail_lock when inserting items into the AIL after log IO completion:

    lip->li_lsn = lsn;

The CIL context lock (xc_ctx_lock) and the AIL lock (ail_lock) are
independent and provide no mutual exclusion between these paths.

On 64-bit architectures this is benign since li_lsn monotonically
increases and both old/new values are valid checkpoint LSNs.  On 32-bit
architectures the 64-bit xfs_lsn_t can be torn into two 32-bit loads,
producing a bogus LSN that could cause log recovery to make incorrect
replay decisions.

Use xfs_trans_ail_copy_lsn() to safely snapshot li_lsn, which takes
ail_lock on 32-bit architectures to prevent torn reads.

Fixes: 93f958f9c41f ("xfs: cull unnecessary icdinode fields")
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/xfs/xfs_inode_item.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8913036b8024..0171f4527f40 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -622,9 +622,12 @@ xfs_inode_item_format_core(
 	struct xlog_format_buf	*lfb)
 {
 	struct xfs_log_dinode	*dic;
+	xfs_lsn_t		lsn;
 
+	xfs_trans_ail_copy_lsn(ip->i_mount->m_ail, &lsn,
+				&ip->i_itemp->ili_item.li_lsn);
 	dic = xlog_format_start(lfb, XLOG_REG_TYPE_ICORE);
-	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
+	xfs_inode_to_log_dinode(ip, dic, lsn);
 	xlog_format_commit(lfb, xfs_log_dinode_size(ip->i_mount));
 }
 
-- 
2.34.1

