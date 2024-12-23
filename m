Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FB913FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991563; cv=none; b=Pm+FzfwAVA125jJP/1KruZhH66u3guItHDBLZkh04ZO5rK5cZ41QNPXG5ygUwp0NIg63qqM06HWzvCxfsqkk6L5eR5Uk0hyBIFp7MWoDqZjqlFZ4olEr6bDhM0OF2w8MI/GCFRA3Di/icvgmV0AWi/TS34sP4doh7hhdwMn4TWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991563; c=relaxed/simple;
	bh=HOGNMadU+0OCkTnfj3ObVaBQYXdLcCWhwkhIx1r5Z6Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t12DqFy+zuEsXfVoLo65+hxCEmbavqYMYFHq+lCudzfgVIRsbtyzexRaAK2X8TPWdO46EBLCXSFyVAgwHwjcmZ51I7f9knihdMloVzhxXDl0wFl8pxptPrRt1p9cKOK/60P+WDVN3eRGh98g9ugUgkpu0kZTRzHv5haitFe7u/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AdQuUy2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AdQuUy2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5341C4CED3;
	Mon, 23 Dec 2024 22:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991562;
	bh=HOGNMadU+0OCkTnfj3ObVaBQYXdLcCWhwkhIx1r5Z6Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AdQuUy2gD2H/OhbbyR+ptijd105bQhIADEEhlPzjFI+zq4/e7JwuiIzpZW8/z7zMy
	 rj6+xh+MEWxSuFYo2n7g+jRcNRlma7MgXIcxZG+bzkHf0Zmv7T2UZ274tQy4ur1hRJ
	 72QYxf6+Q5kmn//rr7VEcfDsLLFZqCgSNgL8b94+0KPi7RK2X7mys594LEGWJECDk9
	 rGB7mpG20rKfEZLxi0i8G/8K1GMAc34NC+rpRu0YfT+l/KSWiuVmFTY81aZkYntiqv
	 2zV+BZT0EgF4BYlF43KSdLgafQqdMg7wB8eDJOm2Saf6p4g0HmsfoLro1+o5IVEIS3
	 GjJuA7WOuofWQ==
Date: Mon, 23 Dec 2024 14:06:02 -0800
Subject: [PATCH 30/52] xfs: scrub metadir paths for rtgroup metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942954.2295836.16161894306258488061.stgit@frogsfrogsfrogs>
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

Source kernel commit: a74923333d9c3bc7cae3f8820d5e80535dca1457

Add the code we need to scan the metadata directory paths of rt group
metadata files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 50de6ad88dbe45..96f7d3c95fb4bc 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -822,9 +822,12 @@ struct xfs_scrub_vec_head {
  * path checking.
  */
 #define XFS_SCRUB_METAPATH_PROBE	(0)  /* do we have a metapath scrubber? */
+#define XFS_SCRUB_METAPATH_RTDIR	(1)  /* rtrgroups metadir */
+#define XFS_SCRUB_METAPATH_RTBITMAP	(2)  /* per-rtg bitmap */
+#define XFS_SCRUB_METAPATH_RTSUMMARY	(3)  /* per-rtg summary */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(1)
+#define XFS_SCRUB_METAPATH_NR		(4)
 
 /*
  * ioctl limits

