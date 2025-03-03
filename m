Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4921AD27
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 09:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740993511; cv=none; b=LEY9K+gEULKEMZjjNx2kZpT/vsIa8verWdnmX05wGSG59hpAhIjH4c3p6RTnNj4YjjEzApA9xwV72qvFl7xijR/SDRcCsOg88i9tiGC4fvroqkW97NjHATDl9jGQtWf4BS+L9w4WnbEyBE9lB+FpegKSDimLMXTPQ1ESpc6s+6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740993511; c=relaxed/simple;
	bh=0UHns6gWTtMBtPYXwxPnvkaAP17S4Ujp6UwPqLHet3s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OcJy9SRG3kiugfhQWctIRdPHCaYpHbYcr1ErbUF+ixCACBOJaRHzWYTc3FLA8YfMOHWrSz21PsH3qCQKILx226ub+5XERjltUQg/QpNjhwcEEaFLzdcBZSkJQafqtz66gl7oVAkeWUidd4r+rODVZpi/0chv4MGSb00BAcpfJ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jly1c1LB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jly1c1LB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C435C4CED6;
	Mon,  3 Mar 2025 09:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740993511;
	bh=0UHns6gWTtMBtPYXwxPnvkaAP17S4Ujp6UwPqLHet3s=;
	h=Date:From:To:Cc:Subject:From;
	b=jly1c1LBjR6ApE4fhHaLBlPL2Sul5Rl5Gu2t099oBXLKb91E69igDTzHDNmXsC1tv
	 +rTJj8Qf603EC/LO3MxgMkUSBNEzmpedfuHRKJcF5CT7jD/CBzImq1t09H6nVYX1ia
	 DHt25CoWmY9x0A8rVKJ6epwFn+CYC7dvhagolMBBqb+dl+Kf4X539CaS4WonUpdDUP
	 B1SC+tmrjMLGAHJB2KYpRDsawJPfVwMCekq6zwMvHiEwoxiMbeBvByj6tyvqCVsboD
	 Mxlqr+y0aLO/3ee0g3DpUHVPVNNBC5SbXNhoC3gOs4ay7msAVZS21/53sjEr8Xy9c5
	 q6P3IhH20jrTQ==
Date: Mon, 3 Mar 2025 10:18:25 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for v6.14-rc6
Message-ID: <tdyusv26cmphdeo26jil4kfz2nokkf34m3mchl62xpf3rui3i7@z4agwzsfdghd>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

This contains just a few cleanups.

Thanks,
Carlos

The following changes since commit 2d873efd174bae9005776937d5ac6a96050266db:

  xfs: flush inodegc before swapon (2025-02-14 09:40:35 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.14-rc6

for you to fetch changes up to 9b47d37496e2669078c8616334e5a7200f91681a:

  xfs: remove the XBF_STALE check from xfs_buf_rele_cached (2025-02-25 13:05:59 +0100)

----------------------------------------------------------------
Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (4):
      xfs: reduce context switches for synchronous buffered I/O
      xfs: decouple buffer readahead from the normal buffer read path
      xfs: remove most in-flight buffer accounting
      xfs: remove the XBF_STALE check from xfs_buf_rele_cached

 fs/xfs/xfs_buf.c         | 182 ++++++++++++++++-------------------------------
 fs/xfs/xfs_buf.h         |   7 +-
 fs/xfs/xfs_buf_mem.c     |   2 +-
 fs/xfs/xfs_log_recover.c |   2 +-
 fs/xfs/xfs_mount.c       |   7 +-
 fs/xfs/xfs_rtalloc.c     |   2 +-
 fs/xfs/xfs_trace.h       |   1 +
 7 files changed, 71 insertions(+), 132 deletions(-)

