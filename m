Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2D62773F0
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 09:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406931; cv=none; b=qs+TH4fpT/Em8Vt7O+CbGXPVvMj44ZTWtYw4oL7F+Q9RnsGX+ZIUEHeXBahq6z9Q/n/7KvTGFsDPAzP4u4vVSINJqnQGWUAW3iWXr1AcefsWmtxYr7Gsy42q3TdttpQPMTFVXTbBWlKb6eH7lz+x6CAEyVSF1tfKwwJZtFHJHoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406931; c=relaxed/simple;
	bh=FvdW5UGbfZbg4/JUFTbGCNNccxPDUjVX1PnGr5SdWKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CnLAe3lvUg2xXS53BVJmGs5dqNSpWYT+O6LozjxbCI5EJLBGvIiF3ob0yLvL2JQtb5nSWmz37OXXkeg8fCTSxStdxXkuCRdBEW/Bqo/A9protwcGlKspDKsLeqIJ3+uHyhP4tKcwJEITDH4vzjEoFP7fp8JS7zOhhwub06hAcNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KvKEnGEd; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KvKEnGEd"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so2258756b3a.0
        for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406928; x=1765011728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=KvKEnGEdxZOSVJvpCWC96O0Ouki17yejWWuNkFLSgXJESMxTCcKV3R5H8SiECddFGo
         LGgoM6c3NM3wzleQDd4n6wah6ACk6oVNxDv2pALM/R6draIEob3rNiwrBDCvcUdHN0RH
         R8vThgv664gFfv65bawW5akKeAjAD2zYwPHiksE6BWz6TnsFp1Pt5nhsENWIrUBd1f4p
         HxXvsQVMYFo/IBJdJop0L94t24qoYhCNG8Y5+RtCoE+xOE1KEdWdLKJc6UfrCHrze9vz
         iNUNPYBy1qMNiCvKkwQNvBtxWKyMISN8HzFWXwaANoc5YEux1i8a9BOfNudlqzRF3QF8
         Zmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406928; x=1765011728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=wiROv2NK38VZ1JS9Ry2ayx8V9GaIBa7tvh3wfgf7uV9iIKrB4MoqbkTCmbIKNZcMI6
         EzwF4rwACjNz5/pgcTpl/q9iUXa2016m/gcXkXqj5qRRa3UGudWDKXhNv1HgRtyo5hxR
         77QnQPW1JptFIwGFXAN3I4WNv9an9U9Y7vdh+Tc11LMcd8ujGa5NAbXWNgVg5fbMp3mv
         KMLb54XoZ+ipzouo0FAbNVJOsWiZV5EkT3niFb6Mv9D6V36NPHPxOD245mkIlK4fKo01
         JlekC6/u9yMBdarg4lc22MMQx9P7kfgADBdGRSpr7B3nINrjcdCyiTu2f3SBUtVgyEGj
         l+6w==
X-Forwarded-Encrypted: i=1; AJvYcCWT35Zh+sPnAhzCPjPfgAZnXQiTEOCjarVG94GYT/QDSrdoIg+sWcBfBhgw4MJh8jOaxTM5P33bSz0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBCyn8NkJffp/c/77G3KOTJPX6bxaB5RQFZ4bNyRLq5Zvezekh
	VWOqJ0UGzdWxqZd7Al/76Ha3GfXpows3N9v6aGRPyk8iUX5mr7cvyLwV
X-Gm-Gg: ASbGnctVSRZ+aGjmkGMFOKNTzHSLb1xhnwVTW8ryMkmbx8+8bx65tMu02D5fZU3Vhdf
	tfWC5wADyU/Mx9MJe4mxfJXQIOKImvHNZep9rJOxdH72e210X6+iIFz5/c4+cdOGzJud1fwxp7l
	zpJWl1JuUmcM7P2qXc0kq97CSkY1+Di19TADJhzhP3UiBqoCYYQaVcCIy6g924SlNY83KVTnnnn
	HPYtkmkxpYYGtML1gQHxVelm/cb6vWghFm/9TLFrr/pG7+kRfHPg1oa9jak0vIE+IX3Ie434kXB
	VfC8fPESAkUIoWrWcQeYM+fDcQOj3DfOr+0xIzMTJoUVFYtNIi+5su8BN4ZGOK4oCogVIJwHUdk
	fMexQM+fsKI0+y4atT/e+rMShLFZxuk50RNqqlCa9Mmc8G/VRRelxKR212LXrChEYkn1RYNs0zv
	iEGnbdjUok/sCys9zYpE/EEXPmZw==
X-Google-Smtp-Source: AGHT+IFpam2VF00mu2rmyIi1m2lRR+Kb7w2Y0p3kOg5DIMgR5i6hM310V7yybDkza8FyIBCJgjbVWA==
X-Received: by 2002:a05:7022:4186:b0:119:e55a:9bf8 with SMTP id a92af1059eb24-11cb3ef2761mr13917973c88.20.1764406927773;
        Sat, 29 Nov 2025 01:02:07 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:07 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 7/9] fs/ntfs3: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:20 +0800
Message-Id: <20251129090122.2457896-8-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
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
 fs/ntfs3/fsntfs.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index c7a2f191254..35685ee4ed2 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1514,11 +1514,7 @@ int ntfs_bio_pages(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 		len = ((u64)clen << cluster_bits) - off;
 new_bio:
 		new = bio_alloc(bdev, nr_pages - page_idx, op, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		while (len) {
@@ -1611,11 +1607,7 @@ int ntfs_bio_fill_1(struct ntfs_sb_info *sbi, const struct runs_tree *run)
 		len = (u64)clen << cluster_bits;
 new_bio:
 		new = bio_alloc(bdev, BIO_MAX_VECS, REQ_OP_WRITE, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		for (;;) {
-- 
2.34.1

