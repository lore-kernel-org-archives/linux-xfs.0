Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69093921A5
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807687; cv=none; b=uHToah8SySIxFBuNjBKDOVJ9Ug/lIy4FFE7rhksZnE1jW27MHIFMyWmOQTJYJr5Tw+CM9/9uQ6mX3Gldp49qyKdVcCSxyjaUihaH3XQ8M3UFeBH9eN+46W4G4QBrLDIFPfwbsPKp8a6EDU9sCuiOJ5hCw64cya93fEmKjwZqcpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807687; c=relaxed/simple;
	bh=i4hePIMWRF5Mzc731oRxQkAAktt67HnoQ6nCM1aZbyw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwJdH94vtgoxvgNyfsqQMBZ20BvRSYJuEUdVqhelxq9LhFMlU5emswYnesOnNc5tUfVWKiF+Iap7fuBGx2GklHiAOOJG3SwYdDDABeYNZqx6Gg6ZPUwrXpckR6oQaHmQVl5JmlQVAE6dUjPjmhVL02NQ5Y/6JeQMe2obU6UBJJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=KvXv2mkc; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="KvXv2mkc"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e95026b33eeso1473746276.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807685; x=1756412485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ag9tvG0VI18Yk1eq/2xT5jiAIgHSAzuzC353p9H0cHc=;
        b=KvXv2mkcwwtjYomjJXpU7AH9jjeFpZ+w4rnpP2bRduLCuMXcWm7ON3fJpdvhkPRdz6
         nXDB/vfXkpukTP9Vz2l+YEqtf//LPg12OIgaOAMSgpYC4yfXj9drbE+ByoZLXGEQjYFU
         WmIDh1nWva4SitZVFIh7z5wJvQn4b9K79CQtgVwQgCOD3n31Ke3A7hcZhJikZgdQdFWa
         OYuEFMithHzKj9RuH6okpoxgbWMuwiBr8Kd6gaqPnY0guii9GuoZ72B4rWoQhAVVFq+J
         salYIDUSGGCrwhQ3utJg6MTnbg5Gl6tAstLrwHUOleXUh9E9T//WfShqX2at3ggNX0BP
         zYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807685; x=1756412485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ag9tvG0VI18Yk1eq/2xT5jiAIgHSAzuzC353p9H0cHc=;
        b=Eum5/SU9QMo3zixg8OZAvN+NExmJ5nDkGw7V3h6jQqQ1KrDeYWH0kDvpxzGQVlxOjR
         vHFgyTt7uaqyL1fQ+843hoS8WYHvck0wdolqfc+rMin9agbkDzUY3ywE/124yAQaMwSb
         U3I/iJfm+LzKsvkB7zFAi66l14HmFGh86+WOu3OPcLybNk0o7gt8QgVu6yHkrdiEBqM3
         ph9DEKZk6rJf9/vh1feZMYEtpXuiYI7kfwkRRnZZDKYFa0Bcd4WEz+MPLgsHToN/YxXV
         DLykgFog9CefpumL/to6VTVfLozzPCSt4Vw+yobY5sBQ90XCK2tJEjAbeQeTDX1hfIOM
         ep6A==
X-Forwarded-Encrypted: i=1; AJvYcCV/l3pkHIBHqmGDfxbnocmnyNVFWdBwh4mxBTk7FP0C53wSxTzRT2rgQFNX7uIBvucqKKHyRC33IZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKloWSzW70W28VVIyuUDGooV962pStQcU27HEEbXko4fkrhey0
	xofOxBKuTeeSgpfG3BBrGE+VaAoPFdVN3vApzopFjJgwJ25mirQ8wW2/U79RSBtXNOE=
X-Gm-Gg: ASbGncuai2H8At6IosRJIKFxGzIiH97AvinDF8utC+YBssHmSckcCH9OK/OTKpIG9x2
	f9A6WJps+C84HD+MzslK8C84hwNAYzNcBZn7Iid0Jpg4Snqq38dMXyDBY55HPrp8+vuFuT5dffM
	r9Mr6K2weJYNtMMfKJ8JAiQPM4N8GZ0wLo7HDJp/FrK7a1MUnOgx2zIWg9fSlUFxFk/wJVpHq8S
	U44uDMLvOb2wztFLJH9Gk9Ico+XvpyREEik65ITH/smDynYiZszK5kxRajITUE1oXYvpPEE3FLA
	3Lm4hitGw1eC9iWjgQpcFiO6DFlsRQPfciec0A8Ve8E2EmyjdnDpH+Gp8iwwbOq97wZt4whZWBp
	ZCBBSq6aAC256QYsj3MN4AP3vYq7z/4WOsoSrvZA0OU7E6rBbqMXt4eLMY+l4VukRPKoHepdRtP
	mwrDHT
X-Google-Smtp-Source: AGHT+IEBylvc7AHp4BniCBq5Q1DyNIynT9BLRz0rP2zm0l1TKcTJo/hsMPaTkP6ZgkuFyU8mOePjTg==
X-Received: by 2002:a05:6902:701:b0:e95:1521:3d93 with SMTP id 3f1490d57ef6-e951d08e7c5mr623429276.15.1755807684641;
        Thu, 21 Aug 2025 13:21:24 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9348b2c51fsm4962060276.7.2025.08.21.13.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:23 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 45/50] pnfs: use i_count refcount to determine if the inode is going away
Date: Thu, 21 Aug 2025 16:18:56 -0400
Message-ID: <8b63d783e7896e857380857ec4c40a00e17d8d73.1755806649.git.josef@toxicpanda.com>
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

Remove the I_FREEING and I_CLEAR check in PNFS and replace it with a
i_count reference check, which will indicate that the inode is going
away.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/nfs/pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index a3135b5af7ee..042a5f152068 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -317,7 +317,7 @@ pnfs_put_layout_hdr(struct pnfs_layout_hdr *lo)
 			WARN_ONCE(1, "NFS: BUG unfreed layout segments.\n");
 		pnfs_detach_layout_hdr(lo);
 		/* Notify pnfs_destroy_layout_final() that we're done */
-		if (inode->i_state & (I_FREEING | I_CLEAR))
+		if (refcount_read(&inode->i_count) == 0)
 			wake_up_var_locked(lo, &inode->i_lock);
 		spin_unlock(&inode->i_lock);
 		pnfs_free_layout_hdr(lo);
-- 
2.49.0

