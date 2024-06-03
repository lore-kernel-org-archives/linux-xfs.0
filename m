Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759B584D2E
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717408120; cv=none; b=MtTLcYIrJEorYA/4IARpta2vdg2rEgy6cioCUECPKkrlCQBbxQj3ArPg4cXll//3svEe3pFS0L/DwwB+Ng8KEGzHyWMp3dmahsZu7YeNSD/oZ3KzYGLoNlKta/Y8ZH/lYOCta2Pm3iPe68s2BZR/IPJE48k9CPGQtn7GW3poOeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717408120; c=relaxed/simple;
	bh=Yf2aodGBUEcMEBK38cdgpqW6kZhpkUNdCdFzFXoVr4A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U5huSxnqjF/5quQ2iuAvACjt0+b9WEFKSEL+3HOZ0kEJxqqSpcXMCC8flvd3V41KOlelWhNFpgzRTqghIPqRndaDOOuPA2ncmzXsnUANozNzb+4BT8xSuXiyM7KVwDmeyKgDON8/Lo1EvS5SpS/4RWhy+EkGw8SEyG5WXYVK9Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AHiRDrVP; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHiRDrVP"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7025e7a42dcso952726b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2024 02:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717408118; x=1718012918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rQK0UzY6zulkVmCQbxCNwZl+c7wvzqywbBNaeUhiHnM=;
        b=AHiRDrVPeK9Za5aBzA/9CR29IYHV2w/lIz7/Mglf1bYTCSvWRf2OLogrGrhztdjedH
         TPgGrfQYUYkkvSLm5XEQwq8I5SN4xP/gr1E/fLGWMw3DhZV4s4w64YBxAyj4E6g4XTmW
         lT7U1jqyBQG+ClJklwpwoWErKZvNeS4390VydNkgRl8bV2umvwYXdCSy09VOk284NT45
         W2Fbdz0EpjfUrv0fmb3Sv6i+lesvOiL9FKzlCO5IVejrK30T6zV93L8V9cz32ESqDqvj
         ljYhY4QXsVy9wHMffAZp1M+uLWWCuJzhy9on29RsuIzX83lj4X43qrWlE5Spc27KkMq0
         D+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717408118; x=1718012918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rQK0UzY6zulkVmCQbxCNwZl+c7wvzqywbBNaeUhiHnM=;
        b=lmr4uPN0aEAZuXzp6Y10950V8MpgvBSdFQIz2ufWHYToedqA3VDXN/IRXeRRNoSWk7
         tU0JK6Lu9EX/bkvISqA+ZQSZ0xxy+NfyHSSdKWPOYxpu/ezi6jgmUeqtyXEbgrKXeyfx
         vYpLW/r7C/0gZMs7xsCT4dvpWXbBAP8Wxn9AG9xKz5fVOYc/afwVfMoyIbnus12hIPPr
         NWDyGSm0+qQ0PLympKzwpS6Jh/8qeRvQnYxdzmx3FyQobsY6K8/9Ixa7D7Rjbp5zDyNB
         TMPZNi1AMlItROrA0Xh8Wc1M3YRBEQD4RgUxHr5IRonU9Hc9Qi1cY8yPHHt6PyKCouK5
         HccA==
X-Gm-Message-State: AOJu0YyvBxEihD307T6DZ5zpah+01TDOiIdigtcR1DILgLpD1ne4E2zO
	QuIdkkdx8iUaWNbZbBIq/op0lGAI4txk9no5xwZbxGZSnZlJ3mt95RD+TwoGB0w=
X-Google-Smtp-Source: AGHT+IFPyNRQsemA7NBfU1I4bRvouNbDcNhpFhvNepiQVQBJkfCpgQ38BKWfhekIdx5YV+2pwR72JA==
X-Received: by 2002:a05:6a20:4327:b0:1b2:7b13:ea7b with SMTP id adf61e73a8af0-1b27b13ec2emr5392949637.44.1717408118496;
        Mon, 03 Jun 2024 02:48:38 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242b03ffasm5309111b3a.141.2024.06.03.02.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 02:48:38 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: lei lu <llfamsec@gmail.com>
Subject: [PATCH] xfs: add bounds checking to xlog_recover_process_data
Date: Mon,  3 Jun 2024 17:46:08 +0800
Message-Id: <20240603094608.83491-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/xfs/xfs_log_recover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1251c81e55f9..14609ce212db 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2456,7 +2456,10 @@ xlog_recover_process_data(
 
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
2.34.1

