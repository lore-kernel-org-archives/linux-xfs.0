Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBAF303CA4
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222876; cv=none; b=Q7/M/zSh+yg01SP8fmwHw7FJXGrzovOtXYDipV4ALqXsKGMPBAbtcFKQmeLgMZ1IoP2AvC7kp4V+B3MQxZDb1G5e6UlE2lrPlETD1gA2ziHgqXpczpDFVpX+0JrhT4wIK8ay1qL6bBtAo2UD/K3xoYDItJZz/qUvl/lZ1DraCB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222876; c=relaxed/simple;
	bh=VwsDvHLoXX1uKTN5GqLXpMQ6MRvXRWQZwSKzj05otD0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbiGQyx7i2y3P4wPJVFHF/71xhtOEExJL77/FLT6nv1m6AY9WESuF8KIpOFBGCyEp9Ry10BSeDnLfhIzgC3hwshI8FbEl63dzqagN+75sfxg1/1TlLDa/yiHF2EzdBX0LW1K3wN5yaMSnjnuLpOvu1EM94sir7F3UIhTlzp0hSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=UZ2Ilx5X; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="UZ2Ilx5X"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d71bcab6fso43150587b3.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222872; x=1756827672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q2LHx31lTtBHtYaRln9gOaHDdksI8aSH74+SGcGPP5E=;
        b=UZ2Ilx5XYrI6h7DZdgdXxsM7wqEqa9/YxK3DSxpz3AWYFZatt9JwfV0Ei/YIUE8UWx
         QYb9beu+HB59eu15RwEarmcNsr6P2wZvFuUJ3D9SFAmiefPV7x3nmChdd6+okD/Nys7a
         7wfGfOXUPYTuHuNRcDFJsBEIysA/GmA/E+42PRwG/j9NgaE262btjHzNpzgTDNbIUMly
         2apjbW/dCF9+qWSHgUIY6mXZte7xH0uRcwB8nhyPw9P7dyizZ5+zn4ufAhh9kQwNFbQ7
         Ve+zXsJKfPjdHZleXzMv6cU0P3WOvXlY9sQk9zdFgZwBrl0qPn78T74YV4YO+joJhhz4
         5qFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222872; x=1756827672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q2LHx31lTtBHtYaRln9gOaHDdksI8aSH74+SGcGPP5E=;
        b=VIKTNnMo/uR09hLu7n8hWiXWokgy7tqiwYT4D4Dpt7FLK4Wcx2/uXaIJnLAj7x0cpz
         WOFHiDBWIgdimHOE8Yu2YO4y7ILAk2mhUIS+SxB5CyY6DJYL0BqBN4uYwRU8J1C0W6ct
         Azwb5ioIho+azH9IkCeOJly0CLEXZ0udB8/WLOgMxUT/5n6e2USgvbDMNKRlIcxOsY71
         0dinwSxO1t+gQQz0CQSLF25IS5I/XF8pB0iK0XxHLwnM6UTSWELmL+WSRL/iJBJd5Crb
         ZDo6LK5bU7SGwjtuL2F8TlV/Yu0UxwgpDUgcFxlarEYt5FSV5AwUHxSdpjVnzmpecq9d
         s0Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVgtIf33Iu6vnIE8Sf9OM2wWw+RSm5IYbV2TTuidVMUXabYpXhVCI1fuAYCFri3f06QxSI++T9DYEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIt76B6dEztShcCsi76QIy42VTYEGnOyyjT68DkIOQnHri3t9W
	Y2l5NZZBGWqOSpj6wGm0z3uscM7yiNVs8mkBsUttyARgd140hoDkQGXhfQIX+ZXIkMw=
X-Gm-Gg: ASbGncsHwDBT7U6IK1LpYvDl1h5c9u1ehtf7tNuY2lVXtjnXQ3tj4FcsZ9R/kLvi4x+
	bRDLj2+W4mdQaJ8vBMBLG8KfHHgINCiC+N+2yPsID0YpaEhMm+bSRGLjjNvGkXQbisepA/t/iQF
	xyQfOVflRU+fPF7+l306oOAPnIMsZUv6qSleP/lTVKOXZBvDpw7GXImprRn1J1LcVMYic5IerAO
	VAT/QQDNlFRO86LhzwJh9Ub0yQrySH+QiUWu4mz992q7/8kP1/I1LuYBuOFDWKuFLQTFrNBtoZ+
	zSkD2qPK4p3+6z+oAO7W7G67IbLavME4FQTTH5qG5/SnIShVp8r+pul3ZTmrXhN5btmMntUgaHb
	nEAwsjCaExnpVWkBs3l6Kymlago/F0OqSXgXsdfKv3yPoDXSQHwb/1l+mn5A=
X-Google-Smtp-Source: AGHT+IGT/XuD8mmhvooE8E8UkA6256XoF7vusI/+JGpOkFM0b1RNjbEYVhkocKaciv/nEIMzWHJRFQ==
X-Received: by 2002:a05:690c:7684:b0:721:10a3:65ae with SMTP id 00721157ae682-72110a37a2bmr69440357b3.11.1756222871810;
        Tue, 26 Aug 2025 08:41:11 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff188b0f1sm25303157b3.42.2025.08.26.08.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:11 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 16/54] fs: delete the inode from the LRU list on lookup
Date: Tue, 26 Aug 2025 11:39:16 -0400
Message-ID: <646d132baae6e5633064645e677dada101681850.1756222465.git.josef@toxicpanda.com>
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

When we move to holding a full reference on the inode when it is on an
LRU list we need to have a mechanism to re-run the LRU add logic. The
use case for this is btrfs's snapshot delete, we will lookup all the
inodes and try to drop them, but if they're on the LRU we will not call
->drop_inode() because their refcount will be elevated, so we won't know
that we need to drop the inode.

Fix this by simply removing the inode from it's respective LRU list when
we grab a reference to it in a way that we have active users.  This will
ensure that the logic to add the inode to the LRU or drop the inode will
be run on the final iput from the user.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 4d39f260901f..399598e90693 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1146,6 +1146,7 @@ static struct inode *find_inode(struct super_block *sb,
 			return ERR_PTR(-ESTALE);
 		}
 		__iget(inode);
+		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
 		return inode;
@@ -1187,6 +1188,7 @@ static struct inode *find_inode_fast(struct super_block *sb,
 			return ERR_PTR(-ESTALE);
 		}
 		__iget(inode);
+		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
 		return inode;
@@ -1653,6 +1655,7 @@ struct inode *igrab(struct inode *inode)
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_state & (I_FREEING|I_WILL_FREE))) {
 		__iget(inode);
+		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 	} else {
 		spin_unlock(&inode->i_lock);
-- 
2.49.0

