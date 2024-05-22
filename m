Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304D42C9D
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347958; cv=none; b=mlwGHxNsjlliRj5u4HZslbwE9vBm4KApfXeTgaxYReVYWkkNGrZG+vWh+ea1ZHooPpOaW/iS7rpPLl7B2MRu+oa2930dem2PMED4KCCuUeGS+WMfzIrKvNrSZRKGyMORFPcieGvUzcl3iZCir4s4UpXI6uEodmTlTrgWu7xWpbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347958; c=relaxed/simple;
	bh=X/B8CnADYTTgPQpFIxU/xFO+czmbCSbGODZZemcUvBg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Erhuv8ZLYKgVzn1t8kepMWIdFmGTGfP9AyY54Bgmc0ZAToiKuJwE84K++gQmJi+oymtexPDCrtHHCIFIILeOufpgir0CVHnGL+aikupCZIDBicuqoGsciIgNyN03kpQQVdneVXUbjKaXgEYL42Eniyu9HifjkACzdJKtOJEVARw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9nHFpoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9nHFpoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F06C2BD11;
	Wed, 22 May 2024 03:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347958;
	bh=X/B8CnADYTTgPQpFIxU/xFO+czmbCSbGODZZemcUvBg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q9nHFpoHuI43LbR6/rRdqaxVxK/Kem/36J9ryue4KeVlSTsRxLywaycGcbGNmTTbl
	 hNheXKVffY13iFAWkiuUoOzyEPSRUxWkrPs0I5iBLCgPNQdcGk8fw0xKrcmayAvh3X
	 XXfVdM2JwbxpZhW0CUgRdkCsb1Xk7Ol3GaSF7BYvgAyea+Dqy2alm1JhTJxbj+woNT
	 TC32tzXy7YC4kheuUa4THA3FsFUPWLVPXzByIIAwdNLym2OwoNj5IHbMJ/iQcoT7zo
	 M0cKXUrozlaFGsqzvfJ2X1qrC+sej0GCr9tHis2tAf6ewQQ0QR5CTbDbG42C2j3AV+
	 Kh0Ttzhg4Ty/Q==
Date: Tue, 21 May 2024 20:19:17 -0700
Subject: [PATCH 1/2] xfs_spaceman: report the health of quota counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534405.2482833.6391980051868485997.stgit@frogsfrogsfrogs>
In-Reply-To: <171634534389.2482833.12547453553760834310.stgit@frogsfrogsfrogs>
References: <171634534389.2482833.12547453553760834310.stgit@frogsfrogsfrogs>
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

Report the health of quota counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 spaceman/health.c               |    4 ++++
 2 files changed, 7 insertions(+)


diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 6b7c83da7..f59a6e8a6 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -256,6 +256,9 @@ Free space bitmap for the realtime device.
 .TP
 .B XFS_FSOP_GEOM_SICK_RT_SUMMARY
 Free space summary for the realtime device.
+.TP
+.B XFS_FSOP_GEOM_SICK_QUOTACHECK
+Quota resource usage counters.
 .RE
 
 .SH RETURN VALUE
diff --git a/spaceman/health.c b/spaceman/health.c
index d83c5ccd9..3318f9d1a 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -72,6 +72,10 @@ static const struct flag_map fs_flags[] = {
 		.descr = "realtime summary",
 		.has_fn = has_realtime,
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
+		.descr = "quota counts",
+	},
 	{0},
 };
 

