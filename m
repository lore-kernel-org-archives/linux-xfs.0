Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2619D33BBA5
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 08:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713098; cv=none; b=hstbUDfBJ8CmaRnOOxwqVSeF1IG1HV5nlMoBdxGY7k0rPVtUXirI0EpGD686h6xIkBy72FggrGbuB/L2E7VqwHwZkeFapXL4gvkjIw4mmWTGB5B40X+Q2xn99C/rGPjnaw4I3qOCxLtAn4yPZ7WJ7vNk7Wowt0Io2xucQd1A8Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713098; c=relaxed/simple;
	bh=ERpHvRnw+l3wstR+WAIvwtnoTvXWleFvGGT+ROO3fSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OuvhjKiQOUXhni5nhtKe8QrJu/Qi48bPgDZv8AaV9Lg2VBpbm46PICNWm3CRVOF+FeK5IkyK21HACJDQNWIbO1yLqMpg2iwtq9DymfIm66x/XLUZ5J4OvS6x54Br5yGLKpxUYqOaKU3Y4pHAYOn+XaNsr2OQeWf30iu4WWMuP0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWk7DRuW; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWk7DRuW"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29845b06dd2so22048655ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 00:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713095; x=1764317895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1V/r9ZPcuPpDeS+hBrkkwoFJqMj16O3RGCN2/vaCDuA=;
        b=mWk7DRuWqfJmo5GZxya3mRbNRQlRIZ07jM8fCQ1fxXLsUubL336YGi5xWzoXb78D3I
         11SVKyjJtCvje11D9kwVdXDFGyjZg4iz/xEmFIDBrKQiqBBBINoxfVlkmesijLZ/+oQ6
         13RFzP3b5D6NgaKDA3UxqNHOS1oOjpFkivlXz9H81K3ifPZYoKaLyP0ET8/FSHs2DwyA
         Ym4+rcWjvXTevpJmVRSSCyrrPEptEFS5tL/LKZGpCUDV+WSwxSSicOljfZuCFPLNJqxD
         Snq+ZR1bgCMkuzmuNTiuznqmzzIK8Hak527bMyYGW42z2ZIaVlrgUz7u0De3yW9YK8NG
         Gd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713095; x=1764317895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1V/r9ZPcuPpDeS+hBrkkwoFJqMj16O3RGCN2/vaCDuA=;
        b=g0yOxMdMscJzrVWtKibQlsfpjuYpoR/NUIf99GMHeX3x2d16cjwREfL62ugsusdFAH
         vs+1ZeKe8u/Tie3OgeYVbHhL9LNgZXf81YweXrREDAbZzTATz93Gg2ie5MLXtvZPc3jG
         EwYEz5KHFB/Ki9JlUzdLv9V6y0Y5n05BCdu7I6BiaLaCxqUVQhvEn8d+S5BbcYvj+FOG
         LVjB6KjvLpxh6lCmVio8JxrLzbUP9FTw8+wm9CA14+3Y2T79rmOi/oL1PgQV7KJ7wCGb
         Qa4derWKBWAJvpzSERZABd7tqb7NqWypxqxvVzQP49ZwCm2Nb/XL38xAIdo6gNxFq1LF
         j/Kg==
X-Forwarded-Encrypted: i=1; AJvYcCXF8rqgiB0XDZ6FGyK1bxz6eZubzX5tYm4Y3BLrw+gDnb8h4UiC8sYowtUZN4ToRTx+NyN2ErRuJlA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ5jQ8X29ThN31TBpCqPScT6Fouu8EzZZ3pRe8o87NdsqgjCW1
	R8fBqdbGIWeSf09CHyPv4XWhqcGfLUQGTeWkyXMiCvZ4GXMx1eLfuRE5
X-Gm-Gg: ASbGnct0gLoUgDX37/GJGjWDwSDVg7m7U2B9ecEAFTUrz8CJ1VRRRSBtBIdoG2aBVBQ
	g+32rg21utgabglePSfTo6yzWgaet2zYLPEwPN2nVdjp+HXIH7Z8eFzS8eDtW7XvTexV3djXp5N
	wcSvH0fUZiifFejYyWd/tVVbXixsqYjP2+qazOUHGqD7VFRsZHvH5ItgbtNF/ut+UYkUleqKTSv
	PiBWTQt+5dDQmFuV2T1/5lUiPYxcODYjd8m+UoRRiBJwBwqyljXajW9BewqgY6gNQ2izAbSk1H/
	ulh/8EPCjoOiwTQkjRq3MdgHah58XYSTUc+3ul6OX68mv0aam9oHRvGnHhpUgoMtzIMjivWzCa4
	AGpzUVB+4wKIiidIJJuR18Sbav7HXXzveQC2liALBqQR3ZOjVy4MXk4TU6BhTk1pzOuOcxHr7vf
	LQB+aXRtPt8+hRXJVs6fdKXncR/w==
X-Google-Smtp-Source: AGHT+IEHu/E6NqM3wgnO0PzNJHfm7ylIJ91XqRa53EvuqqhyyBcUb7YMg890bib+mDDMVjekZVw8IQ==
X-Received: by 2002:a05:7022:4419:b0:119:e569:f25f with SMTP id a92af1059eb24-11c9d70b0d1mr568161c88.8.1763713095153;
        Fri, 21 Nov 2025 00:18:15 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:14 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 3/9] gfs2: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:42 +0800
Message-Id: <20251121081748.1443507-4-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251121081748.1443507-1-zhangshida@kylinos.cn>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/gfs2/lops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9c8c305a75c..c8c48593449 100644
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

