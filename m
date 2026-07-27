Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B870D42CB18
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187492; cv=none; b=XxkdGBQ2uPMEXbkQEFZJxUo9qZJmc+4xp86n/Apl6EWzohOxpVjpaUrIoNNwjzK6+AF6VhPjNCDa/0YvvdudGFYk2pJPxiOUGfmu2D2SfC4bq9/LmqOcYRBIIEkDlXkreuaF/AsCNpPcwFvKTObKqhxpCa3u/Px4FJYxHRyidTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187492; c=relaxed/simple;
	bh=mjtFePw905Ih8lZM0jTOp001M3VsZYjlem3tQ4B9G6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqfcOVzPE3I4HisUPL5p85ROTKePF23JqRypTlxNFrybfAxNhNagoB+I+uVYjj5rYKsJTUs9Ipr+xddqBj6srB3ZceBnb9UA0aW2S8nWvfMFwaGOe3YpO7v1TrLSYOn0EUX1WoSB98IOYjSO+5sbuTWJEFe/aN0tlWDqfXO20wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gm4VlN14; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gm4VlN14"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cab973140bso42792745ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187490; x=1785792290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t0HucSFNwCrhhqVsgsZLRy5u6x5BGWTlUoNlDXYASAs=;
        b=gm4VlN14wsV7YR4qhAHoqFHBZUxX8+3x2mYK6mKE4zZwsqvCeuqdEHWN+C7fWS6Mzy
         jL7Tgi9TmiK3bjUS4nyVE31Jxjx0BsHZuGkmi/sFjKa9SSuyGa8p4OibJxhdhUcr6wg2
         qY1QYasTXpjazlU07jjJcOxluStQBMy/jWqorkQMSocT0i6rjN4y8tyOSV2SR2dC0SXS
         hMiRddeHPFvl12HR1kxZAwGhWDnn+klXCDUe2ctbriydlxCasnbxhPwk+cTzkK0H7RR+
         j07wPLm9afZw/J2AeTuXeA3cmMBPToaS71p0AZ5MZ21oZTexkFPi9JRM6ewpEuS5uXa2
         1e6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187490; x=1785792290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t0HucSFNwCrhhqVsgsZLRy5u6x5BGWTlUoNlDXYASAs=;
        b=muyVRKlUbvfsKTvwLiks6lCmL0X/U02knri6+6iK0O25n87fi3NjGI9L3Xz5d6Eypv
         i73xFgaZWhcxzqi0ewCbXUSYv9PpKv5EiIOEY/1vFcxmqv+3KOxtEqbkpBzlJiHxMYGj
         MfsirkKqQ+9IMqOlDDiFSqrsYQEk93vPHZsTu1yOLd6zblcFU66klQm/sVtDUJlf/n21
         DzJjMciGRZ0B2OPTtRZZSOG2llBL8BzpgsPX4k0OVxXBx7SDlz9WxltEZ2Ect1i7CrCh
         kins/IMLZlugwLlSpkPLF3vZ5j+WDQEpEtnk2r4FtP6UQ9tZUmik+dxWY666xJBC2eI/
         fDbA==
X-Forwarded-Encrypted: i=1; AHgh+Rp+m0uzbRnhG8OWtUctsEAXhaGerIJ4/JabIy6kS0VVUdohV5vpV5c5UQer6SscHXaEcyGWAf82t9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKWFjtXjtRaKE+VW4PPspCcjjDTZg0X9NF3KUZMYctD3mdRj2b
	Qxb+3x3VwklWHUcI0JDL7mAAZ5ttz8WoZKzpp4enLHQ5SQcmmF2fwWbb
X-Gm-Gg: AR+sD10YyMw9ZHsukGPfZdIAKyeZXm8lxYkZWp1P1Xq4DGMOGyCA4cVyXzRxZaLNtYG
	/g0kz0k5gfsRc8H7gHR4dwkcaQVKsBNKM7xjihImjq/6hoTSbva/VSthG82bIJzNnfbvL/6lADb
	XSaL6LI63sS5LEa6Z3JjKjTEahloljcseTLtfPPLim+mntiiaIgD1Q9TOZ0ZsgTLO+sfxa9Eub8
	cDEozbzOFMuiUzf9CdxTHEhDIPFS1cGWRAXYDjbefk3dZXj9JkbE9Fqlww33w9eqEfmbBs/XoDr
	lHJ0VzlW7w/TSu5cLn3axqqtKlyJ5Xg2yeK1+KQtp4YGv/tLZChR+Z3qiq4auPqw1bgCRduOarG
	7+OK6v4wP/xsMiuVlXjVXswCMRcEiwOt1Gah1Ke9qZNEZCXZe7Ae7RG1jMX6HDFM0717xdXRP+V
	Tc/GT4pM+saIFlZdIG4Ywlqyb/HGgz08qCHh25u/lUijM9t7p5QvDuiQ==
X-Received: by 2002:a17:902:e5c6:b0:2ca:d7a0:1312 with SMTP id d9443c01a7336-2cfde85f826mr100366845ad.25.1785187489988;
        Mon, 27 Jul 2026 14:24:49 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bbdf6sm40458485ad.52.2026.07.27.14.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:49 -0700 (PDT)
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
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 11/21] zonefs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:48 -0700
Message-ID: <20260727211758.1116539-12-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert zonefs iomap_ops to the new ->iomap_next() callback. Each
callback is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which
wraps the iomap_iter_next() helper to finish the previous mapping if
needed and produce the next one. No functional changes are intended.

Acked-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/zonefs/file.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 5ada33f70bb4..5b34849be7a2 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -57,8 +57,10 @@ static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(zonefs_read_iomap_next, zonefs_read_iomap_begin);
+
 static const struct iomap_ops zonefs_read_iomap_ops = {
-	.iomap_begin	= zonefs_read_iomap_begin,
+	.iomap_next	= zonefs_read_iomap_next,
 };
 
 static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
@@ -106,8 +108,11 @@ static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(zonefs_write_iomap_next,
+			      zonefs_write_iomap_begin);
+
 static const struct iomap_ops zonefs_write_iomap_ops = {
-	.iomap_begin	= zonefs_write_iomap_begin,
+	.iomap_next	= zonefs_write_iomap_next,
 };
 
 static int zonefs_read_folio(struct file *unused, struct folio *folio)
-- 
2.52.0

