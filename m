Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D533743E3
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807674; cv=none; b=E+4cAuZnr/E36YlSuYCXms1lelLPcnPfJqdSAu05XgtG/WWld1cdFjfJCUxfV+gSj+CsYZoe9MFLYiT3Xb1AUR5nEWq/cQCzZYu+KlSLYxwltAzQXAb654GSYahHRHp2samqqvpkm/pbwGaKScV+ttA/xe+ODF0cqwDCFFFK/So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807674; c=relaxed/simple;
	bh=GaKmvGab+0a2RrIuxhv8XqHzko9SenWylGMpW6UIOW4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAdTbX1eWwO5Cd0m5lbSugwbDIRRdau93amyCFPAkKV7yhflvrD8k+ThX3/y6YIZnQOLSP/aUwxePWzduOkFYL7W4Cv9Njxcu+sOOepcs2ERNsZxo5lwwYBc6babbbRlSAtFDLWnz2ba29+3g2CuF0IvY8bX8+MMPR4/V4xcBGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=3a2hxYO8; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="3a2hxYO8"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71e6f84b77eso12794447b3.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807672; x=1756412472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WTOjoTpV6m7hLv/F0NHjQx0Ply5AcqoXgmnK8+LDP5A=;
        b=3a2hxYO836tfYyAVGnW2blIN319c+qyOm7QlScVs2dhASeE6ZvyGrxPDmVBKRoC6qE
         QpkTSKqg8J26CU9WfvFxJ70pIZ0XCbvcuw1cb/rYJ2Py2VKfxnlLyUDj5k54VpgQMB7I
         D4H3EZY0f2UnpxdoJN4FAxMCfi7ZVc6QajhNg4u8PrPFa6jOAaIYfoPQs/ef3alEfGwc
         jbdNtGvRTYzolRxjlcNTad9E3z+CjSFwtiL0J9XrRdL0EUPGovsRklQptL7mIDBgjbpF
         lE5T2t4tH/9uaoc7uWQt7NExagl/cwsl+VKq69S1Yxjv1Y3o6a+5aud9ylZuC4vmLAY9
         +XDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807672; x=1756412472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WTOjoTpV6m7hLv/F0NHjQx0Ply5AcqoXgmnK8+LDP5A=;
        b=clcQ8qD2sp9gmnxbYVx3Avs4OyjcmJflIf+hagqr85JH2bGLdmwWnemnuXlV3WvQ/z
         JmRZKECFY39gdJqXh3tAvqZkGIHJvT0efKRD7u+MZ7EtFv5AI4MfBNJhglAlAxMwQa9x
         5ayJfz8MHavt/sJHJYaQF5tVzgzNZ0fCDy+ZFT4nuX1wjsC7IzY8w7PTXaNt3+QlceRs
         hRJxcIQTxxJlZUt2EZqN81qPxZc9RwMmHra/ieO3jMb9IMlk0kP2wUyggTiaSs8tuvok
         Ok6vWtSNjcUSI/EpAJ+fUWMvscbHL4UzUAA4wtfRd8Ae0E/ChzCamLynmgCm6KhjGKQI
         N/hw==
X-Forwarded-Encrypted: i=1; AJvYcCXUTs7TXNU5VHehXc6nuK5yJgG45IVXwZxCD4N9AYpt3/hWdf/b/GGobLnfWJBwgRp8lKikKCRhXQU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv0z7TANmTrUn4spmXKZ7HLNYK7JTGymwTS1H/qbQz5VfEN5CG
	fm6yZ8ryU2hj6gL+ALwTN0e3RpkP1PRs/dmlXvH+zM2yOADJRmQnTKMZMJyANUo2+mE=
X-Gm-Gg: ASbGncv3cbb3xCyyFfzI7KDqP0PrJlYVzV9C3yxP3EGxjT3xIGHgcsiohCD1hgc9kuv
	rE1kkniQKpDMbb8wqloP4WGTwc+9wazaXPSkflZOtlcNMT4MKlfzmgtAtA7BNuiiZ3Jirq9reM3
	tnYcpo6EQMCC+89gQDjYzf+bUbO8VqLQ0nuimrZBE9yn7WvgiVLyq3EFPhdIN2FI7NIogge4BQJ
	VxjQQrwV3d9dw/mFQ7kt8jTWRUo2PHAZ14Y0QE+v05+Y0m80HX+kEpNDTiy5b7Te02Jkeja8HMB
	ahFeUh9UQdFInc+Nqpina/VXw+Yq9ZEEwyhpe5/ogSTd+/c7Vp3algeaG9yu6wfv9iCykosOd2v
	Kcm8t066WV/qOS0jyvBA+Nipb3cNbQ9ZMT/htv/1HMpxBW7XX/LyxWu+sZaZV4Xl9l9amow==
X-Google-Smtp-Source: AGHT+IHgWhO0XZL2d+T13fQCGNTnfEWS9ecA9Ina0HETuoa+JmM/sUYXK320kf/CPFEnDhrEBPT2MA==
X-Received: by 2002:a05:690c:6d13:b0:71e:8165:990f with SMTP id 00721157ae682-71fdc316064mr7520287b3.24.1755807672210;
        Thu, 21 Aug 2025 13:21:12 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fae034dc0sm17871437b3.74.2025.08.21.13.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:11 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 37/50] fs: remove I_WILL_FREE|I_FREEING check from dquot.c
Date: Thu, 21 Aug 2025 16:18:48 -0400
Message-ID: <109daa67d809b78526099377be7f9fef59608010.1755806649.git.josef@toxicpanda.com>
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

We can use the reference count to see if the inode is live.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/quota/dquot.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index df4a9b348769..90e69653c261 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1030,14 +1030,16 @@ static int add_dquot_ref(struct super_block *sb, int type)
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		if ((inode->i_state & I_NEW) ||
 		    !atomic_read(&inode->i_writecount) ||
 		    !dqinit_needed(inode, type)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
 		spin_unlock(&inode->i_lock);
+
+		if (!igrab(inode))
+			continue;
 		spin_unlock(&sb->s_inode_list_lock);
 
 #ifdef CONFIG_QUOTA_DEBUG
-- 
2.49.0

