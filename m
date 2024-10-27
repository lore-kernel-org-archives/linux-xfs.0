Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66EC28F5;
	Sun, 27 Oct 2024 19:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730057755; cv=none; b=ReKGif1BvqEvWito0Wrp1nSIHXI1WfBomr4xXEbufHMVvKs5NJyXcAyDBkvAfBDuMUY8fy8p35+55lCqf0BudkZ4hpx0BbFbQioUyud4sc/mvrVVPHwiGaIIrCtHkHiCa8WizdDCFxyCaqBXkudChvtMkCrWcnAqnf0k3rtscBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730057755; c=relaxed/simple;
	bh=EmSWh3xSmAM5RDES6zjzSSlBGnygje4dYfMLKmhvKv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=koR8XU2j4kYSiMpzBKpaR3JACJ1oaXerg4mp19IQ0Oho4FrGCiROVSOQ07VbNPBH6rbYSog7s54qhbFjHNII+4H3vaxBTAdeTrKjoJT0HgOsbNEx7CS/XXKj9xtMDCI0CDCPotFm+3phydXOuzyVArZCl0ncUHy2I5D/SIHxBzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZedHdQJI; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZedHdQJI"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e2ab5bbc01so558724a91.2;
        Sun, 27 Oct 2024 12:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730057753; x=1730662553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HwqSxNHwODb6IvlEFxHFvLCBRbv93BzZ32A8QUXgGBQ=;
        b=ZedHdQJIwMMEFISHE/lbubfiVNgpo1P2Wn1iUg817BsPAopTSNogn+DI/hc8B1fOs/
         PfwmTLe+2Fut5t7/ULAM+VvfrGRIyWzt0Ki2Vt2CzWuyVT71JgQy9O8OxVLK3L9mMPiD
         BmZ5KIhOPj141AFbdGyM8TvVAn+cf8KvK7Y44Kwrxg7CyRfbL1o4Hz5Q6WhFa0Tppqgg
         0l+rLeFswimmTSHUAU17kEhqWWMierADrdVyOj7h2jyxhOZxXF7nKTH/eEW3MCztDwn3
         b7G9axugfxG0EQubyN2mr0vEKBusPVcsp9ilIYYpJnLfWfrV1k1LRaBYdkeLLPS1atMx
         99mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730057753; x=1730662553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HwqSxNHwODb6IvlEFxHFvLCBRbv93BzZ32A8QUXgGBQ=;
        b=m8jt4mi1dJPwh1EVuUf6QS1rSr6PKWFmZZtydTLKsGSQk0N7LCzxWib0J8B0EKGveg
         6U3Soda37bgLqTJurU6W01NkwuEbxi6w2r3jhTNahy9aMCKmmr3Pfff8F3jqZNtCxZ9A
         cpNZSaQJ3XsvYkLfhh5S73Jgfjf+l3Mg2hYHK0dGDUsz2BkflrPRQyxeEDkja9Py8KTX
         5qXugGErCRHeVKVqln6r+PNBegJLB77jkMYwHH25RqVVRWkKaVMtw+w5oGhck2PcFV1t
         O1Ww/WannFgJWtuDtDWpvmpZfh1oP4bJjMuRUb/AdjvMDZVuOAao+K6LE+3pPnbz1WA8
         cV6g==
X-Forwarded-Encrypted: i=1; AJvYcCUrI0HDYjEsaRixjrVu0dhSSVTLOlmFQM9kfiCsNld4pO1gZ7SweZFaC5bAR2fc4jY5B9i5jl/brNXB@vger.kernel.org, AJvYcCWxKNbNSnvjx30a70A0MKkmuzSJw1Nz/acgfUH68UuZLg7KNx1NAS9lEEZnw3qC1LiSWT6qtdwUjnrSrUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxATi/sCkJQLaLnxbFLeniKegHCzByh+C1xDOUpDqhpQgMDfOLP
	ZqIwEP0E7pT01H8Mf+AAP2FJb7cgW30358o19w+nPOhYmqiIQG2P
X-Google-Smtp-Source: AGHT+IFnpox8/7BeIDqsmu1QYNjIHDlNfclJIiHXqMfENK7pNaSGbRDvq+/+Hfvz/omYQRE/LqyaUQ==
X-Received: by 2002:a17:90b:1c8e:b0:2e2:c1e5:2df3 with SMTP id 98e67ed59e1d1-2e8f12e5b6cmr2789942a91.8.1730057753028;
        Sun, 27 Oct 2024 12:35:53 -0700 (PDT)
Received: from motti-test.. ([2409:40f4:300a:9618:92ca:3f55:718b:1cab])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e77e48ed34sm8371290a91.9.2024.10.27.12.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 12:35:52 -0700 (PDT)
From: MottiKumar Babu <mottikumarbabu@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org,
	chandanbabu@kernel.org,
	dchinner@redhat.com,
	zhangjiachen.jaycee@bytedance.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linux-kernel-mentees@lists.linux.dev,
	anupnewsmail@gmail.com,
	skhan@linuxfoundation.org
Subject: [PATCH] Fix out-of-bounds access in xfs_bmapi_allocate by validating whichfork
Date: Mon, 28 Oct 2024 01:05:27 +0530
Message-ID: <20241027193541.14212-1-mottikumarbabu@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This issue was reported by Coverity Scan.

Report:
CID 1633175 Out-of-bounds access - Access of memory not owned by this buffer may cause crashes or incorrect computations.
In xfs_bmapi_allocate: Out-of-bounds access to a buffer (CWE-119)

Signed-off-by: MottiKumar Babu <mottikumarbabu@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 36dd08d13293..6ff378d2d3d9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4169,6 +4169,10 @@ xfs_bmapi_allocate(
 		 * is not on the busy list.
 		 */
 		bma->datatype = XFS_ALLOC_NOBUSY;
+		// Ensure whichfork is valid (0 or 1) before further checks
+		if (whichfork < 0 || whichfork > 1) {
+			return -EINVAL; // Invalid fork
+		}
 		if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
 			bma->datatype |= XFS_ALLOC_USERDATA;
 			if (bma->offset == 0)
-- 
2.43.0

