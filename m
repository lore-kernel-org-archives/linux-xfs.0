Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1208B224AF2
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 19:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764097779; cv=none; b=Bu6MWOJttNWaizQPm1gllR/gn7h0eNjIbid2WvoFuKeomNwVD2nwQowAJMiOJDBpQtUSXFhNkPGdW9rfLc6v0qJFux9xtT08TYKjJHBh7QQ0Z70vB1JkmDxyd8/2DX7oLiV8pIEfXQ1IUfpi6FfkCt6Km9P8XvCrz/zlNK021e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764097779; c=relaxed/simple;
	bh=WhPVHCJW76FGJUYswsjQFNbMTK7L4YrF4FJlMHrzrPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GW+shfXmw50fm1ZAgVErli09nYvVBUJDW1KE111YtFLf1zd8FMjmFqYyF96TonUs5XdvlxydrLOy3YvR6yBtw0GLB5My0KT0Cl33AKl8HNfozXuZgBZXSwVLRV9y5Ok+LX3qAUIYEN00TqUgJLzzFVRMvx8R9VtAOLUjjzOdwKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NlOgYsPb; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NlOgYsPb"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29845b06dd2so72989935ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 11:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764097777; x=1764702577; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KqV4ea26VpNRnNDOYj3v3FWNR4t9iRrjXWCFY4hl9NI=;
        b=NlOgYsPbCXU9ejFGWz4GDe2nHBW8zxMR8CehaM3nG60xRZqeNQQXfZUlIRkmIFBfbZ
         mQWQbA7O+kmym/wi4PrFU4ZAQXNrFPiHsXlJhlk1uPhITqoDH67Zp22ytXmSmlj9tEPQ
         LC7BfDQV6eDnsK7dq9Lxu+YRLW9mOq9my6XatCYFQLcGdGlymd9YZzGwmUaNvMWAWTbK
         6RvmofRhZd5VLG/eYu7+akPmBR5qKQ8fqVjyxt27WJOmTtBQiL9ae51YLAA0Ax7zzv5+
         x9kobiSDBPcjegvtSyNJ7g64XdvF9FEjsRef9ExNv194OhegnXLgMN3m9EEuRX7VNDyQ
         PRWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764097777; x=1764702577;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KqV4ea26VpNRnNDOYj3v3FWNR4t9iRrjXWCFY4hl9NI=;
        b=a6ZYxr7Izb8RQ637ZzWWbGPlm75RzRnO23MRTc5XpfPbkHaHwlPCv+thTxVfeYNyKK
         dqUQC/VKivU51lsay4ebgen/1IB9Qaz7gCGNZGS3v1PDMZHVnkuIeKDVy8j3W6WqSyf8
         H7s2NVY0rXlWAUEw6KhKZkrKp1MNDPQoc8I/g2HPpsZekuTv4bqoSoN+jINYgMxKPUoi
         oZ77as7ZP4R7PcR3Q7AmXEyO+nL3zm2vz/hQbPK9pSd2coUijgsMbIoY9CmMWGplxLaq
         O/kmh5dPVrKMy3zVkxKSGY1nC7vnWNw+JRrVw5NZXLB+TLDaj1c2IW9WLf9VjVp3YJpV
         FuUg==
X-Forwarded-Encrypted: i=1; AJvYcCXOULky3n99KIzGyDxidZAIKRoNxO5gWdGhiV3xoIHDIRn9Ac7llU3kTkQw0NUG1+/xp590ch5jd/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTwC0bWCyatV0ZTxkIWgXrQQ8ogQdlrfIe2b69eiSQVBMDEGOW
	Pw38dxvbl8jXUOGlYXmJsqG1cODdRWFEfzZDw7+xFGjqeM+6UAwTB8sS
