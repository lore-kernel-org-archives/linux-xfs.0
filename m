Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57ADC8C8
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7va1hQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE91C433C8;
	Mon,  1 Jan 2024 00:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067236;
	bh=fwNXTTCQo0mRencFZi6EWQxbbHH1TsZHuRGfvO3JSaU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f7va1hQdhb8JAyLA0ERadlqIhxgSi1T1f3DEvKC3FvD3If1npbWwt9deGQxXupVJY
	 +LW/kLHfLbYBwlpVZqAngfbVtEkDppkBwa4f0zrFjGnIkNW3wIT2oJ/XkiIV42cpx4
	 f/LEMoiRO6OPiDzOYQ8ihmjVST8OJghN6ozbz93B77Wo4DDQP3h5pc84NQlyZbhLqz
	 BTkag8UrJBzYcRZ6mD7GawjfcupJ1VYb/3LtbtOxSCZp63E8t9zvJ1YqDDPT3/WMPT
	 PcD1awrIzdMnwE8WrUMcafVcwhZ/2c3KZJ0S5bFLAshQ3xvnUXFT4k8GNbDJtrlbwx
	 vSZoZTIAbTx0w==
Date: Sun, 31 Dec 2023 16:00:36 +9900
Subject: [PATCH 50/52] mkfs: add headers to realtime bitmap blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012831.1811243.12201677426853572539.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

When the rtgroups feature is enabled, format rtbitmap blocks with the
appropriate block headers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c    |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c |    6 +++++-
 2 files changed, 56 insertions(+), 1 deletion(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 36df148018f..f5b7859f9a9 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -852,6 +852,50 @@ rtsummary_create(
 	mp->m_rsumip = rsumip;
 }
 
+/* Initialize block headers of rt free space files. */
+static int
+init_rtblock_headers(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		nrblocks,
+	const struct xfs_buf_ops *ops,
+	uint32_t		magic)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_rtbuf_blkinfo *hdr;
+	xfs_fileoff_t		off = 0;
+	int			error;
+
+	while (off < nrblocks) {
+		struct xfs_buf	*bp;
+		xfs_daddr_t	daddr;
+		int		nimaps = 1;
+
+		error = -libxfs_bmapi_read(ip, off, 1, &map, &nimaps, 0);
+		if (error)
+			return error;
+
+		daddr = XFS_FSB_TO_DADDR(mp, map.br_startblock);
+		error = -libxfs_buf_get(mp->m_ddev_targp, daddr,
+				XFS_FSB_TO_BB(mp, map.br_blockcount), &bp);
+		if (error)
+			return error;
+
+		bp->b_ops = ops;
+		hdr = bp->b_addr;
+		hdr->rt_magic = cpu_to_be32(magic);
+		hdr->rt_owner = cpu_to_be64(ip->i_ino);
+		hdr->rt_blkno = cpu_to_be64(daddr);
+		platform_uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
+		libxfs_buf_mark_dirty(bp);
+		libxfs_buf_relse(bp);
+
+		off = map.br_startoff + map.br_blockcount;
+	}
+
+	return 0;
+}
+
 /* Zero the realtime bitmap. */
 static void
 rtbitmap_init(
@@ -895,6 +939,13 @@ rtbitmap_init(
 	if (error)
 		fail(_("Block allocation of the realtime bitmap inode failed"),
 				error);
+
+	if (xfs_has_rtgroups(mp)) {
+		error = init_rtblock_headers(mp->m_rbmip, mp->m_sb.sb_rbmblocks,
+				&xfs_rtbitmap_buf_ops, XFS_RTBITMAP_MAGIC);
+		if (error)
+			fail(_("Initialization of rtbitmap failed"), error);
+	}
 }
 
 /* Zero the realtime summary file. */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2330ebebfae..aab1d9130b2 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -909,6 +909,7 @@ struct sb_feat_args {
 	bool	nodalign;
 	bool	nortalign;
 	bool	nrext64;
+	bool	rtgroups;		/* XFS_SB_FEAT_COMPAT_RTGROUPS */
 };
 
 struct cli_params {
@@ -3124,6 +3125,7 @@ validate_rtdev(
 	struct cli_params	*cli)
 {
 	struct libxfs_init	*xi = cli->xi;
+	unsigned int		rbmblocksize = cfg->blocksize;
 
 	if (!xi->rt.dev) {
 		if (cli->rtsize) {
@@ -3167,8 +3169,10 @@ reported by the device (%u).\n"),
 _("cannot have an rt subvolume with zero extents\n"));
 		usage();
 	}
+	if (cfg->sb_feat.rtgroups)
+		rbmblocksize -= sizeof(struct xfs_rtbuf_blkinfo);
 	cfg->rtbmblocks = (xfs_extlen_t)howmany(cfg->rtextents,
-						NBBY * cfg->blocksize);
+						NBBY * rbmblocksize);
 }
 
 static bool

