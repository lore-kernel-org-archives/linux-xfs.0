Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445352;
	b=ASUTQQua4IfjRHrJLbq6DUJuOwVJIkyDTt01MaMeKkJP1fKImqeRnaRtEFZgauDh9/FK
	 7ixxWrF+iv36vVf2s2rYJQvApK/hiNnBauFAE3twjhvX2QhwQx4FOqm3xc3AjZHe2nuDf
	 jYj/KYw1HGz0zF3cv+zYvrs7URrSPpABFwxvLqrAwJYTk4kfkc8Ao5diWT+3Scl9IsvDM
	 ufqcAB5rifjULwKl2ilEmg026tdivEZhAP7bykLEvX1l4suC05Voe7tV0sblrQPUVOFLB
	 ZW1i5w2xgGj7Lfn9hBBkGZ9w/mwIu73qGXmc6EUL6czLJKlGSUUcKFxN8cyyg1ImN/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445352;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=UJ6pBTxZI5zl/SA/eySRsyQjQecxO78gpkfJo+Szb8g=;
	b=wujaFxhMVdEL81kMT5uK4IuF5MsRzWqjRNCiH2/IuGqSd+4RTV1YHVa31Ncgk2Uc25v/
	 wjCXy+YXorfLFgxJQfg0JFpSAXQ3kmT8DYcUWrgKtfW9Ns3GZrTzuCGNfItJG4EzDIiiC
	 V+/VK9BLFl8j1DZj61UJ61rVEgdC+it0Tl2zmg4rPw4tpmJKnpObdqtsyQP8b4bR6LR0J
	 WR0IxTB3fjCmJKFw300XGTx5Hw3vLKmz3Uo6rX9jhSjgLtrb8sghoqqDnwUewygi+JVQW
	 EBto/Ijq8fXI3DuI4iN5SlIyc8E37o47F5qbK89kGCqtps05/93T0EXEwavi6cumWoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AFQvf56g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77EC606A32A;
	Thu, 12 Nov 2026 01:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AFQvf56g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13491F00A07;
	Thu, 12 Nov 2026 01:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445352;
	bh=UJ6pBTxZI5zl/SA/eySRsyQjQecxO78gpkfJo+Szb8g=;
	h=From:To:Subject:Date;
	b=AFQvf56g3eIjArlJVOsynAYId/FJfXW06wkO3vrXUr8fNKxURuMlM0SSFVNc2vi/s
	 H+tV7ZD0qWvvTRYghHBFtZeuB6wWknEHWem1VBSZFxvsY3Ep1eZ3aFepUQCy/+lFo+
	 XbfzjdCohn1A3o2+vHnLw6NSz1RStz4XLGto3BkfIB9fuTDuRJcma7a1h58tolCMZC
	 EW8taYMOhAXYg17ynEsLGpdYnry+WaJMWYUTNI++6sX1jrNmmct5evaLGujWBWSg0N
	 AmNTFuVS9e8zSGxwL2gmex+NqngG4j0tL1Lv2c67S3XxEefTKBfbSCEpncC8CnoC57
	 ufhtxzUbVauDg==
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
Subject: [PATCH v8 00/15] reflink and atomic write bugs
Date: Wed, 11 Nov 2026 20:02:29 -0500
Message-ID: <20261112010229.51029-1-mason@kernel.org>
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

[ the send command got interrupted apologies for the two dups ]

This series did a few rounds privately, but looks ready for the list
now.  Carlos has accepted patches 1-4, but I've kept them here so the
whole series can still be tested.

Except for Christoph's patch, these were all found and fixed
by an LLM.

The meat of the series is fixing reflink corner cases that incorrectly
let you write into the source of a reflink.  LLMs also tripped over a
few ways to use atomic writes to expose stale blocks on the drive, and a
few races with realtime flag and extent size hint manipulations.

v7->v8:

Christoph pointed out that only page faults can cope with the -EAGAIN
from "xfs: restart faults racing with realtime flag changes".  pNFS is
the one other caller that can really get there, so now faults get
-EAGAIN and everyone else gets -EINVAL.

Sashiko had two complaints about the same patch.  The stale reservation
is fixed by the two "resample" patches.  Those are the rest of the 3
additional patches I promised in v7, I just managed to leave them out of
the posting.

The second complaint turned out to be on disk corruption for realtime
filesystems with extents bigger than one block, with nothing returning
an error.  That's the new "xfs: test for an extsize hint again under the
ILOCK".

While checking what a DAX fault does with the -EAGAIN, we found that DAX
and zoned inodes don't work together at all.  With a zoned filesystem on
pmem and dax=always, the first store into a mapped file oopses on
7.4-rc2, and so does ftruncate().  "xfs: don't enable DAX on zoned
inodes" turns DAX off for zoned inodes.

Added Christoph's review to "xfs: test for always COW after the dio
write checks".

v6->v7:

Sashiko noticed a few pre-existing corners that I had ignored, so we
have 3 additional patches dealing with races between FS_IOC_FSSETXATTR
and decisions about file writes.

"xfs: restart faults racing with realtime flag changes" changed enough
that I dropped Christoph's review.

Chris Mason (14):
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
  xfs: test for an extsize hint again under the ILOCK
  xfs: resample the extsize hint after taking the ILOCK
  xfs: resample the COW extsize hint after cycling ILOCK
  xfs: don't enable DAX on zoned inodes

Christoph Hellwig (1):
  xfs: refuse writes to files racing with realtime inode flag changes

 fs/ext4/file.c         |   4 -
 fs/iomap/buffered-io.c |  34 ++++++++-
 fs/read_write.c        |  13 ++++
 fs/xfs/xfs_bmap_util.c |  19 ++++-
 fs/xfs/xfs_file.c      | 167 ++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_ioctl.c     |   8 +-
 fs/xfs/xfs_iomap.c     |  73 ++++++++++++++++--
 fs/xfs/xfs_iops.c      |   4 +
 fs/xfs/xfs_reflink.c   |  16 +++-
 9 files changed, 282 insertions(+), 56 deletions(-)

