Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325E619ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527973; cv=none; b=cUN5HVjS04GBLHvFVEJtmEjNUsTG2JKwK4iN3Inb047u02z8LIuNueLhezmVRLpMWcmBI4qbBsMXDUzbtubWuFs5ydxtav1RVGA+KvMesHAJb1XsD2P9Ec0FBV/FP50zdM4WdmxbqfmWVUexVsRenH/+QueBzIyfVA0AcPSp/mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527973; c=relaxed/simple;
	bh=8T4uZ7gG3nMLVdc9LmI9tmDtQNJDJE1GMr6WjWuYkUc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LqwiiPg0axypR7PiD01p/HEazrmABXWsWgqDk446ql317LfBMvCmugaKCks206kzX4oztgPNoMqDBvCxInop4MD7S3lx8JQ4s38SlNfahBj4Gz2gOuBUXVavuiahdNnZB+nYWIZmvOONPVg8X9EMuhgkW0BYyvF8WHxamBGi1Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8TyMfpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8TyMfpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C359C4CED1;
	Fri,  6 Dec 2024 23:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527973;
	bh=8T4uZ7gG3nMLVdc9LmI9tmDtQNJDJE1GMr6WjWuYkUc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q8TyMfpq1gMhP92kT/DhP+NcFzX2K8zMaNHvkYIOiS8GZXmIH808Q8mZUmxzOomDQ
	 3SEiyfJ7KkRYOnrWYqofeD5bzb/WN2tqSxmL4a1GsIj3NW+i3bakb0B82PGX6LkCqr
	 ODixVgul64PqhJUGcQkY0lfIrtFumR6VifQ6vXM+YBNBGZeM0TWZhbOqvAhQdgTuoY
	 HgKZQt5B8hyEUifwGKpXysdxA7lecDNs6oatdmiqpSV/xuFu5ALxWMxreXCpBd/YVW
	 F7phUlnQdMrQBtkU13R91dtbfx2xbjfX22FwC3YQnltdHpszrpb+EuBS3gUKC1HeTQ
	 BHL1Cs1kXxvkA==
Date: Fri, 06 Dec 2024 15:32:52 -0800
Subject: [PATCH 10/36] xfs: pass a perag structure to the
 xfs_ag_resv_init_error trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747035.121772.10444497231852416605.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 835ddb592fab75ed96828ee3f12ea44496882d6b

And remove the single instance class indirection for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag_resv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 7e5cbe0cb6afd3..d1657d6c636546 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -205,8 +205,7 @@ __xfs_ag_resv_init(
 	else
 		error = xfs_dec_fdblocks(mp, hidden_space, true);
 	if (error) {
-		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
-				error, _RET_IP_);
+		trace_xfs_ag_resv_init_error(pag, error, _RET_IP_);
 		xfs_warn(mp,
 "Per-AG reservation for AG %u failed.  Filesystem may run out of space.",
 				pag->pag_agno);

