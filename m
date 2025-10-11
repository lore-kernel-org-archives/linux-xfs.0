Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24B742A96
	for <linux-xfs@vger.kernel.org>; Sat, 11 Oct 2025 18:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760207645; cv=none; b=SipC+v10R2M9b6ZXHLqc4r+db5q0rsWp5xoTimeHNfEkU3cxQoVvM6+5vzPixmT7hINYpp4fWHrDyyjqdb68hsBQYRo2081l2TQ684FS9S2mG2bCAgvdjMn/wybGCeJNzDjoe4R0Vx5wnmk613nxvdkJNMyWzdQ+iinaNu3QDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760207645; c=relaxed/simple;
	bh=yMxzHIPKIMGZwwfjWIB3Qj1/dscCJFUM5bVUeHMvQrA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EcZKmkjXNjBsHk5T1/9hktLiewjflVn0WcWkA97gdSi5PLupHN0zD4pi58jMO9ls8BG1E3u9v5xRwfG4LD6gSrDsIMV/1PTAAJe+zHOS4Iq6kXh3/zPUlWt1rI34ZynPGjiua6kaBkBKVPIbMHOTe9fzwFIrIHBp6EnkbQsr2Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=quHG8CyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="quHG8CyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126FEC4CEF4;
	Sat, 11 Oct 2025 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760207645;
	bh=yMxzHIPKIMGZwwfjWIB3Qj1/dscCJFUM5bVUeHMvQrA=;
	h=Date:From:To:Cc:Subject:From;
	b=quHG8CyTzou0uf414LZigrXBdhR13FopJTCKanvHyZc6MuD3VnO75Z0XAWVmt5SDM
	 7Cgc7lz3Iqt7cn1aMv8hHqcGxg/nEafueaanYqBWfCxb0jgNdKgeMDDYicWnDDcuOP
	 iMNKgibnc84mA1QSuOjKog+qENa95qYxf0L5SKKU9jsRbQOwqStuTFtFvpZI0LirE1
	 922Mi3JdXJzGcf6rQf/xL6KbjGUqCs+trAMbkZeu4DNccLHDm5DSYkjamsWCkwx4In
	 JyBxxKkFln84oFg3AbbiBXfPO/1Q5EUkEL3MSKCpuoji/oOzcVmc6pQu48e+2UAjZP
	 /EYYYgII43pcQ==
Date: Sat, 11 Oct 2025 11:34:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs: fix copy-paste error in calculate_rtgroup_geometry
Message-ID: <20251011183404.GG6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Fix this copy-paste error -- we should calculate the rt volume
concurrency either if the user gave us an explicit option, or if they
didn't but the rt volume is an SSD.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 34738ff0ee80de ("mkfs: allow sizing realtime allocation groups for concurrency")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0511f1745c47c1..bc6a28b63c24b2 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4506,7 +4506,7 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 		cfg->rgsize = cfg->rtblocks;
 		cfg->rgcount = 0;
 	} else if (cli->rtvol_concurrency > 0 ||
-		   (cli->data_concurrency == -1 && rtdev_is_solidstate(xi))) {
+		   (cli->rtvol_concurrency == -1 && rtdev_is_solidstate(xi))) {
 		calc_concurrency_rtgroup_geometry(cfg, cli, xi);
 	} else if (is_power_of_2(cfg->rtextblocks)) {
 		cfg->rgsize = calc_rgsize_extsize_power(cfg);
