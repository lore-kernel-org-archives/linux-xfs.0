Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0749F3B789;
	Mon, 22 Jan 2024 11:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705922293; cv=none; b=Db5vjGJt1mF5946mavmyjZob3Hs/Pmatt4BJVAIr0cpHUxy9q0trxJr0BhTyudjTP3fNaRWpAZBinWoDW5IG8RtnLTzvv0a5nlsaKGSwfj6xoxfB4YLNh1Uw+AwcXdXPFwoI4mdDBj3yGaDWdGSdRFBtDaJ8Ma5f0FNYhRtOGdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705922293; c=relaxed/simple;
	bh=lok5iLPNPpn/EMwy21RMp1AVdbOMZLqQK1fJThNAX8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/FKl696k/xtnl+gsPh7e5ijsfNw+5kAQjQkk79GzcLkLcOve9uYPQaGKKsM6pI6R1iYN7T9lwrxFdVtOTlIFGHnuEKcabEp/LNGiGucNywpLg2GjhbsR0LtA5QrtwcQLxRICuFWy0dDMOqrdRW33JvreiKcGMR3wmQ6F8Caz9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=WPVrZ0D0; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="WPVrZ0D0"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4TJSPh6d1jz9sTb;
	Mon, 22 Jan 2024 12:18:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1705922280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w6jQZWWQbujLzz4eHK5E0doLYzCciLidhTUCAzuF75M=;
	b=WPVrZ0D04z0sD1GKrj14E/ydqy0Zv9P0zcPccKCQP144SgmeJphW1nyW6dZp8Kt21ntn0m
	LjXOCBV8zd79cqVtnO8xUJEbQEJy01azhmctip+V2YOGgfN5NFTn07vRbQVeZKLwGsmueW
	l8SnUJeOG10L+89L2TV6Kt/g93MVe3KdIwMfKl9GVLa7SOeCvkDCOLJDqgQH94VyzXhJIt
	abO5t6/RAxiAYiZYM8uM5Sca9hHMDet/Imzxmb33goNtrBFlxe4q6ThvT4SqZx8305c98a
	1Ff0RI8UJ/CP4+v8oLajyMoYbAqAWXD+yOpAgu3UjH6luWbcmY6g6p0IoNJvrg==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: zlang@redhat.com,
	fstests@vger.kernel.org
Cc: p.raghav@samsung.com,
	djwong@kernel.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs/161: adapt the test case for LBS filesystem
Date: Mon, 22 Jan 2024 12:17:51 +0100
Message-ID: <20240122111751.449762-3-kernel@pankajraghav.com>
In-Reply-To: <20240122111751.449762-1-kernel@pankajraghav.com>
References: <20240122111751.449762-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pankaj Raghav <p.raghav@samsung.com>

This test fails for >= 64k filesystem block size on a 4k PAGE_SIZE
system(see LBS efforts[1]). Adapt the blksz so that we create more than
one block for the testcase.

Cap the blksz to be at least 64k to retain the same behaviour as before
for smaller filesystem blocksizes.

[1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 tests/xfs/161 | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/161 b/tests/xfs/161
index 486fa6ca..f7b03f0e 100755
--- a/tests/xfs/161
+++ b/tests/xfs/161
@@ -38,9 +38,14 @@ _qmount_option "usrquota"
 _scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
 _scratch_mount >> $seqres.full
 
+min_blksz=65536
+file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
+blksz=$(( 2 * $file_blksz))
+
+blksz=$(( blksz > min_blksz ? blksz : min_blksz ))
 # Force the block counters for uid 1 and 2 above zero
-_pwrite_byte 0x61 0 64k $SCRATCH_MNT/a >> $seqres.full
-_pwrite_byte 0x61 0 64k $SCRATCH_MNT/b >> $seqres.full
+_pwrite_byte 0x61 0 $blksz $SCRATCH_MNT/a >> $seqres.full
+_pwrite_byte 0x61 0 $blksz $SCRATCH_MNT/b >> $seqres.full
 sync
 chown 1 $SCRATCH_MNT/a
 chown 2 $SCRATCH_MNT/b
-- 
2.43.0

