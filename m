Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE544854FC
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353447; cv=none; b=miaIw/3uDh8LlwufcGXpk7DQTcANNIj0pHiCbQxFxnVBKq2sJLYzK0hbdeltGTmKyMM/6xutbfbn5TWycCf8e2jKc7pUsTvj0b0sLkbkyTL3VGf/yHmdxben5X+QprYYN+WMs488vF9Ww9DOMtvEo2AjrimpJKRYRhI4swih5I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353447; c=relaxed/simple;
	bh=Uw7C4e5uBhT8vXzKYITTNDOJUa2oJzwBgsvCUtyl1dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGW3CxoXkni/pI40b4VILSlsKWaV63l8Yw7Z68qlXs2NX6lcAW6lCKAUTcb1EV+3qoud52DFcJ4gq27R2FZ4YMsx5YUdxHQ8pzebWmrDLAe7aK3l9wuuMLiMdO+a5Z09NAOaVQSGHt8baPUdGO0EhyPYvqk4T3Kffqo63E1wQOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CB+iZfNb; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CB+iZfNb"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ce98cb8165so445815ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353437; x=1785958237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=StgZMYvucPudjQFyQxx/n6i1IzSm0NIyISLaDyFfQ88=;
        b=CB+iZfNb8n1QXOPMjAuwEz8vRdsdStTKjEWzSqsEr6sNZMDsC1sIC2EQG/SBgyxx4H
         qdi0T2Aprc+q96d47OZMbAU+/N3OSvbF3kkOvI+Qv1gOT3wgMJERREMsky3UXNBMdtHc
         zc5U1XB/my0sSkx8ESD8CNdZF0/twawTjTOI3Mv7sekgMda0THc3vr3WbKkueFB9nrxj
         FAWn2RiP/RxuTqln0s2U3EUm7qgrSsAQQg2Si6xByNBN+jRy5dFdhPwR49LGYlEhhxUA
         7NqD+CbCSmO0ZFlRhhhpVQ3NWXzbzXOz1T3z+/P25/6NVqqxmZRulyqi8HK8bwiu0OHw
         Xqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353437; x=1785958237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=StgZMYvucPudjQFyQxx/n6i1IzSm0NIyISLaDyFfQ88=;
        b=BH9z80PBr3mIOwMl5YZdIVWiW7bQ3O2ZF9VoA3if9MzObHDHSnvmJ4G4ec661xl1da
         +C3s7A/oVT74jqBSuPO03gZVGRx5VIIzw5rPQ++xEbqglO9YKena1uMAaBzfNZxgIKnv
         AKOIo85YDoWmjWf3DxYp1p7/+ZF92kID3WiEVL4wLti/wuREUOVOPsarKzazByq+AMlU
         1NgAEie/c91YBD3bEpDsjUhzYH4HYHuUw+yc26IJCG4Gxg3SkVnGsJZu/0NK+4g3h+QE
         dhcS2AE45/VgMMSpo3Vd6N9nhG702lSCwdA5fXg1LWaAbmBaVfbUoWVisw14hEqXLSYa
         biMg==
X-Forwarded-Encrypted: i=1; AHgh+Roou1KxSD30QRR5d+1PRXE19L+jLWFjWychvYCj+1FHiYert9sXJ6UZGi/WmuxptxHs6usGum4zH9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfOcqfIcs2wfmcr8H25QF1fz7CulMX+9mm5KP0ZjowktKx5wYg
	FfzabaSZzwxQuToJH6NW7qCpPuYq4PORhUK/ISe4gP8HaLON4wKO7+pF
X-Gm-Gg: AR+sD10UvTOYWZuM+MI6AG2PUzQRvta/6ShfkjxhlSElkvPnYLvBIdHPd2OfSLYIGoN
	oCwOWZgwUUsRucj99tuVlvYbX6rYqdIQsFL19mOn8feFokhC0qWLkDDfPR0t2fQxySVKRG5ulTT
	3q13HZ5tO6OYfhpL59wZU7+rhDq3+wD9mKvTwCNd2o+ho/k/u3+zPcRZxuQzyASOCRdThzUqdTs
	LPGjG5lxft7vBHIXDx//auIpdtgXhvU9IsM1A/npztnP85BmX8oc4XrkQn02Cwg5n0Q6omtyHbi
	GgZYdpNDq/R0szUwj1ZFSJZuDKM38MMeZUuA0j0noc/a807L8pY4IGJSWx3MJPi/29llW9IKFpw
	seG+49K788K98zS77hR8XuYQC89vSOsvUyqvkylXo4SZHPrF3OSt3grtb8t6H7f2eAEbdsB49bl
	DPJWIPOQkPZya8UmxN8Ecrik/976GGSxqtP4cEhtgpW2RziRLbiAKau0dHrSG+BBvw2apAqg0To
	/WvTORceXdA8YUyg6UatszUqhqPdahoxTDJouQ=
X-Received: by 2002:a17:902:fa10:b0:2cf:b9f9:18bb with SMTP id d9443c01a7336-2d0266889b1mr22693885ad.4.1785353437030;
        Wed, 29 Jul 2026 12:30:37 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d024b114a5sm14066635ad.21.2026.07.29.12.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:35 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 20/22] iomap: remove ->iomap_begin()/->iomap_end() legacy path
Date: Wed, 29 Jul 2026 12:27:35 -0700
Message-ID: <20260729192737.3190206-21-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With all in-tree filesystems implementing ->iomap_next(), drop the
->iomap_begin()/->iomap_end() path.

Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 6 +-----
 include/linux/iomap.h | 6 ++----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c445a38b6285..e8a988107530 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -118,11 +118,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	if (ops->iomap_next)
-		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
-	else
-		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
-				ops->iomap_begin, ops->iomap_end);
+	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
 
 	iter->status = 0;
 	if (ret > 0)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index d203d9fe0f89..0bc1beb47a09 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -195,7 +195,7 @@ struct iomap_write_ops {
 };
 
 /*
- * Flags for iomap_begin / iomap_end.  No flag implies a read.
+ * Flags for iomap_next.  No flag implies a read.
  */
 #define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
 #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
@@ -240,8 +240,6 @@ typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
 		struct iomap *iomap, struct iomap *srcmap);
 
 struct iomap_ops {
-	iomap_iter_begin_fn iomap_begin;
-	iomap_iter_end_fn iomap_end;
 	iomap_iter_next_fn iomap_next;
 };
 
@@ -256,7 +254,7 @@ struct iomap_ops {
  *	incremental iter advance.
  * @status: Status of the most recent iteration. Zero on success or a negative
  *	errno on error.
- * @flags: Zero or more of the iomap_begin flags above.
+ * @flags: Zero or more of the iomap_next flags above.
  * @iomap: Map describing the I/O iteration
  * @srcmap: Source map for COW operations
  */
-- 
2.52.0

