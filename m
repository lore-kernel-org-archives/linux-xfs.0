Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82DA58209
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 22:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708469374; cv=none; b=eTW1RaV4t63ntHfXZNry6idD2MsptGgNpM11MEDcJQhvySVejkQj++UVCWWGyS/RmDJefEUnTK9cn0cic4gfAoipYsfxbenhegmoYPP6eLPfs5UNYi4Y/fmCAXAgzbsQhBprDRc+M2BV73DqeymbJirhc7KySut5LZBms80//Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708469374; c=relaxed/simple;
	bh=PWXM00JUG/mOK9PlBv5rLLskcwADqslgZHC6747uOM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o/hBD1k8/j8fvqdATJ8Ghn0HxqOEgUDAtmn+/PIvnk/dm4yvvL9KBSPuwQ1KKrq2WsvWmqndHR/Q9+G5ILMPcF83YrkN3/u5lbAhB6RtPXzesmZOAzk+FN/+5XVnKYkYV8xacwi4D/mCaz2fg0bns8LbICYZXm0sm5KwlHSNp9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=l6IACuR5; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="l6IACuR5"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d934c8f8f7so56888015ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 14:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708469372; x=1709074172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eP+k2poDvO1+QIBsZKbEu2rnLoIKV+W3hYuUdqaSiSo=;
        b=l6IACuR5zhdhmSJsKXhfbtqKu6SOK9WY2dGDDzCw3iDz96762AYY3icxOqKVjF8lBC
         Nhh7Qds3YjP9w9yrIvr2NcIGsWTHJO2rP5uiPNSp86osXTrc4p8tylyU9ADOiczIXqqU
         iPlXNDgY7DKpA64szVsFPrfKZBiL8sP5K8M6f96xoIkab1t49dja7ApmU9/Lkmi6esM9
         JhC3+pAWIrEOPxnV2p/TyPA4VOLN5OhIbj2THvOBAsz34Zo+rpjeDF/6zF4edxyoJ/ry
         Wq/2yGVPCGkAGPMgDr3tS8loIzn3ub08LDFGIZVDaXEtUZxhpb1hnvpwj07sfITXpZ7z
         0vgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708469372; x=1709074172;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eP+k2poDvO1+QIBsZKbEu2rnLoIKV+W3hYuUdqaSiSo=;
        b=hQe6F2O3IV9LxWKembtgvAhebSPtME3ySgqXZiyDwISaa8VN9PvCUyIsgEeGS/vy+i
         +Nf3bIj0Rqg2jERepI2i1a3CyFvyimHpJXpEymFkOedn9A9NQDobEY1O/OviGRab9BI3
         o3zNOpkmAdMC91jvU8O2+BMOOjg/x8QlqtHx+LImpBJEih3t9A7LuXhZdFtch64bl6mN
         Ii7Bt3qwDkW2N37BZ4DIMxshFBFMIDP0/4B9JdJNQyydBEZZGpkNrEP9+J0dnFfYBogT
         gLPsskSEIuf6nMDg8ev/lgFt1tqOB0iBpk8Qr9i91HETpyvTlEHwINMg1zN8Z8nLkF/k
         bJNg==
X-Gm-Message-State: AOJu0Yy5Au8XjQ9GSYNZknlwDlp8B9L/L5PeiQmQAhjBiWvb6X2sT339
	UAvdG2jLa74zDrh3VHVZAWQMXaBx71fGq9GFbid65jAiwiGTaEuNyQt3eMDIO1dR3pTB9mwSNDI
	Q
X-Google-Smtp-Source: AGHT+IF/a9bOMdsBO/V8OiaUQBdVOcIIYW1OFgM5QTdmaOZF61LGGVqbzYs69MU/ll26xDdJWYfYiQ==
X-Received: by 2002:a17:903:286:b0:1db:c741:6f74 with SMTP id j6-20020a170903028600b001dbc7416f74mr11244445plr.2.1708469372185;
        Tue, 20 Feb 2024 14:49:32 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id jy6-20020a17090342c600b001d8f3c7fb96sm6735648plb.166.2024.02.20.14.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 14:49:31 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rcYvZ-009G1C-0H;
	Wed, 21 Feb 2024 09:49:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rcYvY-000000000sL-2KX4;
	Wed, 21 Feb 2024 09:49:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com
Subject: [PATCH] xfs: fix SEEK_HOLE/DATA for regions with active COW extents
Date: Wed, 21 Feb 2024 09:49:28 +1100
Message-ID: <20240220224928.3356-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

A data corruption problem was reported by CoreOS image builders
when using reflink based disk image copies and then converting
them to qcow2 images. The converted images failed the conversion
verification step, and it was isolated down to the fact that
qemu-img uses SEEK_HOLE/SEEK_DATA to find the data it is supposed to
copy.

The reproducer allowed me to isolate the issue down to a region of
the file that had overlapping data and COW fork extents, and the
problem was that the COW fork extent was being reported in it's
entirity by xfs_seek_iomap_begin() and so skipping over the real
data fork extents in that range.

This was somewhat hidden by the fact that 'xfs_bmap -vvp' reported
all the extents correctly, and reading the file completely (i.e. not
using seek to skip holes) would map the file correctly and all the
correct data extents are read. Hence the problem is isolated to just
the xfs_seek_iomap_begin() implementation.

Instrumentation with trace_printk made the problem obvious: we are
passing the wrong length to xfs_trim_extent() in
xfs_seek_iomap_begin(). We are passing the end_fsb, not the
maximum length of the extent we want to trim the map too. Hence the
COW extent map never gets trimmed to the start of the next data fork
extent, and so the seek code treats the entire COW fork extent as
unwritten and skips entirely over the data fork extents in that
range.

Link: https://github.com/coreos/coreos-assembler/issues/3728
Fixes: 60271ab79d40 ("xfs: fix SEEK_DATA for speculative COW fork preallocation")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 18c8f168b153..055cdec2e9ad 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1323,7 +1323,7 @@ xfs_seek_iomap_begin(
 	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
 		if (data_fsb < cow_fsb + cmap.br_blockcount)
 			end_fsb = min(end_fsb, data_fsb);
-		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
+		xfs_trim_extent(&cmap, offset_fsb, end_fsb - offset_fsb);
 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
 		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
 				IOMAP_F_SHARED, seq);
@@ -1348,7 +1348,7 @@ xfs_seek_iomap_begin(
 	imap.br_state = XFS_EXT_NORM;
 done:
 	seq = xfs_iomap_inode_sequence(ip, 0);
-	xfs_trim_extent(&imap, offset_fsb, end_fsb);
+	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
-- 
2.43.0

