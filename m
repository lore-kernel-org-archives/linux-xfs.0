Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9549F3C76A2
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353421; cv=none; b=ALeKrY3CZl0ralQv9uY+LoHf243JTCxYUMR55uclDpK/nouxHQpXR8XEWVf+JJFOYp/EfqFLFOMcyE76U4TzCEnQxnn8A/7lzjkDeCZ3J1cJb70gPmx9JJ5rSEj0/9ray5XV2FTmsvKC8R/8A4Mb17QsfBG9SSYTm1/RfxjcLtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353421; c=relaxed/simple;
	bh=opq3fTnsrXEXUis6orE/E1kvybn4ouWYX+/mNx4cXic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twqw/P2PhxdhJlGuuMQj+NkN/OdEWuJAdObLThSAHdEZoojaGvmWxkVRf2kG2cRRUauZ9g+poG+fKaQZakHOSFTu2k7jkWwAh67ZYmPMBAWaD4bu+XKykcPXXBKjmBnZsbPf9h4pFhZHoQ+Zl2pOUkjneiUP+tpBDgQYunI/grM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zh5YtyeR; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zh5YtyeR"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cf50c6f235so15183555ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353408; x=1785958208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hBriYrscy2lsMSBh5lhjAC8bZyEaS+6CxeuOVAvAWO8=;
        b=Zh5YtyeRdFl0TL6zqUNOvTlh/FQJRuMv3bQjVS2hInJqVcJWfAIN51ByLZ6z0zIFQj
         SFzfl2xbCtrZn8nK/OIiwahbR1cMT5zkm9JCSkqARsueJ7qkERpkTn/afsLjLejK4Rj1
         hMfC+83juxq9irK9M4+RJm1j4QzcrDHumL4dAVRTGZJThaaVIZINXB3ZsxKgZ7K9ro5/
         J1soiI+zQ8LInWBMVjLasKjU/WWcYzoN5O9W1Ka4DpJVgabiZfMGKQHTFAoKklbKRSY0
         0qVQBE/rhFNNZdWF4epHsMS6kXSSvaNUOgEuy3Xa5Gt3e++edLV0Cq9Nc64BoBLtC9Ta
         DHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353408; x=1785958208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hBriYrscy2lsMSBh5lhjAC8bZyEaS+6CxeuOVAvAWO8=;
        b=cLwUQDMI/2Ni9v4ajpbGUhB4TzP+SESXUhaacGnaxmleVv1807nX96Rngf8VxB64Zx
         NE0QVZiVPiYXRAa70SeRInOgg55jICc1KLzXsJO7sZFrlwZ/NwWj9nlX+/iixwmQX/qY
         keXpH85ymYCtRTAKe9Sb/a857d/w+P5LVfzYLCMnX+uBt223ry4T+EY2YzFGxJlfHp+L
         mkT0ho4dRvDghMEYYtTW3lEw3AJ0Ov8rlhO7LDGSFA4cLXkzHPRCTSchNtXp7sp19xL7
         jX4v2zqROnsa129zcl54lnzYJG/ZLsDcDH+Ux8BcGS5sd47N6rKgb4txiYuNcgySIDhq
         NZ3Q==
X-Forwarded-Encrypted: i=1; AHgh+RpQVByopb8u4Ndx8SuxANXB8k47bpHF6QEdqDLoOIIUKGuUWaU8ZEuD5zbJba9MH7Pp7MqmL6EURPg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0E9bzK8QqKxqqYN8rnSIPtuYfXMm04Pt3dqxA7/m90y4T2H9C
	YM7TLVQL/fi6yacmxHKS/k1iXe3spUj0ZZoeU4GaZBEPdFSGRrcmLmCB
X-Gm-Gg: AR+sD11Zc3eHJC2W6g4kx6LvuZTJaEjVe8y580HpIHIHEIkUgOs+E9gFhBJT73S3CcH
	h1r4HJqKdEpBAiyBI/pI4pwi8FxXXpMc3yxlehmAlYB2qzWzk7aXAzF9iyfCzItmXgdumWHPV4K
	qAm0QeSQJHWmJoCJo5u1ZN1gwUATTD+7bRFg8Y0kBHnU301VH1opofvhq79TV6ixqSV8F4IGvnD
	eeQF4xnMZBppAnO+23/3fXKosjXV2urie+hveFRQlzKvN8arlvGwIXe69nXNrzhAIsMBExF2Kzl
	k6xGD/TsqNIvx5qBLbNGorDioLFGLu3PV+kY5sGgXj7808qZFFcfoaIu2Opu2gKzKfo+i7KM+P3
	dzwpVH6JpgesIFfvyxY/FgW2bNNviR1aPkkqB5N4P7F3mdoHoGnWqnWTnM7gjkT2WXFI/jWAclv
	iy8hIKfndFCOU450VrUhltV55174X4XbRFC1FWMTzNlX9nlLJvPf1o3d26XhVxY+FB68dxsqmoh
	+ez0t5tdP+1PBl9lKR039tiWPtiYOTMauBZn9I=
X-Received: by 2002:a17:903:32c1:b0:2c8:4c29:afeb with SMTP id d9443c01a7336-2d0339fa521mr1833455ad.8.1785353408486;
        Wed, 29 Jul 2026 12:30:08 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a15885sm16022595ad.15.2026.07.29.12.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:07 -0700 (PDT)
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
Subject: [PATCH v5 09/22] ntfs: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:24 -0700
Message-ID: <20260729192737.3190206-10-joannelkoong@gmail.com>
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

