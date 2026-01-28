Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAE536B061
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 15:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613338; cv=none; b=b6zKl2JpJBF/2iHhX8VV+znqEaaiMms+4I7WWwxBn99/A/eUqVYlglHZ4qQ+SgLAaeqbzwjvnzWHlnJ7i7J91vWJXHDPSim0mIYmydKYjPVGCy+ZfMSYy6Ne2BQk3Mw8vbs7+fFU7UD446flTg0t2P9gXPmW95uy8c06MQTmoGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613338; c=relaxed/simple;
	bh=ZqzI34KeV4NaSMggHKHOT7De/5R3BRVuDPZLrCkeNKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ/Oxj97kZ4BAmG+mu9ULQ21B3Am6WoOEhuk9LTATznGFanKt9IlMvdE9hKF1rXLbOGGErL9oA08lzlrTyV0k1+XdKwPIOn7m2+sa9rxPJ7df119ezLYCrTr3Vem5jOiAC8WcTIgpJmvaBAXNHpgxwWkQNEX2L0ahc7wZp4lPiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R+aP9bGt; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R+aP9bGt"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-bc17d39ccd2so2462616a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 07:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769613336; x=1770218136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fu+qCwTapAUreSSF92wqEXaYJG8Xehdob2qvKmqP0Gg=;
        b=R+aP9bGtpTMs5QC/kd3XCC9WEN5Ec0P0dj8gfXIyL343Evx6w3+Y5/HVDDLTOiSwq2
         zQ0elSOJUMw+zmUcllbPgyp3nJ09AJQz1FCHdulhk+qUluXq4KwsohHX14AXYWw2LyLs
         8ThC3bNZRD6qIQdq/ujrXAb77MY7SO6CdI8zTVp/Rl/hwzII501n37z+pds//4GPLCEW
         2JATYqb3/IOXb1l0HvVeC8jLhBprYM9hTdDK4vV6cNAO3hNRQKNQwMePFSmn271JLeXw
         yJwCah0UvUI5AopWZPnLipznGPLIzO7EQW+sNypC7MZedP+PuhrnqI8bZf+UgyOVIGJ2
         5FFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769613336; x=1770218136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fu+qCwTapAUreSSF92wqEXaYJG8Xehdob2qvKmqP0Gg=;
        b=qbRqidFC3NNYV/a8nKh+oxxDicgm46PdKNfHfryhPNjeGuSJicTsMm/bpU1SeGoP9m
         UlYBJbL6btCKuJS/iGbnlnNDAXf6kojfn2X5L/vQLjQ+iCDi7ZrUR6AD3buG2JhDXngm
         ic7MMjORqENEOKWg+P4wnyUsiDDmYHtp1I02/ZQ8OpqRjsOwS+u1OTpr+eHZwMdIOKxu
         x+L46kxNacG+UDR+S1uNvlpUc8lDBVu4yZz/uPU7idwCzfeUDyMTJnPRAJdlVfJFRyya
         3eqTLpwHvF82NLtLkHf7vGO5VbafkCWVxrK2B80uQ6EeElgDV6otR+PZ4mggNi7Z9LmT
         /W3w==
X-Gm-Message-State: AOJu0YzQYsmc0xVu6xd1nGuYY91pD6YrazxFFCzJnjm8g42USRVTzn1Y
	QMy8Yz3x/JURvStSzmNZg8NDEilHG4qqZnDR89M8LymxTloI6Ev6qJ4ixD0hSQ==
X-Gm-Gg: AZuq6aLfZ5o6JgL+xpkoYB7A3/n88VbjQorhlmbY2Ev8h153auK9QndADl/xfW8ucUM
	GRyPgJp8COfxpHUhCMwjH514Nxpde6nx5VRTjmKxHGlvIhst8jYiswhMncKYGPQ+zgbCPENhr6d
	UWaM0yOVR7rAnP8uj/vshViLqwTOeW4nUyiS5c8yQ2WxcSvOL5NBmXWYTo6zUDU7rggcHy8VpyJ
	MZaKCgC3lyPaDo9RDebtXh+i25Yrj9XJNPDpwneZBF6DpQqOrE3Krbh6rXXhBBDVTJIcLEFtnw1
	YXUVG3juSQP/1br+E+pKOuS6mxBoTUxcG6N6UkIg7KziVBKgQIE7CYmxLyvj/Zsu8FeaW2W/HaH
	27IlyrjMsk72p6iJhFH8o4UgASYbvHt+J72lTQZRmvDu9hsiEmfyOMn3zXpl3SQqOcD09Pu7q6h
	Gj8cuGAOt5mCHRYRSjgufeSWORpkMKY/svj2Z9XmrJXE85k8bUfDCCD+gfjSPS6OPZ
X-Received: by 2002:a17:90b:1dc4:b0:34a:adf1:677d with SMTP id 98e67ed59e1d1-353fece4939mr4813412a91.9.1769613336005;
        Wed, 28 Jan 2026 07:15:36 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f2f0283sm3286080a91.5.2026.01.28.07.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 07:15:35 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1 2/2] xfs: Fix in xfs_rtalloc_query_range()
Date: Wed, 28 Jan 2026 20:44:35 +0530
Message-ID: <43e717d7864a2662c067d8013e462209c7b2952a.1769613182.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
References: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
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

