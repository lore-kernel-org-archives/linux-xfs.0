Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59AD313537
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222871; cv=none; b=e/g4IJ9BPn03ciUmrNQqpK3UvbD0LZU7C8tKIfXpjVR2D1+wfwD6yC5RQawy3J9E1X8kBS+HBmPBxVjv16nAxtPkTl5XkX1v8wwUHYO2jYhNbRXsgv4IIDBx5tdH7y88Qm7JH0LjOnzsxfmlGTvmFfw0lxtfgtC1QDIUvYX+7eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222871; c=relaxed/simple;
	bh=ai2oUzPAcRJzj4bWGdjdsYHnumyQaMH/ub0qR04Gbgw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzaVVePTiKpYGcIigl4f7baBZP7VueYENcN2w3QguHoKEGSKi7rauWZOQsdu91C3996+OzLGGLgRam8n4bLvbD86y5C+cLBaR5u75FINH3ro0y2RNoJa0Ejl+VvmK1YqznNhW5M7C4n4J46KKNa3IsQYP7mrw+ZfBOVbDVlmZ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=oyYvhPk2; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="oyYvhPk2"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d5fe46572so17387b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222866; x=1756827666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=opvoMbW1BQLT38gew8BsXyJcIC3tejqT6ZRE2IoYWVw=;
        b=oyYvhPk2YaNC1odUj7rgCZKb5iynD0eaF/vlt+SymQ1CUWOk2WSNg4VaLryjGYWRCN
         VayktaAMWZ8ajM4yZC9tp/sHB1J7eHISkQaeliGR6LYDdEOo4wkKegKUuQHGetxkK+97
         Ej/wo1xo8R5XfpzPThcqcms3xUtsUt3fxyYFY5vPFlg9r2OdkdjCyTl+m6evGvEpiRAR
         U8i+S9JhHWZsTvVoQubBlSPANZxpPy/z+i90o2vx4vXTjuBqG8SSZQCOKnQwk3qLLuBx
         cH3ifIlaTIv2V0MSzJ5sM4MynwjVcv3o2j8g1jRD/ibS8kTISWTLiiQ9rgTtEpnfz8gE
         7HjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222866; x=1756827666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=opvoMbW1BQLT38gew8BsXyJcIC3tejqT6ZRE2IoYWVw=;
        b=p5HHiODFRdDntW70R2kZUoqZYZ5fuefJgXf64BqzYWMw2NXb1VDl836BZUEzISsfHH
         9TJnSEC1DDQDal6f4BSAP1eC+a2ra75M8/EN6kMANnFneFPbeQXUJ7hSir2R5qG9xPWh
         GgobzOwXxL8scTWrgonibab9/n0qg9u0PwIhHElZxFE/DR8XEHxqW2VwQ9jQtG607lT7
         2Hzey9bQXqkmJgmJXX+/r0+9dXplZ9CKGlXve3H3oCKTLXIRIz55ltPXOEBVoYiXN/27
         fkRKrVf60wthw/hVhwNIYwcUoCWm9lUcU9s5e35BUZIP6kRJ6pZPnfsqhiraKeyyK7Yt
         n5Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXlo7bzuZBRQucNLXbj8DEhgfaofq0jtq+mhvSW4PVn8YjHUP+cGVMTWOecpZqF+yM688eiv4TF5bY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7IHkn7E/kkYxdmGNsXkImbOQ0u8sR1H3gZvFQ+kx7Ko3jLfNU
	d5W5lxo9OpYFrfdG4zqHFVG6k2TZ9OirHoHQ1rorf28vfQ1sL7en8JyPKShmk6bqIjM3sjsRM3b
	6zrpa
X-Gm-Gg: ASbGnctWaLkv5GNW6KkSP1AGfYqRtR8vUtorU9KsbqaWWgNz7J1Gw2SoNxKeGg4zZfK
	H4HyI6IQ5ClGqpR4aHI6lkrSjmHufvMsGZRlrTQlnT3B2R1aV25JxOv74HYqSHc3NFSNOOUlfSY
	ifDmukYCCvt4j+mE7EAkHHeD6LA5WZkYS/U83llpVDe3aH64xnbdtVyYiEmlz5bIecb3dtmFrLn
	rfWXAMe1+Safu4QrbsmkpSPHN9Gk/FyE54AIGoKHuxDCmchO5UvdNNKZgd0hovJ4zUebecJ4YwW
	xYi/lg8MmHr5xqXO0Z7EQJlVd2E8b9Uc1miMerQDEX4dwKk+7Ki/CaPRzOMTVfRyOVOIf05fsYZ
	azlMb16NKcewfo1+1hgL10w1dRiAg0l6xzAhFs+IqfTFZPeezb3U7zPU+1Lk=
X-Google-Smtp-Source: AGHT+IG4drM57yr5jMHRmPhNbnuKvEUQzsF2UJZDEJ+LiNoGRh2wEepMQoCloxW+Hw7+pj8HTKplcA==
X-Received: by 2002:a05:690c:2021:b0:720:58e:fadc with SMTP id 00721157ae682-72132cda591mr16089637b3.4.1756222865991;
        Tue, 26 Aug 2025 08:41:05 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-721243ea829sm7815797b3.68.2025.08.26.08.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:05 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 12/54] fs: stop accessing ->i_count directly in f2fs and gfs2
Date: Tue, 26 Aug 2025 11:39:12 -0400
Message-ID: <2bd8123db2547032fdc5bf80748c7d9d02336443.1756222465.git.josef@toxicpanda.com>
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

Instead of accessing ->i_count directly in these file systems, use the
appropriate __iget and iput helpers.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/f2fs/super.c      | 4 ++--
 fs/gfs2/ops_fstype.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1db024b20e29..2045642cfe3b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1750,7 +1750,7 @@ static int f2fs_drop_inode(struct inode *inode)
 	if ((!inode_unhashed(inode) && inode->i_state & I_SYNC)) {
 		if (!inode->i_nlink && !is_bad_inode(inode)) {
 			/* to avoid evict_inode call simultaneously */
-			atomic_inc(&inode->i_count);
+			__iget(inode);
 			spin_unlock(&inode->i_lock);
 
 			/* should remain fi->extent_tree for writepage */
@@ -1769,7 +1769,7 @@ static int f2fs_drop_inode(struct inode *inode)
 			sb_end_intwrite(inode->i_sb);
 
 			spin_lock(&inode->i_lock);
-			atomic_dec(&inode->i_count);
+			iput(inode);
 		}
 		trace_f2fs_drop_inode(inode, 0);
 		return 0;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index efe99b732551..c770006f8889 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1754,7 +1754,7 @@ static void gfs2_evict_inodes(struct super_block *sb)
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		atomic_inc(&inode->i_count);
+		__iget(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inode_list_lock);
 
-- 
2.49.0

