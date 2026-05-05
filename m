Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639C9313543
	for <linux-xfs@vger.kernel.org>; Tue,  5 May 2026 22:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778021449; cv=none; b=CaoJt1jFWfPAjZRnVC275KvPP2H3sPva5iUSW5M4IDenN5tmx5Op8LLouwGPeVMPalJnZnSup/T18YF0HuSMPzcseEs+5E5txTlCo7fZGmRDHTIcplgYzN44YiA1D2BN7qkxkrZzM/SUtpCZrO5k/81s+BybYuQMMrEsuZZlB/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778021449; c=relaxed/simple;
	bh=JRv12lRYsbsqyvc3pxn1uVE9cZLZ6GJxKUPYmzFD/wk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Epmszumq1u+tXwrdAEA82IhByrTRFGbj7y1AU77hjlXGwUfhFqklJ4UatYQbfxbyBYv+1JyRL8GR6uG/eikh/rADdkd6esZKwYsT79esnWTG5vUvFJzVGwV1hkaAh2TRGJ1hqxWwU7iilOYGrQp2gzhTj9Jk/3O6Yjywwtmrl0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fp71KwHA; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fp71KwHA"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a0ff30b240so8555165e87.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2026 15:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778021446; x=1778626246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yTX7CA8f4PTXzhU85qwu4yXE6mQp0vfx6y41lfYM6Ss=;
        b=fp71KwHArxN7i2GDo0w1G+hlIMsigT2iZPvpXvx5AZ993+AenUw4zXUhR3CCbGQUkz
         Qnov4CabD2eHwn9OvSNH8+O7dz8sDfMOeSpaZH5S5FT3PcaD6gb2ld/J4YCgybJ211Ap
         H1TD5lFpyVxFIUlZDhmQiFnbuzKeR6ci1p+PhPGxNnjwgL3+eNPHqhGauRXzM89hLRJN
         i7BtG/C6rZX/hj4jQ8rb/Hc4aYDgNy9b2f71Tq3w3+eWIYS6D0eh3wxUeRY36tNlNGpJ
         gG2OOFtmc8kPbfWf3Q1lqr8fjbtkxrNAJB+xar9+L3F/u6vKYBETnsADEvtCvz5IIScj
         LDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778021446; x=1778626246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTX7CA8f4PTXzhU85qwu4yXE6mQp0vfx6y41lfYM6Ss=;
        b=aMXuCHilja8vMjEDlYZo9k+ZSzSw99MgcklpygCh++TyxDlJVLrik9GfYHVoKuC/HM
         l9G4x7kJeVvMX7oPIEGcCid3pOYX7Xz+RR/5cYa5NbLfEriE6aaa1g3lAtq8FgiIzggf
         o8gge79kXNO+WIi2TDo3LBhQMUm0TFXRfcqhDIzlnRg+9XzS7B0ZcGgoTaAPI1/tj1vt
         eQ7fl2D47WkPDbVz2yNpPXYC4quBLsSpiAXyFcVQPRb5/2iUHu9PrCwqegilgDXWH0+C
         WCZJ7zzBiuMn/wl30M7NY6/d157mY5F0oWvqOIadXkvmcJQZM9S3w+yc22jx3WdCpxhk
         tPhA==
X-Gm-Message-State: AOJu0Yxs+v5059dOMDGVQO14pM8OGxuQzCVeVwVEmQp8DtYNFZsa38Yv
	vo6X9GVFNScHFKzr2jOxmseo7ibtQSXuosty1edN0V9tvfvXuHqUHjTgui2pfMY3
X-Gm-Gg: AeBDietNoB2GTL0LmWPtKMVoOUVt0xkM5wD7goZ90/Zn2zfgpegu9FHlR7Xz7Jv65wC
	Lh18yJEBHps5wWfn/7RE/aGvo6pRskAsTNgOAzOfmm9sibce4qlV5AWqLWyiyaA/yUuv5Jy0jFi
	P83tJq1jOIaafOEWlv6hKYokJ44aeTjL2UrKgmZv7JrGVkR/bcBBHEswHb6RHpLPU1FaltuPtnt
	yTfoCbxZwuwEBuQoajoWmhvU/kEing9+O6WB00cQFk0sSWFVhhbT+m9t9GMu0QynwDN6m3B1GgG
	tvBxPxM+5oUyWhxRJircaVmNWhyluDfRfBQLo3rFMHPxmhIqlH8weMyzZcDK07/Xr1h2/qMEZVX
	cu8wdF55eJ0mMbIbDzNXXCVDjuZkZ0lV3tcyEh5l5pC1PMipPmMkSb7X0rClrT6GyxycjI/RIG3
	M341ljgS3yREaNQdSwe+CPQH53jmX7UgFJpndLPiGWcwGepDjupW2iaqzI97th70qnrjVhoT2Ku
	Hw7Cg==
X-Received: by 2002:a05:6512:b82:b0:5a2:abe6:7bcd with SMTP id 2adb3069b0e04-5a887ce3354mr198980e87.19.1778021446168;
        Tue, 05 May 2026 15:50:46 -0700 (PDT)
Received: from Shofiq.home (87-92-218-151.rev.dnainternet.fi. [87.92.218.151])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a85c22df41sm4312132e87.2.2026.05.05.15.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 15:50:45 -0700 (PDT)
From: Md Shofiqul Islam <shofiqtest@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	linux-kernel@vger.kernel.org,
	Md Shofiqul Islam <shofiqtest@gmail.com>
Subject: [PATCH] xfs: Fix typo in comment
Date: Wed,  6 May 2026 01:50:44 +0300
Message-ID: <20260505225044.6484-1-shofiqtest@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix spelling mistake in comment:
 - occured -> occurred
---
 fs/xfs/xfs_notify_failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 64c8afb93..b994ff15d 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -350,7 +350,7 @@ xfs_dax_notify_dev_failure(
 	/*
 	 * Shutdown fs from a force umount in pre-remove case which won't fail,
 	 * so errors can be ignored.  Otherwise, shutdown the filesystem with
-	 * CORRUPT flag if error occured or notify.want_shutdown was set during
+	 * CORRUPT flag if error occurred or notify.want_shutdown was set during
 	 * RMAP querying.
 	 */
 	if (mf_flags & MF_MEM_PRE_REMOVE)
-- 
2.51.1

