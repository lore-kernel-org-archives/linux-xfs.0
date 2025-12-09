Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A441F27E074
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 20:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765312032; cv=none; b=YU4WqxU+bbTnceC527iSiofZMqs6odSEe2Rmil3OCV9MU8mOKzP9Pcw4ktkaoeaKgi8ieAvOxmN5Cap2vD1T3eOP91+iXQhR2uEotu2homY+XxYC9Q2TM57VQlbL6D3Oxo+3uXAwoBaKRbxXFlfnaXsO3M7FiC2YNhmrp5KWPUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765312032; c=relaxed/simple;
	bh=2za3BQ7T/r4nWI3O4sk5U2F3BVV6JBZXA937b/el/vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itvcSX5c+p8q+x4P38ZTOx0CF+dbI+BgzcIHBvcWvtOx1oyJ4Zb1ho73rCM9D2B9MegZexkm2cincstzmPvZ1/TluI4gdZrUronXPrLPC7fvi1lpzOllDTYorihkL+EBXb5Tt+VZDo8ib0ZocUG9QQEI001bbXpdVxyZLIJz9hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZB5XN9eC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HwQEZWwD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZB5XN9eC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwQEZWwD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765312029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Gk2RsRN2kQkv2ftjdzdHgJDLDpFlRFaaTmBh8Wpy4k=;
	b=ZB5XN9eCpWxvlSEFLO+/J/7t+qwwJIprzqsOYPYmwD1aIK7VFa7Tssmsj5H9/IgyJVXSnW
	JMQ+PhpYOc9BbuUg61GbUwQeEwYXOuEqZobwT9vv4jJCpdJ3fxPHkQ9HwkszbEGXEXz751
	tWLI4ZluIYkF2tl+ltNyPcMdXYeGZhY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-pZ4fE3PbNOuHHiPgnCNr1w-1; Tue, 09 Dec 2025 15:27:08 -0500
X-MC-Unique: pZ4fE3PbNOuHHiPgnCNr1w-1
X-Mimecast-MFC-AGG-ID: pZ4fE3PbNOuHHiPgnCNr1w_1765312027
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so33712365e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 12:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765312026; x=1765916826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Gk2RsRN2kQkv2ftjdzdHgJDLDpFlRFaaTmBh8Wpy4k=;
        b=HwQEZWwDkjDVRt1zIENdI3of2dU1noTj2aayVOfERtrIqijpZ4aEaU0/AQDyL0uHLM
         z2MOxyrppZzDxk9WDMKuTZ947quYKy5W/o2Kle27SCoa0XEkMuA/b1vi3STsqX5rLFlQ
         j4xRq97LmI0BNIY0mIAlJ+gb0yz7+/M8fWGLhr4bIIPdsLP5vHHueFiWVGr1G0B6yyua
         RzOjPQV1gGUbU13PbnXbaN+aJsU/wt6eknsvdykACxlCOgsY9Iz/5aw2Tsrrl75jrjUl
         K8fLXfexI/jH1BEduUOCbUtJvc8sjhcgVpzO3aML87Ps2Q+j1vjDUoM7DhYMUm46z7vO
         Sjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765312026; x=1765916826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Gk2RsRN2kQkv2ftjdzdHgJDLDpFlRFaaTmBh8Wpy4k=;
        b=M1TsSeO/vAdHynEH+oKzJXE7phmZKt7qJp1xzo/nyCCyjEO1GIs9p4xXsXJFRDJB3z
         iIlU7glaiLCEFsANG4qo1ijUubydyGfhDPX7HbObM6gJIikEP7yzhsyvyDyODlGhVSpL
         iTvifxO3GC7GacVlgqayjGprXxcxd+SqQhgr11MRLbAw2kuNnQZ32mxeq8gYhvscjp/A
         XwbQOgbBTDzHonLet11hVrrAjZRd4x5WuCrB0c26UrW6RK2Uyqh3jEFxiPfFVUBQE85F
         S4mkipnA4bEgVTLirxCOAoeAcBHUio8ft5hgR95ew3V5hhBijO4ZxB20dAK1uPAWW3Nq
         vMVg==
