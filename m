Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAC53403FC
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022410; cv=none; b=HySbttLf065MqvOQ3TbxbAA/o5ePd8wnLlxROTcRERAhOof1v8cy/dSmYPVjWL5NBh3DojvY4GZGWrRWgm2WAZ/X4vF80wnAlXDQqYIN7oh7V3qxa/DI+g456VXXFI6/yaGae/Dl+5JlDcOuPr0bD9U8kC71W3Apl8f6gdzfSfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022410; c=relaxed/simple;
	bh=MxljdRoDaCdZR2euKhDTSE0Tda2ikt0Tvs1E/UdMbVE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMyLXneiVGn6npl9+OO1+8ohatzApB/7ZZyfOngQSOAADQERWAl0/WkoKvqQvglIUlPAKxcHNJjHIoMacNbUrt2BEE3SiJHmF/SYX/q9MA1jFs4jLUIU7mREmCf+712cwRdHnvtCwMaRx3hHpZdG9gaRUPpkOTX/FJJPudzS2Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mRDPq1DS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRDPq1DS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 32E9A1F000E9;
	Thu,  2 Jul 2026 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022406;
	bh=LjklTrq2aueo7eB/GRVdAHlduZG0mzEB4q1AjxAHvtY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mRDPq1DS19LLBa2hhBYmU2gHX8fnbytUkQzhplX3Qtly76U7kyouH3H+bq4uWh6HO
	 h2sbilBgft2Ug57b1X35Ff7kbBA3XLRSZmEcM3C4bxhIaijUqicwxfNIttcDiZNmTp
	 WmyqZsupMUsfTx2XG/S0e9oJpHhjOMeJqIdiLt/7bYh7dupgas7qrluC1nqZxGMJL9
	 eLmq6C3pYVwng4dFjrlhWbIZGfgFrTlv9dn0KJbn4utHfOz/hRyJfGLNqv0Lo3r78J
	 w/MVV0uQIt5JuLz0luc5S6VL4SFqiMUlK6OHzEJrSzab3UdALoipSB3aWsOI/dWp/L
	 k90eLSwsiTIRg==
Date: Thu, 02 Jul 2026 13:00:05 -0700
Subject: [PATCH 4/5] xfs: zero entire directory data block header region at
 init
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, dgc@kernel.org, ytohnuki@amazon.com,
 linux-xfs@vger.kernel.org
Message-ID: <178302225979.845293.8879106622693689772.stgit@frogsfrogsfrogs>
In-Reply-To: <178302225882.845293.16022494313921827307.stgit@frogsfrogsfrogs>
References: <178302225882.845293.16022494313921827307.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Yuto Ohnuki <ytohnuki@amazon.com>

Source kernel commit: 00dd8d7ec5253c6273023a0fd6dc08683e0bdfef

xfs_dir3_data_init currently zeroes only the xfs_dir3_blk_hdr portion of
the directory data block header, then manually initializes the bestfree
entries in a loop. This leaves the pad field in xfs_dir3_data_hdr
uninitialized and requires explicit zeroing of each bestfree slot.

Zero the entire header region (geo->data_entry_offset bytes)
unconditionally before setting individual fields. This covers all
current and future header fields, all padding (implicit and explicit),
and the bestfree array, so the manual zeroing loop for bestfree can be
removed.

Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_dir2_data.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 1fb43cdfdd6d04..fb5e4b021217a5 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -725,7 +725,6 @@ xfs_dir3_data_init(
 	struct xfs_dir2_data_unused	*dup;
 	struct xfs_dir2_data_free 	*bf;
 	int				error;
-	int				i;
 
 	/*
 	 * Get the buffer set up for the block.
@@ -738,13 +737,16 @@ xfs_dir3_data_init(
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_DATA_BUF);
 
 	/*
-	 * Initialize the header.
+	 * Initialize the whole directory header region to zero
+	 * so that all padding, bestfree entries, and any
+	 * future header fields are clean.
 	 */
 	hdr = bp->b_addr;
+	memset(hdr, 0, geo->data_entry_offset);
+
 	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
-		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		hdr3->owner = cpu_to_be64(args->owner);
@@ -756,10 +758,6 @@ xfs_dir3_data_init(
 	bf = xfs_dir2_data_bestfree_p(mp, hdr);
 	bf[0].offset = cpu_to_be16(geo->data_entry_offset);
 	bf[0].length = cpu_to_be16(geo->blksize - geo->data_entry_offset);
-	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
-		bf[i].length = 0;
-		bf[i].offset = 0;
-	}
 
 	/*
 	 * Set up an unused entry for the block's body.

