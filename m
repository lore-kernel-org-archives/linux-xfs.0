Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C62431E10D
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031178; cv=none; b=sdDWtNXFhjNHweRAfgqD1OXVIyZF5sVsqkgxRcyhpi4KEsHee41qKVXeGrbQLPxS9ZUl36MV3qLfMP5Jubb/YwBS/stS3bD9s1evm7bBHn+ley5WzrOOWBvizCzbvv7pUukNTt7U9zmmao0IIY2wFW/nYERfl0bMeJQ0Hjgl09I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031178; c=relaxed/simple;
	bh=4ZH9W3P+XiG/Sp7tBDITc58g7he5Ng0NmNakO8szh+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNd96i1MJIAjzGyawVvuCfKKhp+34skJYlTvFeXh/9sGowHarnORia26Lj496twkZi05q8VRUHO8UQkc1kCxN+Xse3qQls4P7XoQbljx+vktoLUcRh5uSOLL1oXIuvL1u8AvinublfSPsZcus3LyRhAU7FOwwJO3tvE+456ObJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NzHK56T4; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzHK56T4"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45f29e5e89bso33316905e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 06:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031174; x=1758635974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EhJbct8Hpn8FASNagja9p1KxL0ag1VLHqziGZAwrXc4=;
        b=NzHK56T4Gc9JTM6H5ShPFQQhyyD1KBGLZZDgYq4XZa1aMIo2n4DP9S0SqtZSlgWAel
         URh6NqbNPTAC0XBYWmTWUCNq3f7yIBNCgTDGy30CRsnWD3N6BeCrDUdCf8AY1Jy0sxfs
         WxF4HDJQyHIVnXBszwq0VmZmX6SitvC+7rsMYWXwI9n075Gotqh9WWoCi35qff0KJekl
         vzrjUrDNBpGx9Ytd4bcUK8NHqrUw/DQeUDJF/Nrmm/urXLiciDnr62isLxnvHErkwNE9
         ChRWElykA0Gkfi8CJCeridEoKr/rNMWmUrWzXUSrCFAYe/597o+/Dg7K3iJmLIkP7uTy
         7GFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031174; x=1758635974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EhJbct8Hpn8FASNagja9p1KxL0ag1VLHqziGZAwrXc4=;
        b=vT3MowyIqtmoneaxrPiDCe8mivOZD1oNz80tj5K3DDgpacejaVfP4mdus+sX+gycqW
         VYwGKgh8EPfzVb/y+Dwjdt0JUy4uoD9Uw2y32yJaQOJLUpr0z35mm4kqJ2aWsW4XTyOF
         rOLwZN9ORa+cpXX2B90cyHG/s63Q3BbD2H+rqG1zGW8P5cJ8GeCqb5p/wSRX1uY1NI1z
         T8PcR44XNsW41AAL/CKD4rMGhf/gw17KYbxCcSf+Rku1zH/9bE6yxTegzgt2zXvojxTf
         xhyw44HOQCzMrcwm0WXAlZ+CPZBsLDLrEzPU2voTVnTdWI7C6e+KxZQwAn1mtIwjEpOe
         H+hA==
X-Forwarded-Encrypted: i=1; AJvYcCV8BfE+u8ijxb8lMtqOUVpZnQDuX+Bz6QvExPTV8zen2twkVUX4Yx65lHcCmRbG/x8LI416ZCI6ogg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjk1XHvLA426eZjIKQbYTwnXAB/3z3VL+KMO7uiRIeE2QrRRUO
	RzEnCX+RCpW4cJ9bSeRKoKN4HY39uxyfz1dPyfzHFlpU8lwdW/HAvf4K
