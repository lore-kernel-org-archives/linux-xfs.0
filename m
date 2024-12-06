Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB87206276
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527616; cv=none; b=VAD+D3EFyel5ChUHdrDybRReITfXQwUgVFaVR5f0Mm5qI+j6tUwgFofWTj0XMe3c3aTy00POm5nEHdRI/HTuzaSLCgIQN9r2nWJzW2OC9kzviF3NGxwBkasmR/EgF7+4aZEgkI9xlpVxilZjegw9HSKaX+i6bHLFus777ZCmVDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527616; c=relaxed/simple;
	bh=7FC7YDSodCZjnIiE0vwk5lqVjUMaICJpmXuHqEq63yE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YgJLpM/8pZkuSF+hljJo2Nrpyxo10tChvbUzM3p08oUTicS4F7wBmANWWqMB6HYGA5B7/uZiNbmHmUKBREUh9nb0y16I/2g2t/5NG9k2N8c7gEHMkbsHhRiFUR6/J+uDyHsRsQZ0D89VkI26sKiMRyD4z3CcnJMWzxRYihVT1qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcURBYoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcURBYoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB5CC4CED1;
	Fri,  6 Dec 2024 23:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527615;
	bh=7FC7YDSodCZjnIiE0vwk5lqVjUMaICJpmXuHqEq63yE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dcURBYoZdy8Z4Q1rgxpGgovKfUIYzygEsqmejI6XNOTyzRyWGiNJZEwU64Qr2xSk8
	 H+drAoSLIhjG4EW7ECooacRwbzpQ2agwnHR02ePd6dHwsEarm4LlWV2wv9nLKSvhdK
	 6NBgGKrWnYhTGvgfWsma6F4jfCNw01YSWLSiAymFlwHNJpk+YNn0EzSHuvAuxsA8o1
	 75lTzfijqzVcXFar6dsmHR7fGBBxvxGsXMpcGT52tEP4b3wRQ3wK7FgFipJWt1Aubn
	 tpfHWpzHddjr44oyjsBUj4uyUEZKOattsEhzai6w8coqZZxeW8e5gZuTl4hs9uGY0h
	 6vQPG1YMSL+XQ==
Date: Fri, 06 Dec 2024 15:26:54 -0800
Subject: [PATCHSET 1/9] xfsprogs: bug fixes for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: jpalus@fastmail.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352746299.121646.10555086770297720030.stgit@frogsfrogsfrogs>
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

Bug fixes for 6.12.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.12-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-6.12-fixes
---
Commits in this patchset:
 * man: fix ioctl_xfs_commit_range man page install
 * man: document the -n parent mkfs option
---
 man/man2/ioctl_xfs_commit_range.2 |    2 +-
 man/man8/mkfs.xfs.8.in            |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

