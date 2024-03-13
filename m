Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0A3F9D9
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295957; cv=none; b=hRCp1goYnwXAjyOzm7uY5N5t/H5WWMyBKk+rO8FpDxnUgtB5uUjeVEpybJTzlBruVA7B6DAuWDqyCT7szJx4+SZzpu4MYQgpMRoAf10hzm8jQzMFZ/Xp805ckOzEWhttlaiRb1DsXfWqDdJEJ03jjHeOKwIk4hnuHj49licRX2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295957; c=relaxed/simple;
	bh=dCGvG7vZXDIQZtH5WItLVuOfiq+bgjXs5VwULaZc+EY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kCgOx2z25zuysF93X7fbpRT8n3X4SVckRflrbrcdBpc3KVFi2WHSbmGpqC70ikRaDAq87tuNtddzjqd5CvlqGYwxOaPjmQH6pyC+CWLzIsI75m6t4Ennlve4n75gV1d5qHoOMrbHn9YvwvMnRjzOMF6BvNFhiBfiz5ne/zb1TlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6o/YJ4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6o/YJ4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE019C433F1;
	Wed, 13 Mar 2024 02:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295955;
	bh=dCGvG7vZXDIQZtH5WItLVuOfiq+bgjXs5VwULaZc+EY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n6o/YJ4hfQ1s7f2bW+HKayqjAx3mqal2N5fGjS1ZGInTobpS9yFbJOOvlCnE1yWfm
	 N1DpYUugn7F5Da+xMMxpKxdVWJ9LR4tfDwHJg4GAksdiEhDi3AooX57R9GrztAVKDy
	 mBXKvJ7KUJUUVRDiGVqO23WTNdn0cGOVeAqDzQ4wxEgLxKeB8M+sbmIks7/If01vRO
	 koMqfO1k3gIPr4qaNhqLq5+ITVYNSWe9FvBZsD9+E7hpKHmoavdkfEP7oWiWtUoh5A
	 8+oIBygxroRhy93POLKm4gd3/C4pXzXWxwuj1u55i3IUbjeV0ukkcsfazO4C2POAip
	 S67qXtEwPKd7g==
Date: Tue, 12 Mar 2024 19:12:35 -0700
Subject: [PATCH 5/5] mkfs: use a sensible log sector size default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433287.2063634.15497714444883500861.stgit@frogsfrogsfrogs>
In-Reply-To: <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
References: <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Currently the XFS log sector size defaults to the 512 bytes unless
explicitly overriden.  Default to the device logical block size queried
by get_topology instead.  If that is also 512 nothing changes, and if
the device logical block size is larger this prevents a mkfs failure
because the libxfs buffer cache blows up and as we obviously can't
use a smaller than hardware supported sector size.  This fixes xfs/157
with a 4k block size device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 79d6eaa37a1a..18084b1cc6d1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2075,7 +2075,8 @@ static void
 validate_log_sectorsize(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct mkfs_default_params *dft)
+	struct mkfs_default_params *dft,
+	struct fs_topology	*ft)
 {
 
 	if (cli->loginternal && cli->lsectorsize &&
@@ -2090,7 +2091,7 @@ _("Can't change sector size on internal log!\n"));
 	else if (cli->loginternal)
 		cfg->lsectorsize = cfg->sectorsize;
 	else
-		cfg->lsectorsize = dft->sectorsize;
+		cfg->lsectorsize = ft->log.logical_sector_size;
 	cfg->lsectorlog = libxfs_highbit32(cfg->lsectorsize);
 
 	if (cfg->lsectorsize < XFS_MIN_SECTORSIZE ||
@@ -4206,7 +4207,7 @@ main(
 	blocksize = cfg.blocksize;
 	sectorsize = cfg.sectorsize;
 
-	validate_log_sectorsize(&cfg, &cli, &dft);
+	validate_log_sectorsize(&cfg, &cli, &dft, &ft);
 	validate_sb_features(&cfg, &cli);
 
 	/*

