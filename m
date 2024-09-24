Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA131ACE10;
	Tue, 24 Sep 2024 18:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203165; cv=none; b=ZQcPJplTWxi3qxwCce7tHffX7fHc2zwCU4alJLWMC3ouFtyhbG90FdVcjABi5wlbuoQ7o5wO2jkXPWbxVnMfFhyT+ELv+ICOFwo0SowQN7bqxhxUhnHBs9bwNwSFeEuSwJpfGb0OtOvSyYOKQso+XgXw3WUUHG8r58OohKqpHEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203165; c=relaxed/simple;
	bh=tcENrtcMJxRF70LM2MBJbIsWcpwzbv86B1hK9uz8Mn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhZPDR3TDNGRk3gMGz7LgIK8oFhMycv81Gg5Zo20zkV6WEA8J3u6Ly/rM9BE9Avd65I1145iTpGjKvcYeDgZz3rLvsInTiCC/KQSjj7taoRH9LIm5WbYoBcDXog8aQTVKbO7LfRW5PGhEICCLI/vZTdrleaBwgb56slI0peQFr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NGdtx7Ix; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGdtx7Ix"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2d877e9054eso4108113a91.3;
        Tue, 24 Sep 2024 11:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203163; x=1727807963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o6EXbfRZ2aZwFPjG7rvKiOifRZyraOAGhm74E6z7psA=;
        b=NGdtx7IxOovDCL53/kFpANWd/M3nkIaD5X+AGTaLLSQCWT28c1KEnX6vy8GDKFp1Ku
         fbgwavbAVmixYNk69EVHBbGEvUsJNDFCxhz4idvtZeNN5t8hq3AS/6JttPNdUv2KWg/U
         SW8ESn6pc4XxvMbM4VRF5ci7rSG1PhQeJbbbcqjnQr/FtNu8RJqfRUfnYoe75Ny9eOxm
         GDj35YCmxb6TysAMV8wd9jHd/9Xfp3k5Fi1WfaBh4DIhf39Qa+prYxDMbGvHwzwvDajo
         M3v3kXZiSsP2Wg8n/XekRNQT7mJ60hGQz9H6n+ygGPeJdvNY+eop9eX5jkvpfPielmMW
         hdaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203163; x=1727807963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o6EXbfRZ2aZwFPjG7rvKiOifRZyraOAGhm74E6z7psA=;
        b=vDoxsYAV8lSO17TjFqEtKdF90a5dqN3RHDb9YuylSTFjVyd0L2zoxa94+gSv8krKmN
         jW6oYUMaVXaOZ53sP55PQ1U927semXkWPDqSxJB4i0gke8Vq0QamGONk8tQtgRni41pb
         z4FJuS+jz64UvoIPOFlSxbAK8G5PWbCnLr8v4N7rP7M61YfxnH2WJK3viDgLQ7eRXpDg
         7+ZeIkfQb3nzEvD4tX4q7P5+I6/ipKP7KkPpbz5oZigi2uCG7yNlGcfl5hUAAls06Vgp
         prnbfuCt+1Ao2ZRltMFM01klOoCfK1DFkPi08EUDf5/NsD8y9jj6vCIiRNwsQDCbHfkr
         vmKA==
X-Gm-Message-State: AOJu0Yz3gUYMnZfqg3j8mN7eILmBe1lWLA5EXNZkVIOfstqcKHaOp2kb
	IKTF1WZBxfed4k0WYThasS/asp7dt836rHgyLPsBWiVhdRqSMlbOE57mj7vO
X-Google-Smtp-Source: AGHT+IF19QN7JkA/TOXDRDdHHq1ZcXzQ9EGx2SStW1gMtkBdiaFCiOmkqPYOB8mFXJ7iUtP8jWhIEg==
X-Received: by 2002:a17:90b:384b:b0:2d1:bf48:e767 with SMTP id 98e67ed59e1d1-2e06afc0ff2mr87497a91.29.1727203163083;
        Tue, 24 Sep 2024 11:39:23 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:22 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 19/26] xfs: fix negative array access in xfs_getbmap
Date: Tue, 24 Sep 2024 11:38:44 -0700
Message-ID: <20240924183851.1901667-20-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 1bba82fe1afac69c85c1f5ea137c8e73de3c8032 ]

In commit 8ee81ed581ff, Ye Bin complained about an ASSERT in the bmapx
code that trips if we encounter a delalloc extent after flushing the
pagecache to disk.  The ioctl code does not hold MMAPLOCK so it's
entirely possible that a racing write page fault can create a delalloc
extent after the file has been flushed.  The proposed solution was to
replace the assertion with an early return that avoids filling out the
bmap recordset with a delalloc entry if the caller didn't ask for it.

At the time, I recall thinking that the forward logic sounded ok, but
felt hesitant because I suspected that changing this code would cause
something /else/ to burst loose due to some other subtlety.

syzbot of course found that subtlety.  If all the extent mappings found
after the flush are delalloc mappings, we'll reach the end of the data
fork without ever incrementing bmv->bmv_entries.  This is new, since
before we'd have emitted the delalloc mappings even though the caller
didn't ask for them.  Once we reach the end, we'll try to set
BMV_OF_LAST on the -1st entry (because bmv_entries is zero) and go
corrupt something else in memory.  Yay.

I really dislike all these stupid patches that fiddle around with debug
code and break things that otherwise worked well enough.  Nobody was
complaining that calling XFS_IOC_BMAPX without BMV_IF_DELALLOC would
return BMV_OF_DELALLOC records, and now we've gone from "weird behavior
that nobody cared about" to "bad behavior that must be addressed
immediately".

Maybe I'll just ignore anything from Huawei from now on for my own sake.

Reported-by: syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-xfs/20230412024907.GP360889@frogsfrogsfrogs/
Fixes: 8ee81ed581ff ("xfs: fix BUG_ON in xfs_getbmap()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 351087cde27e..ce8e17ab5434 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -558,7 +558,9 @@ xfs_getbmap(
 		if (!xfs_iext_next_extent(ifp, &icur, &got)) {
 			xfs_fileoff_t	end = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
 
-			out[bmv->bmv_entries - 1].bmv_oflags |= BMV_OF_LAST;
+			if (bmv->bmv_entries > 0)
+				out[bmv->bmv_entries - 1].bmv_oflags |=
+								BMV_OF_LAST;
 
 			if (whichfork != XFS_ATTR_FORK && bno < end &&
 			    !xfs_getbmap_full(bmv)) {
-- 
2.46.0.792.g87dc391469-goog

