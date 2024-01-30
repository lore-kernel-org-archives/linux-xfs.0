Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BEC376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591276; cv=none; b=BTOa2r2ZHLymwvRzn2FO9AMlLLr+YO52b+OixJv3RmLRkEbapkXWbByGFOKvpuhpXfNDMD0RleJPpenk+GgvyY/9HeGExA/si82RUgkj7Ng/sXUgqrj8KTDeYMyRLwfzrUXlhdzHgb/d5Y48WGzHhwa5k5iS2Kcmm9nKU1wD+i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591276; c=relaxed/simple;
	bh=qRSHv0U7NWn5PPbqBf9SVmdXk1NiRrFCrtxbwBQjdpo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rXRvcoLBh6d1ShH5i9kDRdyBI4ClCPK41TTlYKyKd76195uPlgGngiQN6/rJsHSzKrTXN3hbOzL9LaGUVeK2jxu4t1mWCVYhLSPEaANIaDZzgbUvg5+3akOls+bna5ryubvFaPQdV3xtbmlNGB+/Z9RtUtvJTb5+BHwzGa3reYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqiz8KCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqiz8KCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04977C433C7;
	Tue, 30 Jan 2024 05:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591276;
	bh=qRSHv0U7NWn5PPbqBf9SVmdXk1NiRrFCrtxbwBQjdpo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eqiz8KCRS6npLF49qz+MnP5mWmpLNuYVGdI0u/pXX+acitFFotosKzaDyB/mGOBLc
	 zpQoNkIMYScjZuH7DAfCjPrQGhs7nzRCJ1HxPCNScNG/tW9U2zz6HI0eIAMEQt5dQG
	 aEkKaCO7TR2/Gz4/LyHAYjcE0GvKuPBYjNTmIikWx0T6E6HXisxyjktDItQk46YJa8
	 1se3SWZ39ihJJlcflCEKrc0h+xaELgn2FmjE/8JX4TVPqzYKlNczIKbbowv6et2jNy
	 vHsn2XgaCpQBuw4qSkoqRv/mcyHLXQ1FbtRxiyjRz+4msCJg7tGVheMDNI1r49lyAx
	 OHduUTJ2c0POA==
Date: Mon, 29 Jan 2024 21:07:55 -0800
Subject: [PATCH 7/8] xfs: repair cannot update the summary counters when
 logging quota flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062869.3353369.8910186021209077091.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
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

While running xfs/804 (quota repairs racing with fsstress), I observed a
filesystem shutdown in the primary sb write verifier:

run fstests xfs/804 at 2022-05-23 18:43:48
XFS (sda4): Mounting V5 Filesystem
XFS (sda4): Ending clean mount
XFS (sda4): Quotacheck needed: Please wait.
XFS (sda4): Quotacheck: Done.
XFS (sda4): EXPERIMENTAL online scrub feature in use. Use at your own risk!
XFS (sda4): SB ifree sanity check failed 0xb5 > 0x80
XFS (sda4): Metadata corruption detected at xfs_sb_write_verify+0x5e/0x100 [xfs], xfs_sb block 0x0
XFS (sda4): Unmount and run xfs_repair

The "SB ifree sanity check failed" message was a debugging printk that I
added to the kernel; observe that 0xb5 - 0x80 = 53, which is less than
one inode chunk.

I traced this to the xfs_log_sb calls from the online quota repair code,
which tries to clear the CHKD flags from the superblock to force a
mount-time quotacheck if the repair fails.  On a V5 filesystem,
xfs_log_sb updates the ondisk sb summary counters with the current
contents of the percpu counters.  This is done without quiescing other
writer threads, which means it could be racing with a thread that has
updated icount and is about to update ifree.

If the other write thread had incremented ifree before updating icount,
the repair thread will write icount > ifree into the logged update.  If
the AIL writes the logged superblock back to disk before anyone else
fixes this siutation, this will lead to a write verifier failure, which
causes a filesystem shutdown.

Resolve this problem by updating the quota flags and calling
xfs_sb_to_disk directly, which does not touch the percpu counters.
While we're at it, we can elide the entire update if the selected qflags
aren't set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 745d5b8f405a9..3d2c4dbb6909e 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -687,6 +687,39 @@ xrep_find_ag_btree_roots(
 }
 
 #ifdef CONFIG_XFS_QUOTA
+/* Update some quota flags in the superblock. */
+static void
+xrep_update_qflags(
+	struct xfs_scrub	*sc,
+	unsigned int		clear_flags)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*bp;
+
+	mutex_lock(&mp->m_quotainfo->qi_quotaofflock);
+	if ((mp->m_qflags & clear_flags) == 0)
+		goto no_update;
+
+	mp->m_qflags &= ~clear_flags;
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_qflags &= ~clear_flags;
+	spin_unlock(&mp->m_sb_lock);
+
+	/*
+	 * Update the quota flags in the ondisk superblock without touching
+	 * the summary counters.  We have not quiesced inode chunk allocation,
+	 * so we cannot coordinate with updates to the icount and ifree percpu
+	 * counters.
+	 */
+	bp = xfs_trans_getsb(sc->tp);
+	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
+	xfs_trans_log_buf(sc->tp, bp, 0, sizeof(struct xfs_dsb) - 1);
+
+no_update:
+	mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
+}
+
 /* Force a quotacheck the next time we mount. */
 void
 xrep_force_quotacheck(
@@ -699,13 +732,7 @@ xrep_force_quotacheck(
 	if (!(flag & sc->mp->m_qflags))
 		return;
 
-	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
-	sc->mp->m_qflags &= ~flag;
-	spin_lock(&sc->mp->m_sb_lock);
-	sc->mp->m_sb.sb_qflags &= ~flag;
-	spin_unlock(&sc->mp->m_sb_lock);
-	xfs_log_sb(sc->tp);
-	mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
+	xrep_update_qflags(sc, flag);
 }
 
 /*

