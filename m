Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01C02EA173
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318770; cv=none; b=rmihkU3/WB64NtdRRZ1t0fmmJc/zTdPAONwzE8mNZet7qA6XCZ80RSglOA4KVMjcBssrat+2/pKOtTVYtTbiHOnZAukTn1dPOOO+COpjPP5r/tnr0ayAdpIfern1K3qHMaa+eHnKvEmNYjOw1EQD5lA9W26w+YCTq9J6tySHL60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318770; c=relaxed/simple;
	bh=vDTdwwqFiUx+YnWL6sZwmz4ttt9jO7ABRme3mV3jkpo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qk/ch2UdJ5bVRo1MSydmmC2nxf3hBwkHeio5cS2iLrWuQmf9h4HlBbp4VU87Ac3ORF3HfXpNyfcpsTLPbPto5LOVF//BzF+Bck+BpAS5jakzcjF8vYRsRGyQA6jBwCI10wyGrImypLi4roArj0cPHEWAyYHECYxJu0Iq1WSIgeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kzg9a42n; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kzg9a42n"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-299d40b0845so26546055ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318768; x=1764923568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYdGxu8+S3la90e5ilLAk2WHMl9XT2MOPAJKSPmhLP4=;
        b=Kzg9a42nKrcwuYJQY+ScZnAHIrHBJFMdQX0bDvUZSFigzvsmYxoJlJxMQzE+0EDozZ
         c5GzOKzqIpHvZWVmkyMaI/UIkTqtD+w74trvULVNNRtHYvDxzy3aOGgUm4MAWg4QsJJO
         TLf3Pg/lRzat9g/FDJqx2Ndkc4AkEhXnlOnJBv4rLYrNNn3z0Tw8gZC3x8R1sM1pAjW+
         8S29cMxQFrsZBTYkeUzoUU5aRZGaujLAkU1uoT0Ppdt/TOUDuyqO+q5fX5PBQaDfU2Tp
         vlq+R8uu4j+Aogm8F2dpG41wTSSXL6T7K0JuCRjvfZ2XhZEyIlMuzC3q6NRK02smo13l
         EcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318768; x=1764923568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dYdGxu8+S3la90e5ilLAk2WHMl9XT2MOPAJKSPmhLP4=;
        b=rIKolsgN0AHgrWsLtRrV01B/We5EElEla7oan9W6JS5jL7lN40KDvlJ7LP2rFRo3sm
         oOe27GU++Be/NIqJ2YhmJWwjH0IaSuJMD5pbkzHrQohqHjMqXehV6tu/VJroNAA8gVEr
         2uOgLxznat7VuO0P9X9fg5iW55zl+fLUHFHzesEVXeV3UZvkxZvZMbq2zf1pUtBuW/Jn
         cfwrvCpm3h4W2mR4JRGnpgVyrd9g0rezzhru9dCMQxDT2Z5Pwo8LRJmsKCSwchvDeDlW
         Jo3QnUqWpo1DdC26qKsP4aFSUiX2H2/j0xKJu+jQDlxTKVBWivaZoc1z668YVJNFmdD6
         +Mdg==
X-Forwarded-Encrypted: i=1; AJvYcCU1gA01uhmXGLipYPj5SeAklvjLvNUZW+EVNJdTdN0QBiqW4r7tfqdDtkRsHc+bO3cNfWNhDcpK4Pk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz23AFPcmCNWIABISAZTAKX0QUAgZlJRHI/rngnpHWKqvYF/jLd
	G/Hkw+iPpj9K8KiULAbYYcIdi493GpqTGgizd8f+QbXmBSgixQl5Z//K
X-Gm-Gg: ASbGnct9pPtoKnPt0O3RAIwXVIP2HtjqYU8mqBp6aT5SLs8MQRnwGy6w7jyzB0YmM3C
	lYiyjf+nkvBRB3JS0NCyZy1xj5hZ54rH+PYN5qsxuT+IcEbjb8Oil0oTIz9MVqczxfun4Z6Gj7k
	f2LLOY4Z1nTIs5LwaRd8nDH6hei0Ko+C4NUHaggZyks7f6Of/iYXjIEhEyDzdLsmlRM5UTfLT46
	gJ96ds8t5ZAkfYI9gzWYiKv3b8YoiU5DgiJgmP/P7LpTbkIWdLXgjlum4RFw0dA/+ZF8twpuAg5
	4eWhwRnrfkzPglD/uJAxLgtzu5JqarfYjZcRIzcBB682789j7vq0356IL9OmmqkO9n5OyUXg5JP
	x2L1lcNdgaDfwCxP0FVqgaRNKc/JRhm/Nbcp0Ng8dPy40EqRy3E+gtV0jXmDUqZ4uhJTzuP3eab
	VHG1fHUSXOyl9H9GJ7F3Ylzv/81Q==
X-Google-Smtp-Source: AGHT+IExXZt7YE3nF+952Md7MiVvxMbDW7G+yswwYtoDXLwvootnd7yuttY35MGv7RVbIjqP5duRMQ==
X-Received: by 2002:a05:7022:670e:b0:11b:a73b:233b with SMTP id a92af1059eb24-11cb68354b6mr8088695c88.28.1764318767897;
        Fri, 28 Nov 2025 00:32:47 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:47 -0800 (PST)
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
	starzhangzsd@gmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
Date: Fri, 28 Nov 2025 16:32:09 +0800
Message-Id: <20251128083219.2332407-3-zhangshida@kylinos.cn>
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

Andreas point out that multiple completions can race setting
bi_status.

The check (parent->bi_status) and the subsequent write are not an
atomic operation. The value of parent->bi_status could have changed
between the time you read it for the if check and the time you write
to it. So we use cmpxchg to fix the race, as suggested by Christoph.

Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 55c2c1a0020..aa43435c15f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -313,9 +313,12 @@ EXPORT_SYMBOL(bio_reset);
 static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent = bio->bi_private;
+	blk_status_t *status = &parent->bi_status;
+	blk_status_t new_status = bio->bi_status;
+
+	if (new_status != BLK_STS_OK)
+		cmpxchg(status, BLK_STS_OK, new_status);
 
-	if (bio->bi_status && !parent->bi_status)
-		parent->bi_status = bio->bi_status;
 	bio_put(bio);
 	return parent;
 }
-- 
2.34.1

