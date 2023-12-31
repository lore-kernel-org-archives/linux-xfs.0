Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85357BA2B;
	Sun, 31 Dec 2023 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u8YLqSQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E33C433C7;
	Sun, 31 Dec 2023 20:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052942;
	bh=TsH1uVhq90J01ie8UzlHeGCBAFKGg0CbrwJy35jj75k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u8YLqSQEVNoQpU0Mfndku+O48dGmmRcRaF/V4pe27oYg6Cwf11z6vax5Inh0xxz6L
	 ZymF5sW0/0I1SJbrgUAnOiiUn7XlAGBvcTyeTG++5PLpsDYKAi69V9W4Nila+eFYUj
	 w06TAkV+JFN0aiBC1xNtB6YIr2MI1WQWFezcIgsJq+su6b/DEkAyir72WMzXIt49nw
	 yi/mKa7KERQSh6spOpD8s/0LCBBuBVGZf81EKmIkrp8LUk83O9gOMOXyP2Z5uVjGu2
	 icy9IVFHHX89WqNH91DGqhz0CZBqFZmSAJn7vFyN/UXWHocwNPkOQ5xMF9+N5n5dmZ
	 H42NLK7LZ1zAg==
Date: Sun, 31 Dec 2023 12:02:21 -0800
Subject: [PATCHSET 1/2] fstests: functional test for refcount reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405033732.1828671.2206987916120651051.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182553.GV361584@frogsfrogsfrogs>
References: <20231231182553.GV361584@frogsfrogsfrogs>
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

Add a short functional test for the new GETFSREFCOUNTS ioctl that allows
userspace to query reference count information for a given range of
physical blocks.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=report-refcounts

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=report-refcounts

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=report-refcounts
---
 common/rc           |    4 +
 doc/group-names.txt |    1 
 tests/xfs/122.out   |    2 +
 tests/xfs/1921      |  168 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1921.out  |    4 +
 5 files changed, 177 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1921
 create mode 100644 tests/xfs/1921.out

