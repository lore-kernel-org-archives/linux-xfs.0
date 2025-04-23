Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C9D1E98FE
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 10:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405178; cv=none; b=nHBz6NKKiyu7j9Zc60rjn+BxqPhM5DFIynrhgMxHtRX80/bCpFh0Oupc3HcsqloSbGHL1ETE44wIOsWWD2NZL5384oqSIF2csgLzbfR7B/IPcZdSorEeP5t1y7gHNGdlKnYZkARvaWqTj/EvtK+hPuoi44+eJzUU57GoppQ5a8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405178; c=relaxed/simple;
	bh=mMLzq1te31virs36804coCD7Dug5tO88XowVR9MMOyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6jRTwUuSolfiaWCQfNYW7BUHG/XYPaH19k+5zZ0amriwgSO6Shhjboww2K6PkVpwuUohoywY+5YypC8F6q4GuN8s/Y1fMN9G030SCJVjVgy9KjbcPzZzkhb7ZEoYdG6L6e2aELTTVXxi5qKCB2JCJVUoffwxfhwFmbuDi0eiZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AB70Blx4; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AB70Blx4"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39ac9aea656so7886550f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 03:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745405173; x=1746009973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mMLzq1te31virs36804coCD7Dug5tO88XowVR9MMOyk=;
        b=AB70Blx4R8pb8DvxaLwx20IBYLtzzbX3HGGLrPG7p7JDRo5K0BzbOSm9xin1FdTZsU
         G+vBGcordQ0MU4F4zWTSucbQcgVrmEnKuGwzUalanUx7cAjprNC32zwntfISPO+E31zv
         mQi7DP4HAtD0JDzys1UmtqvBe3x9P/mzvXKwvD+Wsklgx6LcgKB4BDsMpSckK4zVJPNH
         u8PVmS8vsX9QWLYr4cE9eJ2qCBdkDwN1wCNpJ2SjkTDqudT3JXY2+YhIXDtsi0UObhJK
         wec10+uuy24221xv+BnO8hUDK3zgI84yPoTWnEnHY8WHkjk2lJ39HQyuRC/vV0KYlSSr
         4Gtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745405173; x=1746009973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mMLzq1te31virs36804coCD7Dug5tO88XowVR9MMOyk=;
        b=wl951f6Mqs12xWeGg+48x1xDdqyBuCikT9EVW7pohUdJyzSCE9hpSWXy1nOoVpisKT
         2Vvp8HSFrqhFt4Xdg1l9QUUHBBM8s4W8bbDL2WqEjVLPb/EhwEJZoJqUpqrSEvfFX2sJ
         xW5kRf1b3Zf18K4s+sChO4C88sn/LJyLBD5wUWW72VGFel6C3j7qzbwmHuWougCo7Fax
         Pcel21oDuhFNEIt/xkV1XTUeYzLCI1yc2cp/8RiuzPQjG6k8EGdh/M9Imckay5zUQ/nY
         v5e3ANflddiwNyfjuIczr1qK8sEas+Hz8Bk98N4STCmh5TKe1TcwkpQ3pKxnYv3i/OKk
         88kA==
X-Gm-Message-State: AOJu0YwZn3qcJw600h7PtfNATjcLmtbzmqn2yVRQfs2o8iTMRUaJmfDi
	xfTWZmtuk3HA1uF75up9A2UAPclBTm+d44pvti7h6JZrFvLUhbExY/bigg==
X-Gm-Gg: ASbGncvTjmv0xoIN+qw7R/vqTGvaHCkGeYY9R0cfXzLgPgexuG2ATIUi9DDdLVCdxCe
	c4dLEK2P4g0flB4hNMzo/SnJmtOLZZBUAs46A4w8HaHTKBbf3ewuAgoiZ3JfwPTBrbi2LE3SJfU
	eGImV6apilnkKTF88A07hKRgsKa9N7vp1bQGLqTrheItxPpbYZ5l0XnAOj3pkf4IDkooC5YIBw7
	Z4C7GYnyMRwqYroGT8WQlY3COnR82ObK+4lNFw2nWVARqXs5aM3tX0QwSFhYCzk4Adp57Nu4mxU
	yKAZ05HMjbiqwJy1N0Y=
X-Google-Smtp-Source: AGHT+IGKK1Qaa8tHjQ3NSHh0TN3vurfsXERXDIg/fzIg38ZEPmzbwRuQf1Bt9SMRvELSRLyiIKxMaQ==
X-Received: by 2002:a05:6000:1ac9:b0:390:dfa1:3448 with SMTP id ffacd0b85a97d-39efbacfc53mr15964870f8f.43.1745405173040;
        Wed, 23 Apr 2025 03:46:13 -0700 (PDT)
Received: from localhost.localdomain ([78.209.88.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43ca78sm18214925f8f.47.2025.04.23.03.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:46:12 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v5 4/4] man: document -P flag to populate a filesystem from a directory
Date: Wed, 23 Apr 2025 12:45:35 +0200
Message-ID: <20250423104535.628057-5-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423104535.628057-1-luca.dimaio1@gmail.com>
References: <20250423104535.628057-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the -P flag into man page.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 man/man8/mkfs.xfs.8.in | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 37e3a88..507a2f9 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1291,6 +1291,13 @@ creating the file system.
 .B \-K
 Do not attempt to discard blocks at mkfs time.
 .TP
+.BI \-P " directory"
+Populate the filesystem starting from a
+.IR directory .
+This will copy the contents of the given directory into the root directory of
+the filesystem. Ownership, Extended attributes, Permissions and timestamps will
+be preserved from the source.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH Configuration File Format
--
2.49.0
