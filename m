Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1B72EE96F;
	Fri,  4 Jul 2025 10:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751623981; cv=none; b=EQRjV4BhkGxKU58z6EJS5x3vVEuB5WeukXcREfS44gyntsLgqxwmeNhUkHmdJOxVa0p0lW11zrKFoD897C4zHsCnKC6XNUrUucKGpXXRHWW+pmQLWEK1GxL5H95W20IYt9mgbW493T3NTmYhMg8VjK3inCyyCIcrWrY5FCtJRUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751623981; c=relaxed/simple;
	bh=strF/qF+HXTlakY4UdqZE40XmR25ZXBwyUj3EmP1zvY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bJh2Wm+bRwoDXS94B+wkDSvI2YSCjxlWUJ0JH52Tqs+SwJ3mL8PhwiEFrHwsCLTC9i7T2FA/P7Xv6V13bfX8VCGjCVd1EHwef49YD0XhGxLlozIrZ/LcOPjj8AOHiu9ncBOvTkMfL8fUXC5L/oumW8Pi0Kx5REGDbF9SzThIkvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X8ZDsIPj; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8ZDsIPj"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-234f17910d8so7078555ad.3;
        Fri, 04 Jul 2025 03:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751623979; x=1752228779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l1y1NR7p8TbbSgnXEpVgZrK6g8G4GQPFzDyyvDynoD8=;
        b=X8ZDsIPjvHU+pC8t7xztDHxRdH1AYHgBcalpMxNfRKRgTMTrHDptHpEnT3LHk9LuVD
         1V8jhSkWWcqA8iQUby5WfVmbzcdDmkNFHUK37LTIY98wtCWZR4RSVp3cMOZHp2JVtRUr
         +/EnoSFrDiZvtmdixbskKrG6Wc4cgiucEE9duYLNtcr9+ibVMZ8Zgw7f/uqwlHUWAbuw
         s0/AcUoAtl4EwjkObY5cikMV0XRxu6UktAnZrxfazR292vy12GahRDf6qitTqwDCIKEa
         fI6XJXU0OgGE12XrF3eHWRsPxbMElZsjSrgUO72WpWaDKVN/rNIkdFmAL9BAb5eWghma
         sThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751623979; x=1752228779;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1y1NR7p8TbbSgnXEpVgZrK6g8G4GQPFzDyyvDynoD8=;
        b=gx+gEDR2XNTuIqxEcRo7BnMkUQoTdJS1UIExWVcLNV+D4h+Cr8LTVfvlMrqM2EBnqW
         MDop32B1RjkOg4gOGYpEqY7ZFfptIfDSpDaJ+M72059GeVBJr0Y5DCKRpLB7FFgqRqxE
         HYpyMYnHOI+xyRHS0x7Xt6IBSWzKz9iCZ64qJprV3tiezJEo3YG3zGl+NJdLd7NZx/jz
         /KE4kvIgXFL//IvZLFAl6DozpbFLPsCFxwqcMvnPq79h3S6voO6rilxq5KQAyEaqR8X3
         h0gq9q8cHSvATn3DPWkVWcCMAwLbIwBOhUwyhwnOQHSs00gwVjX/bg0tczMo3HNUH4iI
         /Fxg==
X-Forwarded-Encrypted: i=1; AJvYcCXLsLsfskMKpDWv7B5EhTrd1YwRvOixBAxswTaeQho1JdIt1RS3H/rzSBJRZLSaOG5cM4K2+wNkp1Uvw/g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvi0FgktQjnCqBE9SOC9OkJiYye4aWsTbZ0cx5X8CWMW6mgvXi
	TbdA7gQAQpcKISaiOoxHsoaZA4kr4x7q8LN11gCki6CbDrBqu90SkE+JMzpa9pCQ4R0=
X-Gm-Gg: ASbGncvl6Fho9JbEUDRrhmpaYqJNxq+BJSI/awgammknTEDYbAHkVmWhJWTPbf9suIz
	DAqqM3SGuh41gGO3r85Mn7Mi7b2hZZyBNmTj/Mq+oNSoE2V2ljzAk9grc+5guoZ6KgM8aCoNbdS
	i17wezV6POst06IfRWVqie/TxmSIo+caJi6FxHQdp4ZN0282F5wMGMarMB9bolxw0c5n5fI66y/
	cem18Evvw7zwiZ/UgOyu38OfLZGQBRHqrlqfXKp0t8Rno1UKodOxmuWh+/3Sin2K/vKe9AONEFv
	kip5pigzXRAiyid392d7j+ofJoBgmuQPEVWoIP3MmJbweJzz5a+pr5y3+YH3YlcUWrdd8qVlc15
	+GPx3Fw==
X-Google-Smtp-Source: AGHT+IEhlz75hcIMScbZOGrIIhpGBtexZtJVFZxnnJZmRv2uDCi7FVBVuU1Wr0ccc3OHMr11OZfp6A==
X-Received: by 2002:a17:90b:3d43:b0:311:eb85:96f0 with SMTP id 98e67ed59e1d1-31aac53b7ccmr3344373a91.29.1751623979053;
        Fri, 04 Jul 2025 03:12:59 -0700 (PDT)
Received: from manjaro.domain.name ([2401:4900:1c30:6f3f:3d1:c4c0:3855:2a18])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31a9cd0cfd9sm4465076a91.39.2025.07.04.03.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 03:12:58 -0700 (PDT)
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: [PATCH v2] fs/xfs: replace strncpy with memtostr_pad()
Date: Fri,  4 Jul 2025 15:42:50 +0530
Message-ID: <20250704101250.24629-1-pranav.tyagi03@gmail.com>
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

