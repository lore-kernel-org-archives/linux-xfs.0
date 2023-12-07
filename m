Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E741868
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9G8Xqkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AEDC433C8;
	Thu,  7 Dec 2023 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916207;
	bh=y27Cr0Ly2yIKplrzgv0jAuGumbfMgje3kLXeEfqnNgg=;
	h=Date:Subject:From:To:Cc:From;
	b=q9G8Xqkm9fK7UjazUqnCrnJ8Z1L8D8fzri28cYNawmbDm6NToO++qvjHOmF/LF085
	 oJCnMnN1psVIikCv6/leYViB/G1Ol0hyizK0l0PKgIwP2b2eLmRrgROGknmg9T4W9S
	 In2Gr71VaTLWCrZdWnVsny/x5jKoc8EPjwo0OsqE07Xznw+2fyLJuOfNRzYPQkzYmg
	 Sie1HxUH7SZOMg83SY7eeHoxzd+XVfe6C8tIWofByCcvo7/RUuul4BXVvwbejRT/mP
	 LqQOUpZEzMj0k4cRYARgG/w77MHFHSOHUP+7ycCTukYlPj0vWYeYIMmnDNC/uiBriE
	 liyGMba7qiHoA==
Date: Wed, 06 Dec 2023 18:30:07 -0800
Subject: [GIT PULL 4/5] xfs: elide defer work ->create_done if no intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191573238.1135812.13863112646073646742.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 4d6bd042de601ce29732060101df64725c925836:

xfs: don't allow overly small or large realtime volumes (2023-12-06 18:17:25 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/defer-elide-create-done-6.8_2023-12-06

for you to fetch changes up to d10115e529bba3a2b2b8194419a13d7dcff970dc:

xfs: elide ->create_done calls for unlogged deferred work (2023-12-06 18:17:25 -0800)

----------------------------------------------------------------
xfs: elide defer work ->create_done if no intent [v2]

Christoph pointed out that the defer ops machinery doesn't need to call
->create_done if the deferred work item didn't generate a log intent
item in the first place.  Let's clean that up and save an indirect call
in the non-logged xattr update call path.

v2: pick up rvb tags

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: document what LARP means
xfs: elide ->create_done calls for unlogged deferred work

fs/xfs/libxfs/xfs_defer.c | 4 ++++
fs/xfs/xfs_attr_item.c    | 3 ---
fs/xfs/xfs_sysfs.c        | 9 +++++++++
3 files changed, 13 insertions(+), 3 deletions(-)

