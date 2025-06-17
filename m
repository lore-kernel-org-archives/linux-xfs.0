Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E6C1F1311;
	Tue, 17 Jun 2025 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750164359; cv=none; b=f+yGN3zhmg/PFyBQrlIOnJKeQiU72u8M3RLSHLsv8XK1fZ2ri+3Lzg44eLH4oo9SCYBnQk5JMyuC6sNy4V6lc0m04B6L7uxJXUI65MZ2/E8qKG3pDxFtRbHQJ68jpPzyYGX1Pk7rO8lh5fgRs97bNx3XKxZeuYfgPreUgFRTA2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750164359; c=relaxed/simple;
	bh=kxyBVKCb12l5V36NGqS8vayy13b/AHgRj5tbAPrSDoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NiGyFgS+Ck/lX/mmVyaDYuJ/8ksGONuZwkzIxs6a77QTEOVOCoTI5dfktQQPGiaAkN6xKG96h3tnn/aWxSQUluDaScWcfWHOYOC6vfqbcAx309mH5HqKhnXmXTMKwLVnZHePLKtuC0AdixmDQk/dqLnldjCjmVIR/Yosi//fWUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=keGTgzIk; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="keGTgzIk"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7489addd403so2050408b3a.1;
        Tue, 17 Jun 2025 05:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750164357; x=1750769157; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bboBEhTeDelkuNOFpiEgEDZG0DvToOz10wOL5urng2w=;
        b=keGTgzIkrOqq0LXkmre27zHh+OZjSsSZKY/bE1vr3LEXxAW0KIYbVMcQi6fUDA2t6c
         k4Ho7Wc7kDJY42agGI+coZVGghBD5MmwlABj8DQEJvQZPqehqyEX3kaMPGR/psF/1QM1
         P0ocAYPC1JyK19MNn8HWNpWyuHyuhMbEyuzcopMWSPwT1A3UrOw3W/Ep8VlvjHcqSs9Z
         Z10NO4VzbTzq3XYHEtfAZ+bTuTFMncKTg0rBDY7oYSLuV60DMRz9qBcisATqfTPhdsMU
         YTITK36/nJRe5g+WuTUwF+dUhmw44HUhYbWJcPvFnGEs+y+rzp7g+xjIdbXQfgGfGN6b
         83hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750164357; x=1750769157;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bboBEhTeDelkuNOFpiEgEDZG0DvToOz10wOL5urng2w=;
        b=StxkpLWiM7oN5B/WijCo9xBxZJwsVANM2epeQXp4rBvoKNm+o1QUiQ1hDSgVZ1vp2m
         8IZVhBBTpdQ4Z/XJirtqGUXpwYPhGJGsp7pSyEMZ2FxcZcrxykFq+UJtFKXtzbCogO55
         4Vq8/TKU23mgP1U73hYML6Dkv7vvfKtErTrcJ5EltsXQUqLHS+C1x1wRYb0zoJqeAYhn
         7fI8wE17hpVZKSmZMeUhVqOaywxFu3xb4l4rIA+wd2kGhZqWz6h8eKTWYbSx/pDxPGr1
         PrBXqSekyIsIYorpnFRyjfFl8bzqBjeo+A941hUuxjznd2POCtx/wtkgd/zFlAl4JF7n
         X8rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUazAQMPOhsTPORV8QoKYbtsckX6wdzf20Ph3d5N1dV5EBuHqVcHzGdhVP7gWJ7QLRKEhKsszA8PpPdgoc=@vger.kernel.org, AJvYcCUzaTz8aKemaV0LChgwPwSgbAsm3nqYWfMI2EtEDN1JFD6cVbAP1TOJI+kPxUzGzCh3KmvcFzkAl9dp@vger.kernel.org
X-Gm-Message-State: AOJu0YyTVvV4EoMe3+Sp3c8kjR7oZ5mPBKO8w1W7z13E4UeEJH6+igCR
	jZ1YgwZb8PyLRtosVDTTyqPHbD8QpTZmqDbtU6qWzDGxioJZag8gnHDj
X-Gm-Gg: ASbGncss6B7FeRk7LEvnzNWzD0r+J0m9a1dl0y72ZIPMLgvLV662JqrPZU9nd8A49Cj
	ozksMk0FYrnsuwkrqveOojAb277xLaBYrfkMMfzkSV+rf7wO1ytSfif2VpHcClCXgOlO9s48EqS
	Ho/J7qeUIafO7uATY+JGUybS+o8AZSv2SOtkGqcCKb6odn+Tah21QE+OQ3UgZQ3HSf++8fjD1uF
	wGBSKof8iPJuDyQS9leATsaT5+b9HaiwddkSDM0RIvPYgz+KJcLNKNP0jm4GcyV4Q8ptn3bEpae
	mFFtf2UxYyOsHtu4A7szJmUmGMhfhiMdkgn/KnC3ThFK9meiOgwB5i2pPWNMGl8H3RdLPnp2id0
	ao6AkIODy9p5EAPFAhQ==
X-Google-Smtp-Source: AGHT+IEcnAlq96r83hmBuDkaSLgE/L4K81xGQ7b9uueV7j2AKCyIg6m9EZcjORiZ90c5PRRiDwhXFg==
X-Received: by 2002:a05:6a00:1895:b0:740:6630:633f with SMTP id d2e1a72fcca58-7489cf728ccmr20947000b3a.8.1750164357351;
        Tue, 17 Jun 2025 05:45:57 -0700 (PDT)
Received: from manjaro.domain.name ([2401:4900:1c68:884c:5800:7324:c411:408d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74890083bb2sm9005450b3a.94.2025.06.17.05.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 05:45:56 -0700 (PDT)
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: [PATCH] fs/xfs: replace strncpy with strscpy
Date: Tue, 17 Jun 2025 18:15:46 +0530
Message-ID: <20250617124546.24102-1-pranav.tyagi03@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the deprecated strncpy() with strscpy() as the destination
buffer should be NUL-terminated and does not require any trailing
NUL-padding. Also, since NUL-termination is guaranteed,
use sizeof(label) in place of XFSLABEL_MAX as the size
parameter.

Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d250f7f74e3b..9f4d68c5b5ab 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -992,7 +992,7 @@ xfs_ioc_getlabel(
 	/* 1 larger than sb_fname, so this ensures a trailing NUL char */
 	memset(label, 0, sizeof(label));
 	spin_lock(&mp->m_sb_lock);
-	strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
+	strscpy(label, sbp->sb_fname, sizeof(label));
 	spin_unlock(&mp->m_sb_lock);
 
 	if (copy_to_user(user_label, label, sizeof(label)))
-- 
2.49.0

