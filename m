Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6385292936
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770130510; cv=none; b=Y7HfqEkZvgy7rhgR8pV7ZPcEaRbNsT90iaLWrkM3V1Twoo/PDQw2DSnS+MwmC4+Z8QOZq4r3bGcIATxiNH87aA658Eb8KNzRA7KoFUHjnPFISnM3tdLErVvFu79vmru18UfHe/k4WImA54rVJZuCIoH4eo+6Gb5ICEvg7XI83Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770130510; c=relaxed/simple;
	bh=5OE7Y+HTKY5faA7/TU736nCoxx4gUfRBL7vIxtOXEwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ItdKduTe0jp6yrqA/qMtIuU0v9a1LybxsRwi5JMhsNZXWNAnY9AGJ/MVVgxrcPGJAjOLp8OWTWc6rkWtavxRru0zQUTdia8oneRYkNgGs/XhcW+SRdUY3CFVZvm94m3vW9NdIcQai+IT3Rht1pmYryA0VXqifVgkUie04NdtOos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TDHmpHBD; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TDHmpHBD"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a12ed4d205so34797895ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Feb 2026 06:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770130506; x=1770735306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sAQQbVOcFo3KcAJ3VU6If5jAsyIObmkZVAzMcqfkGzE=;
        b=TDHmpHBD8kJV5nj/ZPvZMgN1A0lzfTxvfm8w6GybcXkiC231Li9s9Y1l7I8zg3B1ec
         xZa5pPtiFYmxsqyd42RigJB8Bq2dRQfz7cCIIZG1H4B9XvygHN0L27uX134QmOVTvtLP
         7VSAOJFEGZ23SX6fM8i2fTrDNfequi7md/RqwGCAlkEe5NfkS+pKOUvVgj+SI2sLBG+m
         70RZ5ZnSGq+0HzUCahRbyAKewzyPLl1p6BWp2gGGbABC+fBljM4ceNl24IEQj3/TMmi1
         w9RRWps+ZBoGXiBMmISnuaMWjUNAPe+jjdSpb/f+t9SiWmOOsXF0dJZZAa0x6IaY1E5x
         GVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770130506; x=1770735306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sAQQbVOcFo3KcAJ3VU6If5jAsyIObmkZVAzMcqfkGzE=;
        b=lC1h1Srop4AVBJz45OaYvr/V6Xtop9Pha2lh8heVV2Cylu8jnlq9CrySy4LbfguvG8
         vgjChWtXYeHGUmviwE/pkg0HUT6jDIL1BIQa3StPwak9EW7vB9/wh1dhLKrjFFxCD7QV
         rYwhbhJxj/F56T894nNYDaIpKJI4LbB+HMy30aPmXD/74qu/ViqfKoxD9JffUfZ8jN1V
         0+04CQAYePhw7j4VRjUfaUwD4RTR7K/8CWZBoaoUgJNcFs/R9X1bLhixcxAaftVuCXhL
         CI0kPKwMDEWcYVazfbYNCrfC7iu8Thx0l8JnWpAgRlOvKcvufpHSdDH0a8HkBjmHICF6
         QuVg==
X-Gm-Message-State: AOJu0Yxc7h6ggf7GhuSdiesbRTbbUp87wA9NIIKyiq+f5SB2HRmHEoMx
	kljEeIB4+9AkXaYzDW917NSqOSlGezqF9cxF7FvUmAmQ5kL8DvlvjRo0
X-Gm-Gg: AZuq6aKrjcbXH8na1jpBJMc7UcnyTkyjCDMVvtiypfK+Pc0+iuUYdt3k2VM7U+fNn1w
	EgBOXQrKZJma/73HWGEntISW511zxJkm69dj97/iuXp2LNaIj7kni8FBh0MtKIG/LJ9EctUKE2l
	uv/FrnuxNId+45QGWLRlgNgh6laNGV2vNYNM5KaqIu2YHhJtWcqPWBeOk0ht5TBirV9rvgM4VJO
	/RQLaN37o8xh7BPMA0rm3G4CmSOZ9Fn+hbnwJJC4IEwiSd9rPzyt5a3WoUzpj6Mv5FumM1ZjCU7
	a9Gk9GIuS+1S4m3zvhccLvHVMrG3ZrA1Qgf03IeEqBMgNSM/AcCT05VWv4J9wXrImN0zFkycwIN
	bbdPQTQKKnGsB/ZM4FsTmLuQMauqBxP7rABDMn7bgvZxwgq11y5T56GPR99sgZZfuCnMpbVUxmG
	XPAcIvCt7lnF+i74XFGadkxHrEgPXAD162OunHw+tJqGqqjbikBwPt0HWR6Pd6ETHtRdhucg==
X-Received: by 2002:a17:903:64d:b0:2a7:683c:afd0 with SMTP id d9443c01a7336-2a8d9699a92mr100741745ad.14.1770130505772;
        Tue, 03 Feb 2026 06:55:05 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c4665sm175364075ad.64.2026.02.03.06.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 06:55:05 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [patch v3 0/2] Misc fixes in XFS realtime
Date: Tue,  3 Feb 2026 20:24:27 +0530
Message-ID: <cover.1770121544.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset has 2 fixes in some XFS realtime code. Details are
in the commit messages.

[v2] -> v3

1. Patch 1/2 -> Changed ASSERT(sum >= 0); to ASSERT(0);
   (as discussed in [3]) and removed RB from Darrick 
   since the code was slightly changed after the RB was given.
2. Patch 2/2 -> Added RB from Carlos.


[v1] --> v2

1. Added RB from Darrick in patch 1/2.
2. Added Cc, Fixes tag and RB from Darrck in patch 2/2.

[3] - https://lore.kernel.org/all/20260202185348.GI7712@frogsfrogsfrogs/
[v2]- https://lore.kernel.org/all/cover.1769625536.git.nirjhar.roy.lists@gmail.com/
[v1]- https://lore.kernel.org/all/cover.1769613182.git.nirjhar.roy.lists@gmail.com/


Nirjhar Roy (IBM) (2):
  xfs: Move ASSERTion location in xfs_rtcopy_summary()
  xfs: Fix in xfs_rtalloc_query_range()

 fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
 fs/xfs/xfs_rtalloc.c         | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.43.5