X-Gm-Gg: ASbGncuNMKvWsuGuLc2rAtjp/gd+2YFBoqKyrVqKLvMxjIST96z4E5bVFh+cXzxAIeJ
	kcCJLjP9Qz7uJ8/UHSmYBoVjsvTYzSonXCtEKEAjiSUHuvzcsnLhS3HPjI4OGr+kGmrNtO/JZ57
	ax7Sr6fT6DZGZHLChy/ckYkwXIsTo43M4Xjz+Zo/FBtQw+jgGAYd2T/WUuAcxjlAyo2d3BXtXkl
	DiHQ5cNEYOPbTgCi4HFhlJFWeoS6AbdCcP4zW1bAw2qzPlfmQ3w5lha4uv/hfDR/gyB3K0WbzZI
	Td0w0EVrEiOqvpxLP9WmczqHh8/2ZsKpYZp/F5rX6nNV6C8PvE+cTav/sdYm1D2tmNisaDSli6c
	DeE7yRm5p/oQ+ddfMlZxIJWKTj7fjcmntWDvWD3zR9uxVaG6lPWgZE74g8bah9O/iV3hxLiuK
X-Google-Smtp-Source: AGHT+IEv/yp+v5i4wDZD8rx/vzr2v/aCCUSPqPNX1ISHbufqpWah1qF1v3yMiZroJvxSpOFaPBPDfg==
X-Received: by 2002:a5d:5d01:0:b0:3e1:734b:5393 with SMTP id ffacd0b85a97d-3e7657b6a36mr14835320f8f.28.1758031174218;
        Tue, 16 Sep 2025 06:59:34 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.06.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 06:59:33 -0700 (PDT)
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
Subject: [PATCH v4 01/12] fs: provide accessors for ->i_state
Date: Tue, 16 Sep 2025 15:58:49 +0200
Message-ID: <20250916135900.2170346-2-mjguzik@gmail.com>
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

Open-coded accesses prevent asserting they are done correctly. One
obvious aspect is locking, but significantly more can checked. For
example it can be detected when the code is clearing flags which are
already missing, or is setting flags when it is illegal (e.g., I_FREEING
when ->i_count > 0).

In order to keep things manageable this patchset merely gets the thing
off the ground with only lockdep checks baked in.

Current consumers can be trivially converted.

Suppose flags I_A and I_B are to be handled, then if ->i_lock is held:

state = inode->i_state  	=> state = inode_state_read(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_add(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_del(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_set(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally, add "_once"
suffix for the read routine or "_raw" for the rest:

state = inode->i_state  	=> state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_add_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_del_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_set_raw(inode, I_A | I_B)

The "_once" vs "_raw" discrepancy stems from the read variant differing
by READ_ONCE as opposed to just lockdep checks.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 59 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c4fd010cf5bf..d54171f13c7a 100644
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
 
@@ -899,6 +899,61 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 } __randomize_layout;
 
+/*
+ * i_state handling
+ *
+ * We hide all of it behind helpers so that we can validate consumers.
+ */
+static inline enum inode_state_flags_enum inode_state_read_once(struct inode *inode)
+{
+	return READ_ONCE(inode->i_state);
+}
+
+static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
+{
+	lockdep_assert_held(&inode->i_lock);
+	return inode->i_state;
+}
+
+static inline void inode_state_add_raw(struct inode *inode,
+				       enum inode_state_flags_enum addflags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state | addflags);
+}
+
+static inline void inode_state_add(struct inode *inode,
+				   enum inode_state_flags_enum addflags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_add_raw(inode, addflags);
+}
+
+static inline void inode_state_del_raw(struct inode *inode,
+				       enum inode_state_flags_enum delflags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state & ~delflags);
+}
+
+static inline void inode_state_del(struct inode *inode,
+				   enum inode_state_flags_enum delflags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_del_raw(inode, delflags);
+}
+
+static inline void inode_state_set_raw(struct inode *inode,
+				       enum inode_state_flags_enum setflags)
+{
+	WRITE_ONCE(inode->i_state, setflags);
+}
+
+static inline void inode_state_set(struct inode *inode,
+				   enum inode_state_flags_enum setflags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_set_raw(inode, setflags);
+}
+
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
 {
 	VFS_WARN_ON_INODE(strlen(link) != linklen, inode);
-- 
2.43.0

