Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24EE13F426;
	Thu,  6 Jun 2024 09:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717665489; cv=none; b=UGAI/I4tJDByAIt2KvgpKEatK81mUSccLSosB6Y8b5BiQrpzVGrKhVR+H4G/+8uecAQXZxTz0ctNVVDF4QTFf2ICZg9ncS2uxAHe7BNMTVuEox75Zx26RH3h7/ZUlsjrF79gGxneyY83FNC39Yzxv4tX8BiR3aFwz6rm3emQbC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717665489; c=relaxed/simple;
	bh=9xIvntBD9ISwIlNxjxBtMfBTyA/FedaJxpNj7NtHMNc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DuIQd5hlFk/5QNXr5ijBM9Cd2725CpP0VBh9JNARnN5wiiooy66nxTnrP+aLVky3EIg/A/ozD98rZZT0FQAEo/umxbUS8yvS2og0l25yVCGBkZoPF7Mu4rbLANNyzvGfvYS5UlU1ro+EemHnnXXQo/qw13i36p44wf5wD6ayqJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TL+IaoW7; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TL+IaoW7"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f65a3abd01so6949765ad.3;
        Thu, 06 Jun 2024 02:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717665487; x=1718270287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EMuvdvqp3n0ce/pawlMPoxxmp4dH/RgIod7YTFEiVfA=;
        b=TL+IaoW7m1b9mNUqd9I/6B/L3U7aMmvYosQJ3SFvofiIWEVh1DNKBP3FMy4LEDzodx
         w6hAgVGAxDWIbgxK3FqXGlRxYGeuz/z7eDcaQ3pGGaPJn0pv7ByMJpjR6j47Ev0cVrLE
         UQUfkF0WHeRDbz+Fu+8HCarFX763Rhjkfgf0pO0HZ28zZKQfmIiXWealpfSIgGGNLifT
         zkX4J5JAhtaYJ4VIdTqE8YTcYjA5RXtYfdv9ovgMm0ubchN4M9id44muCnddIWzC00X6
         zaQpeahOpCVtKB6d0u2PcUbVUWHvCFBIjWfRA8iwRMJ/1rK4iYaAorxCxMtbDWylRbEz
         IbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717665487; x=1718270287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EMuvdvqp3n0ce/pawlMPoxxmp4dH/RgIod7YTFEiVfA=;
        b=ojJG4WuVwuSBGcPEdi6UKyOuR6l00YhCiv/v4uqLp3IDItFXalwPeL0JVkp/K9fjWj
         foS63EX2u3F71bfKjnjSkqcVoLOzZHUWzUJtSG02oyDV8cnjADVp9HynxF1iq3Ev5zNJ
         RYtQzOqXAbWIJ1BrU7RmIz/Ms/pxdXk/mjsbKOfgFORlgoo6rKR3fCc6few+JE2aAN6u
         5GF4dBFkCbpuGTiVPwqDvxTe7X2U4foSqs9sj2uUmMutnYFvm79aqt3O+p5gH22Q44Lx
         1I4akNVVBXWbEwHwWGT6w1zRiCsRyNRsJm5CjtZSKiU42KlVJkJVy9kafNb8tBWbaa+I
         a5uA==
X-Forwarded-Encrypted: i=1; AJvYcCWCNUbIKxKpftRXiG3iqAo7RpRP3+k6IVHfHSKLhQxp38EL3Zq/hbjvlzXK4VB1/psA30pflZV2+WGJJkXfwE48r9bHwxET2Ip0nREYOFGLgegkUUPd9RskPcJBAEQ6q9tZEaY18xl2
X-Gm-Message-State: AOJu0YwKgIYgduTLrdOwh/+6Zyi0tVsbk54S83spBhlGNwueOBzyL49y
	gOvJ0a22dTf2GlMFDmee8UMqUGLSPEPwbcWx9l1YUwzZoU5qzhdE
X-Google-Smtp-Source: AGHT+IFamLcllAxFiVSTNkN/6DX7U3WhNqKBuSW32Tq6Rt4vpTSIAZlo3R/khdJn5p1Fv5kaiVQiBQ==
X-Received: by 2002:a17:902:db08:b0:1f4:9474:e44d with SMTP id d9443c01a7336-1f6a5a0e824mr63914825ad.21.1717665486819;
        Thu, 06 Jun 2024 02:18:06 -0700 (PDT)
Received: from localhost (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd7ee105sm9869355ad.252.2024.06.06.02.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 02:18:06 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Wenchao Hao <haowenchao22@gmail.com>
Subject: [PATCH] xfs: Remove header files which are included more than once
Date: Thu,  6 Jun 2024 17:17:54 +0800
Message-Id: <20240606091754.3512800-1-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following warning is reported, so remove these duplicated header
including:

./fs/xfs/libxfs/xfs_trans_resv.c: xfs_da_format.h is included more than once.
./fs/xfs/scrub/quota_repair.c: xfs_format.h is included more than once.
./fs/xfs/xfs_handle.c: xfs_da_btree.h is included more than once.
./fs/xfs/xfs_qm_bhv.c: xfs_mount.h is included more than once.
./fs/xfs/xfs_trace.c: xfs_bmap.h is included more than once.

This is just a clean code, no logic changed.

Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 1 -
 fs/xfs/scrub/quota_repair.c    | 1 -
 fs/xfs/xfs_handle.c            | 1 -
 fs/xfs/xfs_qm_bhv.c            | 1 -
 fs/xfs/xfs_trace.c             | 1 -
 5 files changed, 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 6dbe6e7251e7..3dc8f785bf29 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -22,7 +22,6 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_attr_item.h"
 #include "xfs_log.h"
-#include "xfs_da_format.h"
 
 #define _ALLOC	true
 #define _FREE	false
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 90cd1512bba9..cd51f10f2920 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -12,7 +12,6 @@
 #include "xfs_defer.h"
 #include "xfs_btree.h"
 #include "xfs_bit.h"
-#include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index a3f16e9b6fe5..cf5acbd3c7ca 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -21,7 +21,6 @@
 #include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_parent.h"
-#include "xfs_da_btree.h"
 #include "xfs_handle.h"
 #include "xfs_health.h"
 #include "xfs_icache.h"
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 271c1021c733..a11436579877 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -11,7 +11,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_quota.h"
-#include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_qm.h"
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 9c7fbaae2717..e1ec56d95791 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -38,7 +38,6 @@
 #include "xfs_iomap.h"
 #include "xfs_buf_mem.h"
 #include "xfs_btree_mem.h"
-#include "xfs_bmap.h"
 #include "xfs_exchmaps.h"
 #include "xfs_exchrange.h"
 #include "xfs_parent.h"
-- 
2.38.1

