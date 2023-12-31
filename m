Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A7DB65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gxUQxdkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D690C433C7;
	Sun, 31 Dec 2023 19:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052004;
	bh=6Vs7of+oKMjwlZT7+1zPkUuKmLtyAxS6w/4YkIF4+e4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gxUQxdkOeR/35b+0Kvpqsz4wrAzk1YHc74ntOhTwnsWB5NCO6tiritkVSiC0YQMNM
	 6hiZtl/T4JMU5lM2Ryp5WQX0nldjpEX0F9oRW8PzhOw8ALJPMV3WxgudJYjf6l/VZ6
	 hXhwVQTTL5O29zT7f/h3wDGTsIatx+mLxsnWzdLfskmRV7TTE1RX0SKmPekPAhVCSW
	 HA7u+3x+RJSdK5YS5Fr+V6AEt7Ru4G/nb14/ymrLjYxhRxkUTnA/L/SBUHNMoCeN6s
	 9VQlXsBoI3BZxnIambeXVrUS/4waajZ7pTD9B03nUv3ijwAymaIt1r8zA7uDVwYOM2
	 aJ2aPLlsEPOAQ==
Date: Sun, 31 Dec 2023 11:46:43 -0800
Subject: [PATCHSET v29.0 27/40] xfs_scrub: improve warnings about difficult
 repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
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

While I was poking through the QA results for xfs_scrub, I noticed that
it doesn't warn the user when the primary and secondary realtime
metadata are so out of whack that the chances of a successful repair are
not so high.  I decided that it was worth refactoring the scrub code a
bit so that we could warn the user about these types of things, and
ended up refactoring unnecessary helpers out of existence and fixing
other reporting gaps.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-better-repair-warnings
---
 man/man8/xfs_scrub.8 |   19 ++++++++++++++++++
 scrub/common.c       |    2 ++
 scrub/phase1.c       |    2 +-
 scrub/phase2.c       |   53 +++++++++++++++++++++++++++++++-------------------
 scrub/phase3.c       |   21 ++++++++++++++++----
 scrub/phase4.c       |    9 +++++---
 scrub/phase5.c       |   15 +++++++-------
 scrub/repair.c       |   47 ++++++++++++++++++++++++++++++++++----------
 scrub/repair.h       |   10 +++++++--
 scrub/scrub.c        |   52 +------------------------------------------------
 scrub/scrub.h        |    7 ++-----
 scrub/xfs_scrub.c    |   45 ++++++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrub.h    |    1 +
 13 files changed, 175 insertions(+), 108 deletions(-)

