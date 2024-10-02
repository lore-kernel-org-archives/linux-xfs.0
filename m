Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B280119412A;
	Wed,  2 Oct 2024 21:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727903997; cv=none; b=IXWbT4/X8A0bhyPFTi51KmR5d1VyCckNVkGTXV/qC4FDbsi6Qm5hMTnhQyCw8Ci6mlTD0w/7l0xFtJHVCymmiLdzdnvyQ9i5clItrW+mLXyL790EZXAHkqFF/uqlys8Tm81GlITQolWcsA0mQObdlGNUskrxXvtL8F8IevhsfUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727903997; c=relaxed/simple;
	bh=I9FXEKAJnEUkwtjfQbtGO0IypUxqf7hYkkFFJRhHZ8g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DHj7EX0SZvMMygRRYbjZn/tx2KjiIVYxqCuO7/nhkz7Ub5xRQ/wA3Xvj5PrqFRRenFYTL6k7dovfXNM/ez0WJkvQcs/9qNqEXe/mpjQcZ//qXUj1pVazXgUpUgQpbTqLdwrygV/5gTOizEk3OBIaSt7KqyUgtPM75/mTtC8bKcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=in4LBz2K; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="in4LBz2K"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42cba6cdf32so1878175e9.1;
        Wed, 02 Oct 2024 14:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727903994; x=1728508794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OAiYB3ipSAdMMFVVXVLuGAfh+tfJPdeakBwHtHt6Yng=;
        b=in4LBz2Kx4go/sR8iBQc9FxJzDAYPsQZv4wBo+oVEHF96ixnNANHM70vDadT3Z8Slj
         i40wqhNOmKDkwEnQLi03lXAzT1wcN64ZarC5EgMd7u4jTYGGtDF7PXsCezXrSKCxTW11
         050tAESwknCPU/MBtpldI0NnW+yGL4NKvj9QLNNXMDsro7Hgv30xyqsh2r37pKq5WcnQ
         leMaUcroOlMZIpOnullM6P1Kq7lMs0dzbFWeST4bSPUN/359Zslkd6DWseGsxjVef/2J
         zQbg/zUrAvXLV4eW8Qyu+KrvEHu5o3MZlVX1sKD4WyXB7rvwJ/Uj6fn6USKOzlXnCoUI
         fqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727903994; x=1728508794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OAiYB3ipSAdMMFVVXVLuGAfh+tfJPdeakBwHtHt6Yng=;
        b=roeMURNSZ1qs5xssSCXJMJeODo9Azcu7hr7k93+4uY6EeuN5BY5cKcqSYPzL0w9fR7
         C5mHvybXNGmO6emS6z1GCyoP0Oy0yV5B4yRgos374A1+JtKW/zP2kbLIJV8m0uUMMJWp
         3EQh8nosfQGIUGW8y6buX3WPexJbSOhOUTDPd0MHVq02CODWMtSsACXDYuCRvR/mjV1L
         gNiB7NFX1H70Hb9jPO0LhblGDYItvW8MuC3k9ifiTeIgptafZijbeuVVJdeMUNz2K0Q8
         f16OXoKOjeZNVluypYnDQQ7VsEmosswrKjly2Ao9wTaFQ++MfAlxXO7czV8V8qquF0Oo
         t1wg==
X-Forwarded-Encrypted: i=1; AJvYcCUvJQcMt9H7sF2uq/Un5ki6oLl9BQDUsLAPGZ5ozw97sSkl2QCGPh7b72Z4i0MQisORYr0Yrvvj6FEL53fF@vger.kernel.org, AJvYcCX6JDIq3oU4Eq+i5FRmAxvHWq83srMnlBeY7iy8N233NgFS9wGRFA2zAvmppHtHFMQJnprL4gAY2+Smb5+NxVg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxgL+AjPjsVurv5LUytDpH8prxrR+CtCf7tpMx1YPZUYtjcmE2
	oHWc1U5w1VI0hoWeyX1s8EW7ose/+xFXlchiip6ueZZwVgkSnfiWQI6bFTmG
X-Google-Smtp-Source: AGHT+IExqBMO1lJwmh3Wmyt8AYCkoXZ+kkIA+Ye9yKgnlOPmiqFdKuhjwIbcfzYIPTeCRpJPGWnQ3g==
X-Received: by 2002:adf:f284:0:b0:374:c40d:d437 with SMTP id ffacd0b85a97d-37cfb8ce57amr3044644f8f.15.1727903993732;
        Wed, 02 Oct 2024 14:19:53 -0700 (PDT)
Received: from void.void ([141.226.9.42])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd57423afsm14745383f8f.90.2024.10.02.14.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 14:19:53 -0700 (PDT)
From: Andrew Kreimer <algonell@gmail.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Andrew Kreimer <algonell@gmail.com>
Subject: [PATCH] xfs: fix a typo
Date: Thu,  3 Oct 2024 00:19:48 +0300
Message-Id: <20241002211948.10919-1-algonell@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a typo in comments.

Signed-off-by: Andrew Kreimer <algonell@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ec766b4bc853..a13bf53fea49 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1849,7 +1849,7 @@ xlog_find_item_ops(
  *	   from the transaction. However, we can't do that until after we've
  *	   replayed all the other items because they may be dependent on the
  *	   cancelled buffer and replaying the cancelled buffer can remove it
- *	   form the cancelled buffer table. Hence they have tobe done last.
+ *	   form the cancelled buffer table. Hence they have to be done last.
  *
  *	3. Inode allocation buffers must be replayed before inode items that
  *	   read the buffer and replay changes into it. For filesystems using the
-- 
2.39.5

