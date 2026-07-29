Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC104DA539
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353415; cv=none; b=f1ZJ+Myvo5Eun+QU/ZM5+PdTGa1qq17n6YjF/AQ41afiGlH7ETcUSY5/LU026cpJ8P/KlX7gPVBD9n+GEos+Xd+79L6TAyr0Zsc/RlJTmXmdR/L7aOIaGsy1ruQp1QBk40Gy4AJ6x+vMDc6jF/2ruaB/gbbFTz7MI6971hXfNKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353415; c=relaxed/simple;
	bh=U/rckYROPBe6b5K0Y/8tt470oUNqTpGawesJbxo/iRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgN9OjRBLngYZonhozfRtei6Dfn2+9oDC7Fv9NgpwqbSZKoiwBs4rwQuK5P5jljnW6l/K/KZ6vzG31peKPATi0wOA4h141fLLrnEPZlbL5sCRQ/miinTjvIq51tyNKhDOBWYch9vTBo4nbUIbn2wA7MtqElq7WQweeDPxsED1Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TqCtwt97; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TqCtwt97"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-848593533cbso931305b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353399; x=1785958199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BvkbA25OGT8gs7alZHVVlBMx4s9jhvYzzcPoZrf679g=;
        b=TqCtwt97HFDak/L7IUpHUs52nEX/Qa7tx7/T8UQks1G692H5lgUhL9u/NAyamrxc08
         xw+oX7kN0d2z8OL2LF/BJO8zaQwy3d6ihjfHIltvMuFekVc7et556dureb5RiPvkNrUg
         avbFHTUHj9KBy5exJD3BERvxBZWOKOgu8/LrXKH1q9mybhYh01EFi/FXpornTeT6csfH
         imsBXKte31+qSpEOR/Nxb/8BzDk75UX3YAOoJsqu5ayT/+Mayv6mPVtvcv/CNF44IDAc
         4gAXcK8ebIF7tizbN32qu4XIYRTY8kc6rF7dqt2H4VV3Hjg8mxlndgdVuhS5zZQmzMIY
         NTUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353399; x=1785958199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BvkbA25OGT8gs7alZHVVlBMx4s9jhvYzzcPoZrf679g=;
        b=iH3GOg5PzhmxKti4S9dXjjSEHA5Sz55BXLeFpMS5dpu4Hbmw8N44nO8r7F4Tf80zRO
         AHj8DG1VM/g4g6BW4GbV0ePzBYaXhD9ADPL40F1/S06QmIAq3G3aLKb0OuwbNyaBzm1p
         PYODTZ5kILGQFcYF8aYNqvBMwihgDL7J27umvZOvOgY5uFXZ2E3XcqAIpC2TOT3q+pRo
         mXwnB06JIyY08qD3WfTVG4MMiisv0gMUoL++2JOCa1hIfFYJZpiDwfgk+Uc6M/qx5D5m
         eSjOwPH79uic6GUZBu3mA8S5ET1o/e8Sq3WHfcGY+f3OLBe40WI32Tq3BHQcSu8UVKEM
         nHgQ==
X-Forwarded-Encrypted: i=1; AHgh+RrnUrxKb06JHbeHZmWl9f3fH59IMjqrpRsLY5t+zcD2Hqy9VcN/iE9siwd5aU0x2esHiL2B0BrFQvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLnpu4rmrer9kQfAM3h+8+9Z1UQKVqbgp7ZTZuYRxu1ZqYRtnA
	XGgiVU7Oqa64RRJ3aKL+DCVWyDyTMFnpTtXtKyJyZspuEpF6Li3U9/hs
X-Gm-Gg: AR+sD12qbUA+06YniefugtDfxB7zHg1XHblC4hYI6QV5bW8dbV11KcbKvi+sXKVGjmY
	NDS+X03Johl+hxe2qztl410dLoeEDCBoaselShrfIDCXOWs2tfbnUiJwG5c7WkH91RWc2RV1kpD
	VNtu0qQrqO/w2AkrRhDDgWt7wKDH/f5fKlbBaXRPudLIeohbiB4SZD9Uj3Ulp212FHS2JYwygtC
	9foDa4tNvYQMzluSV5d+R7w0xBul9CC0SSo6XAY6PpbWXCFlOKGMbQYk0k7Gyf+aN5Yw1Q22kCE
	QDWgAcG+X6VDMEZzyyzy+PXDC73p1XyRiEmm9gXEWDiCe6SvINr2ocprQaXMU7pI3V+TxkA8O5N
	nMCjxiFRfZV6jscF62eeGkieetb/vN66D13LHy/PjH1DG22V0pYIIPDPDPHmwwDPCtv/9apIiqj
	JIa9gefUm/cS4bHPMwUPWKMozwu+rBRwrGn7Affb61GPstGHNc0hj+Jr70aj1/eUUf1epPcnxsp
	Nu0Xt4jDltPTOi9X8cIWeTnfRwXhIw1JSvUTLzQfXkXKWD31Do=
X-Received: by 2002:a05:6a00:139d:b0:848:31fb:43d9 with SMTP id d2e1a72fcca58-84eba1d3555mr65509b3a.45.1785353398841;
        Wed, 29 Jul 2026 12:29:58 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea02f8461sm1842019b3a.28.2026.07.29.12.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:29:58 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 05/22] iomap: add ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:20 -0700
Message-ID: <20260729192737.3190206-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Have one ->iomap_next() callback instead of ->iomap_begin() and
->iomap_end(). ->iomap_next() finishes the previous mapping if needed,
and produces the next mapping.

Collapsing to a single callback lets a performance-critical caller
inline its iteration loop and pass its ->iomap_next() function as a
compile-time constant, so the compiler can devirtualize that callback
into a direct call instead of an indirect call through a function
pointer.

iomap_iter() uses ->iomap_next() when the filesystem provides that
callback and otherwise falls back to the ->iomap_begin()/->iomap_end()
path, so filesystems can be converted one at a time.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 8 ++++++--
 include/linux/iomap.h | 9 +++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index bf7d4cccc1a7..c445a38b6285 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -118,8 +118,12 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
 
-	ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
-			ops->iomap_begin, ops->iomap_end);
+	if (ops->iomap_next)
+		ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
+	else
+		ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
+				ops->iomap_begin, ops->iomap_end);
+
 	iter->status = 0;
 	if (ret > 0)
 		iomap_iter_done(iter);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 80832edc7ec2..d203d9fe0f89 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -231,9 +231,18 @@ typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
 typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
 		ssize_t written, unsigned flags, struct iomap *iomap);
 
+/*
+ * Produce the next mapping (finishing the previous one if needed).
+ * Return 1 to continue iterating, 0 if the range is fully consumed, or a
+ * negative error on failure.
+ */
+typedef int (*iomap_iter_next_fn)(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap);
+
 struct iomap_ops {
 	iomap_iter_begin_fn iomap_begin;
 	iomap_iter_end_fn iomap_end;
+	iomap_iter_next_fn iomap_next;
 };
 
 /**
-- 
2.52.0

