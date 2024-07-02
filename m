Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA725393
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881422; cv=none; b=A9umf52Rn/dwtzpR3YkaCbWI0dvw0mFDziTZcaRyROinCnrPZbBzVOQowCVOZMtBVXNDFAN+6AseG+zeWSVMxZYQhQrE1mrjDlI7JmUPP3pjI6L8RGf49jY6hRbouRbKqP6yiG1qSSttHiiwitZenLYQjIdUlR4WixVB9bFvZCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881422; c=relaxed/simple;
	bh=qqvw0jerX22UcCAuKU6NNIhRUXqvtH82XpAFyjdRoYI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ahfk6zawlepYPbGn2cvV3xTlB8Hy8kjE0t2emBBmFrVBFAYwsGfvvsC69MK/6qXE25UT3/X3G2Hd3ZkWfVbeGSzopn2w8fdKSaIsqzlQFEev8Wsj/ODkRqORlXCjlp3jjuRMX/tZLjJeY8tiBvOXKpW+YQzKNxesqezjzlbaeYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFuNpHiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFuNpHiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB82C116B1;
	Tue,  2 Jul 2024 00:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881421;
	bh=qqvw0jerX22UcCAuKU6NNIhRUXqvtH82XpAFyjdRoYI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YFuNpHiJ+2XotOiKd9cLESTl7tBukCD5hAo7ETHqxr60TQKHF0vmm2jo6eC8pOmD5
	 0z1gFKlK7F5ySSVUz8CMvHAlLQg5iwcH7uDDMyjXLPowp/owWeWmIFs28o6EPg5ant
	 4N4sMaWe1SK4Cta8Llyu9RkTaWGkkqDgFg5t8wLJv6OjUMLTs5uJDB15s4zxO5KkvR
	 rPpiNl+wUfenERZgqsARn+QUzM5Fsquo7BMvY+ID5eTcqsCpZZWTwv7tK3qp6nS+Hn
	 DH7xwjWG43Nl+QR+kbx4LC/xNSu/aDLHkHEtIyz3L5JgFUB2d0yc9YU0FzlmnGakdJ
	 166WlOFKnNqTQ==
Date: Mon, 01 Jul 2024 17:50:21 -0700
Subject: [PATCHSET v30.7 04/16] xfs_scrub: move fstrim to a separate phase
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
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

Back when I originally designed xfs_scrub, all filesystem metadata
checks were complete by the end of phase 3, and phase 4 was where all
the metadata repairs occurred.  On the grounds that the filesystem
should be fully consistent by then, I made a call to FITRIM at the end
of phase 4 to discard empty space in the filesystem.

Unfortunately, that's no longer the case -- summary counters, link
counts, and quota counters are not checked until phase 7.  It's not safe
to instruct the storage to unmap "empty" areas if we don't know where
those empty areas are, so we need to create a phase 8 to trim the fs.
While we're at it, make it more obvious that fstrim only gets to run if
there are no unfixed corruptions and no other runtime errors have
occurred.

Finally, reduce the latency impacts on the rest of the system by
breaking up the fstrim work into a loop that targets only 16GB per call.
This enables better progress reporting for interactive runs and cgroup
based resource constraints for background runs.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-phase
---
Commits in this patchset:
 * xfs_scrub: move FITRIM to phase 8
 * xfs_scrub: ignore phase 8 if the user disabled fstrim
 * xfs_scrub: collapse trim_filesystem
 * xfs_scrub: fix the work estimation for phase 8
 * xfs_scrub: report FITRIM errors properly
 * xfs_scrub: don't call FITRIM after runtime errors
 * xfs_scrub: don't trim the first agbno of each AG for better performance
 * xfs_scrub: improve progress meter for phase 8 fstrimming
---
 scrub/Makefile    |    1 
 scrub/phase4.c    |   30 +---------
 scrub/phase8.c    |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/vfs.c       |   22 +++++---
 scrub/vfs.h       |    2 -
 scrub/xfs_scrub.c |   11 +++-
 scrub/xfs_scrub.h |    3 +
 7 files changed, 184 insertions(+), 37 deletions(-)
 create mode 100644 scrub/phase8.c

