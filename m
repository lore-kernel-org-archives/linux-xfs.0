Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8852E8B7E
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318791; cv=none; b=rXIVBFDjDMrJKOvfzATpkJBfdOqOXv/AsqVujQnE9+q3PTWzypWJqSeFltODCu9K/UqplGlWdRcnyrN2EKJRMmkFHeFfvICFoTbOq7HpjVtw1iponkyfW7GTdoqgLfg6TrtQU/4L2cWahXLIY0Kq1AgIZzi1ToxNrIEj0IQl8SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318791; c=relaxed/simple;
	bh=eIesZROL2LjNY0DrQ6P8R8b1cwhdKxEhWtmo1wbXnYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lk4SzM2AssnHlEWGciG+qyvsCDvhCU6dC/9GVcRadH+RsGdEHP0K7OgsaZg36ycGzy2+P51WVAGMcqh5J+BZtflbpnpTFEs9LLacwjn7J3en4pr88PTkgj1TV8WK2ScDHk5N0/C/fy3vy4tq4+jvnnyHedXmEyIto2Nuat9+WZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ce9ysQET; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ce9ysQET"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so2032763b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318788; x=1764923588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PAlkzqFb5MzFCJaoNDunPaLLzQJH14gDGKiKCNGaT3E=;
        b=ce9ysQETKpds31mQlC/gwbVsfJvDaNd+gtcQa/DCXl7VkYjf1HLWaPhHsipNj+B4Rp
         rrj5KrI+u7YYGxr0HrmM/ZZ7Dv6R0fnJRYF6g5VRxqneCfn0sYkgTcYKSBkJY5PP0CRN
         C0TMBq5qEvlPFfHZ7+ndX4282E9/EnTc6IwZ2vhF/jIBI/A8CxkhIxf23jCs3A6DcIQW
         15uPeYgKnsVoObyd2m0PLj2iA00v4frkuEyUm9Rb2akgidbrTHI5JeDxZ54VSR1eoryc
         hpfQh1VTtH5Y/D9koUbayRviINOw8Kn5PHKXECaa3ceQKiQ2Mqp3mwPpJfqIiJwQRITw
         m9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318788; x=1764923588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PAlkzqFb5MzFCJaoNDunPaLLzQJH14gDGKiKCNGaT3E=;
        b=rNDOBVrIPcrOQflQosETHBOb2b6LYjEoEj16YfxhGncvJhYHrSRGANhblICrYjJfTL
         hEy+Jefn7dP7uvMhwCN7ht90Esh6arvy+P3bZwKel7KLtmX7JIiuzpM3NomW8I4Kwon7
         1uQt6VvVHx+PMBQdtWyHoPFUm9RPScB9kpIVMMUIqAtO1Ebwrs9Pg8gW0NcS3us+f0Bn
         cUAnkg5Cu+pwvGFng8N6mbW7PnHEp1rrvF6XWr/k+wZc4RYSRHT6qTG5ikLCB4E/Yr97
         qPrzsdoEgqljX2tepAZ4s0VaaogU+2Z8mOzjIuBriFTKBGDc5PgrDGEH3iIgiBhO8HAw
         CYTw==
X-Forwarded-Encrypted: i=1; AJvYcCUkfiqtzxs/FgzNmHOrFOg2J/cnWKSB+/OynzViEHpDMjX4opSoXe8wNUH/sLGmvXt4uiVA4griO5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXzPn7YRYU4nA4lwxFXiVgHSmyx72raZCQoJdFTfewP6OWjoKu
	5o261Z1G6o1eJ6HrI+9nsoGVBPSnLRZUSZf0qYbmEQ1PhDpfSR8ANFU7
X-Gm-Gg: ASbGnctr2BF/TRlRumd7vycvxJkIT+OM53cpcR0OEI9HNkdfyea2OlK2wjHBWr46ESF
	frl2y2KklsHMjCeaiqV1MRkvGbJtlSFLYuLKISwifLDL6e+tD6aoUMvXLV+AV/EudlGyKv8jzBy
	+rNqJFm1iwT6TjiZyD4ZijPusavyl5wmJSA0r1E8J0dLFGRq2VDXfChSbWp0RMAZ/stCmy3TwSc
	Qwvydc3TF4/gMA6kVLjdaNoE/xea84dw+n5cdWoqBJwdN1VZ7/xmwe1xY8wmF9FAjWLd0QHe2Jd
	0VToyrA+kkoLP3V8yomwFtsNxTdMSb0ExQ1gM52wZx0TPNppo9QQP7hdjhl4b7Sd3ppbSykqZSK
	4fHQIumMSQZivjDXEanZ6U+fETS0sb0qlAnqqSdPyl0Rxc+SteJDH6JdYT7xfP+E8i8yvKW5bis
	aERj8HnWJPs7IlYQtmEKoILoWaxA==
X-Google-Smtp-Source: AGHT+IFIaFCQuKpxcLcZ63tEcOt0hGjrfoUQN9LWUQ2kBfICDUhGuL68J3zsB+mI5c6KDSWUdB+sFw==
X-Received: by 2002:a05:7022:670f:b0:11a:4016:4491 with SMTP id a92af1059eb24-11c9d84c6f8mr17988575c88.24.1764318788462;
        Fri, 28 Nov 2025 00:33:08 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:08 -0800 (PST)
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
Subject: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:13 +0800
Message-Id: <20251128083219.2332407-7-zhangshida@kylinos.cn>
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
 fs/gfs2/lops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9c8c305a75c..0073fd7c454 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -487,8 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(new, prev);
-	submit_bio(prev);
+	bio_chain_and_submit(prev, new);
 	return new;
 }
 
-- 
2.34.1

