Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9529C33EC
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831129; cv=none; b=n/+RbbkmQbl0mlNp04W12cc/H51vptMfaZnpkMu484FutcTZsdiPhLwd5Gv35BZrDXfkgrPGqYpGjutSe464cDYiICP4v6/5dnAqeZ3gBJ9zIAYzG9dzChMQeYI73370xZkkotK9hlg0s+eSiP27/Zl2Es9YIwzAmb5kt8X6ch8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831129; c=relaxed/simple;
	bh=75kH6lie3E0KifqG64DF4D0Y5ICzc2IZ/YEj9BlfuwQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSH8582YReuOL5CcpXc0BJUTo2vSpnpwMxw/30LtNVM5TJOZZbw+dS754KNx81qH117sO9RK7zkokqd+V6dBSsd3QNJCvIGuYoHRNemsvLJOEBbZdL0c4+tJW+Iqw4RGx6dzTbeyNakpADPqXw4iuQUciZhMDT6GtBcyECb3lo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rfWeiB37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rfWeiB37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F81C4CED7;
	Wed,  2 Oct 2024 01:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831129;
	bh=75kH6lie3E0KifqG64DF4D0Y5ICzc2IZ/YEj9BlfuwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rfWeiB373PL7NjTdBoN3AYKk8zriI4b73nMXrKMsB2lEYHSLZbZdCK+DOUY+QlwxX
	 LUhomvBJ0S5kHk5ke0p6lWHrX9Gt3bbLgrAWy5/FwYqTm+MU3J90OLGbV9yW2unNN9
	 w9wrKfm1R4lkgxbnlXnH2PJdlXx9f2EcZz3OUFOg6wGH4n7iRGJjbh4PaKGxMFLslM
	 PSJP3zut74O8NVhGZsNMlIpOYfFUeYSbGfqEW9l4+BiZx2zpDnaCBrvvmsrGGY2ouO
	 oCy2fajHhk++/uAr0+6sCd/1Bad38C4qw5zGwgxtEVLd9Dt3PO+xTc4Y6J1RfT6Hhp
	 D7QviTkeY0M4g==
Date: Tue, 01 Oct 2024 18:05:28 -0700
Subject: [PATCHSET 5/6] xfs_repair: cleanups for 6.11
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
In-Reply-To: <20241002010022.GA21836@frogsfrogsfrogs>
References: <20241002010022.GA21836@frogsfrogsfrogs>
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

Clean up crufty old code and fix bugs in xfs_repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-cleanups-6.11
---
Commits in this patchset:
 * xfs_repair: fix exchrange upgrade
 * xfs_repair: don't crash in get_inode_parent
 * xfs_repair: use library functions to reset root/rbm/rsum inodes
 * xfs_repair: use library functions for orphanage creation
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/incore_ino.c      |    2 -
 repair/phase2.c          |    2 -
 repair/phase6.c          |  182 +++++++++++++---------------------------------
 4 files changed, 54 insertions(+), 134 deletions(-)

