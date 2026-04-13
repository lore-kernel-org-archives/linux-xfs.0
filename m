Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A54F341649;
	Mon, 13 Apr 2026 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102516; cv=none; b=RWB8Hc0Qo9fhxep2xulDKYB0umTuWcO7YyI1cVdjtktCdqlxR3aEjWPQs1y8gao++hh4JNmNutbMgBARnYap263rgozz0GNH1aAF1/cLIlPo++UbpS7sIhxrDLHWxpKyTcz9ml7H2PG9bWfpcT6jxxZjVGNxnrteZwzuDEu+hjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102516; c=relaxed/simple;
	bh=EX3Qcx6NExmcWUP2t4ZSGuwfXRfMPiU39qnoThi/uoc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=L3fnp4RTe1Utyb6gvijWs+jaCg/hEFiMyfWNenkIYoTkOL1y+jx8tW/U3UH9GdDlm5tLBEotENtbicFj7ARnnWF+gsCbZwQB5cMJKAiEptcDyobkDd7VunSBVHkpaSGbCMnUyB64We5tlLYHwuDxU54q2j6DJ2qcvSWI9wHhOYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xh/SkBGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xh/SkBGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73E6C2BCAF;
	Mon, 13 Apr 2026 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776102515;
	bh=EX3Qcx6NExmcWUP2t4ZSGuwfXRfMPiU39qnoThi/uoc=;
	h=Date:Subject:From:To:Cc:From;
	b=Xh/SkBGAMJKqfq81omO+zyFzsRRlTg/zN3h4VSd3W17ECxab4JdUXgXtBTDMHwsr9
	 GWiJS1ZKHgDIQNeUfOUOAFHqftyKZZR90iGwxvkPv5qx6F5YXY/a+1DvdJZXkn8/Uc
	 QAtl150PycckEzKa7vAyd2PLjrcSDoT3GouhSPgKjcw+GsbGPvHgt+nGBhMtRdsXpq
	 ZS9GgPE4+6N9dLAlrbNHTtOIhLDqYwjmk/A8PTdHD445vtum0mSfYQkrhQOLkt498+
	 z8v9Vo3Lvw6JNGbi3Iv5rXROdiWGMrko4FiWmF+MBHi6l9iZhcwCOKfesM/fj1nos7
	 Lwim8+jrcjNFw==
Date: Mon, 13 Apr 2026 10:48:35 -0700
Subject: [PATCHSET 1/2] fstests: more random fixes for v2026.02.26
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177610246638.110415.16445576460857112820.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.

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
 * xfs/841: actually compare the new filesystem contents to the proto dir
---
 tests/xfs/841 |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

