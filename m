Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E262566
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 00:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708388687; cv=none; b=sBpJh5gtwS7V7GmncbGxBfOrfE1Wb/NAacg3HnPe9O4malJt6q6gPSbgzLtFuSdtfAzEK6V3G9jzEhoAFBeGhdheb1FdPwdfwN81X4I/qxBdA3QlN7isQps8N9oZU205RW7o6OXpJwcYte1mvPxzxSGHBLdtM9MEEKv7Az6MSd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708388687; c=relaxed/simple;
	bh=Z1WPPWOpKzUEMVhEzKoPURqhnyvM4o3QwOmnqCgKO0A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=krjQCEgE5GeCBXDacPNPveW2wQn3Se24/VQRurXZrIZ3sxBWJruSw2rTaKzbFpeFrFEdvBo02UroB7EuzSf5Rgg24hww3sLbCM1qzmor0ol5x6b1Cnue1SM8kv8EX45hl2mg2znEOBslx2GvOVCTxcCiXPygsg48HG4IXf+FfDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=JSl4eLNK; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="JSl4eLNK"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e45d0c9676so1099863b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 16:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708388685; x=1708993485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5YgTVZFVJj0a0XSQoTuaBmq2NislUyolaSS1Mb9jiGw=;
        b=JSl4eLNKN7YD6LNsHuJYaLQpRVbKLqYlZaIwLf0wjG0ewN8zod0XI66+YdOiRKjzL0
         hycX13NZOTHTAP+B5hlxWBSO3oBvErL4Kj6/vWt2r118dw8mC8EAEXV+QostCJK4B7iJ
         qKcbYpwO0SH+Di1r/BG+eEwIlpP6FC29hjW62AYcUL9lZh4dwtQ5yDPEN9AQKKq2o33f
         zZlFl3tagNgxzc3TvkbC5mf3sGuGjmMgc9HfFS030XzYKV3bxpPgzFHry3QTeKorC05m
         kqf50qYMVmy7EF7dqWNNsAOT7SG/PhnkHCyBBwkTCp+ZNpTDWo4BL6kNapExH/d2Ym5Q
         cHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708388685; x=1708993485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5YgTVZFVJj0a0XSQoTuaBmq2NislUyolaSS1Mb9jiGw=;
        b=k0b8eFV9hqn+ki78lGfnk9zFPVC0cYrEgUAf7RZR+xTrCHPdlhBKuRhiwbBYc2jf/g
         wpzQLZNMlFuiUBUEofg39aQTBPchZVVt+2lx/HuX6yElkYcARQ4e4hUoQ2A4Fz1OpDnc
         SqpwtPPDvQttT5G+U1K4Cdb9W8g/kb5rN2fxDaNpC38wb77+z7dZdru3OO/1SJ/EH/kF
         nXOfeXr5NPN3f8EAFU9TSPjasr1h8vuBF7FO3rH1BUnxWBhs8olYG1Ps8mjKNeBnz0+h
         i1iya+td9RlGcDaEpDhDnlNtEO6XpCMjYcyAFg3I1eflv2f1bR44+mqm0zjCsdXrdjtY
         pT8g==
X-Gm-Message-State: AOJu0YwMimBbMFK14MJG94rs8m6kC7FXhm7JgPTHg56QlXlx5yTTm3Zy
	NMHYeefj/tJFaHjCPcjnVHvfyk8wCkobwYByQKPENu1iDZMzn+CST6ruSx0WAvr0sYiKWd+w9Fs
	i
X-Google-Smtp-Source: AGHT+IE/zGSutUCfaYwQpHjZipa7hPr6fOOfo7gygxK07zBnXM4jo8s4wrxn8Ie0eaHx1Yeoa0Bl2A==
X-Received: by 2002:a05:6a20:2d0f:b0:19e:9da4:1a10 with SMTP id g15-20020a056a202d0f00b0019e9da41a10mr20486700pzl.21.1708388685044;
        Mon, 19 Feb 2024 16:24:45 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id r6-20020aa78b86000000b006e2f9f007b0sm5131565pfd.92.2024.02.19.16.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 16:24:44 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rcDwA-008q5J-1j;
	Tue, 20 Feb 2024 11:24:42 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rcDwA-0000000HFmL-08Bh;
	Tue, 20 Feb 2024 11:24:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com
Subject: [PATCH] xfs: use kvfree in xfs_ioc_getfsmap()
Date: Tue, 20 Feb 2024 11:24:41 +1100
Message-ID: <20240220002442.4112220-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Another incorrect conversion to kfree() instead of kvfree().

Fixes: 49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 02605474dc19..8355498de430 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1636,7 +1636,7 @@ xfs_ioc_getfsmap(
 	}
 
 out_free:
-	kfree(recs);
+	kvfree(recs);
 	return error;
 }
 
-- 
2.43.0

