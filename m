Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADBB2DC79F
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291826; cv=none; b=sfG2xDGW9NasAmXDbasEzeEYJttFHAdfRxyHD7UZpr4hglv8T5s+KPauPWeztkNB71Tl5fwI2rTMTxGVPPMhMXzaAJ+dcr8A+RBpEkiaMwH2XjPt0Yw5JeC3RhxncAiQgRx15AQafY2SoxlcdcsOoHxIqVQiQ+TK3UL+f8cBYME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291826; c=relaxed/simple;
	bh=gyB8kZutyKgVGPgZdwgABJLVO35YvjFDy87cRyJ+iyE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f2dDYWJC6nAzqBw1CN30ToB5yz325VbrPwIEPoGoECY15gQJQYwJiLfO1UQ/E2pEUaw0AcH9yWdChAfVa/EdbhOx+MGPj6EdD/3jggExD/ErYXrzb5ihwQFk573GjlCpwVd6uYr+Sd0qvq9dDmxX5zyNuF71oGJdi0a6epPAwGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pgcmDylD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pgcmDylD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFEBC2BC87;
	Mon, 23 Mar 2026 18:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291826;
	bh=gyB8kZutyKgVGPgZdwgABJLVO35YvjFDy87cRyJ+iyE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pgcmDylD6I3zF3z93JnuzA6epO8j8ZjuiYA6XfbnD0pMGeugW5SG7VOUa6yPrBQL4
	 4ylWo/V2f9HRk5sIRvYbQ+MGr9rUmPeZqe9/e+trzva04OzpWOQkShSM8uA/pBqkZX
	 JaiUtTshDvTOIHsv+RaPw97dh+VBOqvgEqFlQdzvd6NRabyxJmO8nKaF2yWsfM4GSB
	 lbx4HDkSFTIz0iBMXW00g3Wwae4eMTwlF3m8YP0WwzfuIY2RfNAEzD3ggBiLZunxdG
	 T0BOH18KZcfMHbiGt9q3k82oS8R5SMtHK8vCDGR5vkuzwlizMzR4xAkpoXaH3+sCTh
	 Cd4R7wShugGUg==
Date: Mon, 23 Mar 2026 11:50:26 -0700
Subject: [PATCH 35/40] xfs: remove metafile inodes from the active inode stat
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429121384.2266274.6338753391178160065.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 47553dd60b1da88df2354f841a4f71dd4de6478a

The active inode (or active vnode until recently) stat can get much larger
than expected on file systems with a lot of metafile inodes like zoned
file systems on SMR hard disks with 10.000s of rtg rmap inodes.

Remove all metafile inodes from the active counter to make it more useful
to track actual workloads and add a separate counter for active metafile
inodes.

This fixes xfs/177 on SMR hard drives.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_inode_buf.c |    4 ++++
 libxfs/xfs_metafile.c  |    5 +++++
 2 files changed, 9 insertions(+)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 0802bc376073d8..f56aef0dbb3db9 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -265,6 +265,10 @@ xfs_inode_from_disk(
 	}
 	if (xfs_is_reflink_inode(ip))
 		xfs_ifork_init_cow(ip);
+	if (xfs_is_metadir_inode(ip)) {
+		XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
+		XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
+	}
 	return 0;
 
 out_destroy_data_fork:
diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 8d98989349d086..bab5d7e29ae9a7 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -59,6 +59,9 @@ xfs_metafile_set_iflag(
 	ip->i_diflags2 |= XFS_DIFLAG2_METADATA;
 	ip->i_metatype = metafile_type;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
+	XFS_STATS_INC(ip->i_mount, xs_inodes_meta);
 }
 
 /* Clear the metadata directory inode flag. */
@@ -72,6 +75,8 @@ xfs_metafile_clear_iflag(
 
 	ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	XFS_STATS_INC(ip->i_mount, xs_inodes_active);
+	XFS_STATS_DEC(ip->i_mount, xs_inodes_meta);
 }
 
 /*

