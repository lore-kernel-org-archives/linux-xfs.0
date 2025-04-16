Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1B815F41F
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 21:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744838437; cv=none; b=pKu6Xd6HzQem0kbGhBI4TGRmVD36KFSJbOqyTURAMNxXNxQA0qGxSMNFIMFs6pHBj8N2DS3HXdm4cqiLEOU/NsdlDWbyxjIBF6QPSIr+8TdtBYJSy4JHRvU8gsY7y7l/s1b5n/EPN2Ay88/KNVEfIt0SHVmwIvkQWjUXKo6aa8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744838437; c=relaxed/simple;
	bh=LhUVibsQM3wgy1Zdiz+FjuSGmx5qFyW6kAL90UjKgb8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qIpuswKPavkFoNAD3MV0UHdaiPYjmWzPFwbP9oi2yo9/Mc+vKPzzjapX+JSH7ZcBfgV/fprqRCJnhN6PizkNqtxrDzkadUc2YFjy1B1BHfeQal3Pyo0+QTdzifJkKMpW1he2iNT2Zq3O7rwCkvE3/NFNcoZYoXRnIVuCoi48BHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iClk6hgF; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iClk6hgF"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso1184055e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 14:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744838433; x=1745443233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vKmy6XcWxAUn6aO0ZzZjJJ23WzqWPaqHP3rwaRDU070=;
        b=iClk6hgFuk1/6w8/gNND0ORq8hbOoCu2x696P7A1PWUWDhWnwH9GBUf/dRjmvGqrW1
         2wmIyYN5z3lXFE9q9HC/WK5rRlGhv3xpt2whcLs0EEAp9wDgTIOt1mSpXN8WMUoIWZeU
         Dp5594fjGKLKLYOtXha31WN2ZcQI2i7RSab3FqCebQPR0AtbaszAUa7SIx957p19jk3F
         F79mAEGUffFEUZPtef4UOsTu7L8ddYPaKPYxgeuYmMOX5EfKfimAfQ+gI6ZqrsTHfeLU
         8Ct9VyxefxVLksiPsQISLlLbg/54pKjMt1Dz7Mipkarg4R0h1e6CEKaD9Ge6/52v+Jz8
         UX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744838433; x=1745443233;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vKmy6XcWxAUn6aO0ZzZjJJ23WzqWPaqHP3rwaRDU070=;
        b=Eo+nd8wQLBrRL9NobAopZmljHeRQatsGIrQ9iv9fvgQYFefiVxvF5Y9WRlBknG7mzn
         QujJGKDlayrKAAMe32nsRGLT2SyrHup1rc+Vw+Sj/xgyZvLO3mWWIx/sZOPWx9nUQb68
         j1yams+Wq4NPC+gXJMMDeLMnzN9x86rcYYXFmiT6PhkxqtDBF2dvcl3+47LN8W+POVE+
         q9+0vYRYc8qFE0SMhXDqcfmFgXEJLzvipW+MC7PFe71Y1ReFDYXa9Tb7MXGcOTnVrmfr
         JkqjfkK4dbU3yXHcPYllsIsXNgCk4kG5q+Z36qQyzfrEHQRBz7/K6nKHuJ28KqMONVfA
         7GXw==
X-Gm-Message-State: AOJu0Yz/AWjtL5BoAWyRI0k727kbDvJEfRqkMY/j4Y+8emDV+zocVtya
	P0awNOZvTcK7FFvVvsiJYTAMgnu748A/ZyNfUVlQ/JiPtF6EuXQN8zn61w==
X-Gm-Gg: ASbGncv5w9gz+VKnfcocHIbmA+SRzrNtxmKRravqdsVyfsA4eG9w205Vq2b1DwdMGxv
	iHZL1wG2xTTNT8c7bd138KDgNY67Y3vAdqrzbhD4hcUyyafs37f5gmS6sZWStZblmwcS8Xi8KJe
	rPRGQqJEy328YWa5sS0dRByK9zCV2eCvSqQawz3fwFesJudYjDJ2UHGoWUaVskPJMw+778L5ESP
	h/SNtXlXwC5oqUPhev7ovSc/y5ZWGEQcKg8HeYJZgA2cbEzWZmJoZvHD8TW8r15WAviO08qaVNN
	u49IBIhzH1nm54wVzlunxD63y95BmGwcat3yA3mtDzDwP/k=
X-Google-Smtp-Source: AGHT+IHvNgOOOdnJpfZ+jfaN39jANFaFBh6jx4jSn13sbFP1jhBIi42FmGeLGs3nQo14FRpoAb7rrA==
X-Received: by 2002:a05:600c:35c9:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-4405d6d20afmr34536975e9.30.1744838432749;
        Wed, 16 Apr 2025 14:20:32 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e11:3:1ff0:a52d:d3c8:a4ac:6651])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4404352a5f0sm41642745e9.1.2025.04.16.14.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 14:20:32 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH v3] xfs_protofile: fix permission octet when suid/guid is set
Date: Wed, 16 Apr 2025 23:20:04 +0200
Message-ID: <20250416212013.968570-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When encountering suid or sgid files, we already set the `u` or `g` property
in the prototype file.
Given that proto.c only supports three numbers for permissions, we need to
remove the redundant information from the permission, else it was incorrectly
parsed.

[v1] -> [v2]
Improve masking as suggested
[v2] -> [v3]
Fix typo

Co-authored-by: Luca Di Maio <luca.dimaio1@gmail.com>
Co-authored-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/xfs_protofile.in | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
index e83c39f..9418e7f 100644
--- a/mkfs/xfs_protofile.in
+++ b/mkfs/xfs_protofile.in
@@ -43,7 +43,9 @@ def stat_to_str(statbuf):
 	else:
 		sgid = '-'

-	perms = stat.S_IMODE(statbuf.st_mode)
+	# We already register suid in the proto string, no need
+	# to also represent it into the octet
+	perms = stat.S_IMODE(statbuf.st_mode) & 0o777

 	return '%s%s%s%03o %d %d' % (type, suid, sgid, perms, statbuf.st_uid, \
 			statbuf.st_gid)
--
2.49.0
