Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B305637E5D7
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187485; cv=none; b=GM/iEpITdpswvALxwFIzfIERbEX2hsItG9YNz/5wAGutRgwHJeOe0qsLKGn6W7hodJXoy2iMy8ZCFRySMU1mlxSIgJZxiHY8oyRK6fJ3C9d3x7cbX6A3GBb9WSOvCn2W7ykST6rHi2UDRYcn56hlWopGCI4eT+xzkVMLaKW6Ez8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187485; c=relaxed/simple;
	bh=opq3fTnsrXEXUis6orE/E1kvybn4ouWYX+/mNx4cXic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ey2h134ur+lsnynEVX6Jhcprnkk3YSz8WK3sATMcYPcX1OLUUml41m6W9H+3oOU0H+24nuVSKuZfX0mmg0cbZu9zqUyUuRuQUPULaKj9ICL/qBmxN/Q7ojH6DAtvvZVfwPyFxDY5X0A6zxfIjoHxkDboowqC+vdFzyz9cUy3HZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LRPBA9YB; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LRPBA9YB"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so47205975ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187483; x=1785792283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hBriYrscy2lsMSBh5lhjAC8bZyEaS+6CxeuOVAvAWO8=;
        b=LRPBA9YBbftSDfU7JQOkIbjNgi+qzmebnTsJiSQt7PuJsQvmQ/chuCLVVbP2Gpyia5
         79bHhOGluM/kD/MUL+l9I2S9EejNja5RJ2EdO2SmY4TS61yvjLLtmjtGrw7KrG0AnYeQ
         QhnQx9CUG5N0yx5rzIJdpyxSBgj2IlwPI0W+MygvYHRedNHX48MpHLbjCjbjzfeQrCwg
         CTLMP/Aco3bmLnoKZSzDYx/Us2hDmAMjSC1WX5F+wSys5nkVB/sH2s2bNUi9UMp4VlGG
         U8DtXEFA8yJ/0Ir98KCl/YXeCmDUEHZ3f1wQpAIh/NSmI8OZtORm2/xz2fEGj7KM/4R1
         K3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187483; x=1785792283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hBriYrscy2lsMSBh5lhjAC8bZyEaS+6CxeuOVAvAWO8=;
        b=eKeRycRmSh58rwvXaZbLkuy295K1KLDgwuNa/T6JmlHdHKRDvAG+3DWWFrBftGaoxp
         iQ4FxenGhKgJA3eDD0blXf+cEfGTBzasZyNpnIqokxH9GvCrV14vCKlvuy8q/yEn8PdC
         h0YHxH/GMSDsk8RWo4Kq8n/VsIShOi/UPrD/cJC3ovscomVTPpZHNa3/e5ZFDTaS5xpK
         HhmMnYFjDN5GP+1Igl3yCsUMVbICRBH6gOIF6drxUr2uTDFmgEJlLTRGD+ZX5MknmJfp
         PVW9ytl3yHn4N4JoHCBQU0RPEuB9NHppaM33kxQG4nuMSkDnTpKat3WaWnU64famEf/G
         9c9Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqc+AX0V7M4CDfTY06WMIgDyu47VzdntjCPfDzjRz1R9M5sMyTXII2KRiMMrQ+hsC/3aKqDGkyafTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdZEn1opaPq66fjQTruhJxKSYpGv3hWOlig9b04T6eaDzYuNaW
	nzok4sysomndto+ONluP3Sf45tTTSjKnQWMLMuojb5O/GHm8KAt5avH5
X-Gm-Gg: AR+sD10fErv8AIDzaQjB5IfwCpVYN77FmFgVqZSwhM+6QOZsdHn87MHiNboZDixrz5v
	20FRM5hktQjSO4NjOK8EM94mKTf7Jqs8Vxmt7uNtnhRazI0toawtly7ClsK1aUYNrFXnw63otS6
	TUf8LpqTycoRY6VyZxPAUQtfcmThdA9x821SKQTk6xSLg2Md3rttxEzALRRITSrvCWQwqXVZocO
	vPVqKRuUEoxm73Ntwg6tLLdrwUi6Es9trnfKRzFKgoVMT3kaSOvxgvsdjNSijyjg7zU88RO1dHo
	sng2MKEQDibm0Ch0tMU8UlpA+2lWimGOg/Ac3Fum1QF+M0MaeXLkc25npawLqeRJsaHtVh3uf3M
	eV/zuwJj4kpDqurQoMxL5kno089KhZYY26JSvdfD1ARmDjNnIm22feWSk0thyKxgSH3Oi2WkYqL
	x2VM4urpZ410XxBmhidFPPTnRY+6FrtxMLJvbcXCz6+ZJOBn3+zIqMTg==
