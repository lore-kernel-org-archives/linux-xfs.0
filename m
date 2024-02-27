Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C52916;
	Tue, 27 Feb 2024 02:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999242; cv=none; b=Z/WbeV1+K2xb5mxDf1jUgZxVgMxl5t+hkT8hx9A+4nln1Hb88oDY+NE6cnZX+TQ3WhNdiSx5xtLI5hybyhvycCPGUh4zFtyhww3P6jlwkR7dd0mTMIyCp3WW/RUi7OZM+Ua5DEf58DYc4H0+mTFLLw4p6lkFmk/ZMTS4H3hiT8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999242; c=relaxed/simple;
	bh=d3YSyypI1YJ5aNz/wAB5qJjpDgluq+pll5JXWjVsFUI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=UJegy2N1OcBEiOlVA5EeRMut6YrLSIcbnFHOIQ8v248ThFKaKrp15pNpeWSPYa5DEdHIh3B6B6sRrlO0dQjDUD60Q45K3GuC6Tio9iB3+5cvHUb1ErU1sv0ogC1By1ZOkZ5n7cHjgOCfwiuSmVSQnnH1qe93UygAv0Cmu4Bi5c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7C2B/mT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7C2B/mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B71C433C7;
	Tue, 27 Feb 2024 02:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708999242;
	bh=d3YSyypI1YJ5aNz/wAB5qJjpDgluq+pll5JXWjVsFUI=;
	h=Date:Subject:From:To:Cc:From;
	b=F7C2B/mTprPeENwz9aRD+AsaqxqQGkgZhAlVnCIoqefT/4YapD+7SHvWUWXQcbfTx
	 idTFgI1ATRHMm0iQm5SY7NngwRVPkxt3ZVXobZ38xdfJfzuS6bWT5ljcKdT2FCvERv
	 8hB/SikTrPpYew88aveLchymFSTb8UiGqqBgVzPVQoH2Y+vQQ5aDG5H1Q1sKRVrb6V
	 INwvCBv1Y2/Hv/iWCi+UnKQee43xgxwABAO7kyLEgZbOBkfUY5LdXJn7Bi9O18ZyIJ
	 adg6Wz2K+7zbkZrWe+bh2KO7UN9PqZEQabFyN/T8sNUIJSLCCSb+IvOPnpidCyHgVo
	 Z1JzIH2qUeIKQ==
Date: Mon, 26 Feb 2024 18:00:41 -0800
Subject: [PATCHSET] fstests: random fixes for v2024.02.09
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org,
 guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
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

Here's the usual odd fixes for fstests.  Most of these are cleanups and
bug fixes that have been aging in my djwong-wtf branch forever.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
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
 * generic/604: try to make race occur reliably
 * xfs/155: fail the test if xfs_repair hangs for too long
 * generic/192: fix spurious timeout?
 * generic/491: increase test timeout
 * xfs/599: reduce the amount of attrs created here
 * xfs/122: update test to pick up rtword/suminfo ondisk unions
 * xfs/43[4-6]: make module reloading optional
 * xfs: test for premature ENOSPC with large cow delalloc extents
---
 common/module      |   34 ++++++++++++++++++---
 common/rc          |   14 +++++++++
 tests/generic/192  |   16 ++++++++--
 tests/generic/491  |    2 +
 tests/generic/604  |    7 ++--
 tests/xfs/122      |    2 +
 tests/xfs/122.out  |    2 +
 tests/xfs/155      |    4 ++
 tests/xfs/1923     |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1923.out |    8 +++++
 tests/xfs/434      |    3 +-
 tests/xfs/435      |    3 +-
 tests/xfs/436      |    3 +-
 tests/xfs/599      |    9 ++----
 14 files changed, 168 insertions(+), 24 deletions(-)
 create mode 100755 tests/xfs/1923
 create mode 100644 tests/xfs/1923.out

