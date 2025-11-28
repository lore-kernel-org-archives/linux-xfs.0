Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EC22FE076
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318812; cv=none; b=i56PlrtnLO47rig2yUseFvy1MpJMIKDXlaaMoNE9qYcp+MzRro74JSJJXbr+jOnodkKRqCLMheu8P+2csmtj3uGH46KzdqEcVmt+lmwkL/83fdvM8MA+omTrJSdA9neclLOOj5YrS6XnTOdjwI5c9FQNN+plCFKyn9YBmi/ELsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318812; c=relaxed/simple;
	bh=TbxNohFMmSKnHTWH+mnyMfPFRdWdcWW/LS3/VsufZdc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N/YEf7GkGfrwDMgxq4YaL0Mp6fhqfMtP5V7MpTyEyTYTOb7bFbGe9DJYPKbTdj6j0zA8T/WSnCI9l84mi/Xx5WuiL4OyenKoG7SikrWQLal4tcoJFN6wwlpXMsgTP1w8DZmEPNtLeUwh4zy5tYxlw3Zu7Xob7O7U3TPC2H9uU7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AjmpIAyJ; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjmpIAyJ"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso1459040a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318808; x=1764923608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJti1W24hnwF4OFg7cS4jWnw0eZv9xglyyGrmFluATQ=;
        b=AjmpIAyJf6JuyIrhAGiNid6XUAa4g4RrZwnHclHp/pVWuzH1VLVvZppOCoNcecZmRJ
         TsroiT53VAQOILzAKA/KT9wWusG74M9XHGbLDWt9nWP5Ig7woXGHCDNlIisELR81PsjM
         Gj1gSPdcetRXXQOL5NzyCj2+NiUSYFYbhosk8SNnwkX1mSVNFWcpBxxhZDts2K+D6eiy
         qBcXBeSo4t2Bb2D74uAI9RGN+1hwtAaIr89QCc9QNUnf5EF1ZsEJCCrBHz98uJ9cM/qA
         YaESTKuRxQR7U4wZ/SDPPSNnnICcG0SsaBX0ZTDgsGddCJFYqBHmxOsLbs3KuYOtZYGx
         rQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318808; x=1764923608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jJti1W24hnwF4OFg7cS4jWnw0eZv9xglyyGrmFluATQ=;
        b=nvK/j/3IEfDpfStg6DOw4fiuchtwDON5uWNgrWC40HEQhYIpN8CLCu8wPsgFRKh6wj
         G74cQGcF9ZZ/nRuRFbwNUCiCfvhDbBmLGpcHPQkgVhXGGu/W6zpywC3nVz+g67cqpYo/
         BZQyH69FsM/LjRTEO0D+hb7ERzOoDqBK9WB+p3B6OOeCOY1i8C6e5nFbUyu5yroxNsvf
         8rU8H6qwwCya8lPNxf6+n/qvnpa/f9D3yUAoq1WAat3Lltr565VngdIcMYBFMHqMNey4
         0Md4+sNXNMVr9TpgDksNz8qqtCyKkzDuAXXAylbn6D3fbDLKn3kYtu/0gLLxw62cnkMk
         471A==
X-Forwarded-Encrypted: i=1; AJvYcCVg03eIsI2tNTddsLC8oln8TA3xfSJ0/48wlEDX32Y3xUjO/yueecTgxVtzHz2V388b1l1qBbB+zEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmCLnEkzml4EHsvLbIpVusQM/iJH5NBgsB4LPrrknkeW+e40vD
	N1Pz6324etGTyGW9Bt2Yt4zJ1lfwYedIXXADPGHY9Fk2ayqO26RXjaGV
X-Gm-Gg: ASbGncvmw2hRI6kLmX4k35PfRO0NaMGv/7GtuVlc1jMm4F7twZ6zYmIEjwKvRrG198H
	Cxu1FFANQ8hL3J4nZb+0UOUD2qmLj+jfBzOfYj2xeHNb4uqv/dQGh3tUJKVDEVhthBYczhRDlr/
	19MDqCjxL0YKglgA5eeVTKPMyl6mXKQE+u0yph26f7I27KzidTgo8cCILhRE7Oj2DSx8FjkFA6F
	9TIHwrdj8gSmVHtkoWSg8JDGEl4g6ufsSYP+80+T+MX68BD9vOIUAqiPF5tRTe/mzdu0HjhDY/5
	H1WZQoOzyfS/WbXAj+d3G5QXUJahADyw1LGPteiDPIujH2HcZYuthCg4WhEsBSw8CXxHrMK5/6/
	vBEEI/T6+KqMjxv5cOAe8O5XWQ90svz+q0CnKcCqDzynU98aPAtvTm3DgIiLq87hJmUUlvG8Lyf
	vm/tTlmIqsGM38K1nwwnilgY2pwHakVKPKzmc5
X-Google-Smtp-Source: AGHT+IHDsMToqUoj0PcNSA32TYDuHE8zhBuDir1BrYt+w5Y/wAZYCWlUzMNg1Dgih3T9wVkLcbd8Tg==
X-Received: by 2002:a05:693c:2488:b0:2a4:3593:6464 with SMTP id 5a478bee46e88-2a71929687fmr16240699eec.20.1764318807899;
        Fri, 28 Nov 2025 00:33:27 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:27 -0800 (PST)
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
Subject: [PATCH v2 10/12] zram: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:17 +0800
Message-Id: <20251128083219.2332407-11-zhangshida@kylinos.cn>
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
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a4307465753..084de60ebaf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -730,8 +730,7 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
 	__bio_add_page(bio, page, PAGE_SIZE, 0);
-	bio_chain(bio, parent);
-	submit_bio(bio);
+	bio_chain_and_submit(bio, parent);
 }
 
 static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
-- 
2.34.1

