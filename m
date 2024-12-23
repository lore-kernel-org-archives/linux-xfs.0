Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C952A7E76D;
	Mon, 23 Dec 2024 23:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995146; cv=none; b=j72XFJ5JyywbDSxGe439iSRx9703PnTf9JTY+VFVvTpkqwX0gJtGUEAUIUwwlYm6Gv7SnBYMp910TCvV+iQ3EWw2iDUKQhgHrdzj/OSOoYFPnoeKeuXDRMrW8Ubg27mGrAo+DyOcTMXM8N9gIZA4FT/qj4YxyVRuTwGoAlmmZdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995146; c=relaxed/simple;
	bh=uxsduaCP/SeoLlXMGsjlSgbl4aQ1b0VF8Be4rceYVeM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ec7dBmZlJtgJmvOvctyjgV1iQKj/SXadqj1mo2TtcnoCSMeEY1FWN5ZGPKFvwbqgAZTYvz65m8vZBNPDTS6/REvLvBu1q/aeJlihI2xERRJqWYLG2ou7dse5fdv/lkNAdufnipUKxmLUMmLCr/LuAi6WUP7msHm4V1566yHQyl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0E2NcNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0E2NcNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0132C4CED3;
	Mon, 23 Dec 2024 23:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995146;
	bh=uxsduaCP/SeoLlXMGsjlSgbl4aQ1b0VF8Be4rceYVeM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a0E2NcNieupzrVfIea5ZHDspLdJRwZmYJlUyhf1d2lNpWmVLDp+1yudiR961TXVEX
	 xBOHR7EvhPBFxD6GkL0b/nUE4HzcMQZZ85gXFZIf1nOIWPYsN2uxyeCbtAv/sXQ6fU
	 w4caR2pqDOnA3U6M4lAONEToJ+t5LO1PhcLaU8P4eI1r2N+3+6AyUQ2t/FecbcRCiv
	 U3a4+ykz3rfTTZU9gscGtgl76mQokSKXycNCS9DYAijWekuMemHkYtYVdDtyjxvdqI
	 y/vdT3+8NJYF21X5uCDglUccLpFyMJqbWeRRDJS1ex26BqKKxt4WAWvWSs6OALXii7
	 hu8urKJRO0JHw==
Date: Mon, 23 Dec 2024 15:05:46 -0800
Subject: [PATCH 35/37] xfs: don't shut down the filesystem for media failures
 beyond end of log
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419322.2380130.8761329319627277912.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the filesystem has an external log device on pmem and the pmem
reports a media error beyond the end of the log area, don't shut down
the filesystem because we don't use that space.

