Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165A2137C2A
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440912; cv=none; b=OiutO565eZJ/YvlnbQhEpBhjhTnkyApwvo5ZUt5zNjpRf6pbf5KhotZ/JoAPIHM/noA9GVIrAgmwoE86+UNXWEHuT3NdhUp/710vOk30P2gQsq/pn+ExVR2yEys9976L+CApIiKr81vxVJklmDUlIWBO9eM0p83LJ0S+xVx60sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440912; c=relaxed/simple;
	bh=gsSFgLFFBB63zDqqft1+TJrUG5WvFXWSrrywxF6ESCQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pVywe1THb6WWEtx0+1xO5NWyrnBUK+watCK710LhvbhebI8JDHvc/X74e6cyxvgeBsbxJlh08OEEGJFUckclBjIqyOKD62v6TUTZliJ3CN98Ts/F+atshIVM3FxH7l0w1uv44mCnCXn0j4J9yEONWwW/pEzi+QrMtyNFx1yaFq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyuQpTLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyuQpTLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FB8C2BD10;
	Mon,  3 Jun 2024 18:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440911;
	bh=gsSFgLFFBB63zDqqft1+TJrUG5WvFXWSrrywxF6ESCQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SyuQpTLIWUvMlvZjf1aAKchIq/hdP18fHRD2I8Ym5vDeepfa+DXrqTT3t6l2JCIrx
	 7ebOrNAHDjiHc2o2waw62pshyc+R+omQvIkKz5voWoJjbBelEmDqxUdJdDjvx9wCbT
	 d8TwNRD1BvMz9FpBUOjEKDiakQoFu0IcdIEx8GUkcPHXxjggPXPYzHZrzZDeVtMC4L
	 f7EzStoGRhNFbJ5G79fOV46lKN+/p+ozBX30DtbRmD978X4MJU9MQEiMV9gUahM2Yj
	 RsAHfUpE3L3kQRvFEoODANF+XJWUOISvEByfmGQRfrhSlwcyMNgtTlj3yP+jMw6k5O
	 +5UIWTxUSRReg==
Date: Mon, 03 Jun 2024 11:55:11 -0700
Subject: [PATCH 012/111] xfs: report the health of quota counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039547.1443973.10881144163395951275.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3d8f1426977f1bf10f867bcd26df6518ae6c2b2c

Report the health of quota counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_health.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 636007386..711e0fc7e 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -195,6 +195,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
+#define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 6296993ff..5626e53b3 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -41,6 +41,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_UQUOTA	(1 << 1)  /* user quota */
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
+#define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -77,7 +78,8 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
-				 XFS_SICK_FS_PQUOTA)
+				 XFS_SICK_FS_PQUOTA | \
+				 XFS_SICK_FS_QUOTACHECK)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)

