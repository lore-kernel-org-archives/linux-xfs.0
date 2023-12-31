Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F34ABA31;
	Sun, 31 Dec 2023 19:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEBXZ62U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664F1C433C8;
	Sun, 31 Dec 2023 19:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052770;
	bh=UB2AjkAQPGKOET5QPpK6vhRsnqbJgN3iVn+FEjMw/N8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XEBXZ62UZNlbXWIXYr2ZrCmdlJwPrDPnZMQDO8KFyGo7dU8avXeAZ6h7XOe5Z6/2+
	 XGscg6as+G8QC48nhAnowdb5Ob/laPlYLuxfkUsTclKbH1BvYiQyf1mjOhrbrCbfUg
	 gEo9jWV0tWKdeJFfgZXwW9fxZhTH5sr1ISBIIDWeGHuRuGJ/HtQ2FTQFZNotVBam+a
	 OW09TQq86ksGHuwMw0mv0MjTmnxxzjj+kJxiDVueb4CWW1o3FPpmOBZHa8IdBMrNaK
	 tDAaVKw9wCeNUfxfXXmDcpdEQmp2Gq8eID9wwj3MtC1ds5VFqsJWplCbQg0193m8CI
	 yZIoasKITpvJA==
Date: Sun, 31 Dec 2023 11:59:29 -0800
Subject: [PATCHSET v13.0 2/3] xfs: detect and correct directory tree
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170405028893.1825187.7753896310306155652.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

Historically, checking the tree-ness of the directory tree structure has
not been complete.  Cycles of subdirectories break the tree properties,
as do subdirectories with multiple parents.  It's easy enough for DFS to
detect problems as long as one of the participants is reachable from the
root, but this technique cannot find unconnected cycles.

Directory parent pointers change that, because we can discover all of
these problems from a simple walk from a subdirectory towards the root.
For each child we start with, if the walk terminates without reaching
the root, we know the path is disconnected and ought to be attached to
the lost and found.  If we find ourselves, we know this is a cycle and
can delete an incoming edge.  If we find multiple paths to the root, we
know to delete an incoming edge.

Even better, once we've finished walking paths, we've identified the
good ones and know which other path(s) to remove.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-directory-tree

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-directory-tree

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-directory-tree
---
 tests/xfs/1864     |   38 +++++++++++++
 tests/xfs/1864.out |    2 +
 tests/xfs/1865     |   38 +++++++++++++
 tests/xfs/1865.out |    2 +
 tests/xfs/1866     |  122 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1866.out |   19 ++++++
 tests/xfs/1867     |  133 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1867.out |   25 ++++++++
 tests/xfs/1868     |  121 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1868.out |   21 +++++++
 tests/xfs/1869     |  157 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1869.out |   32 +++++++++++
 tests/xfs/1870     |  146 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1870.out |   30 ++++++++++
 tests/xfs/1871     |   78 ++++++++++++++++++++++++++
 tests/xfs/1871.out |    2 +
 16 files changed, 966 insertions(+)
 create mode 100755 tests/xfs/1864
 create mode 100644 tests/xfs/1864.out
 create mode 100755 tests/xfs/1865
 create mode 100644 tests/xfs/1865.out
 create mode 100755 tests/xfs/1866
 create mode 100644 tests/xfs/1866.out
 create mode 100755 tests/xfs/1867
 create mode 100644 tests/xfs/1867.out
 create mode 100755 tests/xfs/1868
 create mode 100644 tests/xfs/1868.out
 create mode 100755 tests/xfs/1869
 create mode 100644 tests/xfs/1869.out
 create mode 100755 tests/xfs/1870
 create mode 100644 tests/xfs/1870.out
 create mode 100755 tests/xfs/1871
 create mode 100644 tests/xfs/1871.out

