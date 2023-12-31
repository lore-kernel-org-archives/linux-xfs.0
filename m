Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0BB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vcy4jZx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C80C433C7;
	Sun, 31 Dec 2023 19:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052114;
	bh=N+Ux1aLEH9KxC3glPGnKIXuwtQuIirzcZ4Jil8yHZGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vcy4jZx5eFIq4krHuJzsK69LIromJ3fP9r+CgxizQCF64+Og+IIsJi1bhf6bZzk3t
	 ciAYSarq5w3DpS4hUJy00zTsxm3UkrrmNsMgYbLZoAyzhvVU+24a/ZUYyZ4gA4yHed
	 86LFLSk2Ysx51xHicO/VCvV8Wjl5tMHZgFurCPG7gXRw5D7LQjL8c1i7I3ZsWYjB14
	 zF/dcQFb+HdbWtHOIsHA4ZyV7gxr53fpk7EbSqB3SYwy30xsS3si1fPP0GAJNLCTR2
	 /TFSHBf8U8FjNf4/NfMQLYXC9470CMfEmX4cBkg/ZDbpZypl2wS0YoCJI6NuDxO7tm
	 ynQ8xCmTZ7lFA==
Date: Sun, 31 Dec 2023 11:48:33 -0800
Subject: [PATCHSET v29.0 34/40] xfs_scrub: fixes for systemd services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Neal Gompa <neal@gompa.dev>,
 linux-xfs@vger.kernel.org
Message-ID: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
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

This series fixes deficiencies in the systemd services that were created
to manage background scans.  First, improve the debian packaging so that
services get installed at package install time.  Next, fix copyright and
spdx header omissions.

Finally, fix bugs in the mailer scripts so that scrub failures are
reported effectively.  Finally, fix xfs_scrub_all to deal with systemd
restarts causing it to think that a scrub has finished before the
service actually finishes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-service-fixes
---
 debian/rules                     |    1 +
 include/builddefs.in             |    2 +-
 scrub/Makefile                   |   26 ++++++++++++++------
 scrub/xfs_scrub@.service.in      |    6 ++---
 scrub/xfs_scrub_all.in           |   49 ++++++++++++++++----------------------
 scrub/xfs_scrub_fail.in          |   12 ++++++++-
 scrub/xfs_scrub_fail@.service.in |    4 ++-
 7 files changed, 55 insertions(+), 45 deletions(-)
 rename scrub/{xfs_scrub_fail => xfs_scrub_fail.in} (62%)

