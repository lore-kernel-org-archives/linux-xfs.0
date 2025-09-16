Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CC7321F3F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031189; cv=none; b=RBCx0XQgLMkYvzCKWyHxwgCnzZxv06kLK6PS4VQh1aUmA5jcHI8zPZ0Gc+rT8yoYuk7WXNFl6cPFvPOeeJUl7lUj6dHtFfvuM3Q9IWYRwhVunJi4MbQ0vDQTCCg6biCHSqPM2uQncEbZ4tGSa3iD4+DmtZurtCxdbFOVYdpsr/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031189; c=relaxed/simple;
	bh=zBN9BldLXuQYafbepgbsRKYJCNw2ZdSE8TIiThiLfW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iv8c2CaJH0Ybc0iOKD1Phu/TBHcxDg8CqMLXSi84apI/IRGxuhfd6G6BIGSfCZDHdw1J+h/xNIf0C6eBoM1h1OEZCv7L3tjr3Yjkx9fnV9Xxo9/m5/5d7dYFHyGRFrSLti5PX7NmT9I1EVvZ7oYKFg5hP2PgaRud9q+LUC4F1Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BLBo2LB5; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BLBo2LB5"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45dd505a1dfso43954975e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 06:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031182; x=1758635982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rbghKwI6RgQqtHuzp8YIKipmqQLga/vSj80h86fMMYM=;
        b=BLBo2LB5PHvFexWoLIYT5WrIPilki61efSEs5c0jKV5SbQmSndN00mauMoB88EsbHy
         EbW3RDHt6qEcAhbdRfU/nR0p3s4ponYl6Od3MsYa3toqlYwc4dPCmvXQinYcjsWKkpoY
         1OgiiIhCNypynnEVbf6HaKtZAZIkbWWGkbYJOw9CwmaKGdEyGmqorR3wDJtsmNIg8YRE
         BKy9Gtsw/o9jXEw+WYSZBaiWgv7q56SpVfUBc0goRKHiTm6Drm8X62FsntD6u0YWyDak
         Ksngv81i03MZ/WRkd+u6vWvTeo51lmVGNs53sBwSK6FgmtujqQgh7j1VFNMk147g/McU
         8Mhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031182; x=1758635982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rbghKwI6RgQqtHuzp8YIKipmqQLga/vSj80h86fMMYM=;
        b=JmaIYU6ukrf1kA9Vc4or6l0Sf4FZHmSHVeb2a+7CpkInZfjJGB+g5vzRxr38BWEhec
         dsnXWRolcHfjEA2n4/dkWkrj/J1bOFT6WI9mI8R8VrrM9QU7jpXkh+5axGt0g4MQ2+WI
         uFlWZUnot2BWae5gwPoDsCsVLCJ9qTEKoAEkAzcTvoLKWorPdHnwsUzjLq57FlNR9rAp
         WlCnrxi0B1+ovo01K3fhG6TfSSTdyvWy4wULeJCZghWmh09oz3gwxCaLjdvccxe+5EaH
         9GowbH32CZbKTiNpaVxfFJbHwe6W1NCJVvvFLHZCqaLnPJc2CDFfI560Zj1xdIml/j4k
         ZORQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4fg105MSGylbeG4Bca0+/xg69DessBUyHIzN6YOUlqjl5ZoSdmIqsw05btm4IwV8cJLkCoJCq70g=@vger.kernel.org
X-Gm-Message-State: AOJu0YydJhbPNH9lzUVUSH/4n4L+wOXP91SqP8qXHCPHvgLF+F2bhLCm
	BIxqQ8Q8BYxh7NpOORWqOVHCDk3Urg26DzPC6eHpbNG9ONmxZlG59Y8q
