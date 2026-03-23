Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D85373BFB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 21:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774299832; cv=none; b=nq+Tz1a7Y70ryy+uRuLVrGNVfTOAVsUd87mRESChH0AlD40SSh48E4sVCva0uLRP2AkJvWKrNwaWVcLZz7XFrLQKsbYFTpDPs8UJEy+QN1o4YSl8efT5ceyLDGbUtFJ8fa1BWyL5DT4FW1UI17/w0YfnkxKE8KlHKFHkEjKPikc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774299832; c=relaxed/simple;
	bh=r8OL1tC4vs0p6w32MKgZRL1t5OWW9fS83QCQXWhM7k4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PIxNdPB6fNKTgWBEy6u3hhvLnLhQzR3QFu1Fg1ZCQTZA/AUXZSiJRKWcAr0q0LxjXRr905xUWdl70BSyZYYWSvjwYUNRFIIlETNX+mIag75EZf541ElXWiqP7rUgJ3p/VLSWw7vIhPu7UaLgJG7KmatTV7X/rpWT7hTkPYHDeSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkUtktJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkUtktJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ADDC4CEF7;
	Mon, 23 Mar 2026 21:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774299831;
	bh=r8OL1tC4vs0p6w32MKgZRL1t5OWW9fS83QCQXWhM7k4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EkUtktJw/VtIdUTHJ29p/W+WFXLEUC2FPhutf6iikQvAf4t31L/G3XrvzxnV4a2QK
	 aWy2XGrCO/LSl7X0Bw6CZ4HWuQTJog8HP9kv8OnFkmgxJxA4HEqeER1dRpKkKrsvS5
	 QhZ8cBJ7B46Keq9Rumr09pdEeEJojVnrONC9Z6kT77sV88UYgm4IquycJBFA6Nq35G
	 CXV0Nmi59Kx9quWEUjLKalWOpUX+7wWpr1+EVAPz1DE7NYmNXZTOAFClX3m/wM/+LM
	 6oApojBGwTIbKCG5KEctF9J6Xdg/1cE1n7YP3CemxASIdsnG/s5W8b4Fk6BaWl/3kw
	 kCtgoP30PEx6g==
Date: Mon, 23 Mar 2026 14:03:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH 2/3] xfs: don't expose stale pointers to callers of
 xlog_recover_iget
Message-ID: <20260323210351.GN6223@frogsfrogsfrogs>
References: <20260323210157.GM6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323210157.GM6223@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Fix this function to avoid exposing a stale pointer to the caller when
returning an error code after dqattach fails.

Cc: <stable@vger.kernel.org> # v5.15
Fixes: 4bc619833f738f ("xfs: refactor xfs_iget calls from log intent recovery")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_log_recover.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09e6678ca4878e..0e91a62348eb79 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1745,21 +1745,23 @@ xlog_recover_iget(
 	xfs_ino_t		ino,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_inode	*ip;
 	int			error;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
+	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
 	if (error)
 		return error;
 
-	error = xfs_qm_dqattach(*ipp);
+	error = xfs_qm_dqattach(ip);
 	if (error) {
-		xfs_irele(*ipp);
+		xfs_irele(ip);
 		return error;
 	}
 
-	if (VFS_I(*ipp)->i_nlink == 0)
-		xfs_iflags_set(*ipp, XFS_IRECOVERY);
+	if (VFS_I(ip)->i_nlink == 0)
+		xfs_iflags_set(ip, XFS_IRECOVERY);
 
+	*ipp = ip;
 	return 0;
 }
 
