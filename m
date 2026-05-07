Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9E934E74D
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 22:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778191877; cv=none; b=k4yuKpLfVXAlzVZUkZaXbOxMemYh3mFn4VZPHJ2ecVwjV00/ZcKUXHkJF1NSrUtomsOTVTFUFVacfHuUZMiWIbltQT6M9+nTcGK+U2p/HgD/SS8j4V5VmfOUCBMlFqVlmJiInuQqWm98hHte+ALBVfT4odbejedTBXB/zzMpHRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778191877; c=relaxed/simple;
	bh=TxnaDXKVVmt8t7KCTL4iuaf89atTAdL/L+1gHjhVkyE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=p4aA+1pZJlP/m43udYN2FBD6+Syd/Q9PAEoPC+3c9FFhXc48JUwls6EtgOR8IQ+4DN3EmYsai7dvwVop1xdECpHgqui5y/MdVMptFrKToPUakkXzmSfpaDG/4WwEE4r3g6NfjVkkrnNZofLksMYn3GrtymNrW9zRFmozojtktN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmT6Zcoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmT6Zcoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97B6C2BCB2;
	Thu,  7 May 2026 22:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778191876;
	bh=TxnaDXKVVmt8t7KCTL4iuaf89atTAdL/L+1gHjhVkyE=;
	h=Date:Subject:From:To:Cc:From;
	b=kmT6Zcozxpt8EbZU1mjdhayJwZZV0OqXhuASNl54Rpr9BnGY/+6wTRu/iGfJ/g+pu
	 6TCy6pfgacgoyeW3U7h/48lnjDCtWd/lNPt+SzI6o+pFX/O0+G60IQ7Pa3Xb81RBZ6
	 VwyCzVyiaaJLYQypBtnZtKM7sSdCK5WZKxpy8dYuO1Dasp2TPmjlJfRg3wOlzeXSxZ
	 7DZwi/Z3CCfwf1gb0eiERsgstHbz2tY3LkR6X+fw+hvOhss8gL1PzplZxm2B6+5Ghk
	 KqeLLqKjunaYs6UFt7JRSm4xMiIaOx6BtAnUenNoyIHsZR3H+sAWuRBHKAwI/Rrpgo
	 lSlUl2IiAUAhg==
Date: Thu, 07 May 2026 15:11:16 -0700
Subject: [PATCHSET 1/2] xfsprogs: various bug fixes for 7.1
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series contains miscellaneous bugfixes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * platform_defs.h: fix __counted_by_ptr annotation
 * xfs_scrub_all: remove dead code
 * xfs_scrub: remove dead code
---
 include/platform_defs.h   |    2 ++
 scrub/unicrash.c          |    7 -------
 scrub/xfs_scrub_all.py.in |    6 ------
 3 files changed, 2 insertions(+), 13 deletions(-)

