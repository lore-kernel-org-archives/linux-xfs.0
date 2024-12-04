Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70A22746C;
	Wed,  4 Dec 2024 03:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733283944; cv=none; b=BONiCj8nJg+ebCoxhUj5OEIVr/gIaM6tK6UW6kMVIWCEHMVtwBEk9k9EilYpL1tnlcocDhXiyG6IIzad6KPULjj27PSiUFYykRxeW0VoCZ8d3TWvKzOpjyPIqanv3z48m2BfNyVowqsd0eIyiNk8gXD9UftGgt0SgxZpSoYtwUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733283944; c=relaxed/simple;
	bh=cUm3yDRuGm1rPQLGYSVF71RBia8Uzrs6h2kRHydwDgU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=qITJM+SJHBlFXrtl75K3vnVLO2t2qqx4nbKasXh6EJTyW+vzzEfk7J6vGg7JTiKZq+iwJlq41CW2EV298fc51qcT7pIbciHsBuUNO8RXQxYi+Avdy/bcpdnRKeHuEFtNnh9Qzu9uL5gtaGeN6D1DKi8lTV6mvqeXwjN1uuK+FME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5Pqe25R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5Pqe25R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D3EC4CED1;
	Wed,  4 Dec 2024 03:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733283944;
	bh=cUm3yDRuGm1rPQLGYSVF71RBia8Uzrs6h2kRHydwDgU=;
	h=Date:Subject:From:To:Cc:From;
	b=F5Pqe25RXVvxbuqINucT8yC4t2lY60op0g5t5sWDqRZX76tS81UkZHXA/fjJuGo2j
	 G9UKsMj2LAKMgf9UxuhoDu5yAWvVBhj4PeFvlbqYNyr/8NK4EKKlLKfGNZMKNVnb9u
	 Bjs81uSCXDWVJiJFtcSsHxwazmZM7FGTgOKCjC8pO1qtEjbnBnpBKOUL/+hIv0I67e
	 TTRjYtv4UX++N6Ly7WfHv/PGZx8JuFIq5uW9FWdSZVm3zoUeuB3z+NnYEXSBBLCv9P
	 9owhGZ5+9VWFdg4nnSZlzW3NUuWkXBzhaMqrXKbvXM1ATcTJXpeDsf67zhljMxYof0
	 H0JXWK3HToQyw==
Date: Tue, 03 Dec 2024 19:45:43 -0800
Subject: [PATCHSET v3] fstests: random fixes for v2024.12.01
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>
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

v2: Now with more cleanups to the logwrites code and better loop control
    for 251, as discussed on the v1 patchset.
v3: Add more acks, kick out some of the logwrites stuff, add more
    bugfixes.

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
 * xfs/032: try running on blocksize > pagesize filesystems
 * xfs/43[4-6]: implement impatient module reloading
---
 common/module |   11 +++++++++++
 tests/xfs/032 |   11 +++++++++++
 tests/xfs/434 |    2 +-
 tests/xfs/435 |    2 +-
 tests/xfs/436 |    2 +-
 5 files changed, 25 insertions(+), 3 deletions(-)

