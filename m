Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB29139590
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 22:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727217093; cv=none; b=hxl7+HFmsyLpRhy5Z2Ym6IX7+hTo8SAONmbxIq+SxjzQ0N1noboVIFRIteP+IMJHzjTqEgj6gKCVcqNrlVQH2OClitBCCBa1O+WLUXTsjRGZcfC5h9BsoZrymtimduHyl2UhBhu5c1PIpDaLsDCmhEU/ezp8jgRn3YiVfAKr59U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727217093; c=relaxed/simple;
	bh=mPXnF7hMkUm99VEerNDvKssi7GoYEqx+nCfJxCNI5gE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RFfkbxka8IfMfJEe7juj9NwT/W3SVUcJedrNgmqPNMvUot4HUvjVfd8E+LVKsfBBbkwKeBvwP9b/ySjZZcL0L1YdyHrA6S0LIg+UNzpywSM9jL3BwzNvrYvIHfERa/YAOfBxG/LYeBJWPWPxTiKflIU0c5iQHF58LqinwuTaGoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GGnG6cQW; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GGnG6cQW"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-206e614953aso59751805ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 15:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1727217091; x=1727821891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l0a+dC7bPkvRCPdf1FziTYWIZO6MVoEFRBy8NHKXmB8=;
        b=GGnG6cQWO05rVlpCLaxt0RN2/e6Pf5achfuaU+7ZsA+UvPYtNLARQ/Pxex4hPiDjnT
         0aUG6SAkIcH6sj45lEQjobsV+QeWI43CHGhNwqns+sU7thgaC2jLj7fbkgd5Sj56eKK/
         QbjupLyN4W9E+Sf3AKd0i10LLXfh76fXcyYU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727217091; x=1727821891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l0a+dC7bPkvRCPdf1FziTYWIZO6MVoEFRBy8NHKXmB8=;
        b=V7T7T6l+5Ie1iWaDO+7M7V8jCoVS4+KF7LfvK9eOV+DaMkhQaQE7e+Z0PVMjQURZW8
         jDWAn07e81Woki5SGnYynFqo8piOBiIuYiz6gA/ZR6pwWyuTHBV+f9tZfJgptgtItkAZ
         NHo2MgQ2TnlzyiLE1VR770PRPWEE8v5nKVjxuEF1bIIQHF4KqNfdsgdoYqW42qiYH69T
         mCmSpTUos6hJlkFSNN3AR6jnkqwy3EJjx3pJ57KO91qMRgYWa7l0R2qf7XfwSiiNZnG9
         0lg7nYtfKugyDVpuR/0Mq7rCo/JWfz1exF5j7JnjQc76oMlo6ZULgT7HK/q2Z94LZqYq
         N+jA==
X-Forwarded-Encrypted: i=1; AJvYcCUMUUv9WBIojJf/CT77Fhkzv2+NoZOlgTgIbfkmdx7+MudkBddlGJXtbB335jrZoY/iluuqLIOnoeY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgJKH/0vGRrurFOgpC3qJAUFi6aItrg3eRk1TMQXcFLzgHMzR3
	TUTI9VLiHI6+nDBW3CMxOmRB9BnGCpqWyimzNl7wPqDj40rD/qihLwdfSH5mGQ==
X-Google-Smtp-Source: AGHT+IEi9k/FbY6zEWEIa9h9GpTHhnlsJzfXToS3+1LZrx9tg8QQC9qwAH5eBkvFqZmBKD0Zi/wz6w==
X-Received: by 2002:a17:903:11ce:b0:205:8a25:904b with SMTP id d9443c01a7336-20afc66e1e7mr10761525ad.57.1727217090765;
        Tue, 24 Sep 2024 15:31:30 -0700 (PDT)
Received: from ubuntu-vm.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20af185471asm14234215ad.257.2024.09.24.15.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 15:31:29 -0700 (PDT)
From: Kuntal Nayak <kuntal.nayak@broadcom.com>
To: leah.rumancik@gmail.com,
	jwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vasavi.sirnapalli@broadcom.com,
	lei lu <llfamsec@gmail.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH] xfs: add bounds checking to xlog_recover_process_data
Date: Tue, 24 Sep 2024 15:29:53 -0700
Message-Id: <20240924222955.346976-1-kuntal.nayak@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: lei lu <llfamsec@gmail.com>

[ Upstream commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 ]

There is a lack of verification of the space occupied by fixed members
of xlog_op_header in the xlog_recover_process_data.

We can create a crafted image to trigger an out of bounds read by
following these steps:
    1) Mount an image of xfs, and do some file operations to leave records
    2) Before umounting, copy the image for subsequent steps to simulate
       abnormal exit. Because umount will ensure that tail_blk and
       head_blk are the same, which will result in the inability to enter
       xlog_recover_process_data
    3) Write a tool to parse and modify the copied image in step 2
    4) Make the end of the xlog_op_header entries only 1 byte away from
       xlog_rec_header->h_size
    5) xlog_rec_header->h_num_logops++
    6) Modify xlog_rec_header->h_crc

Fix:
Add a check to make sure there is sufficient space to access fixed members
of xlog_op_header.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
---
 fs/xfs/xfs_log_recover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e61f28ce3..eafe76f30 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2419,7 +2419,10 @@ xlog_recover_process_data(
 
 		ohead = (struct xlog_op_header *)dp;
 		dp += sizeof(*ohead);
-		ASSERT(dp <= end);
+		if (dp > end) {
+			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
+			return -EFSCORRUPTED;
+		}
 
 		/* errors will abort recovery */
 		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
-- 
2.39.3

