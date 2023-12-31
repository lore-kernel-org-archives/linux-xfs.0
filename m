Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1614BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaghexJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666BBC433C8;
	Sun, 31 Dec 2023 19:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052176;
	bh=r0DjmLkwf0eLiHaeJ320q685bqHy5SY8NcQ7MUFVnTc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZaghexJIS7DoJpp+Jl2LDv9U6EeIH0r2YJ20qCQyZ/wvVnwbE1fXKVpcy9Smpq7nY
	 ITlvviGM2nyaWczWTK1s9IBb+aSVfTXymzoG9bW8RI/nk78r7we31LJPtBOLH248Xw
	 xhwRdV+vBrB+kpVuEyNkc5uHaeMgQadGiMAF22nF1jRN5SDLAUw8TCHiGBluzib5dx
	 qF++c0Bar+d4i6dxpfh/QyayvrJkA587LjfXQL70qJGKxyQ8g0A/bRRSDPf92LH2k1
	 iiF/8zLmdOwkl3ro2QutHtHJdK1aTXyigVot4PSEhFNpFyt3UOZG8j2662tgJxyqMy
	 6XZt9yYilHiDQ==
Date: Sun, 31 Dec 2023 11:49:35 -0800
Subject: [PATCHSET v29.0 38/40] xfs_scrub_all: improve systemd handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003347.1801694.9862582977773516679.stgit@frogsfrogsfrogs>
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



If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-all-improve-systemd-handling
---
 debian/control         |    2 
 scrub/xfs_scrub_all.in |  279 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 209 insertions(+), 72 deletions(-)

