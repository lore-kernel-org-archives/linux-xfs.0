Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F83B11713
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294549; cv=none; b=aQQSqzLUIYgOE0Haxu6dIdwt66HZhVhHZqFr6U18nw8HdHjOMm/VatQi7gDt/7QpEzPsEaEoqWvhkXaVVSXECV+U44lVYvyvshPMgW8teJpJsCwxAzG2guKz+JtSSomYO8LIDTYjHKBPqE2qq+Sp32PgZ4/qegtUiyFtumzOTbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294549; c=relaxed/simple;
	bh=Begf0qvX5VDXJXNf90EVuQVjH+cCzndxQJjUYr0wfVY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AlAm6//UzuK1IAKq/lqB6/DCXRdJVMs/jGnAub9IcJn5dK00MTfMJEIxQ6+Ttp1hh7le0+cw7EpXBXliB3ipzEG/YKnJ92ZZH7HuCQ2R3Z7X6DNjNtdAtO2fAKhIlxvjfPAh56Bjyzyl/5GIIIGG9hYOaRyGhRwGwdLETf22Ujc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2zLrGG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2zLrGG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB17CC433C7;
	Wed, 13 Mar 2024 01:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294548;
	bh=Begf0qvX5VDXJXNf90EVuQVjH+cCzndxQJjUYr0wfVY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E2zLrGG+pRwJsCwjQNJoRqIdGvPhFU3mGTEVuclbvdE6QImLvyUACpMb+cgXBDeCg
	 7Bl6H4SfWNKhft3kv8cAlvzhxwYirCzQCI8AYH806/gTFW2RKLadwGVmKsN1pTukZN
	 WjKW7K518dhOkLAN9PsNLn3GC3x/b+qOW4wlGQTmvVvxMfhyy12RE5/dkQ1URENFyl
	 6Op/Ojk6A1cWUx5Vs1dV3poiRCvGq1dcU2gJDgANGBOYwAZ9baw2fCWX9qk1Wo9gmr
	 Hm59D+NU1RSTyPpXY85/mpbPVYuyCwkEWLtamkJWUs1+aq2GPn5rSBw1m05pkE14KP
	 jW9Tb0pk5Tlkw==
Date: Tue, 12 Mar 2024 18:49:08 -0700
Subject: [PATCHSET v29.4 08/10] xfs_repair: rebuild inode fork mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
In-Reply-To: <20240313014127.GJ1927156@frogsfrogsfrogs>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
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

Add the ability to regenerate inode fork mappings if the rmapbt
otherwise looks ok.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rebuild-forks
---
Commits in this patchset:
 * xfs_repair: push inode buf and dinode pointers all the way to inode fork processing
 * xfs_repair: sync bulkload data structures with kernel newbt code
 * xfs_repair: rebuild block mappings from rmapbt data
---
 include/xfs_trans.h      |    2 
 libxfs/libxfs_api_defs.h |   16 +
 libxfs/trans.c           |   48 +++
 repair/Makefile          |    2 
 repair/agbtree.c         |   24 +
 repair/bmap_repair.c     |  749 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/bmap_repair.h     |   13 +
 repair/bulkload.c        |  260 +++++++++++++++-
 repair/bulkload.h        |   34 ++
 repair/dino_chunks.c     |    5 
 repair/dinode.c          |  142 ++++++---
 repair/dinode.h          |    7 
 repair/phase5.c          |    2 
 repair/rmap.c            |    2 
 repair/rmap.h            |    1 
 15 files changed, 1227 insertions(+), 80 deletions(-)
 create mode 100644 repair/bmap_repair.c
 create mode 100644 repair/bmap_repair.h

