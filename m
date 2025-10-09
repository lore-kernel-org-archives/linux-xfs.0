Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E9D2DFA27
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 08:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996805; cv=none; b=tzapPdVU+WBuRjULReRHiDupjErTjgIVpJql1cTcV2gZt0csOoDgDUjFKuzi5K/SUURpwgxiKccdF1zatr7RFD2xAzTgvyJiTNnpG+j0X7k3rRCd7wZV5ILDcBUp1wetFlCCC757Qhb0XolS2nJfQJE+DUwYcT1MkT06VvdbUow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996805; c=relaxed/simple;
	bh=jQNHepm+GfxiH8iJqPWkaNzoPhlEV+QYfSEO5RaRoCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAtT4iTGFsveKrc7/75LjPfQJkfMVev1pZYfNYYkYKLdt7EY0Js9sjHXZiEogZKSq/3N7evrBRj9DEXsVY4IbXS4PRbSxf+fdA7O7YDKCzvcaoF10CsL5wZo/cvHfjp/UB8acbJfP6OtjNR8r/Ry0QIjG15SzCaznCmHsRMB7YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c5K+GMVy; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5K+GMVy"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3e7cc84b82so124964466b.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 01:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996798; x=1760601598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ij6PghlUCkvZUM92+6FKF+AKyv5iaQdA6DsJZ2ToQxg=;
        b=c5K+GMVyvYS40R24tzKNe19Haju195Y5qlAxziozaALQvmrqE9I5VLb9jvbvL3ce0S
         9KJjhQJZc0VFZh1hu0PVkW30bq8WYihS0YgD7WOyxL9T2A2DT4OPO9gevJTckIpMfDur
         /4F/eAI9OI8Z/aJwx9rvfVTln4d1R/uvsYFQAMMiSNScOd5c2Mg0Z4lWxtbFfD2TkpVo
         UmaEhCgZ99AvhhNYboANd05myEtwvtiBHrUW5Nktd4C3ouEQhbnnFV0WxCxP8g+rIBPD
         qq2T2jcjtJY8imtE0I/20zxHlgHjUwvCudFbPpVoWJWr1HmZxlgv3+v568Zfs3a+Zmbr
         sBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996798; x=1760601598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ij6PghlUCkvZUM92+6FKF+AKyv5iaQdA6DsJZ2ToQxg=;
        b=LEfg0C/N0DHzqvZfEDoneN7BRCxzklkV6j4QRsjHASsunTh21vVm0p3XU4voIcC5SP
         hUXBYxD5Qc/vVC6uDx5RV1Fkwgip+Nwqh7g1IpQ1lOcq7Cg0dYTotrtVlt6oYmfUrL8t
         bZowfn3ZWCOpEfAxYoculknQLQhovZc/L/ML1bgJEkTaUaAD9v2MgjHM85AwwFkQrBAR
         SEnKnngyuO1dqpgYSqFCOvlU8OPMEPseelA8a92dbFMCPyGTL6ZilZs06jXBhGrdWCXK
         qqoNy9KvHXqZrXECnAgh2IhY8d6iHVhWWOMThjz1aB1Lp6huVOLocqZlm8PBDT/61Qtj
         veGA==
X-Forwarded-Encrypted: i=1; AJvYcCVYb3BGpLCSFwFIp8fD1CzhpcHh8JtRx+uUPX9qFzgkvr5dPPTqONo09UTgGykgvNy64oULP3Xklzw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3d8tkOH3QhJqBhnZ56CyeFPEDv7/Tc9sPayFK8PFS/AgCAwMS
	pMoWE+ZipAvWhYG3lxPkNIt0FVhhtcINyJN6EyCmvWEI4Z1z6RW2tJOC
