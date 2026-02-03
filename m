Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D6A39526D
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770130548; cv=none; b=TNMvj0Z/TiefTzKIiGZ6oNNmAgcnfPC8+0aHc9yb3RHerxk7HgKWlKI30O6CwbMYai0zsiPorQ8Pzmnge/DhCHk3FpWaU6OQyh8I+UM3Rqti/uRrahRgQE31g3IJAYVA823y9QLiPQ9kE0OLa2roKp5rvKRkltFQEAkDJU1e5kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770130548; c=relaxed/simple;
	bh=1oPpgYbDz7mcLg4SUtprx5qlPIWdoGEjMzwHOa7Er4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNJMrZIsolxs8Ptd9/aqbLJ+4CRLiPuIcwdrHjQ5bRjbw2ef2YmBYzEYiKaZ3JC2OoZECXL6OdL6xlAjzSkpi8VkkqrOIIjsMDZmRThRLmbEpmxZN1Rm9dLdBtdUt6wDAw8Xqu0i0CQCzr0bCp0yDrK6tkS2SFEGO2FNcah3Kc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3Ot2VKC; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3Ot2VKC"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a78e381fc1so27834525ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Feb 2026 06:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770130544; x=1770735344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpEec9zFZd2KdyugsuQGFXIuPsgdOYSt6RZ5GYYEpww=;
        b=N3Ot2VKC/w3E3RA8CBatAwXCBkxXcgTQy29/zo009brK2Z14NvCWP5ell0QCzlWAOP
         lNv4995enWDBVkLRvkyx2tDkrNr/Afv6Rl0ohdRcaEbGYwCkOGdGH5umsCvo3658p/th
         iLh5HX0jvqQWyLI4AJjTgLITlsLWY9hpRupdmR29PNf/hQYzXm65ZAJbunIRKXhTC2DL
         Z4fncZe8fS0nh0K8n6ViWr4exEwAEQjE4RAIzgzVTouH3ewrN6iiTETSEo2fPOStY9DV
         ULbOPyNC7M3Cf0vwTjX5/vT8p9EJ9R8GBGgmPQi+nWgY5tgP4tQvkeYc9EXiQ6ys1k9P
         zsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770130544; x=1770735344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UpEec9zFZd2KdyugsuQGFXIuPsgdOYSt6RZ5GYYEpww=;
        b=uKIEXtU8KXf1akm2VlbseF70vf3FI0QJBa12ju6RjKdv3/ooP+fE5ZvwJ6xW33LRVK
         zET58VbJvN9xTEQf5sp+9Ml4QVrmY0gdfsUXO+IkL4jpMGy2nY5kEvMuVrwwX4Bbmslb
         CRCi6a63Qpb99lv/FS9lUCa6CHEaYgnS6s5gQ4BPCRKPUAhabSNLrP12fHx3AmRsR2M8
         5VRRR3TzK5+GIITFDVlUibOexDcMgzhd10ku5NoxQj32byQnMv6ZWyycSDOXc1FsyZJX
         /dero9+uXFMWuM+Y8CzQGT4v4cexmsJ1fupNqzhVf+69gkzoajdsmSg7lU2ph3OOE5AW
         cumg==
X-Gm-Message-State: AOJu0YwBfouyUHMoVkrnUAShmAE81xK//cJaS4mtWpTMdNu4M/jfb5me
	IKz/NJXdJdyMkQDKpvRTXxb5+wOn/X+b3gLuWI4AIYLbd5qlePRbMI5r
X-Gm-Gg: AZuq6aJxAj2RnQHFytywT4I3/kJWV78JBcmZO5RrqKpAvRvMmcqgnxrPIYt7pS3Vv4C
	ySlgIJdjuCnc6yDWg7KZjcdkimI0cLPYmqSsrac1C30VJwdCjDtYjbyiZxIrXk/M5nuDitfMOqU
	QZLGaHq6/Peyuz0F1hsk+LK0rD2H6cw6ku51V5fiBgiueHHLlPlLDkPCvDN68AVYbse6+oBY0za
	lo2lFWXZJGGbmh5hd+d5dzb4brBW55F2uaMoT3qefUBBI1m8hShqaraQyZcqXyA5Chjf3GMVOyZ
	OK7uy1fHBR/z7I9A0uyBHxumJzKkBbYkRehEUeAsmZ2b+dJb+f2hvDxtlFOJZFfcxTeOytU/z+1
	kR8kczM116wkjEjhGSRGn/rjdx2o1iPRq8x+b24lPgMVdPdoCqvr971s3KDEFYsAZYbmNONW76K
	hueyGCHgbmSxKdl+NcqEipJzNFBy1P5XwGlbsRXRGEto0PXddePEC2gP18PRiXFJPym2N3dg==
X-Received: by 2002:a17:903:1b47:b0:29f:2b9:6cca with SMTP id d9443c01a7336-2a8d9943ee6mr149667035ad.44.1770130543933;
        Tue, 03 Feb 2026 06:55:43 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c4665sm175364075ad.64.2026.02.03.06.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 06:55:43 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [patch v3 2/2] xfs: Fix in xfs_rtalloc_query_range()
Date: Tue,  3 Feb 2026 20:24:29 +0530
Message-ID: <40bb6291838c95582ae967f3e35980923129d7b7.1770121545.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770121544.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770121544.git.nirjhar.roy.lists@gmail.com>
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

