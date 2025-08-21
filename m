Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD286350837
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807624; cv=none; b=N/ZqDnBtRILmsF/uLiwe+ZKYDxDCDg+ebQYnkZ3wFt2lWosuHP0AwtiOirEUPQNbt8qKVWbCVJT0daYzi5Ptlw1hDv9N0HKfBZRyMZKVXUiu0tJY+v3PXe9lpXAQk7IMXk7ru8PK5xKBQw9DFVHZlnpUb1UqHYQzv7flhBlO2Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807624; c=relaxed/simple;
	bh=D93quPOEYKV3ecF80PgDZ/SBCUn+YEd3pA6H3kfuds8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAZoF/DLSHpNIBsepWE2cI1IR9rWiSqEwItKo6cQpv7bYzNGRAU4gaXUnOtz24ufZNViwk5suVWmuJBlC3xzvYkpfn0Qvfvz84CQfSPshzwUSVL1y7njKqI3qH6fRM6M/CT3XQy52hKXnzZ6SK02/wBxyLdNKrk7dEggTVLv7VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=FdjFDnSf; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="FdjFDnSf"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71e6eb6494eso13041087b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807622; x=1756412422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HAA7yBTxTE6ptsf2bLIbVrVMiD/7hA8aK0cz9PGFZKo=;
        b=FdjFDnSfQSraijqQk4sRFY1Q/f7Na957iwTOMAMkV1vDWbUvnYX2c9jm+Yecn59Xq8
         e9Q4yUlnAJCLAhN5PJYMxOnLHYJSjOzF6j2uUDUE6kQ8mcd3s8H4BNXU2hZ4WitqIVuj
         qixhh10usq3B5ANJPaoMcOzpggFR8xj2FL6aSdI01WzbzpNowVYIAOBUW1AyVDoN5jQq
         nDkwe7pbw7Za7iaoc9ZYC7eFA8PhSSeBu7zM2bPx6XcIUPaN43cnMIPUDi9C7lA1tNQj
         aK0FRgEzqRhXrZDu+xMw1XYe/+LwFIHw38nuBKNmlvSOLLFhviwZKra/h3h6JGnrwkYt
         tHsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807622; x=1756412422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HAA7yBTxTE6ptsf2bLIbVrVMiD/7hA8aK0cz9PGFZKo=;
        b=dFAZ6V4GKJ7dJVfWJuV9c2Zu678gMBdtMz22U+1kof8lgqyI9D84svY80Wo8D+54AB
         ShSIHR68k31yJGd58iJY/TnHBn9gnvIwZ035xerj36NaP57jJa4hH6eNWP0BHjo/U+cA
         ugdgHmmBHgSI+gOBgF9h/KVdY1CV6hNrvm0zf8jSGF7zC+UvhvVgM34NG7CBlUuX5jge
         oPINcQWS0Z11e+SEZQr7c4mMhhz+ZsgmJg/mnPl73qxIvkTgMlo5cZ9m9wiBjdczu0s8
         1Wdonk3e/feBn4DeE/Rkdbghyj98wQah84AdW11i5bxaCB31gPK3dY+Ojf68PoEdV42z
         Zing==
X-Forwarded-Encrypted: i=1; AJvYcCVSqLf3LVrjHiwYTCz8drigOdG8NcUOAVYLlzj5NyraQirvteAE+OJ5yH2uUNjHClLeZDZrqBq42uU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz56VBxI/yJ5fdKrKsMR58sU4ilDK0n9pit1BE8QiTj8MzdSurm
	CckyF/6NaL114T27IP0jb12EsgLMOLojSiX8yl5WHqTdSaFFZaxeKcddQW5Ry479ToI=
