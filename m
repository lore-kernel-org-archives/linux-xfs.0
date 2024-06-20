Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF32F84A4D
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924304; cv=none; b=c4++ndg6ge/QBsBCiden0Li2fkyXQUM02ZUUUkENsPEym7Yygi6W0Zz0D48IyGoiBftP2Ph2ex9owaaW5kvYFu5VJfRwZNEuC0y+KibsOJ3+zQ0ft7Tw+R8urqAAEKM1rGe9aDGaDWTnZGK6FYxIFDm8f/rbRkU9XWG2MJVzO94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924304; c=relaxed/simple;
	bh=1RyCS8XSL0BJqdXGk1Qa5soav43y9RJZIOhwGhTBzdo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NBFYxInDXotwesSjvY6ytce2JlgeIzBIwmzfZw+LU/jkUaU5WDLUY7cZHGVy2o+TrO+Gg/nxPc+r3Npgiqa/kVJUNp+cKOKt8l6sGt0RQE3p9KljHoD8675wHeGSMq0cpAsqZINlVHs+5jNyFmcVkOHdoWeGWnYfsqbMF9erldo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XoC9ggg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XoC9ggg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954BEC2BD10;
	Thu, 20 Jun 2024 22:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924304;
	bh=1RyCS8XSL0BJqdXGk1Qa5soav43y9RJZIOhwGhTBzdo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XoC9ggg28pCdXV93c94VfbFJyQiyzKkQqVMCTiMozNDTWaFPdE95jjpfrkrsJD7+y
	 aVxVdoljLqUDD/DyTxoXFPPxoK7JDJgkAHZSjF4zeptGOljTrwuLgp142bT16/zZ2w
	 Cx6pF0QYdgxfdyfdzU/ovqD17ntPmlpgYDzaCovlMnlQDuRMABNNPmFSZlw/aTef1n
	 PuCDEtAxUwadV2ZRY3yth2Xcg97rDkkIrcClqxTfGwia6w6DCRgMNrW23g8X3QxPlT
	 UAURKGLp334dql2f1ufNr9uO3A/TpQG5yqRxqMpugiV6ya5DmLU1xQJdr0Llm7/UPg
	 sCcLIA1QWk45w==
Date: Thu, 20 Jun 2024 15:58:24 -0700
Subject: [PATCHSET v3.0 5/5] xfs: enable FITRIM for the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Konst Mayer <cdlscpmv@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
In-Reply-To: <20240620225033.GD103020@frogsfrogsfrogs>
References: <20240620225033.GD103020@frogsfrogsfrogs>
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

One thing that's been missing for a long time is the ability to tell
underlying storage that it can unmap the unused space on the realtime
device.  This short series exposes this functionality through FITRIM.
Callers that want ranged FITRIM should be aware that the realtime space
exists in the offset range after the data device.  However, it is
anticipated that most callers pass in offset=0 len=-1ULL and will not
notice or care.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-discard

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-discard
---
Commits in this patchset:
 * xfs: enable FITRIM on the realtime device
---
 fs/xfs/xfs_discard.c |  252 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h   |   29 ++++++
 2 files changed, 274 insertions(+), 7 deletions(-)

