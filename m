Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EA7BA30;
	Sun, 31 Dec 2023 20:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcvPD5tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B721AC433C7;
	Sun, 31 Dec 2023 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052801;
	bh=s9OB6zcKv0gK0Cbbhj281ByPbNmwDRAEEHYHJ5LTOB0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mcvPD5tgM+n2I0Extjoq+cTHrOy5qNsnWbYUMdZiG15RR9nfqMsLkQ9NZgWXGUiKP
	 4EfOnIS37UoFHZga8opJ3pGtO7PXPhOg/fhCfCZmmIxzHI/ejeRsNIE51vay603Zuz
	 4/Htu3XuL1RKuJn1VyQCGuGxx9Ols/qkUOpvwT/V7vSj/0HWpmEyNGKuEN9VEAQH3r
	 2yxaJJcrzgIPEoS2ZWAnc/PZa4FSIU9englCtPJwkCuZlOKKsLDtbJz5W8iwcFDBTR
	 7ZFALmdSfUWL+Zq4O+EG89UPpMDDhBsBYAEO22VzGSFAvNnLqiGxy2hJWJ5G8E54Xz
	 ibyxlvNvDGmAw==
Date: Sun, 31 Dec 2023 12:00:01 -0800
Subject: [PATCHSET v2.0 1/9] fstests: test XFS metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
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

Adjust fstests as needed to support the XFS metadata directory feature,
and add some new tests for online fsck and fuzz testing of the ondisk
metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
 common/filter      |    7 +
 common/repair      |    4 
 common/xfs         |   96 +++++++++++-
 tests/xfs/007      |   16 +-
 tests/xfs/030      |    1 
 tests/xfs/033      |    1 
 tests/xfs/050      |    5 +
 tests/xfs/122.out  |    1 
 tests/xfs/153      |    5 +
 tests/xfs/1546     |   37 ++++
 tests/xfs/1546.out |  316 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1547     |   37 ++++
 tests/xfs/1547.out |   36 ++++
 tests/xfs/1548     |   37 ++++
 tests/xfs/1548.out |  318 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1549     |   38 +++++
 tests/xfs/1549.out |  330 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1550     |   37 ++++
 tests/xfs/1550.out |  434 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1551     |   37 ++++
 tests/xfs/1551.out |   35 ++++
 tests/xfs/1552     |   37 ++++
 tests/xfs/1552.out |  343 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1553     |   38 +++++
 tests/xfs/1553.out |  370 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/178      |    1 
 tests/xfs/1856     |    2 
 tests/xfs/1874     |  132 ++++++++++++++++
 tests/xfs/1874.out |   16 ++
 tests/xfs/206      |    3 
 tests/xfs/299      |    1 
 tests/xfs/330      |    6 +
 tests/xfs/509      |   21 ++-
 tests/xfs/529      |    5 -
 tests/xfs/530      |    6 -
 tests/xfs/739      |    9 -
 tests/xfs/740      |    9 -
 tests/xfs/741      |    9 -
 tests/xfs/742      |    9 -
 tests/xfs/743      |    9 -
 tests/xfs/744      |    9 -
 tests/xfs/745      |    9 -
 tests/xfs/746      |    9 -
 43 files changed, 2803 insertions(+), 78 deletions(-)
 create mode 100755 tests/xfs/1546
 create mode 100644 tests/xfs/1546.out
 create mode 100755 tests/xfs/1547
 create mode 100644 tests/xfs/1547.out
 create mode 100755 tests/xfs/1548
 create mode 100644 tests/xfs/1548.out
 create mode 100755 tests/xfs/1549
 create mode 100644 tests/xfs/1549.out
 create mode 100755 tests/xfs/1550
 create mode 100644 tests/xfs/1550.out
 create mode 100755 tests/xfs/1551
 create mode 100644 tests/xfs/1551.out
 create mode 100755 tests/xfs/1552
 create mode 100644 tests/xfs/1552.out
 create mode 100755 tests/xfs/1553
 create mode 100644 tests/xfs/1553.out
 create mode 100755 tests/xfs/1874
 create mode 100644 tests/xfs/1874.out

