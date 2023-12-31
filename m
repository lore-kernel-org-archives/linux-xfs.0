Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6DCB667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtZI4TcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E3DC433C9;
	Sun, 31 Dec 2023 19:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052192;
	bh=BriUhSgHNhuLqVgzllrLcAe9Aq2609axh4Swxlhir4w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZtZI4TcMTiRklJyTegOtVmEZ7dQoS0hJskOFh1wbIu8kPxJw21rgGUpC+0Q2TScMq
	 Y8LDgez4AxHGCn9oLc4ISb4Ykn6146I+5lsvFuV2svrvWRURBpfI/RasHM/jCF3oKP
	 nbzl5TT/TOTDtqyOgJXK086iSNbfPIr4lu/XUZFnOMOg62LyHu07/xQorUVOgEN2wv
	 oJElGVPT7s9hW8Dt6xs398W+5/2GQ/xYBesWAQFS9pboqB9cu/puBdJ06SU3TskQU1
	 aqay9RIP5GcsFyD61Dmmhz3eG/WbiLyQ+bwx287OUSBGSdiBb7YYgzMGp4SUkPBBr1
	 hUIQTXG5pTw1w==
Date: Sun, 31 Dec 2023 11:49:51 -0800
Subject: [PATCHSET v29.0 39/40] xfs_scrub: automatic optimization by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003711.1801869.9864337837460047947.stgit@frogsfrogsfrogs>
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

This final patchset in the online fsck series enables the background
service to optimize filesystems by default.  This is the first step
towards enabling repairs by default.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-optimize-by-default

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-optimize-by-default
---
 debian/rules         |    2 +-
 man/man8/xfs_scrub.8 |    6 +++++-
 scrub/Makefile       |    2 +-
 scrub/phase1.c       |   13 +++++++++++++
 scrub/phase4.c       |    6 ++++++
 scrub/repair.c       |   37 ++++++++++++++++++++++++++++++++++++-
 scrub/repair.h       |    2 ++
 scrub/scrub.c        |    4 ++--
 scrub/xfs_scrub.c    |   21 +++++++++++++++++++--
 scrub/xfs_scrub.h    |    1 +
 10 files changed, 86 insertions(+), 8 deletions(-)

