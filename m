Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE2D280317
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 14:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770130538; cv=none; b=uNwh+68HL4I8KW2QdWWmh7PhT1a27fAnC/t7EmX3CoK8EHLKhjLaVZUXTQm2CO3M+xaeSd6PwQSWLXQX03sbJ11G2kXCPdYgwYC/gH4bGhzFEQjipZd0eEl4KI+mdl3fV1BjKPM2kSsatkzsGLqHfvtDzDMBNwVKZ+UVL47ZONQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770130538; c=relaxed/simple;
	bh=STvndpUk0fNarVloAdcQ9lEpFP5+PLKjxp+uXvgrr1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPeNLdzV9iPCIdhbnD6X5zWLKulpwAYl0Rod+7ecakhhm2ELs6eKTMVky3n82mOl0slogtgj8S/m5yfe24NDTbKZJH19keIe1mDzlztBVNLhZLMUBuo4YscDyFtdRlu7bUjf/yNTFn+/bTkzzCgEL/Aztf8OWni9aTzr54EBgno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IB0Qey+J; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IB0Qey+J"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2a7bced39cfso60571345ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Feb 2026 06:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770130534; x=1770735334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQwLC5Cnylzqr9et7khNykWSt242Lat12SW9qK8sTo8=;
        b=IB0Qey+JydiossiXEn1n7cExKN8f5tGPhJnPzNHbKBRfOFkx7xBlE06uB2TPsHlwZM
         fRjtQqL9C0izXCwJRxrLCrfnKgl480DHXfVvYmzqKsfAOBLgOC7lqz8LRDZJm3KXTdbW
         K6r+BqvBCwrIali7OkPVwNRgZhXzIIBzU9IES7+XNTpcCRlhaprVLPiOnWLZIeyHLMiH
         EJuswZd2dw2rRFajPWLAeAMH3uBq7mN4LniPF6+VAiBBlAik674McdYzOYumByUGzsZU
         vFOcG4xalpSVUeiHuqQeDwDZDbGKEJSXVC4PEx3xDnbyQ9n4OUQ6uR2HvJGbmagqmX42
         YDsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770130534; x=1770735334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wQwLC5Cnylzqr9et7khNykWSt242Lat12SW9qK8sTo8=;
        b=rVfu8BdAzHGSoNumTpBAam2EPJK+xYNiNUDhvsRjJBWjLZK0TfdN5iyg2s1/heIp27
         eprJVPdKJ5JjWdJFkXBBtAomaqeyUsjCvz3Evm0HWB0ADoBbq4gpuoXU9vwtiD9kSfHm
         X/izXeA66nQU6We32xb8whnSSAaTc7bPwkyFypA3VNrASRzR7uSpEp0LFDmVP83B0F+d
         NsXBISrukzoxia7zQdPLp7I/EsSz7cE1i9k+u+8ipC6/2CKSEQEqDpdNYr6ubmHZgsJH
         D7rT7fLLSITD1i3jFqe6TEHQaaHFb+0TTht3njsop9FEelU9tj0Ty6u2NflJWI7VVxXM
         r4Lg==
X-Gm-Message-State: AOJu0YwCDRYJK9Iv+awgzZdcXoLzDxTnPnK81Bgc+dPS1QVj965lfd0B
	aJw/1vJPdYUCPO7LW5VvgmutriXbfG8iP39Re6TP2p+pk+Jkv1tFnHT/
X-Gm-Gg: AZuq6aLeGCS1yjseV3SKDSmmNoH98OcTbmAlRWJVl8OnaKsk1PtGk72LdSRSJ91MWl9
	Y7+S/fSwdr3JtzPP2thX8+Z4as6wjeA7W+o0DGCT625eSlUIt8+pB9kZbyPlN+BhDrLY73sAm5q
	LZwN+Devr0gyZsp/KMW9a6vU4I0W0dJbBCfB3L3J1pyTvj4BviOOshtmaS/25LxM2lH8xxxhhqq
	YacwxQEh9PFOmhIiOee2XUC1/p73W52k96pdPYoJuR7eYEYWdRAw2DfDRobklCdnS62xcKUzi2K
	gjCVL4fOD4xgzHHMA0/jUmw3P336eb2bYiFjAGoBF67nvffMNPunelpola2Y0Ah6q4jiUIcHDnH
	Unglurqsi+H2UnT/spdSSNyOlQO8BP+ja5HsPXDNL2CmqKT74lQ7xxonayhYbS5XdiwKhNTzgNU
	Je6ahKBkxLCb7aPpp/eDRzZDWbB+Ae+X85XqfZgGKMnP0Qjjgckcd90MzvheQzlWRSHfYtjw==
X-Received: by 2002:a17:903:2a8e:b0:294:d953:6ff9 with SMTP id d9443c01a7336-2a8d9a61f77mr172571315ad.47.1770130534371;
        Tue, 03 Feb 2026 06:55:34 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c4665sm175364075ad.64.2026.02.03.06.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 06:55:34 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [patch v3 1/2] xfs: Move ASSERTion location in xfs_rtcopy_summary()
Date: Tue,  3 Feb 2026 20:24:28 +0530
Message-ID: <476789408083fc88c5fc57eb3e76309439c48a80.1770121544.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770121544.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770121544.git.nirjhar.roy.lists@gmail.com>
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
 fs/xfs/xfs_rtalloc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a12ffed12391..727582b98b27 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -112,6 +112,11 @@ xfs_rtcopy_summary(
 			error = xfs_rtget_summary(oargs, log, bbno, &sum);
 			if (error)
 				goto out;
+			if (sum < 0) {
+				ASSERT(0);
+				error = -EFSCORRUPTED;
+				goto out;
+			}
 			if (sum == 0)
 				continue;
 			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
@@ -120,7 +125,6 @@ xfs_rtcopy_summary(
 			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
 			if (error)
 				goto out;
-			ASSERT(sum > 0);
 		}
 	}
 	error = 0;
-- 
2.43.5

