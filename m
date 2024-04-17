Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C147464
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395617; cv=none; b=npH5T9e7EbmmjIKRts/ryqzzH/iPMKgVrqj9iu26hJkx6yPTEVh0asiIoWDv2j59CIzWPJwWQTMacmSjfcSh5I3fChsvj12jscl8TSzdWY8u2DYWTjIaNtQWn46zz+yWKRGqS5FXUwdXAureEji3gOsfgfWRry/xyGdhQLXBs6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395617; c=relaxed/simple;
	bh=+i/wCCemSsZHYWqTtfEMIgJaKQJJ9Ob+GHGMCj/m1jM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cLM2E+oXKr0mb039XarARlHGkJ+pmYYbcpTBnYYvOcp8zd3uOTieb4ueHFlcbewv3tHEeRE+dsnnaBbAY+q/XwWoIRvsyAH1Rj7mnHAk5ROuTnNLRj0ZsBZxYxTDmokztzZc1NGLDpaNirgGGHqthGsEwvDm4uj6icUaboDPaiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0PJYgOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0PJYgOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C5EC072AA;
	Wed, 17 Apr 2024 23:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713395616;
	bh=+i/wCCemSsZHYWqTtfEMIgJaKQJJ9Ob+GHGMCj/m1jM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X0PJYgOWASwR2M4McGeuBCieNCjwdzInYJ7VhW3KhRcie/N4DyYKLpPBCz7JnlCLL
	 lMR22LqW7a9C/5V6+NmU58aiqi3lv+kuveyAYePQeEjXFft7EneGMxycnImyN+imC6
	 +vwqiHRHtnfVMvN3UIZ3NnjjacwMSriRbZQgZ85rP7EI0jxZtKQ+DsP0g8VGBp4b+K
	 CHyQjjEV2gjgmilQQCLoBSKUd+4y61rQ9fvh9USnp871LpIFUoI9BB5mxzLAOtttVl
	 o7HbEWJaATE++KedtuMEzkjo3tOxTVjFsvk/SCwWmC/YTzCp/zdmVN+hVfo+204FIt
	 9lY/PdXvge66Q==
Date: Wed, 17 Apr 2024 16:13:36 -0700
Subject: [PATCHSET v13.3 2/2] xfs: minor fixes to online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417231037.GD11948@frogsfrogsfrogs>
References: <20240417231037.GD11948@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fixes
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

