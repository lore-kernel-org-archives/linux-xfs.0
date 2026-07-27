Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B5342D777
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187481; cv=none; b=EpVgGgAg07lUTJCp6jijAyis5o08pSZdu2etowq/vhGD1PEKPFMufH7MnCCYlbuwbrTUc91mUjglOscdmSQaCzGcF0VZtCK9NXRPIFnxh92udLVxtVvzJdQBeSz3C6Dyj8xjR3t1JaTNjg1mDH8dc07+LO9zvTFpyadmjF9s/+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187481; c=relaxed/simple;
	bh=rkaAcHNFcamz6DhIX2flj3zcR68Gq2Gna+EtwTYWD4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkdAI0m6mZpjM8hMPVH7waY6x3X5+/FJQ4mtbnvAJ/HSQYtFTgtQZsL2SWM0CylG+dV1W3gAzQ+bGC6+Rx4A58p6l8BLQpzA2QvQjDT5CSBMASotfFe7/OBZome4y7a8acc4O1yfXM3OhtDn3wl8nQa2pT3Qqup9nL6Ivpaa3Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nP0nm3fy; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nP0nm3fy"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84861fc51f5so2475631b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187478; x=1785792278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cm0YRaFY8SVNZm2g6Tmv3v7XKJUMSaBD7LFCYeNZJYA=;
        b=nP0nm3fydBYv2fSmmQxLenXjH0455jEsRx6/mUopy0CmwBwL6C44BdHTwLt4IDxKzs
         eNB/BWfNVWXXXYNtkwxH6dl86y4qDHjOReB+FX6kGQ6f/KV6cp0j6hGcEodlflJyd2w0
         +zEK/T4KrGUs+wa+1CyjDhbDEfbPtVuGpc/g/VTCF+Hwt3ms2Lp/s29LgjvgPM/WrYcx
         gR3MJwf5eNRc5NVo2AWia4yv/zFUUZfrUJVebH1bG5gFBsEJjj15hQ99udi/HHPLElgJ
         5aSkTLVvBIztScrCOd4O8uuxD9kSWNG0bVLazlU0spm57bn/2OKE9xjwio6k8UKd/j0x
         5YKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187478; x=1785792278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cm0YRaFY8SVNZm2g6Tmv3v7XKJUMSaBD7LFCYeNZJYA=;
        b=lHh9Mk/d8/z2ry413GiDTt72tx07mztUGaN+VkIQAS1eOlZiXfXXnWPzwTpBoiR2lg
         SlSPrLDvUhR3knMrTlSgI7nM2PCexBQ3sWih9cNnVIA0kVgBMzkQeqH8Aas6L+Ov/xZI
         dY6JrunA+On5NFf/ZtloYq7R5XTVe4jXJmWGqaFm1EOkA4cPglsk3j619WZfCXCEYR7y
         UQbp8omewxBMd7QXPwX+HBewQiRuDDg+oaz47pnEmP3+fD3uGY6qetoWscgE81d3a8/x
         CO8CrpnC3+BxY3SIlPkjchRH5s7q4flvl/6xEVjx+x4IanZ7Pq0xJL/Q7c1Rk4jRosBu
         eBRw==
X-Forwarded-Encrypted: i=1; AHgh+RoZ+1rL2h2O5tWdh5ORBuTZ9I9gp/iz0orf5LTITqxWIUFkzT0keJflyXDuBnlu+2E0iAXnyTP/g74=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuEqtOm3AwERILH9DENTA5efYV7aAb5YjbmwBJTH4lmeVRrmqZ
	UjR1oLwBQxiOUnp2nuCabAwNguoeEOa706yPIOy3ILsnuTcvnxbD1dw2
X-Gm-Gg: AR+sD10bAFMOmHSZked2YbONg6r2EBMIl1WuQiA3P4IdE8nSZTuGn32cPRg5peWCiJq
	xbEenHXRhe/vYcbz0nsnZBUERXjU0t0vOU2/R2DfdbYuvQ0jFy7t4U2358XXTEH8pm4g/IPUzll
	0jmz5g5vthXXcygzXq2cfL8djcWbJCSZtbZh9Z+ejfSYzP+PLB0/MnTqo4N1KDKkFzaOPh5eNEu
	2enyBNNl0EMehSfpUjalCzzu0jG/3hl0hG9zQtQiShe702LHFn7A6ScS9pLSjXIxz2dD59oiknP
	SZ5yA75dGoxnjSk3Fl9tlDUwtxJL1DeV5Zzmdv/YOjspnGKp1I/rFiTPFpO8+d35p4DUxnmugAR
	Etn15/xvAnjnRdsTeYMgFc35kSTGZoG2ypyDkg+TLfHBIvLULJ8dNGDTfFr9D7z5/glQis4x4U8
	KtiX4WyJxIkxiMvToNjJIbo/T8Ki5ACrtOoNwT7kGKHr8hHOSMpV8JYg==
X-Received: by 2002:a05:6a00:a803:b0:848:700d:c950 with SMTP id d2e1a72fcca58-84e8d371ee4mr936201b3a.37.1785187478608;
        Mon, 27 Jul 2026 14:24:38 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53425649sm3455454b3a.45.2026.07.27.14.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:38 -0700 (PDT)
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
Subject: [PATCH v4 06/21] btrfs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:43 -0700
Message-ID: <20260727211758.1116539-7-joannelkoong@gmail.com>
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

Convert btrfs iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT_END() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/btrfs/direct-io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 460326d34143..d5439b06cdc9 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -798,9 +798,11 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	btrfs_submit_bbio(bbio, 0);
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(btrfs_dio_iomap_next, btrfs_dio_iomap_begin,
+				  btrfs_dio_iomap_end);
+
 static const struct iomap_ops btrfs_dio_iomap_ops = {
-	.iomap_begin            = btrfs_dio_iomap_begin,
-	.iomap_end              = btrfs_dio_iomap_end,
+	.iomap_next             = btrfs_dio_iomap_next,
 };
 
 static const struct iomap_dio_ops btrfs_dio_ops = {
-- 
2.52.0

