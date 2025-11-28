Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798032FBE1B
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318796; cv=none; b=d9vz2/QieiDU7haUuGP5ptdcn/2hyT0gWKGzbDFV5XX6Rxpex93Hntu0eZPsRaGfFnyWWW7WEotrTo0t+lP8wesCKqc6I/2JwgsqCmDPIr/i4rny9jAqc0J7qWEkfvjhebjwfDuuRf6V0wUdfo9ZLlwIgTY8as92sDUjd/jH+pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318796; c=relaxed/simple;
	bh=rZqecGhzp3NmtFjaYLSNOTM+/xsMiNIYX8VY+Bn+fL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QXIebt30746wvv85gxT1QYcI2ewYmiHZibov7RsDkxc6xAwTamaK/9DL+1Nm3OVNuhuXm6XHPAvrmnB+TzyE1lbPvgZiGxcyBET6KrcLXv1MU3Imvps+Ouyh4wFYLmVktZjzCKXnKfJV1e+O9MJxHA9g4MNLW3XPAO8xnqfQCqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UuQjJ0Or; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UuQjJ0Or"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2956d816c10so18872915ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318794; x=1764923594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=UuQjJ0OrMliOYq/vKHkZ0EGMLjkP/3Z/KCHoy07iJ12lhSd9x9TW/pDBuxHkpO1xfS
         sr6xa4mg02G5RHHgr3svMEMCmLpDhdQcryheLSMfzjadk8ub2pnZ3K7KNe/QtFSIFSlf
         RM1IvGWxY+Lp0vcGGiIPfFSLyEwQNmNxQXRFRsC4gNVt+fdxU+nPuVS9FCoWe9kPH16d
         PcFG5Tt+J/Nj41241tasEcsxcIctOC4S3R6CIVAefgqgFxk/Lw/rEifAew2RXZhJgAgU
         y4mB0mkgCmGUqBTC+v3oFrYyPEm6qRgetjGwbn55odFqfVbATiCTrSSqI3VJWchOnkrw
         YhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318794; x=1764923594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=rARmyTrS+befk2/j+WJas2TkMBqfZ71ZD4j4FOGlTJkCAQaX2gv4VSEuMqYpM5TMw0
         7fbUmR2/bI7wC1iv0S5y1CGdxUowm7rD6qn6IHw+R/G+2LXA0I3F6GFZ3BaRPHj+WR8G
         5qW/204KoXsaaLWl8JrJVHVsL2uO8Pn5Ij7vybrGFmrVkXuw7IrZxCYXqITOAbGihh6M
         PZrLi+G5peKuf6tRiuSfOAd19rIK+XrMepCEvFsyaB9LBBYqP11NPdJ15eAgVWxYT6VJ
         URaKqdNH/0w0nb0uLum6y+0MiEwy9c1ig4gkBC7CHU0cjZX6RnhZAQAmfMAXR8e3476m
         QRog==
X-Forwarded-Encrypted: i=1; AJvYcCXx/nV4Mo/hPt+bPk/jBN60UZAtCx5qWdMnz5Hbzcoroslwoha4r7bJgR5KzW64RUDQb7wVosevOV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFLEjjH/cNX42MbyYtV2eRArbJ6qArew5xeSsGI1Mj/eTb0x2e
	O8l9fWfIWSzOMwl01h27ze/M12Fuf2aoGeWCJpF2ZpdhEZxPgZ+Hpk5W
X-Gm-Gg: ASbGncsHNKGMeanjEDbB0wwPvLy7rMcgi0JSWkVbR+FX30MnE04RXtzpBmU3qMisM1I
	aaIatyiVsxYplK1kls2aL1bZzlurADyJBKX7BcYUGUewgR+BF745Lx7SwbeX1LTfMfBd0akW1uP
	HOcRWdd66dB3jJmHEU1mPN9BGr/9/nwqy7fUZueXdyYmI5R4qJg8zYq121XztWX1ZvVlLPfsJT2
	ZlMp+KC2bH9AnlEfE3/9HBXzoX6NYW/XTCuF3gEVpdrFuYEoAzOlN3P+E/TnrrpBD5kgNGDqxMM
	jnd1bcB3WonTswBaIcerCz1q9NzMPqM2pEfrj46opDMYcgRPLOcAPqtzchiMYqvfuaqESwZU2D7
	F2pYFuqSxgi7HNjneF1v7HEbbWHAAze82kOMNU+hw0n4ne1viAxQxY1+PWFpH5TVWlCvEDnm5jn
	gAk5EzIIFPG8PAmQip1jLvwGbzBQ==
X-Google-Smtp-Source: AGHT+IGKjtGYvF0Bq9aksrL28VuK/U2PkCtZPwPR3BXXqxprAsbvk/b9CT8/yxSPTU2xDb2fwzHbRg==
X-Received: by 2002:a05:7022:41:b0:11b:b1ce:277a with SMTP id a92af1059eb24-11c9d8482b1mr15434117c88.28.1764318793604;
        Fri, 28 Nov 2025 00:33:13 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:13 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 07/12] xfs: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:14 +0800
Message-Id: <20251128083219.2332407-8-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/xfs_bio_io.c | 3 +--
 fs/xfs/xfs_buf.c    | 3 +--
 fs/xfs/xfs_log.c    | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 2a736d10eaf..4a6577b0789 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -38,8 +38,7 @@ xfs_rw_bdev(
 					bio_max_vecs(count - done),
 					prev->bi_opf, GFP_KERNEL);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
-			bio_chain(prev, bio);
-			submit_bio(prev);
+			bio_chain_and_submit(prev, bio);
 		}
 		done += added;
 	} while (done < count);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 773d959965d..c26bd28edb4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1357,8 +1357,7 @@ xfs_buf_submit_bio(
 		split = bio_split(bio, bp->b_maps[map].bm_len, GFP_NOFS,
 				&fs_bio_set);
 		split->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
-		bio_chain(split, bio);
-		submit_bio(split);
+		bio_chain_and_submit(split, bio);
 	}
 	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
 	submit_bio(bio);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 603e85c1ab4..f4c9ad1d148 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1687,8 +1687,7 @@ xlog_write_iclog(
 
 		split = bio_split(&iclog->ic_bio, log->l_logBBsize - bno,
 				  GFP_NOIO, &fs_bio_set);
-		bio_chain(split, &iclog->ic_bio);
-		submit_bio(split);
+		bio_chain_and_submit(split, &iclog->ic_bio);
 
 		/* restart at logical offset zero for the remainder */
 		iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart;
-- 
2.34.1

