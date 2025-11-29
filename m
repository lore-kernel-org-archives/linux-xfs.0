Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8FF27F754
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 09:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406917; cv=none; b=MlwgwkQFOO7YB/0wTTI3YJuXTTNdfBUGgZS4Kh/4xC17TFo1sntBaZXlHRHwG0wpf42i299r+FDjSZvTC2QnLOkzAOy62p2Zp4f9yjksFHBFw5nZs1Xg4nhYhWwKfoKLvD+Tj3wo+IMm5UWQJ1M9j8UoeC6sgfKvHcxADk5iLgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406917; c=relaxed/simple;
	bh=pDPxpgP4y7Y34S846UZ5pdageZyT3VDirSvStDnHRd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EByR372wGzATq8fzQusUMjhQ9htpPmr+gX0ZjlwEvFo3EhHO2IhhFZxJS+osLSIFHwiHMdJWsLHCVTurVUxAXmQQV7jUhrQWfLzKhsf4VyqfLaUc4Gs7qK7Bg/luoblkfHrraVCP6gBlq15Ik4kZGMl8gbVXZAKGUEcn/HQB1HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCQquR5g; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCQquR5g"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-343ea89896eso2585492a91.2
        for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406914; x=1765011714; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8NoibJSiNHVArlLUK5xHvDn/GmQ96N4NjNkgGx3wcU=;
        b=eCQquR5g2nzkSn2xhtf/misuhs+3/XAS8F89freoYMhp/QU2qz/W7KUKu01a/B+W+B
         qnt8HseNzz86ai9qT4vvsoI0a1AkF/PujnGoqDBMjIvv13WLo2vV8hSgARMExFaic8Qy
         6cHt1lezisfN6o/qaY5VGjok8CJkHHLi//N9zsORIFU07TrNviikiX0OMaeV/YlWSjUX
         yf1L068Hrtnde45bQb7zfgSePLkZQAkyF7A5MSsfY9+5Y2wv31mq+nUxc76XXG5W2Q6c
         2W7XzjtCSM7AMVBb/tne8Qf5Im1KuKZJk88r4q7+B4iR9HxlRHwoiJxREo8T/vtTDn6B
         Do/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406914; x=1765011714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t8NoibJSiNHVArlLUK5xHvDn/GmQ96N4NjNkgGx3wcU=;
        b=Lzrzb8000gcmH+cf/jyvFFsI6IcwrKJSpz+rbZoDI2u+Fw/8he4jyzjIMIJA17jmeI
         oSR1U9sIrUmfWJWOMh4Wi+g4irSRgQmeSOmcTNMaaXaI465yAwuRuH7hYoAjS86xYv9y
         QJ9FPs7DAHOuYOa2O1Gm7Se+FcHr/eWG8QD4MA8CoFOPrv+Id7NFt5Sf/VziScJVoN84
         HLEeZOlMsj+LxXPnaXF/i8h7Oqob5spdztVBgkW9W/QvRDgXdFqctXNhHiz+yFfRkl7r
         KPZQ06ZWE9hlKHfU6QBBGCaMi3ntvnNsg7lYwX52iJU6jlULXNel7eKijlNASflKizAJ
         c1oA==
X-Forwarded-Encrypted: i=1; AJvYcCXluB9kV0nwFzo1pINLV6rvYdoH2ahhwyB+dgVn1DGESsSnVtz9tfttThIhrlxyxfYBhIr4jogtIik=@vger.kernel.org
X-Gm-Message-State: AOJu0YxA5Q64MMwOIEkF1zITDt0n8NZDTuOWXKuMWGUWidfEPU0/4MgJ
	AdPoHzQtz1oFIrCwpEnBMm6rYuUO/W/PVydb3RAs7LOTzsZIv1QClFmC
X-Gm-Gg: ASbGncshqfQoALRSS3BHUASDg9c7gCtkuJZp+qRJxii0gIRyncM62akicUJdDu06Rxn
	OEVxB5jX0zaCAOGcGUMPTmrK0FtENaGQC4rS+IKjGtZfYqjpnvAxU79hsF61EqtP6HZvzHCi2XD
	3XeRr3UYvLtq6hYA3e3xXVvPCSBw+dlNO6RA0Z3bcx08sQVrbXRYU0A1e4OqI0sHzlupTiSscWI
	bLv9FQfw0UWu3bp/N8cQIPsio2xI7dtbuWp8Aht4NJsLKrDpn7xZ+sPa/J54MBp5gW7Fc4G0y2s
	HcApQ5R8Rocraw/JYrwsLjDZjNv1iIfFEvGYP5HBAK2Wt93g7byr0RKK65z6WxFTiVjyVVyPBCn
	xL4kVWDUD/m8K+A3dqR4Qp2hk5dlyOlKRNqEtcAuw4xo+pQCLRTyE/WwuWAduXMl/pqU5m/55MT
	+IR4MMe0VKyA8eQ53BLuR7XTQdtbbd7FcD3pl0
X-Google-Smtp-Source: AGHT+IG2wahiB2PBWVfrDNRf7p52lLBDrzQQGimm/4V6gX8Dcmjw91342gxhdzWR3iErnl9Stx9Lzw==
X-Received: by 2002:a05:7022:3c84:b0:119:e569:f277 with SMTP id a92af1059eb24-11c9d864eddmr16724097c88.32.1764406914041;
        Sat, 29 Nov 2025 01:01:54 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:53 -0800 (PST)
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
Subject: [PATCH v3 4/9] block: export bio_chain_and_submit
Date: Sat, 29 Nov 2025 17:01:17 +0800
Message-Id: <20251129090122.2457896-5-zhangshida@kylinos.cn>
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

Export the bio_chain_and_submit function to make it available as a
common utility. This will allow replacing repetitive bio chaining
patterns found in multiple locations throughout the codebase.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index 097c1cd2054..7aa4a1d3672 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -368,6 +368,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new)
 	}
 	return new;
 }
+EXPORT_SYMBOL_GPL(bio_chain_and_submit);
 
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
-- 
2.34.1

