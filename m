Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DAE1442E8
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801655; cv=none; b=Ju26Xcugt3T0s1L32xgJqhi+P8+9D5OuJWHgMb1SkeSYDRan9wZ+/i9bn86getzNH/r8KrXD7tgA5qXiAisNYBePjvrBiud/cECffGmuFqLgKj4brixmQAJSJhOhWccrZF2wkAuD5KnGUE5AoaR6yrkCN8kW/q/ifoWaM4pzjCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801655; c=relaxed/simple;
	bh=FMaw/2MmQlxt3tnLSByoAN4WOw6EkjA2UbQyhyeVHSE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YHJ/a257MFw7f5V9COcKYACKE038hhpCkinFlBGvG9LYiR3vu28h1V26YxF7qQ4BD6YRc8E6zb8HXU+JECKioTtHIOYXP4gnt4/jTo1QHN0eYEOT9WUdqgo0Pew+foRQYdZ+78URBTjqQbnhwY2qpDULxXQUTxfEs8jqVQaRdrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jA57BaTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jA57BaTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6A9C55DE5;
	Tue, 27 Aug 2024 23:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801655;
	bh=FMaw/2MmQlxt3tnLSByoAN4WOw6EkjA2UbQyhyeVHSE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jA57BaTnZdnoq27aDuOzyrmk8gK6NSgT4gjWCH4RendbauLFKCidI1DWCN9Dmh7jC
	 EH6e195+m5Ic9GoSpqgfYy2e0VScQZGIcu6ZI4OLk/pTYZe+wII5RU3ZR32QMKhK87
	 WYZVkf4Fdy/Y82NEKwbe0rUGxLyAbeJkx3r/TcppFCLwUTDV53t2T8EfA1uKpU15OZ
	 iu8/sGsxmvrfRbE9/7mBPJMd7KQ7zzUeWbLhN89mK689Dwge9Dhb2Z5Cm/ublyYJA6
	 spknHpJC3saDAnek8UOCPWWezn92eWnjvEiZOUXLr+YIxGwiHijm/GRG4pDDOduQ3U
	 n7d8yjMRzHkLw==
Date: Tue, 27 Aug 2024 16:34:14 -0700
Subject: [PATCH 02/10] xfs: fix FITRIM reporting again
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172480131538.2291268.13135074466048273297.stgit@frogsfrogsfrogs>
In-Reply-To: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
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

Don't report FITRIMming more bytes than possibly exist in the
filesystem.

Fixes: 410e8a18f8e93 ("xfs: don't bother reporting blocks trimmed via FITRIM")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index bf1e3f330018d..d8c4a5dcca7ae 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -707,7 +707,7 @@ xfs_ioc_trim(
 		return last_error;
 
 	range.len = min_t(unsigned long long, range.len,
-			  XFS_FSB_TO_B(mp, max_blocks));
+			  XFS_FSB_TO_B(mp, max_blocks) - range.start);
 	if (copy_to_user(urange, &range, sizeof(range)))
 		return -EFAULT;
 	return 0;

