Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B1F1428F4;
	Tue, 16 Dec 2025 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765909760; cv=none; b=CCT9eIZJhlO10KZ0sFUR5IvtwamKtNsyL3SeEHOIIlxPfBUvsFOV6Bad81IwiAIZQg6t7sPJnuw0BQ5ulnMiWaJjJ2Md7aCgPv4OyD4KwhjODDGPus2RaGeO2gSrthv6vz0xQ3GE+XzJzyKs2TNzKgeTRUPUctMVTDyfuFfLk5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765909760; c=relaxed/simple;
	bh=ZqmpAI/hB//JFnpUHK2SbGOuNSC/mZaHxIvIY+0d7bw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=b8BJN/u4R/5yM7MuQo5Mg2j5c2mjjDtmVdYrwRAET3QBWHmB9SfNk3b+ctzI8GtVLpUIpFMZy7vuPq5l9L7E+yOEByd/IWIjfgiACU85xUlBbbbVVAQ1FebjFUp2NmwUJyiXG7M1j/zlZ0Q/2gmrPyw2G08m797wqVUNut4OJJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kv9NtmDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kv9NtmDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17818C4CEF1;
	Tue, 16 Dec 2025 18:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765909760;
	bh=ZqmpAI/hB//JFnpUHK2SbGOuNSC/mZaHxIvIY+0d7bw=;
	h=Date:Subject:From:To:Cc:From;
	b=kv9NtmDgeSvxy+VNpFN+WH8Qu2IpXTWE72244g4rYf7QtkHcxYXrkelbD9fejzwe3
	 L7Wm78ep/dwTNM6HZCVTbwyQryRnb/FS4WhghqpwbjW+AWCFpdI6X95guNWzix+LYa
	 2/a6qe4Q9HSdowEIB0AHwSw39IDlFE9UDndb6pCyGLwgRgrqVKFs6k6t4Qfy1e01C8
	 90CYlx0JVJJa7Mh9iF1uw4ncOtbJwZ0Cm1dcwNsfCtEwbGU5m2dSTxRYWnoEpYD13r
	 jiFnstB/pzAduFpMs2kZPeT0GtGiZLhr9MN4p78BKLkgWjyDX/USoK9IfVFfA9i/+V
	 V9QzFecrVoe4g==
Date: Tue, 16 Dec 2025 10:29:19 -0800
Subject: [PATCHSET] fstests: more random fixes for v2025.12.09
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
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
 * check: put temporary files in TMPDIR, not /tmp
 * common/rc: fix _xfs_is_realtime_file for internal rt devices
 * xfs/649: fix various problems
---
 check             |    2 +-
 common/preamble   |    2 +-
 common/xfs        |    6 +++---
 tests/generic/002 |   16 ++++++++--------
 tests/xfs/649     |    7 ++++---
 5 files changed, 17 insertions(+), 16 deletions(-)

