Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1C4213E67
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740074189; cv=none; b=g7aeB4Gmkdu7Sb6JFASD/PIIqCd2QNwR4eq6ppN7Xf1UfNolVR558zMsI5erZJZBBSB23QQdjKEtY2uBdXbPPQUc0v0b4EUEX/9bsTpCjeBItQDqvfBUtfMqVnh2wO/mpUsRHblnE/MM552JPteftGlSpQJG+cbhsJA7DCuD5ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740074189; c=relaxed/simple;
	bh=9KRAqBv+78MVU9FDvVLH2AnxA+w3SaUEknFkNYT1qAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5aLd0WvFdJ5S3EmaEtsCgvS7Ev32nKCW9chfa+edk9PWAVrADy9OA+VOrez6FMsJm00FoO49ymeCe6FPdJJbPJudoy6mV4m/0ji/eTFxmZtzMB2R3NLT4ovh57cPR+x58SjEMXsUWVor+tkPnRYNkFk1xyJkTuusMcPeQtz7zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iOfG4zzE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iOfG4zzE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740074186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2F6OZBj2c2A2kdelY4iXjMkzOYXfrR2t0XgyTX/Tlvw=;
	b=iOfG4zzElMT+uZaelEfjzUj1umdsQmVWKFFp9haT/vfs1nKlwE+87/I6nwNk2zAzwyqdgK
	Lv+PTzzgsTvCLxlbjcxSbdDZAJPhWlaGQ6Mm7ydeIaFOKvoKm61qNetl408JK4spQooDt+
	/8h/QTC9H5bG2bijGeWzdycJ9iIQp3o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-y07_SGIcMoC2gzQovPyBew-1; Thu, 20 Feb 2025 12:56:25 -0500
X-MC-Unique: y07_SGIcMoC2gzQovPyBew-1
X-Mimecast-MFC-AGG-ID: y07_SGIcMoC2gzQovPyBew_1740074183
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38f4e47d0b2so601837f8f.2
        for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 09:56:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740074182; x=1740678982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2F6OZBj2c2A2kdelY4iXjMkzOYXfrR2t0XgyTX/Tlvw=;
        b=Wh25ixiEWCShcZs9c+FGUT6N4gjqvUeFr/Qdr2t5HEHUeTV3kCposF+eaZMWpcdNDN
         ufVy0U5+Zi3WnOwp5w42wCLENnptILiox00FJtKkAasEzYLaq7l+h5BFRi/hWnPHFmlo
         STUVbTkhQ1fAcG/SV8USh4bIv/GqzqSNuxZm2qSzDAdEt80Q6jEIRzQ+WQLHBehS6bmf
         i31JrqtsEpZLzVPL6i31OBooO08NWP8ESdVB03jJF4qUCnTH53RqXnSvrrGxXtRUw/Ma
         8paX6sxluku/p1r1k+cJcamDg8XceraCUv83W1cGVdtouJVLyP0Ef9oiJNeasOfUTn/y
         y5QQ==
X-Gm-Message-State: AOJu0YwrvmaLbIHBt61U+9mNlezpetaLyb5NyrmP1Ubg43qlYihsUSIw
	RJtGXqyEjmtEuY4TyFzLW5ocwOv3mY0hV1geOJ5ksdDhiZhnUebPDK08zlf16F45UF/xvnUh34m
	YO+HEhILu8B3fHN1HrPNX0cuMlDJMy47TVYNedB0NjJItWvlMsgwArLjxfBSKwDuKbZe6FbwYlX
	4YP/cRm18MRmTP0qWZpl59wkfiDE1FWATI6uO1Htcl
X-Gm-Gg: ASbGncsQGYUCSYyDxyrQgYrS2KdRmSugYVOaQbUCZ9V8+hWZrVtjOMiuvjWQHluYz75
	XO/RAw69h9wJs1JCvBqcoTwIe8ZfwfFOl5gx2bOztMGvhjH/8i6KAnpOL1fShDf292a0h0BDIhe
	id9NAShUA8A3qYMwprVZ2/y5jFoVH/JQwg1ytmzcL0Srvr9lUpdhmbxCIuhX9zH1Ya+y/OA49OR
	eOXr6lByZAjVEYzj8BJWEdA+CEAkw3TW9ipXpMC1rIEpaN/mAlxbookl26yrJJT5SD3nqXRR23T
	ITyK9cfcTKTdzk+cgVU1cfltYnLp9Fj4bmunjuo=
X-Received: by 2002:a05:6000:1786:b0:38f:3e8d:dd42 with SMTP id ffacd0b85a97d-38f6f0d6ccemr139702f8f.53.1740074182494;
        Thu, 20 Feb 2025 09:56:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdzbu3ok2+UShZRCvJLzAFVEZCooe2iO/mmId8e1GVgEOYMq8OcQ7jz2e8Y2EGxnbugqH3pw==
X-Received: by 2002:a05:6000:1786:b0:38f:3e8d:dd42 with SMTP id ffacd0b85a97d-38f6f0d6ccemr139685f8f.53.1740074182153;
        Thu, 20 Feb 2025 09:56:22 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f8115sm21552975f8f.92.2025.02.20.09.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 09:56:21 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	aalbersh@kernel.org
Subject: [PATCH] libxfs-apply: fix stgit detection
Date: Thu, 20 Feb 2025 18:56:01 +0100
Message-ID: <20250220175600.3728574-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250220164933.GP21808@frogsfrogsfrogs>
References: <20250220164933.GP21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

stgit top doesn't seem to return 0 if stack is created for a branch
but no patches applied. The code is 2 as when no 'stgit init' was
run.

Replace top with log which always has at least "initialize" action.

Stacked Git 2.4.12

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tools/libxfs-apply | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 097a695f942b..480b862d06a7 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -100,7 +100,7 @@ if [ $? -eq 0 ]; then
 fi
 
 # Are we using stgit? This works even if no patch is applied.
-stg top &> /dev/null
+stg log &> /dev/null
 if [ $? -eq 0 ]; then
 	STGIT=1
 fi
-- 
2.47.2

