Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FAA305692;
	Mon,  5 Oct 2026 05:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179891; cv=none; b=EtdzCOMAq7bsRHcbaxYgEIUZEGI2sRyDVlyBtc77V8Cr7QlXzHvXhd3D3gldjfI2Sa596m3SwW/ZQMRzRd1zmxVfJeqsV9zhNJo4Z/6hJxdqOYWoCEmo06wTJUy5nmA2V7KpeVkD/EfhdKSbuQ+6kHhjgNuzaUIAuISuZjgC3K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179891; c=relaxed/simple;
	bh=w9rzrOoIrlsabzvuKuYAQV5sWTbyWjg6siD2V8cL89E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSuResu/nLPymPS4eBt3/fybNoL3f2+4W0CYJxboAfRwCJpW0ityk/3MI8zvp/W+NkUPYQlTWwyTp0EhvJdmc+ycmTxK1PDwLbAceromIC4YU7xWsWXJvfvAuWQjSk9IqMEmLQwiFcX9FcXZutBXGjZceEZYHHqXjV3BL7LbRvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LZvmxvLe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZvmxvLe"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DC2711F000FF;
	Mon,  5 Oct 2026 05:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179890;
	bh=rIeYmPvPZKA4O5/3pqdU8+gkKnK+2yxmONdwITQ8g1A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LZvmxvLeu1qYYbJYKkkKU8xnTD3AAvKqDQuXPzmGWlZjb4mD7SmviV2d2zDbw0r3m
	 RChmvKQaHf/Vt0B8c3B1mFndI2mqPsi929raR1bZcVoVXg63ECoyzTy9ZuAaoQlAHq
	 cWovHpeHsXWsIrpScPF6WYVZM8lWh+tG06coyz2rRr2dn1O2PjHZdCXLhkadigTGjX
	 vHQbCmAnbxYV2Xj4I/MY1sQugIfYVInCyL39hulg+OdoEnVlSl6rcy2L0qEeyw3xu4
	 VC6RHqHN99woNVhlOBNg4NZjiYCT4XMVS3bKxQrDrmpu7UgTBONT2ZUHY2XDUvZ6xd
	 4/AyrsyxphV+g==
Date: Sun, 04 Oct 2026 22:58:09 -0700
Subject: [PATCH 11/12] xfs: always zero the whole shortform header when
 zeroing attr fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965245.614350.13479239208521625776.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_xattr_fork_remove can decide to reset the attr
fork contents to an empty shortform header, but then fails to zero the
padding byte in the header.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: e47dcf113ae348 ("xfs: repair extended attributes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/attr_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 98a74066b24000..4a6124b592b525 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -970,7 +970,7 @@ xrep_xattr_fork_remove(
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
 		hdr = xfs_idata_realloc(ip, (int)sizeof(*hdr) - ifp->if_bytes,
 				XFS_ATTR_FORK);
-		hdr->count = 0;
+		memset(hdr, 0, sizeof(*hdr));
 		hdr->totsize = cpu_to_be16(sizeof(*hdr));
 		xfs_trans_log_inode(sc->tp, ip,
 				XFS_ILOG_CORE | XFS_ILOG_ADATA);

