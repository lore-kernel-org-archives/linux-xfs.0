Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBA73ACF17
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187475; cv=none; b=sJDJOxxYGpbN5D5a1F+/HKuY2sQ0JONjPY6uzYvDqhfFVF2LhwtrSYCsKtUM6CJYFVwrvZA63HU4fNcQLhjESNQS/Nm5ugAYja2GOsr4h+W+iI7CMe5nhZeMOzzbpuE4Vu58Eiyb+d4hKZVRzRCzgrOjU7kd1HLhx609YARlOzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187475; c=relaxed/simple;
	bh=37DoZPkb+1W8fWCJOdx7vJRB1ZWmqFh53cazfdVPywk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alui4XXuAwdqzYFaR2aIQsMwf42MRi34pPXaNY2CwUDjExtxhCY+OnXuP+wF1LWP+eXTMDCxPpvWyGD0u3eGiK+J/p4iBJudl2hqUGk12xJdzxh2/YAVwGNZprGCYUGlKbmiOyK1TZ2qNVuzsf0dFm4mpby7h0AOBUg4kJThHns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RLbnzESt; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RLbnzESt"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2caced6038eso5180595ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187473; x=1785792273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jCBfh4hnA0KRKUHFPOeo4GUfSXPKVLhLb/fiVOqAkG4=;
        b=RLbnzEStyKuTQwbc+Ij4DLzt3KsUz2jQXvlD/29p/YGH6+phB+0ktoA2C3qxBqfed6
         jAL61DhCx2+hVUsWyw0ofZpMtBFLIWx7DIo1B1kZh65HdAD5U9nObeK3aAUeLBzhJPJZ
         bKUT8otzU1yfp/HfJYh6xaajy6JOIPLSc7ET9WtFCCD1ilxITDWSqRnoFMxPyVTy8GsU
         1jz5D/NO94z8Dm8OpFrlTFImVvM9ch9EoZDoCo40ol2DPz0MaI5IAqjBMxepVt/IABqO
         NWAt2U2lmIYYOLjj64GNqC63h+KYNrDIe+9fNy1RBsOyRhiAs0QLfhsM5w7TG6ubRSzv
         if9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187473; x=1785792273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jCBfh4hnA0KRKUHFPOeo4GUfSXPKVLhLb/fiVOqAkG4=;
        b=alUbr7wfomIT0KhtDLBSl8Io1MVIT0TESkMUBN9XLsBiGcMjsKQ0PSY426woZYbaJ9
         aPiaK2ypr7+5XJKzODoAkczXAa91IUIVT6vhz82YCwYPwqaDQcChxfCDs89g5t/cN/+/
         QEZEAFZ4+3AMQBLrBodTgy959Pe+EXFz21envByVji7sgo6i3bAavuN0tBH1TWD6YriT
         Z0FyficvxUm8cnHz3YRl+PQItSJ5aaRCidZzhV3gsl9fvGMZXz4Lwi4xx5q9rZ0PgtGJ
         Umu/l78SQ9vgzHjJY4hD8bbAbR5+KrOe+3ICEdYsROOI1PT5HxoUhTZ9jF6u8ePcHviv
         sbpA==
X-Forwarded-Encrypted: i=1; AHgh+Rodph2d2OogLt0/T+Aj1BHnRFGaIFDHj6YbpXcMMPhStdfWHMAJaCF4+dEDKI7/m2lOqjFp09x/Sao=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfPeoh9d9DP2tHQ/ROQKhML9c9GOUItwIXazJAuWUH7DQEs5yx
	/Gylj0sLi9pny3lAricC0t1b63LHfKc0F7s4GXS/SiTgT5OJ7OCnBqCZSv9LtQ==
X-Gm-Gg: AR+sD11w/2PNKR+aI3xDbj8iWrqGbvyt6mkqskGI/+Mog3vKwLck6AUtZdwSJdeqRRI
	hSBGIaHzK4qcFMgXtK7WRBtjHnacX+F/VjPnu9ZuurKe7/wD7z/t5xLg2Z9YauT3LX1tqbVMHm2
	BGCUlfA8ePhzj/+E+x9pLxNi4Er2YQtlV34i9na9zAfvEApt+1w2dyimWaDcmsTZ0vO6L0yPGjn
	gzW6U4We2q5+tNyYDJHAErDvXHPLL/mRF814K9t0E1bRz2g09SWI6qL2VvyrtZZ7VGeD9zgFxBG
	s7exsfOz8bFcq16o7oVMFbCc309mSdb47Y2eeP/getcEhaICu1vspYC7FLTlZEK7KC45euXhVcA
	VErPBQZshA5bSRvuJDSg3FIWo6LYocdbXhRAR3+GV+G9qDvleIHdPCELyAOr++fEHA3nfz1clf6
	ApY9uTF2XoSbs2GZAA0gbrwK4JjoPZy9fQHzHN3NzY5kUYqwsMDCtYGw==
X-Received: by 2002:a17:903:1745:b0:2cb:402:70cc with SMTP id d9443c01a7336-2d0122483c1mr3309335ad.28.1785187472633;
        Mon, 27 Jul 2026 14:24:32 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde5e333bsm40730925ad.30.2026.07.27.14.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:32 -0700 (PDT)
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
Subject: [PATCH v4 03/21] iomap: use GFP_NOWAIT when application for iomap_dio_simple allocations
Date: Mon, 27 Jul 2026 14:17:40 -0700
Message-ID: <20260727211758.1116539-4-joannelkoong@gmail.com>
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

From: Christoph Hellwig <hch@lst.de>

For non-blocking iocbs we should avoid blocking allocation where
possible, so switch to a GFP_NOWAIT allocation here.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 36c976cf0848..5c28124b9f02 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -986,6 +986,7 @@ static void iomap_dio_simple_end_io(struct bio *bio)
 ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
 		struct iomap_iter *iomi)
 {
+	gfp_t gfp = (iomi->flags & IOMAP_NOWAIT) ? GFP_NOWAIT : GFP_KERNEL;
 	struct iomap_dio_simple *sr;
 	unsigned int alignment;
 	struct bio *bio;
@@ -1015,7 +1016,11 @@ ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
 
 	bio = bio_alloc_bioset(iomi->iomap.bdev,
 			       bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
-			       REQ_OP_READ, GFP_KERNEL, &iomap_dio_simple_pool);
+			       REQ_OP_READ, gfp, &iomap_dio_simple_pool);
+	if (!bio) {
+		ret = -EAGAIN;
+		goto out_dio_end;
+	}
 	sr = container_of(bio, struct iomap_dio_simple, bio);
 	sr->iocb = iocb;
 	sr->dio_flags = 0;
-- 
2.52.0

