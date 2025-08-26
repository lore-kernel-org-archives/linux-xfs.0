Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D52341651
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222888; cv=none; b=T2LJe6uGL0BnnhBGsQttrejW2P0A9WftqplAvpXDuq9MX36zEBJbbahEayU9lG/oJXXkanqgvPssArT5dYZreKKCKCyQkEAajoTpPP43lQlcOyl0uXA1fURQDsYTbo3KqDUgU3xbsJrM3BwCMQ9Oo5imQXLvQZi0/Bs5uoXQQvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222888; c=relaxed/simple;
	bh=n2PMRuPR6JYZVUW2/KJe5vnseijKbMo3WzgrzTCJifo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iL4HQ7QKA/K6bnVPOAxP7cyD4cT3KnQzZSLp6ugjJuzkZAFS7P1T5M0CL/5sJ4fS/4o/FHZJ7uG3aV3Bw+qnPmVs3PHaWlbzNnD3zxqscoqyGQTmU6FlZIu4B0OtexO+ZBZ4pbBmh6RThRICRVBtRhBWhxs1rF9jvimlLng8eXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=E7v9DGwg; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="E7v9DGwg"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d60504db9so42627097b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222885; x=1756827685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VlLhOSIwCH5Ivh3dHEMbxIwp8egJF9NMtkZv3ZbCr3U=;
        b=E7v9DGwgsmKY7t1jhTV4pIfLjhzC5WYtx+XzOZFLGfh1YpY05yFYpOIIUX9D055s4j
         225zoSyf7juEHEWrhLt42HsvDWo5m0OQ8iCDW6GpILZdfFzbCgLvXGaJLgBuh3WzR1oG
         e+2svNTsgeUTWbdzzh5IJXQ5TZi/weAOn++0qe+Pmwlvv0+Knx+MvLhrqtPUd/m6EEzO
         awxa3xEX1qpVaGCAFf26fC8Zp3owRAvGFgzesZpK2P8aEAfXY2N3G3lnRcXw4D7/b8kS
         K+KJFXkUcq4jXbV42Xa4WZ59sTk25VaXqrf3rJ7U3oXTCWPoWKkyeOZR/1NkyB9/OPEc
         PCuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222885; x=1756827685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VlLhOSIwCH5Ivh3dHEMbxIwp8egJF9NMtkZv3ZbCr3U=;
        b=g57aaloxBN3OCBrLS9+cMiRYmZP/rY2dJ61MyapL2PzAk3hSBx4LAzpj+5y2i2Q9Ed
         uQGBB87jXDSifc/a11Z5wp6YPDlBR+fBxgcghimhuQhzSK8b2IuFUMNLejDDcFGmU16v
         oetcssKdiwwqQ/E59kz62/i2IckfmQnkkFCB7QDlMcOUIgCvpz3WzzjqcosPiT7rNurq
         4OYe7WpKOTeoIYMFd7CQX94nt7Rii0fsm7k9bI1HNhb1tD9h6QPbgJpxtqaq1put/g6I
         QUfA0n5KYIQ+c4QZzqFpg3o5lyVGa+mq9KFTduDKFeVwI17GNe4SgrScjIIUEeIeTYFe
         nz8g==
X-Forwarded-Encrypted: i=1; AJvYcCUZFaKY2o+MGQ8Zlz5vmtrkknvBSWQ3JeyARFdfVyKZimDilYElShsYdJPwP3Fsj3b2Lq34FhjHkyg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyufT9c8orYchz+CT7wAhplPbc4z2R5+a2rBA6A0+p+g9K0Q1C2
	YArs59THXHFLygUtBf5ZcVdMnq3MS9ZLi+ZXUdDshu4NcOFGTTy3SJRvBB/7iAeDG/I=
X-Gm-Gg: ASbGnctfuZpQTbCyATvsolVUwWpyfedxaoUyl97+Qf2sb1XrVmNddn/O0IxViUR8znd
	uJSypIBqRmiChNKMKGJV82Z0L1Wi6RPZnWykMkbgb3cCf/Nmb5zJmNVe9rjiKPxfSTHR4Rr1qKt
	49B+yQjhouTOdroaLQluf3S3HwQEZyZtP6l9JfRHm4u2n3GIuxJU4+Sr+nb+UdLI6wW7LfQegfG
	k44Lenw0tM2cZ9DgP46WLSYJnsA2xg4JBI3DgCe+uSK/Pe8HlFmNkFEx1SM8WOL/mN5Fp/r71Ku
	lji3cdIllBXdlS3K8y+gRyAsJlrfs1Vb+qbd6A6j8TFKCxChXzIcEcSx+tbrJ4FCX8+o1O11C6Q
	VkA2KeCukRhZjYUzCuu6x2o/Ssj327f3/sg5rXosKUzvxrM4+vc3Ey8CJAFW8dhBQfEBnjw==
X-Google-Smtp-Source: AGHT+IGWS2z+DTg1fDukCryUmw/K/ldjfo8vScGliNb0JD4SGdAHIMczu/WUBMkIGgEqVpAF9+oHHA==
X-Received: by 2002:a05:690c:311:b0:71f:9a36:d33c with SMTP id 00721157ae682-71fdc41251amr159709517b3.46.1756222884962;
        Tue, 26 Aug 2025 08:41:24 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18add4fsm25000297b3.51.2025.08.26.08.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:24 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 25/54] fs: update find_inode_*rcu to check the i_count count
Date: Tue, 26 Aug 2025 11:39:25 -0400
Message-ID: <d612f83abe1ff518ee85319cb593c0ac4f266cb2.1756222465.git.josef@toxicpanda.com>
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

These two helpers are always used under the RCU and don't appear to mind
if the inode state changes in between time of check and time of use.
Update them to use the i_count refcount instead of I_WILL_FREE or
I_FREEING.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4ed2e8ff5334..8ae9ed9605ef 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1823,7 +1823,7 @@ struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
 
 	hlist_for_each_entry_rcu(inode, head, i_hash) {
 		if (inode->i_sb == sb &&
-		    !(READ_ONCE(inode->i_state) & (I_FREEING | I_WILL_FREE)) &&
+		    icount_read(inode) > 0 &&
 		    test(inode, data))
 			return inode;
 	}
@@ -1862,8 +1862,8 @@ struct inode *find_inode_by_ino_rcu(struct super_block *sb,
 	hlist_for_each_entry_rcu(inode, head, i_hash) {
 		if (inode->i_ino == ino &&
 		    inode->i_sb == sb &&
-		    !(READ_ONCE(inode->i_state) & (I_FREEING | I_WILL_FREE)))
-		    return inode;
+		    icount_read(inode) > 0)
+			return inode;
 	}
 	return NULL;
 }
-- 
2.49.0

