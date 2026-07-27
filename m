Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67C642DA53
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187496; cv=none; b=s39EBraOcNwFtVlchq+5kahxrCM6xPvmgf+m4m7qnRYB5Dj9bgZ/lvB4Vo5ADUOQUlTygwlYzterwjjfj6fJJnPDtS3FCc4q7CU7TB3Ipu/BN+z9TFQC6gxaNaLCZboIyQ0WNdwTZE7Uf7RnCPjuHt7dPJJcUM5qi2ceV9+zs0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187496; c=relaxed/simple;
	bh=Fjw5DSYb9KRQ1xyLxsho1mmISLRJMKjPVMoKEf1qwyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqcjdArEbnE+cANl6OABk0+4ye+EZmVzjTk1ElPXVRw5bcKpgW9yzT5ZH/7Arj4c+hQtuhRfTl7kgv4KSS8LpGKgm+BlRckKndSQSepmWYoMTtCrsXfPkJlbzcK0BPcL07diZB5M4HZ1gzX8QZsinzZpZiZCA3iFlpU857CH5Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SrSQv5FM; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrSQv5FM"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2caea3f742bso38699285ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187494; x=1785792294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+DsR/dFj2nYHw6/Q7iYssphd45mi2AeTA7D0yo+w0Uw=;
        b=SrSQv5FMtcSnQU5eIisu4nW0bQ21xKiagmub0wyWeR2PtOyKAW7ExaOs7h6W6fL9r5
         xMm1/Iyekw3ysjIuoRF/+GmUz1e/Nz2FDCLHB/F73+EeVHGOq8GgIHSq1UpzQr1qMdzO
         ic4htFe+ieH4W8fZYp7Ymz07+ubZXYtod8+rJUspbCjnZU5VwQRQoZRhBs25iPYBR3DF
         jQLNQTE/QuP0a/EiddGnNcHYpLWwQUaDNRc/Ktwljbc8hvjbGKVo/+aoEXSrtX9dUr9N
         K3hU1EfdSsbFc7L22cCSnpJDrWFZHyuGUjofSZYyXCrpG6jcATUlMHM9fdz4rp+rNI9W
         2eng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187494; x=1785792294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+DsR/dFj2nYHw6/Q7iYssphd45mi2AeTA7D0yo+w0Uw=;
        b=nFbbagsHDjSMtuWRgy42gl3KuOVxPzigQDSJeHYCMYV+3uNILOjRqcL24cuxV4NbgJ
         cwMEit4mvKvMqG3xB8S0PppvnKPzK8MUtnT1v8nIDSbfIIRyukNOQk1yhdwYaxKuMi9J
         mXw6UwQC+IILiVWyEY46Vj5FGpPmTb5nStjOPuOQRLBwXj/GbZAbwqENDL+vHleEFhIF
         MRJMyUfcbH1P/OCAx/8tR2eoqAaFJ/SbvQjjhe+RorONabnz5Rl2zSZuCzu9CUlNeE8o
         v2nDQa5F6w6teMqMJgERCcsEGnWb2VbZXdBg6mvPry7puFYr3KosWuMxkS6ihrjiENzc
         5rIQ==
X-Forwarded-Encrypted: i=1; AHgh+RqpQUT1fJARkqFgrYcLkazj6zLaVR4CHP3XcdLdmdqkRUN7aGjL2jFjd4IMls2ocV5kLo8lWfdDPQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YydZG7nvb7OTyTYyoPe6BDKq8TdXK4Wt9uFA6UfN1p6CNyZFHvV
	xNn5znOIQyL6Tu9UFyqORUirxTiG2b27tuadhSF1FwWV3PAIvA46u6Zn
X-Gm-Gg: AR+sD13sm2KUfgJt5GjyUZpurdO4IUIkfClutWAdGtAun2udCv342ZswLCCxMsNfKp3
	XL8llXhQtcbDyhTXpPFsZB52QD67k5PoxTlob55EaDM65Bx/SdDtr1Smd4dYWeTYLwETUkarjj5
	nDAFlZx7hn347JgWnaExsTKkGEueZRcEpuMEXTyJadKJjukH5tJXRe4scDlpd7jhFWjY95Yn6kT
	j7CFRTxMlbXdgdPKYWg5Wp/W/mzxGC1PNm+avCzR2Cu82sMNliGzPkWAOHAi7N2YDHe6TAZ7IKT
	fHQ9VEI6tbtqXq4mPNy9RjXCkd25sVprqaPiJh7mCNpRs8gtdAF3O5LJPdYsShdDjikd+qWdzg+
	a9oae4+mSBdKYhwaKDYs61nPtU3cJrRtXDulvRs8MeTVP7exQIoLbFaJOCBdFKJCVhbItBf5Ihg
	JJgDLvq5+bIU5QywO1gPwKfSMLDrkCrk8S5h/afHdqA5ivmRaxGhWW
X-Received: by 2002:a17:902:d98c:b0:2ca:73aa:b48f with SMTP id d9443c01a7336-2d00f3e13f3mr9522575ad.35.1785187494348;
        Mon, 27 Jul 2026 14:24:54 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:5::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59bc49sm40516525ad.7.2026.07.27.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:53 -0700 (PDT)
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
Subject: [PATCH v4 13/21] block: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:50 -0700
Message-ID: <20260727211758.1116539-14-joannelkoong@gmail.com>
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

Convert block iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 block/fops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 15783a6180de..4cff76e9eb71 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -453,8 +453,10 @@ static int blkdev_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(blkdev_iomap_next, blkdev_iomap_begin);
+
 static const struct iomap_ops blkdev_iomap_ops = {
-	.iomap_begin		= blkdev_iomap_begin,
+	.iomap_next		= blkdev_iomap_next,
 };
 
 #ifdef CONFIG_BUFFER_HEAD
-- 
2.52.0