X-Gm-Gg: ASbGnctEv7HN8KaVe6CJ8EJgEac9pmQxVR02kgWtNiNLEBdZWUTvI26hzqXJVwoEq9w
	lXuWdg0Wg9gw0xmdOlofMgR/T/oLrWRpKrwqXIsH4Z0u0DHsGC5xcbqgo1y+aEguDbpt3+kdL6h
	LQMWjSrK4KlichDB4O8rIbtSbK28ANw2ie6YR701uIhg+/PQo+r5IOv1WmZj0+AQY/nY93GpVJ7
	/vqFNg4eSp76jUGCQ9KNIX4GwOHxC6qhUYcYBKGZ5pfPT6QXiOh7Foje4PAgamUBCyfKHkDGidD
	TiYdvwZvlTbPCb/+/N7Eg/WDkcCwn70H1v2Z16/N33oIlHEQOy91LyJOnjPJlsDFtNwVtXxhEvj
	cRxLEVOzkpVodTFNS1cAXsJthRCuZLmJhkMsQdHxE0PpIgcbHpkTrNJWFv8cK+JXB3IGF7yqL9s
	+4VcNjcw1bahyyAQrgXTIBgQ==
X-Google-Smtp-Source: AGHT+IF3XO1P9pAg2+/sOoYw+aIYYoO0vgMYpDeSqig4GnRovdBm66KN0sJELngmUliGaQKvYfh3Bw==
X-Received: by 2002:a17:906:c144:b0:b04:48b5:6e8a with SMTP id a640c23a62f3a-b50aa292fb7mr691075466b.7.1759996798297;
        Thu, 09 Oct 2025 00:59:58 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:57 -0700 (PDT)
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
Subject: [PATCH v7 11/14] overlayfs: use the new ->i_state accessors
Date: Thu,  9 Oct 2025 09:59:25 +0200
Message-ID: <20251009075929.1203950-12-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009075929.1203950-1-mjguzik@gmail.com>
References: <20251009075929.1203950-1-mjguzik@gmail.com>
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

If ->i_lock is held, then:

state = inode->i_state          => state = inode_state_read(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally:

state = inode->i_state          => state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign_raw(inode, I_A | I_B)

 fs/overlayfs/dir.c   |  2 +-
 fs/overlayfs/inode.c |  6 +++---
 fs/overlayfs/util.c  | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a5e9ddf3023b..83b955a1d55c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -686,7 +686,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 		goto out_drop_write;
 
 	spin_lock(&inode->i_lock);
-	inode->i_state |= I_CREATING;
+	inode_state_set(inode, I_CREATING);
 	spin_unlock(&inode->i_lock);
 
 	inode_init_owner(&nop_mnt_idmap, inode, dentry->d_parent->d_inode, mode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index aaa4cf579561..b7938dd43b95 100644
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
@@ -1300,7 +1300,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	if (upperdentry)
 		ovl_check_protattr(inode, upperdentry);
 
-	if (inode->i_state & I_NEW)
+	if (inode_state_read_once(inode) & I_NEW)
 		unlock_new_inode(inode);
 out:
 	return inode;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f76672f2e686..2da1c035f716 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1019,8 +1019,8 @@ bool ovl_inuse_trylock(struct dentry *dentry)
 	bool locked = false;
 
 	spin_lock(&inode->i_lock);
-	if (!(inode->i_state & I_OVL_INUSE)) {
-		inode->i_state |= I_OVL_INUSE;
+	if (!(inode_state_read(inode) & I_OVL_INUSE)) {
+		inode_state_set(inode, I_OVL_INUSE);
 		locked = true;
 	}
 	spin_unlock(&inode->i_lock);
@@ -1034,8 +1034,8 @@ void ovl_inuse_unlock(struct dentry *dentry)
 		struct inode *inode = d_inode(dentry);
 
 		spin_lock(&inode->i_lock);
-		WARN_ON(!(inode->i_state & I_OVL_INUSE));
-		inode->i_state &= ~I_OVL_INUSE;
+		WARN_ON(!(inode_state_read(inode) & I_OVL_INUSE));
+		inode_state_clear(inode, I_OVL_INUSE);
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
2.34.1

