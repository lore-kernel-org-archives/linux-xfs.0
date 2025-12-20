Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01001C84A0
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 02:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766199480; cv=none; b=PqpHDqnBq8sstQlE++8o5Z9PELjaxxeHVBOgAe+4BmfAbDjvtP1mu2N9LJI27D8L92UZ0rcwuQjkZuv+i7kE5AXFD9smGTDSovcyJ4gLGyuM2zv8NizTpY6efDRITzWw2MiftUA8sqL6X08wKX3Kfx4S8jQJHz4o+FlVX+A9cJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766199480; c=relaxed/simple;
	bh=JgSfShLI8SYonszZyXmhU/Vi99nFg6kNUNhtB9lztQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ah5ijeCF0fMgFC0c/WS4KyF1G40K8J4jDPSpn7yhUgnoEP6O+Fi9lZjsLnbruuZqX4GxNkQgI5MkNzjsvC/CWRUOELRLWx5Y2uDyPM46kOFtXJSEHhETlQaOMS1cnPFIndKuyOREf4fNTdC59Cak19Evb3vtiM/X0aVASvGhb+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlnwDYZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlnwDYZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F038DC4CEF1;
	Sat, 20 Dec 2025 02:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766199478;
	bh=JgSfShLI8SYonszZyXmhU/Vi99nFg6kNUNhtB9lztQk=;
	h=From:To:Cc:Subject:Date:From;
	b=LlnwDYZldz+EiB1JPUmBvfcWG/EERfoyoTb60R8LlXMAP+v+99MJJPKpv1cf5VgGF
	 47zem8RBVXrdnstPpDhcN8BEI9XIm85gu3B9G8bkaWasWFSYGV1rcwstITe8GjcCnB
	 I1tEnV84lsqJUi3hmulYS8ZwOipmcqlTZYEMifX9G8ws23ZIHq16m04wzh+mmus3y8
	 sg+i6Cae8NoiVA5aVigq+/fXE9Pso1q+kH9AztGuNKkDCtqMB7o+FkdIpXuJOCYxbT
	 GZwI4hQ1UkvCsE/1s1TJsb0lu9gB2AqzYi8K55n20L20nKCI5/8IMT8m/L2dAaC2pS
	 XEvTxWFFS/VpQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v3 0/6] Enable cached zone report
Date: Sat, 20 Dec 2025 11:53:20 +0900
Message-ID: <20251220025326.209196-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable cached zone report to speed up mkfs and repair on a zoned block
device (e.g. an SMR disk). Cached zone report support was introduced in
the kernel with version 6.19-rc1.

Patch 1 and 2 are a couple of simple fixes/cleanups.
Patch 3 intorduces the new xfrog_report_zones() helper function, which
is used in patch 4 and 5 for mkfs and repair respectively.
Finally, patch 6 modifies xfrog_report_zones() to enable cached report
zones.

Changes from v2:
 - Complete rework of the series to make the zone reporting code common
   in libfrog
 - Added patch 1 and 2 as small cleanups/improvements.

Changes from v1:
 - Fix erroneous handling of ioctl(BLKREPORTZONEV2) error to correctly
   fallback to the regular ioctl(BLKREPORTZONE) if the kernel does not
   support BLKREPORTZONEV2.

Damien Le Moal (6):
  libxfs: add missing forward declaration in xfs_zones.h
  mkfs: remove unnecessary return value affectation
  libfrog: introduce xfrog_report_zones
  mkfs: use xfrog_report_zones()
  repair: use xfrog_report_zones()
  libfrog: enable cached report zones

 libfrog/Makefile   |  6 ++++--
 libfrog/zones.c    | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/zones.h    | 22 ++++++++++++++++++++
 libxfs/xfs_zones.c |  3 ++-
 libxfs/xfs_zones.h |  1 +
 mkfs/xfs_mkfs.c    | 39 +++++++++--------------------------
 repair/zoned.c     | 29 ++++++++------------------
 7 files changed, 98 insertions(+), 53 deletions(-)
 create mode 100644 libfrog/zones.c
 create mode 100644 libfrog/zones.h

-- 
2.52.0

