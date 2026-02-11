Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2180A3254A9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Feb 2026 03:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770780561; cv=none; b=X1C7EfKnmtnbEOYjox+kuHD1xwKtssB4WXD4KgkSLxCEugXXYfO581MNgTnkUZDqNplYIZOicb3HCOqoprqDfgIDRdZl8iawLUnhkN1U9fCw+KEiEArfOTohlTEnY9hV0/B4drltekc2VxPPsTp9+7a9tbgCu+S2m8oS+cxvB24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770780561; c=relaxed/simple;
	bh=njvnIABoUjFTMgHKcBGwPMg4C9PrgykI9iO3D9vaxgw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DjVtDvWKuwaStVy6Kkt6SHq9LUyCde0HoPdnCbhfgA6t8nQhHYRpipme2hGHpNDzViR/hgVWvIulGvfmWBj/KkY4hz8dbLPyGcVQ8/w5hca/uyddLQmgiDss33AP0If7GVAJ9n7hR9wV+oRwRKeeti0JLxfdECGdduaFnp4QJY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hi+pkYEG; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hi+pkYEG"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso5289514b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 19:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770780559; x=1771385359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LfA7WO7YBFZhvaAr1Ry7lesoQ7RXyVJx9Hjz3WPrYxk=;
        b=Hi+pkYEGf3PuYWjjaxjmKLH3flscDopAWEW2kAjC8mgLOqXhZXj/j5BAUEdBN9IFir
         0ocW/AkZoiDHE/jVT+OMOjhFYESPuohktJfed0emaHjVAU8qOFYEGt2BLde6CcEBuYCW
         8DVqg7uOq/ddNBzZ18b57VCEYz9QKdjSAPnrKgGyB8Hi7kzvB3bJyVuidZnbpswOs501
         Ovb0zaM8v48+XEjvjvqFOTGxE9p/g/kXOgclLqhnVHTRiHSDkANG4a4KRT676BEQ6aot
         uOgipgCzKywN4OyrKOuhRre77ta764y6MxraDWItX//BNrMGBpOWrLeiwTM9NjFI7AJu
         3gFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770780559; x=1771385359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LfA7WO7YBFZhvaAr1Ry7lesoQ7RXyVJx9Hjz3WPrYxk=;
        b=YEdem3zXETgZmKimI9W34iJ9M0Qx4xC8q0qpyQExUnJ26R9CkXcb5hge8G4gxglp5k
         he35Css6MjcwC0JQoPPA5Hc+xVt3JLDaOA/euuG30+dp3rcPCm0WNjyxYbtknkoFyyRN
         48Z3m1GRdyyl9HSUNudJhSLexsuzg223s3ga4HkbjlWA7AOOzq8oVWfA5kW+St1p0Eqp
         j6Xis3uxmNE3fKQieipcGjSm4WTcw9uwTwp76AHfViMsN1pFfcDTCBWWdbNTi3YyBMxX
         VdEqc02Wkj5VtGNS8rZRMOaRPjIq28INbg6kbPQFKBMKZn3B2eGHSQef1ujtIILi/Cx6
         Ut/w==
X-Gm-Message-State: AOJu0YyJT3/xalTAAB1LJdwSUAskwZM/EeXdjauKqrya5/11RkK6+VfI
	A3ya6ni2AiA9kuaJadxP67qtD+6DEYcJft70bpzKP1TtvM/N9S81Q0Rq
X-Gm-Gg: AZuq6aJoOADTS/Vn/wC582kkNucXGrE3y4CSbw+dxCFAHs7P9PnWoJV2Q4zqOaHCHNy
	iY41tmwXwhHhNq6+/NGMW9pGI5FsHRogxr9Cswmn8jfUGBmeWlPax+bbiBi4HLxGknp2le4VCps
	iw5aeX0auhZQVSIi9tvxzzYcgmrpn7+kuDzOkHNt27lnOJgapUspM28pAKXBmAxIgvfjYKYaMEP
	jQLNLvrUOJUquoTWH8IRDzYuXyj7Abwqxtz6yOmWf05MFK0ONWn2DWzbFxPvrY3aeARfdYM2eMU
	QKVVQ0B4IfY9YKVflkY74jwilep5cJPL4B0kyYI8FbUigEEcs6ltJ49PnTv24tHBiX/g9vX14b+
	fBmZeZR2+UQa2GzYtV8vO8mfs3p3NyeTz9UEaOg0LcK8aCa36ommSQ/RoBjoT+utRUzueNJO6Uc
	DcTgpW5mE/B13tc4I2Ex2N5a5EObBaab3Rt4f2Lo0U+VotDzAv5QZ76yaItfnZ
X-Received: by 2002:a05:6a00:f92:b0:81e:c5a:8c25 with SMTP id d2e1a72fcca58-8249fd1ca96mr554354b3a.44.1770780559458;
        Tue, 10 Feb 2026 19:29:19 -0800 (PST)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e8473fasm439521b3a.55.2026.02.10.19.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 19:29:19 -0800 (PST)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH v3 1/2] xfs: remove duplicate static size checks
Date: Wed, 11 Feb 2026 13:29:02 +1000
Message-ID: <20260211032902.3649525-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

In libxfs/xfs_ondisk.h, remove some duplicate entries of
XFS_CHECK_STRUCT_SIZE().

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
V2 -> V3:
	- No change
---
 fs/xfs/libxfs/xfs_ondisk.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 2e9715cc1641..601a8367ced6 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -136,16 +136,7 @@ xfs_check_ondisk_structs(void)
 	/* ondisk dir/attr structures from xfs/122 */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_entry,		3);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,	4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_unused,	6);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,	8);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,	4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,		3);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,		10);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
-- 
2.53.0

