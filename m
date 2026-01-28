Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9FE26463A
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 18:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769625932; cv=none; b=qGKOpZxvioBlqxAeKOUpGbPKSy4poaLUvv6BBqR2fkONxcYG4gQrRSj/SOjsxtboL6nJHVzpMuy+WBmehzxy6bwKexpbQweWyZS+xxfBZEKRDtkD+rmq2lEN4nhrvuUtnIxuR7EU9qKdOgspmr92/djxy1x4S658guJ2E4TG3Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769625932; c=relaxed/simple;
	bh=0CLbT03r5vSG/MgKh8WUBh5oiTbZRn4tfy3Bv3khLx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKqeBSrE7un2q1QywVwnYTZ8ElAnO6/vWXD3jAH74hUEPzJsfO5vcsX1I0DW+zf6EQhb3pnyrUHxPCTSjxiQksAkJIl4uOG9hQNW1MN+ncotjqMKf7d9F4e9MW4Dh3IhE6ZtVCwnUKENOnhXQ8MOhrPQbItp1XtCew6ZTBJxne4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h8LKY86K; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8LKY86K"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a79998d35aso685565ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 10:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769625930; x=1770230730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6magBzZhz5IWiUMcBiS8RKl+ND9ZscGbMUReMXsW9nI=;
        b=h8LKY86Kd1St3eXo7EnkoplRigfZF0hw4NHVYAniVsYsnDZzJWfX+U3ZjPs4N/1yGF
         KLcCQ4lhgt2MwKO9HeOKwVKW44hnOJ5jKFkuS2fS37JNQcMGaYzu4Fl3ACoDv5X2jKJ/
         nkR1AxQiIsPDCo2NQVEWQUKqHiOnjxF23+aAeu4K+rzifN9s1nUBUA/UBz25WpmSlwT/
         UGBOTrNl6A0js/WYMTAOOiQsgm4R0QfTRDJ2cQwAZEq1XAo18CtmicpwrOce+sOdKnx4
         /+zdouUAD/5pJ7Y8ARvyd5Mo8ycJnND4OgnOEqNvbPjcDdRToUZ4e1wSUVmvU8A362Yf
         +/lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769625930; x=1770230730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6magBzZhz5IWiUMcBiS8RKl+ND9ZscGbMUReMXsW9nI=;
        b=NKt650mczSpmBFGZtzwLkmQ7cYRHObfJnDi5REsk4ifK5uMDRR97BOhO9rJXfwi7+w
         nWaM01q6dwBBZj2hLgv4LUMTO9MyRcBywaorYyF4OzHjzpiM0Yi+xnqXjZgpTOfEM7Rc
         ZeEmVJW95Ygtq0E/bzeFWgbdIVHUhI2ywqNxocsx/srKB/WSTHpSRC9nZhTz4F9suO0O
         zsrjTnWVnYI35wMIqHnT+QNnzyCf8ErDEkZ3FXxlgEXQP8OTyQPw77BWXm39IDvUvAQL
         DkioPCfFTUt4534a7io51AAXOcz0vbkArtqG64O+zUOoRAWI/aamuQp2ZXzKszkQXIpq
         LN6Q==
X-Gm-Message-State: AOJu0Ywd0LuO07JjRnPJDDj1jO/JibTbycAgYPPd1k4sXIF7v1ySIpjm
	SY0P7P46i1n45DZneMXwN0L/2r+uV/V2pzFq5jFHdU6EhdhFEuxR9THMpsJ9bQ==
X-Gm-Gg: AZuq6aIZo00Et0uXY2sYu9XMbVC2rOHV67tQZ6veH6SokPdytsAbHgGl+265inGPQTL
	rek3zO8SsycqwUnW4C0uTaI5Z+VS5nVSUGXyVkXd56AvD1Ir0baJtb2wkBck6FAejTk7Ukfx9uQ
	vmUkMdT/xLxpDdqI310SbsHHVRz6gyhfnYOdsIdq8gJcpUGti6DOD3DYNd6Fa4d8/XusExbmQpw
	p8ainHjSHuZ7XAX+OhcjFzoWo+Pnt55vzj+igESS5Zw2PoOspJXRq0VvTCe7ZA2CscXeVvLUF4t
	uQ+RcPhRzaK/YhT9n2ZZAPGiF9tO+wpX+UetXrLc08jHjm19q6O3o7R33hm/jjCciLI1r+l4di9
	YBqiCmt4HFpkWWKvpDWmyZmAHrdOuExlDtqEM2ZfzD9hm9WG/kUiqvJIF2VMXpMfEebFJeI48C0
	rq155L8jas3PyxDyQeD0E+V8XO8w5Gs3mZL8kwQYa6GtrU1AhFHWe8Dq2KhWAKXfmE
X-Received: by 2002:a17:903:1a6f:b0:2a7:5095:c92a with SMTP id d9443c01a7336-2a870dc6c2bmr66016585ad.31.1769625929647;
        Wed, 28 Jan 2026 10:45:29 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3dd4sm29068745ad.65.2026.01.28.10.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 10:45:29 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v2 2/2] xfs: Fix in xfs_rtalloc_query_range()
Date: Thu, 29 Jan 2026 00:14:42 +0530
Message-ID: <2bba12bddb71ad566eb94958aae239f2cd58777c.1769625536.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
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

