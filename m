Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF7413FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991704; cv=none; b=WchTWIxxyKPDGU7WUA+yF4e+dVH6zfFkOpIT0ihRW0yeeT3mS6ONSWRJ/Y8icHeQSifX1MT15eNZWbCpIpYDBdYUbY84qKVtbGfg/bsWcgoJoyi6VSErHMW9aEa405+Makhfhj7L6PCQt80eR7NsfhkewTYm/d905+uMGhGF+SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991704; c=relaxed/simple;
	bh=XIsbQYlZ5NMAXIDveOO6uxLjfpXf5sompTCTutu4oSw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SjKXzt2JYJG0gxciIgja5iGiCZwmCIfoE5fiwqxhtLObxZi5twpqCuHC2dq09rQ6ej40JzAKsMxLXEcgC5JOx5fugMFJkMVy4kItzQiVJW0amvn+9uPHZo29LoutDQ7bdZp/CYuaEaR688JVOqETGA2MROFMQIiE4twqkCSarkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQaiV49N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQaiV49N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEECC4CED3;
	Mon, 23 Dec 2024 22:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991703;
	bh=XIsbQYlZ5NMAXIDveOO6uxLjfpXf5sompTCTutu4oSw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oQaiV49NDB6+5GI6yEGt3hP3bNwt28N/N1rT9rMl8iN3iFURbSPGxVL0Votrb1grk
	 jnGv4yx4vNReO3Fk/LqXpv/y4EixCl55b742SelFgYgoEuuQcOoOhDYZRpMyJ0C7Ei
	 ee4vehpNwApfkGH0xznC2ovly0CkctZHgeMQqO/4wkC+SSxNKmLUhjLlFSCdWnW8R0
	 UMAWIx3oMxmEQzKf8Re1ZkGnxXnb+JbyqKzlnuIQ6hsDMeXEckCmOZvgVVmwIHUoct
	 cqS/8lt6cMCGvyiGlXvHmHMGAzPLXxWtHLbc8vZgM3hlxZVaKSD5ugeFp38d9Lj5qe
	 rVONtLpV8Jxtw==
Date: Mon, 23 Dec 2024 14:08:23 -0800
Subject: [PATCH 39/52] xfs: scrub quota file metapaths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943092.2295836.14920254197760366184.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 128a055291ebbc156e219b83d03dc5e63e71d7ce

Enable online fsck for quota file metadata directory paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 96f7d3c95fb4bc..41ce4d3d650ec7 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -825,9 +825,13 @@ struct xfs_scrub_vec_head {
 #define XFS_SCRUB_METAPATH_RTDIR	(1)  /* rtrgroups metadir */
 #define XFS_SCRUB_METAPATH_RTBITMAP	(2)  /* per-rtg bitmap */
 #define XFS_SCRUB_METAPATH_RTSUMMARY	(3)  /* per-rtg summary */
+#define XFS_SCRUB_METAPATH_QUOTADIR	(4)  /* quota metadir */
+#define XFS_SCRUB_METAPATH_USRQUOTA	(5)  /* user quota */
+#define XFS_SCRUB_METAPATH_GRPQUOTA	(6)  /* group quota */
+#define XFS_SCRUB_METAPATH_PRJQUOTA	(7)  /* project quota */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(4)
+#define XFS_SCRUB_METAPATH_NR		(8)
 
 /*
  * ioctl limits

