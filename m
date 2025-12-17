Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043B336CE02
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765982519; cv=none; b=LVrt21M4IgpXH9H4LRSMjBuJbDV9/FAJWYQyKkAnaQC7GDEpicols3mxmRWouU/DhriW6BkjgSmhCv/rmWBWIx0gqSj2iGv0qnd7D1chzl0SPYu4PXl4NNem6THkbs/GsVCcKhXBdKZidI2qXlKgy+GOwVG9Avu83a93mlhCYxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765982519; c=relaxed/simple;
	bh=5SzQPt2tmUp7e95QFU8h05fUZ9+ifiUggg68rkvF/UU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cA8JzlK1GaLQOmjHiPbU0dILqqv0uTm7O9empioMC7wna10PQCl/PpZgUN99I8i82Sh7OPGCeVtGBtuRNcGkQKanKalInn/oTVQfhYM0lCMatuc6KN5GwhyhKqmNI7p20Cce7NEuYNOCqfiC7dM71gecKE9gKA7criaGGtPsolc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ltj/jeq7; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltj/jeq7"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0b4320665so53465745ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 06:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765982517; x=1766587317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l0wZpduSA/Xljb/4OZQf98r4uBlmoIJOoY3MO9Qodo0=;
        b=ltj/jeq7zwcxW42dDddmV7hK8CrDx4eiuQBHaPw8T9dgXgOftkJa5VJsE8sJenytav
         QQTpiqFlB3Bb/fZUuQlpXxoKTMkR5cDjOdjuzmBbRYQy1c/piADMNAOzmbDzCSerL8W3
         g9UMmlYhSt8BdMKeoZ992n8K8RVlOm8cr+9U3nERz1oL3LJOl/epZf2TFHYBft5eH+hC
         jX5lSb+em/uz4Lu7zMJwsYZtmloHtJ9IqEbJzqPVQ4Q3y4BfP1XiRL0CxtN498rkTocF
         m4RFSgGC0Bz+i2HS/lOSLB/rxZ91MuRsu7KcA+NmDrWlvwC/+kFY4gWuUL4EuOSRId4Y
         JRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765982517; x=1766587317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0wZpduSA/Xljb/4OZQf98r4uBlmoIJOoY3MO9Qodo0=;
        b=Rw+e3+TvHGpSHHWlxq6Hz8h5fqQfd2365ZJT17zCHUQRQhzLbHb7Id0G4+EfIMCWVt
         Lzznd3sABjvXobn7oWsMWQ/LcCR0S7yyf2ToW0e8XgkhdhCk1Nq50UQ5ikDs/VzEtCNE
         v5bYg1B1T78EviE5EYkNa5Efxf5pz86H6lW1Jen8EHl8F7VRGMhv2RagLJ1PcYt1X/TE
         eoo90WyF20e/T5sC+bvqTpnGESjLrqeJdHK9au5M5lRGhNAaWUyMrI9DvE0vDKKWFoJf
         ypITdg0LYV2ta0v1aJPrdDXFwOivGeW/PSJzbD3Fgo0wilyN6tfg/nWbrIUjHX/UlIls
         cx8g==
X-Gm-Message-State: AOJu0YwiVau/0KnJ42WQJuKkEd25sZJMa+SiJoWsnY/QqobdmVtG+2hg
	MKk4uR3pYVMcCvjZEEimXdMrQxrEdfORzpacaiZrZs2Nzrz9btZj9y+b9xs6AQ==
X-Gm-Gg: AY/fxX7d8fGt0eYcGCr5YzoWA0AWwyP4okpXb51ZDu2YNIOZPAF4Q0J9xCDFaN5HbfR
	cOCR8t06X3Ajqp80cBApyajyLX3rfhRw1akhtnvT4FDUV+VDYp7KRMijgB4172FVnlu2m9Y/Ak4
	JzNCl9i+l8x7doHVaH+JIe2eXYP3v5Wa6i20J3q9/BJKiAX1LLZiNl3bCicrVr+p1RVLsu7oNe6
	3RiL1e02Yx9kD/gSkpS7q5VRpe2jPA8aykXd+R/aG6smEFNTcHcqdx2oPwLdPg17Vvj0DWz5vkK
	07DiKVktbXQ7VBTv9zMOzVLWPBXybEXPkg8pyuXawNoCyrtV2W9R1KUmnQzkBfcpMRJTECKIGve
	7WFGnf5sWHivrX7aZ5lApFZo6thqgmPpuknn8HIjzMRSWrygOoMHO1LpbI88RBtDwPI2101bHFF
	rA1QwMQkle4SSgkMUdGW396UC458CbmbEu7JBwBeclBv2VphxPt0aydfr2gBYyoyY9
X-Google-Smtp-Source: AGHT+IE4VabQn7etKn9BYvxqGeRLFlB3Ckx97QEvjagYODhd9lpSnuVxR1b/+RmWFyibI4XFRY5EAA==
X-Received: by 2002:a17:902:cccb:b0:2a0:97d2:a25d with SMTP id d9443c01a7336-2a097d2a470mr152636395ad.15.1765982516706;
        Wed, 17 Dec 2025 06:41:56 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.205.246])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a110f6374asm85914065ad.63.2025.12.17.06.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:41:56 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v2] xfs: Fix the return value of xfs_rtcopy_summary()
Date: Wed, 17 Dec 2025 20:11:33 +0530
Message-ID: <c6b04ec9ae584af62317d4c1bcf3f84dfab74be0.1765982438.git.nirjhar.roy.lists@gmail.com>
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

