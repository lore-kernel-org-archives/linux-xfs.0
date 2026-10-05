Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E1E3254B8;
	Mon,  5 Oct 2026 05:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179877; cv=none; b=mKOiAuyiZkD33Zv/bu0cqi/UQBOTXSoqPAHYXApR3CNJBFadj8aAX1wGzQktu/14yy+v5kl7x6yhvzIGP85QKmCsUU232TdKYudie1IRTKNXHVROGiLA2WXJ/a50jMWti2fChqCqMI7KJMR2YO1S1L5DVd2pFnZF2mgc0AuBMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179877; c=relaxed/simple;
	bh=kHGioiAMiTOYBCLa3Iatlh60hdioLdrj7AJlEyeUwKE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzai+pYNhZ/SyQaaZo1m0/+4OWbikYbbk1RhSVvx7NjtLJyjoZYj291JM1xyc89b2U2JNSXGF1YHVY5Y9bWNiXYhA4JuS7z8Z4aH6LT/ycG1Wd9vhCR8PxyZPNrlSs436Q/akTOZjCoBA+WjKYfkxVpM+GtYpczCCCR4kq2z4N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXB1QW2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXB1QW2y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3D2D91F000FF;
	Mon,  5 Oct 2026 05:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179874;
	bh=2p5FU7xYWTrKr4DRx8//E3oz6EpoLTpw6d7mmKzyf8E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hXB1QW2y4YPVuDZpVLwgeJo610yw31oT3X8AkFLTwDWG6uOYu/giE4ptk0ly+CkKH
	 cIrdM6gX+3bmdv4LDsBcdIbQkvT/4t7nGgLkc8Mkdl7ThynWiy4MztbhO5S34gdjbC
	 PV4Q80veqmB5ClidJ0fiF7DXnFYnSBanHP5vLOd21499Ix1kJUYuShzFA6U8bf39Jm
	 8iM983eh/ad2AyoHosT0vSaweq7vOHA2sN/0BAybYvzXxakoY0W3GUIJN0diIzrYqd
	 MozsKi4cSZkNhufEmxcy5xVSyTvKOnBixpFHvX4UwpYUFQ9jaA8xCLwmLKFdQbDJka
	 hI1ww0YRwQf0A==
Date: Sun, 04 Oct 2026 22:57:53 -0700
Subject: [PATCH 10/12] xfs: release ip after unlinked list store failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965223.614350.12123807601095557612.stgit@frogsfrogsfrogs>
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

If, while processing an unlinked list we see an inode that has nonzero
link count, we fail to store the incore prev/next pointers, we should
release the incore inode instead of leaking it.  This was in the llm
fixes branch but fell out for -rc7.  Weird.

Cc: <stable@vger.kernel.org> # v7.2-rc7
Fixes: 0052633527158b ("xfs: don't ignore runtime errors in xrep_iunlink_reload_next")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 497701cf96940e..32dd09ac3a55de 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1104,12 +1104,9 @@ xrep_iunlink_reload_next(
 	if (VFS_I(ip)->i_nlink != 0) {
 		error = xrep_iunlink_store_next(ragi, agino, NULLAGINO);
 		if (error)
-			return error;
+			goto rele;
 
 		error = xrep_iunlink_store_prev(ragi, agino, LINKED_AGINO);
-		if (error)
-			return error;
-
 		goto rele;
 	}
 
@@ -1123,7 +1120,7 @@ xrep_iunlink_reload_next(
 	 */
 rele:
 	xchk_irele(sc, ip);
-	return 0;
+	return error;
 }
 
 /*

