Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAF43728AC
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807658; cv=none; b=QQMylRqd70BK+Llg7xbVQI1hpAkjUwe0TqKdWLAiFpAWqtFSV712s2XKN0vibI8AX5bW19eOMHHOnCECnuMMP3eh4QJVK4YZgJVIJ5Uor3FeFum7FStXtxS4tVo/w4GJqwVfOaMRtCwA4tUNtRmObDaP5OD/dcSjUsIcIjsjii8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807658; c=relaxed/simple;
	bh=pZWAfjeKEyxWVI1i/b/M2R87xzgDWCxe1Yk13Yj6LPk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Luu9qzc7ekLhENOjuQWesfeer8bypg6mFJZVXhf1O5TidQzSicdL5BUyHUfY40A2WW07zmxU2V8GkVbVYVZAoVS5+GsMgsbeXR16s+RU1eAV8BIJr9xZ0MSLpf88Fp7mu1dcuTEMAdf2NVo7VUPfk8t0RNaK7zW2gjh9Sn/rwXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=anu4mt8g; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="anu4mt8g"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e95026b33eeso1473488276.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807656; x=1756412456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s8OxZ8arGUc2qFIUcpcCgS+zVxBChijINy+DyEvJNls=;
        b=anu4mt8g4EDrDHPwRfIeh+t/OfTiE6iTKHYbAl1ufsbOmDrHXxNeZyZPlUopTl18Jc
         zoT+amOB+TiovX4lcBQSI4NcmDavG+hMR9zDDcB03Zh9XMn/lOMM/BIVNiWiSSVBvaEo
         nV0kfxrI1DIrDqxfKqYFFkIc20yoHJBu4CrrCzS0lTH6+DrRCgGeBD8PQQ5hSfTVwebE
         SSjAiQzrYlN677ZgEF/F5YLofuJPhgl0P825tvVuKqNs9ay+prdXy2TmXKOnwG+Jrtgr
         hbVdnYjBgU7Nc1Oo8i0cmFmLk49/rV22w2s1UDJGagx5G9m0x9x5I32/sfvBmRqFvhKp
         r+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807656; x=1756412456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s8OxZ8arGUc2qFIUcpcCgS+zVxBChijINy+DyEvJNls=;
        b=wsamyWggZ1FSV9aVk+n5IhS58shYAEGYjXpE4QPLtPE2drFY3EQQ9FKBUt3FgHICRg
         +zQQc3+IKHh+gROt9UIGBWXla8Je0Aw1jA+VfCoSuArLIQWPoZribUbjRpYR+q4LRQU4
         FHE0YPF4sdtDMtJAiiGYXqYw2FtKMaWnoDrEHHo8jscwCEY9e2KbnfXOrMgrlAAcxPeJ
         zKL1Q13mdd9NyIrc7sEZFTSvgI9t8EJF3jItQe9r6wJXt6/ZbDWLSdgGSNvCkPVGkFKf
         1AF8qGHrcE0O+xt5icJF94yhp5q5HS/ZcTrJoBnxNTK/Y1kXjDXAGJ5aOF9MijWyw/LZ
         5w2w==
X-Forwarded-Encrypted: i=1; AJvYcCW3+ee7msa2Tt7qEOWpJRWmfWJfjvm5r8nUJY7edRseBmV+tmb4ymwNzJW6iHk4QeRw1yI4ATljHAA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOQYIerSG7YnqHoyHQw8CSDLEUZZ6RU8b5Wr6B8qLRpH5Be75n
	rss6hPMHN7aNDQCVfoSxeQM8lFovs72RenLessvPVp6NKTu0xVcC/1x7V6En+XrXaxk=
X-Gm-Gg: ASbGncvUt9tI/3ek+iiE7RWIep6yerZqp13uh5SppVKkUclQV0UEYWG05w6D2IEwbbC
	6W+Cif0c3Vubo/vMWP2ajK4SciQ2FqNe+CEfS5b7hjpBlLcjoHx2pgVspYqjw6IX50YSeawOX8G
	fVi7Bq4IL75G2kPoDkATugEDKceNtyEJwthhaHrekff6ryqn/7g9JjR0bxwvl8901F492KK2sHH
	xzUiFqpDmG1HGKaDjLw/qqE3b6x7iuTYfFZ2eHWDJPQfY2lDYZWnYK8Gon7MOVqo6zUkN6BaBeO
	84QpQR+Jn8q0FPrK98aSorzKgmAFg2akK/9eLUhTrS3QNvtf2+/l9agBaij+DNIApfzYdjkzEB9
	HBer+chz1YhgmbNid00l+ddUmPdLvWRYWkrBFklhhSY0L9DLy3p98RJ+6Lg1VYVawT699dBro8e
	WnMY0o
X-Google-Smtp-Source: AGHT+IHKdD7c0NoLaVeNfnIQ5Yw7Ue8ZdBZnrvI+mZUb/Urk+RN0cKprW6ynBsmjXYuBK0VVixEYQA==
X-Received: by 2002:a05:6902:102e:b0:e93:4952:e2bb with SMTP id 3f1490d57ef6-e951cdc81a7mr498133276.1.1755807656238;
        Thu, 21 Aug 2025 13:20:56 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e94f1150b34sm2414635276.4.2025.08.21.13.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:55 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 27/50] fs: use inode_tryget in evict_inodes
Date: Thu, 21 Aug 2025 16:18:38 -0400
Message-ID: <7564463eb7f0cb60a84b99f732118774d2ddacaa.1755806649.git.josef@toxicpanda.com>
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

Instead of checking I_WILL_FREE|I_FREEING we can simply use
inode_tryget() to determine if we have a live inode that can be evicted.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index a14b3a54c4b5..4e1eeb0c3889 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -983,12 +983,16 @@ void evict_inodes(struct super_block *sb)
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+		if (inode->i_state & I_NEW) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+
+		if (!inode_tryget(inode)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 
-		__iget(inode);
 		inode_lru_list_del(inode);
 		list_add(&inode->i_lru, &dispose);
 		spin_unlock(&inode->i_lock);
-- 
2.49.0

