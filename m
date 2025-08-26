Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6336835E4E8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222882; cv=none; b=eBas/eFOijYYX4+8/JkNpTvGtyZMvwbwbZKZCZg86e1YXkK3cxYpmHpFKv4htHsJRSqIIqgJGtCNTdUnehSINE4QGA8Z9h44DGUvsQHtsw7H4LkrLkOaDcaNZYKIcV1L8Ze66YwIppbFM+YOxD2JvL3TtkoM1yGRFkL64GHXa9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222882; c=relaxed/simple;
	bh=9h6PPznuSE5nPJ74VSVyjjLvORGODq5PPIqVHYaiKuw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pn2cHXmoC4tTfW5Zk8JRDIHgWwwYiZ1WutvPscEz5tmi4PD1T2UhkXg3K/G3WKsrdB28HmftXVqr5V2t30QdVhW7hgCd0hIiBJeBO4vXv+8CMRg+H817yJYyaeC3aL108uTwtLueqmhrohBfAHxR10QzaYR4/AmTJdgd8I8EgJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=AjnpHHL1; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="AjnpHHL1"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d605a70bdso37816987b3.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222879; x=1756827679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbLQoR7hnQAMVl5aGLYTpEQarM8sb2EoAq+ZL5IeLT4=;
        b=AjnpHHL1enuJhFyTHe5bVpEY4e+nbhowgl8US8whiIL2vqfQkOmQ+mh8kNpkXDrv8o
         rpexrT8FbR4WsGp3PXfS46Z9RgG3qXJ+ANuaTGA18pBS1FdrFUEF+MaKo+JP6rOn/jnq
         OIRL4e2vtfTIBqsYG/QqQB3sN/NV8CBAhShtwiGvlQ13Xz1gOjMEKEx5bZB4LJ7/2+Fo
         GYqnOs1vJOw5V2TxHRN7skQFEpPN8KMBRtayCtsI2mf1mdNkGV2BE2rNme9tGFDOtq/A
         dBskaSGuwz6p+rC4g5eZE9J5p8GRbAlAfpq0CCAbUepksUVNDmiRNtmtEEPZs8NLJIbv
         EtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222879; x=1756827679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fbLQoR7hnQAMVl5aGLYTpEQarM8sb2EoAq+ZL5IeLT4=;
        b=wnJXjeSSGNbSnIoJh1KWed75M35sOqGStAfVUV1jSOLKkEX0GGecKmifKS6Eewsah6
         HqfMcow9Z/VvFiVg5fo2MVuRddZs8SsvcUcZXzsUTTw7DzCuVjqR1T7sLx0ZmRg5Erok
         S8iWbiKvI/tGvpuNK7dwwcaD7Vf9f1kzjZv+APmwgqWKnG0N7hO688SOgYs9ahxFzke+
         OcxTG3KcRZC46+X9H/O3dx0oYbvUvr1d4I+NoR4HN2QShfG6RpeAOYkQFMnKKS9EoUvk
         Q8UYENgpPiygEX2RcAPt6AyhguHi4kvrozPjXwmy60J4jnVkWAY98WyQUc4ZeELRPZ+0
         7skw==
X-Forwarded-Encrypted: i=1; AJvYcCWt5bLpYpPtOT6XeeKra4FcqJEgDWFEzIlwI/kdgAHBJfRlA1MQb9oEuo5qGZcOqgnDjle1OY2m7Os=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFM+IONatCgIF1azSAn03vX1iytCm4c38OjeALoRJOIpoIOMAi
	GDmwAMGOSfvTcoXiNgl+ud0wKdmhLIQayeH82nUH4fLxE63Fy1N/l6CnNno+LA9uzRs=
X-Gm-Gg: ASbGncsogY+egSrkNJ5mNp1rbmt3BD39LynJr34DOLZY6OGk6lT7nQQbTILIUgdj3yU
	5dlq5FuWNVuJdHSbGMuCLGoC9oEuF5Jmq7ID6uNUzpbJykE2bghenGDZOZ6Bgr1Q6kRBgLXPZ8V
	XvjCh+TOkKqe1W4wZ6/24vYCcpnW/B9EY3J4Hs7PolHXbtUBK5IPrOvmkZDLKpZefSDru4TYdJs
	mQ9Ar6AcXIild14NlD/84fOG3uSc7rut6uL5Y8SwhEauZi7m0XjD5sYuj7v3XVAQpFuCfAZEc9k
	tsNJvy2MWTTirb2Lqc1ZkCNIwGZQJ50h+j2SJOaiyfkMOE07RYzruySTNPWRdInAn8chw32TOwh
	VfcPWk7faYkgtrJrTYOLuemxFVQcu6osq3T6wAtDzrOrRtzXeu6cbDe5oRfs=
X-Google-Smtp-Source: AGHT+IFVd/Dppsnb6E1/+4Q9E2BDcwXG8IrdClOe5QP1Pciq2pnbXmjT7B3KKQidZ+9xNPYLXeeOlg==
X-Received: by 2002:a05:690c:311:b0:71f:9a36:d33c with SMTP id 00721157ae682-71fdc41251amr159706727b3.46.1756222879135;
        Tue, 26 Aug 2025 08:41:19 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96e9fa5d42sm189948276.18.2025.08.26.08.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:18 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 21/54] fs: make evict_inodes add to the dispose list under the i_lock
Date: Tue, 26 Aug 2025 11:39:21 -0400
Message-ID: <c500d99c66c4b09a212005fe75465745d5c78f3d.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the future when we only serialize the freeing of the inode on the
reference count we could potentially be relying on ->i_lru to be
consistent, which means we need it to be consistent under the ->i_lock.
Move the list_add in evict_inodes() to under the ->i_lock to prevent
potential races where we think the inode isn't on a list but is going to
be added to the private dispose list.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index d1668f7fb73e..1992db5cd70a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -975,8 +975,8 @@ void evict_inodes(struct super_block *sb)
 
 		__iget(inode);
 		inode_lru_list_del(inode);
-		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * We can have a ton of inodes to evict at unmount time given
-- 
2.49.0

