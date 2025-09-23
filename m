Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0866321289
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758624447; cv=none; b=NzW3ADStKTsnMKDI8fVLLJKg1s1FhZ91mSFH5YQDeD3I5g57kT1PM8vVJ0kGpn2pmqe+YMKxEuvm9FPxJHbJcxtgNzAoIzHylggHPdLbXnixHoccSfBJjA3xMzMT5BLEKC6A0PxrK3THL9AEoTL0P3wzw4MTJGSrXRl8kgeGYms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758624447; c=relaxed/simple;
	bh=l2+XRRMMlUv38cxkDkgsNP7PrYQqTHAOPnKjsX3NKpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cvz7viiStrdaThBpo8r0a8Wh+Md5gN9fH6/C7SRlnfLgbo9gETINpOtnBognIO3wE+WnfHrKvKMGmJsdvGOsWGWjgUOr4wdS9HymincTfueXDbPvDF40VEuEw5qnbCeFW1jTvyrhz34s5nW3DUhZDSiPJbJMS8uRjYnQMhhgDsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMiDhOih; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMiDhOih"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e23a6617dso2574165e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 03:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758624444; x=1759229244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wY/sdmBMIe7/evMOyoyNDBqGuIEYNCftZNVDhHEUu68=;
        b=FMiDhOiher0WYGTvi9mlL0UHvwCKsGGmjWkge3xsWfv/uDzLFpbP40NiXIRMUUP968
         xwfEckY67Oh/E1gCkApvZxxe7wm6INY2+PfRri4sRHZaVJf4VH4MFohjjbV1yLhbrQxa
         lCOhz4kRZejjx8sWCcm9SeekQG7H+5pEgj/QwQxYDKdtPvmq51GHckIGEYdxBvp+43N4
         TQXV12quwS3Y2e3xL1iAppawPO1vf2BbQCcO3YiNEbW9LzcTsFrws8GNCQQXtkGQxfNH
         wy+seOz/vpZ2cdR+r84jaFF8A3IuG+Id/1OnsEzN5y25ZVX/k6owrKNrmSUGyBAYdfLY
         zsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758624444; x=1759229244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wY/sdmBMIe7/evMOyoyNDBqGuIEYNCftZNVDhHEUu68=;
        b=O57yNE9EuBBJEnsAa4Q1fE6cJfqy+/ZxtGXpDrWQ9SMrx84NP+g+dJE7yo1ELE8v59
         ZTrwhIUgsRSgyZCnMOD9UkacVrvCLnGkq/i+lEvakBTilGZQtScs4qJ3qNhScA4mf51v
         cT77WJ8ZDd+bPhehRZlxD5VNgCBU+aI8cYgW0OEn3QjprFTar+d7WQUT0QoMn7u55VCJ
         Qzx3vpZWCrnt0kURAXywc+kLUUQuS5lVakvUkZ3YL2uczjkiBlIl2QvKdMxIPQ/Fv2+O
         IyLr9fDChxiwj+GZLeifmOYDPo/+B2P/yIfs7qv1dDWosd0pGBZGAcO7BKsZiJqU3xux
         fl4g==
X-Forwarded-Encrypted: i=1; AJvYcCWTO4UsYqU8IejSkwdOfUhfileOvB8jMc41u19gwnUX4FBU1Q1cT9ob10Erwpm21C6ktobx1OgEKvg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt05f/jpXGthq6zukNyJwq1p1ap2aXkPp+p+/LkP/SMvqkV1tb
	l8m2X8kvr6t8N4xlRCMtlMx3Gs/9rWGQtXyMP5EZnxropjZPyTGAkpAd
X-Gm-Gg: ASbGncvB3rJBznkXz0geFTEBUyWnnHBEZdxCXV/gOkh0m3JZz2k9rt+ce5DJrqPLkA2
	VFM53wkY+D5wrZbBwwzBmR0g54wl9FNAG4e2zGZk5AKNzVEfNsNC4Mv1aYAcj7tMdqqD/QhKIkY
	zZLfVFsvEuU4O9S8JRIqBC8e6Za2KE0UXC0RV2orpXJVHSm4v0eztQfdO6DFRacInoR8yYNWvwQ
	+1YxSm8lJEC0aw+4IDbO4C/Y/tx/NtjBTSMR1Sbr6rQm5+KaVctg5bTmgtZcXgLYU34yKpFzEA7
	GdMqOGEXZNhkkeOehX4osCDduF0k2geuejmqWGzGWGSzII0vV1yPSUoKKxtrr8YgdIsPaSnDESU
	ioWu/KOkGagEpT9TvbssFY3qxQ+bs2IEAJODVYz8syv0XSQEIdIQf6K1iehodgl+kiDMtlzR0hf
	drw+21
X-Google-Smtp-Source: AGHT+IFG/viu/Q5UoxWFmn6MCDA3PwXtIt4JmmoJtRIj8itygK9JQbD92sFVJjS9mxr6/B7iPXdZCA==
X-Received: by 2002:a05:600c:c8a:b0:46e:978:e231 with SMTP id 5b1f17b1804b1-46e1e0aec9bmr23755185e9.17.1758624443810;
        Tue, 23 Sep 2025 03:47:23 -0700 (PDT)
Received: from f.. (cst-prg-21-74.cust.vodafone.cz. [46.135.21.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e23adce1bsm9710525e9.24.2025.09.23.03.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 03:47:23 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v6 1/4] fs: provide accessors for ->i_state
Date: Tue, 23 Sep 2025 12:47:07 +0200
Message-ID: <20250923104710.2973493-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923104710.2973493-1-mjguzik@gmail.com>
References: <20250923104710.2973493-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Open-coded accesses prevent asserting they are done correctly. One
obvious aspect is locking, but significantly more can checked. For
example it can be detected when the code is clearing flags which are
already missing, or is setting flags when it is illegal (e.g., I_FREEING
when ->i_count > 0).

Given the late stage of the release cycle this patchset only aims to
hide access, it does not provide any of the checks.

Consumers can be trivially converted. Suppose flags I_A and I_B are to
be handled, then:

state = inode->i_state  	=> state = inode_state_read(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_assign(inode, I_A | I_B)

Note open-coded access compiles just fine until the last patch in the
series.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c4fd010cf5bf..06bece8d1f18 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -756,7 +756,7 @@ enum inode_state_bits {
 	/* reserved wait address bit 3 */
 };
 
-enum inode_state_flags_t {
+enum inode_state_flags_enum {
 	I_NEW			= (1U << __I_NEW),
 	I_SYNC			= (1U << __I_SYNC),
 	I_LRU_ISOLATING         = (1U << __I_LRU_ISOLATING),
@@ -840,7 +840,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_t	i_state;
+	enum inode_state_flags_enum i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -899,6 +899,35 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 } __randomize_layout;
 
+/*
+ * i_state handling
+ *
+ * We hide all of it behind helpers so that we can validate consumers.
+ */
+static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
+{
+	return READ_ONCE(inode->i_state);
+}
+
+static inline void inode_state_set(struct inode *inode,
+				   enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state | flags);
+}
+
+static inline void inode_state_clear(struct inode *inode,
+				     enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state & ~flags);
+
+}
+
+static inline void inode_state_assign(struct inode *inode,
+				      enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, flags);
+}
+
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
 {
 	VFS_WARN_ON_INODE(strlen(link) != linklen, inode);
-- 
2.43.0

