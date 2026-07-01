Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF0D383C65
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 05:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884978; cv=none; b=XPodNinQw+p/fUsSGWVwXzkdM8XHLFXetQQ2Gmr2iYGyiBWP5bhRrWFkEa+qPfLojy1BE1muEYkMXZ2IS7vtcgIjsynXyWyegPg9PD+RxXQwoWBaGqw/4Ai4Ap/5ZECkYPKdY7IEmvxhp8hxIR/wLLDonTRl8HvSK1eKpepMYIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884978; c=relaxed/simple;
	bh=0utgMuKJSsaEuoP1KdWkepdpHf4LLQ6W0y8eS+6bTNU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=LrTVeyQ9G9tA7kY67mMOmC3UaWFL4w/Y6e5KDowHQrZdbMM1bhVOvxPLQoj12o92yslKRregNtQ3W+Di+tDIRNW2LFsLQoBcH7XHGdOSFwv0/2vVkzPxFnaiZ5piOjj4R4WLVUsDYyn09Vnp//ySji8WN08nNUhwuPPNM2DFteY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCAkMDCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCAkMDCE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 43B011F00A3A;
	Wed,  1 Jul 2026 05:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782884977;
	bh=2k1N2ShN1pl/50yoSMzhtmIwjH0ebTNPiVJAFTtYHTg=;
	h=Date:Subject:From:To:Cc;
	b=NCAkMDCEN7yWKRxKhGr90NUIm2mGZpxOmuNscTd1eaXrXwRxBAKEKLRSUeU9WghRd
	 rvxyDWObqxvD5+MbYEPakFwWBOuNLCmIk3tDJfCgSE8GhQjQsB5V81GWtYBDe36+OC
	 wVoOyHSGXoJeYEqDOpWpwW2v32+CT0Gkr825RYzIUUERcvchcAAaiEy/mmEH7S/fdt
	 HRvAoCOCGH5zRN4UKSpxgNxmygrR9V8Y7DEVvbJ6dsoO+GXcHtW1nfZcJA6MXmGwuc
	 6cZZKxAHXBVhoV+/73EHKce+eOOXhrKuxd2wDlljT18OMynDRIjz/RYqp4CgeAKP+e
	 pu8rQ+p3p8Aiw==
Date: Tue, 30 Jun 2026 22:49:36 -0700
Subject: [PATCHSET] mkfs.xfs: codex-inspired bug fixes, part 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a batch of mkfs.xfs fixes resulting from Codex reviews.
These are really just the patches from yesterday that needed more tweaks.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-codex-fixes2
---
Commits in this patchset:
 * mkfs: pass stat buf pointers around the protofile code
 * mkfs: fix hardlink detection in directory import code
 * mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
---
 mkfs/proto.c    |   47 +++++++++++++++++++++++++++++------------------
 mkfs/xfs_mkfs.c |    2 +-
 2 files changed, 30 insertions(+), 19 deletions(-)

