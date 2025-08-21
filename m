Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2BA373F9D
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807657; cv=none; b=WlnkjwkuRNJzujwN0zVskkQl4ESs2sH1dCuKZj8sUw8sbGT+I9uhKpJ3f6CMHW2ZcLWcEDWDOaWtomHWT6b1eZH3g7mihMdapwdbept939+yTs5AQRc7on3GRbQ4m6IqplqEPejTqYYKmxCUzGfMeCIvZmCE3y3AUhL9aOnHo8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807657; c=relaxed/simple;
	bh=NKVthHrTpyCuYxypL0G6ZssB8gJJwQE+Gjakb3Uib/0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myhDgVAew20izb/eLze/WOyQ+1eFLxrrJE8fmslsURmlTtutoVSLGNQEVl8adyVQGoozZN3t9HMSpq6WL5m12Nm/f82U6LlnwjmiX52inAYfogCXSq42JzHCPrX0wRqb2h4+mg59EW8kO0krjDyh5O4GAapQWaaN9WfxL6ZyLC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=aOBn9oFN; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="aOBn9oFN"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e9513a4b346so988541276.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807654; x=1756412454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PorrIJhHXaHO27cDWxDKTAUw8tGpPd1qttfIj42aEmU=;
        b=aOBn9oFNsc51+699KhZE2yc79RJokgJKK9twxQhRbiO48sY/4ek8a9vjqBoCAFFBoh
         wyGcYOMGeCvDABETL7qL9UrzrtEvjEMrUgd80UtZhMTldUb3kClKs4SmdNdkWg/xlYs/
         E6rMPvGBXy1sg0FsKBBNDTjnVb3KU77NC4xSO7bfWccIqnn4/9YVl0gwUTbKrwelCtTy
         2aalGomFgU9e9NZJ5teqxdgsBDR3EL+3D5wG+QPAxN9/rhQpQUj6nKUMAjVMOurDkpPL
         6X+ZtPNWvujefTv5NiYyaqdvRTlUr9btUibDyvnnMwsn4ar6qdjCOXjbu7/UwoJbNW21
         /EXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807654; x=1756412454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PorrIJhHXaHO27cDWxDKTAUw8tGpPd1qttfIj42aEmU=;
        b=XZ1f3XGw5oF3ToBclprof2e1QIbycSAGHQcZQ9Z7NlqjrJbZlg5ZCtGz6UloRA39hW
         IEm5qZBoA6Fh9wEAiwI13WGWRoNV+uMDXTin6xknBTYHT7no4/hoT9XhagWosbnfQVm3
         jea4rVoXA0q+tNM8fDg6kObX+TFEcPEVD+FDoRheuzHcPlGo8lZObcNsFfkHIFcahBg/
         9zAjOpOcb/Xsh688UiHI0w/CUuBxG9c5Wd8bhLlO8GM6fhkBde9pMPPYtfOiiTpvaFrb
         +eRka62WrIOpQiNTPk/eajCZh80TGa7divsyVolatEevtQNjQENrFciJh8KtJpN7EWQv
         sDYA==
X-Forwarded-Encrypted: i=1; AJvYcCU1Hok0vfHizaeluA7VBd+RvAKqUkOmpMuJ1i/3dK2ecPas7unfI4tAggLWr1yaq/rJ0pwIZiwH6tc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7ZaoMnWUaO/f1iLpjKA0+KLdgceDZe9jOiPKFXuDrmlp4GDKj
	PS3Eyuck51jXV3xu0Wjg7oLjXEsC4mKToMpSXHwfGmS/18IMKAza/z9lRAmdU9ymw3c=
X-Gm-Gg: ASbGncswvCmhMRAkCQDnCcEuaLqlGPC/ljmVALQV8Sb4GweO0LRRQd+1RRVA1VdPgUE
	c8GsqDHxuPSQhnNOd0kOexqo+xzdAOqsszHqae9J5zkBvCgWb9/aCmmWrM8gDO5pXljBgtkQsKX
	U1xBKl0FQKKcU63w8WqPtvxlXSacq718kbm8Wr3rVsInxjp8tHTpn07TtDTtqj7e9aDWfkZ87J6
	ap5OpnG/Jn8zKk5ZZ6+ipM/RTe5aF190A/4RO7R66+/Gx8wqib9FVbo33pMKd7axCPZ8VGL2Vem
	Xu9tEcla9EIhAeULfn4QjssGLA9S9FMLNgK1ixZWPQgBQrdRxgfI2etGhwFusrislvNldyUqy6F
	T3Q+5tmyyDn2Jjp98ESIl1msrSNxqWKt7XOej0Ga4/xzNFwf6LvbOizqp3jcH2Ksp3iJqjA==
X-Google-Smtp-Source: AGHT+IGbGhHtW+dkKRPeIKh0lukvvT4QFrNpyVadJdYASbUMv52STVjCCLg+pYG9C9deIRU2g8iINg==
X-Received: by 2002:a05:6902:2b8d:b0:e95:18dd:6a83 with SMTP id 3f1490d57ef6-e951ce0495emr555156276.11.1755807654366;
        Thu, 21 Aug 2025 13:20:54 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e951c976124sm142232276.34.2025.08.21.13.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:53 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 26/50] fs: remove I_WILL_FREE|I_FREEING check in inode_pin_lru_isolating
Date: Thu, 21 Aug 2025 16:18:37 -0400
Message-ID: <954a16d781fd9bfc1b6cfec40af80475f710acf2.1755806649.git.josef@toxicpanda.com>
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

If the inode is on the LRU list then it has a valid reference and we do
not need to check for these flags.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index c61400f39876..a14b3a54c4b5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -682,7 +682,7 @@ void inode_lru_list_del(struct inode *inode)
 static void inode_pin_lru_isolating(struct inode *inode)
 {
 	lockdep_assert_held(&inode->i_lock);
-	WARN_ON(inode->i_state & (I_LRU_ISOLATING | I_FREEING | I_WILL_FREE));
+	WARN_ON(inode->i_state & I_LRU_ISOLATING);
 	inode->i_state |= I_LRU_ISOLATING;
 }
 
-- 
2.49.0

