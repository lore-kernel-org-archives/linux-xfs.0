Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB5732A813
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031209; cv=none; b=b3R1HeSiu9+eTQI5o6NuvzZUo6JUQuWWp5jvRbOhcGDhb/qlLdV+aHJj6+XcvccqWlweDy/wGYDhPC2tAvWp3yoSUI4h8peUwvhcF7qASnlEU5h9W85L1YtseUc+BYb+YvOpdrQiHALvlWfx6/n7qiX2ErvmIms0cOmdKSFw+vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031209; c=relaxed/simple;
	bh=9uB5tIoSu0Ihqwy/dzzpF33dCVQXqPEjiR4jiBdlE6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUQUyeOr7oRxDO2aBnK1+WdYiBekb7ZhbXEDkYrCoV/7ndUP1d1bmQ9N/yihRu1A11QUuYeHwv4i5YAL6A49WEKr/JWXXIv6Qh7yfQSbL/9cXQu0C9rJEzMsnILIfzF7hJtPL2za7FEePQAdlhufXKdcRfhMP2+xj4nvnxaIBJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lxR8ybYu; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lxR8ybYu"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45f29e5e89bso33323225e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 07:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031204; x=1758636004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jXBWCescUObzsT6Su0exTy7Btg138NHvbE5HLT4Jeo=;
        b=lxR8ybYuXYa9qNaTZ+hqKLsxR/u6BY6zzV/gtp4yDl4JzRW+ztA7qdJaNySrU8LmcZ
         +FSmJWBbnjLDWgyo81qjnG8LLkp49YRNdYlJqvcNLp1+zhsno83coVbLSowVmYzeurvP
         XsYd6YlG2dkp1qWYP1If5nmE0BPIBxlP6+3WVOfS6fWAMuJASV8e6HHvYe6qc7kxCtMz
         5HAaBdC8JUnGb9Wy/Tj8Fc6l2KcFMwegRHdlBFMG2gPhJIngXhaUXjdOvXzJA8ybaSYe
         J3/HVLwK1FojmIoSbCzAg99/Fl9poOSdGL8rtQSt6SG5a0ebPl6+1AKIxIWjjcXLmRom
         jeCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031204; x=1758636004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jXBWCescUObzsT6Su0exTy7Btg138NHvbE5HLT4Jeo=;
        b=IFdX8HNLOSMlbKDbf1f6Kj8+UAXHTRC3/z45ba17aaXIF71LMAxeVPF77OHT+vh9Xt
         u96tAG2kmatl5x/5Wib+anbNCA8oKVzdsxuMaNRMKHQuggSzLqePyZXLuW6mxsWZZ65Q
         4/d3qeDRMx6UiYp6SeAW0dtNcNmFUaWpq6M99tlu/hJ57kqiEvgZl6DIHuMPFspzRRPU
         FNCzOIA41Uhk6XNBR67w8NfGTYquMd7bXqnVM5kWtawoXwlM4CBMbfTj9agpofERMCxn
         UJSqh2KNQPvLn1hzEnxhm4qK1ldT2oYeDK4gkHoIsLM68rg68YAKcn1FHd00HTwDXXB7
         3Ieg==
X-Forwarded-Encrypted: i=1; AJvYcCX03KynCk6knaMLqZEGG3+FYA05X0Jp83no7JI8YTW773iaQSgJTp1ru4ebO8yllMhbQ11skat+uuc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHN0M96uKIrRWAV+aflUW4cOUdQ+CePRBJDy6+sBe/cSLmT8By
	ettQhLHTMoJyJSg6v/LCnU9Ay/dseZ7O6r2+obrROz1EqnAK4teLCxGc
X-Gm-Gg: ASbGncsixxbXQhvdeQVu2gGi+ckm+YOvnGLm/cfmui9GJwNV2E5HzabmOXUORWSQwWB
	bJu2H9RGv2NMG8gLw7+l8Ey4lVCKugQcRwTVamzmXOudgKUevMUImtwlEFCJ/Ij2wgwJfgF7u3S
	z6PrnVFmT3dUDloK/mjyvsWoVfu7Ju14F7jpqziWvU3q0ZTboV4yfsJu0nI7hEF2CqbSs6h1952
	ivNxYEo0TJTOzPYWapRpVfU364td50mXqHpdxIkVt0i3CSQnrt2IrNEOt+9Yb5OT7lE7wurLFQm
	svduQrJoRUVlpCyID1fMfQlxDSmNbxhGAUxB7ayS2kwFDNL/ClSF8YPTdAmxAvhjYIWumdkwHsr
	CkQE6I6LfUnLYxVTtsr3wJFQCZi8lvDv0Ur8DN3xIf6eFk8GrwbX5X02+yBg2gu5TJREkvnRW
