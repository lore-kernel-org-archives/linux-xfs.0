Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F26ABE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jspskUh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7069BC433C8;
	Sun, 31 Dec 2023 21:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059966;
	bh=biEclcCQcchoKmaQnJ77jDteDGJoW05rv/DC27kjOFc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jspskUh5aua7iy2MFAzv5WFoW6Ee0+EYzXiakFS9/fbkOnzU0nit9yTHq+V9v3dNJ
	 8Qc31c/t0C42poC5YYT3N/qERKl0jmE9Nrb/TIZRJcNYRHrBdrbF/cynKkepBzb8Rg
	 bTbw07QydoGM0aGx7d7FuheER2CEguO3qrt2XHV3zv4OeAXQ+EBapSsj4EzEVNbEPN
	 53RavS9eim9yXUiEtVTg2GQlFVE2XJ1Hy8RGj6OeYvXxhtd/o0hjXJsDT1y5FDmXiu
	 +c4dW8JM4o0v4zteV1T/wr1E/AzEFmM+BG7PwftkG4PB/+UAOltqmuSy29Hz7N6KhD
	 /7I4WWcf4HjZw==
Date: Sun, 31 Dec 2023 13:59:25 -0800
Subject: [PATCH 4/6] xfs: advertise realtime quota support in the xqm stat
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404853239.1767666.4987419457161292634.stgit@frogsfrogsfrogs>
In-Reply-To: <170404853163.1767666.1660746530012636507.stgit@frogsfrogsfrogs>
References: <170404853163.1767666.1660746530012636507.stgit@frogsfrogsfrogs>
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
index 90a77cd3ebade..ab682c2c2152c 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -113,10 +113,16 @@ void xfs_stats_clearall(struct xfsstats __percpu *stats)
 
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
 

