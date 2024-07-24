Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1D82595
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 02:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721788827; cv=none; b=kDE/2mEs146NDya9b2lcmk2RyLvJs8s8hGgnwpGMSR/jc3y2QmO2f1jgU3BnVdKuflwEnlNAgGsNJYpTQtDbNWovulCrzQuEBCtlLlC5+kjxGQjZBKAZVlJkz7Ph/MANvV7u+rkjHMBfNH5XmvOZNBxMzIjdtVkZSOCTcD0ulH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721788827; c=relaxed/simple;
	bh=rWfXmi7I2G/zhM+9AfLEQdFR7UpENh1J5romYac2tsA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=W3jcee+vDx9IkI83QAc7y85dJ1huiwopKiS+DWHD6hKdY0Q6nDjOzNS/P5VXFWusove0LADZ2ISkl6OVAaDRD4m1UX6hJfcSLZPpY17WpqKyHHHqbbmpaBHXp8Q+Sd+TNiunitj1mZApZjq3yfKLgcOsaKSEALsHTStNN4GEQRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j5bUX4IQ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j5bUX4IQ"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70d2e68f5a8so1826226b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 19:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721788825; x=1722393625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oh+3k3aZMg1SQeZK/yBdQCvSPpbJg1rnJy+0p7kmAu8=;
        b=j5bUX4IQx01+/4OtQpVE4FY1UxhGv5e7CTnYKKN2rDRbeVKdY7DXLjvFsXjOqnn1IB
         VdIdN8/wBAK97tHBGFAU5AmOEPSKb3DqJnsndYvihcNhgSfi+mt0ogRBXKvkvgi683ga
         SNvlHcJBVE/k2trWVXgpUNQ5a8H17TJhSxgbFhprGQkrM6nkAbS/ea/Ip5bzkE4W6YfG
         +GCRRwGFjqlDpP6EGxbc9JtPRqqabihvjhgsb51ntw8I90ZqlUSVNUl/qND6XdXa4h+B
         Nku+38E/y/CZSHMmRvonBssS/fmwZk5QaGg7xyfQAgRLojZfytW4TIw+oqJOLr3oSSPN
         iWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721788825; x=1722393625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oh+3k3aZMg1SQeZK/yBdQCvSPpbJg1rnJy+0p7kmAu8=;
        b=amfQsm25pgp4VNGLrH5O2tj7Fdgx/RfqVMITsvmb4NqLQo3cNNX3bnv9mvuJdUo9Hw
         8NDNy9XKP5stIdbc0qN6Is+JmQ/Uti7OyTDnp03Twt2RKS5g3j4TWcaaaFqDH/fKlGrL
         iEYDwIAdjoF9jVloKBHjJFHImccNDZ4oaGiabtP83BScAxfeD1A+f0pSFxLs5g+3ugI0
         SJ1gxCkwMu05HZulk0EtEkOPrkHz4Y5+JiM3R5WCy9IOx3wapKr5Rttvz8rvdkceCT0n
         0skLYJE80AbtQcm7bn7EL6l0cTIEa6hnrZR+uQXPHxe+syTmmtH51z3lpH2rXS7mT+I5
         9/nQ==
X-Gm-Message-State: AOJu0YzYaF4Q+urUaZL5gjgqWBy5IAwtSWsBX9lPGcltPHun1kK9gr57
	mqgAlxjEnZHbR9YOp3vEGCliv3q4SsyrtPANjNDKkgkX1Bg1LXIghebcNAK0PzY=
X-Google-Smtp-Source: AGHT+IEZysTqf+13evK8kSfV0jGgl+R8+0bWZj+E4TQBypJccVqbzsKbcjiaknZGfqlgcxxKU4E24Q==
X-Received: by 2002:a05:6a00:1312:b0:70b:176e:b3bc with SMTP id d2e1a72fcca58-70d086447admr16946348b3a.28.1721788824924;
        Tue, 23 Jul 2024 19:40:24 -0700 (PDT)
Received: from localhost ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70d27d6f0e2sm4101234b3a.165.2024.07.23.19.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 19:40:24 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	chandan.babu@oracle.com,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 1/2] xfs: remove duplicated include header
Date: Tue, 23 Jul 2024 22:40:14 -0400
Message-Id: <20240724024015.167894-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using make includecheck, we can see the message
	./fs/xfs/libxfs/xfs_defer.c:
	xfs_trans_priv.h is included more than once.
So, remove one of them.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/xfs/libxfs/xfs_defer.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 40021849b42f..8a73458f5acf 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -12,7 +12,6 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
-- 
2.39.2

