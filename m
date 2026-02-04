Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71111426D36
	for <linux-xfs@vger.kernel.org>; Wed,  4 Feb 2026 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217629; cv=none; b=SyTIa8SdiWcRhaKBDtsKH5umiCTEYv1lxXbbNdTQNlUHX07nVh0UhgPJtir3Oikr0Mg5uI3fiSLlLNVDx8n+KzhGjLiLzuOJTug/CDuOJ5w23fNa/PsEk/Z2LRT79nQyHo5d7LMQ/6ykKRJJ0ourdnC1CiS3FT2OXKRmbpfibX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217629; c=relaxed/simple;
	bh=T+wMXnee3e1ysV9DVj5UKX4SMufWtgoKmvMQDQfaztw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tgprtp/kKyxEeVRowpZ0fv8q7/coGPRrZeRfaTOJf5CtQKJwnJBezT0aOUedTe0Kehy1QMN3ykMaxHqoFY41xmzBbnqzBH1hvkhJIOz8wWTi8o6rdElWEAxNsxKKXzdH5aobuOC3N9nNPtxDYcm021fM/+MCbDnAE7hX2r04vVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C5v1qf9j; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5v1qf9j"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-823075fed75so548258b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 04 Feb 2026 07:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770217629; x=1770822429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tzPZt+B0mnax59UYD4Szo3zdI8lT14LHpoomqvPuP5c=;
        b=C5v1qf9jOZfX76WleZzMUNmu1QPO6UHoprwgITa/+5y8/rvPaBQBmWr1KVWhoo3HMa
         iNYK+rZE8y8tl6EsP/PR5wSBIcOfVpX1HvR0cyEfhCfoc5g8s6yCsOAK9bSpWDaBGibW
         wZcKQdyMHuQCJRVGXQXv33Gn/kFhRKqsXCy7mGY+SxNjc1fPQJHCsx9oxL7bOU/Z1Y+v
         WJg9Ft01W0uIqelivxx91EOsUtbC3v97g/+BfHxAWJ9uf9sf6jQNnspoTMmjp/74sYK6
         PJGlffFzXbX5odwSHvjIvlsuLM0ITO5tK+kawZVUIGGD7rt6opTIn4LAGSPGVTE3kyk7
         /ytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770217629; x=1770822429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tzPZt+B0mnax59UYD4Szo3zdI8lT14LHpoomqvPuP5c=;
        b=aHx7jK71Z5FRd3Vl6OfxDG9wlNz7B5DM+zgb4NjKUuW3nFY1W6hc0jVYiJp9bWiUPl
         3u5JHNNwOwjm1Njp7hQpB/ArTjeBFqcyGUZzDUAB9mfKQZqKtq13nGnnI1vPjFYBlMpR
         a2T9jplTNarNJ+K1cuCmK7O8J7VnkULbQzzJauRWXeWYqOz+A3jf6Gq3xSxfwPtL8/A+
         raoMakd2qBtr7gAkxNVZs1naKpO87L/pG3RkEgnxmRPz8c6vkZpWAI+v0lbgvQx6eitq
         7nrl1Wmh5rLYfvUKbiaWOOp2Do8ENusRKjLnzUFvb8CmH/v0bZyL2RzmEvE1qL3FV+I4
         TFqQ==
X-Gm-Message-State: AOJu0YxxMeIok5yoNbQG647iqFhDCm+gcvmYml9lAQc/TCHhuit7odnN
	4pR7T3NJC31d1q9vKHJPGG7cGrz5R2WtsU9VJV6eRPqxvStINT3Sku0N