Cc: <stable@vger.kernel.org> # v6.0
Fixes: 6f643c57d57c56 ("xfs: implement ->notify_failure() for XFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_notify_failure.c |  121 +++++++++++++++++++++++++++++--------------
 1 file changed, 82 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index fa50e5308292d3..0b0b0f31aca274 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -153,6 +153,79 @@ xfs_dax_notify_failure_thaw(
 	thaw_super(sb, FREEZE_HOLDER_USERSPACE);
 }
 
+static int
+xfs_dax_translate_range(
+	struct xfs_buftarg	*btp,
+	u64			offset,
+	u64			len,
+	xfs_daddr_t		*daddr,
+	uint64_t		*bblen)
+{
+	u64			dev_start = btp->bt_dax_part_off;
+	u64			dev_len = bdev_nr_bytes(btp->bt_bdev);
+	u64			dev_end = dev_start + dev_len - 1;
+
+	/* Notify failure on the whole device. */
+	if (offset == 0 && len == U64_MAX) {
+		offset = dev_start;
+		len = dev_len;
+	}
+
+	/* Ignore the range out of filesystem area */
+	if (offset + len - 1 < dev_start)
+		return -ENXIO;
+	if (offset > dev_end)
+		return -ENXIO;
+
+	/* Calculate the real range when it touches the boundary */
+	if (offset > dev_start)
+		offset -= dev_start;
+	else {
+		len -= dev_start - offset;
+		offset = 0;
+	}
+	if (offset + len - 1 > dev_end)
+		len = dev_end - offset + 1;
+
+	*daddr = BTOBB(offset);
+	*bblen = BTOBB(len);
+	return 0;
+}
+
+static int
+xfs_dax_notify_logdev_failure(
+	struct xfs_mount	*mp,
+	u64			offset,
+	u64			len,
+	int			mf_flags)
+{
+	xfs_daddr_t		daddr;
+	uint64_t		bblen;
+	int			error;
+
+	/*
+	 * Return ENXIO instead of shutting down the filesystem if the failed
+	 * region is beyond the end of the log.
+	 */
+	error = xfs_dax_translate_range(mp->m_logdev_targp,
+			offset, len, &daddr, &bblen);
+	if (error)
+		return error;
+
+	/*
+	 * In the pre-remove case the failure notification is attempting to
+	 * trigger a force unmount.  The expectation is that the device is
+	 * still present, but its removal is in progress and can not be
+	 * cancelled, proceed with accessing the log device.
+	 */
+	if (mf_flags & MF_MEM_PRE_REMOVE)
+		return 0;
+
+	xfs_err(mp, "ondisk log corrupt, shutting down fs!");
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
+	return -EFSCORRUPTED;
+}
+
 static int
 xfs_dax_notify_ddev_failure(
 	struct xfs_mount	*mp,
@@ -263,8 +336,9 @@ xfs_dax_notify_failure(
 	int			mf_flags)
 {
 	struct xfs_mount	*mp = dax_holder(dax_dev);
-	u64			ddev_start;
-	u64			ddev_end;
+	xfs_daddr_t		daddr;
+	uint64_t		bblen;
+	int			error;
 
 	if (!(mp->m_super->s_flags & SB_BORN)) {
 		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
@@ -279,17 +353,7 @@ xfs_dax_notify_failure(
 
 	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
 	    mp->m_logdev_targp != mp->m_ddev_targp) {
-		/*
-		 * In the pre-remove case the failure notification is attempting
-		 * to trigger a force unmount.  The expectation is that the
-		 * device is still present, but its removal is in progress and
-		 * can not be cancelled, proceed with accessing the log device.
-		 */
-		if (mf_flags & MF_MEM_PRE_REMOVE)
-			return 0;
-		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
-		return -EFSCORRUPTED;
+		return xfs_dax_notify_logdev_failure(mp, offset, len, mf_flags);
 	}
 
 	if (!xfs_has_rmapbt(mp)) {
@@ -297,33 +361,12 @@ xfs_dax_notify_failure(
 		return -EOPNOTSUPP;
 	}
 
-	ddev_start = mp->m_ddev_targp->bt_dax_part_off;
-	ddev_end = ddev_start + bdev_nr_bytes(mp->m_ddev_targp->bt_bdev) - 1;
+	error = xfs_dax_translate_range(mp->m_ddev_targp, offset, len, &daddr,
+			&bblen);
+	if (error)
+		return error;
 
-	/* Notify failure on the whole device. */
-	if (offset == 0 && len == U64_MAX) {
-		offset = ddev_start;
-		len = bdev_nr_bytes(mp->m_ddev_targp->bt_bdev);
-	}
-
-	/* Ignore the range out of filesystem area */
-	if (offset + len - 1 < ddev_start)
-		return -ENXIO;
-	if (offset > ddev_end)
-		return -ENXIO;
-
-	/* Calculate the real range when it touches the boundary */
-	if (offset > ddev_start)
-		offset -= ddev_start;
-	else {
-		len -= ddev_start - offset;
-		offset = 0;
-	}
-	if (offset + len - 1 > ddev_end)
-		len = ddev_end - offset + 1;
-
-	return xfs_dax_notify_ddev_failure(mp, BTOBB(offset), BTOBB(len),
-			mf_flags);
+	return xfs_dax_notify_ddev_failure(mp, daddr, bblen, mf_flags);
 }
 
 const struct dax_holder_operations xfs_dax_holder_operations = {

