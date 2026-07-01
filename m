Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688C23D281
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864727; cv=none; b=pNFYpHCQfCy2gNWX1wGuIYUbM9xb8fRadx7T8MccBwTpMUmasm2iWDMsHAPpAPVpXJ60FcxEH2t2tcUkDwpqd2kMhSS2KhNtm/yz1OkZCn2Rw9pFa6GEAvwjH8mBNckVCKiX543MhqesOjfsiYpws4oaUimJL8iyydRz1NUcr14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864727; c=relaxed/simple;
	bh=rZMwAp8AP75tyrP6Z70wspwAjYZTN/vjlM8jMf9jJdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n++MhWSDyk+VElwo7VVB7VN3l4tjFvhgCNykcskJLQmdCEqiSRDgeK7wL5ldZK47y+lwK6OitP9SW502bYVuk9jMBx2MKL2ujQjcVWfTQwu2eUdIrCi1UAy3gQD+RSzwLYmwSTajE1tUaUp29g88Bn2BdZ2lwXTI+hBUUe8Y2TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eZ9f/Q84; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eZ9f/Q84"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e9f69ee6f4so110067a34.2
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864724; x=1783469524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1PYWDER/X9yFiAy2VkcCTuFWmeMhUIUR7JtPj5OqF0=;
        b=eZ9f/Q84EvxqqynV7SFXezS0DXLrV4H3fd0tsCS/Jw4h29gx9lcA0CCZfEiegssnHT
         ZEUbyIazOCNGNPHL+QA4CYY20riGi2M2jrjHop2ySafiI/tuS2hOTZ740p+sZEKZNPKN
         jZRtH2Z7OQ5oOcfVm8OTy3I1HzVSL7utaye8KUbdDOSycY6HuHkPCRDprmGofwqgXu+E
         eqQIbVhzlnskQpxYp+12FL8oOsJsFfZ6aeF4arsKSdkokWpKlRjYCanl6phyQQL9pBVw
         7IYnHlJhfr6ofE3Q0HlCpc/f5wQDfdBFX45dXOhhMpqO22pCTrFroJxea8cj86cYIAZj
         dNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864724; x=1783469524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v1PYWDER/X9yFiAy2VkcCTuFWmeMhUIUR7JtPj5OqF0=;
        b=n0kKkwCTckAaj1LTFwWSt6v6wU25Wrn5WUS8rMvUU+rCnsAYlTqjunrSK4UDjdamSw
         CsIPXeaLLllIn4b/9kztD30Uij26up9QS8e0NKUjFgNRJIPE+N6aFadAtt/jklPTkeuD
         elZQ/03TXIiRSm3htLjSXy3NihpkaQ9AUtpcDjebgYgP6FG6sZ8xcAY2fXd6kBiUrmuR
         3ezGAkWkvJsHnIAoTb9rmNNk6n9Eoy6bczKhucLEjWAgHVc/hqpKOTl1PeYsMcR+sq6o
         W0Dh3PLfu7Enywz+IlcYcGf7R/sRKqSb1a7gFQc53twJKrOGK4lSDhFAUYvxiicPx/mx
         6gjQ==
X-Forwarded-Encrypted: i=1; AFNElJ/n5J1960z9x05nVSzp+6NWri3D3/o9HexrlC8Hmv/MUqZTIrJBax9vWRCGgGJOvZ5QEFixDbQQdHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMdchrHJyceu5h6aSk2mCeprxuxPv2yeTyu0HjYddTBbUY4UNe
	QeXMMSMrUG9zehBKGt0AD2sPzq06Hlw8DtmVSN0b9/0uzYD1e2BK5QYL
X-Gm-Gg: AfdE7cklvZusigW6Ga4bRp+ij6Jmx7CaD0LaVqf19PjOpwRq35f0G2Uh/iQnZNaSCaR
	YOKVoptZJ5o21PfTnz0BpqB9xMzEyEZvKK9WGMUCBqbmFRPQGZIDvrnKbNBzPNkVl/ggi8Wbf/c
	3YQL8GtMeFDVjkTQplh6X37Doh32ILwbGrptnshMTPAVc0/8+Kn/jWAv8+/2nkgZCI4ELKbtN39
	fpiPWcEmYdA0TLICJrDDNvhb9yjBWhYBxYq2bAj1YWQBD7xxIqcULKXxYp3zxb4/T6W6xszgFVD
	Ufr+QfCZAgqeGhUoLQLAYmnzEJjhDdwOzZPp2YMF+TOF4HM/VD6oeC0NRzw2pFI+vHdi7mgwD9x
	lxsZr5pK+h6LJD8uWklD1uH4F1eRfAbFO848Lbd72iQueFzLUwWOA2esXLHsIoz3Ez2S00HB5d/
	qI7yU9elS3GfiFKOKG2yoATcEpBtSh2kByOnLPfP8HRMAT0cYdq4ixAqjammlQEL9G29kIDoXC0
	OM=
X-Received: by 2002:a05:6830:439e:b0:7e6:f2dd:93c3 with SMTP id 46e09a7af769-7e9ec706306mr4755934a34.15.1782864724460;
        Tue, 30 Jun 2026 17:12:04 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4d::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9ebf891b8sm3635363a34.6.2026.06.30.17.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:12:03 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 13/18] hpfs: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:28 -0700
Message-ID: <20260701000949.1666714-14-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert hpfs iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/hpfs/file.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 29e876705369..1df9f28fb40b 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -156,8 +156,14 @@ static int hpfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static int hpfs_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			   struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, hpfs_iomap_begin, NULL);
+}
+
 static const struct iomap_ops hpfs_iomap_ops = {
-	.iomap_begin		= hpfs_iomap_begin,
+	.iomap_next		= hpfs_iomap_next,
 };
 
 static int hpfs_read_folio(struct file *file, struct folio *folio)
-- 
2.52.0

