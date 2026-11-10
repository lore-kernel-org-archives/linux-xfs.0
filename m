Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337462;
	b=nLa45gC8VYKqcX6R/fyHHdFllb2AAQTKVw5L3yGx2y5ya61AhHxAZOI7rzugULMWuO7X
	 rzMNuwWXAXVJfGJ1KrtPein5NBeKCJU2ISEo9aaT+36fvT6BXgSVHtFWxOo8pdGIkGdJj
	 dfaK4xHYcevaBxhDJrQAYCzuAeX0dd8T4QouIhiHO6S+cwJXVuStW0z3NZALMwJbp3O0J
	 8I6P68yMWkuTZNrZVViGcrVJRiXQKtfkMiQBhdzehhaYJksAr71kRKdqhpPGycBzFrzGg
	 45dMlfvb9LoEeR6fGjIA5e3XNLvtMQXj3A0cF7cwh0gg70lgdSarO/gAFig1pO/aBJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337462;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jot0meT61nYpnJvABWxTHeYzg5H0PbUz/w5w4CVIwGs=;
	b=xLCKo7I7GEAFlhjyNmnfxTzet5vWWwgPlst/v8kOqingNhYoAf8CYAeweMcG3EBTYQPd
	 Gh+DIdhTSybb5WIc38Wkua1mfxAWITkYCl+2R9XlPlItAUiYXQCLpSlVIZQhagDyxxCuP
	 yUDUU4Xsdx4FOm2m3hhHdz73iQMIg705/2BbH3PRCQf/dVqD1QcbVP0KCyVVUSn0lQTlz
	 1ZdXuvhxYcWthsgLKXxzzMcOBPve0ikO03AOiBNDqpc1yd3Wb9Vi/tWD4qu7AkEKGp/QK
	 sAy/eDpLDLCA0KWa2a4ClY9sWXpbv827F1pVtS1hlEkOBY0zeKkA97vHtW9K21pXSQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bYqabPnj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E319606A31C;
	Tue, 10 Nov 2026 19:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bYqabPnj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7838A1F008A1;
	Tue, 10 Nov 2026 19:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337461;
	bh=jot0meT61nYpnJvABWxTHeYzg5H0PbUz/w5w4CVIwGs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=bYqabPnjr36nnuM/IG5MPueh4TBjsyzTPzlejzErHFnaTQrnwlTtdB1HoWde0x7yi
	 WzxuXwOb7DXMU0xs5OnBgN/I3VwUqiHAu6Sx5e0WVhEoT78CSjkLyqRvbaZFGMv4Xi
	 KeNR1Y6SzXlPPDvdXQWhP+LOK4rhlWKHyDmeCRQI8ICYW/syH/vadu6HJbm9if5saE
	 zoYeeHP/hZFnQ51ZYnChWwCYZ3vED7mHNi8sm6CzgkdsVeM8UepeRdfJbqkMVCJhIS
	 iTP7KTvJxBIL2ixZqjFwF0/ehOCNVGhaN5gtpXfE20gLor/Cswz04QuEaw7GFvM74H
	 KKCCgSylstmZQ==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v7 00/11] reflink and atomic write bugs
Date: Tue, 10 Nov 2026 14:04:18 -0500
Message-ID: <20261110190417.32650-2-mason@kernel.org>
In-Reply-To: <20261110190417.32650-1-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series did a few rounds privately, but looks ready for the list
now.  Carlos has accepted patches 1-4, but I've kept them here so the
whole series can still be tested.

Except for Christoph's patch, these were all found and fixed
by an LLM.

The meat of the series is fixing reflink corner cases that incorrectly
let you write into the source of a reflink.  LLMs also tripped over a
few ways to use atomic writes to expose stale blocks on the drive, and a
few races with realtime flag manipulations.

v6->v7:

Sashiko noticed a few pre-existing corners that I had ignored, so we
have 3 additional patches dealing with races between FS_IOC_FSSETXATTR
and decisions about file writes.

"xfs: restart faults racing with realtime flag changes" changed enough
that I dropped Christoph's review.

Tal Zussman's series is needed for my current ext4 patches to be
correct:
https://lore.kernel.org/all/20261012-ext4-atomic-no-fallback-v2-1-c4b30c60e500@columbia.edu/

Chris Mason (10):
  xfs: don't skip the flush before shifting extents
  xfs: flush the shifted range before changing the file
  xfs: don't change the block map under a dirty folio
  iomap: don't punch delalloc under a dirty EOF block
  fs: validate atomic writes after O_APPEND and limits
  xfs: recheck direct write alignment after write checks
  xfs: test for reflink after the dio write checks
  xfs: test for always COW after the dio write checks
  xfs: refuse fallocate racing with realtime flag changes
  xfs: restart faults racing with realtime flag changes

Christoph Hellwig (1):
  xfs: refuse writes to files racing with realtime inode flag changes

 fs/ext4/file.c         |   4 -
 fs/iomap/buffered-io.c |  34 ++++++++-
 fs/read_write.c        |  13 ++++
 fs/xfs/xfs_bmap_util.c |  19 ++++-
 fs/xfs/xfs_file.c      | 167 ++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_iomap.c     |  40 +++++++++-
 fs/xfs/xfs_reflink.c   |   2 +-
 7 files changed, 230 insertions(+), 49 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
--
2.55.0

