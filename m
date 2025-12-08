Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40713B8D65
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 15:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207022; cv=none; b=AHUdL/PZR5eGQmuxDGxVkunwFW+9vqlfnrKSppnuMFKUkSRYH0TjPfiZrUnUwmL/sXARtHuxvZr0LX+MOkPPF49t1gfEfrmeEi0rzZpNL0HZsyH4qtlmL6SkZ/EiO2GqInbXpltl3rRvNENq+XIWvXvIGO0WdOXyF/KASHPOWdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207022; c=relaxed/simple;
	bh=kJeM1B0lFo01CY7l9nbNudHozdt7DIONrCyQbVDiV8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AHp6+c52MZ8q5HRk7WFXemPViE2x2jo/RZl/J/8yNyIU8WbdD5E+fq/Ub9+ZBiiz2r3s0U6P7uW2Edc5rETNhHMshSyFX9HcMYX0CxGA8mS2PPUDz8gmKU+aGhRYNUEuaN6Vva9AckRzoUseRPp6pz6D/ZOATp6pzEaCjkFWIYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kGxQZPp0; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kGxQZPp0"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7aace33b75bso4439609b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 08 Dec 2025 07:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765207018; x=1765811818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MZwJOhnXjR9RH7Jlcrg7Vv/LBvLsIAP2Sb2ddg+1+Lg=;
        b=kGxQZPp053M9tiS6frkUvqophDLDHmEZW+CWc+K51aZBoHI7pU9Fd6B9SK2g1trWhX
         nLRBXh2TOuKd3KWsvffS+Ez5jMKx436GvHikqMqIh/IaRd1eIjoH0jkL8bXcIPFPXPjn
         tmy7RI9FoGg6Q0f4JtSGG1uLzHMkrsfk7o2n+0kyk+KxE8GSrifkM2QZstoNNKGEcnJJ
         DnkcrWtlDVARfyfxjpmRYmhrjHaK4kcO+2NfeXvVVrGkC+qosI+3fl8ws1xq55Jg2g/F
         Mhnq2s6KTInUxR+5l7he3uJi+SZ5CaCTkRuvBlXZWuzQ4/A2v00+ntvZTMuZczAMHEIZ
         IaVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765207018; x=1765811818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MZwJOhnXjR9RH7Jlcrg7Vv/LBvLsIAP2Sb2ddg+1+Lg=;
        b=spWfVvyUGOIOaU2V5oW3r3MqXOcTaILm2KZ7IIz41z/VrbtcO7t0kyjj7zJs59AIBG
         Kn2XtFB52gmETsgIfI4ZjLr2G25glwYGMwNMww9Vr389oHMePvsN01FVrGt8aW80qfIY
         fYDuLW4AmgqETHNN7euMlDE2gpKawOW2s1wMPH5YoMxHPiFRDPUsr891QVHJUwpLpSPh
         dtN8McCdRaGine5HV4b/m9xVg80EUEUHJ2YCs6jnuckbcjyghU46boqa4dFipzdgGL2z
         By7xrEN8CACm9Sj0secbz8fRD49Izn/NC5QfNcL7CyeEEQ235UvF81fKoTTliL8lNGwb
         OAJA==
X-Gm-Message-State: AOJu0YwOiwABZvMhh5sCmrjnoek21RpYFUBwDXcyYl/sXPHnSoB1EXid
	E4bZragH5JMo7RXTLfw5u1FqxehL1OB6vaxdVqr9poyTcj2rF5+Jv3MbCAv6Qg==
X-Gm-Gg: ASbGncvpmVYCOk03bCLBUZSEq2YDfrVD1y3ZawSilLy/ODnDNkS73EWeUjcNGL7XrXB
	3ziQ+OvH7sDKTbCOEsNSswclwmNd0kYrzK20ZfcMrpzSd8B78+JcgTAKMepqoTJwai7fBsAlhHe
	g7O+N0t5UPuw3mHD7d3Nk9UfNk8VSwyT+UEX14Lfu5RN0+huQzdrlZmYN+MIbxar+LcDv+SQNbc
	pTOJlelsqDx4TD2rW5zwMsTtcp5S+wLKPY5u+eqP3scexTtQv1iALU/mLkmARAgwlwrTnJVr4cv
	yjzfMiMVgnuD0PyP/umyWAeEVdpTnlw4BhzdWVxmAuYw1JMgDCWLdRW6owzuSJgXw/V6yV3Rkx2
	SARkIy0JK0dWUKHcAsbe42nqFVkME7sH4HReXit7Sv/gAfJYCuSTimkAZNk/0mrqtYACQPtGVlg
	356NoZnsmd1bpr3OfAJ0saVJEiJNnMB2J4+w/gOv82clBitps3UsxeCoasqqrivTgg
X-Google-Smtp-Source: AGHT+IF4kLgFxpove754PNuUtZvXylfVAXL+I8whI3Rofz5cA5SO+NozMZfGOzysE2VCmiEyVbmhDw==
X-Received: by 2002:a05:6a00:399c:b0:7e8:43f5:bd30 with SMTP id d2e1a72fcca58-7e8c60d9e48mr6752166b3a.69.1765207018310;
        Mon, 08 Dec 2025 07:16:58 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.204.153])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e29ff6b55fsm13586437b3a.17.2025.12.08.07.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 07:16:57 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1] xfs: Fix rgcount/rgsize value reported in XFS_IOC_FSGEOMETRY ioctl
Date: Mon,  8 Dec 2025 20:46:11 +0530
Message-ID: <50441ebab613e02219545cca9caec58aacf77446.1765206687.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With mkfs.xfs -m dir=0 i.e, with XFS_SB_FEAT_INCOMPAT_METADIR
disabled, number of realtime groups should be reported as 1 and
the size of it should be equal to total number of realtime
extents since this the entire realtime filesystem has only 1
realtime group.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index cdd16dd805d7..989553e7ec02 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -875,7 +875,7 @@ __xfs_sb_from_disk(
 	} else {
 		to->sb_metadirino = NULLFSINO;
 		to->sb_rgcount = 1;
-		to->sb_rgextents = 0;
+		to->sb_rgextents = to->sb_rextents;
 	}
 
 	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
@@ -1586,10 +1586,8 @@ xfs_fs_geometry(
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
 
-	if (xfs_has_rtgroups(mp)) {
-		geo->rgcount = sbp->sb_rgcount;
-		geo->rgextents = sbp->sb_rgextents;
-	}
+	geo->rgcount = sbp->sb_rgcount;
+	geo->rgextents = sbp->sb_rgextents;
 	if (xfs_has_zoned(mp)) {
 		geo->rtstart = sbp->sb_rtstart;
 		geo->rtreserved = sbp->sb_rtreserved;
-- 
2.43.5

