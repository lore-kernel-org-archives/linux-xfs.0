Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A35C8CA;
	Sun, 31 Dec 2023 19:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKfbIvRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE83C433C7;
	Sun, 31 Dec 2023 19:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052629;
	bh=LqLUZursVvMo1wWB7+mEsO9KR18liySlVejnFr4QU78=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LKfbIvRuA5ZYwg3Q9y40ror4F1p4d8U3ARRN0X5BWU5WalqIViy89D2Nahrc+mULB
	 /XGFlZMzbYJ1IjBKBONROxeabS+HBNCkQDmFS58oP6xUCHd/13FoK4bTCnR2CKyHm+
	 MwLMmivNXLtBDPnhcMQLfxWtzsd3jmfKS3WEFtcdz0Fg7BcA+ZYik7DU4gyWM13Wxt
	 2qbq96NwouM8jprGJcIyhdg1UjbVKneJ1G2QPKlaqW8U2f+aCRzTpLJkqIN/WytBV6
	 O34UTL5bOcTjrcPENpAjJbFlWX2cWZ2jICUmaInv9r2Nj5q3p14dsNKk4fo+wfkZ01
	 Q6FIiwYvo+UWg==
Date: Sun, 31 Dec 2023 11:57:09 -0800
Subject: [PATCHSET 1/8] fstests: fuzz non-root dquots on xfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405025600.1821776.14517378233107318876.stgit@frogsfrogsfrogs>
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

During testing of online fsck part 2, I noticed that the dquot iteration
code in online fsck had some math bugs that resulted in it only ever
checking the root dquot.  Loooking into why I never noticed that, I
discovered that fstests also never checked them.  Strengthen our testing
by adding that.

While we're at it, hide a few more inode fields from the fuzzer, since
their contents are completely user-controlled and have no other
validation.  Hence they just generate noise in the test system and
increase runtimes unnecessarily.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuzz-dquots
---
 check           |   12 ++++++++++++
 common/fuzzy    |   27 ++++++++++++++++++++++++---
 common/populate |   14 ++++++++++++++
 tests/xfs/425   |   10 +++++++---
 tests/xfs/426   |   10 +++++++---
 tests/xfs/427   |   10 +++++++---
 tests/xfs/428   |   10 +++++++---
 tests/xfs/429   |   10 +++++++---
 tests/xfs/430   |   10 +++++++---
 tests/xfs/487   |   10 +++++++---
 tests/xfs/488   |   10 +++++++---
 tests/xfs/489   |   10 +++++++---
 tests/xfs/779   |   10 +++++++---
 tests/xfs/780   |   10 +++++++---
 tests/xfs/781   |   10 +++++++---
 15 files changed, 134 insertions(+), 39 deletions(-)

