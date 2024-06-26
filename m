Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924F9A31;
	Wed, 26 Jun 2024 04:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719377356; cv=none; b=qhbM1YEKLaneUOMdKI+uoV3Dw9FSchxPRrIqEwoVJBYDRA0sFrQmYHyPo4hEFseNkd/wwTWAX6Mkfwl5L+5suip+mMmjOOMXdGT0aybDmKNz6ZzKdsQ+CINHwf+kIyocjl884uc14Gy9oO1SsApZKOKRxzV5fggJauY1s2tXA3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719377356; c=relaxed/simple;
	bh=6Dt7XKN/gWWkoSUe/anFSkfct0JMHFUjoOQdigdCoY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KMXStk67LT47twi+iRSQadwvLJ0SQhn5TG8nuIMc9eBzHU8QsgG3JxP7oL9FRPOziOEO4Ir9nmmWtfUzKz+inDrUCH1ylfLwtG4+p9ye4+LvzsE+GbtBbDS9l9o6TlDhNpxEuTbiyEESN8hovPa52a0iSQOJ7je2SB9mHJhi6EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TIiwVMMI; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIiwVMMI"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1f4a5344ec7so1164215ad.1;
        Tue, 25 Jun 2024 21:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719377355; x=1719982155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w5+SCZL6xBFJrCff4JpY/ZI9sXTroZDoGWt636czmAI=;
        b=TIiwVMMImuL4TRjPQ1jWWgGwJGgpaVquaNXkpDQJw1hlj/TZvLWhtSzss183WvCn66
         bmvNsjgcOl7OYxz1GzEBIYjDZuXaRLJRu8ClAYpjtxtrlBLg5OBdfDzcEMIdueCnqawd
         O0rTs6arcyG0tTXNi8e1s4iq3mGWyU6G3rJkXKTJYgoPifMAqjDFNnyo90l6edeyHoZ+
         SoHHSs5aJtYWbCoJ4wyXlfGtfRFIuTO+iOUWmIPKcQQr9y+UnNgOziYxG5+RfaEX+zBr
         WnundSRan5+PvaABqair0prMwb9Cb+oQA/ib6bZNZpz1FiWeYAP2bAuNkUIWOhu0RP8V
         FiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719377355; x=1719982155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5+SCZL6xBFJrCff4JpY/ZI9sXTroZDoGWt636czmAI=;
        b=g8q/UDbBaQJCc5cvydAuKtq5xr+sSvTW0Q/K8bUXJtAP/NLmXQHV695pKp0cjvkcsA
         yp/AIE3JNTIP1sMGEqLbLQLOpoCqU6zqoKWWezG5cNRlmse0pfv2KlDXJqBjqN/r3SsA
         /yGUa6iZYDRhWSn6Y6iXuDh/InPKafHPHVAAQf6+o/9xPYQqv6oli5CqioVQIK/rre6F
         Y2uDDCShTkiugsY2JujW9zeciV5X2MCNNs+g5aPVTz8zfO8RaEeJCAgx7QM03fmbznkG
         Il2zgKF2FL7thzTmGJlZJAaqeTiQqyXJWUJC0ecfpvYAFc9MTCxo/+so5JKOb8mRYLE5
         9cSg==
X-Forwarded-Encrypted: i=1; AJvYcCWkfq/LU1aIJwXjHM0Yx+6QsUUCnVOYVJFubz8crqRLgAb0G4sQEHQH5g7LsYTV8ntX3y3AyrVuvWKOk1h4waiMOAf4TnpXivJWJ/zsYpL572u9YQrLTvO/eXposNIdYC4WTBfS8bSy
X-Gm-Message-State: AOJu0Yw+luT6lAsUy9i18QXfE84aY02Z2KGxMW+vIG66w+NYcj40tQKx
	IFfnanG8LtlY+dRJzDoz7w+609dHBMIRKQiblgKRZ5dtnRTqU0M6
X-Google-Smtp-Source: AGHT+IFxvYwx8UH7TXFQTAd7omh0bHDOc5uls7ujnQVFgrUqbPAyG9Dm7knlZpwIxJcfDSfXETeJRg==
X-Received: by 2002:a17:903:2445:b0:1f9:ba4b:57d2 with SMTP id d9443c01a7336-1fa0fb0494emr151086615ad.27.1719377354709;
        Tue, 25 Jun 2024 21:49:14 -0700 (PDT)
Received: from localhost.localdomain ([43.135.72.207])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb321a8esm90110685ad.96.2024.06.25.21.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 21:49:14 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: david@fromorbit.com,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: [PATCH v3 0/2] Separate xfs_log_vec/iovec to save memory
Date: Wed, 26 Jun 2024 12:49:07 +0800
Message-ID: <20240626044909.15060-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

xfs_log_iovec dominates the memory usage of the
xfs_log_vec/xfs_log_iovec combination, and it is no longer useful after
the data is flushed to the iclog. This patchset separates xfs_log_iovec
from xfs_log_vec and releases them early to save memory.

Changelog:
V1:
- https://lore.kernel.org/linux-xfs/20240623123119.3562031-1-alexjlzheng@tencent.com/

V2:
- add kmem_cache for small object xfs_log_vec
- reduce redundant free and allocation of xfs_log_vec
- https://lore.kernel.org/linux-xfs/20240625182842.1038809-3-alexjlzheng@tencent.com/T/#u

V3:
- simplify code for same or smaller
- fix warning: unused variable 'lvec' [-Wunused-variable] in
  xlog_finish_iovec

Jinliang Zheng (2):
  xfs: add xfs_log_vec_cache for separate xfs_log_vec/xfs_log_iovec
  xfs: make xfs_log_iovec independent from xfs_log_vec and free it early

 fs/xfs/xfs_log.c     |  3 +++
 fs/xfs/xfs_log.h     | 10 ++++++++--
 fs/xfs/xfs_log_cil.c | 34 ++++++++++++++++++++--------------
 fs/xfs/xfs_super.c   |  9 +++++++++
 4 files changed, 40 insertions(+), 16 deletions(-)

-- 
2.41.1

