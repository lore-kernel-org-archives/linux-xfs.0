Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179CD26A0A7
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 10:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212350; cv=none; b=osstDYTkSU9Mp7Ftr2oGiCJQOyO7cJhfEigXMlAKyy+mvPTXE5NAlGksa5Nf3Trkit/krOdAS+o+BErbNu3ludFa3W562M8f7Rc5xA50v22InKimw89zDCQNW53eR6KYKftKPBBFEKZiR26OyFCs562jydgHm61URyTGyt73Vu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212350; c=relaxed/simple;
	bh=daMuEi5nNTrjeRfm2nYwgE60zo3+B0/h9Io22PxzWLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dtn8toQehdJcVe2eEvIHRbpkv7RQsjTGRN2fXBniIubUKo79E3bDANnznx8bYq6X2z3yv9HN3nO+x+h3I2M+5wdx/wk+hyBMoQWfMbkX/Byb+ezqx01vBqFGINbEgO06URkM+C/TtZKmpGhAfECNyjq7VcRPYn+RZMZRR+B7bGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RwWe4g2Q; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RwWe4g2Q"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a0bb2f093aso43470565ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 02:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768212348; x=1768817148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O+WOngjqIZgbv8k07V011cIL07A8WspfoLjC3rnjud8=;
        b=RwWe4g2QwokCH71nmQXB27nCuRv1eCYqCwgjsvI30sIsH0Pc1j2faVONL4PNrFRSzm
         gVOhueZXyn2oCsRtaTCIvgPz4IxLTTeiOuF7TPdtwHBhyoYklBfUp8QKVZtuJ852OM4t
         K13nOx+1o9Nbimkhj1a15Wh++F2XyZ5sTPU3tbwSRakJfFEnfx3SHCSIzahFeKaW2W5d
         PGqCnB3MqzgVe0Mwhaw4eSmhsDlYNb3Nd1gjO3WH+5cGS76YmcJQ19Rs7DwbEykhQg1C
         O57tS9xllHLfRBzRb6clq9/DAJN+TK97INK2+FxZoJqogGDIIZcO7IN7fiGTXCopB4OV
         Rdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768212348; x=1768817148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+WOngjqIZgbv8k07V011cIL07A8WspfoLjC3rnjud8=;
        b=rzSGSX3PC7m5gQ4RogYdt7qje83l3Icv/UVmm5I6g+VBo0cf0fEQwfv177zmDjtKXx
         PIyYJ1wyErlD3lS9G2V8hqbG2Q/I6Hqy6UY699kDJ0OzvVFV6o9coUobyX0HQWf4AFS8
         KF0d2D/5i6AFDXBK1MpIwqvD9d18Ta42xrdDByBBXZC2Qu+E9o4V6/mC/LjZW3OzZAzm
         nLFnrb+XqNFcXjQlgMl5G0N4ZTV52y9yVxc/8DysBIsz+9hCSRjFApPl2stdFl1a+2Ie
         pWocOJcmhdMw5IQ4ZyTA6hI72DlNCj/cBLVmRZGqFPXHBi5wzJ6WeIiXDPJIRVJ6PQkc
         XcFA==
X-Gm-Message-State: AOJu0YwJW6zQ/ike8YpJYwmp0Fjfgd5YNImt565+OohtMlFtsvnSxAor
	wCRBcQKNfuK0Wnum3iP46W9LaR5CfrWIlQ9tRJF2Qo5C2gzjPzSZtR9qqMUVHw==
X-Gm-Gg: AY/fxX7kgpsgICLRmdVQLzF77lfesNh8kvCrRSpgs1RjCuTeKVbMUk55Ndj8Vpv1H9G
	H6ZcruFEsnoEKOiEZej8cZcs3P0bLqm+deobAxkbiZFSpG+4xhasKUNe2XvhF9ikue0+NUcUILP
	QDSDoFE4GZKRbxsGGlCnPpL5MaO0173Ceq3y3N9PXk2JZZlekn9ArFIMk+YXkHKHwn5x7tyYoar
	3IXZnnEYToldK9aEXyF5enpzApVCP3BsNCnLPHnol/mJtdCmAarhYd2wxmRBb4aWq0+FfwawRAs
	AKsdcc1tIWpQffGqqC5G+ikK9WZu0H0MK+uZ2du2vupfTW2Vm5EqYoDuOVFdgoit9K7v5979lVY
	iNIAM8enm9qO6ZaQBnsU6wY3kXhShxxCvRfdsK1XFAxMQNaDsk79gAg3cQXZdXstlwSFWRBPPZH
	1SsRM3MON62CgXyT65xomWPUjp2mWD1XL308pLoq/RIQNAVk4vHxMrxavlK4pSoc91
X-Google-Smtp-Source: AGHT+IFP/PPzpr+ZKSmlIb1X685vzMJvCEuY3szbHhN4HYUMvhP02tvlU05ehttN7mLWSWwgL4Y/Ug==
X-Received: by 2002:a17:902:ea04:b0:2a1:2ebc:e633 with SMTP id d9443c01a7336-2a3ee4372c6mr163358225ad.4.1768212347942;
        Mon, 12 Jan 2026 02:05:47 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.232.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3ba03f9sm169314415ad.0.2026.01.12.02.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 02:05:47 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v4] xfs: Fix the return value of xfs_rtcopy_summary()
Date: Mon, 12 Jan 2026 15:35:23 +0530
Message-ID: <587bff140dc86fec629cd41db0af8c00fb9623d0.1768212233.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_rtcopy_summary() should return the appropriate error code
instead of always returning 0. The caller of this function which is
xfs_growfs_rt_bmblock() is already handling the error.

Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org> # v6.7
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6907e871fa15..bc88b965e909 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -126,7 +126,7 @@ xfs_rtcopy_summary(
 	error = 0;
 out:
 	xfs_rtbuf_cache_relse(oargs);
-	return 0;
+	return error;
 }
 /*
  * Mark an extent specified by start and len allocated.
-- 
2.43.5

