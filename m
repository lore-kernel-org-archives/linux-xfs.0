Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE308F5E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609157; cv=none; b=G6+JJpxe8Qg6HR1qzB127RDTCGq65/+xIOXfVTVQAzJhv/Bp6cfrWZnye+ngCRPsc/hpBFRLykWeR3hQWtaS5BTFnX1JdjO8lIRY8t2oV8f9FsZJPB/nxD3N377vXPBSW7HW0eaPAmOGgmpD1ePDVTrr8FBFZjbD9QhOB5UKiR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609157; c=relaxed/simple;
	bh=YZYxtaudofYf+Jx/HlAMqD3aZxO1/Tu6AHqV/btYkwE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=otDsXq1ZT50wLvwwvkALTCDVl0JrT9ZiduTfCwb8/DdkJvGZInE6GpXAPyRD/gvIPknocuEMGRoi5oNw1VcJ65ff4BLvzAjt4ph07SQM3M5vLS/R1wMtCRdEFFybJxwtbkUNJhq6qeH2/vPaF4QNr4+Y3bDhvWIApcRc9Tb8dv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUqpmyd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUqpmyd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BB8C4CEC5;
	Fri, 11 Oct 2024 01:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609157;
	bh=YZYxtaudofYf+Jx/HlAMqD3aZxO1/Tu6AHqV/btYkwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cUqpmyd99AfZ4X6EZr3BTB22b6D45FqVmO74lvQ3t4TWnhcnG8DC/FYUzT1IInRYf
	 m0hbpUFgHpor8otlsqRVsY9jMAwYynQLmKY4cB9hs86JtJ1PHSzWoS2bO+iIGpPAug
	 nnm+H7T2w+299YCJPrUU9Cu4/c46byTwRbD5utBTMPcsRswT/7A1jLPmZrFCM432Er
	 4SG3angIgvMBHtIPcmUmk1bQ3Nr2wvTpFqOUVqYGKtI9i6VeH8scy7+xHOlsZ20YZ/
	 gSGb028QYEAmit5NDQyd+3EUnESznY/Y1rPoBDRg9UzFTbLP2LQTBIolArgr5Z2RbJ
	 SgInvU6sFN+Kw==
Date: Thu, 10 Oct 2024 18:12:36 -0700
Subject: [PATCH 2/6] xfs: advertise realtime quota support in the xqm stat
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645712.4180109.12939301427402294508.stgit@frogsfrogsfrogs>
In-Reply-To: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
 fs/xfs/xfs_stats.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index ed97d72caa6652..7f0704236c1002 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -115,10 +115,16 @@ void xfs_stats_clearall(struct xfsstats __percpu *stats)
 
 static int xqm_proc_show(struct seq_file *m, void *v)
 {
-	/* maximum; incore; ratio free to inuse; freelist */
-	seq_printf(m, "%d\t%d\t%d\t%u\n",
+	/* maximum; incore; ratio free to inuse; freelist; rtquota */
+	seq_printf(m, "%d\t%d\t%d\t%u\t%u\n",
 		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
-		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT + 1));
+		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT + 1),
+#ifdef CONFIG_XFS_RT
+		   1
+#else
+		   0
+#endif
+		   );
 	return 0;
 }
 

