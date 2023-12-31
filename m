Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF8EC8CF;
	Sun, 31 Dec 2023 19:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEcFi5e5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE1AC433C7;
	Sun, 31 Dec 2023 19:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052660;
	bh=Gx2PEOuynK9W8e+oonaw6/QAJXACSwAJZCw4F4dzCes=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GEcFi5e54tXB34B9leTtTf2NScr+viOKPKZnrNytcWhe10TqqBI3YAVFUsydVolef
	 pIyUpFvIBqkLuPyHXk9qbb6D4NPwHetWJjy7ifChRdDk+cpq2/6dmfbunrp9fX0cb0
	 5yv4ZRd+CIBlzjYpkSDcGW8sWPtME04t0nH25vGlpiqDRK/pui2dLPSrc37i48YE65
	 w/jd5JgNXrN+J21dmMDGoLZ7Ah3U/wYoeCNLna18as3KjQiwqYSxbuSP3sQyro9YRW
	 EvwrWDjDq5dzgX7fitcjMsaDHxBscAbZCptKnwlo5nSPK6fyvHK2mIKWCbQw1PvRKf
	 LCrsZhYERe9Fg==
Date: Sun, 31 Dec 2023 11:57:40 -0800
Subject: [PATCHSET v29.0 3/8] fstests: establish baseline for fuzz tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405026226.1823639.16368830178504929409.stgit@frogsfrogsfrogs>
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

