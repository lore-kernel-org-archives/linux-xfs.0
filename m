Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48A8D53F;
	Thu,  7 Nov 2024 08:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730968851; cv=none; b=Nms1Cy1PRZs4RlcZPaG7spxra6fR9hbj1G9gIqMMNPKrP07smhe+rS846gh5dAOX5ZqevMpOMY8DpYK3XsQwEpo1PVjAzxuMewHcKZWMT6UcRmFrWvwA8Y8ukUwI2Lj7/iDY0ykyrEvBNqZNMCZuKgeP/cPIHxl9FnEyRPrvaes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730968851; c=relaxed/simple;
	bh=uH/Fs9jQ7M26l6TFw/SHi/08lMBwE/9IoaBuDUI+DTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IwSOe5wWDHv2R3ja5aaHmoNi2FMDXP42+NlhFhDNdch3zNupRViRECtm9T3NrIkXJwJc+3tp79bdK5qDcVCu8u/8tjr9gHgQSGQUWYJ6qYAZmoMKOAQUQK6ZYhafh1BCNsi+ta7yT30zNEIavhafeQLOOpYr6iIus+MGY7o9CnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mF0ca28F; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mF0ca28F"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20e576dbc42so8170595ad.0;
        Thu, 07 Nov 2024 00:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730968849; x=1731573649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2ssTqbgt8VC+Hz/A3wbN2uo4y3i5VoN8EJoyRX69Lkg=;
        b=mF0ca28FuuxSTVGLYZyp9j7GmgaUOSxqZMxbE6hz6SVWG/lGMmtNWNRtnh/MGKou8s
         WxJp72CXlNnCra8b/OR7Wg9oweqeWNear73Lu7ZGiso5icSe2RfD5uWb2E0sqKJeaUim
         CAdJt/DCFssCVARAkFyXRea48PjG7gPSYvK68rPI6pnIx5d9B3eYrO1nJTSsT0uyI5Po
         nhYLf9u+DjLM2G/xxnoY+U0/6FYnSuSjG7Op2uAI9ICluTqH0Jmen0u7SG7nchUyo7/X
         tHccD5wec7wEh0xylLESXkpjKpZdU8F6DAPUs3IK0Uoem/ml3iRpan89jIqgIJ9LHCDI
         Av5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730968849; x=1731573649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ssTqbgt8VC+Hz/A3wbN2uo4y3i5VoN8EJoyRX69Lkg=;
        b=nPoVQvcn94aOh4RSTZwVKp9w4xflE2GA5938RV6B8mace0mFu9ykO2hg74YcQB3n66
         HTtoY2V8pzFSUWxXeSK6B7Lj4YxEebYZc6OWvtymKi3R++ab6iLiePgfETO276lvONY+
         2ILYea3GL/pS/kawCHyipmeDn8NeR8wyhGBC7Hk9D825lKRLei2x5aCzCGzMUvci9jRp
         PqZE1cBxxjBcygjN7e+fXoxcyV+KMm4VHly3rSZLEJs6oModxXfByujeExO40yYxaLao
         bsr15hEEyTGcYaVR6jYHriJpZKEfVUi5RJjm0pSNQXfmBF+oh6eMB7wbF1aJw0IP4XYD
         MxRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAYZiM0PACWSe1Mr/uop0ECRhJ9UKlVmcrooAN+iP2683+MSzhm6M21U8U42w/XkV5w5NVhkShRt5X4mM=@vger.kernel.org, AJvYcCXpt296M+wzO2jpDfAN7CIWOYXgVT4DQ3rdDcCCYVA1yNzatzTKr2C8R9dwiJ4PgGvGyVTLLXMU+nWk@vger.kernel.org
X-Gm-Message-State: AOJu0YyOftQGiPaqkxfjmU9QnaB7Hfb0/ukbsIW6rPSoFE/1m4fVSGmu
	y7dTxMxiJV3ar/xPjMQj3rLNNX6aXezj6mBn6S/S7C7X5PjBtiWAbXJr5g==
X-Google-Smtp-Source: AGHT+IHcgBNVtElTEKZ4qIeE6FSApOKKvWtYxw3NQaQCOlT/r1O1qZ7ydcvoKAN+R0lbbSTIzyZOuA==
X-Received: by 2002:a17:902:f54e:b0:20c:a175:b720 with SMTP id d9443c01a7336-2117d20c784mr2254125ad.1.1730968849098;
        Thu, 07 Nov 2024 00:40:49 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177dde2e1sm7191325ad.76.2024.11.07.00.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 00:40:48 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: dchinner@redhat.com
Cc: cem@kernel.org,
	djwong@kernel.org,
	chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH v2] xfs: check the remaining length of extent after roundup
Date: Thu,  7 Nov 2024 16:40:44 +0800
Message-ID: <20241107084044.182463-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In xfs_alloc_compute_diff(), ensure that the remaining length of extent
still meets the wantlen requirements after newbno1 is rounded.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
Changelog:

V2: Fix the error logic

V1: https://lore.kernel.org/linux-xfs/20241107070300.13535-1-alexjlzheng@tencent.com/#R
---
 fs/xfs/libxfs/xfs_alloc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 22bdbb3e9980..1d4cc75b7318 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -393,7 +393,8 @@ xfs_alloc_compute_diff(
 	 * grows in the short term.
 	 */
 	if (freebno >= wantbno || (userdata && freeend < wantend)) {
-		if ((newbno1 = roundup(freebno, alignment)) >= freeend)
+		newbno1 = roundup(freebno, alignment);
+		if (newbno1 >= freeend || newbno1 > freeend - wantlen)
 			newbno1 = NULLAGBLOCK;
 	} else if (freeend >= wantend && alignment > 1) {
 		newbno1 = roundup(wantbno, alignment);
@@ -414,6 +415,8 @@ xfs_alloc_compute_diff(
 				newbno1 = newbno2;
 		} else if (newbno2 != NULLAGBLOCK)
 			newbno1 = newbno2;
+		if (newbno1 > freeend - wantlen)
+			newbno1 = NULLAGBLOCK;
 	} else if (freeend >= wantend) {
 		newbno1 = wantbno;
 	} else if (alignment > 1) {
-- 
2.41.1

