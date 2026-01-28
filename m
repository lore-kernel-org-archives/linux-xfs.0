Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E3436B072
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613324; cv=none; b=LEf0+IGwAiZwWGI0Gl/1pIwDCOxlOSqSvoQQTsvY/fL3e4C7nWvYIpQMpzEar0VyeMQ7f2BetvrmoT5hoJB1CCuTwa+EqeCZS+lxj6oiF0nIe7oyV4IyFrBhla+6NDbDmgvAE1T5kjlfNcFPGOalYM9xD25ZZjsYmb9V6vwGp4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613324; c=relaxed/simple;
	bh=P1PXfY1ngUYi4NlEIAxbLSw5SttE9xE1pwSRyDhEmc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXrQvtmdvDaTEZDZX3isJ+9hE1t9Vj8J4eeRYpR2OilbMKbaDi1kOEk777wMTWEBHFbREUYHQgJ8wJUiYIJpDB/IeGIcDYrWfdUWRsivpWBHfDNxR8NCi3KJOSg8YY03CI9GBD0yNUx6187Vi5PAA1c+g6b2cMDruhO6+YnffIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fbHiwg9P; arc=none smtp.client-ip=209.85.216.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbHiwg9P"
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-3541fd9dacdso178756a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 07:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769613322; x=1770218122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FxPoZV4XSzeCBpZ1feEcNnG1ObS341KEroflQpuqDg=;
        b=fbHiwg9Pwo8yfLpD6aszCYGzf9EhAFtFiXYpxC4FWPsaJhInmYeg54TdVQFOl2HWzy
         4FMtnq+cfwkGAvYlwEwLIZ5VKJVugUNiCL0GW2hwUvOWbF3zKw5k8+ty7J6dWIPzK/wZ
         U+dtj+xO1l9uy5B+xNqYlzQ4yv2l7sA3bkySYS0YsVx4qEWHxnoWCnqrJgmy+j465PIf
         ICzX2ew0mJDyj+koHi+etuNguQWWpGEJBLjbL7AYPLFPgBK4FOZmMhgLLqYDu0XF1sGT
         I9hLmGRLoObK9FXhsT+czv4ZP/mnocZlPuKTNYhmJ4IbCjta8AENpf8nTA6rEvQOpdPa
         kfsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769613322; x=1770218122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2FxPoZV4XSzeCBpZ1feEcNnG1ObS341KEroflQpuqDg=;
        b=Bs2gGJJP5i+g6FkuDo2f48ZBEpQNxWwqLB+HQqKKKHfbuvm5d4BwaOJnnSJWgJEQVK
         6rJwnYGMKQt9sCiKfiLhnwNzHnS6hQ3m7yuyoKgPbkqUdLLI2l1YL0J4b4K8IYQ0+s56
         fSV+sm5geeP3PDzpx4I2di1wIh0t55Qd5rNOr4j/EVMIcMqfx+e2l0clvfl8E0AMLZ+j
         pe5ITRS6bk0D18Z3bbB/IVMhQfWZOvlduiVgf06nnX8Gpwd+zWagSb1x1GeXEb1Sn5B8
         H8HJH5ojCwjcUp3a4+vlWItcd3WsIVIZ3R8M/sjWDmZPjYRgpzxfjCS9owXNhuu1UvIE
         vqIA==
X-Gm-Message-State: AOJu0Yz2wjse6SXct0N28DFwWB3vszxNyv79E5Xhxq6B11qH4WBKAyvG
	rjn8iSA62H7Z7psRUfUDWSz6xC1TEWBfqx5nB84HIszXIO+TqC0i4ppJQ4y5F1Cq
X-Gm-Gg: AZuq6aJMFOUc+PKhRodLleHWR+QYgJHLsMBOQNcf/8MhfU4I8pI8rskzFYCvEYwpUaZ
	CrY7Wvp1aUhhASm7WsCw4VllUIC+m6yYSLxpR/zqoRY3PKEDImcHYOqlzbd0Lwdj2DI+Bc69G5n
	CWGqLR/3uAXXSF5Uq2GhsDJ5H2lDBJh8pfzDMi6m6YdKYDtPk91ro4kEQu5l5FJuAwiDkg5ssNN
	K/HKG3pFYbhhos/f2Tq1kkCrK1wUCm+jnMlocrWEQqIdm/10y3gJSI4GkX5x8Q8d5RvTuIZ43Dy
	yytbrlqng8klVPvCkJtNlv6bMPLExTYktzjDZVBSb8Ob7n+Kq28EexJ9OXYPJ77s228q4foyr1U
	lncQ+oyDil7RjJdAZufZlRxwP3l5eokGU0ThZaobXi3Oai/Cl31KGFzNRPpIKnVB/aCzNFphc/x
	QrlB7bunVFInhGJaVsGZhZggXVknvGujy2tEhsFBlPRLJTPgtclpm7eppc7hH+e0/C
X-Received: by 2002:a17:90b:3d44:b0:352:f296:26f9 with SMTP id 98e67ed59e1d1-353ffb68eedmr4989869a91.17.1769613321725;
        Wed, 28 Jan 2026 07:15:21 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f2f0283sm3286080a91.5.2026.01.28.07.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 07:15:21 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1 1/2] xfs: Move ASSERTion location in xfs_rtcopy_summary()
Date: Wed, 28 Jan 2026 20:44:34 +0530
Message-ID: <a904c5bcb5b4fc2c7c2429646251a7f429a67d5a.1769613182.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
References: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
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
index a12ffed12391..9fb975171bf8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -112,6 +112,11 @@ xfs_rtcopy_summary(
 			error = xfs_rtget_summary(oargs, log, bbno, &sum);
 			if (error)
 				goto out;
+			if (sum < 0) {
+				ASSERT(sum >= 0);
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

