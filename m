Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6DBBA2E;
	Sun, 31 Dec 2023 19:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSePRX/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13265C433C8;
	Sun, 31 Dec 2023 19:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052786;
	bh=hLYJ/7DlzPNJXzHageX1EpactzRMbuZyb4EUFGcX8Bk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nSePRX/7eLuxgCnRjMYpuieQ4KoSpYG8WLQxv60gzryyuyp/OOJ3pjoBwixaOMB/G
	 zJ+BGpeW9GudqBruKHptDgK88q61CWorAzYRV8O22Gnn/1bIYa6l6Zb5OFZ+Nx4uKt
	 k18QxGxbPf+9EOy2BjyV1iIsC4uaTdoAQCdubzdwBpz52UqBofb2Z9OFDWj/ms01kQ
	 zcQWUehNERmPwQg4zjg1Imks7rIKIQLPS0vSE4SsvZnukp703BZ765XIMkLDDdjMHk
	 DGpnjOC9Ngf2a/AHxySwHc6ROADEy2QvfO8B7pp7GPuxlXIOCVkSRUDScqF/8k9jIV
	 2XYEZqxPzXTYg==
Date: Sun, 31 Dec 2023 11:59:45 -0800
Subject: [PATCHSET 3/3] xfs_scrub: vectorize kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170405029241.1825289.15703936901700637451.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=vectorized-scrub
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)

