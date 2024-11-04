Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C14E16DC28;
	Mon,  4 Nov 2024 01:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730684701; cv=none; b=ojR8/hwf3bZzcnGXrHFZkHl67ZttnPwKfaTburHDw8X05NUTBFOOG4Fk52Nw2c2fJ1REdE0o5Lns+VpXJmhsi894VMl97Nj0mwPZiigh9SN5WiUJ1cilu1bCk+1vWsdevYulfHjZGvxth0W7557gxpCtPGd5C2vB6zqVueLOTe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730684701; c=relaxed/simple;
	bh=7Pp4PBJBD5yxLLgDe9EQ5hpOhYXqkT1Cf7NgbTbHuUw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G4FUhemO33ENQpXyHP+CpeySmBoKIHcDOrvFbAfEIDbJ7Q1SlVtQx/ectaN7Vnadi6xaL15yf1rSi2GwEUJ5dywdAkSvG/P+dHdsM+t8n7siDfLKiGa7nquqDxjxT2lV2UALYQTkasv2KoOCcH1HQ/MDuqwrzeWJxQVyZWzSt60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hAmRCPOL; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hAmRCPOL"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7f12ba78072so495037a12.2;
        Sun, 03 Nov 2024 17:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730684699; x=1731289499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M+88D/OjH70vfTg2OXZg5JI8QMPXka3iA132tE3YHvA=;
        b=hAmRCPOLL53kHK8+nV4eT3yn7pbsNdh0kE1DBG/rbzZMj5HBVkqGirzEKfuNPJu3Ud
         YDT1OVi8Myei/y9m1Y02EpRqYIp2NeVV4J9pw01zGAslDKSvBM2DCDBcLRKkJ7TMntRj
         FPKHUG6SvtHrTblyTwXRwhuckS3jFuzNAjOaqAVfS6bRxWHFS8UCjqxHaZwBI+onNZ4U
         151f7eb9agpbN2Qy1BuHgGNxuFUEVnFNrV6nen/V2hd6HQK9Msv4bGOiSgjeZv7FXXnL
         VrohkmGVCqwZjiDuDxmlm95/USuoNZIjPCebM0UhZKkDDATTybZbbi3neTnXF9N0Fa2I
         4XDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730684699; x=1731289499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M+88D/OjH70vfTg2OXZg5JI8QMPXka3iA132tE3YHvA=;
        b=PazIIH0gVo19Jgjy6vG8W4tHjq502YkZNOKIIgi8K7ou1wYeYrZYpUHqAywm4VxNav
         LhN3cMvzXQUFA3POdpDMncyP9wkuJI/NOBR0PMmQl5YmInA6aGFQIDTYLJtDe8nUZXzR
         Yv9OJW+xZ5vcPlWIpGmZv25CQCpDw8gfK2cPrrugGdfcZ1d1/zZBkGk4x4+LuxuYqgzC
         NYQmeOyR6XmHYSTKzbj7YvssH3GMmzu//KGOwD9OBye1VKoWr06Klx+7pm9GGbUQTPAc
         o3q8tOTdNL44zXwCXKIA0YaepAd/CTpuF9rhYvG+aTayLRDgEg4sV6561god6KZsW4IJ
         k2eg==
X-Forwarded-Encrypted: i=1; AJvYcCXlK/eNhY0esKIwqkaDZFu1DUy7JBUrzkOgBgAxwh3GVZv71ZsIZK+8P5T/BT5Enr5EwnfdH+qhgg2WoDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy68RVpwHAuhhYhPXz+XbE1GYwIAtnSmfTSpaK2guQYlSHH7YPV
	VUZwE0r/5wyVZXFFV4Kaap7HzzobaUZ73Honwq4hyn/Sh7xG6C78
X-Google-Smtp-Source: AGHT+IHa2yJ/bn3FSL0jPq2uBClDUUfxkR7tGn7zwp7n7ppK6tYZdpha2KzG/KTpdGWbtpWMzsQ+ww==
X-Received: by 2002:a05:6a21:388a:b0:1d7:3d:6008 with SMTP id adf61e73a8af0-1d9a83cac42mr39743282637.13.1730684699536;
        Sun, 03 Nov 2024 17:44:59 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:105:216:3cff:fef7:9bc7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1eb3a7sm6360030b3a.81.2024.11.03.17.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 17:44:59 -0800 (PST)
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
Subject: [PATCH 1/5] xfs: add two wrappers for iterating ags in a AF
Date: Mon,  4 Nov 2024 09:44:35 +0800
Message-Id: <20241104014439.3786609-2-zhangshida@kylinos.cn>
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

As indicated by the diagram:

|<--------+ af 0 +--------->|
|----------------------------
| ag 0 | ag 1 | ag 2 | ag 3 |
+--------------------------------
   |----------2-->|----1--->|     |
curr_af          start  next_af-1 next_af

1.First iterate over [start, next_af).
2.Then [restart, start).

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/libxfs/xfs_ag.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 9edfe0e96439..0c6b7fe5194f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -311,6 +311,23 @@ xfs_perag_next_wrap(
 	for_each_perag_wrap_at((mp), (start_agno), (mp)->m_sb.sb_agcount, \
 				(agno), (pag))
 
+/*
+ * Iterate all AGs from start_agno through wrap_agno, then curr_af through
+ * (start_agno - 1).
+ */
+#define for_each_perag_af_wrap_at(mp, start_agno, wrap_agno, agno, pag, curr_af) \
+	for_each_perag_wrap_range((mp), (start_agno), (curr_af), (wrap_agno), (agno), \
+				  (pag))
+
+/*
+ * Iterate all AGs from start_agno through to the end of the AF, then curr_af
+ * through (start_agno - 1).
+ */
+#define for_each_perag_af_wrap(mp, start_agno, agno, pag, curr_af, next_af) \
+	for_each_perag_af_wrap_at((mp), (start_agno), (next_af), (agno), (pag), \
+				  (curr_af))
+
+
 
 struct aghdr_init_data {
 	/* per ag data */
-- 
2.33.0

