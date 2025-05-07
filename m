Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADEB214A7F
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 07:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746602975; cv=none; b=NWpnVadUnFTRgmwbQapLzUcp2bRtbNbge3OiLy3Y8mTfRm+857R/fCIceJSiqdCCIX5MtlVzwmH5LZ0z5ZVwOkW/oh3p/pJrqnU/F2QRltIPWlwv2E6sHOAiQ2LKHeA98GtLoJug1Lev2Brp0bLtZdm87kccfCj0j3DDE10SEcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746602975; c=relaxed/simple;
	bh=8JnyoSCwN6YH/kbof1jNeY04d+YsSlZyYkZmqTN4Lf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O/QRbwE7t5ldJjLuVV8vgJAnWnJ+uQOgMudZzKl9M9cMNPNmwJyQw9HKWLY1vZbvC3RzCI7wMLUpufCHpjV9ywAcEPg5LJhdeft60IvFnVglVuyCbw9arilHGmld1ssbOd1DwxHfQCO7pxEWrLqmB32yrIk+Vkhd4YceD6RjZnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LE6XElsh; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LE6XElsh"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7403f3ece96so8666868b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 07 May 2025 00:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746602973; x=1747207773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z7WMTlZJBL5yPb0eCJTaRwVVREAXpo1dQLU0r2jcO3Y=;
        b=LE6XElshZPsNThURk4xoUOHGpL3WLMgXNNlsNmZZIszLbnpoFgGI4icPCArWl936fs
         B7h8v5qIqooMhr0+D4XCKdT66TNSRJHK8lE2Qw3ROVNthLvKfCyp8oozN/FdOIrQlTyv
         W0Jh45HzP4sFtUusZAjlAAbfT7a/EouubBKaS+DdZAji8nBs2Q1ATP9bpHAmWtDLOv2d
         6KAOEhaE/fVRMNgVdTyZXU/c3zEDJtucGgbynAVErDILBYcZmE8Alfi+vEGmVyuDMo6w
         5ktx6q6Kf9oQfeBxWYh3h3r80DG0wUNUwZZ+ZlQPm+I15kCvVIRA0bjhM0vI/1Gy8edK
         e5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746602973; x=1747207773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z7WMTlZJBL5yPb0eCJTaRwVVREAXpo1dQLU0r2jcO3Y=;
        b=J8wul2Pyhpm5eBOQhixhWoKQddSQwJ+RjzPK+wUnMzcDgPR2mrHAKaD1iZaIHaI5Yf
         wBRp++evSuWoDMcAC8zfjt/9RFf+Vkr7PTVQHxIUI50MmcfC2r/m+jtvsMPCFxyYQdaN
         3VttR431Yp/J6pPfptx4yYMuzDy946z4iUH5AEYbmLqw4s2ioo0TisbtOlOuDCdu7JPN
         VrYhbIc376FN4GX8oYa/rxxutdnCJvwZ/4QS7IvlVWFP4TQYiX9Uuz5j6889uf3Pg05J
         zBNHd6gQE1keQGUNQfxFXASf0INXgUambiCaKBRwpgP+N1pkq4TnyGLVTB9ply+DkCPO
         hf7g==
X-Gm-Message-State: AOJu0YwUruD139a1sHCjL4rJOf6f+JrUmW30Ekc+ooQbT5hIcaWQ4Aa9
	qzJnHyA42y4gPfzenJ2X8uce4vyE7jv6K/4BkQ80fO9zpMssyaKNHc5T3A==
X-Gm-Gg: ASbGncukePm18vyomyTVSr+LGHrv6TPr1EVAn0PXGZhBn0TstP/xB0M6vrn+odrObML
	UtvbCMtdRLrV5xhZZoQgMZDQufd4IPbb8IV/YafFHsnLMb2ZOWRkjFDxr4vAo84A3V2Zfcz+tSo
	PtJAzSeZ/lpwu+gJfxNj5ZiCgO8YY8fS+oAnk5h0Hqf+21n6ASogq/v9e4Ae4Xumrw9z96DxWoC
	h8kaPloMO3iF9a5veVB7v/I/49sMeaC+6E7nFLJapFR1Bi7MK++ycffEVfqMxUuaxKbCnPOSDB9
	qfFBT7Z75z8Bv6FoBzDDg5HpZANFXPUXobD0NZzM4qc9A+gJyYw0ybQ6HxXZI2ulRIdo1+WecWG
	4a7d8v8982vWdJD6IeiYYuWc=
X-Google-Smtp-Source: AGHT+IG4UwrmePdOYzyWJ23ct+H8fr+D5/155foj1VmJT+woAVSVfRDfn5EFjShGKHSCxtSCZoOF/g==
X-Received: by 2002:a05:6a21:e91:b0:20e:4f4b:944a with SMTP id adf61e73a8af0-2148d0116ebmr4230409637.32.1746602972733;
        Wed, 07 May 2025 00:29:32 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.205.34.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058d7a20bsm10768512b3a.10.2025.05.07.00.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 00:29:32 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	cem@kernel.org
Subject: [PATCH v4 0/1] xfs: Fail remount with noattr2 on a v5 xfs with v4 enabled kernel.
Date: Wed,  7 May 2025 12:59:12 +0530
Message-ID: <cover.1746600966.git.nirjhar.roy.lists@gmail.com>
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

[v3] --> v4
 - Added RB[2] of Christoph.

NOTE: The primary reason to send v4 is that this patch got missed in the previous update of linux-xfs kernel release.

[v1] https://lore.kernel.org/all/7c4202348f67788db55c7ec445cbe3f2d587daf2.1744394929.git.nirjhar.roy.lists@gmail.com/
[v2] https://lore.kernel.org/all/cover.1745916682.git.nirjhar.roy.lists@gmail.com/
[v3] https://lore.kernel.org/all/cover.1745937794.git.nirjhar.roy.lists@gmail.com/
[1] https://lore.kernel.org/all/Z65o6nWxT00MaUrW@dread.disaster.area/
[2] https://lore.kernel.org/all/aBRt2SNUxb6WuMO-@infradead.org/

Nirjhar Roy (IBM) (1):
  xfs: Fail remount with noattr2 on a v5 with v4 enabled

 fs/xfs/xfs_super.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--
2.43.5