X-Gm-Gg: ASbGnct5hBZVXh2e1gevXKsECe9FCcZwcj0/vTSNLnbQyUs99zHMiK05GBNFJrIT7mA
	e36mYBgwi24h5uPj9sgQVWzbqlbAqqQeWmRHKAydUUALZyLW3YJGMgZEWtra90SrLvlqr1/Er02
	+Yeab7DDwxvSY57hguZlhjDWrhWb7+f6hPj8snMPd2v+AkcV72Y1aZ64BNqQpEYLC3QSPXHNw8V
	c6f4HCw3HLykAN911XDe/DjfpTAaC9SzC0ZVLlPF5/lijwoGoCdi4/esbcSZhA3G3EuS6BabrJQ
	ncvyRBp5zR2WBY39ymhMbZ6KCDTzPZHZ6pOJNU6LPerKjfuB5KxRB1yy88Y/tPeXzB+q0b8bvzp
	/1ydXQzHxBtrlpi88hR5FoTCBBUXljrfK1K2ySGUnOCDGDw0LJKnMIfu9/yNmli3pjSPOOwOaJz
	MmHt7O
X-Google-Smtp-Source: AGHT+IGv4NhJf1cT6NIbqZa/4R9/wEW3Dk34Z/qOn5/BwvXw6MJR1AIUtLA2xvcvi2nVywQSjYDnPA==
X-Received: by 2002:a05:690c:4b89:b0:719:5664:87fd with SMTP id 00721157ae682-71fdc40e0aamr6490137b3.37.1755807621709;
        Thu, 21 Aug 2025 13:20:21 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6de96c79sm46567797b3.11.2025.08.21.13.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:20 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 04/50] fs: hold an i_obj_count reference for the i_wb_list
Date: Thu, 21 Aug 2025 16:18:15 -0400
Message-ID: <39379ac2620e98987f185dcf3a20f7b273d7ca33.1755806649.git.josef@toxicpanda.com>
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

If we're holding the inode on one of the writeback lists we need to have
a reference on that inode. Grab a reference when we add i_wb_list to
something, drop it when it's removed.

This is potentially dangerous, because we remove the inode from the
i_wb_list potentially under IRQ via folio_end_writeback(). This will be
mitigated by making sure all writeback is completed on the final iput,
before the final iobj_put, preventing a potential free under IRQ.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fs-writeback.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 001773e6e95c..c2437e3d320a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1332,6 +1332,7 @@ void sb_mark_inode_writeback(struct inode *inode)
 	if (list_empty(&inode->i_wb_list)) {
 		spin_lock_irqsave(&sb->s_inode_wblist_lock, flags);
 		if (list_empty(&inode->i_wb_list)) {
+			iobj_get(inode);
 			list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
 			trace_sb_mark_inode_writeback(inode);
 		}
@@ -1346,15 +1347,26 @@ void sb_clear_inode_writeback(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	unsigned long flags;
+	bool drop = false;
 
 	if (!list_empty(&inode->i_wb_list)) {
 		spin_lock_irqsave(&sb->s_inode_wblist_lock, flags);
 		if (!list_empty(&inode->i_wb_list)) {
+			drop = true;
 			list_del_init(&inode->i_wb_list);
 			trace_sb_clear_inode_writeback(inode);
 		}
 		spin_unlock_irqrestore(&sb->s_inode_wblist_lock, flags);
 	}
+
+	/*
+	 * This can be called in IRQ context when we're clearing writeback on
+	 * the folio. This should not be the last iobj_put() on the inode, we
+	 * run all of the writeback before we free the inode in order to avoid
+	 * this possibility.
+	 */
+	if (drop)
+		iobj_put(inode);
 }
 
 /*
@@ -2683,6 +2695,8 @@ static void wait_sb_inodes(struct super_block *sb)
 		 * to preserve consistency between i_wb_list and the mapping
 		 * writeback tag. Writeback completion is responsible to remove
 		 * the inode from either list once the writeback tag is cleared.
+		 * At that point the i_obj_count reference will be dropped for
+		 * the i_wb_list reference.
 		 */
 		list_move_tail(&inode->i_wb_list, &sb->s_inodes_wb);
 
-- 
2.49.0

