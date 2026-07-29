Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1813E51E4
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353435; cv=none; b=TxinzHWNmVuu4XEQWTbFevkTbo9xMxtgvyGhDDJs7ITwJgmxfS9eYhyb9PcB6WwprbQDEvosbdVO8HPuyYIzJUgTQZsoQsa9bX0lZsTddoU9mLZvvinvxxY8eAixna3GuYuxmD6Krns4mIn/N7vk2UywIEA4gt3Xv/U7rO9sbKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353435; c=relaxed/simple;
	bh=Fjw5DSYb9KRQ1xyLxsho1mmISLRJMKjPVMoKEf1qwyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIVUtZsKCQsbX2vcVK54UMVDa4wfuOmOi1I5vdqUlE4Amr/jtNzqKimiqvKoBnlXip7ORLgGlc+PxRsgo3ItUzoEs3H318B8ix+C36xAzSYC5GXNg18mD5sPYeRk+EYUzWQHu5wUxCLo3G0D+IGdVcGMCbRLMZWnik4bameG7o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m33pBlXn; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m33pBlXn"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cbb973e6749so1557517a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353424; x=1785958224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+DsR/dFj2nYHw6/Q7iYssphd45mi2AeTA7D0yo+w0Uw=;
        b=m33pBlXn9JVAQMOzYqZK8DmyRBf2oVJBsTPoEiCzK1MHeRc0nZ5WoZ10PMero8OCJA
         VdkIXqB2ctNyTtde8T+NBieF9aFQfast2Z5PZhwMz69l4eyBSpbC4pnfDnVjFopj/su3
         euAFDKJ2Df0EGcnJ9DR8Xx/N3G11g2DKghxe7K/zBG3/E8Hym5Fi8g+L5YUQ489OHLlN
         bf/VFVZ8kEpz96qLuhd03cJSpuFHbpzeHjsDzcpBLt/MqQSRa/BmuFV2zDcuoxZ7wG89
         7nOWeaTvDQU81HHLjWJLEvBQesbYkzbVTyyxSGRcexKyU8fnTUaRgzkBS+Xxa6nFIDKW
         BUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353424; x=1785958224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+DsR/dFj2nYHw6/Q7iYssphd45mi2AeTA7D0yo+w0Uw=;
        b=hviyQKW9go2j755himQTCCq2tbBRBhJB1KfXo74lbosSXHjuLSjEkQIaVCa7GCmQC3
         PVcqwPtpxuH8aYqercjmSj8sSdSg2C+VuB9mwdXmSyRsE0UNI8T3B8i5WBR+9C+8wkSt
         oU7AZ0O6oNnYFox8mm1/msR9g+eGPZ73n6E48UE27Cw1lCIinCFzYkJACZkzacep5+38
         HSU1loxcsZXzIoYy6wfK+0R8hcBXx3RRTJKsN4+n3Pif2Qkbf1SOc9JuposMdSO2iwdX
         EJ+OnQar96Peo+04OTRIX88yJqXs9d94f/VHA/klNNas4WkcgC9iurZPWvjUAUw5Pxki
         Hapg==
X-Forwarded-Encrypted: i=1; AHgh+RqmURJ/NAxGKc86mBxCezASlpiIdL0mn1ybdVr3PiIBTyJfVdYf//YWC3QAjqcvArCrfZvPXzxvn5s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQvi3O91qI2/Vn0M6nNq18fdKlIVQqDwn7ZLkiJB4uRRQIMubH
	fs/P2Nv3Wl5uByqTget0XaLtEqcaS+S1Ow8I1IEhgShHbxKyRl0vmjVg
X-Gm-Gg: AR+sD11vNiRvlskn3/4vTGVoj/sA9xUgLf3Eu77dYrIYGIAAI26zvJrHfzFVnDJbUyd
	5XZOw1muK7UHixuJz3Yp6Wi/YRIhVTApDWm9NRqonJ5Ll1w7RUHzRlZ/qqYhE+SBVPlYMqe18OU
	Y33UXRfCJr2AD9frAknv8CxBDbIX8yvD66mcJoNEcNHIzaxtc+JxGCFR1KHRivfsBP4A1DaLGZl
	te5YP2O9GY/avaiF0x9JK4d/m/9Z/qiLpncUQ9BKGy1wm9VuLEjE7HugYiJk4nprNv4WbWihsPz
	ytC2SK5CXnA4o1dxJXcnjKXrBco/QkoNxTCIFuZwiTT7xhWy0EfUqI1VoRdBVrGwqywFvJmIq9O
	MUJ2fZbAY1IiX6jsc4DIr3KDrLTPFNFmprSOqg/f+qnh5ODDys2Wq2W0yUyPC7GsF5UGYNsccDB
	iJHY0qrRgTTT+VZCpT1aKBus+CCWKjKyyeoUbztcWDwJOtk60traaUqxYJh9QX/V9O+BB9ybd9t
	Por2UAE2vaPZ9w7jhBwwJSD6+2m8J+qNijhddAr
X-Received: by 2002:a05:6a20:4313:b0:3c4:396d:4a6c with SMTP id adf61e73a8af0-3c8aafc0362mr10655921637.5.1785353423821;
        Wed, 29 Jul 2026 12:30:23 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba92bb37sm1264179a12.30.2026.07.29.12.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:22 -0700 (PDT)
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
Subject: [PATCH v5 14/22] block: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:29 -0700
Message-ID: <20260729192737.3190206-15-joannelkoong@gmail.com>
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

