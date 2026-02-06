Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC4429B8E1
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 15:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770392312; cv=none; b=DU1caj+7KT/DVUvhBEq3TEH9M8LUba6Y8w0vlfOUJ6hGSYxw0XBnEPDH/uMDAT26U7xUs/JOD51n8sHyp820uFymwlsHyeRR5WFCy17XFVETW8aZS77aHOxLTQ2VHi7bYFPYqaDddsoVlvWoPyizt9/ZDHoxPEwT+XpOKyEfy7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770392312; c=relaxed/simple;
	bh=0E6KGu+BCOGlp6vcpgD764YDOXTf/3TTu6oJLXM3vZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mUUkrf/snQyArlxNVo1ArV99R/xum2t7rKXtDp/pPN2L9YLWLD3tdrPgb+9XaMJ6MWWV2plbz0D7E/7rrRS6PkhXbzSvg9SdcrQ7nDiQDeqCVVHd+lfGR52cxFvBBe/yrGEC8ZpD2f+MycGZ9qBgg65aahlsPaYCjYAxIF6PyjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HUCblToy; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HUCblToy"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3549bba5302so1358966a91.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Feb 2026 07:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770392312; x=1770997112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Dz6wD+7Ugi3o96pX44vNbo/BkfXzNFQKVPcQ4VyxAC0=;
        b=HUCblToy1GPOC3dHmFxtmrtdv+249K4L3m3goUhxK4lJJowQpxSXpcsCg3C8k834ZG
         /O5bM21ehaNga4pa5/qeLKVdEgbXJSk/FKULhY5/sFfieOgUreJPM6AqdU0MnNqfA8GU
         KIQj8MmsO66KCaNVHBnwWkUJLL85QHxhNtQvSWzOdSlg3/WuXbsfgLFQrfxTz88k+c9E
         q18/i1pswPf2wkBg68+3LH197mmwa41l+VTLFRP6/+1/xudCowAGKu/dUs6jF8FTQdbL
         gYfI8LT7zvvzB69IJNarROVBg8EwJ4YJ500RupcEr9XcojVQSbUJ88K4gdDr921q5rIQ
         ONaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770392312; x=1770997112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dz6wD+7Ugi3o96pX44vNbo/BkfXzNFQKVPcQ4VyxAC0=;
        b=ntEp95mpdvclrzpWLn04UXdrRsl59ss7zLS3g/mwh5RAcDtX46o3+93pBAs+D5qVGw
         iH7GV4QE90hcXtdv9SGzTtHoVoAqGHsHffLeQJPrvxC1lKDw9Dnnvc/ME/rALrBhgMjv
         U/3LBcZIgSOZSS0Q4YJ9PgLayTlmPEsCKaQl0V3L1N1PYhm1Cgxb0zMLnrXQRL1ghu26
         xqJ2sQY3s1T2LhCSysEuDeCjCWEmigZkQKgkUwStzheHV064W/gebL0atSkpWOEC9eF+
         dJ45Yy7pQC7Pz9cmts2EKgyuHLXx8s6pzEXwYGVRcKOklgE0nzFXlubEchgsqYaAq2MA
         FtJQ==
X-Gm-Message-State: AOJu0Ywb5Ias+yx5P4r+PxaGY7wZSoLf1f65xQL/EBpDL9VhrO/Oagaa
	9IFuk3ZTikmQ1uIP/SWXcrXS32JSd7gIyzATJJQWGU1lVdZaeb0GSpvP
X-Gm-Gg: AZuq6aIo2uWf/ONXRDJB3+8SacieqsxM+ffghhsNRxVo4uTUjJlhqV80mZ75GmaD3NO
	cnnq27LDLu/ed8PSrHPndA6Ayn8GJS7WPD2KkB4LPqFKkvzpccGCYPkPnCNN+O5NhjTroMzfMM5
	h2kO8oN+AuEgmhFURireA8vws2Q5uakQkpXkvRq/nkjx1Zn7F8E+8EAPkXHmfZwE6pccD6wysy5
	V8R9UsYye7NTV7mve9hKcvwwbbtbrDUTsSGp+XYUT6QvIvYUH7/o1QprZ5kLNZTpiJN+C/RS4aO
	/463BraL1KT3HoOZZCKpSQhi2PfOK9ewImBhbjlF/bM9Dm1KF9pVVSbN6ELatuuk4GUy57anVSs
	fkquKeZ8PJE3Jru4I66Y/OIwsLPExSFLh7UkVmTMFT8ob1UNr4mgfyjfgKe/9Z0rAKkRKMVVTHc
	DlkMZEvreSObk0f/vhnA2/UHWwQRADythYIPXYJRqH3cKlFt5WlsB5mSkZTBu7EHrl8AbW6A==
X-Received: by 2002:a17:90b:4b87:b0:352:c9c9:75b8 with SMTP id 98e67ed59e1d1-354b3e79121mr2248049a91.36.1770392311730;
        Fri, 06 Feb 2026 07:38:31 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c28241fsm6746975a91.11.2026.02.06.07.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 07:38:31 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [patch v1 0/2]  Misc refactoring in XFS
Date: Fri,  6 Feb 2026 21:07:59 +0530
Message-ID: <cover.1770128479.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset contains 2 refactorings. Details are in the patches.
Please note that the RB for patch 1 was given in [1].

[1] https://lore.kernel.org/all/20250729202428.GE2672049@frogsfrogsfrogs/

Nirjhar Roy (IBM) (2):
  xfs: Refactoring the nagcount and delta calculation
  xfs: Use rtg_group() wrapper in xfs_zone_gc.c

 fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |  3 +++
 fs/xfs/xfs_fsops.c     | 17 ++---------------
 fs/xfs/xfs_zone_gc.c   |  4 ++--
 4 files changed, 35 insertions(+), 17 deletions(-)

-- 
2.43.5

