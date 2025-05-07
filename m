Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EF622688B;
	Wed,  7 May 2025 21:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654843; cv=none; b=kMnKJhSZQdgZgf/woeXalDIZHLpr39pIdusvo/0liD526vLVydzz+z2AXBQcOykfssGw0F6IOW2X0EqlWkezTpX2ldVp7uwvEGI20XmMawIY03qNayMEweB1wLPIw1oHryu4g9uIvOyPv+EZv3rKBINkMWYjo6lje26wFaqYTQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654843; c=relaxed/simple;
	bh=QRQo09RrwLkYk24yqtfWm1k4i2Rgu36MZnWrzujBteg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=TuKBK8DpE6NnIZPnxIB359aHnUIkxyl9awcJacYGgHy2FTrbSiuzOSMT4NRyIKCk76LvM2Y9Twqr3benB6vuBqOLa0s4PvI1wvQ1WAjsdOiWl2nJ+pPQFjDUnvSmay8OFWB3jgTqfLtxhOyRMkWmJNBFkNY5KoaE6nc5WqaD6U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWY9G1Rt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWY9G1Rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC02C4CEE2;
	Wed,  7 May 2025 21:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746654842;
	bh=QRQo09RrwLkYk24yqtfWm1k4i2Rgu36MZnWrzujBteg=;
	h=Date:Subject:From:To:Cc:From;
	b=HWY9G1RtRggNl16I2aR0B0yrZffEHc/1fF3t8C1BPZxuC8gytWdv4ARkbuj7BObbS
	 RMFV+EA2jhtucmbupP8VAzDgRQrZSSpltk9TS0ySUNgENPINiLod0jDA5NVNHRxrGy
	 pDkiMj7yDx5AcgdD0pZe30wVx5UwDL/xMSEPGnlODNMWDuFRnE8fmCOdiiDbpxQrR9
	 X0JXhusDOfJhA6+BJpAQtJUsLQWfAlUFuauI42yV1UKlr7GJPaAeFecedAR+cqBfjG
	 Cdq8hQjRGorr2ZGR76IuctVHTD8ow/appYVBFPPQecjwYmFxyg5GuF2fIjZeJGAlVi
	 zyyST1dZ7YbqA==
Date: Wed, 07 May 2025 14:54:01 -0700
Subject: [PATCHSET] fstests: more random fixes for v2025.04.27
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <174665480800.2706436.6161696852401894870.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * fsstress: fix attr_set naming
 * xfs/349: don't run on kernels that don't support scrub
---
 ltp/fsstress.c |    4 ++--
 tests/xfs/349  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

