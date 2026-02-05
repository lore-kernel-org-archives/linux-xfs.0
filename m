Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0830F7EF
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 08:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770279986; cv=none; b=k40GuVEvLBM7xpoWbvueCGel2BjXLesr3Dj6eVqSihbEe2Wff0Z2NFrMcteGOXxnPXwt28dwGtdNAv+WLdGN3QdZHZOSK4zFa2USGX+IeMw9kciVfQx8+ubw/+661cIiFhCSeKSriUtP96ccMy0T3GILAVCupayXHv50hlI/xQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770279986; c=relaxed/simple;
	bh=lmwFrmN63ymvJSfI84HlcCwiM1bQqFDNVrP9jz7Ntdc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rTnPLMICUhnRKU2RAoA7GfKBOCCj/UsdtGDbt23qs0v5UCDpHUIiL8G0AXmL/TWkVdEHeKolhrnuPaAJqnkxv0+i2QxZrXp8m91a1qfUSHtD7BacJbeuxVK7aXOFeJsyD1EI8ugfi/rBNaS5cHDjS0Uhxr1bIGM5D85LmZ02K7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F5oQck5r; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F5oQck5r"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1249b9f5703so1152427c88.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 00:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770279985; x=1770884785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9aDKO71QQchuiL6O17rzNxM8z2AUm9dMP10IkUlZzHA=;
        b=F5oQck5rXzFGQuH+WKftqhZbsdJLia77PNOyDnCXTHjA8VfWfp8L9OluTHfSLHR3ut
         G/RBHZnyUPqYcgzTBuQpit0uq3xxTdsOMJtvePk35YiBtFPgLCSIvTW7pRKLlFtIRvqY
         mH8SIX/FF1Lp5dkDA85ojtE0TsLEMdngmQClTtCgG6345m2GCEm80SOFjZgXVwBHnokb
         TNO6I03pr+GnSxsTtpt+AMajjz2BqOV1ymyiWzH/3W+txK2Lps5bfgYgB61IoTZUU/hF
         DmiyOaKUZxNlv0spDS9sUtkoAnoo60112XYkBMA5LE23t+BTRhYi3DsXHLVPH6MFgs+l
         M33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770279985; x=1770884785;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9aDKO71QQchuiL6O17rzNxM8z2AUm9dMP10IkUlZzHA=;
        b=vLzXlW7HsmEOEHdxxnOxKl8cm41W0ESCK3bDy3736aOXsH9qIyL9Ql6/cWHT8JYcVQ
         MR41mh0xGbdujLAnTw1RujGasrurYv9QDrGWwY/OaRRElSOdVRo4ysdMnmyJv+IQHFWd
         lga4C/VxNyN06mxUE9CL/SHdC8o06zHlS8z6W203ntc1fY3uCR5GES+X5zLg6tsYYlmX
         pfWDij84zNLZ3E6SbeNS1ObZU7eXL5yLi+kUM9mnScDzto6A5iSz+3mUf+Ap4AJubUy/
         djj/dSht3JjtBA/M28IyTeDv5xIKpIDabOFocH3sI+Q2xPstw1r5ltEsKgLmPhJw04bf
         TQlA==
X-Gm-Message-State: AOJu0YwKNDGzf4CtS0q9VnrPnDCGgRcVlj/Oc9AKiSE9n1hexi5hlvAU
	fa+OMTMCcmywaSK80fD3/oM60MYlKNlNOgAiIaOQKZAm4qPT6bbcr7sP
X-Gm-Gg: AZuq6aIiH6WWAUG25HgBr+568p4jGKqnQMVCXPEMembEfXZrg1/G8jTwj0Fyk7/Rm12
	G8icNBCF8HaZ9ewGBUwUVPyMJgnFystBMBhB9PDUhPAp01eb2DCcwTuHXP2aMgcNcsuHaVANCXm
	GZ3mrxB2Mml1r2UiPJLmAo57iuIgkcGUERAaSXuO6Rn2xHFX8t6ymybaXODNlDtyFP+PdwHxGVC
	5BXaOqYLXl9mVQQp8M43AtDofTZXrit8AeKkTLi71QPssLQVSzaOqdTiHSNmmWyW28WpEm0Bw5h
	wTasv0uZmJmQ8MdUzTbyZBl00iIniWpzghOtH8QX5DFHWg9yAFEDaeX7VkWFL0aSN1U2cGI+//K
	HU0tNS1v62bc6WnICNU9T58XT27ouWuVDFWanIzh2thKqjVOK8PX614b5hN+THdVVJv/jh2kqLU
	rn9k2KNy4FXIyMWPH9uYSxnzw=
X-Received: by 2002:a05:7022:914:b0:11b:38b6:a95a with SMTP id a92af1059eb24-126f4786246mr2781184c88.11.1770279984911;
        Thu, 05 Feb 2026 00:26:24 -0800 (PST)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f503ecf4sm3903960c88.15.2026.02.05.00.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 00:26:24 -0800 (PST)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH 0/2] Add cond_resched() in some place to avoid softlockup
Date: Thu,  5 Feb 2026 16:26:19 +0800
Message-ID: <20260205082621.2259895-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

We recently observed several XFS-related softlockups in non-preempt
kernels during stability testing, and we believe adding a few
cond_resched()calls would be beneficial.

Jinliang Zheng (2):
  xfs: take a breath in xlog_ioend_work()
  xfs: take a breath in xfsaild()

 fs/xfs/xfs_buf.c     | 2 ++
 fs/xfs/xfs_log_cil.c | 3 +++
 2 files changed, 5 insertions(+)

-- 
2.49.0

