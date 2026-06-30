Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FEE1FC8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781323; cv=none; b=mtr/qO7qq1d33M7EYfr/pgSB68idwwL4hlfe6zZDVXpzktmsbLcbP0R8BeExXwHlC2POzG95a7rnd8Js/H2Psh68GOBFqbyTJ8gKSdo6UzUZcOMRKm8NasJrJWHs3y9t8YFgPEdc+ygPOK5kD1wSphxwNpO6maXjdAeEVxTEFvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781323; c=relaxed/simple;
	bh=oMpXaT3g+d7J+7j46Wel7nI2ZQ3v8esPc+IQ88bW/Sw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=fmoYBY24YuI4b147IjLclDzlu41CiErUrtBXmw3npXMQedPvkwcVQARmouECN3Df6PHmDRlh8/dalt1uZj9aaQBYoxBVJFSgQSjlZIaFiu9nnxuI8k9z/F+0ClgC4rc7EJoJm9OD15WFUojBohC/iq8Ja5Z6aF+WPJqRG2iPs0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXLgPHLF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXLgPHLF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6129A1F000E9;
	Tue, 30 Jun 2026 01:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781322;
	bh=TMh2QpNcBLHqxRgCQNNv0aMANrf8A9e/hzw6Vr/Hlik=;
	h=Date:Subject:From:To:Cc;
	b=nXLgPHLFrg+nbePui0dkNXfqwn0sAbLlUuyshxxoiUAJHA6gWXNldGDYnaOBIeHMU
	 18Tt2jH1OAV85dejwJRg1ExMJWjp6PzTfXffj8pH6fQrszMCWe519H4dTQsqayPC8c
	 dTYqTyZFA+nQj7yteLFLIwwkB2XvuLTTRedSoGrxtY/ZXTro5wVl3vzQQ5fQ39LwAB
	 1XCzr9LKtlv4YFBmF6LuR02aHHHgaEfR4taBpTj9np/QuY4HBMSne7lkbOsef0Echn
	 pUNUXeo9bYuGAHHy8XwdcUWSyFEt5JeM+u8wgzbvd+icROq90ikz2semgg+tZFgRxc
	 AmUxU70inYTYg==
Date: Mon, 29 Jun 2026 18:02:02 -0700
Subject: [PATCHSET 1/4] xfs_scrub: codex-inspired bug fixes, part 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129539.858187.11646178692582297659.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a fourth batch of xfs_scrub fixes resulting from Codex reviews.
This is actually just the two from the last drop that haven't yet
passed review.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-codex-fixes4
---
Commits in this patchset:
 * xfs_scrub: fix spacemap external log device scan dev key
 * xfs_scrub: fix estimate of work items for phase 4
---
 scrub/spacemap.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 scrub/phase4.c   |   17 +++++++++++++++--
 scrub/phase6.c   |   42 ------------------------------------------
 scrub/phase7.c   |   11 +----------
 scrub/spacemap.c |   17 +++++------------
 5 files changed, 63 insertions(+), 66 deletions(-)

