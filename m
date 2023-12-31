Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE9ABA2E;
	Sun, 31 Dec 2023 20:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsJvKcPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C5EC433C7;
	Sun, 31 Dec 2023 20:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052879;
	bh=97hScWk19NJxV1gTYHpfULVl835YUq7NLuXO24CF+Ik=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DsJvKcPJFmPPzw5zzwEYbPtDIAol+nhZKtCNYQeVPYv4j7tIKHC3DE4VuddUr/ltj
	 cfQxoDEnBsC2bjtCBXCEA/cslm1v6KKNdBG48d/YrdJiLX6/1UgreE8Z2ap2PtZFtS
	 24CP7Xpet5EPYNr9CYkcNrRB0ZAHDdZXl0si+B0U2eyIhZ9Klpw+FLLNSA8wyXt9x7
	 ne2xgbE+W9AThmaMt+zG5G8HGhplI6t1Oyi85o98shAeET8FT8EVbFTmblwsR4BgW7
	 SB32LYN+Q/ZCr/j+v96Lj2KIL6AaTXaaWk3Kqa+4Hu9jk/YtX8+PLxQsduzD3rtQnN
	 OiomJicsjVe+Q==
Date: Sun, 31 Dec 2023 12:01:19 -0800
Subject: [PATCHSET v2.0 6/9] fstests: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then widening of the
API parameters; and introduction of the new btree format and inode fork
format.  Next comes enabling CoW and remapping for the rt device; new
scrub, repair, and health reporting code; and at the end we implement
some code to lengthen write requests so that rt extents are always CoWed
fully.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-reflink
---
 common/populate       |   26 ++++++++++++++++++---
 common/xfs            |   15 ++++++++++++
 tests/generic/331     |   12 ++++++++-
 tests/generic/331.out |    2 +-
 tests/xfs/122.out     |    3 ++
 tests/xfs/131         |   48 --------------------------------------
 tests/xfs/131.out     |    5 ----
 tests/xfs/1538        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1538.out    |    4 +++
 tests/xfs/1539        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1539.out    |    4 +++
 tests/xfs/1540        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1540.out    |    4 +++
 tests/xfs/1541        |   42 +++++++++++++++++++++++++++++++++
 tests/xfs/1541.out    |    4 +++
 tests/xfs/1542        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1542.out    |    4 +++
 tests/xfs/1543        |   40 ++++++++++++++++++++++++++++++++
 tests/xfs/1543.out    |    4 +++
 tests/xfs/1544        |   40 ++++++++++++++++++++++++++++++++
 tests/xfs/1544.out    |    4 +++
 tests/xfs/1545        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1545.out    |    4 +++
 tests/xfs/1818        |   43 ++++++++++++++++++++++++++++++++++
 tests/xfs/1818.out    |    2 ++
 tests/xfs/1819        |   43 ++++++++++++++++++++++++++++++++++
 tests/xfs/1819.out    |    2 ++
 tests/xfs/1856        |    3 ++
 tests/xfs/240         |   13 +++++++++-
 tests/xfs/240.out     |    2 +-
 tests/xfs/272         |   40 +++++++++++++++++++++-----------
 tests/xfs/274         |   62 ++++++++++++++++++++++++++++++++++---------------
 32 files changed, 585 insertions(+), 95 deletions(-)
 delete mode 100755 tests/xfs/131
 delete mode 100644 tests/xfs/131.out
 create mode 100755 tests/xfs/1538
 create mode 100644 tests/xfs/1538.out
 create mode 100755 tests/xfs/1539
 create mode 100644 tests/xfs/1539.out
 create mode 100755 tests/xfs/1540
 create mode 100644 tests/xfs/1540.out
 create mode 100755 tests/xfs/1541
 create mode 100644 tests/xfs/1541.out
 create mode 100755 tests/xfs/1542
 create mode 100644 tests/xfs/1542.out
 create mode 100755 tests/xfs/1543
 create mode 100644 tests/xfs/1543.out
 create mode 100755 tests/xfs/1544
 create mode 100644 tests/xfs/1544.out
 create mode 100755 tests/xfs/1545
 create mode 100644 tests/xfs/1545.out
 create mode 100755 tests/xfs/1818
 create mode 100644 tests/xfs/1818.out
 create mode 100755 tests/xfs/1819
 create mode 100644 tests/xfs/1819.out

