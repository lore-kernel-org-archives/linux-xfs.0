Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB11BA2E;
	Sun, 31 Dec 2023 20:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oAWFD34l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A71FC433C7;
	Sun, 31 Dec 2023 20:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052911;
	bh=3+Quyh09QidfmcQPi+eCTcq8k/PlGZLC+uOkXRrEIAw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oAWFD34l9Nst0tvVUwy8BzKSHNGRKBtf7T321aLAKeqfEc8rV0IHteKpuwmw1QBPR
	 AFQUbyUxJeIu3tlobIhsl6esXu4gW6LtzE+7IQiL9tiybQFA+tje47ZGWaExopsoEC
	 cnWYUXIZKjU6btpCEDWCj0dJr3KokPlR5AU4v+RJQoqwKjbBjMjy8qo0UKvQN7Xf1t
	 5KI/or9E51pMnsOcRncyqKSPQajSNhGHwXxC2ZT9WGk8eoiYiYCMzydYXkWIw4d3cr
	 amWK8h96pyZ8/1udhDaVBqqRfkA78DpSHAa+OlAQmlaHWYoj4M2rSOmz5R+KCDbwsS
	 /D2InhSuzO1mQ==
Date: Sun, 31 Dec 2023 12:01:50 -0800
Subject: [PATCHSET v2.0 8/9] fstests: reflink with large realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032733.1827706.12312180709769839153.stgit@frogsfrogsfrogs>
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

Now that we've landed support for reflink on the realtime device for
cases where the rt extent size is the same as the fs block size, enhance
the reflink code further to support cases where the rt extent size is a
power-of-two multiple of the fs block size.  This enables us to do data
block sharing (for example) for much larger allocation units by dirtying
pagecache around shared extents and expanding writeback to write back
shared extents fully.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink-extsize

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink-extsize

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink-extsize
---
 common/rc          |   23 +++++++
 common/reflink     |   27 ++++++++
 tests/generic/145  |    1 
 tests/generic/147  |    1 
 tests/generic/261  |    1 
 tests/generic/262  |    1 
 tests/generic/303  |    8 ++
 tests/generic/331  |    1 
 tests/generic/353  |    2 -
 tests/generic/517  |    1 
 tests/generic/657  |    1 
 tests/generic/658  |    1 
 tests/generic/659  |    1 
 tests/generic/660  |    1 
 tests/generic/663  |    1 
 tests/generic/664  |    1 
 tests/generic/665  |    1 
 tests/generic/670  |    1 
 tests/generic/672  |    1 
 tests/xfs/180      |    1 
 tests/xfs/182      |    1 
 tests/xfs/184      |    1 
 tests/xfs/1919     |  163 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1919.out |   84 +++++++++++++++++++++++++
 tests/xfs/192      |    1 
 tests/xfs/1926     |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1926.out |    2 +
 tests/xfs/200      |    1 
 tests/xfs/204      |    1 
 tests/xfs/208      |    1 
 tests/xfs/315      |    1 
 tests/xfs/326      |    6 ++
 tests/xfs/420      |    3 +
 tests/xfs/421      |    3 +
 tests/xfs/792      |    1 
 35 files changed, 520 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1919
 create mode 100644 tests/xfs/1919.out
 create mode 100755 tests/xfs/1926
 create mode 100644 tests/xfs/1926.out

