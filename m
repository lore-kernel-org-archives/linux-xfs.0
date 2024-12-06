Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D2A212F96
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527785; cv=none; b=LBh36om46Gzpus/XcVmdmUrxSPThG+FDm47koelOvCGSo/vAMBq/BYdlSaR2rTPJ/It2fvLU4pRnr9hu/Vnvr+1pMPtD2PEzG0ykX1P2zAo3c31Q6EYU+UT5OeEbUpY0BfFCQekEMQF91IeIZg9WAipPzWp6I7TsM5TqXO2/ksQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527785; c=relaxed/simple;
	bh=FZw6z+pBusOBlasrR39EX3tNDm5HxsDAyUsVq0sLfSk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZEP5phd7XsPEdXmh0YtnrfIawipEPRveXzcQjPdjyD0oeCzqEDa+PJ4vFfy4txWt6MObZuZTMoP6WYmty17IBS8H1YEZRu4ROmqYxJjY/NiTXA4QfMjpmEe3vPqxA5YP4tkk+WFwTJcPd+zE9fQwD1pqCaYMFV76FQb0HR/fXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ozd8BT+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ozd8BT+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690D5C4CED1;
	Fri,  6 Dec 2024 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527785;
	bh=FZw6z+pBusOBlasrR39EX3tNDm5HxsDAyUsVq0sLfSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ozd8BT+9TwCXeyjFr1FtI5gZIdDnvDsS9nLlxZPNK2QLdru0EhwVHPzSNOX5gzIuZ
	 +eCi9on79cPak+cNtxWvo5SmZWX3m2Pqr0LBeIFzpUY78H2OhvXk2bNk2CN9rV7Jzo
	 w9MENG3JUR3AKs0wHrBpIEX0Cy3oNZboYQHN2zahsBevNwDYouSv5GV7OYEnxAr7qO
	 IN4jGF7IKyUw8zKkZCZ0aLOUB5T+3+FBhpQL422hC4dNYVHKY6TedvGSvas05AfGad
	 auvYn1caY0fzbxHifCZL1CXRtML+1BdCZ62+m4gl1wslBrA1MPB7gGijVHxavtVEly
	 RlofwtbwVHjQA==
Date: Fri, 06 Dec 2024 15:29:45 -0800
Subject: [PATCHSET v5.8 9/9] xfsprogs: enable quota for realtime voluems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352753955.129972.8619019803110503641.stgit@frogsfrogsfrogs>
In-Reply-To: <20241206232259.GO7837@frogsfrogsfrogs>
References: <20241206232259.GO7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that it nearly works: the only broken
pieces are chown and delayed allocation, and reporting of project
quotas in the statvfs output for projinherit+rtinherit directories.

Fix these things and we can have realtime quotas again after 20 years.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
Commits in this patchset:
 * xfs_quota: report warning limits for realtime space quotas
 * mkfs: enable rt quota options
---
 include/xqm.h   |    5 ++++-
 mkfs/xfs_mkfs.c |    6 ------
 quota/state.c   |    1 +
 3 files changed, 5 insertions(+), 7 deletions(-)

