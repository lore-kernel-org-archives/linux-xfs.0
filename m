Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8595FDF60
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307469; cv=none; b=tl7rQsAN2xpntnt1XraZwuBJQElHhmUQr5duhmoQRwZkgJW08OBMocHXCJXTruGGjGWlBszxFS2FzOEQLirpvtB9OAFtdxDlsPdn1B6fiDzrbwQTdD9eukWWSX3i9vLpLqyAWMN03b3kxu4dOcNPwfpDVYqVtxDjPxvnq911oro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307469; c=relaxed/simple;
	bh=9T4m6SpeUJ7Ab4wEEbcSj1PZ6LNOpfOg0yn0MRKEW1w=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=SP/esfTSULkjdmatF57n4t91Y7o9huRHSNdSfz/IjyyfdkPh9CGm4g715nw5Fols/N/7BwsSPyj/RlQrZBGtfz7AqVNFTPn8cmf1uax//WG21kz5y0BALI5+VtIEZC+foNcT5ocnWrwNJWnF8c6Ste4slyFduO9dpktCFj2hs+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n206c0oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n206c0oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDD3C32786;
	Tue, 30 Jul 2024 02:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307469;
	bh=9T4m6SpeUJ7Ab4wEEbcSj1PZ6LNOpfOg0yn0MRKEW1w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n206c0ojkLYtS2i81eUrxe3rL2jk4RSZxAiEmBoZT2cNoBWqMdI1oE/jt3Cq5K+de
	 FxqcWhmIXfiBgh10niKFsQV/1rcdnHiXJlPpPsD6Iav0qXivu1sN9UAHDKbSdI/Zsr
	 FWXajZjD7NO1q9DIpnxlKVwWx9DKNJaYFGqfw7Akv56N8m9r7yJQJ3KS3mwUO6s2MH
	 t26Wbx35pGgIEP/L+cG1Ed8O6ae9eobqa0GnwHWnG5L6QewzG4HQxSciW97SecJG0g
	 c4+19QG5ulB1cpLbAwNpVZmLLXdrYqz2JY91eoVUppclvUjhABUoe8qcPe5gFzb4jQ
	 f2K47z71M4kcQ==
Date: Mon, 29 Jul 2024 19:44:28 -0700
Subject: [GIT PULL 16/23] xfs_scrub_all: improve systemd handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230459399.1455085.1767851933784509862.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit e040916f649f71fb6a695dfcc6f6c9f576c5c4db:

xfs_scrub_all: failure reporting for the xfs_scrub_all job (2024-07-29 17:01:10 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-all-improve-systemd-handling-6.10_2024-07-29

for you to fetch changes up to e46249ec0b96ac5ced5b49928d3b3865b6d9546c:

xfs_scrub_all: implement retry and backoff for dbus calls (2024-07-29 17:01:10 -0700)

----------------------------------------------------------------
xfs_scrub_all: improve systemd handling [v30.9 16/28]

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs_scrub_all: encapsulate all the subprocess code in an object
xfs_scrub_all: encapsulate all the systemctl code in an object
xfs_scrub_all: add CLI option for easier debugging
xfs_scrub_all: convert systemctl calls to dbus
xfs_scrub_all: implement retry and backoff for dbus calls

debian/control         |   2 +-
scrub/xfs_scrub_all.in | 284 ++++++++++++++++++++++++++++++++++++-------------
2 files changed, 213 insertions(+), 73 deletions(-)

