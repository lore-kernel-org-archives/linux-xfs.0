Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855D6139D04
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713299061; cv=none; b=UTY5eU8DlL86i4HFhO5alR+rZxd1GOnsxDDaK98Ei4iK0H9zU2k/F3AkTBRz3uBF620ZPXxB0BSfgRlcsdyQAkQgvV58NQALw9NXSXROOutytx0RI9aZ0D/OxaFM3ygitiOYNMferBGpEaDK4cBHDXlnMHV5ICcdvxRJRLd1SX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713299061; c=relaxed/simple;
	bh=97jwknFT2QGNSM/B8p48WLxBQt5ki5hq6vgfr73ABcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4UWfx1G0WDhMbYfVJ4FVpjYLljvefUalVzRPJWvDgHj1UJX1RpgEaQrBZjI41GyEznYLMw6CnXPm/Z3iFDrOsnNzF8dhJFk+XXoVq5re5pfgh4HIBnb0jXyK2TM0t+Ix23TAVvYzNpTYG4D8n081fKTdHrgCB23AyPiRxD4ry0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBDO0QRX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBDO0QRX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713299058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=prY0xi3n/FsFGeqJC4zm+mMUkmD21tId1Sz88Dqht+s=;
	b=SBDO0QRXeYzWpHbdj/0TBB1zVUwZWoCCOWu3Y/k/5tDhdkeuN1pGzdVdQ+D8JMsV2WGni/
	X05qfmS/rJMjwqOV/4PDBQd2oBYTmm7ycRpXWIJ+Vk+B/098qfBdFWAVJFfEst1shAEu9S
	iB8hsOIZ8E6pV0fq7BUO13dtqhf/vwU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-K80pkCu2Pg-iSHKlB_tCxA-1; Tue, 16 Apr 2024 16:24:17 -0400
X-MC-Unique: K80pkCu2Pg-iSHKlB_tCxA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56c3dc8d331so3779075a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 13:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713299056; x=1713903856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=prY0xi3n/FsFGeqJC4zm+mMUkmD21tId1Sz88Dqht+s=;
        b=nG2+ozRY5cRSc402lSR6CIKvxhjnhqywimqhdgtGsqWAlK8Gvm3uxUobTvh630GF+7
         f23di5qJGFBDbOCEJk2FMkeELyxNZ1282lf2rPP0FGhPrr1iPqzwklSbndk4K80Rgsv6
         /ZeAY3w3RPvr0zjKYle8Ls4VjKTMhEU9DsUwWmGZZiiKCiHVKzOdB3vwccsa2sOZQf6m
         C6djWYDqUt9QVvJ4rEJKOacHh+Q1lk9V3T1jourLEaoUEVRP1BYupC/1Eqvf4hk0+vT6
         GIPbMjO1vCKsnfNRPnweGOUNlSWYL1c72+08DT77wRNWw9M9fuvlyqRT9CUJvn75uEzT
         4XGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHt9CR6M9CuJbEb+N4mfQ5C7rrpoLJVdWSfZ/dAFbGdLDtwVx8NIW8IUiycm6oknD6RtvQAe2WE7t5jXpobSEL8S9H26Kdivby
X-Gm-Message-State: AOJu0YxmoGlR9x7HK4MdHdqKW/TuU7e+czLJe5SE2LdxUn79QZ9RMKO+
	paCrPcrRvPpyVMBiRQerVIb0XzqxD/3EaPPYGDey6XWYzFAqfeZ7dlu8UDFtxdPbxVONgSqeHzk
	jTU8s/z9gylqbvPLKZdC6/2jFNLMba4XopBaFwxW3qX+Q8u3e/wJYy2ap
X-Received: by 2002:a50:cd5c:0:b0:56c:5a49:730 with SMTP id d28-20020a50cd5c000000b0056c5a490730mr8938068edj.19.1713299055703;
        Tue, 16 Apr 2024 13:24:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFN04onw7xzoZw2QseyykqfoRq9zAr6de3cxcSVDv6jimvFC0C33/Xddr7mkLXJf+TUpYI7eQ==
X-Received: by 2002:a50:cd5c:0:b0:56c:5a49:730 with SMTP id d28-20020a50cd5c000000b0056c5a490730mr8938059edj.19.1713299055198;
        Tue, 16 Apr 2024 13:24:15 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id fe1-20020a056402390100b005701df2ea98sm3655687edb.32.2024.04.16.13.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 13:24:14 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 1/4] xfs_db: fix leak in flist_find_ftyp()
Date: Tue, 16 Apr 2024 22:23:59 +0200
Message-ID: <20240416202402.724492-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240416202402.724492-1-aalbersh@redhat.com>
References: <20240416202402.724492-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When count is zero fl reference is lost. Fix it by freeing the list.

Fixes: a0d79cb37a36 ("xfs_db: make flist_find_ftyp() to check for field existance on disk")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 db/flist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db/flist.c b/db/flist.c
index c81d229ab99c..0a6cc5fcee43 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -424,8 +424,10 @@ flist_find_ftyp(
 		if (f->ftyp == type)
 			return fl;
 		count = fcount(f, obj, startoff);
-		if (!count)
+		if (!count) {
+			flist_free(fl);
 			continue;
+		}
 		fa = &ftattrtab[f->ftyp];
 		if (fa->subfld) {
 			flist_t *nfl;
-- 
2.42.0

