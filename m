Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31991CA78
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FU9icX2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D753C433C7;
	Tue,  5 Dec 2023 05:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701754562;
	bh=NaTdp3lOhH1hxpCEnazBJmtFeEYJSzWp0lxjWV38bs0=;
	h=Subject:From:To:Cc:Date:From;
	b=FU9icX2QFFei4Flr6mwFkcB8104Le+FzxRsemT2ufgIS9ZTjCAb4n41f5hwNH3pAv
	 7BV51lixnoUtyzzNHtpqZ1lrvxsEPxX0eVDYbfq4SIibZuBYosZZDT+YWlLozjkFec
	 Z0YPrijyUUv0iAwU0PtBOqNNz8YD+AEd1CxbcFcYAe7Jjf1Gv+aDJKJKDlO1AZZqx5
	 NmWWNwic4FZlypAsWUD97hPwR1qKLWnkDAiBBIleIKyUBujsYs3uDLjCMXZ8kTC0tZ
	 SkRQ3l2UVbCEg9pJlQF0I6aZVVq16fMC60GXBpk04nGuJ/qOyKkP7ZRjy9sRjwsKgB
	 8C0XQygevMACA==
Subject: [PATCHSET 0/2] xfs: elide defer work ->create_done if no intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Date: Mon, 04 Dec 2023 21:36:02 -0800
Message-ID: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs>
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

Christoph pointed out that the defer ops machinery doesn't need to call
->create_done if the deferred work item didn't generate a log intent
item in the first place.  Let's clean that up and save an indirect call
in the non-logged xattr update call path.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defer-elide-create-done-6.7
---
 fs/xfs/libxfs/xfs_defer.c |    4 ++++
 fs/xfs/xfs_attr_item.c    |    3 ---
 fs/xfs/xfs_sysfs.c        |    7 +++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

