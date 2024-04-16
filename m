Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDD78F5A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229068; cv=none; b=gZMzvyhlBiS4+QFM4rXjwgX8SpArwUCIWjQpxMO0d134OtDuIZTEPRL35QA6++YxQAqr52Kp57czuM4OVQ/2oEsM45VPJxjkZLgM8V9m72uzglWEDAeKSM8Qv0dsKp5JbOj7VZNTLBzONDXFDpSzeSOAtEwg7Yz59GVCPcQeWMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229068; c=relaxed/simple;
	bh=Hd+MRc/J+18CJt9lyouCEZVNUO0iD8p+YToomI9HT4Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebvlzLR0PB0uGo8jKjeD4XuEp8ZRsg85EtD/KGg/zQEoxmQXuIIbdtrVAM1YmrypXpphTTKb7ULYRMt8DkVx095/viqaHWqAA8MgoMmXsiQCpMCgeYr2Kk5+UMQKZhmORb1CH9nYNIC8GDPtgv490qbXDMEuZvz2i4SpFQfjUO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oCy5qWCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCy5qWCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2019C113CC;
	Tue, 16 Apr 2024 00:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229067;
	bh=Hd+MRc/J+18CJt9lyouCEZVNUO0iD8p+YToomI9HT4Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oCy5qWCETyW+tJIv5WRwrLRvpr7DVtR0p2w+lwGV07oXtIpikhBtuz/w1RJicOBah
	 lO6VUg1WvergyKh2tVjzxfJyesqauhpKfYj43oLL3KPubzep+5HYqqV7zyeQXrOPqR
	 ZYdtecK8dDJ5QW/Cp7CoZcXad4P/nJc6AKAmZkxT8ZsmGRKQk8LPp8Nj3R5bV6TZgU
	 yMpF69g36oJjr4a6SSJmkAvez0yD6eiRZVUlaQUwUyDgm4iHMT5UnUISeLj8Og71O1
	 ixUf/664ox7+H+flc6F/17U/urYvZ9eqUA+U7hQv7/wl5eCP27IFQxG4b6kMJ/NGAi
	 AdaLv3Z+lvbYQ==
Date: Mon, 15 Apr 2024 17:57:47 -0700
Subject: [PATCHSET 1/4] xfsprogs: bug fixes for 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Bill O'Donnell <bodonnel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
In-Reply-To: <20240416005120.GF11948@frogsfrogsfrogs>
References: <20240416005120.GF11948@frogsfrogsfrogs>
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

Bug fixes for xfsprogs for 6.8.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-6.8-fixes
---
Commits in this patchset:
 * xfs_repair: double-check with shortform attr verifiers
 * xfs_db: improve number extraction in getbitval
 * xfs_scrub: fix threadcount estimates for phase 6
 * xfs_scrub: don't fail while reporting media scan errors
 * xfs_io: add linux madvise advice codes
---
 db/bit.c             |   37 ++++++++++--------------
 io/madvise.c         |   77 +++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/attr_repair.c |   17 +++++++++++
 scrub/phase6.c       |   36 ++++++++++++++++++-----
 4 files changed, 137 insertions(+), 30 deletions(-)

