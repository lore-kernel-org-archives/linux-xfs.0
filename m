Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0A3189BBB;
	Tue, 31 Dec 2024 23:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688113; cv=none; b=Gge9JXK7pgmj9akqMru0Y5YHlRZHwUKr9BexjAblpigR7xiu9aFD1+dtllPkL6D6OKpZGN4k65qvssFawqgv5Hjo3oWdxhY0FFTlznNS5jPymzeAmybjhWg65kGL6ELoKXQEMTBVcy1pdm00SDEIxDpBmHf/ffeX3FtF+Kq32c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688113; c=relaxed/simple;
	bh=9jAeEHzN6Xx/7oHdXTT9SDTPZYKIagGmF+79rMqQ0Ew=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ks5UbsLNQksU2K7eCNN2AwhQTJy50cSPhFH8KiVmmh2JOlWdt35dy0InQ4goW2xmr7BEfVkwj3pqlykwmuXVx7dPfyJbbLu90aI9Y3jVxdQzm/Aeb/x4lWNvX5lFB+oDSPGxkl2ltxVSbSKmlmhH9pA4ik50tiYLkzsXplHYv8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sup69Zu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sup69Zu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2A9C4CED2;
	Tue, 31 Dec 2024 23:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688112;
	bh=9jAeEHzN6Xx/7oHdXTT9SDTPZYKIagGmF+79rMqQ0Ew=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sup69Zu8llMsnMXdN5jH9mwXDZQZJC2CqcDIFMbpXjk96XB9N66aEtDFsZnynL0xY
	 NnRPQlfDzHla/ptnyKAeZie48vQYU5QxQvewD+f5dcGTs3+HFNVXxr/N+2HEByKCRE
	 xVAoPaBxJklvbXC7Q9d9FO5RKIUKBJn9yM5nSdL2loVet3a8stlLy5WwoaDk1LvQok
	 jr4tR6NIRGCThqtjSsnOULFJSh5ggHMIanlIcBxcYU0FjbltXcuQrWQBjI9eo3Q/SW
	 DYfYUAF4TsmpvtN/Ey6OCoMotuSiVYYnbHLnpKgOuctMHY2Pa24G/qGY1TVg0ljt3c
	 hlOWm+adujVEQ==
Date: Tue, 31 Dec 2024 15:35:12 -0800
Subject: [PATCHSET 2/5] fstests: defragment free space
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568782405.2712030.4766560864446006648.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
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
Commits in this patchset:
 * xfs: test clearing of free space
---
 common/rc          |    5 ++++
 tests/xfs/1400     |   52 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1400.out |    2 +
 tests/xfs/1401     |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1401.out |    2 +
 5 files changed, 131 insertions(+)
 create mode 100755 tests/xfs/1400
 create mode 100644 tests/xfs/1400.out
 create mode 100755 tests/xfs/1401
 create mode 100644 tests/xfs/1401.out

