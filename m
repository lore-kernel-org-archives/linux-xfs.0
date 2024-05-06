Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3FF158855
	for <linux-xfs@vger.kernel.org>; Mon,  6 May 2024 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715018683; cv=none; b=OS5SWQYZvXwQTQiPeEy6RlJAktUlaqLTJBSdY7ytkLLT8nkykiBuh3M1tZn8y6tKu5nki9PGsnTbjaUl1ooVkB0S7T1kH8UHKa2AsSqrF818kWZnsED0ae7QNlJ8AN0k96hQYpKwplHZ6oJpKM4bUFr6iMVfuF5LAkdX5pX56h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715018683; c=relaxed/simple;
	bh=YONtu3IiyU+bho/EpSsb6cY4we1TJnPBM/yTuxcb3dA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fLE/tI1rdD5wl7lvoP6VBvKrMaEjUQFe8CGojpRf8pA4h/xxT10GfuiqUyq29ZQxh6cPW6QIC6yRMNCoKrDAMM0fLHCAEqwLuaV7ns8n8DMGut0phDJcjSlb4ONTM1qaBPRb9P5nUuq2V7Dzfer5PmN2v+bgb/lUvu8V3B5Cf+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B9AgIedO; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B9AgIedO"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6f44e3fd382so1577524b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 May 2024 11:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715018681; x=1715623481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Aj6xVxucLKLGAnugMcJaYCR64t9LFunkvNQhkaYMUAc=;
        b=B9AgIedOFHVmEkms7j3yR3FGacNS9MJaEv/oW/FFzkChRbSLbmO+WHY9i8b57iCPhD
         IIj5GliO41Jt5OZEDDJ8Q2LTRXoU9LvYxTu7Wf7+Wgt2KtXroIw8f6J0RXidugyvSn5z
         1hrTR+yItQOqccTvONIQWeNVnduukjXVOJYjk6OviekFjL/ugny93YMXTmjODzEfAIRv
         bx9MajvOrb/JRt354aRpPrnDM422/54ENF878BJXVDXDz8G6E9HTnzI9N8LCyxKP5SdV
         KqmF1sz8GQMHBjdWKAzunfZcapjo/OGv3xB1GafHoBpXJHxZkI2UQkaE71hYACcLCdng
         mxVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715018681; x=1715623481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aj6xVxucLKLGAnugMcJaYCR64t9LFunkvNQhkaYMUAc=;
        b=IV+ZjGtIjGKzoOHu5dq7bhvyKRDbsTBSgtGHUun2ZDQmbqh3Fer/6zNBRwAAMeuehU
         ebAi6oAEVxHyyQQ8oGwntGQ1Wyvra0gsQZH/5h8vH3Ylfj4tVrHugLpZ5DX1BoEsK1dP
         l+QrKd7CYou611XGiqqZSJDq6t12AGOinRljNGe+Pgw0k9ahF7p5O5HvN5FcCE7/kMh5
         ZyNobPBG49PR9pbErwq56UUqUTzGlY1+5HlskEM+aIL62Onh220sISIHfWNBQZs7aOys
         tsHk73flU/Va8oeq+disn0JnC5tRP6B0Yv7neF723eMyZoGYcpAW0dOE5cMht4RGlLJj
         aWUw==
X-Gm-Message-State: AOJu0Yxi8Ko3i2FnVvSvaWuIgDojnFT/f13eRyTTLD1GoNe7AqSzv5g/
	LLUyUA/FY2T7/mOoOWe3L8sf5JAk4WmhxHqRti6LQDVUAPnIMOucdETIPLiJ
X-Google-Smtp-Source: AGHT+IEUo21Aitl4Vi9B2UEz0gDKm2VS4OA4yz6XYAOpndQdqOFvR/44d5tcGHlmM43VglMFGeGesQ==
X-Received: by 2002:a05:6a00:a05:b0:6eb:3d37:ce7a with SMTP id p5-20020a056a000a0500b006eb3d37ce7amr11372485pfh.21.1715018681171;
        Mon, 06 May 2024 11:04:41 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:f68b:2943:e93b:7554])
        by smtp.gmail.com with ESMTPSA id p4-20020a056a0026c400b006f448272ae0sm6736639pfw.4.2024.05.06.11.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 11:04:40 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1] MAINTAINERS: add leah to MAINTAINERS file
Date: Mon,  6 May 2024 11:04:26 -0700
Message-ID: <20240506180426.692441-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I've been trying to get backports rolling to 6.1.y. Update MAINTAINERS
file so backports requests / questions can get routed appropriately.

Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ecf4d0c8f446..4b19dfb5d2fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22557,6 +22557,7 @@ F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
 C:	irc://irc.oftc.net/xfs
+M:	Leah Rumancik <leah.rumancik@gmail.com>
 M:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
 S:	Supported
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

