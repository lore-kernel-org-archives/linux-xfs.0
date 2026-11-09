Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268274;
	b=GUfqZalj9XSWl4IsTirYCnLeXT6YkK0pOEhZLiLB2CeODqD0EI9PdAthDKpAIKkzbngp
	 9g02TuJPA6SEiNe78rLKeS8TdFNYjxrLVwUHRe2duYOm1PuRbi+AI0JtIRu5C/m5UcGgL
	 cDseL8Z85mOpLPy+uUc2JCcnZC1gBXSM7H3g7WCnzEd/a8PMXGWryIPqUn8qdgYeWTSdv
	 5K5MmnbPbuWFuc32+3KFAa6GA2p5G8p6uDPnYKkDvhA8Tnhs1iD7sfEQnR3eHW1xqh8gI
	 xnyUN8wRLBdJ5Jba2MtChioX0m3UMgOOWfw7MjfOwEeRIjbIDmwMxSeCZbRd6fM1nUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268274;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=ORbE1mg5iTUjQH+mp5nFuaGXJutZvkHOuo1HTwX2iCQ=;
	b=xI3t1OokLBxetwMm1oagg2FJmqe7zT9BBAFUtNaVPCcg6WNpfVp/ram93ExzZkm0Zk7r
	 gp0/PsqWscF7KRvghYuXjCI3Sepz6A3bwef6piKoQnbSfuBDAVwOF9jzpATbtVgks0n5Z
	 3QNBsqnLEovCQm1IJ2nOlLKMMIEe9lSpcF2iS2KRNeL9aGEY595DfKvHASHchBV12+zxd
	 58XAJFrytgg1YLndn4rqdKmS4CxTCDUVq+9xG7DI506p6Gpe+GKkHtn8iMmMVPD8RJV1j
	 6qxslQOpMUmGzc1pdpJNfLK8v66YLmInS1RJZ1h1cmt8Ah7KSYQiBte8IaDMDjhaheA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJyHu9pq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15315606A31C;
	Mon,  9 Nov 2026 23:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJyHu9pq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8769B1F0089F;
	Mon,  9 Nov 2026 23:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268273;
	bh=ORbE1mg5iTUjQH+mp5nFuaGXJutZvkHOuo1HTwX2iCQ=;
	h=From:To:Subject:Date;
	b=kJyHu9pqpyNnrTWPhd5ClHZBO3IWtIQk7D6ohle9hVkUfeP1xdtWXFjoULewL/dzZ
	 /kqO2liuRG0cYxCtTcz5Y0gC1aOc/ZAzyoBjnMYLsx9JoLMGv2L6sROEeBRlaDR7Xd
	 l1bbEIsUkwb2J5ABlxBiHgoAfw6kEMJmQIhQ0t7L16PsuHTtSXcwt4eh2q4Hfz7VhN
	 xgQyhuDnSqaTu01DoOPGYTKhgP/F3vU1WAM5WQaI1amfVCng590FgzuUH6f/s3ucJ7
	 E4LKM9Tuxmw+BGs6euxOlNgF+GrC2mveZf7/gF3+UFR1+xNeNBaM2W58XNogn1N5/K
	 9BkFSjHeM/FMg==
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 00/10] reflink and atomic write bugs
Date: Mon, 09 Nov 2026 18:51:11 -0500
Message-ID: <20261109235111.14129-1-mason@kernel.org>
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

Hi everyone,

This series did a few rounds privately, but looks ready for the list
now.  Except for Christoph's patch, these were all found and fixed
by an LLM.

The meat of the series is fixing reflink corner cases that incorrectly
let you write into the source of a reflink.  LLMs also tripped over a
few ways to use atomic writes to expose stale blocks on the drive, and a
few races with realtime flag manipulations.

Carlos and Christoph ran these through fstests (thanks guys).

Chris Mason (9):
  xfs: don't skip the flush before shifting extents
  xfs: flush the shifted range before changing the file
  xfs: don't change the block map under a dirty folio
  iomap: don't punch delalloc under a dirty EOF block
  fs: validate atomic writes after O_APPEND and limits
  xfs: recheck direct write alignment after write checks
  xfs: test for reflink after the dio write checks
  xfs: refuse fallocate racing with realtime flag changes
  xfs: restart faults racing with realtime flag changes

Christoph Hellwig (1):
  xfs: refuse writes to files racing with realtime inode flag changes

 fs/ext4/file.c         |   4 --
 fs/iomap/buffered-io.c |  34 ++++++++--
 fs/read_write.c        |  13 ++++
 fs/xfs/xfs_bmap_util.c |  19 +++++-
 fs/xfs/xfs_file.c      | 150 +++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_iomap.c     |  33 ++++++++-
 fs/xfs/xfs_reflink.c   |   2 +-
 7 files changed, 215 insertions(+), 40 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
--
2.55.0

