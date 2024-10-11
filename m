Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281CBE49
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609672; cv=none; b=et+EhM61rmXQk5L7aA/df1SmcmhxXgXWB73Q2EKnJZfgXT3g++mNGTy2pTRJUoXo0C5tRfmTTMQoBOmqTscODr1thFATnEMiHDuwUZ/P5XELz1IdWiBxpwb1laZnbxPUk4eCPp5gYnL/EWEgQ8NCf9hEJH3g3GvmPxCs5sdy8lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609672; c=relaxed/simple;
	bh=j1QukefmX7EWU4hjdyK5tnDCAmFk4WrP3L8HvQcRy+M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GBKzBFt/GYa6dn6ZZmaWclRFr1hODt58KY6E68SRSymigFYp8xV4uGx0+qwe/iLKzbGytw22eW4PIGV0qtQRR9tW4IH0xtIEAeww0XRteHXgmty7l83bOrC/2OfMmdf36jzpScb+F26EBHBRw5Xaea82r4hdUFB3aqAZRkd6e60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGNaPcNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGNaPcNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D64EC4CEC5;
	Fri, 11 Oct 2024 01:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609672;
	bh=j1QukefmX7EWU4hjdyK5tnDCAmFk4WrP3L8HvQcRy+M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WGNaPcNiRZ3FmEdv+XbVDTouJbdcSyqq+aGUQ4cZaNsc2J008XlSRKN7+6jCD/Clf
	 YgPTVc4pgGLEBEQRGGmSiugbOdRW0zZ2V0Iwb/FhCbfYCh5PkYyYSRMAcWarwC5tII
	 H8avtAmLXaYIFSvkVey3cKgVLaxie6/WwsloW3G2tEczYZfTg6gAJOF+J6ciQROXtt
	 QtuX6V/U6g9Sld1s05BF+YB+P0w4UpiHlyiLEHMkh3sY5fR19liI71fSY+lwDmYLLu
	 A6T5Qycuzd/BpuK28TXXUONYSY0wedYPQerk8IwcB0MXSa3WBsaHndYyc42WWF498b
	 Ab0C5dqIEonBw==
Date: Thu, 10 Oct 2024 18:21:11 -0700
Subject: [PATCH 27/38] xfs_repair: update incore metadata state whenever we
 create new files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654391.4183231.9131794852952841836.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Make sure that we update our incore metadata inode bookkeepping whenever
we create new metadata files.  There will be many more of these later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index f2358bde194e38..dd17e8a60d05a3 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -474,6 +474,24 @@ reset_sbroot_ino(
 	libxfs_inode_init(tp, &args, ip);
 }
 
+/*
+ * Mark a newly allocated inode as metadata in the incore bitmap.  Callers
+ * must have already called mark_ino_inuse to ensure there is an incore record.
+ */
+static void
+mark_ino_metadata(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct ino_tree_node	*irec;
+	int			ino_offset;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+	ino_offset = get_inode_offset(mp, ino, irec);
+	set_inode_is_meta(irec, ino_offset);
+}
+
 /* Load a realtime freespace metadata inode from disk and reset it. */
 static int
 ensure_rtino(
@@ -693,6 +711,7 @@ mk_metadir(
 
 	libxfs_trans_ijoin(tp, mp->m_metadirip, 0);
 	libxfs_metafile_set_iflag(tp, mp->m_metadirip, XFS_METAFILE_DIR);
+	mark_ino_metadata(mp, mp->m_metadirip->i_ino);
 
 	error = -libxfs_trans_commit(tp);
 	if (error)

