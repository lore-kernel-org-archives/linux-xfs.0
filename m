Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEF81E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192256; cv=none; b=iZQiE/VKYgBj4hmKRsjS5uU+u8bZ+gUA8jrIu1py9PnBGXxvep1JmU728KVtCWBDcV+onInjuFUu1HGk3ISVZoDezU0AejwBMZ3URPEG/WGBU9wtS+qH6x+5GfVcscaTjta2058n/88ViKeViS2Azda0Wa71nfdRPqlimD2cSbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192256; c=relaxed/simple;
	bh=tOcCmBanszvQH4PbKdDB6HDeGg+LmTn56EZDvi6/LGo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rUVQhF16NAzvc3Z+lDvRLJlfLuMmoBbTrO1Cil0ayYAMoGqKKGFVqiLZOutcXL2hZcgB2PP3lIaz6P2pgK159QsrrWD0izljUMTQLK528aYitl0MzqeEEyRIG/bW1WEwUNiGdi1MZTGCaEOEHVeKk0NhJ6NC5x7S54y5qm7RdHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r7e+CHKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r7e+CHKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EB1C4CEC3;
	Thu, 17 Oct 2024 19:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192256;
	bh=tOcCmBanszvQH4PbKdDB6HDeGg+LmTn56EZDvi6/LGo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r7e+CHKqcWOfli7VF589dG31zPyaKqqynDT40EIovogXCB8MPPmEDbfLF6OXxn5s4
	 UayUbCZJRDBunA3fju41gsuEI1oaN9JUCqhuPBPmpsZd3zcE67cbxEiHhRDmLxs3C1
	 1A9z38ZF+IYUwx1R9+wlFDUcYGDaQ9ulV0uVt2PdKAqyWufxZC9d8QZb3hb6aRllD7
	 YZYRcQmdDrXwIR/mC8NGMKymj9hEJQOxsl+Scb61/25PA4VHcEgq6QlW0bKQpQrcNk
	 5Gpdj0huJ2AG5VQK0jGSumAaSiFW2ix39LnpfpQOt1cz0Q+hzkxfHace26OwrV3aPs
	 5AH76szTHWheg==
Date: Thu, 17 Oct 2024 12:10:55 -0700
Subject: [PATCH 2/6] xfs: advertise realtime quota support in the xqm stat
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919073112.3456016.11369324005013611455.stgit@frogsfrogsfrogs>
In-Reply-To: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
References: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a fifth column to this (really old) stat file to advertise that the
kernel supports quota for realtime volumes.  This will be used by
fstests to detect kernel support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_stats.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index ed97d72caa6652..ffb52725c2a8e8 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -115,10 +115,11 @@ void xfs_stats_clearall(struct xfsstats __percpu *stats)
 
 static int xqm_proc_show(struct seq_file *m, void *v)
 {
-	/* maximum; incore; ratio free to inuse; freelist */
-	seq_printf(m, "%d\t%d\t%d\t%u\n",
+	/* maximum; incore; ratio free to inuse; freelist; rtquota */
+	seq_printf(m, "%d\t%d\t%d\t%u\t%s\n",
 		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
-		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT + 1));
+		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT + 1),
+		   IS_ENABLED(CONFIG_XFS_RT) ? "rtquota" : "quota");
 	return 0;
 }
 

