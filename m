Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479C91E7C23;
	Mon, 16 Jun 2025 11:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750071817; cv=none; b=uKDmJ0Yn2BHP74fByqfZbplJ792k1N/87OoqgaVbdPQiqJwxU66CUQ5vxWdWn9GtX247cKWjWmmlLxglE/MJdtfQ0Tl+XNLrhKVdtQvcFGSJmN/HqyU6pvbILSqzxyfctqL/ITxqltvQ/iheE6AyO5Kslt2rX6Iv04wYJ2sQWIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750071817; c=relaxed/simple;
	bh=m4Q97Vl9Pu9GM4C2YDP6SbvlhmPxpHgL709nuEfJrfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l1CddpwSHZq5wl3NOHrE6293YbimJxd5S/9DjudqPYWcPgTEHAyWlcpTmip+BdtYiscpNPUy55jz4f5FmJl13v0DakUC3jWPZX6EmZusDGDryJxVFTN8j3BlS2FgYUv+sw8Ax/gD/wX26Ci+f+kXAl9U4t9SdoWWVzLgCvJRMgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TaxpYpnZ; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TaxpYpnZ"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-747fc7506d4so3596443b3a.0;
        Mon, 16 Jun 2025 04:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750071814; x=1750676614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5o0Hn0fW6RFNxHio5FVElS24SR1RndyfYKHO5SLow+0=;
        b=TaxpYpnZJSdqEcuhuytay+prnjnZofVV9ThY0ihVZFTONGo6Yvd+wXrdcXJvjbki4J
         pHUo3n46yj5UmlnXoayj9K5G3qukQa/1YT/YN50daeJdkpRMnQ8LANqGGWhZLqt+vhAc
         AVwLRTmCyVtJRZSf8RBXLCP/P1Y4oB5E+fVDjA6HOKvOcUjgcIt7dQL5CHSnv+moT3BL
         jlxOnc3k3y7bNU+1dTBovwx2n+LR8lWxHdjJ2G1unRVbJuuA01VzdcrLveBLv4L0rEif
         H8acT7huRAihH9+PcR+QxvFA4/QbEnIiMdaLXsZBKljBUbrJiO1zrp1RSzvm+eN6YHhP
         l6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750071814; x=1750676614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5o0Hn0fW6RFNxHio5FVElS24SR1RndyfYKHO5SLow+0=;
        b=JuSE7qmwj5C/YtoanKF8VPj+Sat9k2oVArf/T1ZGCDsb3VLrgE9AIyum9F+UJ55vDm
         CnUZtITeZ+x+f5h7nzjbzfRogei5BdJC2RfotwF9mxjIiLUdynM73Y9P1DJnxDrlcV/r
         h8HvggxizPD7tASWyG4sT2+Xm7LPfcMt/Mwe1SwFNVOB8aQSKhGRmdh0jZFP+h7DnJ0A
         dVPvjiQa7FggonYKDa0PdyEYmgYbLaF9mcIVSFAG7fsNFZFGlW/MAYQF1hv28tuxxDjN
         tomG+1/1l1QmMFDriBavdnAXwIx/ji1fqJ+BoFqUCtORTUG9EBHVupimgSuSTUkR7HOc
         wwJg==
X-Forwarded-Encrypted: i=1; AJvYcCXeolRpCBy9P6y09AZK6+v4y5HD7o9n2lHNxZwWauHnV7BSMVhwjlGoqG+oICv3E06G3bmZloM2augXgWs=@vger.kernel.org, AJvYcCXr20zpBRU3Qc/z/G/9pLcjte0Kl2t+PK9KYQ8CxBntA3zxhxPhOeW17xm5OzH29Bl3J3UuavLAoG6/@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrij/UrVuTw7WZb3UYbgk+0b5qhC1t9FPKrZp/akTLKjBL0S36
	e1DMcVlhsEMAT+D2uSlirvsxtEk3iQfN2zvevND4W37Bkib0BUx5ANRurzE5fPOB
X-Gm-Gg: ASbGncueFUKU9ezYujO0nl261BEzpuv86xM4BCx9qT6UVJQATFrpIYq8VZHeUoFdHTe
	gYL2gUbRk8EYmZwibmO0HswQ6cxUru++jQKNuj8uh3dSkaxBPdWATA8TQZnEvSuYSt5j36pyY5n
	e/WsXqi8L2Kc6EliVBxz3cPEdlWx2SgWzl2Hyl59boxYnk6H/E0HHKwqCxXYFQbR5RqJkJT8sCr
	/SjFi7YbyJXNiPEM/FzTU35dYmI0DeEjPm3oywWz57ZJDICTrTRzM6fQxrH0HyecEnLlc2/Cbc1
	QBznv7aUmu7KdWvOpLIO9CHglDQtAi+JwmTu4XDMcQo+Phmh4NkWB81/If8MVwTO2kaIj8FJXcR
	zVvPdvHk=
X-Google-Smtp-Source: AGHT+IF4SzbHZUhbFwosMC0lnmCIR5cjaOPgH5kNe6x7SOYohIs8eQs5+7xY8DfNyKJWCnS44WQWxw==
X-Received: by 2002:a05:6a00:2381:b0:742:a0c8:b5cd with SMTP id d2e1a72fcca58-7489d039b81mr12234599b3a.19.1750071814445;
        Mon, 16 Jun 2025 04:03:34 -0700 (PDT)
Received: from manjaro.domain.name ([2401:4900:1c68:884c:5800:7324:c411:408d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74890083c7csm6508293b3a.84.2025.06.16.04.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 04:03:33 -0700 (PDT)
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: cem@kernel.org
Cc: skhan@linuxfoundation.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: [PATCH] fs/xfs: use scnprintf() in show functions
Date: Mon, 16 Jun 2025 16:33:13 +0530
Message-ID: <20250616110313.372314-1-pranav.tyagi03@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace all snprintf() instances with scnprintf(). snprintf() returns
the number of bytes that would have been written had there been enough
space. For sysfs attributes, snprintf() should not be used for the
show() method. Instead use scnprintf() which returns the number of bytes
actually written.

Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
---
 fs/xfs/xfs_sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 7a5c5ef2db92..f7206e3edea2 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -257,7 +257,7 @@ larp_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
 }
 XFS_SYSFS_ATTR_RW(larp);
 
@@ -283,7 +283,7 @@ bload_leaf_slack_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_leaf_slack);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_leaf_slack);
 }
 XFS_SYSFS_ATTR_RW(bload_leaf_slack);
 
@@ -309,7 +309,7 @@ bload_node_slack_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_node_slack);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_node_slack);
 }
 XFS_SYSFS_ATTR_RW(bload_node_slack);
 
-- 
2.49.0

