Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF711862B8
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560535; cv=none; b=PW6jweFYgtMW4u47Ise2uHGkYb0TIV1J5u9QosfHpxlfpR0A7BE9lcMXHnZ9CB1Hf/Z92kSVdEUVz19CmM6TXweRijS00+NeZrMKiAC9Qdg8GrhuoD2gpt5lJ0hJBGg1uHP8mwkatQNJiFgGdGOsHoJN//KWAdY5S9VIn1WLTgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560535; c=relaxed/simple;
	bh=uvE4HzrMKfxh6m+ETmTZoE2Jqwp/Ub9SrGoT3o2Uoyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcLWpWjLflSgtJdOjnFoF+A7TyDNRtFM68dYXXZ8+fWvBzcuIdAmhF+0OUGthc6tCCjhmDOkmsPLRoCDdd/ELLXKEMn0xHbNKp/y47PXr/IZwPJn+vAqhmBTzpuZZehI3qu25WGYQKIVri1ILMTnDjuc3ae0pw+16wT5ZM7vphY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YcgwJSgy; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YcgwJSgy"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2054e22ce3fso11515015ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560533; x=1726165333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wl6kbP3NCHwsQRnmoY7uhvBICT8XJepGXHRJAGbl0Vw=;
        b=YcgwJSgyXAjd4flKIJIG6dog6Hnf+qmMsSOEMZMT/uUfXGH0Ze+OgjNqqyEJxPxHFd
         K+q5R4WtH41SojFpMy+baY09iHn2qUiR+ecBHMLY2bAiA+We924XNZbf2NlOCcC0BYsr
         Q947sllFhb/Sa4TGz569A9p/HJwF0fqPuLIW2O0EItU8FrDzOnRXRbVzKod02W2E+Hvb
         jJTCv/w9QHmKNavbF5Jc05JEVGSGS1L0SeDwtQlTH0IpNgfNRDslelyQaNLyuNvh5tJM
         Uw+LeF+C+dsmWKjtLGKo6i0S/WDHiyw1+xH3IvxcF8hVYsZQC+2UV0KcwxeVr4oeGgXQ
         1Q+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560533; x=1726165333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wl6kbP3NCHwsQRnmoY7uhvBICT8XJepGXHRJAGbl0Vw=;
        b=MoGxiqNb87rLOFeSfKdHf7EV8XK3DxSwO5ZYZP4pi0EzyBcA0rik5L4UJnNLGIwDZo
         QTvyhQXoBOwkVa8zzEJC2joirGNWBD8averLROKE3LaV3WgYNYdaHwsthTKIbWo/YS2i
         4VdHEYOTXJszjFlB9ftHPlbKyOZ188vmMHltanZUs6VpnTFWbpVfHwu4IsxP9M3OjTw0
         wVMuAk9NTfYppfefHMzCYObLaPBj0+1eiUIlVpaL9B5kTCmJEgHAI8AKYrk9WOMxsUES
         PTGvpN/FcOO0IjN/51cl+Kcj6S48kc5SggtFBpIp1TYJnlHybwKBvLe4OswZE5Ak8X2c
         UhEg==
X-Gm-Message-State: AOJu0YyPh0+9u1lEx5k/xusrQmgKPuesZsi5EkQLH4A7WtZqvkKjH+On
	V5YkcMGG5V9aeJjxlwz1zQTtIE1zZwF1Of74gT9aCUlp1SccoexIVAxmNSpS
X-Google-Smtp-Source: AGHT+IGPJpGa80cSZzb8/TQUGsIqmAWNmT044iqk0HEYN/a/GeBqocxJuEY0Fb0767pfxI9K9KA9Xg==
X-Received: by 2002:a17:903:2287:b0:205:68a4:b2d8 with SMTP id d9443c01a7336-20699acb7d5mr121888335ad.11.1725560533251;
        Thu, 05 Sep 2024 11:22:13 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:13 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 21/26] xfs: correct calculation for agend and blockcount
Date: Thu,  5 Sep 2024 11:21:38 -0700
Message-ID: <20240905182144.2691920-22-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

[ Upstream commit 3c90c01e49342b166e5c90ec2c85b220be15a20e ]

The agend should be "start + length - 1", then, blockcount should be
"end + 1 - start".  Correct 2 calculation mistakes.

Also, rename "agend" to "range_agend" because it's not the end of the AG
per se; it's the end of the dead region within an AG's agblock space.

Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_notify_failure.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 4a9bbd3fe120..a7daa522e00f 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -126,8 +126,8 @@ xfs_dax_notify_ddev_failure(
 		struct xfs_rmap_irec	ri_low = { };
 		struct xfs_rmap_irec	ri_high;
 		struct xfs_agf		*agf;
-		xfs_agblock_t		agend;
 		struct xfs_perag	*pag;
+		xfs_agblock_t		range_agend;
 
 		pag = xfs_perag_get(mp, agno);
 		error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
@@ -148,10 +148,10 @@ xfs_dax_notify_ddev_failure(
 			ri_high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsbno);
 
 		agf = agf_bp->b_addr;
-		agend = min(be32_to_cpu(agf->agf_length),
+		range_agend = min(be32_to_cpu(agf->agf_length) - 1,
 				ri_high.rm_startblock);
 		notify.startblock = ri_low.rm_startblock;
-		notify.blockcount = agend - ri_low.rm_startblock;
+		notify.blockcount = range_agend + 1 - ri_low.rm_startblock;
 
 		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
 				xfs_dax_failure_fn, &notify);
-- 
2.46.0.598.g6f2099f65c-goog

