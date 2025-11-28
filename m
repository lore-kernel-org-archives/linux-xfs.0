Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047C52E62D4
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318765; cv=none; b=Zh9IEMaNDoRUQw1EH/OgTrujPSY7yUaGKtUCjX1RrlXgTeTXWypFpK+Vv0YZcjk0z+TrlFXZuLjZCw+sgBfnXWG04jaYBc0N9m7KB+vF29GKD1G7YNUkMEj7JVWzS7N+crCPqUhWHxviyTHZME5gChV/+0Ezrpxpx1EtDxBOqkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318765; c=relaxed/simple;
	bh=nbYby2EM9de8liKCH6EPXwLAr+CXSG8jGQgCdHY1huE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n4rwibzc1cwO66wQiWoFspK68W2NsyQz/h/OMBzU5PjK4Mkfyzuik8CrKzYHmNxziIS7YDJe7f381+gAReT8pFRRkdAepeWS0mtMdP+DABbqMz+kxb+l9K3f57V1yMmfhuLTZhND+0lBv3w8Lk8NiMW7KFE+Lkkj/LkJKD1k324=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0pYmYtI; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0pYmYtI"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b8e49d8b35so1864641b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318763; x=1764923563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEXNzDk3PZG7Vl6bACrm82r4Ym6fDNxq87feOMpROvE=;
        b=g0pYmYtIS/P7dMpQ1erDvN2bSLVnJDU7lfPJm1A2SlMQjNBQa0vNrfvHR4fXZBhpk5
         UHRMokyQSBTl0qaE3JcHHjjzO+j3PO6PZZw68b0dN4GXFSq6V9WKk82w6wWAT9R7RgJx
         Wh6GPPHmo2ZwNIyqiALQCK1pVIyYtvwQYG0de7CQmuQue6EWrwpTb1wqyydFo4rXcxLq
         Pr+zD9mGo2fPUSWhfV6YRfBEl2sspB1q7r70DKpOYneMHO9D1RsfGG9+nwBfqvatPs3q
         zb60/K0hz8NR7KTGUotMJkf8DtF0VssVC3nk19wz4i81NPAA1iiacVVw9QpzvP+yDqmA
         Dkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318763; x=1764923563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wEXNzDk3PZG7Vl6bACrm82r4Ym6fDNxq87feOMpROvE=;
        b=QXpNPvfG0RRpB1xSY/ALJ0NgdRk+fnxEyJsvJ7r8Sb7t4/mzBE7P0cPctk/28pW51/
         nGPGGDA+UY1KoJGJWv0/8YHNZ/rdkIQ8+x9mjL2UY/71fup+c/MAHvaAI59ko2YLqWUO
         r8Xk/HgzTO+a8rInldnRBM23Cf/DkqhJFvnFnnggaXQVazObEjFjy9hE9vBMk+SI1Rll
         8CLa88qwZmDOzIwmpPwfUbvGDrot7E8WxIqiQqQGHvpR7lEbtCkbUxjDcgqb3ZH/AaRQ
         WPFxOr8Bg06jQaZYULreGHkeDRNN6CCHH46DX1siHWlOSimWmPTBzA+y5GjOPcDNcezS
         VkLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDLP6WBFYZTx+NZaxS4YsEf7ZItiSFGX9MA41QsbPYNnkqcg+oFNPay2I8BkuQHqgPIbZv8ugzfuQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVgAJqvpg7Fj9vQU0uYrcckbdTzy0JJ5X6ndStp28UF/p+QNYX
	YQa9/zJWLQ/3NVLpavTLLBOVfWwmhgdA1k/P0YtloBLXvXfB2Qxp7Qhr
X-Gm-Gg: ASbGncsAPGtJUv2TNuUkW6fPMKVotpcQJ9NxtxJIXh4ClOI1CLpdYuAToF0TuwiqNxB
	50mbpRYIQ7n1c+y8jph6LC1Zrp/pO5aTMDkYYutldi6AAnI6CeZwbLTnNEG1Q4WCoBrjvJMdsTL
	PqEdnyx/kKFYbibVADQldowsHKkwXlkTFjsbsy93I7ul3aB8/X0EXvq0PUOj7P/WAL33nVgrjL+
	/IbTDKzuI2M6I3ssJAxd/o2nRtNowx/A8sBO6uaFJpYFTuW1vYl07DiGmv43l7F0PT6qyvzy0rz
	IoU0lwClOHIMZoE8hsZQlKJshY79+qBrMoslYnlzWiw+rKgtMP4wf/5TNUFi4rRxFx/KkpEgdKp
	AKVs5y6o4OvBYIdUS4YxJUQ91Kj5m8c4oegqq1qzo6MwK2NAJ/RBRH4kHAbwtC1Qlml73jFmudu
	m1IBhgpzOFwBNdihhK59z39yJw7A==
X-Google-Smtp-Source: AGHT+IF16ld9QNCqaVETJUBsXYjs2kY4Pw4mcEH3R6jDofKcar8TG/UX/uqF2Rs9fZ+s8kH1ElEzpw==
X-Received: by 2002:a05:7022:7f1c:b0:119:e569:f615 with SMTP id a92af1059eb24-11c9d712704mr11436137c88.14.1764318762983;
        Fri, 28 Nov 2025 00:32:42 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:42 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 01/12] block: fix incorrect logic in bio_chain_endio
Date: Fri, 28 Nov 2025 16:32:08 +0800
Message-Id: <20251128083219.2332407-2-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

The `__bio_chain_endio` function, which was intended to serve only as a
flag, contains faulty completion logic. When called, it decrements the
`bi_remaining` count on the *next* bio in the chain without checking its
own.

Consider a bio chain where `bi_remaining` is decremented as each bio in
the chain completes.
For example, if a chain consists of three bios (bio1 -> bio2 -> bio3)
with bi_remaining count:
1->2->2
if the bio completes in the reverse order, there will be a problem.
if bio 3 completes first, it will become:
1->2->1
then bio 2 completes:
1->1->0

Because `bi_remaining` has reached zero, the final `end_io` callback for
the entire chain is triggered, even though not all bios in the chain have
actually finished processing.

As a quick fix, removing `__bio_chain_endio` and allowing the standard
`bio_endio` to handle the completion logic should resolve this issue,
as `bio_endio` correctly manages the `bi_remaining` counter.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b3a79285c27..55c2c1a0020 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 
 static void bio_chain_endio(struct bio *bio)
 {
-	bio_endio(__bio_chain_endio(bio));
+	bio_endio(bio);
 }
 
 /**
-- 
2.34.1

