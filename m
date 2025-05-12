Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B4C24503C;
	Mon, 12 May 2025 16:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747067502; cv=none; b=u7D+FFJ7olSp0HDa4de0i/XgWUMGLwiVkineGrZAVeu1wN8Jcf0UwMLQtkNvEEAyBYGJUMQh0ittolBF0TuhbUdovZ44NXyVJ2zx2tcQ7s/n0XCtNPEFg+HAC5Gvy5aRkhEo2hj495V4vAQZMe0gvJruOuJG82hn2jJ/YGxlInM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747067502; c=relaxed/simple;
	bh=kclPQ9TevUZcIJQULh5LS5uSXu/weSVP9B4nelw2XuU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=diuwjfgoKHBZiVNmPIlZK7c5JvoyZe63WUb40ADn8F/gwW65zJhqRM2MXPwB5T3sHVr0XPYzcBpknR82eBshhSoI1L8RZsaWE/X2jQGXuYLsgOkGJXsJt14u/ZXfbVnrrpVgDfSCyLSGWKEBeOT7hr3K03tjsWl7Cq/R3meekoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dEqcEFH0; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEqcEFH0"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30a99e2bdd4so4059894a91.0;
        Mon, 12 May 2025 09:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747067499; x=1747672299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qGIV1s6ym30zN/skuQRmS2Erua5b6Xi4cI/Q2r/KVo8=;
        b=dEqcEFH0jh6oznN0sZYYp+SBbI/5fkzgEjW1qgd5DJ7mX2dHvrTxyaf5BuOXFH9IAP
         vpTQUfsIGkHwLDyJ5f9VSSbJf1iHHrsYU8b+KfNSX4eBH1cw0gj1QKXhVT/N6F2zj1/d
         86edjPHmkczfXilursLrZEldK4+9HT22Y6bFu8OMmfJu74xdHwqbiJKB31kgP9wullFb
         wQQQQctS83LJmKBWX95iBNtFb055sF+GD8TQAxsVEQfgo3cBsJtbvSI/oevhLcUjeg1d
         GgHz8etBpU4RHIZAkU6hyb3493bAD2SjfjgfN/6lRq+zHYWnSHCs/6OlwPWshNWXK+oD
         aqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747067499; x=1747672299;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qGIV1s6ym30zN/skuQRmS2Erua5b6Xi4cI/Q2r/KVo8=;
        b=l4HWXLRglo6xuPA232o+Xf4dwF7duf2rsOMdvMeP4wR1env7+/74tR/K1MPQTbxJTY
         Gc0rf3KGy43thWlhSeMBLRnJTJ5HLSVzla6e2tKylmZkHSAjLCm4Ky8Jop5XwDObGMai
         /Z/VMXVoFPfwEH68khRxoG+BkQ5CrCe5qaBe6ZZjUWPh26Gchnu5d+ZUOss3rpsgQE+C
         Y+u18cmZbkEYRroFSVEcdp9D2TD60XMH66TLmv+MpX64KUv4bO43tp+PXvecDp9vzo5e
         WXiP5Vd6rrgpuw/AZxzHdCUBdXvJ+NKDPm7GbLxCiJkk9a4JKeaFnf4DS881rsVIsNX+
         gnqw==
X-Gm-Message-State: AOJu0Yx4B4LcQEDo05x2sL7CJoRbO3HlQb9RAcJyp8TU+NVban3Y50iK
	DvQMTYGolr/sZzfb3pTqTmtEDFXDTsDaldG82I650y9WZlV6RxxTPJ7lBg==
X-Gm-Gg: ASbGncuX87tOgxSTnw3FwdcCbFoV7AXFTunaLFNc9ardkpmUtvNTa+sWYCsvkCBUdJN
	AKNMBd6303xoYfYPoK90S2E5sJU5LLZYsbTY5SbmvZJDL+S71cStwCe86qqBDLgWfWniu37uWAk
	MBS6mbjWJiFXqi1zcxZEyynMxteFlwQ+z2lBcnyVSvsUynNa4bsSM9l2q7/+PW8DWTFZfqxQiTz
	8sMRZOecqMytO+fx3hQNc6R2/yyJaT80x8QI6fNqjBx3PAfoicI65WEASxoCM60ckwucCq9HxcS
	0kAwqPQU1J9abOe9CMMTnKy9/PmvKwrJ+FLTE+EZpk0Hu5Rqmtuk2ZzFO0p2/hn3FE2I03SNzaV
	/DXIVfJVtN71tf0XlwVaIoEBI98z8KBf1ZzIWX6eQAnJk
X-Google-Smtp-Source: AGHT+IE8ghhlp3OdoooiHeP/Eb87BdGjJJ9fU7jaNQK2mAetyh6UXkhg5zgVqK18hwHhtgeLXS9aiQ==
X-Received: by 2002:a17:90b:1a89:b0:305:2d27:7cb0 with SMTP id 98e67ed59e1d1-30c3d3eb4d8mr18593006a91.21.1747067499010;
        Mon, 12 May 2025 09:31:39 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.205.34.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30c39deb39fsm6820150a91.22.2025.05.12.09.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 09:31:38 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	zlang@kernel.org,
	david@fromorbit.com,
	nirjhar.roy.lists@gmail.com,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v6 0/1] xfs: Fail remount with noattr2 on a v5 xfs with v4 enabled kernel.
Date: Mon, 12 May 2025 22:00:31 +0530
Message-ID: <cover.1747067101.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes an issue where remount with noattr2 doesn't fail explicitly
on v5 xfs with CONFIG_XFS_SUPPORT_V4=y. Details are there in the commit message
of the patch.

Related discussion in [1].

[v5] --> v6
 - Added RB from Carlos in the commit message.
 - Some formatting fixes in the comments (suggested by Christoph)

[v1] https://lore.kernel.org/all/7c4202348f67788db55c7ec445cbe3f2d587daf2.1744394929.git.nirjhar.roy.lists@gmail.com/
[v2] https://lore.kernel.org/all/cover.1745916682.git.nirjhar.roy.lists@gmail.com/
[v3] https://lore.kernel.org/all/cover.1745937794.git.nirjhar.roy.lists@gmail.com/
[v4] https://lore.kernel.org/all/cover.1746600966.git.nirjhar.roy.lists@gmail.com/
[v5] https://lore.kernel.org/all/cover.1747043272.git.nirjhar.roy.lists@gmail.com/
[1] https://lore.kernel.org/all/Z65o6nWxT00MaUrW@dread.disaster.area/
[2] https://lore.kernel.org/all/aBRt2SNUxb6WuMO-@infradead.org/

Nirjhar Roy (IBM) (1):
  xfs: Fail remount with noattr2 on a v5 with v4 enabled

 fs/xfs/xfs_super.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--
2.43.5