X-Gm-Gg: ASbGnctpY716wpM3Lyh+GqAM5aOKpnwYsWWU08YMkOW0eagKrY6r5imrbAMZr4risBT
	kWJ5gsozvdXXhRCtIyj4093HQkPECbEJPpPwqBE1dXnLPqObXcf3VR+rWqKObHHOfrY/Ah43G/c
	TsAFwMDsDqe0CpObNDnEUWxFE/aab5AlZYtv5ZJ3h6TdJPtEEV9yJckYaiSigFuxlqFt3PcEdC8
	9yUwZlAj/yKdMgXxRTwjtzL1e7n9f2yxHQ7TwpWAn1Sga52spnsmdwVCfv801ti/ZltcFHGpbnh
	8G4yMh4iGH4ZBEoxsaT16ozyIfpa2PQc3MdvGLxEHadvkL0K+cnzosZvfU25Y4EatUuV58jpcGp
	0yfUxp8xwJRya/SeHZDBUWgiy5LWXmm8K0/buF3UuSiDcIEMAMvx85fghhnciQmNPcJvG0YBv
X-Google-Smtp-Source: AGHT+IE5shqQIUKbOw6hlw6cRTrcBtFVXG2OEPPmead9j/NTizmYAzcuhQc64qnxQ9XZRhrVFrM2rw==
X-Received: by 2002:a05:6000:310f:b0:3ec:d7c4:25a5 with SMTP id ffacd0b85a97d-3ecd7c4282emr1856689f8f.42.1758031181954;
        Tue, 16 Sep 2025 06:59:41 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.06.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 06:59:41 -0700 (PDT)
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
Subject: [PATCH v4 05/12] netfs: use the new ->i_state accessors
Date: Tue, 16 Sep 2025 15:58:53 +0200
Message-ID: <20250916135900.2170346-6-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916135900.2170346-1-mjguzik@gmail.com>
References: <20250916135900.2170346-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change generated with coccinelle and fixed up by hand as appropriate.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

cheat sheet:
Suppose flags I_A and I_B are to be handled, then if ->i_lock is held:

state = inode->i_state          => state = inode_state_read(inode)
inode->i_state |= (I_A | I_B)   => inode_state_add(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_del(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_set(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally, add "_once"
suffix for the read routine or "_raw" for the rest:

state = inode->i_state          => state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B)   => inode_state_add_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_del_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_set_raw(inode, I_A | I_B)

 fs/netfs/misc.c        | 8 ++++----
 fs/netfs/read_single.c | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 20748bcfbf59..f0f23887d350 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -147,10 +147,10 @@ bool netfs_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (!fscache_cookie_valid(cookie))
 		return true;
 
-	if (!(inode->i_state & I_PINNING_NETFS_WB)) {
+	if (!(inode_state_read_once(inode) & I_PINNING_NETFS_WB)) {
 		spin_lock(&inode->i_lock);
-		if (!(inode->i_state & I_PINNING_NETFS_WB)) {
-			inode->i_state |= I_PINNING_NETFS_WB;
+		if (!(inode_state_read(inode) & I_PINNING_NETFS_WB)) {
+			inode_state_add(inode, I_PINNING_NETFS_WB);
 			need_use = true;
 		}
 		spin_unlock(&inode->i_lock);
@@ -192,7 +192,7 @@ void netfs_clear_inode_writeback(struct inode *inode, const void *aux)
 {
 	struct fscache_cookie *cookie = netfs_i_cookie(netfs_inode(inode));
 
-	if (inode->i_state & I_PINNING_NETFS_WB) {
+	if (inode_state_read_once(inode) & I_PINNING_NETFS_WB) {
 		loff_t i_size = i_size_read(inode);
 		fscache_unuse_cookie(cookie, aux, &i_size);
 	}
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index fa622a6cd56d..f728aae9bde9 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -36,12 +36,12 @@ void netfs_single_mark_inode_dirty(struct inode *inode)
 
 	mark_inode_dirty(inode);
 
-	if (caching && !(inode->i_state & I_PINNING_NETFS_WB)) {
+	if (caching && !(inode_state_read_once(inode) & I_PINNING_NETFS_WB)) {
 		bool need_use = false;
 
 		spin_lock(&inode->i_lock);
-		if (!(inode->i_state & I_PINNING_NETFS_WB)) {
-			inode->i_state |= I_PINNING_NETFS_WB;
+		if (!(inode_state_read(inode) & I_PINNING_NETFS_WB)) {
+			inode_state_add(inode, I_PINNING_NETFS_WB);
 			need_use = true;
 		}
 		spin_unlock(&inode->i_lock);
-- 
2.43.0

