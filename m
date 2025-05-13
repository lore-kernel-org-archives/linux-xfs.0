Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9291821171F
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157745; cv=none; b=K0WwTunXkNPYYbYSSEF+fTGO1pKbc7eX/ZHVoFUIcXxGFMCaTLpkG88B+ceRVaf6njL2LldreBK0MwNVgazvS2yy04NrxA5V+XFvKcJy/BADKL72WbsDAoFSekuC9jpSN/SyRvmm8MQT6xWo5KA16oUkxbPCpkOrHdkFv34GGm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157745; c=relaxed/simple;
	bh=FnfZzEDiKknzZtCDcItNEfL2dV3G6Ah3dDUh21VaUqA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=enhmphAFfYAgaLIIDALD0xwfVfSbJhaakV/6neIfv/18P7y6hVQUPrTeb+EZLOBWz23pLzp8wz4K9ZmFHhPXFFck3Vuus5ErZMgQZqpSZncbuR43+y2pDUTOaTfEI3Y3jZ4gOhf8hvtJuX2Pel5nPYp+co2pnSLIYKc6vXVMfsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKgc6/Ux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKgc6/Ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6002CC4CEE4
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 17:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747157744;
	bh=FnfZzEDiKknzZtCDcItNEfL2dV3G6Ah3dDUh21VaUqA=;
	h=Date:From:To:Subject:From;
	b=SKgc6/Ux/uzzBBRnbs6C5D6KZ+hMg62Y8n5gjFwDfQCkYAAphdt4C4/fGC8sC/yjK
	 x2HdZOXKOmVNQ+k8pelNj37nZoEUtERVQiPq/uyA/XvQKKYhbPDqn5nFZW4WBPnVxk
	 X4G8haeLcWDAu29M29NvqaTA1cerESJsBWRO6zqfCe6quzUTM3XmS3qC1ZLQdaIwkk
	 k0Du0hoQbCCx8efvi/luPiTUh9BiiVsZ2QAgIoBquoYEfO4WGE6mSRkyTLOZcm44xu
	 QrbgPCXvjh5bVG6duoPsvR+v3+EFe94uxra4nIlh3rkbGp2JS2hPw5g3DD0xe3JUGt
	 eAB323yd2tmuQ==
Date: Tue, 13 May 2025 19:35:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to a0922bf89760
Message-ID: <sjuhygycuriowxzm6pxl57xx2rps3nqn2zbxm6frw2kke3ovd5@ra47vueh5urk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

a0922bf89760 Merge branch 'xfs-6.15-fixes' into for-next

6 new commits:

Carlos Maiolino (1):
      [a0922bf89760] Merge branch 'xfs-6.15-fixes' into for-next

Christoph Hellwig (1):
      [91ffea7cf2f0] xfs: fix zoned GC data corruption due to wrong bv_offset

Darrick J. Wong (1):
      [f0886a57ee89] xfs: stop using set_blocksize

Dave Chinner (1):
      [23871ab38662] xfs: don't assume perags are initialised when trimming AGs

Hans Holmberg (1):
      [654a7640418c] xfs: allow ro mounts if rtdev or logdev are read-only

Wengang Wang (1):
      [3cfcd35c5133] xfs: free up mp->m_free[0].count in error case

Code Diffstat:

 fs/xfs/xfs_buf.c     | 6 +++++-
 fs/xfs/xfs_zone_gc.c | 5 +++--
 2 files changed, 8 insertions(+), 3 deletions(-)