X-Gm-Gg: ASbGncvQfjyWklR3nVIDN8qILB886Zmqt7mWewU2JiMo00HLsQVURtihE0czLWvPe68
	vhQzN/OW5obKbC24mNCLQ5L84Mkm8+Sgoe5CwHkGgNdeaiapU+yOLfKA9H6ZtU1o5A1H3v5Hula
	vC2B8TCOSBZSzBDeSBRzvBSmon5BKa2IgPBOStCJ3c9xhn0qlf/DlSn3dmzlpc837uo+XP6/9If
	9co4E1+6dSb1BDmWDqLYlFK2a2qoLI/D6GScr+mktqfY1tKNaW315OlGJ3iPMTxuuB9BjxL8ail
	2COyLi5Sf/bSmGy/9+oxxEz5V6ypGQ5D0dvShG7m46kr8cIaQ8E1x+VVseF0gREYUYNyZqnQ3VB
	H406stOALWKHtx9rjnb5DdY07jC45uiF9ZhPDfuKkV+RaEcHvEBQCogrbuvW6zx9tdXuUWNEaH6
	Sd5JpHs/fVScGhAtBbJR0CcZ4Uz9INC+CKnXB+3p6RKN4ymE/d7xCdwWp1Xkily1nD
X-Google-Smtp-Source: AGHT+IHuIf8IdstsNtTBrFtuIhxYayVPP9kbYzco+dRdLBQVBBJBvJGBn5Q65xamj5HkAzoQXFriDQ==
X-Received: by 2002:a17:903:2acb:b0:294:fc77:f021 with SMTP id d9443c01a7336-29b6c6b32f7mr194870325ad.49.1764097777372;
        Tue, 25 Nov 2025 11:09:37 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:a9c6:421a:26c5:f914? ([2600:8802:b00:9ce0:a9c6:421a:26c5:f914])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b107cc2sm176518725ad.16.2025.11.25.11.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 11:09:37 -0800 (PST)
Message-ID: <851516d5-a5e8-47dd-82e0-3e34090e600d@gmail.com>
Date: Tue, 25 Nov 2025 11:09:35 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/6] block: ignore discard return value
To: Jens Axboe <axboe@kernel.dk>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai@fnnas.com, hch@lst.de,
 sagi@grimberg.me, kch@nvidia.com, jaegeuk@kernel.org, chao@kernel.org,
 cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-2-ckulkarnilinux@gmail.com>
 <e3f09e0c-63f4-4887-8e3a-1fb24963b627@kernel.dk>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <e3f09e0c-63f4-4887-8e3a-1fb24963b627@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/25 09:38, Jens Axboe wrote:
> On 11/24/25 4:48 PM, Chaitanya Kulkarni wrote:
>> __blkdev_issue_discard() always returns 0, making the error check
>> in blkdev_issue_discard() dead code.
> Shouldn't it be a void instead then?
>
Yes, we have decided to clean up the callers first [1]. Once they are
merged safely, after rc1 I'll send a patch [2] to make it void since
it touches many different subsystems.

-ck

[1]
https://marc.info/?l=linux-block&m=176405170918235&w=2
https://marc.info/?l=dm-devel&m=176345232320530&w=2

[2]
 From abdf4d1863a02d4be816aaab9a789f44bfca568f Mon Sep 17 00:00:00 2001
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Date: Tue, 18 Nov 2025 10:35:58 -0800
Subject: [PATCH 6/6] block: change discar return type to  void

Now that all callers have been updated to not check the return value
of __blkdev_issue_discard(), change its return type from int to void
and remove the return 0 statement.

This completes the cleanup of dead error checking code around
__blkdev_issue_discard().

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
  block/blk-lib.c        | 3 +--
  include/linux/blkdev.h | 2 +-
  2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 19e0203cc18a..0a5f39325b2d 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -60,7 +60,7 @@ struct bio *blk_alloc_discard_bio(struct block_device *bdev,
  	return bio;
  }
  
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+void __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
  		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop)
  {
  	struct bio *bio;
@@ -68,7 +68,6 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
  	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
  			gfp_mask)))
  		*biop = bio_chain_and_submit(*biop, bio);
-	return 0;
  }
  EXPORT_SYMBOL(__blkdev_issue_discard);
  
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f0ab02e0a673..b05c37d20b09 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1258,7 +1258,7 @@ extern void blk_io_schedule(void);
  
  int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
  		sector_t nr_sects, gfp_t gfp_mask);
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+void __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
  		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
  int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
  		sector_t nr_sects, gfp_t gfp);
-- 
2.40.0

