Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0B61B0406;
	Wed, 12 Mar 2025 23:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821046; cv=none; b=QDjMvUardgYy/aVUh9MkOlvEbooygOmHOmtTNOA0eukvz7PjgLZotnhWIz3S1qeAh9Q9FX/PaP22zEuLFQ/dEOpbJFrMsObo5NptpMlaOob1cCXyMKdifsdxEddvY4HdfWKg4xIo10cnGxiLAm5HRv4SpaMBa6N2dIcq0dsJ8HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821046; c=relaxed/simple;
	bh=pN88neFlEVXnGmoQ9DNG46EXKPtrDtlKe24JVlFUbio=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kHRrLtupcbi70XFOeMCmFZi1QvLN75F/eifHppM0x5UY4oTBJiDy5itZcaA+S1s5lgcqse81rsHZurMP0fIENiAc5bH0B22vDHnqenTjWilVrOPN+0Jt2G/EKcGooUOJZsI260m3VHxyLEQsFjiRJ0IPWHHa1BfokupJ09ZOEhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwJv8zvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwJv8zvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427CBC4CEDD;
	Wed, 12 Mar 2025 23:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741821046;
	bh=pN88neFlEVXnGmoQ9DNG46EXKPtrDtlKe24JVlFUbio=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VwJv8zvn8r1rX2VadAJBuHX5UHuYxYZ2yTf89yNeG6yWL63Rmttpjgepegb3GHrze
	 oz60vyOmgf+4iGAUUi+mhNYFamdP7RLCsTFJyHaQBzSsBQcZErAql2WEunMl5SEYz9
	 E79UwICCcRVkEmhpTmmtg8rW2JebidSmFLjG+7903ygZfZ/evHQJVM21J9f0ZoqVT/
	 /yz+VTMCwYq93JcqzKbpf4NL7hQTsYVEkyz0YWkwHvj8I11ESXDwME82gszROJdywp
	 YnDr8w7dh66v32vRbljO3C6aH5fgUJiyxrvijEksvxXPYHfF2plizPd5KbUpdDsiIK
	 JaHItCSzrdeHA==
Date: Wed, 12 Mar 2025 16:10:45 -0700
Subject: [PATCHSET 3/3] fstests: more random fixes for v2025.03.09
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
In-Reply-To: <20250312230736.GS2803749@frogsfrogsfrogs>
References: <20250312230736.GS2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * xfs/614: determine the sector size of the fs image by doing a test format
 * generic/537: disable quota mount options for pre-metadir rt filesystems
 * check: don't allow TEST_DIR/SCRATCH_MNT to be in /tmp
---
 check             |   14 ++++++++++++++
 tests/generic/537 |   17 +++++++++++++++++
 tests/xfs/614     |   13 ++++++++-----
 3 files changed, 39 insertions(+), 5 deletions(-)

