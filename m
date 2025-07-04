Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7907628725B;
	Fri,  4 Jul 2025 07:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751613981; cv=none; b=IkDYad9A4ArxBnWg89DYEiO6nJEJp887DWHR8ExAbPsWTdbQoBfl37C4Ctq2qhzIrBwFyZg4adYSrYPo7M9MWnv+e6L7NVyvM/UwlVadG+WqanaToUa49LG1Ma5Y5OqPVcjl8tGj4EzTF/tr3/EiOSAD46Vd6OkPKMzHmzEmFlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751613981; c=relaxed/simple;
	bh=Upigb2pu4dZf0sT6kkLAt84b8rlfCgQMY6Qq/ZtbZrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dBqhspb5ucFkOTciPzq2UHI4Yjpwer+hwSGvACW3Y7dRufn0/xpxmiw2EGlzdGZRvtiMkIkCGDkjK/YifPbG+tMWeyy8AHQuZCpuaJ9E3ieYB7cqkTFmI18gOYJoV09J6652NMpsySvBVBpGrLgrUvUfUIxgfiyqbVE6aklX0DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DmRRxE1i; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DmRRxE1i"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-236377f00easo9463695ad.1;
        Fri, 04 Jul 2025 00:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751613978; x=1752218778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kDxuxUDgUgDkcVZdx4yl7cOtfH39Xq3bSHZLoPDyb9E=;
        b=DmRRxE1iiDZmscjNq9QCo0O4f4e12uCcXfUtLOYi4YCyorEkt9nO6+jsGR+PgTq9jg
         CXIwNt+hnOXB784FGWPSbTTinY/aOoBl3SUvAZ3XQ1L8LfKtfT3zHEN9MhH8eyr9NBNy
         99Pp+LU5pWNJ0m5u2rUD3uOvojsa9ULGqkK4L2815cR3AeRqj5KUyxCHDivOuUSENg6I
         5Adq6HOU8KiiX2xGFPENFlAHAZc/H4o+g39gtpxkYYo7e+16U7M5FUO9NQfRndCHaJbM
         /y0s93I58DjFC7r0QCtOu5TrhhmlsUDqapYdQgvJklCcWg6UszEd8+HefaDleZcrOwIQ
         /2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751613978; x=1752218778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kDxuxUDgUgDkcVZdx4yl7cOtfH39Xq3bSHZLoPDyb9E=;
        b=UBpqUr/x2hBjQ2Z1n55xI6RHUndJpAaN/jo0gM6C9hlvvLCbPdBvzpqgSiIciDxdZR
         3V0Ng3AlnMRxjtoQFXByXgsS10QRq+ztjBvnKNcMIpljiISjvlu+5HLrck/SfNRoXxh3
         a5dprBonBR0inwo6AejTn2Td2RqnHTHX/s6AfJw9QjBUF6PtbkSmVH//uq/EaCG22LPP
         TAXrlLZ6zTZPNPXACQp0y2og9syFrxmT5KRUicMHx3wUZHyiALx80EC7KSql5bmNItdS
         X51GfMdTykmsdyt38mPHZmF0cTAF+HGH7uXNaZFKedRjFNuuvU3LjjuA7Dy8IK+iPQDI
         v9yw==
X-Forwarded-Encrypted: i=1; AJvYcCUaSHxrrhR2EkhKGMGOjjvw7xT4o4KzxtFa7ClyJ+QAGpS+gLBIN8SgSMVeu/akvRF8UwIxxHnJTau9Rfs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfwXAtyX4rg4XCyaLthnU51+bmYuuZk4ES8zRBkEeAzMRAf+4P
	XmR0s01DCiX93LHHyeftZzAdzDiPRvjqzIMz5+OC+nU1KqfvTOEOfAH9kK3J1eO6SKw=
X-Gm-Gg: ASbGncuUni6Sbwk88zBR3X9nU2J/08nCankrW/yi1E2feWin1yP3IJCZ9qTo89nWup7
	7/gWwLZr68CIm0ZQGHnCWnHFVswyd4ObODN4gHLLR7kReT84yZmun0200NZBf/b31+WbdocXm28
	0Vp9B5OvNANpz6+kHXuFO7hFsmxc9O7vbEuGTD5sKa8pSTeBzxKzXGKfTKfkgMSA9BoukCOlE85
	SRN4WqURE+US3d9XwwxFTGnxKl4iTcd5V7FXFoBvI+IRjp8bvZvmerh+e1AQp8wL7RhYo3NxSfn
	YE5+gAmE4Ll4l9xL2SYtPxntiQZOW/Q3NjD2tnCTlRaeTwElA4G12ePZUNRpsiIdDQPyEhP/sVA
	rZuvR+oiMDyjPnXqm
X-Google-Smtp-Source: AGHT+IF868eyucOmTptTbQbUozxpL8rfVAZcdj+zsUMVFE1ZmgFNdh9GJcoKkdvBbd8xKBaEX3JDJw==
X-Received: by 2002:a17:902:fc48:b0:235:27b6:a891 with SMTP id d9443c01a7336-23c85e772c8mr31057695ad.28.1751613978318;
        Fri, 04 Jul 2025 00:26:18 -0700 (PDT)
Received: from manjaro.domain.name ([2401:4900:1c30:6f3f:3d1:c4c0:3855:2a18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8455dafcsm13455985ad.96.2025.07.04.00.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 00:26:17 -0700 (PDT)
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	Pranav Tyagi <pranav.tyagi03@gmail.com>,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH] fs/xfs: replace strncpy with memtostr_pad()
Date: Fri,  4 Jul 2025 12:56:04 +0530
Message-ID: <20250704072604.13605-1-pranav.tyagi03@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the deprecated strncpy() with memtostr_pad(). This also avoids
the need for separate zeroing using memset(). Mark sb_fname buffer with
__nonstring as its size is XFSLABEL_MAX and so no terminating NULL for
sb_fname.

Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202506300953.8b18c4e0-lkp@intel.com
---
 fs/xfs/libxfs/xfs_format.h | 2 +-
 fs/xfs/xfs_ioctl.c         | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9566a7623365..779dac59b1f3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -112,7 +112,7 @@ typedef struct xfs_sb {
 	uint16_t	sb_sectsize;	/* volume sector size, bytes */
 	uint16_t	sb_inodesize;	/* inode size, bytes */
 	uint16_t	sb_inopblock;	/* inodes per block */
-	char		sb_fname[XFSLABEL_MAX]; /* file system name */
+	char		sb_fname[XFSLABEL_MAX] __nonstring; /* file system name */
 	uint8_t		sb_blocklog;	/* log2 of sb_blocksize */
 	uint8_t		sb_sectlog;	/* log2 of sb_sectsize */
 	uint8_t		sb_inodelog;	/* log2 of sb_inodesize */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d250f7f74e3b..c3e8c5c1084f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -990,9 +990,8 @@ xfs_ioc_getlabel(
 	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
 
 	/* 1 larger than sb_fname, so this ensures a trailing NUL char */
-	memset(label, 0, sizeof(label));
 	spin_lock(&mp->m_sb_lock);
-	strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
+	memtostr_pad(label, sbp->sb_fname);
 	spin_unlock(&mp->m_sb_lock);
 
 	if (copy_to_user(user_label, label, sizeof(label)))
-- 
2.49.0

