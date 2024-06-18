Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39AD7483;
	Tue, 18 Jun 2024 00:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671589; cv=none; b=gX629Jd6ElYAladp7FmrvfSwP2F5rGjJfiilt4S84QC8b9h41brJSpoyOScClSqYnhD7JEOVg1gdLaQcKem9gjb5L0A41zbHbrcqVo/kOPbKbrFIsXZXgPeZjhYj+Ew3F+gZjbFik7yVolOfVwPuyaDjgGJSw4a/3AFHBLLlN4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671589; c=relaxed/simple;
	bh=GCZfA3vEJ+r0WBbg3uboUbqsMjzI/+q4AaCFm3i3TBE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=lQzcOjiqd7jyU9y4w2h1g3/MBt7K6JEHbW/rhONOjxh3VGBnJHQMinbvFAHjq27VFdkxttcZLY8wpwTu/WgpEiSaNTcp1xoftWggF8J/hoeREYV6e9ILfTe66q2HtViuz2C/9SVHujDQ80g/ImdR91cd23/hL3pUWCc1p9YbzF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JH9DAQgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JH9DAQgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FDAC2BD10;
	Tue, 18 Jun 2024 00:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671589;
	bh=GCZfA3vEJ+r0WBbg3uboUbqsMjzI/+q4AaCFm3i3TBE=;
	h=Date:Subject:From:To:Cc:From;
	b=JH9DAQgcrkE+CdS9oM6rVH41I6uZ4VofSmWieWVOlSeCKlj9RqIMbKz1paOeWNGGR
	 vYdh4VW1+18zK0/HNdfJg6YknByaSksBZe8AHmLN3JgURMZE3RZBAQ02lqoSp9j6fC
	 4gJXWu2tBgVNY1Psezx1MjR3uOTgBqUf0GrNaOct/GUHxTwcO0dPvacI8d+OyUpwwC
	 YHIQWooRsYWNwun9LCXhG7CSIfWtxPui/HWw9payEfHSg0le7gTID9kdlA/REmlkE+
	 wuVgSO4aBivH736lFZgGHCH2HiF72PvJJFPKkV/2jPCCAyjQWS8PJw4C3YbkI0YibC
	 ypo7GfB9mZ7Rw==
Date: Mon, 17 Jun 2024 17:46:28 -0700
Subject: [PATCHSET v30.6 4/6] xfs: detect and correct directory tree
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867146313.794337.2022231429195368114.stgit@frogsfrogsfrogs>
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
Commits in this patchset:
 * common/fuzzy: stress directory tree modifications with the dirtree tester
 * scrub: test correction of directory tree corruptions
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

