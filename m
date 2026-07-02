Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1934426426
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993376; cv=none; b=LYSTG+CIeHRki2c4cY2TSL0Vr5dCpWOrKVg48U8H6/+tmGZxYBt3lMwRVEy2+uX2JgDjv7+l/33/tOh3Y9gYq5ClEVOPdoyPltqVWAFp5OMQbtNQadVR+oamCAoR05y3ETeYPJcgGaQ2rRLbQx6L3a+lrQboefxFrD+kbGCKkk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993376; c=relaxed/simple;
	bh=dvhAhSLZ2tsJwBV710PDjKYwMvjbDEn72bRWuBWRgnI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UNJbfjDYB28b7M2qDoJPL/s6HUl6VBbE5O4dmq0/g8VocJ4dZzOoISFTJ6fSOD+c54f2huPjkjxTXqFy2oBYWtx8oJvdZTW7pGdotrFgcS1PeIlvIF3unpUmx05z1h7FQG0vAbRXuTW3qICv53Aknx0zG3Snaqgt6XdwgCryMQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dysi8SNb; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dysi8SNb"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c88d1d4543fso331387a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 04:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782993375; x=1783598175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lXg2Rhbb0t7mbi9M9oI8GRYpC2vTaKnZJqTrxUfA0gA=;
        b=dysi8SNb17xuwLFBoUdtRk4P92jeHQ4Bv+2U+lTx4JQzHi3c7M9oBoCuKdf1mnYlTL
         qDWRnpZ6fVWg+qmjUTF0PUVz5Jo9Fqa6fWpVpa4KDKlR0YauAuWCXaBJ0IMjKKSqZrcr
         CQzYZvvZrDO5LdkdxfMBbi6CDhExGBLmLG84BDf9pqWM64+/Y0c+NN9A8sJs+h/xpJFL
         LIBE8NWho/8ne7zKtOMfcf3fe5mszrU1zXo6tSsCiD/6karARIh4ZJ1NomAHF1ksT/Gt
         q9nyJYBDif7O0+7aPP4eFWJvJUNYwho830PUelc5WPTBdYYngrbf36b1gpYW7MLFCQKP
         CXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782993375; x=1783598175;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXg2Rhbb0t7mbi9M9oI8GRYpC2vTaKnZJqTrxUfA0gA=;
        b=DdxKgZPCsR+AIJLDoNY5AUfIfim0DJ//hBVlHi0b2x6pGyTpkg0thtZSDTp2bX9STZ
         Qcel/15Wg5EFWJnFi4hBOaNYXOR2vi84E2EoO5oBsvZKzvSyRYVK6HITN7pMfwtwX87f
         +3HFjsXtjW3DUxxTJfnHLGcMmp1ONXrBy7MET/T4/6HPEps0qKVCdOBFNm4rd92rLO1u
         +es8wNZwlfygScVSkMV+nIfLVkSirppkigvAx6CfvRzp1MFsU/gKbdoXr9kV1QrjUpcU
         dsqXtf6/tgx25JCsMgUciZMZeVFXcBHBLUXMln+CfojvVbtTBfG7suDwvheFfdHoDHab
         taUg==
X-Forwarded-Encrypted: i=1; AHgh+RpPHiXUT2YkvR2ZSe4KAFOntJWyYvyXW7J4ktkxDXgzKAvlKmcP/TO1TWTgwOkJV9HDPeP2+MdtwAU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws+gdT4HHpdG5ESB7xZvgqS94qmvWftvgiqUl0dp/7sxrzLRW8
	j8HoeAPjYqQP67Zgr6l/JqHG9XbCu2aCWqZ3zq/VPVabfGu0N8d3xgVb
X-Gm-Gg: AfdE7cm11yHndYk2QCuPNxXFYEtZtHIvzEyCdl0rDJu+vyhajpKmZ5dymTHdpUmCJYA
	KN7IJv8jQ0rZJTsmvxT0RhyzQlhNVuFO91IVeakHrItYjPzCi4kQYaD8BLcZKYpvXpvaUFsq5X2
	skzv9ok4sInyWvupjemh2lEJG+/MRZIj1EqJmT9R4uBtrGJDm+S8LklzTnL5Ink5pv4VPDcPbj6
	vazHhe6DL50Y52e2ol/S1N7FTaPh4YPTexBBmJhDYjVaboOvt+vQj2Kzc/IBLrYTobKhBDFW6i2
	VgzG9vvoQuzQ3wV5REiHqEhC464simkXjcQqBWaTr9xCcyOF8SGBgRpA8V6VMK08lPVoBsYKwDC
	iNASgthbvBODeyj178cTg9TdUBrCfZrJUrWzWf5RmLL8QfZ5CkPgODh4oWjnpKUZ4qc9GbEdWVg
	9hhmupoROxV8wiqloXWaZ4bv2L
X-Received: by 2002:a17:90b:5645:b0:37e:1620:dabc with SMTP id 98e67ed59e1d1-38066e2cdbbmr8785341a91.0.1782993374676;
        Thu, 02 Jul 2026 04:56:14 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bbd2362sm9417796eec.20.2026.07.02.04.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:56:13 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: cem@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH] xfs: use xfs_csn_t for xlog_cil_push_now() push_seq parameter
Date: Thu,  2 Jul 2026 19:56:11 +0800
Message-ID: <20260702115611.3605810-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

The push_seq argument to xlog_cil_push_now() carries a CIL checkpoint
sequence number, not a log sequence number (LSN).

Change the parameter type from xfs_lsn_t to xfs_csn_t to correctly
reflect its semantics and match the surrounding types. Both types are
int64_t under the hood, so this is a type-annotation fix with no
behavioural change.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/xfs_log_cil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index edc368938f30..639f875a8fb2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1710,7 +1710,7 @@ xlog_cil_push_background(
 static void
 xlog_cil_push_now(
 	struct xlog	*log,
-	xfs_lsn_t	push_seq,
+	xfs_csn_t	push_seq,
 	bool		async)
 {
 	struct xfs_cil	*cil = log->l_cilp;
-- 
2.43.7

