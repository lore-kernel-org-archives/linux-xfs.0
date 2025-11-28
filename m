Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B302C2376
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318818; cv=none; b=Dv/BslTCmbIh8uqPE4JN4SNNjN8vrLDfSxnLOkVqPooRLiDw3Zt/vr6hiawjbUYp3HkuSAS0ak5RsPXenp2VnnuyA8hNOoGNv2zbK8Zh9xkIQiO3sIbDJBADaDGB8mVT6nkRD03c23nVSuc0Dgey+Fcs1fqWhOpkZjooD7CsZSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318818; c=relaxed/simple;
	bh=MIUxfeIlXsLJb7D1x07khmxiQaV6FMQZLzsNI6cDMOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pQ7iKFzpBOYysl7Q99UvFtFSdWBoCjlqtjCI8uxba6Hfl8t5zcgchNGXL6VMenreLsljsrROBh/E+JHSNXcZ3mCvsFlOpxF0UN6Lq9XGb8ZrK1x+U0e3YAYPMf8bWoepXvvBES09ZXSG5Rho7nIcDR8kVtCF5y9L7aE/WK7qwl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EPebDMuF; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EPebDMuF"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so2014975b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318813; x=1764923613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=EPebDMuF2YtiYM5kWUognxF1g/WoiT8JY4hRj+UZWVAgcw0ZBaHphOeRh69Nohxc8i
         TyzMJr+38d0Tl2NsNJOhzXHIkFZGFHbugNjrpwwKUwcZt/cC5mIceCQPGoJe+AOIno6O
         Zi0P0ckYCidr4AYY88DJy66bFtSFswpp4MYtYcik8TkCJ0ii1nfBS6GYTIoQ2tFugh95
         t/d73wR2vgsVU69F+rbxseA1CgyjXU8hLdFy2frc2xvhc53gQa3EIN51+SUuq4MVp4la
         lIfvjkONj3NgGeL3Y8OOOMLPCvQjce9jSxDFV9zb3Z8iBoPDqRhcCx1pf3xMxwRHxNoK
         ohLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318813; x=1764923613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=fWB+ccONZrRiz08xzrBp+sSnYtGbHcSwwXEfCQ4j1oMomtnuGe6gEb/86Gzll30PzK
         bQ93tVdAjdHMMztrtvI9EKfZkKSAJkpfVElyAgSxd23Go1fxr4FpCj/61qitXCB/drc/
         /12FlLuTnB9UYe60xWxF2ekUtbXOb9o6eCiXK9LYGx5/qG32ftMyJwJHELWDUeI/+7eI
         S5zlxZM1eXdzIbg6mQLUy3bvmF63ar8z3lSW1fA4rXNF1Iaseuewl0mZcEAbfa379u+X
         c7YPsVCZYEolBp2jtvU8c3W2fB9ED1/vOh3LMKaGHl+1FHH7tohBptdmaYPa9NANs+3f
         bqIw==
X-Forwarded-Encrypted: i=1; AJvYcCXr1OvDSilaVKLRw5ja8THqQ60a9BAukg/r2QokGYGidNmUJv/ROIVQhMcBWHTIETZUAguSXjLV7Sc=@vger.kernel.org
X-Gm-Message-State: AOJu0YytBEsx8zPFWv7nIgNe69Y358yqnp0i9T/7vqT5J4muGDPzE3VB
	P7eID9GCIdlz1ALkeNXyVqHSKFyEaReTuuuy6Uoe1pJN9DNYsYvJvf/p
X-Gm-Gg: ASbGncs9+Y2NLTYDY1PHPKJkqkZHWeJvYTVfFsqIySIjkioOis2F7riyHEO/Gh3ebtC
	pOHrBA+w1uGahxOBsKKdjazjlw5nPaLEPJ0AaCXXje88oFaMVdRzHBp7G84E9IaxAnglepfREeK
	ff1BlaTfWZvgsjhxKTBDZoLQoYIjZZeThmRgmsQ0+PWzfkVNFxFEu2JCeU8EHev4bxdjrUgj/5j
	T5OxK1qKjL0JWlnus82G1si+XtG76nRgGlgZ6QFHJVd5tFPE5EYUoqPY6q1dIMJAc6aF3jdBst+
	epyncM4RWnRKvyFOLa9ng2/HwJeHcVa7wAoMkgtZyMlFozXmqBL42e8t2gNXG7XnRorKn5Rguga
	sym1HvtgX6jO3JvhH6/FlPH2oR639lS5iPGrIU4okaoytqE9gv5Sj8i/RBcqTqVNhkkf8QrbsB6
	s74MQUJ463JZ6os6/XD60eEjSF1MMtLJI5FG4H
X-Google-Smtp-Source: AGHT+IHqHdLof6s224+GbtnJAk22/n625R68t5gW5XXJrnH8NN05gDy1A3OVkHY/4+FwyWeG7e9t0g==
X-Received: by 2002:a05:7022:3886:b0:11b:9386:a3c8 with SMTP id a92af1059eb24-11c9d867ff0mr21572562c88.41.1764318813388;
        Fri, 28 Nov 2025 00:33:33 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:33 -0800 (PST)
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
Subject: [PATCH v2 11/12] nvdimm: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:18 +0800
Message-Id: <20251128083219.2332407-12-zhangshida@kylinos.cn>
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

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/nvdimm/nd_virtio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa2..e6ec7ceee9b 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -122,8 +122,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 			return -ENOMEM;
 		bio_clone_blkg_association(child, bio);
 		child->bi_iter.bi_sector = -1;
-		bio_chain(child, bio);
-		submit_bio(child);
+		bio_chain_and_submit(child, bio);
 		return 0;
 	}
 	if (virtio_pmem_flush(nd_region))
-- 
2.34.1

