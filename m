Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33350BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928058; cv=none; b=TUHEyBl8qc9sb55i4y83pyuzUYryizVBV7S36M/hOwPX9VhtNr6KkVY1E3sogvSmHFxUCXm9H6hpo/buneTJ2PeZOxiKH9K7mVY8t49WFZ55iZAz1r4bLos1fuDOAG6Q1t/UDG9RkfzBhZHItqNDUTuhS5FUpSzNMSpOAZy+/EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928058; c=relaxed/simple;
	bh=Uepq5SFvRQOT0XmMTdLKY8fVJOr6Q53ZkxH8pyCKHaY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HCpIXsHoW/eslDKpAZWcuEB1f3sdLilPlnWn85zETsKV0ZmGQ7/07rAQkC9qqoinrO9yx6UCi7bFPY4E6QOw10vQ6j+zxdAVHJsilEq3nodFE4BjxcGVikAwgk4yMNpNRgx7haat/6/rGoBR5r4XmuRNHUycbHGfxB/AMVQuMwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+4W8GTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+4W8GTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059C3C116B1;
	Wed, 24 Apr 2024 03:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928058;
	bh=Uepq5SFvRQOT0XmMTdLKY8fVJOr6Q53ZkxH8pyCKHaY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c+4W8GTbXdZ930+e6NJOI8akY2YZaocVZeJqQ/9++j9VmvUw0cRvD2WtwVBOMlYwX
	 vIHL0cC3wJK4B9FZtAeeidjWQt1fDSr/B9hDbbtEvwe/K8JIYtm/5XprvhVbKhaLwd
	 5VRUc0svO+qvtS5gGef87eOKDta9zwkm2CiTHWOoWDLeLdY4ZwHd/TD5AdI9AU46X5
	 ufCvtMSgPcxZ3FFTsfSPAQyxja2OVE3dnsGTbh3NM8i1j1kPbowf9ZRc/CTsHlXfa/
	 nRbdFldyq5qoIeVJBP61D+b47IHIZPl5S6uGI0moIUBgHrx4E8p52ygsWDHCvjTRh0
	 7ojTVGIv8i2Kw==
Date: Tue, 23 Apr 2024 20:07:37 -0700
Subject: [PATCHSET v13.4 9/9] xfs: minor fixes to online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392786386.1907482.12122730497500276549.stgit@frogsfrogsfrogs>
In-Reply-To: <20240424030246.GB360919@frogsfrogsfrogs>
References: <20240424030246.GB360919@frogsfrogsfrogs>
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

Here are some miscellaneous bug fixes for the online repair code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fixes-6.10
---
Commits in this patchset:
 * xfs: drop the scrub file's iolock when transaction allocation fails
 * xfs: fix iunlock calls in xrep_adoption_trans_alloc
 * xfs: exchange-range for repairs is no longer dynamic
 * xfs: invalidate dentries for a file before moving it to the orphanage
---
 fs/xfs/scrub/attr_repair.c      |    3 ++
 fs/xfs/scrub/dir_repair.c       |    3 ++
 fs/xfs/scrub/nlinks_repair.c    |    4 ++-
 fs/xfs/scrub/orphanage.c        |   49 +++++++++++++++++----------------------
 fs/xfs/scrub/parent_repair.c    |   10 ++++++--
 fs/xfs/scrub/rtsummary_repair.c |   10 +++-----
 fs/xfs/scrub/scrub.c            |    8 ++----
 fs/xfs/scrub/scrub.h            |    7 ------
 fs/xfs/scrub/symlink_repair.c   |    3 ++
 fs/xfs/scrub/tempexch.h         |    1 -
 fs/xfs/scrub/tempfile.c         |   24 ++-----------------
 fs/xfs/scrub/trace.h            |    3 --
 12 files changed, 49 insertions(+), 76 deletions(-)