X-Google-Smtp-Source: AGHT+IHwPsVwzVQ+3BwThlohyBuVsh7mtJyWbIwjAmCzyS+IiOJcg7GYx0sFvI9t/faLf/pLubt0LQ==
X-Received: by 2002:a05:600c:190f:b0:45b:4282:7b60 with SMTP id 5b1f17b1804b1-460614f9f91mr11287815e9.34.1758031204161;
        Tue, 16 Sep 2025 07:00:04 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.07.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:00:03 -0700 (PDT)
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
Subject: [PATCH v4 11/12] overlayfs: use the new ->i_state accessors
Date: Tue, 16 Sep 2025 15:58:59 +0200
Message-ID: <20250916135900.2170346-12-mjguzik@gmail.com>
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
 fs/overlayfs/dir.c   |  2 +-
 fs/overlayfs/inode.c |  6 +++---
 fs/overlayfs/util.c  | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 70b8687dc45e..eb3419c25dfc 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -659,7 +659,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 		goto out_drop_write;
 
 	spin_lock(&inode->i_lock);
-	inode->i_state |= I_CREATING;
+	inode_state_add(inode, I_CREATING);
 	spin_unlock(&inode->i_lock);
 
 	inode_init_owner(&nop_mnt_idmap, inode, dentry->d_parent->d_inode, mode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ecb9f2019395..3f7ef3dae5e5 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1149,7 +1149,7 @@ struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir)
 	if (!trap)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(trap->i_state & I_NEW)) {
+	if (!(inode_state_read_once(trap) & I_NEW)) {
 		/* Conflicting layer roots? */
 		iput(trap);
 		return ERR_PTR(-ELOOP);
@@ -1240,7 +1240,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		inode = ovl_iget5(sb, oip->newinode, key);
 		if (!inode)
 			goto out_err;
-		if (!(inode->i_state & I_NEW)) {
+		if (!(inode_state_read_once(inode) & I_NEW)) {
 			/*
 			 * Verify that the underlying files stored in the inode
 			 * match those in the dentry.
@@ -1299,7 +1299,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	if (upperdentry)
 		ovl_check_protattr(inode, upperdentry);
 
-	if (inode->i_state & I_NEW)
+	if (inode_state_read_once(inode) & I_NEW)
 		unlock_new_inode(inode);
 out:
 	return inode;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a33115e7384c..cfc7a7b00fba 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1019,8 +1019,8 @@ bool ovl_inuse_trylock(struct dentry *dentry)
 	bool locked = false;
 
 	spin_lock(&inode->i_lock);
-	if (!(inode->i_state & I_OVL_INUSE)) {
-		inode->i_state |= I_OVL_INUSE;
+	if (!(inode_state_read(inode) & I_OVL_INUSE)) {
+		inode_state_add(inode, I_OVL_INUSE);
 		locked = true;
 	}
 	spin_unlock(&inode->i_lock);
@@ -1034,8 +1034,8 @@ void ovl_inuse_unlock(struct dentry *dentry)
 		struct inode *inode = d_inode(dentry);
 
 		spin_lock(&inode->i_lock);
-		WARN_ON(!(inode->i_state & I_OVL_INUSE));
-		inode->i_state &= ~I_OVL_INUSE;
+		WARN_ON(!(inode_state_read(inode) & I_OVL_INUSE));
+		inode_state_del(inode, I_OVL_INUSE);
 		spin_unlock(&inode->i_lock);
 	}
 }
@@ -1046,7 +1046,7 @@ bool ovl_is_inuse(struct dentry *dentry)
 	bool inuse;
 
 	spin_lock(&inode->i_lock);
-	inuse = (inode->i_state & I_OVL_INUSE);
+	inuse = (inode_state_read(inode) & I_OVL_INUSE);
 	spin_unlock(&inode->i_lock);
 
 	return inuse;
-- 
2.43.0