X-Gm-Gg: AZuq6aJGGbXvvCHlSKBuEHQMGvxsvbfm763t3L5ER8yNCK/Apwq/bew79Jy/fv2ZaIF
	wDBR6Ml4Qs97EuSIpp6nQh3klRLeexWJH11hQjRm8uxNFnwQbDpvAoD6qMaz1Qnmwq3HyJusqlt
	QQsDzD53bSA44UMTP4iDTwkN13+246z2gVXLnzQ76MbsP9ZrY9XB5DmdKroEKOWS+gLzXaxNAxw
	xl9d2AOR3Zt8K7ypOOmEhZgQyNOHBCs9yXa4/ssFHoyQlS/On/HdZnaDdvo6+Stl5TWBNeQ3SD1
	Sm5+WBEWIq/fOGy8zGVOLgvmHktyYNYIO+zctFaD2SQKq2eQAMOOUOGx5nYl2w1FvX6axyw18c7
	vRvIgiOwsTpUBTdOc7b39MsQbN8S2t/kT/fqB34Cz7U9CWcx5aBUt1T0NoS5eX+ki3E03/f60eS
	a5YvnMuNeOFB+ZltEdtr5huh40f1Lor3kuar8yKGdHD/tR8exfR4XL8nJQOiEnaYV2PbkrnA==
X-Received: by 2002:a05:6a20:549d:b0:35f:14ae:4a7a with SMTP id adf61e73a8af0-39356189b14mr6734054637.13.1770217628537;
        Wed, 04 Feb 2026 07:07:08 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c84d67f2fsm2495276a12.17.2026.02.04.07.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:07:08 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [patch v4 2/2] xfs: Fix in xfs_rtalloc_query_range()
Date: Wed,  4 Feb 2026 20:36:27 +0530
Message-ID: <4215ff7fc2efcf2e147d2d413e5b0505ab332ec3.1770133949.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_rtalloc_query_range() should not return 0 by doing a NOP when
start == end i.e, when the rtgroup size is 1. This causes incorrect
calculation of free rtextents i.e, the count is reduced by 1 since
the last rtgroup's rtextent count is not taken and hence xfs_scrub
throws false summary counter report (from xchk_fscounters()).

A simple way to reproduce the above bug:

$ mkfs.xfs -f -m metadir=1 \
	-r rtdev=/dev/loop2,extsize=4096,rgcount=4,size=1G \
	-d size=1G /dev/loop1
meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
         =                       rgcount=4    rgsize=65536 extents
         =                       zoned=0      start=0 reserved=0
Discarding blocks...Done.
Discarding blocks...Done.
$ mount -o rtdev=/dev/loop2 /dev/loop1 /mnt1/scratch
$ xfs_growfs -R $(( 65536 * 4 + 1 ))  /mnt1/scratch
meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
         =                       rgcount=4    rgsize=65536 extents
         =                       zoned=0      start=0 reserved=0
calling xfsctl with in.newblocks = 262145
realtime blocks changed from 262144 to 262145
$ xfs_scrub -n   -v /mnt1/scratch
Phase 1: Find filesystem geometry.
/mnt1/scratch: using 2 threads to scrub.
Phase 2: Check internal metadata.
Corruption: rtgroup 4 realtime summary: Repairs are required.
Phase 3: Scan all inodes.
Phase 5: Check directory tree.
Info: /mnt1/scratch: Filesystem has errors, skipping connectivity checks.
Phase 7: Check summary counters.
Corruption: filesystem summary counters: Repairs are required.
125.0MiB data used;  8.0KiB realtime data used;  15 inodes used.
64.3MiB data found; 4.0KiB realtime data found; 18 inodes found.
18 inodes counted; 18 inodes checked.
Phase 8: Trim filesystem storage.
/mnt1/scratch: corruptions found: 2
/mnt1/scratch: Re-run xfs_scrub without -n.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 618061d898d4..8f552129ffcc 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1170,7 +1170,7 @@ xfs_rtalloc_query_range(
 
 	if (start > end)
 		return -EINVAL;
-	if (start == end || start >= rtg->rtg_extents)
+	if (start >= rtg->rtg_extents)
 		return 0;
 
 	end = min(end, rtg->rtg_extents - 1);
-- 
2.43.5

