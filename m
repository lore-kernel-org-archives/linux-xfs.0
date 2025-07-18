Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD9C4A33
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 03:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752810157; cv=none; b=gBqKojUoMRNXWH7nFzP/1De1zvyVXM9LwvzgE73986t+t9/fKcnm7pISyHqI7T4p0A06jZBngCmom1Lkx0RMlphQpyXj8gIkuIYbHPGPaS9jGYgqw8LfNqMbIxIiOxuCffAunSSD5C2jwcGnzMjrhleLa/ca7IzJ7hSBH4HXP3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752810157; c=relaxed/simple;
	bh=xGUfSCc0mEpTuXvvqwBYQ/kR1sIRfkjxeLOwzaZi5G8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dc/s8PWCEkHgIql+8AA+yYqnUIRoixX4SUGhO60aDxxnLuR8z1OeOUEtz6eiK3O2sr/6/WWq8ktiRBn4lEqoLV1KzkBlma2cpxuJW1bhiJeTDXAH0e8Iu6+oIq6rpGHQ6c0zdk5oShh4Y+QWC7Ywc/XxhryVjQWEATUOU0ahEHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mCkMTQg/; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mCkMTQg/"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-313a188174fso2102869a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 20:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752810155; x=1753414955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8eAbptHiIrg3m7paHMdjGPnPgZ6QoZhxkureZn50ipg=;
        b=mCkMTQg/is0YB1ruyN9aUPF0aipgF5ATdCm7iUGZK3nRUlAVM0Q0jF6fUBVpkN3+ii
         B3VsgE4duk0o70ssIpEtIV3JCShK4iCHEI9CYt7QWAqZJcrzlJhSEeq/HcKipEvSd7fM
         pyUgYCqaEjeYtPnuj0PyA9X3JVmyqQ9vzLB1/la3AiQ3FSpGDBhplHO2RWnxUEsgjGYE
         EfZCh7JayvoR2KelQetpyxQYPNRxF0xLghnomHTnFmf7VdG1armypJNjrdQBBhO/x3//
         HHPoB4p+R2ayx3FUkbDs1V6aqnKKov4g+fxB3QC8rZdbp4IloZGXdjp4nNrpBMOPbXmn
         xn7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752810155; x=1753414955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8eAbptHiIrg3m7paHMdjGPnPgZ6QoZhxkureZn50ipg=;
        b=xK1aNe31JaOY/gim9uE0wyHoMTEejve+1BCgQR/Nf3wJICPRIOYjoqWNHK7IEuG6Wh
         dZDiTFO3BoM6frti7ZkonnlSjTC/dd9eW9O0hsxB2ZU9Bn+11DvoYP07zlQ6w2ObfZTA
         1txCawUu+yOJA3IOOaMmJ7H0mTEY2HJqTuZ8wgpqxZ5afIGSVWqt6mW+m3yzdUzm3fxI
         Qew8rF9jEZvR4ZI0wxQM+dzGi31uI00p1EPT+b1/KotChveYSby9QBgcDIi7ANhzklJk
         AgUFobHApP/6fkctHW16fqt4orrtOtnwgpuAQTe7QOpUOy2f9HfLsglG/guGquArJTax
         Kn0Q==
X-Gm-Message-State: AOJu0YxPN0XWtWhvjjAwNt/6xYbF4Azuyu6JbODfXvQU/0oWA+04wGQw
	1iBWmaOLTnukgbXi+ZRaSUmxwcnrgpXeiA83PJXZd10zC8whF2Wz0cm54Hut54EC
X-Gm-Gg: ASbGncv2MhrNleFPEr3+cjxNMFUK1g2CSGljhjHD3pBp92PGnrbu0Re0O9MybLdtz4E
	s9lxtBol4COzuM5HDA1Rtqj2e0oqn6QkL8cKHoaEO9nCs3xMoYj+oOv7zVFDXgoRgynfZ/UPKEt
	fCtzQDPAQlTXhyr6S01kE5hgCFxIDwQh+yirEGblI0g1GmyZAK03VQhtGrwxpeTQ60QDxN/jUIX
	u3UEhRKkPd/cpEcIXSAx/hL3c7nEcsOLBnh4Zqr2rCVt4tGM+yATURChnZDDiCZUxoYTxpdT5BX
	Os4Xwqyd9dhl3apxGvvgTqyi4o9z5kPNVA5x9RgXP0E20+eSGU9IZpSgNJHt9cooPLi6NdPa
X-Google-Smtp-Source: AGHT+IEC5x5trrgct5DxJCC6F+ymE1DzlExCUnKq7tUvs4FncYjfaiflo7WlPfqMXpHY+k4BWD37sw==
X-Received: by 2002:a17:90b:3d8a:b0:312:e73e:cded with SMTP id 98e67ed59e1d1-31cc045b2dcmr3052702a91.16.1752810154648;
        Thu, 17 Jul 2025 20:42:34 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c9f1e61e8sm4086449a91.16.2025.07.17.20.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 20:42:34 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] xfs: Remove unused label in xfs_dax_notify_dev_failure
Date: Fri, 18 Jul 2025 11:42:22 +0800
Message-ID: <20250718034222.1403370-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: e967dc40d501 ("xfs: return the allocated transaction from xfs_trans_alloc_empty")
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/xfs/xfs_notify_failure.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index fbd521f89874..fbeddcac4792 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -350,7 +350,6 @@ xfs_dax_notify_dev_failure(
 			error = -EFSCORRUPTED;
 	}
 
-out:
 	/* Thaw the fs if it has been frozen before. */
 	if (mf_flags & MF_MEM_PRE_REMOVE)
 		xfs_dax_notify_failure_thaw(mp, kernel_frozen);
-- 
2.48.1

