Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C484317165
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291733; cv=none; b=th0T+tsbnTrCXl17g8mR0cWhXVb1kMawbnD2o+n0OM3QbwLcI5ie+MHt9AVoSlqbuE3rw+4DapDyy/z7bI8lPoUmVU7XP6IT5/1s1RRnv9Uud56eU8Y6KCTb9gU+gtH9oVAMynUSyI+rf1AtIxQkMe0IxerGSLwLB0YzgXlQyiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291733; c=relaxed/simple;
	bh=QZ2wH1Um2G7tYr/e4sJfasK3kgzrplTRpSQShK6xqq8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzY+wCSs0LRX4orIOQBXmgqnuByO2/pUzaSImkqMOqneQBaGavFr3h9qNZ7vTB+/PE2FXzuF2N9yQMWxicFuTbJJwqcGmZQyYc9tODx84pZHBM8f6tAgXnbqXd3lMsuflrgFcMoaVupIA9bofhR6ogis6uMdF+efI4bWh3YT1sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0AdgBJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0AdgBJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B023AC4CEF7;
	Mon, 23 Mar 2026 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291732;
	bh=QZ2wH1Um2G7tYr/e4sJfasK3kgzrplTRpSQShK6xqq8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G0AdgBJ98NbQXj1JS8locm7ewA5XL3vHw5AmZiJPybcbqCjOxc1z/3Wmud3WZu0Fy
	 A2Ue8aPnXt0csqt7HcyrDZIxXOqyfQR+tfq60P+Kmy6NcIEsiPAWtl7ibOAJ1S4LTT
	 S8BfVWo97GCwny08vK4i3I/PJ9tohbTPMD+1IFVhcOK2kUjNCtLSmRmCx9Ioy44zu4
	 MmStuOy5f9+J2e67itLyi6xDh3/RCla+9wfgA8dR5+1DWnlxqzF7i0ubYlvY07YNUT
	 8/RPu3H30HXd2eAGaAh/k3TSzj2f1VIN7dd7P4V9xECEgxoS8vAOf7QH9ywSX/Y4wD
	 urJyBduw/YMuA==
Date: Mon, 23 Mar 2026 11:48:52 -0700
Subject: [PATCH 29/40] xfs: add zone reset error injection
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hans.holmberg@wdc.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177429121273.2266274.9047124383772422019.stgit@frogsfrogsfrogs>
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

Source kernel commit: 41374ae69ec3a910950d3888f444f80678c6f308

Add a new errortag to test that zone reset errors are handled correctly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_errortag.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index b7d98471684bf1..6de207fed2d892 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -74,7 +74,8 @@
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
 #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
-#define XFS_ERRTAG_MAX					47
+#define XFS_ERRTAG_ZONE_RESET				47
+#define XFS_ERRTAG_MAX					48
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -135,7 +136,8 @@ XFS_ERRTAG(WB_DELAY_MS,		wb_delay_ms,		3000) \
 XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
 XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
 XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
-XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4)
+XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
+XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
 #endif /* XFS_ERRTAG */
 
 #endif /* __XFS_ERRORTAG_H_ */

