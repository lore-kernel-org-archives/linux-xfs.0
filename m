Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8B7233723;
	Mon, 27 Jul 2026 05:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129812; cv=none; b=nbK3nhQmkxJfjUoOvIRXfgTY8dz43iH1KlKdXLAUoDOvSbNODVois+0BvM4vLHG7Rgmjp6iD1CAiuZ+i4ksEs5zVsZF/W1d5dFwugLM/KZev0sRSLsx/2+rE4o+qudviw3Y5riqO0o1czixCz5/9MK2G79L7FaTabGcAzUSQZtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129812; c=relaxed/simple;
	bh=7e96+SgzUcJBQEeK31acN8QmwDzDgRPPxsxmfdvM3+k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QdGQJ9LB2gKsbnTBE7rtb/KkBxLcv6U/S3sELgxSe8/U/8mmwq4ucKQBUx5AfnFM2bvJt94RRzoqiu1zNBja1SbRIm+YGE+Gio6qVDVmNSGKICW/MDM8gNylVVS1hstETDBLFVa+Kc1sOA5j4z4AD0UjToXHfkXeru9r/4c1pz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHATNrKP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHATNrKP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6CE631F000E9;
	Mon, 27 Jul 2026 05:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129811;
	bh=2EbjGaRs7zvo7wBWsPU8gyxWNJt5l2haDIp9X43zSnw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KHATNrKPcxQtq7JxT2coY/YbPX+/ikNNXhAeRQzWiYFY7tONiEIc5YD2E+GBtX90Q
	 c8P7a106y/NXF5tObBNIrpnRrFryHbGxZBDNRZ1GH5CjD3DK5lIhoh5VpfoCIpCHXV
	 SQW9wIZORFaPHAsnPCKLqvhQ4I2j1AOsPM2+TzHPkLHTBitDp+U1Pfg3P+PFOcHh/K
	 Mveu9MV1wN0+5VMkeJjb2eAt1fRsHwCLOH8OCxe9AH9AOONuaCNqrqHvwo0E9L9iCl
	 hvEhWsVC19i3OklkW4DE8PSUtsfZvw0v7svUncDYQzJV2yBf4BZNQYkhcmrp0viWrI
	 NUbMWaPRmenaA==
Date: Sun, 26 Jul 2026 22:23:31 -0700
Subject: [PATCH 3/6] xfs: don't return EFSCORRUPTED when scrubbing corrupt
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389230.1494795.12380486743423568658.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
References: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that scrub sets the CORRUPT flag when xfs_parent_from_attr
thinks it's been given a corrupt parent pointer.  This eliminates the
potential to repair the filesystem because that error code is bubbled up
the call stack.  Fix this by collapsing them all to ECANCELED in
xchk_parent_pptr, which doesn't have that trait.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 0d29a20fbdba89 ("xfs: scrub parent pointers")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/parent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index a8c4807e1d9464..99b60773b7158d 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -485,7 +485,7 @@ xchk_parent_scan_attr(
 			valuelen, &parent_ino, NULL);
 	if (error) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
-		return error;
+		return -ECANCELED;
 	}
 
 	/* No self-referential parent pointers. */

