Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7B046A7
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnbjAVFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFB6C433C7;
	Thu,  7 Dec 2023 02:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701917685;
	bh=9OqoJuAf3Ip8gTWDIQLjLpCJniRbFaBhHnsVoQD+fUk=;
	h=Date:Subject:From:To:Cc:From;
	b=cnbjAVFxRWEhZi+0YR6SjA8UPlBE5hkPmfNdYPKwZ2IgBbJMQTSjUDXotV5EU3EXt
	 ni4Rh6cyUKYnFDO0ygNwWGuAihTkLw5o+XkkBY1yy3qm0icszuyQdv9lInBZVvuu0U
	 d7Lglb5mq2G+T5C5eySTB7+qFBkrVuDV8gpdbCMoPH6Jv8zVq3CwxD7qHfNmpggUeG
	 cZeXwg4At8Qz4dXPAcZLxSHK3oxh1f8aI8kaN6VFpFro7k5CtPI2RqqPrGs1UeDGS9
	 5CdaBM8OsYQ7UZkWBlKdJOanCi64itz5q/Wcsav5prMnvWrel4yCJcdIWg45MxI8nn
	 4dSFTLEWJYOfw==
Date: Wed, 06 Dec 2023 18:54:44 -0800
Subject: [GIT PULL 5/6] xfs: prevent livelocks in xchk_iget
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170191742703.1195961.7951432575370183295.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.8-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 9c07bca793b4ff9f0b7871e2a928a1b28b8fa4e3:

xfs: elide ->create_done calls for unlogged deferred work (2023-12-06 18:45:17 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-livelock-prevention-6.8_2023-12-06

for you to fetch changes up to 3f113c2739b1b068854c7ffed635c2bd790d1492:

xfs: make xchk_iget safer in the presence of corrupt inode btrees (2023-12-06 18:45:17 -0800)

----------------------------------------------------------------
xfs: prevent livelocks in xchk_iget [v28.1]

Prevent scrub from live locking in xchk_iget if there's a cycle in the
inobt by allocating an empty transaction.

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: make xchk_iget safer in the presence of corrupt inode btrees

fs/xfs/scrub/common.c |  6 ++++--
fs/xfs/scrub/common.h | 25 +++++++++++++++++++++++++
fs/xfs/scrub/inode.c  |  4 ++--
3 files changed, 31 insertions(+), 4 deletions(-)

