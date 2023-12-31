Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FF4BA30;
	Sun, 31 Dec 2023 20:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o5kaKWfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966A5C433C8;
	Sun, 31 Dec 2023 20:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052848;
	bh=Vw3oXrlmHJDQ3hxwZXEvg4rc+U4EmNUIuARRRh9jG+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o5kaKWfzDB+H6XhywlysOisiqntU9LwcjwgZwTopkyBMU83ZUmuXXuHQ/kaccz/fv
	 Z1vplFqIDaUrBhTcnpDe4YJ49gM2ztGSIqYKWWK+IpGNS+EHMjRr7kl7bCWweQg8ZI
	 t4S/SlZ8IK7WBxgkuQz4h2FGuIdd/iiSEaUwW3ZhjrCsxlGVGIWhuSxWZk+Q1TQBSI
	 a2T7PTEAFy7qTT2V12GVHU/QK+hfgD5UlqP94UTmxpPYFO1UvyJjRNlKyOUyixYXXZ
	 7PfFuQ6BWa+DyHGYNL8R1SvbBylm0qVdLoRy8mX3XhqKWB5t/s9r2KA9AZwM8m887c
	 OCI8+rqKvitJQ==
Date: Sun, 31 Dec 2023 12:00:48 -0800
Subject: [PATCHSET v2.0 4/9] fstests: fixes for realtime rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
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

Fix a few regressions in fstests when rmap is enabled on the realtime
volume.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-rmap

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-rmap
---
 common/populate    |   36 +++++++++++++++++++++++++
 common/xfs         |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/104      |    1 +
 tests/xfs/122.out  |    5 +---
 tests/xfs/1528     |   41 +++++++++++++++++++++++++++++
 tests/xfs/1528.out |    4 +++
 tests/xfs/1529     |   40 ++++++++++++++++++++++++++++
 tests/xfs/1529.out |    4 +++
 tests/xfs/1817     |   42 ++++++++++++++++++++++++++++++
 tests/xfs/1817.out |    2 +
 tests/xfs/1821     |   42 ++++++++++++++++++++++++++++++
 tests/xfs/1821.out |    2 +
 tests/xfs/1856     |   39 +++++++++++++++++++++++++++
 tests/xfs/1857     |   42 ++++++++++++++++++++++++++++++
 tests/xfs/1857.out |    2 +
 tests/xfs/272      |    2 +
 tests/xfs/276      |    2 +
 tests/xfs/277      |    2 +
 tests/xfs/291      |    3 +-
 tests/xfs/332      |    6 +---
 tests/xfs/332.out  |    2 -
 tests/xfs/333      |   45 --------------------------------
 tests/xfs/333.out  |    6 ----
 tests/xfs/337      |    2 +
 tests/xfs/338      |   30 ++++++++++++++++++---
 tests/xfs/339      |    5 ++--
 tests/xfs/340      |   25 ++++++++++++++----
 tests/xfs/341      |   12 +++-----
 tests/xfs/341.out  |    1 -
 tests/xfs/342      |    4 +--
 tests/xfs/343      |    2 +
 tests/xfs/406      |    6 +++-
 tests/xfs/407      |    6 +++-
 tests/xfs/408      |    7 ++++-
 tests/xfs/409      |    7 ++++-
 tests/xfs/443      |    9 ++++--
 tests/xfs/481      |    6 +++-
 tests/xfs/482      |    7 ++++-
 38 files changed, 466 insertions(+), 107 deletions(-)
 create mode 100755 tests/xfs/1528
 create mode 100644 tests/xfs/1528.out
 create mode 100755 tests/xfs/1529
 create mode 100644 tests/xfs/1529.out
 create mode 100755 tests/xfs/1817
 create mode 100644 tests/xfs/1817.out
 create mode 100755 tests/xfs/1821
 create mode 100644 tests/xfs/1821.out
 create mode 100755 tests/xfs/1857
 create mode 100644 tests/xfs/1857.out
 delete mode 100755 tests/xfs/333
 delete mode 100644 tests/xfs/333.out

