Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1447C76025
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864712; cv=none; b=n+4CDbw5kyHWxGnDFRumAgA4FY0+kW1g8LblG+VgOTpq2Wzce1nI3sO9cniq9LRahPQHA1Ufizi2EvnXz/9sFL1m0ALxK5ifGK7JIA5ieOS7aXWKktdGkl+vkwSNq4ehMsQvL2KG43zaCt/nAHN9ZjRNqvDPgbh2RwVa5vBcPwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864712; c=relaxed/simple;
	bh=poQXawbGUGaPktypVMuM6tBnwR6xT/UlwmthSZUnqQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuQPX9CJOtDOskhH+gCwdh0n06IK73rAjyApNtEL8/0vkczaEIwLl8dChaw2KQKMIS0O6wmqVJr/y/TjD0AesXBNak7s5o78DlluEKVeCzpKEd6rDiJTtWjyEveC2X3RN58sR8QKeDHYUy2dKhxWEs7h5sciRx1kN3hSLDOd5OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=stmI8qs0; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="stmI8qs0"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6a1160a2c42so53687eaf.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864710; x=1783469510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLxtQ8RRcat5JdEG4+gqeCTF1rh6owEPHX3/SlXOuvo=;
        b=stmI8qs0a8S1vLOdV0zgac6LUfcTYRnBT1sYkVQdVmasBJS1tGW+zWP1oIRZpGZTpC
         AjqIg08VT1h5EoVzqOfyINTuTU/7K8lfWF6kCNTfLbMNPFKLcSModGKgyuq4mXEvMkqT
         JFWmXH/KpJ6Rs91nVQLNN7kdWdMzKJ9SZ57mXwKCdjoAdRFuu87cz/KUg09Bt9GhzA7d
         Zj4AlnuvKcSczA4Jzje1wCsjahxVn69YHQ6W+T6HG484GBTy2x+3/uc5w1QdpV5ewZBs
         yNdQDmCvn+afphO1GKZaWHVnEzhyrHm283HfNCXZAxRz51rS+oWWS1hTBA3g2gWMSeKX
         P/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864710; x=1783469510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OLxtQ8RRcat5JdEG4+gqeCTF1rh6owEPHX3/SlXOuvo=;
        b=tUdRNfMJRqUrbzsWiaHKjIFRB3DKEciAGxT7H5aTxJNV/aLCh0iWrrzT6BBehRAJed
         w+8ql6Qt8HIlPuuJWVarlTcY+E4qHk5fkkvsUD4ayOd3Z/EvXj9jzL5rUQ6hCGr3M7Gn
         VniIfz/XteBgbwKm6b4IEffqI6wrkh6vIi2iS6ZbfV5DlnVGDCHgd1xERJ/zkWzfXrXC
         0waEdOFnlHrC4TV4gbJJsRjE3KcbsITc0WOjQ/xcpjsEFtF/EGauKaUed/0cTIQk92bg
         ENXDo3TqzlXG6/Cq8hpHQ/7Bww0UjVDRaHU7yYaBXHUnQku4JNgiY+Xh64/5IWSMd7oS
         ZFDA==
X-Forwarded-Encrypted: i=1; AFNElJ94i5j8fxnczhVgHDtZZAOGwrd58Y480ctIrycqOKodH0RbyNyQSTEf5yufvZLXO/t8V+Jbfj2h7Rc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxtu5ZMVXaUi2PsCoplD6fbmctcMB+HXwdmE7ACwsrw9w9zPSpe
	R61VRPNw4AFvztc1tyS8HFqFkF6EWPex5zrym3r38Zz1mbvicq/USNXOHLayBA==
X-Gm-Gg: AfdE7clhE9m0dUATJEzvk5MW7V+BKcaS2myk3z7CDLIC3Az6rrzKjHRG/p3Ict6pOgd
	BNB3Njaa+RScRMfC69TEe7F2fDF9Llz5ahb6H0aunyZt1PvaTMiieYK0eR1aKp5kISgzSg/YLP7
	DRHfK82KwXQJVWZYiI/xMProJFj1C4aaYbXEttgsD0n91A07UZPKpyYz1XtTNlm+3xh+iE4LWzm
	nLyGzK+2tQPStK9D/vQMZhKOPjvb2CxwYKT1FvqgKBV8bbG7Et8lFIkZK99x7J2vMO4OT+h4mcx
	6p/SwDLls3VLGXL4w4Sowvo4PLxhvaQJGmYxKlOIQcWCcUgf5hFIrIxMng9g1G+MF+/7zTWZLyO
	GvKOp/igdbNmopSfkXQ0OQl53ETsKTAjDxeEWPDN4OrWL//Rb4vtGJsONlhl2ZzPkRgztgI4YzX
	Eu7ov1V5NjuzJBnf1mhMzhbO6byR+xWe0FI0Xm8GARXQCcIYILdq/m64ovK6ho1rUi
X-Received: by 2002:a05:6809:196:10b0:495:f104:d898 with SMTP id 5614622812f47-495f104e5ddmr2749952b6e.32.1782864710224;
        Tue, 30 Jun 2026 17:11:50 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-49606b1309csm242012b6e.13.2026.06.30.17.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:48 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org (open list:EXT2 FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 09/18] ext2: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:24 -0700
Message-ID: <20260701000949.1666714-10-joannelkoong@gmail.com>
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

Convert ext2 iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ext2/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 29808629cce5..0693059caa35 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -860,9 +860,15 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static int ext2_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			   struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ext2_iomap_begin,
+			     ext2_iomap_end);
+}
+
 const struct iomap_ops ext2_iomap_ops = {
-	.iomap_begin		= ext2_iomap_begin,
-	.iomap_end		= ext2_iomap_end,
+	.iomap_next		= ext2_iomap_next,
 };
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
2.52.0

