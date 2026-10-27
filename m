Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138320;
	b=Q8okJHNA6syn+H6uOI/wRwirzzLTETdQngXX7SQHZX7zPQrIHH8QoV0PAxGL/b/6amCs
	 FHOQtYLxWHFVR6YIrxWuXNtn8f/yG/1BNARWYarbCbgBUd9eFCqDJga6tKlbMc0Q4Z5mw
	 hOPbYccsLsiZpGNzgu70YicyjieY0Mgpw5ZqBUn0bTc+MUf/Vl6AE6uGXBAOYbJpUGIH+
	 0Iyo1PSPMw4wPlXDUhqu9G4A2BsOt+bjRt1s1B1cmYezmIFb0eC81HerFPvhvbWDt77Bo
	 GHQg0AsxBkrmk3VBsmZfR9d75NTuEdskaQ5qStvVW8C575fpI3Vl2210+ZrVFYGs2GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138320;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=43G9CXaG7qSF4UFTj5k8Ql+kaR9Fc0A0Kgr5LG/j+HQ=;
	b=osnYgwogThUJX8cGtlJIDZS9hbGvgNxLvPkx7w73t51TSKmXBm0tXLhD/gLNeGUWripz
	 ZuT0YrC3G1cfYuQuglH67sGYy31ztN2LqHrS6uZw8UtRD0uBchw0r3vRbF94RJXK8+xsC
	 h17Z3Hn3ce/6Enjr3xuRd8o5QhSIeUAwen2GH+f9Z5Qn64a1O0cvly9NWSyn1E++7Ab2S
	 TAC2b4gMoHJ6Oc63tREbuDUhEtb83xIGvQtWIODVbtcslagAEZpihZkaIHmkC5/dYYT53
	 ingGfFmufK48fbicq7EYk9FEwGuxgczCn5TbQM0l2ctz0U5Egv9Nl0CYYU6VqyT/BvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0JoWngSl;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A28E606A32F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:58:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A28E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0JoWngSl
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b118bea471so2484867b3.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138319; x=1793743119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=43G9CXaG7qSF4UFTj5k8Ql+kaR9Fc0A0Kgr5LG/j+HQ=;
        b=0JoWngSl/7Wd4baloUpWZfgYNcJsVWiereAE7th7R2Ip+sXgtUEhPJO1hjFXHapzbR
         yPAtjz+ezQBhpAMDxbiS6NCatGfpLLaiWx3O1DQmpz0O86H1LD/XTr04UMKmlmbO/Vo9
         4xfaa0gGx4eWPRM/ewD4WBEPFHsEj5k8P9e9oSmnQTcm+8DivDfjUd7A5oR3TGka4RC1
         vJv+hHOEGLK5VpjdEhPVM/J2fOv+egtjbFUGk7eBJREyknkrXfZnUtf7klqTWt0ENeiz
         xUBRXMjgnVeAVE6Dbu/WEYJzXgstdrpDAg+ijV1WUiyayiW32T30xxd0cGoPgh6z5wgq
         Ns4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138319; x=1793743119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=43G9CXaG7qSF4UFTj5k8Ql+kaR9Fc0A0Kgr5LG/j+HQ=;
        b=YFcdMQ38w+XUuizPXOFGy9ev+iimGRG/if3gHqy4dTXQx+gshwcDoqEqU2VGaxHpfZ
         wqvDDpt06EsD7jHSg/En5bimywZnHdVlhubb9HLnh5ePhRd/I4VDjis9pRn0UNL+CeBF
         b9Zod0d4g0CYTDc7jsga3Dz8M8HWPc7IWdE9bG24+N1L7ZBC8Wg4WB1UwgpEu3eRW/KX
         aD+Yqdaqo7jqdlOHd63hNVbNqWlz+Q3sjJwER0Ia1MKGDMObLtLjkhjCQ6Mo0FJItFT3
         nf0w/ypIMcSa9NsnO/PHkKb1WSsq4us61G1hpcl2nO6UrE7mdKcSCK8qMPn80+mw04ET
         2Odg==
X-Forwarded-Encrypted: i=1; AKwUvBwsZzYJHrkC/YzDoXLlcSffevUAegaJOOnRrfLtHC+SetcWucCLHBtZ2dsXkm+lUHyT9nqKM9hQyR4=@vger.kernel.org
X-Gm-Message-State: AFq9FYLwc9OXvCGNhN37LE5xL6twoesTIvuFkc3Gva50U5OgWn7e9WCh
	3lNvXhBiUx+G21HqFbsM7WT/04rBDSMqNMtpyO6so9nBQ3PQXhtRsjIC
X-Gm-Gg: AYBFou391hwKu0Pw7137EcHHxBUCHQhtd/egUobbElqYrJHV8XfdW28GpHJoDLRlPXv
	H7Kq+saxvILgGln6M+t133TyjekqJtnIB9OqOQxgsGkl5jrdKA8W5LbbNmt5aSDoCbJnf6ve+k5
	EoqE2rLB32fNfQtm5kCWReinvPGeE+R6Z4m5y2jlDgFHCb4jK/T3QTfAobdaSKDLoGc9BWHZAhh
	fbqKoXJ1MmxWoMqtAclGPM+NRQ5lMuBhu4V8DIyxpf4lFx16jcWHwdrn/mvVFFnWvwyDzd1P7JT
	WGuW5RaLuLBZhq3WqGhveqh/ga886/4gZGBCx/IOh2i4oOWYp+tNVLDge17S/1K4Eu/KajjlT73
	46dnlVyr7/HQqvYolpcn7jGaz0G/J6wBJX1sIQXKY2oi3EJ/7nt4u8wAHXUHcoXFyMfIMnYXLXC
	3DfsGQ42ofIHktXdLKuWrKbFLxNyvOoW2E/6NJ62Qte6GYBw46rIwfIcMRz6plXmLR4jyuKp1lr
	N+Yk/nH8HMMrcwYfP0xOz5pRKWyRIS9VtSmloBwOl6fkUU0Z8WBo+SQBFj0oIY8O+PCc1KeRnlv
	Eqj1et3OPXc6ZV01mrv+Fz2KdWfSyh5G
X-Received: by 2002:a05:690c:f89:b0:8ab:485b:9bc8 with SMTP id 00721157ae682-8b1b5a8ceffmr2994117b3.24.1793138319600;
        Tue, 27 Oct 2026 14:58:39 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e5b83b9sm18877967b3.27.2026.10.27.14.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:39 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
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
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 3/5] iomap: remove ->iomap_begin()/->iomap_end() legacy path
Date: Tue, 27 Oct 2026 14:53:24 -0700
Message-ID: <20261027215326.2693300-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
index fd8791c4963b..8b6da9750a93 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -119,11 +119,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
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
index 59718f73c15a..95d4995a49ca 100644
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

