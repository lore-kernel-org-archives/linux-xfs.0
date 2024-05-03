Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADCD1CD26
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 04:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714710860; cv=none; b=DrpEuZjNHM9iRr3bmaeSV7SITr5VIpcNvmKAI7ZnFUm9gJ5uh0rNK6szFjdcTG9TIc2UPs/pDZ6OIMK36IhTWqHAFtJABOEthVOkiboB8boYQxG3lik7CWOFQ22/3M2m9+M0qstwctfwATFptP/WeZcMt0AcvC7f5MMA/pr2SKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714710860; c=relaxed/simple;
	bh=VLKZ+Zd6B5mrSBjKtV1+O/nhPe9hVc+LIIhhM5KPidE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SGqDf62+xZ95a4AvZUhJoYZHX4Qf6+dOP0Is8Pb3elf35jXf93QtlPT1Xyaz1evyvDDsBhnvZvrpgRLZKbYV/HjsONQ101MvkS7A7LxI2laUF8FO/GEPJF990RkzKDHVenBIyWpRwW76yku7xGoKF7Vj0w6hI/ttri8W9BtSJtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=naRwr6e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="naRwr6e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E4CC116B1;
	Fri,  3 May 2024 04:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714710859;
	bh=VLKZ+Zd6B5mrSBjKtV1+O/nhPe9hVc+LIIhhM5KPidE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=naRwr6e+OEMN+gshzNpa8BeUhJhE2OruNeiF8vp8+y5lZiHNpXGIBsvE+xRvfASYe
	 5tkLlcYyeh6eZiE8YHsy6DRRHrJsx0QQSMiQx4JrN4qq4SFgMvrvjFXgPmi3SEVU/0
	 p5cmUlEggd6w+Zn35DUdiRQsmDgloJnEuyYKB5rmZiooziukDC1/+Rv2b+cJuweU8C
	 YkQhmeVJgB/trWLUjc6fxXeZJ8SK+ycw2MfIsnSbyPpUlaa8BGqQxFIZ+x0BOvo6c3
	 G7vWysXjRsw+M/MiXZTpS+EiX+9/20XeeQ2sc7RvcIsmepF55pxt/HDCUTIBzEl1xn
	 0UtRPQj94tvEA==
Date: Thu, 02 May 2024 21:34:19 -0700
Subject: [PATCH 3/5] xfs: create a helper to compute the blockcount of a max
 sized remote value
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171471075370.2662283.6573224701765191832.stgit@frogsfrogsfrogs>
In-Reply-To: <171471075305.2662283.8498264701525930955.stgit@frogsfrogsfrogs>
References: <171471075305.2662283.8498264701525930955.stgit@frogsfrogsfrogs>
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

Create a helper function to compute the number of fsblocks needed to
store a maximally-sized extended attribute value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c        |    2 +-
 fs/xfs/libxfs/xfs_attr_remote.h |    6 ++++++
 fs/xfs/scrub/reap.c             |    4 ++--
 3 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1c2a27fce08a..eb274d4d636d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1036,7 +1036,7 @@ xfs_attr_set(
 		break;
 	case XFS_ATTRUPDATE_REMOVE:
 		XFS_STATS_INC(mp, xs_attr_remove);
-		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+		rmt_blks = xfs_attr3_max_rmt_blocks(mp);
 		break;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index c64b04f91caf..e3c6c7d774bf 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -8,6 +8,12 @@
 
 unsigned int xfs_attr3_rmt_blocks(struct xfs_mount *mp, unsigned int attrlen);
 
+/* Number of rmt blocks needed to store the maximally sized attr value */
+static inline unsigned int xfs_attr3_max_rmt_blocks(struct xfs_mount *mp)
+{
+	return xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+}
+
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 01ceaa4efa16..be283153c254 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -223,7 +223,7 @@ xrep_bufscan_max_sectors(
 	int			max_fsbs;
 
 	/* Remote xattr values are the largest buffers that we support. */
-	max_fsbs = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+	max_fsbs = xfs_attr3_max_rmt_blocks(mp);
 
 	return XFS_FSB_TO_BB(mp, min_t(xfs_extlen_t, fsblocks, max_fsbs));
 }
@@ -806,7 +806,7 @@ xreap_bmapi_binval(
 	 * of the next hole.
 	 */
 	off = imap->br_startoff + imap->br_blockcount;
-	max_off = off + xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+	max_off = off + xfs_attr3_max_rmt_blocks(mp);
 	while (off < max_off) {
 		struct xfs_bmbt_irec	hmap;
 		int			nhmaps = 1;

