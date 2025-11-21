Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D1133B6CA
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 08:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713097; cv=none; b=fqwAqUVIFTlRcNk4rxD2P18LN3JIGEvJLN4TExyMYowWLdyeadbOmX7OsyjVsoGdcDFKTAxmw266zAHnQ084yCasEc/2rau4mbjPgWzc3LhQ0lfoeH+vISltELsvTTsB7B9VWNo4CmHXPGpOIEeuNfExnNqcnlMtueRTsXPwN5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713097; c=relaxed/simple;
	bh=/P1RYgORKxwE9EU9V7IqZbnP/9QJ+9L8NguSmQu/jJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iUZIt7zUrrkyVfU7/olIjUmYNJmjDO/VOZZv0GPLtYclIxldOI9hbBoityjclzWrj3vacKZ5w/dDATVHP5n40HSsfBXdkaBoODxQNqThW4mdB1irf3H1J62i1QJiegCnsQbJuI00F01OYRSz4deIoiyMOVuS58OMGSFFZ3VOxKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KqV4ck86; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqV4ck86"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bd610f4425fso1046233a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 00:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713092; x=1764317892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2hQwsn6Sms438Pv0Q4ngdJSSkLE/b11prNvkoKJDYo=;
        b=KqV4ck86WNbsGDhmD/6yKH8Mgo1i6hIeId6gE5DfNCurQ/kEtVGj7gpSDHX5XWOS4q
         IR1NVC+k5Q7nkQR/Qul5FVkk/g1RXpu0dErfGJSoG8g7/Xqg4vyNDLSPputAFgOyZm5S
         sTAQufiTe7cGuqbwwVedvrxs5K5qG1IEYEKZuwaKen+ymwe/uyPE49nLjDbRohTL3Mp6
         Gc8eiMDnBq89zT9KLDl4EurhTdqNEofwin0joyfY/6Y8tpwH1d52QXmM8ka8YAoKv0mj
         50Fw11J5dBWu+4tHZvJiPgmeFHR0TzKHY4V/U+74kJY12vrz+0eHzWZaz9N0kR51gjnp
         KIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713092; x=1764317892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/2hQwsn6Sms438Pv0Q4ngdJSSkLE/b11prNvkoKJDYo=;
        b=bo4aivc/gAgSikRRv/xjXEpAF+Tx6590/91REG3gXx+1YTX0KkrOCNfNtMpqiPbcKg
         idKE1W5tOmaSfYBDqSJcYiRPCjxpmA1H0hv2K41kWrc5TnnRdgNLQqkQ5fgLNhJuyO1Y
         SE8V21LpC1gjIRNt4mOGMkXj/gw4Gqp9g75cD6A4m0gaDqbFBVaZRprc5XlJUNerS4Dg
         wtFRyL+VyLxY9dJjy/wAhvUUdjj3EL5FX4Qyo3M+k52XrxOvVNfZlOjk9eZzCTU7xQe+
         jbj2gbE0J3Dlt3llj+HEAknb2c9vhzBhpnqxr6q3T/cYU4ex3LViPtBmgZ39XqpNJos3
         rZ0g==
X-Forwarded-Encrypted: i=1; AJvYcCWfGsx1+FOzc3JvDnD9ym/cqPmqg6KUG0lr+ZrkhF30DRMOPHjDtmZSEjklvkFeFz/kaXZghGNZY0U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgZmmYgxKCRSQEI6VSHn0K+B73Ebv82DRjsOighw+GaUqNa04+
	zIBkXKjDovGSjNs2/LSJo3gadEU0qwZMC9P3LiSMeHBSOkNawBE6crg3lpDwDhljdi0=
X-Gm-Gg: ASbGncttz5zSlSaTx5l4c3QtC8Ep/38nUKmLg+OhXEDG26pfl8bsyaLY/X4JsXIPVFF
	87P216dP3kr2lLDE1n34r2zOgzjYN/J0eLd/s3SW0OmUX0+fdScKIsmvG1sFqlOIjusXaynrbJh
	YJ8mAJYu/RksdBsfhCsG537mNgmhKygHsLwV1RG8ND6l3oscqGvbV87cFCqiz10azjXTSM//sOQ
	OE0bE2jHG6Wal1vFQQ6ruH6yQRgNXG46aODKQ9gcwmUMgLxJzX+za8FPoSLEX06BqdQzOwgchcv
	/XYDkO3FCvQstqL3UGbTTtyYloi7K4S5Pfh/7yy7Z1dNUpgIr1FxoVkOydvoVP8LTz7li1ONUNw
	hfcGfly3eIdw5oilJ6kcYXyUAigjhEbsoVImaGQmbcmLrf/eFykTmfRcrqZrYjeGMOx5/9a03Ea
	B6SNjbZ0FQzQi5OqxqOHV+wG3Org==
X-Google-Smtp-Source: AGHT+IENbSLlagXc9NX/smNIF96UgKjh9NXUi+KBRvhy18+CUMO6BxslQvGRE/2mRUDvnGhRtmvCRg==
X-Received: by 2002:a05:7022:ba1:b0:11b:b3a1:713c with SMTP id a92af1059eb24-11c9d60d20cmr498283c88.9.1763713092239;
        Fri, 21 Nov 2025 00:18:12 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:11 -0800 (PST)
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
Subject: [PATCH 2/9] block: export bio_chain_and_submit
Date: Fri, 21 Nov 2025 16:17:41 +0800
Message-Id: <20251121081748.1443507-3-zhangshida@kylinos.cn>
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
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index 55c2c1a0020..a6912aa8d69 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -363,6 +363,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new)
 	}
 	return new;
 }
+EXPORT_SYMBOL_GPL(bio_chain_and_submit);
 
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
-- 
2.34.1

