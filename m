Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C67F3B7B93
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 19:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353415; cv=none; b=ojZy5LaBwHHiS6w3SH21le62Op2ZY/0/TLVeHkOXAPuRjWxhS5+x9XZFbxIywaNx5611CuRzV7KI1WyNyzlibWqIVH8sUkXOzPf74fpJo0cnaUUCUaGVMqzL/Vfkz1qt6Jcm/TBk2KxlPlyErudMeWz/fmC67m6X5fdSpmsaR2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353415; c=relaxed/simple;
	bh=rkaAcHNFcamz6DhIX2flj3zcR68Gq2Gna+EtwTYWD4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw5+WLm5A1SwQbiHMJYnjl7uIZCsKhlJHdNd6ZPPoW26aa6jzI4CFqkUsyhNdpteqeHKJS8bVhzCxVItiiRgNlojoZOeckok/ClKrWoBNL9uJmDJeHUZdlusHB6FOsGGUmob8LfzMr/X7/YJbmnvT+89JbsS15s8u/ZDQi13pWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bpNiEzau; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bpNiEzau"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e041ea211so1494761a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353403; x=1785958203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cm0YRaFY8SVNZm2g6Tmv3v7XKJUMSaBD7LFCYeNZJYA=;
        b=bpNiEzaueZw9jT+RJwzbN/5RD9L+57N817zQfdi7Jl8xNfn9tlnQG2Q7Je7izyy2Kp
         XKhRqPsnRfOfFSBF7BXunKe4VuUZfgrzt2t8wsd7a+nNYcpfmp3qsZWpDhT+Y/bJQxpv
         NiObsTGPFEEeSnOVwG4BhsJJGrq0k2JV4hgjjG4l5NrsI4agh6llUWzJzK4LyeEWep66
         0fJS9rrhhEWZhCmSIwOHpoI3SOHkUegyFR6KvHtfPrg6kADtz9RMmRbq/SXt4GH1HGOS
         D9D0edUhKKjdnE4Jd54N5xX/37WZcSmtmj+svhEdt4vXbCNGXrX7eahMEbBxOuddQXA0
         cUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353403; x=1785958203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cm0YRaFY8SVNZm2g6Tmv3v7XKJUMSaBD7LFCYeNZJYA=;
        b=kYzV5iKDYF/6mnw3bn6UZtI1BRAW56jJ0CieYnegDFP1f7VHqGkpzj1+fmtunvn9Ib
         noZlHvyZLBDfI2GSQPIyH05H1jXAE2T7HEGyYeDshRPbk8/tbhDet5ZYC+GcrelzHvIk
         XbE5uAQQh51y4YlRyl6hXMlAPLHEzwZhWbeV54sVAfyHwQoVTa5jRhYq2dR3f+OlQkf4
         r8tGye+sL+SzTlDxjWrZ8XB4jHxc7imyyxmJA19gRdRBHkOP6V6JTOnyRW5roB9xv2Dt
         nH4BuM/W70my1G4MvvHfzlkG6NV0pFy2FkhIZimlG7kHlhBNL8UQghsBJzzPmFmwqIY/
         7nsQ==
X-Forwarded-Encrypted: i=1; AHgh+RqVyG7WoVpnlJI/5LFVxoa7+O7BceO4r/HvonZ3Vh6/xLt2ONKtq8aFHc/B4R5PcV7MaMxTals8I9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVplNWLUM29zfKvr2Ysy4Ib1I8C2CzyPLRCVGPsFoXO8NOBJ8r
	yItOMlBq/agxEbCsaKDtrp7SK3wV90KJKCCY6OXtlv6tGyUsMewsBZxT
X-Gm-Gg: AR+sD11y8wCWbNOvuC9GzrR7n6vy+y2iOmvEpcTjlCFSFRMrTHJSA567dO/z57vqqgF
	dl8xE1/9m/HjAfdoLwcqTxfbHFNVS/unQaWVw7D1KxLV+AdaEgAn+AyS6zD1JVBBYUJQkaQX9V9
	SKlVIWJm1QbMKaufwRU+KAd6TN7X4DsF0a1Rc1IxTcMWvqQSBh8zOvhaVJLjVjSnpf5UWqGwzi0
	av/4W2ITfvYVPAmsjNF2W2s/iaR6AHX9SDIGeWM/4zcjZpCmCYd9cFmKd9cYBK6AaNvJozHxqJJ
	o8digpx+S0wkwmbGOzVCmLl0PZdQqWK+oMRBcPzYQI8jbgCPOMpNZaoWiLLZwBfxShPuCj7Fo5F
	NnnGsVvMe5ZU7tgfbEhFpskhLUXMdFq1XbUX+NgCFiwLfCeq6IAfBK5hct5R4OQnvM4AxqehHr8
	cAjv9ibdhoHNKIz4t9FFcanZZ65bR4dIl5tRx+tEhuIeYuJMPbaz1a2I5phFxAWKh/pfnwTiZOZ
	mkR62JN69MNJ2oltzr74cdlX0mEeXd6zDa/GCtl
X-Received: by 2002:a17:90b:1b0d:b0:380:873:49cb with SMTP id 98e67ed59e1d1-38f9913c940mr172669a91.21.1785353403298;
        Wed, 29 Jul 2026 12:30:03 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7f2b9e1esm1792343a91.15.2026.07.29.12.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:02 -0700 (PDT)
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
Subject: [PATCH v5 07/22] btrfs: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:22 -0700
Message-ID: <20260729192737.3190206-8-joannelkoong@gmail.com>
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

