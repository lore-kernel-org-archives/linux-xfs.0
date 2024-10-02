Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124251C2E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831067; cv=none; b=ESicpvfUrSjRibVDkfbbRh5KUAQJH0DhQ7g5qKNzr5KdQLC+U4UDr2R8UHz3X07k9jBmK49TpWbA0SbLbY/+eT0ZnmXBRrfdMKey3lSx8CM0lATdh2WkYewWonR/I428fgjCpGp8YiRhhsMDEwEbLVRvwLAAI2zJ3HpY8O3rsqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831067; c=relaxed/simple;
	bh=2fHxkvHAMiuVAhRq1TaQRRe3TMaUYBNe8/dqS5BoU6U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o4ESjTW5dAkJs7oPFlNoAA90ozke0TeJMvXu5xC4kGupP2llvKaNRcZlcEnU88RZtxiUXGBwwuTE6qfKI/H8D9Z8pcV9PgNmimJSvq+J1e8SyL5qm/WHvAgozeuHHavr7rKS+o8FNG7V3BM7J2aLEOWclV/RxPOJWJbZPk7uNq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQmNxME9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQmNxME9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD82C4CEC6;
	Wed,  2 Oct 2024 01:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831066;
	bh=2fHxkvHAMiuVAhRq1TaQRRe3TMaUYBNe8/dqS5BoU6U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bQmNxME9/PyaD2LyP4+yzZD9BHLW8I9LuBpacoJ+1msPNw0VdIMZ4b7tL2985d6Iu
	 dxlI01c7+a+8k1DXKR+0iCvUcJukfdoGpz1pv8FbPR9DhBeXhL+P3r+JQgTjV8ytFC
	 E8YTT/evckQPGS3oaDzZIs72LMaGyOppVfgKna93e28Mg2iUHdjlDMp9LPLFaovLhQ
	 jNvoL9BvmWz86tvBKet+TVWRpkf9C29mv+0pi2DEv5U/vQ1H4c00dnd9hJy5WhfdZW
	 1CbOWlpbHeKMuPRGMVyhirlldkiRgt9OQs9x7CuOI4MIwxKEoVzKamFrOuh9pbUkiI
	 Bx6R5TvY2iEFA==
Date: Tue, 01 Oct 2024 18:04:26 -0700
Subject: [PATCHSET 1/6] xfsprogs: Debian and Ubuntu archive changes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Bastian Germann <bage@debian.org>, Zixing Liu <zixing.liu@canonical.com>,
 linux-xfs@vger.kernel.org
Message-ID: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
In-Reply-To: <20241002010022.GA21836@frogsfrogsfrogs>
References: <20241002010022.GA21836@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Hi,

I am forwarding all the changes that are in the Debian and Ubuntu
archives with a major structural change in the debian/rules file,
which gets the package to a more modern dh-based build flavor.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=debian-modernize-6.11
---
Commits in this patchset:
 * debian: Update debhelper-compat level
 * debian: Update public release key
 * debian: Prevent recreating the orig tarball
 * debian: Add Build-Depends on pkg with systemd.pc
 * debian: Modernize build script
 * debian: Correct the day-of-week on 2024-09-04
---
 debian/changelog                |    2 -
 debian/compat                   |    2 -
 debian/control                  |    2 -
 debian/rules                    |   81 ++++++++++--------------------
 debian/upstream/signing-key.asc |  106 +++++++++++++++++----------------------
 5 files changed, 75 insertions(+), 118 deletions(-)

