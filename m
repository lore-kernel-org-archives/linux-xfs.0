Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2D6B666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITx0PIsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119D4C433C7;
	Sun, 31 Dec 2023 19:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052067;
	bh=+LS3HF7RonAzoWFRi0Sshy+5WLL0Nk3FmpJNaalhmy0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ITx0PIsP7zidevOiRSdDxEOpcWYCwYosTuHr8UoerHBrRCWygDDvRuB9Ky3MOxUQj
	 Ei1spLBXfIxoah1E7uc/myO9Gu37X2P5LeceviY5NN+6lgE54a9oXA2vRKImpOQ0fZ
	 cRWoyziD3Cd8vhbgUi0WUUSMgmj3C0atTQDSUWHu8mgCICw+X2Tyy44fv7hO0w5mTX
	 9PiXM4hEPWUHfx4dUdaoxjU0R+VfJByqs/sdYiw2AJAwXJsD7Nzw18WB9Olp7lH/mr
	 IfY6Y16CS4US2PxyrwvjjbPxxZaxbP8GgjYMu6Jv5/xQa9dDQlNoiFFT8BSnG8oAsK
	 DoDHUZkEMSAjQ==
Date: Sun, 31 Dec 2023 11:47:46 -0800
Subject: [PATCHSET v29.0 31/40] xfs_scrub: detect deceptive filename
 extensions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

In early 2023, malware researchers disclosed a phishing attack that was
targeted at people running Linux workstations.  The attack vector
involved the use of filenames containing what looked like a file
extension but instead contained a lookalike for the full stop (".")
and a common extension ("pdf").  Enhance xfs_scrub phase 5 to detect
these types of attacks and warn the system administrator.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-detect-deceptive-extensions

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-detect-deceptive-extensions
---
 scrub/unicrash.c |  530 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 424 insertions(+), 106 deletions(-)

