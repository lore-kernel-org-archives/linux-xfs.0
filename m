Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E9BA951
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294986; cv=none; b=KUuSZBNlhFWFS0RQ0fv/AZBgVQJ7DAb53rym63zsgKe4sAzPVzMOT1Mb3qGDCk15ORCCk9XDl588C+8SK5HxbDeN0Fty+CrRw7Rv1hhDgczsfgNZr0SXsGC7qgWsETEyGqorp+jMrmWI/T+W55gTk252KRCBfGPTVumqWvzeENU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294986; c=relaxed/simple;
	bh=j7UrZa465552QqaDf/RE5Srf5uO1u55tvH34Dph8SVA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P+omlV9Gle+Je8cnWjpPhGIY49isi0Q5CakDujuTTzxac6BVpY2P7u/nw8Mu44VNEmRMSecd6dNg2pO/EH6kQ8TzIeUXpbamUpb4ZETD47+B+fMxe3w2OXdyZ+QE8222LAd/5CGRxz0LsSbnzXbI3vlLNT6OKYUHZrkCtw4Ic44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKPcAWMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKPcAWMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50238C433C7;
	Wed, 13 Mar 2024 01:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294986;
	bh=j7UrZa465552QqaDf/RE5Srf5uO1u55tvH34Dph8SVA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iKPcAWMyLGE/yq6/JkSWaIJBDZJXt3GoIRCNMavicHgKYUnRvMwaa319LDNyR7qZs
	 HDGbvrNvFQTRT3Cx2PKmg4tkdRIWArrSlT0b4yX4OMHi88FFLvysZBweKLX/gVijkk
	 cRrfICI80+Dx3a1Cq91on3qns3VANiMDrfTYvcpBfZ3UslCU4rGRNSszhspbukn6Vm
	 svdkQicGhJB+zgGGa0QgtG8QKjBs8rVFtps9GHHCORmYC49+6RyDJxhPO6aMrCC4xt
	 3PItsv1d3HMhZvTCPWULOEm0bUw9kyMP7brHg+A6Ig81tW31qEuDYyURvkquxgKYmq
	 jXlAhiR0P4BRg==
Date: Tue, 12 Mar 2024 18:56:25 -0700
Subject: [PATCH 13/67] xfs: don't allow overly small or large realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431381.2061787.16982684933003745809.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: e14293803f4e84eb23a417b462b56251033b5a66

Don't allow realtime volumes that are less than one rt extent long.
This has been broken across 4 LTS kernels with nobody noticing, so let's
just disable it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.h |   13 +++++++++++++
 libxfs/xfs_sb.c       |    3 ++-
 mkfs/xfs_mkfs.c       |    5 +++++
 repair/sb.c           |    3 +++
 4 files changed, 23 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 6e5bae324cc3..1c84b52de3d4 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -353,6 +353,18 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
+/* Do we support an rt volume having this number of rtextents? */
+static inline bool
+xfs_validate_rtextents(
+	xfs_rtbxlen_t		rtextents)
+{
+	/* No runt rt volumes */
+	if (rtextents == 0)
+		return false;
+
+	return true;
+}
+
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
@@ -372,6 +384,7 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 # define xfs_compute_rextslog(rtx)			(0)
+# define xfs_validate_rtextents(rtx)			(false)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 {
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 95a29bf1ffcf..7a72d5a17910 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -507,7 +507,8 @@ xfs_validate_sb_common(
 		rbmblocks = howmany_64(sbp->sb_rextents,
 				       NBBY * sbp->sb_blocksize);
 
-		if (sbp->sb_rextents != rexts ||
+		if (!xfs_validate_rtextents(rexts) ||
+		    sbp->sb_rextents != rexts ||
 		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index abea61943652..1a0a71dbec78 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3025,6 +3025,11 @@ reported by the device (%u).\n"),
 	}
 
 	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
+	if (cfg->rtextents == 0) {
+		fprintf(stderr,
+_("cannot have an rt subvolume with zero extents\n"));
+		usage();
+	}
 	cfg->rtbmblocks = (xfs_extlen_t)howmany(cfg->rtextents,
 						NBBY * cfg->blocksize);
 }
diff --git a/repair/sb.c b/repair/sb.c
index 384840db1cec..faf79d9d0835 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -475,6 +475,9 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		if (sb->sb_rblocks / sb->sb_rextsize != sb->sb_rextents)
 			return(XR_BAD_RT_GEO_DATA);
 
+		if (sb->sb_rextents == 0)
+			return XR_BAD_RT_GEO_DATA;
+
 		if (sb->sb_rextslog != libxfs_compute_rextslog(sb->sb_rextents))
 			return(XR_BAD_RT_GEO_DATA);
 

