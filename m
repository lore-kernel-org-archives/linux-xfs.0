Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07A420ED
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444625; cv=none; b=iVHe0KkUZVgpHH2CRooTCxZHVaL1osyWLV7PsekHbQyx2pWIBsx8I5ZAc0i9dhhcf7Jgtnud1mUTl1/bkKPMk0Sfop7lI97WPRhIhP/77O2UU0osLMSrVZ03VgvyXFdqSViUI4ANR+jqVlsTsv2cqKPJyoub8Ayf6jH7BRJSoek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444625; c=relaxed/simple;
	bh=y2EGVlxpMytI8YY0li6Y/e98/u17vhlPzBQ62Atk5c8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=qbcZD+OPRgXyDxeL5DZjrIkYecebITVBbr4RZHucEI1z+GjVE+/HKIKu+XReyaiF1t/rWMmFPDQ8ZSsoqhv7hkDHubndcWa/Fjd1urQ1VNGYd/efhkA9wqwvRsI6baztrBHK0mnFhA9Kvty76J7Wb2Ll5sEtwK/zVQN8S0PE8VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Igazi9rp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Igazi9rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C84DC2BD10;
	Mon,  3 Jun 2024 19:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444625;
	bh=y2EGVlxpMytI8YY0li6Y/e98/u17vhlPzBQ62Atk5c8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Igazi9rpa5zQf+eDCNSU0B9NmxgusFDbah7e+8iQ6x/kEdP4Jni1fooWSLBfC69DT
	 Y5R0m78/FzEaheHbU5TmK7QOU9md/jFSZTb0Tnza8PN98c6FiU500GbvC3LXHMnfJ/
	 +mPNujLNfGNs1WGSJmKmZqwWqn7RZ4Ke9teqK3RTX9WxDSu9p7bOE4V0n4dvdYSgdq
	 21egGE+j3K3ihx99NalmoQpafyzx2khORT0Xo+NT6HkVSXvXgPnXl00yfF6ke93/Uk
	 PlNpSnT+E0/1zpTJJz42HMHNgts5i5/MTCClXT9a8akvk1hoSEMnmNyh0iH+lNd0A8
	 wO7PTf1hxRdHQ==
Date: Mon, 03 Jun 2024 12:57:04 -0700
Subject: [GIT PULL 10/10] mkfs: cleanups for 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171744444280.1510943.2749807167277775546.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240603195305.GE52987@frogsfrogsfrogs>
References: <20240603195305.GE52987@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 9a51e91a017bf285ea5fd5c5a6a7534e2ca56587:

xfs_repair: remove the old bag implementation (2024-06-03 11:37:42 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/mkfs-cleanups-6.9_2024-06-03

for you to fetch changes up to d1f942f19859103ccbca6ba7de9ed65024be2ae9:

mkfs: use libxfs to create symlinks (2024-06-03 11:37:43 -0700)

----------------------------------------------------------------
mkfs: cleanups for 6.9 [v30.5 11/35]

Clean up mkfs' open-coded symlink handling code.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs_io: fix gcc complaints about potentially uninitialized variables
xfs_io: print sysfs paths of mounted filesystems
mkfs: use libxfs to create symlinks

io/bulkstat.c            |  4 +--
io/fsuuid.c              | 68 +++++++++++++++++++++++++++++++++++++++++++++
libxfs/libxfs_api_defs.h |  1 +
man/man8/xfs_io.8        |  7 +++++
mkfs/proto.c             | 72 +++++++++++++++++++++++++-----------------------
quota/quota.c            |  2 ++
quota/quota.h            | 20 ++++++++++++++
quota/util.c             | 26 +++++++++++++++++
8 files changed, 164 insertions(+), 36 deletions(-)

