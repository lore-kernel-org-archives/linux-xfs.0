Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3672F1A2860
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 10:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740564076; cv=none; b=Ry+rQxuLhcLOb08uPsmo452qfME2uO1Y3rsn4C0m6GusNvgurmQaKostqsSfR2jo0s6TrlpYmEp3KTzYvrVMiqYo/69xHwMs00ErLGWc7kl3EzP0pu1Lf2QoGSIOsdpLkO+W2iSOjlxug+5X55+7tuSdYiQqCwPVFHu2FLXr3pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740564076; c=relaxed/simple;
	bh=EcrSrTLJKM6cShknzGdztqURBvj6jnLQnQcbcdrPkkQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZSRQHmCg3x3DEW0sCRtlp+9eqwmWR3QeJf/In8rpCcA2xle4smsb54fUHXRzYcbS2NiYz/SuK8mYfm5FZhvhU8xOMgiQvZJbR0ZifBg3mwEB2c/CA+lmiX8Q9zPg95ydxlEsbaMvtD15zivIlxY5xTxrqCxCSAKuenyut2pjLdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KwiuG2b7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KwiuG2b7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03162C4CEE7
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 10:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740564075;
	bh=EcrSrTLJKM6cShknzGdztqURBvj6jnLQnQcbcdrPkkQ=;
	h=Date:From:To:Subject:From;
	b=KwiuG2b7MxYYRu/FsrF6YTyAkAKDZBPF0bQ7GgV/QIifH5xyO1WQzdU1rv2/NYIsG
	 3psV5ldwMeDFkpAUODqCAQQ66to8n8+8LuMQqvwoER073WhgSqqQw7+z297PlDhuKj
	 5mV9sNL2iNd3NoLymATilclQGEH4P3mInTwKv0mSOGlFXC86waLnCoZ3AB+wzbvHQM
	 NcdIaVDcvD9V52UpgMsBA1RVl2sjhMoE/sA5aUDfIc0ujPgc5qVy+rinkRvl8go1mc
	 75J4dl31A1wSn3CZ9V4AmjlKOnxa2rILPuPtFMnszmU32hSDRuatYwh4dzssfcxUbd
	 /1L63iyRqLHEw==
Date: Wed, 26 Feb 2025 11:01:11 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 9b47d37496e2
Message-ID: <b6ek6tjfowznwxgbtfovzctumzx2mgc2spd7jtw5u5emzkedjl@pxorgvwyc3sv>
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

9b47d37496e2 xfs: remove the XBF_STALE check from xfs_buf_rele_cached

4 new commits:

Christoph Hellwig (4):
      [4b90de5bc0f5] xfs: reduce context switches for synchronous buffered I/O
      [efc5f7a9f3d8] xfs: decouple buffer readahead from the normal buffer read path
      [0d1120b9bbe4] xfs: remove most in-flight buffer accounting
      [9b47d37496e2] xfs: remove the XBF_STALE check from xfs_buf_rele_cached

Code Diffstat:

 fs/xfs/xfs_buf.c         | 182 ++++++++++++++++-------------------------------
 fs/xfs/xfs_buf.h         |   7 +-
 fs/xfs/xfs_buf_mem.c     |   2 +-
 fs/xfs/xfs_log_recover.c |   2 +-
 fs/xfs/xfs_mount.c       |   7 +-
 fs/xfs/xfs_rtalloc.c     |   2 +-
 fs/xfs/xfs_trace.h       |   1 +
 7 files changed, 71 insertions(+), 132 deletions(-)
