Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F26622D7A9
	for <linux-xfs@vger.kernel.org>; Sun, 28 Jun 2026 09:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782638760; cv=none; b=tCN5ONPw5984+0RcXt0pLTMDSqeYRqGUyqigHs8ct3JT0cu2M5qabXU2VRg4iR14K99GB5XbO/cnmDgi+12L7mRcg1Lpmltbk3/E0ZsG79jDMtAQ+kNxn8f4Iebdr4PbqhRVdv+QlqubmlrlQrLwpDbjbnIyndXxhzxvJCW/cnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782638760; c=relaxed/simple;
	bh=UNNiuzmcBoG+nRsEkI60Cg/VDBcGfYPkQvWMrsNU45Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SRiZvAQgAD+7PtIUvHRahiblBfbehZvqqB01Tg4OW/Jt/jEdzkDKRdfiq4W1FdU4yUQ/8m8HK7ZdWZJYE36QlpKxgRYeaXeTYqVYL6eJjhEfFXNnTxCBXBRHLPikEokhr2whTDyqg3jBfj3WnVUDDmQwia5eRZErlsmWHKx+Ppg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q71PGOmZ; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q71PGOmZ"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-80b9993928dso25211737b3.0
        for <linux-xfs@vger.kernel.org>; Sun, 28 Jun 2026 02:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782638757; x=1783243557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xuTjDHAVL3C45DH+ngv7eazzAslDVL12lledj+rRglU=;
        b=q71PGOmZwgt6qtjjhugkWv6G8yYww3MsEy+RX9Cc7cjOzo1ytZcubxJX5WKjORIaYV
         K0i8HyIL3GTUPV3LpSQqqw9P8Y+i5EKdWyg8TEe+7DgNERz0FX0otgU2X0BtP1ipibCw
         0lHC5b9wwTQNN/iBjMWBBcxl5KOH0sZKqYACW43g25lD6mZRYAwSUHBWwFvMvYTg6jKS
         axK7aIDApGnUQcspCmvRh8jtQhCu/s/ahiO0JZIGTtQS6Q8U0UwLLrWsyVH6jmatTl/c
         i8KM2Rac023xdJ1LvS4gNX1n85FKXt4BfTb6zP9ZIxSPXKt3ReGVrwzXUnpK7S/RIShu
         Xkng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782638757; x=1783243557;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuTjDHAVL3C45DH+ngv7eazzAslDVL12lledj+rRglU=;
        b=kEA3WAt8LeJ4BvsgI2uFxXIXmfPTIEe6fr27s9ZVzfoUOu7c5pJqxn3pgSJK+FRXqq
         0JodE7AqhrdHqqh0kVlLRcBq7enX4nw6PT1agsNNVncXn16rnmlSvT8t7HLtkyE4FZDC
         YhSLFCizXh6nwFkj7QLiQAhG9WpmRU3J+72HabgeJUNCc4jU0qSYlvka1cwn/uHE5ZnX
         ivjezCNlItBFfzVxeH34om0tuZtTkBuAHlVI4c+9ZpktG8e989L7CwQVYB4kTEwlsoGk
         RcCaOGDI7Bq8adwyRyRAbrMi8Wt4kQb+R30VDH62dDaNrKw9RgcHms0AbA4va5XyjAvm
         d8Fw==
X-Gm-Message-State: AOJu0YwUTT0l8cOZeM/g+j/bDBt9nexFLtA00T6oVGcCqGytb8N5idxo
	Tri0FOXEuxYQHcaNWwJlQjI7vU+Cv7GNu+fUsLN8elaFvUlQJm47KLwY
X-Gm-Gg: AfdE7cmZYDp6mixfJtDEilSD9yI5rMvKwXfmZyHEwnKwyrt8+CatjK0w8IXJG50Nkvv
	WqxENkceg94R/JTqsyhGdo9ZSxsuQD/vBHp3VrdDE9DeHkzyRCIHkI9eiEhNX/lpWF7wEwG7712
	h5da3cunJ/vmSE4FbREjelMAU81s7zXUnErDd8M4V6EVhg863LfXir+WVtALFppQMpY+HPIPDvB
	DbuzJiht4WJeDE3xEswTDdY3v4sWnlj4b9bn7ewiiVkdwKK+qC8Q8vdGOOvCS3o+X7Tu3egTH0S
	YXGKtt01gW/pg28QsKcHd8wegr2nbI0v/XeJka1swj9aiF042wv9GbAdgvSZqVLOezGYnSOj4MQ
	A1xeUrhxQu5WK+z43wgzDodCtJ3QfFH8yjwK9Aii+zfd4sVr5Hqw/7wM9IauyAW2e8eayWiupDl
	7rkA8MR5CBldK9g4lIGJA0BGhYqA==
X-Received: by 2002:a05:690c:9985:b0:7f8:7e02:248 with SMTP id 00721157ae682-80a6ae88e31mr124636427b3.48.1782638757572;
        Sun, 28 Jun 2026 02:25:57 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8025ffc60f0sm104475967b3.37.2026.06.28.02.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 02:25:57 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH] xfs: initialize first bad log block in head verification
Date: Sun, 28 Jun 2026 11:25:13 +0200
Message-ID: <20260628092513.39620-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_do_recovery_pass() only writes first_bad when it reaches the common
error exit after processing a log record. An earlier CRC or corruption
failure can therefore return without initializing the out-parameter.

xlog_verify_head() tests first_bad on those errors and may then use its
uninitialized stack value as a log block number while searching for the
last good record. Initialize it to zero, matching xlog_verify_tail(), so
an error without a recorded bad block is returned directly.

Fixes: 7088c4136fa1 ("xfs: detect and trim torn writes during log recovery")
Reported-by: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b7dfbed0c6c2b5e9fd34
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09e6678ca487..d8125f3add4b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1028,7 +1028,7 @@ xlog_verify_head(
 {
 	struct xlog_rec_header	*tmp_rhead;
 	char			*tmp_buffer;
-	xfs_daddr_t		first_bad;
+	xfs_daddr_t		first_bad = 0;
 	xfs_daddr_t		tmp_rhead_blk;
 	int			found;
 	int			error;
-- 
2.54.0