Establish a baseline golden output for all current fuzz tests.  This
shouldn't be merged upstream because the output is very dependent on the
geometry of the filesystem that is created.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuzz-baseline
---
 tests/xfs/350.out |   91 +++++++++
 tests/xfs/351.out |   75 +++++++
 tests/xfs/353.out |   96 ++++++++++
 tests/xfs/354.out |   87 +++++++++
 tests/xfs/355.out |   47 +++++
 tests/xfs/356.out |   13 +
 tests/xfs/357.out |  109 +++++++++++
 tests/xfs/358.out |    5 
 tests/xfs/360.out |   30 +++
 tests/xfs/361.out |   14 +
 tests/xfs/362.out |    5 
 tests/xfs/364.out |    6 +
 tests/xfs/366.out |    6 +
 tests/xfs/368.out |    8 +
 tests/xfs/369.out |   57 ++++++
 tests/xfs/370.out |  417 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/371.out |  108 +++++++++++
 tests/xfs/372.out |    5 
 tests/xfs/374.out |   35 +++
 tests/xfs/375.out |   94 +++++++++
 tests/xfs/376.out |   22 ++
 tests/xfs/377.out |   62 ++++++
 tests/xfs/378.out |   22 ++
 tests/xfs/379.out |   74 +++++++
 tests/xfs/381.out |    1 
 tests/xfs/382.out |    4 
 tests/xfs/383.out |    4 
 tests/xfs/384.out |   38 ++++
 tests/xfs/385.out |   68 +++++++
 tests/xfs/386.out |   28 +++
 tests/xfs/388.out |  535 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/392.out |    7 +
 tests/xfs/394.out |   12 +
 tests/xfs/398.out |   38 ++++
 tests/xfs/399.out |   63 ++++++
 tests/xfs/400.out |   26 +++
 tests/xfs/401.out |   72 +++++++
 tests/xfs/402.out |    7 +
 tests/xfs/404.out |   33 +++
 tests/xfs/405.out |    5 
 tests/xfs/410.out |    6 +
 tests/xfs/412.out |   21 ++
 tests/xfs/413.out |   48 +++++
 tests/xfs/414.out |   23 ++
 tests/xfs/415.out |   56 ++++++
 tests/xfs/416.out |   22 ++
 tests/xfs/417.out |   56 ++++++
 tests/xfs/418.out |   90 +++++++++
 tests/xfs/425.out |  258 ++++++++++++++++++++++++++
 tests/xfs/426.out |  132 +++++++++++++
 tests/xfs/427.out |  258 ++++++++++++++++++++++++++
 tests/xfs/428.out |  132 +++++++++++++
 tests/xfs/429.out |  258 ++++++++++++++++++++++++++
 tests/xfs/430.out |  132 +++++++++++++
 tests/xfs/453.out |  152 +++++++++++++++
 tests/xfs/454.out |   96 ++++++++++
 tests/xfs/455.out |  134 +++++++++++++
 tests/xfs/456.out |  129 +++++++++++++
 tests/xfs/457.out |    5 
 tests/xfs/458.out |   44 ++++
 tests/xfs/459.out |    5 
 tests/xfs/460.out |    6 +
 tests/xfs/461.out |    6 +
 tests/xfs/462.out |    8 +
 tests/xfs/463.out |  525 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/464.out |    5 
 tests/xfs/465.out |   71 +++++++
 tests/xfs/466.out |   51 +++++
 tests/xfs/467.out |   47 +++++
 tests/xfs/469.out |    8 +
 tests/xfs/470.out |   79 ++++++++
 tests/xfs/471.out |    7 +
 tests/xfs/472.out |    7 +
 tests/xfs/474.out |    7 +
 tests/xfs/475.out |    6 +
 tests/xfs/477.out |   79 ++++++++
 tests/xfs/478.out |   91 +++++++++
 tests/xfs/479.out |    7 +
 tests/xfs/480.out |   24 ++
 tests/xfs/483.out |    6 +
 tests/xfs/484.out |   45 ++++
 tests/xfs/485.out |   51 +++++
 tests/xfs/486.out |   46 +++++
 tests/xfs/487.out |  242 ++++++++++++++++++++++++
 tests/xfs/488.out |  242 ++++++++++++++++++++++++
 tests/xfs/489.out |  242 ++++++++++++++++++++++++
 tests/xfs/496.out |   24 ++
 tests/xfs/498.out |   12 +
 tests/xfs/730.out |   10 +
 tests/xfs/734.out |    9 +
 tests/xfs/737.out |   14 +
 tests/xfs/747.out |  152 +++++++++++++++
 tests/xfs/748.out |   96 ++++++++++
 tests/xfs/749.out |  134 +++++++++++++
 tests/xfs/750.out |  129 +++++++++++++
 tests/xfs/751.out |    5 
 tests/xfs/752.out |   44 ++++
 tests/xfs/753.out |    5 
 tests/xfs/754.out |    6 +
 tests/xfs/755.out |    6 +
 tests/xfs/756.out |   61 ++++++
 tests/xfs/757.out |  525 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/758.out |    5 
 tests/xfs/759.out |   94 +++++++++
 tests/xfs/760.out |   64 ++++++
 tests/xfs/761.out |   66 +++++++
 tests/xfs/762.out |    1 
 tests/xfs/763.out |    8 +
 tests/xfs/764.out |   92 +++++++++
 tests/xfs/765.out |    7 +
 tests/xfs/766.out |   11 +
 tests/xfs/768.out |    7 +
 tests/xfs/769.out |    6 +
 tests/xfs/771.out |   91 +++++++++
 tests/xfs/772.out |   93 +++++++++
 tests/xfs/773.out |    7 +
 tests/xfs/774.out |   24 ++
 tests/xfs/775.out |    6 +
 tests/xfs/776.out |   59 ++++++
 tests/xfs/777.out |   69 +++++++
 tests/xfs/778.out |   60 ++++++
 tests/xfs/779.out |  296 +++++++++++++++++++++++++++++
 tests/xfs/780.out |  296 +++++++++++++++++++++++++++++
 tests/xfs/781.out |  296 +++++++++++++++++++++++++++++
 tests/xfs/782.out |   12 +
 tests/xfs/783.out |  210 +++++++++++++++++++++
 tests/xfs/784.out |   10 +
 tests/xfs/785.out |   23 ++
 tests/xfs/787.out |   23 ++
 tests/xfs/788.out |   23 ++
 130 files changed, 9585 insertions(+)

