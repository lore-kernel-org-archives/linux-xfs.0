Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB9E49AA34;
	Tue, 13 Oct 2026 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871771; cv=none; b=jqm96vEGCo6YbJuExDU2UtoJj6ei6ffonpVMP3AJtyoXf0UjsD8cf2h3tbJMCNY5i1jXuUVFsF4zlNdk8+wyJVBpW98owqDvyk1Q4EDLnr+tLdBHlB5CxeFp9BtmveEnE4QqalxBK4tftMhTitWNugrondP4BMmGYkiuxTtplPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871771; c=relaxed/simple;
	bh=v1rOVrPY/N8ZbMbW3fzsdNiXfdBSex3pUwAjVY/4fJY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iv+v7kek4coMNOYd+I39jji5CApq+F0XNid3Ia7Auv8RE788t3qCpxzZoBSnh3L5Oty6S0CuQZAwsFR6C0Vu4FwjWqf8N1KoU9oP1+XaNwJLku+AR/rsWgv82OWm1jrHvIqKx6pLq1WKsGVjkaW/gRGcEwnmMyaYlek4t686Tqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4JKGBbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4JKGBbZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3C8441F000FF;
	Tue, 13 Oct 2026 06:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871763;
	bh=iP4yiHEFrQX75zyn+yXQUQ/0V6/QXOXjqMtiJhf9MlA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=M4JKGBbZzyrcSuDONJqwVJ87+IhqzbOvb+XiWJWPEawb+5fVS42OCyuLy6EJvDcph
	 14qgUlYQKh10A8gPkr7oviDLa2gasI8VsJ52bHa9S0sqQw2K+yR0UgrXHTc4zJuy15
	 l2FnoChAXc4fY8037bAxlqmjdDPk5qdTcL7/o2OcUH5v4R55pAfOHKXxMIxPktmcZT
	 FGn4n2CWRjayXhfgO79nfJVUqoYi7+f5FzCdTWJCaEuDbYZobiBocr66ilhv86kv4V
	 WtfAzJdLPDESjb+knjNjBDR4Y3TLYMS8glntL3IOC/1uFycEUfpkMeQacHa2oRGTjq
	 +cK7EJTsh6sZQ==
Date: Mon, 12 Oct 2026 23:09:22 -0700
Subject: [PATCH 04/12] xfs: don't try to repair rtsummary if the summary file
 isn't computed
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107927.1898896.4105859314616542318.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observed that we can erroneously try to repair the rtsummary file
if we've not yet computed its contents.  That results in a corrupt
summary file, so let's add a flag to track whether or not the incore
data is complete.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: abf039e2e4afde ("xfs: online repair of realtime summaries")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rtsummary.h        |    1 +
 fs/xfs/scrub/rtsummary.c        |    9 ++++++++-
 fs/xfs/scrub/rtsummary_repair.c |    2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
index e44b04cb6e2d5e..af1ab64c3f2125 100644
--- a/fs/xfs/scrub/rtsummary.h
+++ b/fs/xfs/scrub/rtsummary.h
@@ -17,6 +17,7 @@ struct xchk_rtsummary {
 	xfs_filblks_t		rsumblocks;
 	unsigned int		rsumlevels;
 	unsigned int		resblks;
+	bool			summary_computed;
 
 	/* suminfo position of xfile as we write buffers to disk. */
 	xfs_rtsumoff_t		prep_wordoff;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 546b335ade1354..fa358746beaf5c 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -212,13 +212,20 @@ xchk_rtsum_compute(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xchk_rtsummary	*rts = sc->buf;
+	int			error;
 
 	/* If the bitmap size doesn't match the computed size, bail. */
 	if (XFS_FSB_TO_B(mp, xfs_rtbitmap_blockcount(mp)) !=
 	    rtg_bitmap(rtg)->i_disk_size)
 		return -EFSCORRUPTED;
 
-	return xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtsum_record_free, sc);
+	error = xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtsum_record_free, sc);
+	if (error)
+		return error;
+
+	rts->summary_computed = true;
+	return 0;
 }
 
 /* Compare the rtsummary file against the one we computed. */
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index ed763290aec1e5..45bdefaeab013e 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -122,7 +122,7 @@ xrep_rtsummary(
 		return -EOPNOTSUPP;
 
 	/* Walk away if we disagree on the size of the rt bitmap. */
-	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks)
+	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks || !rts->summary_computed)
 		return 0;
 
 	/* Make sure any problems with the fork are fixed. */

