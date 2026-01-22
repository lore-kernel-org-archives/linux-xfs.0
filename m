Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790B12F9984
	for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 16:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100707; cv=none; b=TAhMpIRVDrNcjqbEHdNHr9H49LFpvyRCFy07Wz+Zp2w1ywpM8aExuL+CEsm1W8G3HKdimcTvZavGwBnA9P5W8qqMl6UiTM0S0NgfIOSOaDzuRR7CcTJp0dpgclh1aUQ7zkZ3znPr1OHiXsrdw+9TppnOUg/VcXrW8FyGm85RFGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100707; c=relaxed/simple;
	bh=PLuMuVV8Xj07JSnx5F6Z3c/q9sbop32BYDCbOPaOa3k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=crnXFJ+g8KuhSCPsqywyCRupF+y2ccUtoypX4Luv5CMiJHIXmsplUU5kXoLdemlqLlAMVA2QJlV+9aPGpU5cz5GWfB29yf1VD30hyZCMSRanPBhmN1oNqhxOWJZY92CO+lSZ7z+uY58wd5+f3/VYymCHEuaqfMmsQvtdwNTwvlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gA4e9s9/; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gA4e9s9/"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2a743050256so7283075ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 08:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769100692; x=1769705492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYrI8gARDC5Yqn6zzY0mWIrBMcEM20q34PGnH9bzmcc=;
        b=gA4e9s9/xyIaoSJaX7H38ZR4XbYbN7kj5IULhGUKHeNfCbwjmFddR+ZCqlyk7E4H4u
         rfYO+ESJdqxUQ2ovQBuc8Yz7j0+MBguckWggwT4psCrxa0YEPlJCuDw0zt7eidorhZBo
         8m4cPTNd39qmfNRbvDlIy5qx68+jcqqF0nfrnWYuMf2hupYHA2EeQoair+3pS3sRfvZS
         6Vq46+R3secvVGMAEUHgAdbK+UE8oCY4wLkCWp94xFEMmcM6Am8nMmpbRDtKHdfaaJWJ
         A0979yc955JTGD5dQHvIPL3fb6hi7AcqBfyF2se5/eFZjr0KxXvOlwU0fMyBHxmyklXy
         LGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100692; x=1769705492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYrI8gARDC5Yqn6zzY0mWIrBMcEM20q34PGnH9bzmcc=;
        b=LDS305x7bwldRiRpNeFHjK7/N4idnkJxm+77aj2Gf4+H0Qv1jS3JYwRW82Jvf03ska
         8345nDd/LjiNqeicZtzKzhx+bDrWPTnVfDVus6aU0z8s9/diX2XMS18yLCQImTe1Xl7D
         3sSG25Ww67PUybrMJJejUaAuug0osjNeH0MlrBGJWc0VxG6ktHKwwBgLauAjxNlTa+Cj
         CSWriBe82EXW6HFFifdJMlDlRj/9SzPREv5erLB3SFWS5WLPOv4n0vxisHMXMSy26lz3
         G95i4MliLfp67GJV7SSGf4+9Ts5KnU86mB0AYhV4eT8dd2mbOb8x+3xzsc+Fad1qPzHv
         3Lxg==
X-Gm-Message-State: AOJu0YzjELVoqgB4THELZfqA4etgKgp38zI24yKeZQarhm3BRi4zEeVF
	Y7gqDJul7N2wVkfCbsN1aojSLS01VGVjekI4+X+Af1KlXvsP93CoedT11z4Nxvsk
X-Gm-Gg: AZuq6aKU2+OI+9ZaxYgjhwSxrPBCQ5TLJZfC+V7P+IQJufakovHxams8W01lkDGy5hn
	VkBuGmtuY0F7qKfQJ5tpA0FaRUtAymAvIgsB0nVDcE4GVi+Y7n0LoLBkkBJ2ND5+LlnGrkGC0Ni
	ZT7M73ULoMpyf/mbqC/pZ7GK/8zu3/WfQwnbchkYf53w2SEd4bGVGhVOrFPXFfNBP7y/P0LKTe7
	+yyQ2BEQdFKkXFtVGRT2n4uUcaVIA/Qw/MeTKvbkl0hsxxsSAPmkOQlO1ShXS6nr6HXcATb+cXL
	+586rsgCudC4AtMLpNYeJkj00KHYQbyqn0UlBE2G4bFNCSyg/tS15lIzDOwlmD7pL/WbJU9gE4E
	4URgOT+tLszH55udjCbomsIaIqk8rd8TKjAyQLwXxMALPiBfATAtpraHQT/JZQNA3EfNN1sDKCV
	Tq4tHTLvNSG62FgDC5RBDK/v2+CfD5CRb5e99eR9sewRcAcqjDIDeRQpyX+ZdkmqAG
X-Received: by 2002:a17:902:e784:b0:298:2637:800b with SMTP id d9443c01a7336-2a7fe625db2mr372225ad.31.1769100691769;
        Thu, 22 Jan 2026 08:51:31 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.204.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190abcf0sm190609635ad.12.2026.01.22.08.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 08:51:31 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1] xfs: Move ASSERTion location in xfs_rtcopy_summary()
Date: Thu, 22 Jan 2026 22:20:35 +0530
Message-ID: <044d2912a87f68f953efcb83607d5cf20b81798b.1769100528.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We should ASSERT on a variable before using it, so that we
don't end up using an illegal value.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a12ffed12391..353a1af89f5d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -112,6 +112,7 @@ xfs_rtcopy_summary(
 			error = xfs_rtget_summary(oargs, log, bbno, &sum);
 			if (error)
 				goto out;
+			ASSERT(sum >= 0);
 			if (sum == 0)
 				continue;
 			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
@@ -120,7 +121,6 @@ xfs_rtcopy_summary(
 			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
 			if (error)
 				goto out;
-			ASSERT(sum > 0);
 		}
 	}
 	error = 0;
-- 
2.43.5

