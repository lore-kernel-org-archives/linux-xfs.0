Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0C9EDE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881391; cv=none; b=UYFUm11EhBk6leMkbuty/3qzBybuxlmQ00J2R6PyR34mJvxS/VimuBWjckUbwVEnEjvOZJv9LoDf3tmavOphss32MtNANtOy6AtEGrtaLskrhDG9vHoj/EDec1AnY7uoYs2oiG1L5IJZfkXxqNrd21m1spN+ISYj9RWIVvblQ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881391; c=relaxed/simple;
	bh=uU0ruwiEnIGmrWdttxTebryCoIsGWJmOdUbR4+VSztI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GuieKmNylMcG13Pgu33wGbvkEiXa0TIIZSQh6nTDktHsll0Msga6OcAIunW67g01BwNYXH1N/+Df+aI3MzTh8T+COg+ZVoNXnGROO1r5IDKg9F4EwROqPhzkhn5p2nHB5W4jKrbK2ka7w2tzCWAnx1gPlL3dCXPCQ+zAdiRCxvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b6eU8gb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6eU8gb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD84C116B1;
	Tue,  2 Jul 2024 00:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881390;
	bh=uU0ruwiEnIGmrWdttxTebryCoIsGWJmOdUbR4+VSztI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b6eU8gb5SE9NT0MZFzV/ilZ2XBpNGraGl8WYP0t0JpWl3N5le6Jt6rp1VKc7sjr7M
	 5FZBh/WPFiKhHjzqk7JVbvAEYIQMvr8vEYSnc7nGOleHeIqwJ3h0bUXex+56uxOh7/
	 +WXrv9h+Tdt2BL2LMNNr6/I3KDM7EhsBP2IiiJflNsg6ezJfoO5+vl2v9Z7UBJ1cDY
	 Ttu4zjlMlOvqp3BivADirZfDIuEqm0nDt9DDzQrorRxH5lqYmyAfhSqDVVsAtpALqq
	 SMofNJmYGIblRRfir1FrJ/frt51n0K7s98bbl/9dA9iRP4/HCBv1viea2QrtqYrcmk
	 egy/3U7JlzKlA==
Date: Mon, 01 Jul 2024 17:49:50 -0700
Subject: [PATCHSET v30.7 02/16] xfsprogs: inode-related repair fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117219.2006964.1550137506522221205.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
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

While doing QA of the online fsck code, I made a few observations:
First, nobody was checking that the di_onlink field is actually zero;
Second, that allocating a temporary file for repairs can fail (and
thus bring down the entire fs) if the inode cluster is corrupt; and
Third, that file link counts do not pin at ~0U to prevent integer
overflows.

This scattered patchset fixes those three problems.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-repair-improvements

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-repair-improvements
---
Commits in this patchset:
 * xfs_{db,repair}: add an explicit owner field to xfs_da_args
 * libxfs: port the bumplink function from the kernel
 * mkfs/repair: pin inodes that would otherwise overflow link count
---
 db/namei.c          |    1 +
 include/xfs_inode.h |    2 ++
 libxfs/util.c       |   18 ++++++++++++++++++
 mkfs/proto.c        |    4 ++--
 repair/incore_ino.c |    3 ++-
 repair/phase6.c     |   13 ++++++++-----
 6 files changed, 33 insertions(+), 8 deletions(-)