X-Gm-Message-State: AOJu0YxBeJdDNanpvXx3qgwR+QnqCoWkfuRrx4GT6kG1krzhaEEPjatv
	bLD1J6fZlV8aELjZJvmAcaBSZuxYzfBxpNMDHvWcqAQ+qLuc5K/t7d7AV1ZcxO30aaWGA5MCi5h
	LiVyCCDjP3EYlYHjFpsWayrLFmTEOirAxfnkwmLfbHDsPAukAoD/OPq4KMNln36lzSceGp2UtLp
	8iyWLWIrNC4sL7UB6O2weoJGq854CJNry6zZAk/MmO8eF3
X-Gm-Gg: ASbGncse3VjKMWI4t66LlAhDkLVE/KQKJZnAmAWBctqVQzLKqEzeNUQ0zeehVa5SKla
	43pXfjxJyBFY2ed+v6bBoqBqkGBvo+vGfySVeHkWfn3be0pFyqGOAh8friJNtf2F7jbUjzWBxo1
	6VjQB34hl31V94i+NM9kbXPzllNPnUJ4+N0LIoCMlCh43Mt3wbdO8ZJZdK6VoG0e9GG1SpNAbwI
	fuAFLVEjRJgvkQhOVQQ1A/aVflZWyah9ZlXWMd978vw7amOxYyTvBVcqNfDkFqaJBWYvnsKBsil
	P1Dyv4+EY6x+PnGhtVAIUysVfc2xffTn3NYRXulXXPn+KfYT7C2Q1BejepYDYqvb/k7ZKOa8Fcj
	Clxv2eAwh//lLy02xbUVo5Ga0EkhzbQb5WOT9XQ6Sp48pWDA=
X-Received: by 2002:a05:600c:628c:b0:476:d494:41d2 with SMTP id 5b1f17b1804b1-47a83846f62mr909305e9.29.1765312025886;
        Tue, 09 Dec 2025 12:27:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGC+ILbacXYL0Ir0m7TdwKL1l3isD+doQH+xg7it0/0p+/jsrvnIe9Yz+GUhDl9oCEnUXFnqA==
X-Received: by 2002:a05:600c:628c:b0:476:d494:41d2 with SMTP id 5b1f17b1804b1-47a83846f62mr909095e9.29.1765312025448;
        Tue, 09 Dec 2025 12:27:05 -0800 (PST)
Received: from fedora.redhat.com (gw20-pha-stl-mmo-2.avonet.cz. [131.117.213.219])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d2ec650sm25335585e9.0.2025.12.09.12.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:27:02 -0800 (PST)
From: Pavel Reichl <preichl@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org,
	sandeen@redhat.com,
	zlang@redhat.com,
	aalbersh@redhat.com
Subject: [PATCH 1/1] mdrestore: fix restore_v2() superblock length check
Date: Tue,  9 Dec 2025 21:27:00 +0100
Message-ID: <20251209202700.1507550-2-preichl@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251209202700.1507550-1-preichl@redhat.com>
References: <20251209202700.1507550-1-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On big-endian architectures (e.g. s390x), restoring a filesystem from a
v2 metadump fails with "Invalid superblock disk address/length". This is
caused by restore_v2() treating a superblock extent length of 1 as an
error, even though a length of 1 is expected because the superblock fits
within a 512-byte sector.

On little-endian systems, the same raw extent length bytes that represent
a value of 1 on big-endian are misinterpreted as 16777216 due to byte
ordering, so the faulty check never triggers there and the bug is hidden.

Fix the issue by using an endian-correct comparison of xme_len so that
the superblock extent length is validated properly and consistently on
all architectures.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 mdrestore/xfs_mdrestore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index f10c4bef..71c2bb9a 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -437,7 +437,7 @@ restore_v2(
 	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
-	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
+	if (xme.xme_addr != 0 || cpu_to_be32(xme.xme_len) != 1 ||
 	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
 			XME_ADDR_DATA_DEVICE)
 		fatal("Invalid superblock disk address/length\n");
-- 
2.52.0