X-Received: by 2002:a17:903:1aa7:b0:2ca:ca48:c380 with SMTP id d9443c01a7336-2cfde8a5229mr95192185ad.47.1785187483211;
        Mon, 27 Jul 2026 14:24:43 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde4650a5sm41237635ad.0.2026.07.27.14.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:42 -0700 (PDT)
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
Subject: [PATCH v4 08/21] ntfs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:45 -0700
Message-ID: <20260727211758.1116539-9-joannelkoong@gmail.com>
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

Convert ntfs iomap_ops to the new ->iomap_next() callback. Each callback is
generated with the DEFINE_IOMAP_ITER_NEXT()/DEFINE_IOMAP_ITER_NEXT_END()
macros, which wrap the iomap_iter_next() helper to finish the previous
mapping if needed and produce the next one. No functional changes are
intended.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ntfs/iomap.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index 52eecf5cb256..d0964ac840d9 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -277,8 +277,10 @@ static int ntfs_read_iomap_begin(struct inode *inode, loff_t offset, loff_t leng
 			srcmap, true);
 }
 
+static DEFINE_IOMAP_ITER_NEXT(ntfs_read_iomap_next, ntfs_read_iomap_begin);
+
 const struct iomap_ops ntfs_read_iomap_ops = {
-	.iomap_begin = ntfs_read_iomap_begin,
+	.iomap_next = ntfs_read_iomap_next,
 };
 
 /*
@@ -329,13 +331,17 @@ static int ntfs_zero_read_iomap_end(struct inode *inode, loff_t pos, loff_t leng
 	return written;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_zero_read_iomap_next,
+		ntfs_seek_iomap_begin, ntfs_zero_read_iomap_end);
+
 static const struct iomap_ops ntfs_zero_read_iomap_ops = {
-	.iomap_begin = ntfs_seek_iomap_begin,
-	.iomap_end = ntfs_zero_read_iomap_end,
+	.iomap_next = ntfs_zero_read_iomap_next,
 };
 
+static DEFINE_IOMAP_ITER_NEXT(ntfs_seek_iomap_next, ntfs_seek_iomap_begin);
+
 const struct iomap_ops ntfs_seek_iomap_ops = {
-	.iomap_begin = ntfs_seek_iomap_begin,
+	.iomap_next = ntfs_seek_iomap_next,
 };
 
 int ntfs_dio_zero_range(struct inode *inode, loff_t offset, loff_t length)
@@ -764,9 +770,11 @@ static int ntfs_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_write_iomap_next,
+		ntfs_write_iomap_begin, ntfs_write_iomap_end);
+
 const struct iomap_ops ntfs_write_iomap_ops = {
-	.iomap_begin		= ntfs_write_iomap_begin,
-	.iomap_end		= ntfs_write_iomap_end,
+	.iomap_next		= ntfs_write_iomap_next,
 };
 
 static int ntfs_page_mkwrite_iomap_begin(struct inode *inode, loff_t offset,
@@ -777,9 +785,11 @@ static int ntfs_page_mkwrite_iomap_begin(struct inode *inode, loff_t offset,
 			NTFS_IOMAP_FLAGS_MKWRITE);
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_page_mkwrite_iomap_next,
+		ntfs_page_mkwrite_iomap_begin, ntfs_write_iomap_end);
+
 const struct iomap_ops ntfs_page_mkwrite_iomap_ops = {
-	.iomap_begin		= ntfs_page_mkwrite_iomap_begin,
-	.iomap_end		= ntfs_write_iomap_end,
+	.iomap_next		= ntfs_page_mkwrite_iomap_next,
 };
 
 static int ntfs_dio_iomap_begin(struct inode *inode, loff_t offset,
@@ -790,9 +800,11 @@ static int ntfs_dio_iomap_begin(struct inode *inode, loff_t offset,
 			NTFS_IOMAP_FLAGS_DIO);
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_dio_iomap_next,
+		ntfs_dio_iomap_begin, ntfs_write_iomap_end);
+
 const struct iomap_ops ntfs_dio_iomap_ops = {
-	.iomap_begin		= ntfs_dio_iomap_begin,
-	.iomap_end		= ntfs_write_iomap_end,
+	.iomap_next		= ntfs_dio_iomap_next,
 };
 
 static ssize_t ntfs_writeback_range(struct iomap_writepage_ctx *wpc,
-- 
2.52.0

