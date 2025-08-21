Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57AD3921A6
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807685; cv=none; b=Riddif+cvxmrqw50s0on4UoLvD7OrjTOc5oqbM8GX2PL669aT1oaPgz8oJ3px44RAlVvoWPAV6D377npIqoNZ5eM6n1EXR1vzNzJC4PPGAlE24JYy9NpYE/3tCVeOaJrzwZnpposivpYTtTWTBCxpJTm4iHp3tlPFMwnXCmMrvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807685; c=relaxed/simple;
	bh=0ZjV+DUCSr2pMjxDPkN/PoOVM2MR73/8MF8nar2aCc0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtzuRb+SJZ8EHSv/eVrp4pG+tBZ/eGIyjrMkUQgw1s+R2oDZWzlEDHOURWObEctbnENPyqpsa7vRo5PvixsB6rSQQhAnss79/a8OOWCzcCLT5eNjF88ZXQhiD0axLPMxBHUoJgDxUnFYmhBFzHDJo6o+meUEK7AL+w846axoEGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=VnRff4S1; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="VnRff4S1"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71fb85c4b59so25542367b3.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807683; x=1756412483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3dx0/asqotG4rq6EdmXwwX9N7zT6RzPtjLNznPWUyIY=;
        b=VnRff4S1NyTjF6Wv4trGP6bKHc5cpMxvcVUKD5DYc+jaXv3qa/saOtoI58ljFhapSv
         dgP7kFl5W41+9GNsCT5lIfWcvIwt1VFo+62WBiVA9rrj/jS697XidiOCOePeNJB7ZncK
         oi9LYJj9GshsVaB8j/JMuNYBd4cLHgoEF5vlJNPmmbGjQwuhuCJzJhVAajcRD8tMsdHO
         qWVODynV7sfegkm7F5UnmW9XRXKtfAYgGY8vHtdx2xOsrTOsAAOx6/lePAZbZplAx2iY
         MVAbHQEyBH7PSonMfYnser3L+W3LITLH51jZFabt2BiNonQbKfrygzuozGL5Lh9sD23i
         xFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807683; x=1756412483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3dx0/asqotG4rq6EdmXwwX9N7zT6RzPtjLNznPWUyIY=;
        b=nMBePyWMRdNf6SIzx1ikl53bT3OPm6REwutrl/zhl4c2X5s9pkvdbk6Won2uDKmh+h
         43b8c40AVKsNCs4b1wDlfqNwoFKzr05/zAvCt8uvQubavsvjnha/zL60Uq7pKAGT1+zU
         pcCYqNwNu49kpyc11bm61/tyunlWF9YmAk5O8XwHb3qtLCurpAkxu2k4x07IBkcOrn+n
         3cvLiYKK2EZBfmfsPnLfIO2fmQrWhUlcvsFlEtbniKL3sD58i1iV6OZyrVeo0AfkNE2M
         +GlLZgCWgXFysGyHAqBqMG+I7MLRbUYM6KaKOmdNMySPudnbBOp4E6a2R1xfJWyfgIsF
         zx2w==
X-Forwarded-Encrypted: i=1; AJvYcCV80ryWwi1cgWE4+tuwpybT59cTVwxjrBp5Ubjlcbz6iIgg9NzFEgcWh7MwIV6WFmOdH/h0BCnaoTU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5MC7/HJJZ7Su5xaY/AjVjVWyXAaVeobCORzqw8uOeWGMLVu68
	u1Z18lv9B9f0kZrS7B38TY/HTRLCeQJXmA069R/JGtN/KWcQPSmg5tn8KuAmLy+6vbI=
X-Gm-Gg: ASbGncvq8uAVIT5k++JE8XWJf55xT1TDGTnGjeEikDMWeUEKxp3BFnyVqYdu0TurEKb
	XQZNhv23TVX+f1TcaMYRtis376bsCWn10iAqFZNKdzojB0VLrlf9SYaclg+18Dz3F5G81wWBjB7
	PSzYRw++Aza/ogKsNvhE2/geKipLnfyHEQqGfwiSV7roFXcuJST1boP1DW7hY5XtKJSBPje0aNg
	vNxyaJxmTndMwHROvL0QnANx5dMB46ql6XUAJrzu0hg16yX3sQkUpw3uitPxnGehOxgT9S1F83V
	4n7G9IOh5XYFL8mXolP9f1iM1YCQphdr78XsgmLsPARZRo/gl3FSMQH/RiT3ltC9MqY8FZFMBSy
	rDgXx4CP4NivO57Tg2qEw5p4Z4gOFmHv6mKiYdklTklku/YHuklaiK66n4dOeEl/PwhARjQ==
X-Google-Smtp-Source: AGHT+IE3MKR1OshrNQhYMfUHpxtul5RNV78jpcHZ1k48ccvq/Xk3W8ycFnx2cvyOFBjMaIDV2N2ulA==
X-Received: by 2002:a05:690c:3345:b0:71f:9a36:d330 with SMTP id 00721157ae682-71fdc8da73emr5864447b3.25.1755807682899;
        Thu, 21 Aug 2025 13:21:22 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fb71c1acfsm13948477b3.71.2025.08.21.13.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:22 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 44/50] ext4: remove reference to I_FREEING in orphan.c
Date: Thu, 21 Aug 2025 16:18:55 -0400
Message-ID: <cd9f2a5d78d6863fa529da33950e5f2f0f26de60.1755806649.git.josef@toxicpanda.com>
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

We can use the i_count refcount to see if this inode is being freed.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/orphan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 524d4658fa40..40d3eac7b003 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -107,7 +107,8 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	if (!sbi->s_journal || is_bad_inode(inode))
 		return 0;
 
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+	WARN_ON_ONCE(!(inode->i_state & I_NEW) &&
+		     refcount_read(&inode->i_count) > 0 &&
 		     !inode_is_locked(inode));
 	/*
 	 * Inode orphaned in orphan file or in orphan list?
@@ -236,7 +237,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+	WARN_ON_ONCE(!(inode->i_state & I_NEW) &&
+		     refcount_read(&inode->i_count) > 0 &&
 		     !inode_is_locked(inode));
 	if (ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE))
 		return ext4_orphan_file_del(handle, inode);
-- 
2.49.0

