Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11332372EEE
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428065; cv=none; b=anoaD8DmmjDKzYegY1huCSYWh648Mc+PGoWbyRT5PrZy+t0t38HPCpv9kKj41dvVpq0Zo7cWwOoOIQXdLJe4+WCsEFaSmp2PAnsOViTwv8rIN+c9T1z6x2SflxyF856STjAkWtShWBaewOTaEP077ePXQ1KA1d5M1QvPJr6OStk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428065; c=relaxed/simple;
	bh=GEkT89ZBVs3qTZ3QUczq0TnQdDGh4MgZR2QOHYXqgL4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=GKaqzWkcIE7ZPw+h+SzdIUfssLN3jgdm4ph+x7B41tNsucDRXncw8p0gJUNFgAOGLzG8HeZ61+29hPaRBjWzX/KawEEdM4jTJCWkXPuz/YI0fOSknSRr6YBYvYYJuyqLlNkuMTJKKpH5/ZVjx/AvigUQ+mJJzbaQjwad1p+ayU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOoDgTy6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOoDgTy6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8D3D81F000E9;
	Thu, 25 Jun 2026 22:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428063;
	bh=cnkSM0hq90PyzIaLzzXFseH21ZVM9Hnxper3EZQEG1k=;
	h=Date:Subject:From:To:Cc;
	b=DOoDgTy63LcrTZMlr8qYbbHBees5fMpDjBo36RbC7qjHhYxJ/x9p9pVPd0nHvaDCi
	 +gxeqJ4ChHk4oDfgy3/yQM/TGsodxrwDf3AOvuKvS1laeY0qUJw3xhAuL+G4e4RiyC
	 NfTgrOggNccQ48gAULFHLuY2z1WDtOVWOyl6nCHx6fjLWgZVJUTAeeOeN7WBpcI8KZ
	 Yj7y2RoiYUUBtU5PSC9pAGpkoOWGL119c7aqiTikqJImV1q2LR97u1stmVDsBXrjS7
	 /yiguO93UC+6UrgacS5JokHunuMaWW+1EvfAWDhCiDPO63ukV/RyVO8Pvk42lDjduU
	 ix8WJe3Wx7YEw==
Date: Thu, 25 Jun 2026 15:54:23 -0700
Subject: [PATCHSET] xfs_scrub: codex-inspired bug fixes, part 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a third batch of xfs_scrub fixes resulting from Codex reviews.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-codex-fixes3
---
Commits in this patchset:
 * xfs_scrub: stop user file scan if caller already aborte
 * xfs_scrub: don't flatten error numbers in read_verify_schedule_now
 * xfs_scrub: actually handle NEEDSCHECK scrub items in phase 4
 * xfs_scrub: fix spacemap external log device scan dev key
 * xfs_scrub: fix estimate of work items for phase 4
 * xfs_scrub: don't leak phase 5 scan items after a failed workqueue_add
 * xfs_scrub: fix phase 8 debug reporting
 * xfs_scrub: always finish cleanup, even if reporting healthy state fails
---
 scrub/repair.h      |   14 ++++++++++++++
 scrub/inodes.c      |    2 +-
 scrub/phase1.c      |   11 ++++++-----
 scrub/phase4.c      |    4 ++++
 scrub/phase5.c      |    8 ++++++--
 scrub/phase8.c      |    5 ++---
 scrub/read_verify.c |    2 +-
 scrub/repair.c      |   16 +++++++++++-----
 scrub/spacemap.c    |    9 +++++++--
 9 files changed, 52 insertions(+), 19 deletions(-)

