Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A979BA22;
	Sun, 31 Dec 2023 20:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7AUNE4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF59CC433C7;
	Sun, 31 Dec 2023 20:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052958;
	bh=+0N7sF7oyBtnuYyTg7f68ygc+0lS8T20lrAHD3coyhY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C7AUNE4z+iH8mzyEao41nf8qxIVtcqRdxHR6hjfOrzYZbAxFjYa10sOnmSU1Xh6Gj
	 ilUtEm8D4f8b87a+n5B7IrxiCAQkxWKKjuXzEjBJbi7rGVWxkaSgbQaW5dTtyAvjgE
	 f8aGOjvlIwEzZ6CbKX4rTc7ysiIZh3KAuRxFRRJFu1cCNtHLDqXzGrJURzLYzcScgo
	 Vffmgta6PTOYEZixbe90+chdL9dMy4HYZWIP6CwQx8/ZnhSsakYCIxw0Mu1ChrVTg3
	 xFaqff3+oNmAiTHCXs4Uy/hckT0N1p0beUjTliwhnBkwnrHeNQi/X1AV20TlrC42tp
	 tjNdRxr6+XpnA==
Date: Sun, 31 Dec 2023 12:02:37 -0800
Subject: [PATCHSET 2/2] fstests: defragment free space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405034074.1828773.1484406890502132195.stgit@frogsfrogsfrogs>
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

These patches contain experimental code to enable userspace to defragment
the free space in a filesystem.  Two purposes are imagined for this
functionality: clearing space at the end of a filesystem before
shrinking it, and clearing free space in anticipation of making a large
allocation.

The first patch adds a new fallocate mode that allows userspace to
allocate free space from the filesystem into a file.  The goal here is
to allow the filesystem shrink process to prevent allocation from a
certain part of the filesystem while a free space defragmenter evacuates
all the files from the doomed part of the filesystem.

The second patch amends the online repair system to allow the sysadmin
to forcibly rebuild metadata structures, even if they're not corrupt.
Without adding an ioctl to move metadata btree blocks, this is the only
way to dislodge metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defrag-freespace

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defrag-freespace

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=defrag-freespace
---
 common/rc          |    5 +++
 tests/xfs/122.out  |    1 +
 tests/xfs/1400     |   57 ++++++++++++++++++++++++++++++++++++
 tests/xfs/1400.out |    2 +
 tests/xfs/1401     |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1401.out |    2 +
 6 files changed, 149 insertions(+)
 create mode 100755 tests/xfs/1400
 create mode 100644 tests/xfs/1400.out
 create mode 100755 tests/xfs/1401
 create mode 100644 tests/xfs/1401.out

