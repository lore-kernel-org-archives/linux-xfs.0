Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1355817DFE0;
	Mon,  4 Nov 2024 01:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730684708; cv=none; b=h2aXuV13mGPzkle/sIEjESWo5bdPde+nkAW5G8fBKrXq3iDoDMz/NYjFZcadPGEz4XVxx1Wxhc5tFKE/XuzzPwkLTToj7icFAXixMOTPG4SP6xeyo2Y/xopIztAUnRe6SHiNxXsWfntWHZobuRvVbbBHEQPw8QoTP2Lha7YqyO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730684708; c=relaxed/simple;
	bh=arn1OCDxZaEgplRAT40oLAkueks9sPLIJ/HqWldOUNU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UxAv20pAC2QvptNaC9QfhngPQPx0hImErXBaMLl/PUw8Jc9VQUJSnwaEQkRrs2PzvMXQeAW7ZOsx6dbhRhwAo9TFl8vdPTGoVqvAVM41NXnaOiCUN8dd3ZirllUwOXBChR0y8i/IFnyd/8noWlQG2CF7bH40wlB7bfG6qnDL+L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M0a8enp1; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M0a8enp1"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-720c2db824eso3356068b3a.0;
        Sun, 03 Nov 2024 17:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730684706; x=1731289506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fbk9rhQrosmAxwMrd6YDiXdQG9wegdoaNo70H/pX0VM=;
        b=M0a8enp1Jdh27FUwPssytq4iTENGPqitKsTwOeT3yfmBw5d+OyUgi5CnsRIn6q7J7G
         5UljHZj4+wet47kbEdeN8FPLM38fFe3ued7/0VCCMauRjabuFCtA6pBgxTzujcSEMbHy
         OFm0ywyol4wBsRzin4lNDTopvKDwcx/xrLbO1D+5AFYivqOusCvAnsartAJBGX+MOxoE
         k/vo6SUuIe9NcJqE8rQZJyFGz7azqafUa7SeN5k1kmP96GCUf7DwVQxUVfBFR7njlnQY
         GsFbbf8LJTONYBat1MT+90rgqpy/JntxF6JjlgVPs2Z6AeaiE6qxuJw8zHo/esh2giMx
         lqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730684706; x=1731289506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fbk9rhQrosmAxwMrd6YDiXdQG9wegdoaNo70H/pX0VM=;
        b=GEZiAHuk8wLKaLItp5MAtRqxcMfqTAt7JjROMdxYAN03mHji8W8/jGo1I4q7Eqdyss
         EcSePtSlbyK8Sq0oiJP2LZ9k/1XsOWkF+ZbEdN4FtRLa1Bw4xZI8q8jcEnyFzyV8f+Ns
         5DpnL6Rg2ElJSl0Y91CcE2Nblj57tuTQd7KrLE9wgSatq7nfe3ws+8ImijU2KZrrrvIU
         gmmXGtvnDV0ozvHQYKi1GZN+0jQFyZMWZF99kLe1NPpejqYQTfGs1mk722CxZ833hfVe
         bYXmRDTZbZkb+Xts5LdSykcd7FvTGJMqhB1HEepsW8ZXQfBUz8OuIJ98gXGNM0f+3a0S
         PvvA==
X-Forwarded-Encrypted: i=1; AJvYcCVSo1G0wJV/cta+OgKuk2QP1I967JlJnqIkRCsftPDC0K9XkK5FygpbxfmYpiy2qfTTN2LOUEiBG+OOlE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzZt++h53MlUJ/8mLJnalBKFGMoMRm1FSWP/z7SpThnT5UbFRo
	EQ5dE9m9MutUWXu0+YG0fOj6NdxIawhVjddAUJDD6shIW1JRO0aa
X-Google-Smtp-Source: AGHT+IEsZPdU8GM1kum7/zaUzEVw6XvTIJrad8b4SerZbO73UnRoT/b4kMshT+eS7mAR2Kt1EenPhA==
X-Received: by 2002:a05:6a00:4616:b0:71e:41b3:a57a with SMTP id d2e1a72fcca58-72063093466mr40197264b3a.24.1730684706294;
        Sun, 03 Nov 2024 17:45:06 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:105:216:3cff:fef7:9bc7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1eb3a7sm6360030b3a.81.2024.11.03.17.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 17:45:05 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: djwong@kernel.org,
	dchinner@redhat.com,
	leo.lilong@huawei.com,
	wozizhi@huawei.com,
	osandov@fb.com,
	xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 2/5] xfs: add two mp member to record the alloction field layout
Date: Mon,  4 Nov 2024 09:44:36 +0800
Message-Id: <20241104014439.3786609-3-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104014439.3786609-1-zhangshida@kylinos.cn>
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Add two member to support the AF(alloction field) for each *mp*,
which means now we can have 3 AFs at most:
    [ 0, AF[0] )
    [ AF[0], AF[1] )
    [ AF[1], m_sb.agcount )

where AF[N],
    start agno of the AF[N] = mp->m_sb.agcount - mp->m_af[N]

On default,
    [ 0,  m_sb.agcount)
    [ m_sb.agcount, m_sb.agcount )
    [ m_sb.agcount, m_sb.agcount )

That means the entire filesystem can be deemed as a AF 0 extending
from 0 to m_sb.agcount.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/xfs_mount.h | 3 +++
 fs/xfs/xfs_super.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 96496f39f551..38dff08b467d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -260,6 +260,9 @@ typedef struct xfs_mount {
 
 	/* Hook to feed dirent updates to an active online repair. */
 	struct xfs_hooks	m_dir_update_hooks;
+
+	/* Relative start agno of the AFs */
+	xfs_agnumber_t		m_af[2];
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fbb3a1594c0d..0975ad55557e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2040,6 +2040,8 @@ static int xfs_init_fs_context(
 	mp->m_logbufs = -1;
 	mp->m_logbsize = -1;
 	mp->m_allocsize_log = 16; /* 64k */
+	mp->m_af[0] = 0;
+	mp->m_af[1] = 0;
 
 	xfs_hooks_init(&mp->m_dir_update_hooks);
 
-- 
2.33.0

