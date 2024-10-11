Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D4FC8C7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607015; cv=none; b=hBFWmEhdc74HS/xPFYYIKGlt8Plj4Ypk4H1Ky/m3qmqF/+msGdp+gcjiHag/w3cgfsFuuEghLcQV56VZkLcIxK3mUteuGqJFmUvE/cn72KL4iTJBMtzWYEFo/l1odLSYkiKYGs4pQ3asUsxqZwNKinxd2wrJXJRu23llBXQDidI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607015; c=relaxed/simple;
	bh=FZw6z+pBusOBlasrR39EX3tNDm5HxsDAyUsVq0sLfSk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isPlr5G4rP/rXfdwc1nmf+yxmNlAjaor6OD/lt7rmorrPnyPjj/ZilqNfgiR6cZSjiz4wobdPyI2ZKqYxlebIYwt2Y/xwPyuTJ3dg1g7jEwDqdRfZwvpa8MtqMjdtk+1zrw0MfDdbNSj6tI2jfEOfa1oFrh12GxJz1CqnuJpU3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGQzaMua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGQzaMua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4AAC4CEC5;
	Fri, 11 Oct 2024 00:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607014;
	bh=FZw6z+pBusOBlasrR39EX3tNDm5HxsDAyUsVq0sLfSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dGQzaMuaQ/eLrfKrPAGFJLFaSCszHg9rbj9c5aMsRzDq2N0QlmlRG3kDoZLLLdvlO
	 QbZ7lNtftilJSHxz7/PVbKfGfvJAXunVvszXk9llD0I/v37ULuv7n/RL8l6x7I5TWu
	 ri+jpKL8FuVgWwyc+73Qo6jqYdFejrTAWMM3PTT2ZLYvgo9rOev6VB9Qkj8KeOUbNO
	 YPggcGCiCHQ5yxqPmaF7y2MLNQXS09L1Hdg/niYdR59M9lj70kL+aWdNU4nxxqVpyG
	 ylNe1ICwLU/RV9dJHASEvpaPpz6fTy6Hd2kut57A/tQrfXziKw5Y+GvqHntqRWRPWN
	 6DDuiM2qD9QPA==
Date: Thu, 10 Oct 2024 17:36:54 -0700
Subject: [PATCHSET v5.0 5/5] xfsprogs: enable quota for realtime voluems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656815.4186363.7149995381387622443.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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

