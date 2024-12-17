Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB94718B46E;
	Tue, 17 Dec 2024 23:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734476445; cv=none; b=Z+0RSZeSPIms968KlDTnmQYqo7XR9rshiAOftCnn8kcJt76VQ/A1IC8De4DQzoUoNokYA/rJs5rI5FDZz31sKYUgJwcEf8xEccBqBle9l1ZGQQq2w1PRpIorg6fA98sZTaTUnSZ9HtlB0atjI2EBVHCFglIqZqR+Xim01FLi+Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734476445; c=relaxed/simple;
	bh=RawtYvaWz6lWliHs/9+GsdxwzXSxR9r3tQxnvTbR8cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j0ZcN76dbRQMXk1trZrkseGlCrIwQ9CIcK2xG2mBCJ6vQN/EmlOk3ublEn4Kh30q33PsD4DtZfYLgHbSJOzU2ZEPYyKL7PIPkdNuJ2RlO8Q+jBlqSQo0toZ/A0Sxq0bPJ9m3Hkvi5lW1v1sueW3JLGnMD0nFGs2Uj88IYgFTk6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SCsdw82b; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SCsdw82b"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aab6fa3e20eso843828466b.2;
        Tue, 17 Dec 2024 15:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734476442; x=1735081242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4XEz6rhnsFVB96wbkpW+lhU7b364boMylDpIEeHqrE4=;
        b=SCsdw82bYjaIk6MRn9VG/hBpG067Ph/nD+szKQt1Q8gxVl4XbAz9snRYAfuKV42fpm
         9VTx7DmmAQkv4FjMm1kIxmd8o88XtzkROz2Gl+/fWMXLD4TpXq9j/U6YZafjFX/9WCf1
         JZ2cdxptMac7ajRUlT+o2R/SqMjjkIKh+gNYl/eV8PEsd3K5yTX3sxyJuAs64iECzkRY
         kOx2c0c+Fa8Ujto3bd07UFbQuXO86zwsopQBJIkfMvFty4upG2VZlnSef0ZWqIqN68LG
         he3uGH2B60TbOyOU+97lhH92e7IxViok52wlUlBhMk+g9hdy39fhTXWUpwov5izG9TOA
         E52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734476442; x=1735081242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4XEz6rhnsFVB96wbkpW+lhU7b364boMylDpIEeHqrE4=;
        b=YMCf6/K/tZlOtrONN2s+VAfpdkJEcqxUadIpEKO3qxQr3XoEqh5SzhadnYiR2wCLc5
         vOrCP3UdJVAzY1byvnNfeydP7kY81vpbzvmL6udMHVC3+CLojkzX5mlWv2dg7RoTM+D1
         L7VLhYAtYr1vN7tmYoJoAVwBfkGKReXc2AvcHE2KyZFIGbZltRpwELuBNo20N4Rc0HVl
         uuhU84BaSEkK8YqjAsZn+U5fp+MGUUlgKndbe7Kjo9ZHoPhudCVCD25SX6InOEgszQ98
         vmajpLEYbtL77CeUpko1dO6+Qjoqa/sP7JBFGHYsk8IuvF6Tmy1D3+c9XllrIC6b/rFQ
         gb/A==
X-Forwarded-Encrypted: i=1; AJvYcCWH7274bivz7pvMcV46hvTRy+RNVyphVXRoBS9PnAwM+xS5ir0dmMgZnW2tMR6lUimOBBVblgNyMbfY@vger.kernel.org, AJvYcCWr5KYn8ZAO+2SHtxOKOuNhD7KJW1Hlu+dY2Gx/rf3S+NdquSo8a9+IPuq0u9smvkxVPIUQjyUIjiwOqK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfvmBwKqat8VxhHcTL/yGIpF571g4D5TVbaSyPWo/fhfPD5GeE
	5H8R4MTtzAcny0PesWzqQvQxrwXrODc0q5c1F5ejpdIxgtX2G0vVxFQ7PQ==
X-Gm-Gg: ASbGncutyz2LxBMK1tI+ssrA1Jhx/ENsihPoJtjlmGHl+J3ecRlSbr7QNmlmc3+92qs
	jgI6sYEK2EpyBPt1P5ueLIaa0ocSGTLYZWjthf5BIySr5YeBxNowcSuduc9bc6dw8BvnpxcVn/o
	26HOhMutjnYT86OUB+Z4xCosBgqFM6qdxk41fkYeYS/IEzuugwyOxsJfCxT4O7n2rEPhjGjsk2R
	tStd0XbxHEvwEwijMNaW98Wbx8rTDSMkAGCuV697lS2WEOOoOIe/F3TDbgcsekmU6X5BO6z
X-Google-Smtp-Source: AGHT+IFQX77wgpGspEiR873ojumfcvZFoep/771Bg+U3/cA+lXsvCwJn7F5mSufydfw/ldrxkhTLGg==
X-Received: by 2002:a17:907:da8:b0:aa6:a228:afa9 with SMTP id a640c23a62f3a-aabf46fbf1emr45475166b.3.1734476441886;
        Tue, 17 Dec 2024 15:00:41 -0800 (PST)
Received: from localhost (dh207-43-57.xnet.hr. [88.207.43.57])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab9c3eb5e0sm468944766b.44.2024.12.17.15.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 15:00:41 -0800 (PST)
From: Mirsad Todorovac <mtodorovac69@gmail.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	Victor Skvortsov <victor.skvortsov@amd.com>,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Xinhui Pan <Xinhui.Pan@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH v1 2/3] xfs/libxfs: replace kmalloc() and memcpy() with kmemdup()
Date: Tue, 17 Dec 2024 23:58:12 +0100
Message-ID: <20241217225811.2437150-4-mtodorovac69@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241217225811.2437150-2-mtodorovac69@gmail.com>
References: <20241217225811.2437150-2-mtodorovac69@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The source static analysis tool gave the following advice:

./fs/xfs/libxfs/xfs_dir2.c:382:15-22: WARNING opportunity for kmemdup

 → 382         args->value = kmalloc(len,
   383                          GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
   384         if (!args->value)
   385                 return -ENOMEM;
   386
 → 387         memcpy(args->value, name, len);
   388         args->valuelen = len;
   389         return -EEXIST;

Replacing kmalloc() + memcpy() with kmemdump() doesn't change semantics.
Original code works without fault, so this is not a bug fix but proposed improvement.

Link: https://lwn.net/Articles/198928/
Fixes: 94a69db2367ef ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
Fixes: 384f3ced07efd ("[XFS] Return case-insensitive match for dentry cache")
Fixes: 2451337dd0439 ("xfs: global error sign conversion")
Cc: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
---
 v1:
	initial version.

 fs/xfs/libxfs/xfs_dir2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 202468223bf9..24251e42bdeb 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -379,12 +379,11 @@ xfs_dir_cilookup_result(
 					!(args->op_flags & XFS_DA_OP_CILOOKUP))
 		return -EEXIST;
 
-	args->value = kmalloc(len,
+	args->value = kmemdup(name, len,
 			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
 	if (!args->value)
 		return -ENOMEM;
 
-	memcpy(args->value, name, len);
 	args->valuelen = len;
 	return -EEXIST;
 }
-- 
2.43.0

