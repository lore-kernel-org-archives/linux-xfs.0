Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E02369961
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222904; cv=none; b=lJBQWuDl3WrQSbCcg5AkprnZ1GxMSfeecDXsKS2/FzgLlFQvnFUgXDcscOgi5o4OtP4Sf0TEjPilr+KfPW+xp7vitRCtCJsM2pqC8XaAdGhxgaFEOBfSr8l/zHlneUfCyteEeTc2KCRGhAyQ9kgPLw8EVPWdNBbJbkShfpK87U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222904; c=relaxed/simple;
	bh=I8tiOyv+oMFkzRzMCj4c/X0bwN+yK3mHwtJz9daUlt4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMD4051V6Dw10nwfuZ7KQKGx4udiEOXBFEiY1fvUIf9Bf4zyVv6J6FGlemKAHqFL0hB5qoQbbovARa2eHvleK7Ev3lNbkmQsyhNsJIIRlbPR+1YQO57JJONIMKkHQXtgXic/91nh8oMI/5xq455pU+5rvVAWI/S6jngyRgDnP4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=pwylTXvZ; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="pwylTXvZ"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d6083cc69so44284837b3.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222902; x=1756827702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z7tCn6brW2Zw7rSbRSTNv27z2ReNHNSMYcuiTIB2+/A=;
        b=pwylTXvZIek9rC+cjh+rUvWRMGRxPPKY/12OEde/F2n52BIvEfVk77wjSelJ03Ul8H
         Fve2hGzxBxhUJFEt/rUiBuMfdMC6mi2cUiTUlzlrLLkHgntPWMVE3CUuMiVWHw30gei/
         i8eVFnU9D+j2N12TcTZ5rawZJM9V+zQZW/pypw7vN22u+JOca8YudhpXRMn7GaRToIyu
         3mnNOd7oTCK8GUXVM4Be0GqypQlFAfwyKMfR8ksNkOixcU0XAUIfg0IawAQ3nPEdtwxI
         my7ELj73tIKtEytDRIhjG3qWe+kRGCAnI0ry9llwWvEn730sFEOM1iYClkG9EfzB1On7
         ua6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222902; x=1756827702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7tCn6brW2Zw7rSbRSTNv27z2ReNHNSMYcuiTIB2+/A=;
        b=A1dohf2SEgZ+OD2zOuM7C0E5VRWWtN1qr6tr6KuvCBhxEaVbgtrQAt1LnlCqhNY2X4
         ZsLiZMbyR9Cc4D+cPlNbnqsJK3j/FSI8sV3f2COlbCfs+EEJ+KoIclZGBFep7TzYacDo
         3qLFkOeDXl28fc/FRsn7LQKeP6+h653DpNXBlzrXJA/iuC+ZXfbuczWuAtDYLL70BeK0
         xNQxa8BQwDx4ll3LorHglHbh0EYiLyardij4b6SEOlnSjbeKhE3U+1Wjt/6Lsb0uTlt2
         Ge4gmsQI9PxI+JUhG585nB3bbYF59uaKq3NysFoufsBDIiZBVb3Tipme2w35Yduh43xC
         S5PA==
X-Forwarded-Encrypted: i=1; AJvYcCVsqZGOgBGw+VhZgLCrkGaGyODqWDwgM7//X+Ws5MZ82pXWw1ranAiPoJqxvv7Z10PJFIfkqbVFBN8=@vger.kernel.org
X-Gm-Message-State: AOJu0YziWIqk0zLGr/bzgXXuNlUhMTxb+CWvO3oKuD9xyAd4DuyLlTIy
	gsSK4+Ueaz7WtxDum35u72GmMmGL/xhQrfuSbSeBZ40PY4x37Y7GAVOiepcnGR7sG5z/X++iXuc
	BbPzC
X-Gm-Gg: ASbGncvUASXhuKwe62hGCJIsGN/mQxLuOMANP821XO0ubvOv+cF6VG1kidzVeMHt5e6
	2TsB7ZBjRPfBXCGuhFDYOkSZwFIn0+cxPbxgk4wRQHAqH5jJLx940yiy1enhWFboyd3mXkkB+Dx
	2KgNu4QUmnoN6cRc97A+44STnwG1TqA2y/fxHqGctQaULvl9jaj7GUm9Diu3dDpQ8u2K8kDl3Qn
	JBIshIHjP7kCIyMa2n0s79PxF96qx+6cXltoYHUb1GuKp7GR61usp1C6UbYGCGmYqvfMjLWLT3n
	ml/kd8uyxwrKJL2JCtCWVBa+02NdgC6F9VOwTWwzFauqRNDWMkXzUjKZo1BHETrMXgdVImwCRwd
	gx4sbIqV5ODHde4qEOJQYQaZenf+B/p2wWjZUWuE6ZYk02z1XxucZg6cHnno=
X-Google-Smtp-Source: AGHT+IGBAJPmxte5sNeC5FD2oABugwlxmnWPA9F/dg7GKYcMncBw9P2DHou91Bjzh8qPzrObW8jwHQ==
X-Received: by 2002:a05:690c:4889:b0:71f:f24f:ccd9 with SMTP id 00721157ae682-71ff24fcd8amr158166887b3.36.1756222901377;
        Tue, 26 Aug 2025 08:41:41 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18fc8f4sm25008697b3.77.2025.08.26.08.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:40 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 36/54] ext4: stop checking I_WILL_FREE|IFREEING in ext4_check_map_extents_env
Date: Tue, 26 Aug 2025 11:39:36 -0400
Message-ID: <716903e50725460894cd1b2591f9bb2cac90a2e2.1756222465.git.josef@toxicpanda.com>
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

Instead check the refcount to see if the inode is alive.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5b7a15db4953..2c777b0f225b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -425,7 +425,7 @@ void ext4_check_map_extents_env(struct inode *inode)
 	if (!S_ISREG(inode->i_mode) ||
 	    IS_NOQUOTA(inode) || IS_VERITY(inode) ||
 	    is_special_ino(inode->i_sb, inode->i_ino) ||
-	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) ||
+	    ((inode->i_state & I_NEW) || !icount_read(inode) ||
 	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE) ||
 	    ext4_verity_in_progress(inode))
 		return;
-- 
2.49.0

