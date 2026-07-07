Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125F230E829
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783432893; cv=none; b=XFM3QsG0RdmyZTQBb5D39KaE5tzGSMTv7AlD1ANg+yrQZwAYwOq2IK7jDtXqXThkH6czZO15QsR8x6N1Wfznv5wrwfEa3jJk+fHArR7SSTViW+suFD9zaoXqlSSRAVLHLchJ2FsihXsa0/ldVgmzLthgBAty1A7pSRQg4HGejnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783432893; c=relaxed/simple;
	bh=k3p/LVhY6XieXSUYhvqXUVhPUxXPhzCecfn9ETy2ZfU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ncbpCBAbnXuQfVW04NBFNfDpetFwQDn2NY8eACipF2rSfR1bHd+hRGiwjHqteKTa8uyOTOrSip8mpp6jogFRgfZ4W0ekyWLHXLXM1LYIGCvKoZDV4Xyk93/Kt8CUPkVDJX4lOxeAn96KLjFrbcX9hHYhqcjfBA1mWzMkHyS6MBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XxMaZmxz; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XxMaZmxz"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-847917c3678so444010b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 07:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783432891; x=1784037691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1ph26z8kK868uOu08qfxJac8BJOh6HBGTI2padbyuTk=;
        b=XxMaZmxz6SZa/SsbIjNeIcLGhrBM1fTyaTSrqmLIBB3rfbfdOm16+jLlW6u4fQJnPi
         5ApiXR11B03kUyNV7jT7vEHcKhwy1GaaxTpABQdmZmRNCS9yDUFgwWlSgU72igR+BFKV
         HE61bUmyVEsOZ3xF0sgMHn0/tT4/bVghztRt0SteaMjj0rB1ALugnSQ5moZYjUhs8Ugt
         /K8hM5EGseschu/WfysVEnlYf/I8uEbswzqmckaflvgDJ6Mm0YHJNJN7w2VUrkfDHwC/
         YLEtvdbslM8FBcEqssYgZ5koOWVbH0qrgnigy3giBZLAgZUpbC0YBPra1M1Ki2zE8B7G
         lm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783432891; x=1784037691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ph26z8kK868uOu08qfxJac8BJOh6HBGTI2padbyuTk=;
        b=WcFijxnnxWPP/4Zds1VsykpgDJa9pV1JrBSKxU0ylgKfifV179oTtJF5w5ADcELxAM
         Pl4e2hZ2fupAtP1No8CQzIw+03T5r1VY2Z2hKqPBo3wsQT3GEqs3XZg2ENCPcTDwSQEd
         RlGEZ2Pf8z55XH2om5C8g5Rh96BWCRNClwvl2yGoQtMJqMGX/nsKC0k7wzVV55hJtD+D
         Ab3cn3nshqr6JnHiqmtCp0gsnZjs9Nq/TLC9UvgYEAvBFbR0W/j1Xg63dVDeHHGqKQWt
         tjbHliuYCtRr+HXE4XuDBGn34AR522U3miElsr7/2Z63WsVvRbglbTRwWNm4WvQ1X+sD
         4vxA==
X-Gm-Message-State: AOJu0YwCe2Xxi9uLdVuSV7MZc9dDbhSXSEN00125ZihkRiXCEqvNXOKz
	wh9x9ZHTUnI+dApoFdrVEBL/M5YFi7T4mECctYyVf3k885G0LJPXBoyrE8eTNZO9zdg=
X-Gm-Gg: AfdE7clxreOhwF59r6i8biMYJB9VZuUsSyDRsfRQkh73H881KJhBT1plg73CgAkxa7q
	isu7p+erJpfYbdVAt8p8bDguInLEG69x6CgIeWjwDKsNTn4DD9ZhpFtSHG1M5Nlvqm2y8xRd/RG
	0f/3NY1fxU3yHJlSut7n5VMPvYzI3OqPaF0W3FQSMmKmG6PQnavDuFiES0CV/hKIx1Rk/wAicZx
	oaFkWODqNgcLTZ0BL5O2yegUegET5yrYY7+eoQzHTV/z8r6NeH2E+2//A+KW7GMaiA1PkLzwUQc
	HMgmJ6wOVJ4FoYzHbnmdYB9LJI7oDlZ+AL35EVG1XDye4eHXk+SQ2uj2+GyTe1udg6kz59cRXYL
	R59kLU8LuhNl/nSazEdAtVN74tK+lrlBe8MwJlpLh0hTX7uQbgioMKzt59qZ+KLudgy1fYSkVdJ
	5P3Kol
X-Received: by 2002:a05:6a20:914e:b0:3bf:a517:cdcd with SMTP id adf61e73a8af0-3c09b0140a3mr3677488637.12.1783432889904;
        Tue, 07 Jul 2026 07:01:29 -0700 (PDT)
Received: from beelink.. ([186.22.57.86])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b6596681fsm9900909c88.8.2026.07.07.07.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 07:01:25 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH] xfs: reject remote xattr entries with an out-of-range value length
Date: Tue,  7 Jul 2026 11:01:18 -0300
Message-ID: <20260707140118.3217585-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_attr3_leaf_verify_entry() validates a remote attribute entry's name
but never bounds its on-disk value length (xfs_attr_leaf_name_remote.
valuelen, a __be32). A crafted leaf with valuelen = 0x80000000 passes
the verifier and the CRC.

That length is later assigned into the signed int args->rmtvaluelen
(xfs_attr3_leaf_getvalue), becoming negative, which slips past the signed
-ERANGE check in xfs_attr_copy_value(); a getxattr() with a small buffer
then memcpy()s a full remote block into the small kvalue buffer
(xfs_attr_rmtval_copyout) -- a heap out-of-bounds write with
attacker-controlled content, from an unprivileged getxattr(2) on a
mounted crafted image.

Reject remote entries whose value length exceeds XFS_XATTR_SIZE_MAX in
the leaf verifier, so the malicious block is rejected at read time.

Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 86c5c09a5db4..f1769289f908 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -339,6 +339,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)
-- 
2.43.0

