Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C31F1319;
	Thu, 12 Jun 2025 10:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749723928; cv=none; b=KTfm4fwGUbljXBGTmZ089mHc8z8+kAv/YwpLg/LfHafQMyaRmIGKNc8x3BPmfJMkVWpfHmtsV3DNS+7EuNmEAF0VAejpi04p4LtsrBlZ6RblR8c5m27OMrIdcnhrR3jQNKidxV/m8lCbYih+lzEIWTBHg+ph8ZzESJTvphbeg7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749723928; c=relaxed/simple;
	bh=+sIlEe0Syg6+bKt/NZJvbdYi1Abu4cu7xszJvg6OHrk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gFTMjOC62zkIupc+4Z0Tiwn2eXNJkdvhr+LJzaBF7N68XGBtNiszcLdpCgdaWvwTX4S8yaEvx4VMbe3Dfaqk0wQYgm4ZFFUC9Rw40ACd1b8WfkXIfRJ9pbF2hnRsE03xvuuii9m74BIqcsrGUavUQ4eWp5BeyCwBx6mwQogjocM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=O998UNl+; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="O998UNl+"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id 8BA75552F533;
	Thu, 12 Jun 2025 10:25:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 8BA75552F533
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1749723921;
	bh=NDxglNLTmwF7TTmbzr816pEFu886yLEViYrh++aESOE=;
	h=From:To:Cc:Subject:Date:From;
	b=O998UNl+iKB3EA5i5Aozwdx7tUzp6Bh3U+yNDpDUtKyihbXCaHfWUQdovKnKdKg2D
	 W9O6EkFn5BE08oMHzopjpcafcwnYaFxZ0ciUQ6gjBh71/l17zv10hOh37Sa250b954
	 HFu8jDhDim/9HWU8hIS6Ed2qEMSrWg/abvsHpPhU=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 0/6] xfs: cleanup key comparing routines
Date: Thu, 12 Jun 2025 13:24:44 +0300
Message-ID: <20250612102455.63024-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Key comparing routines are currently opencoded with extra casts and
subtractions which is error prone and can be replaced with a neat
cmp_int() helper which is now in a generic header file.

Started from:
https://lore.kernel.org/linux-xfs/20250426134232.128864-1-pchelkin@ispras.ru/T/#u

Thanks Darrick for suggestion!

Fedor Pchelkin (6):
  xfs: rename diff_two_keys routines
  xfs: rename key_diff routines
  xfs: refactor cmp_two_keys routines to take advantage of cmp_int()
  xfs: refactor cmp_key_with_cur routines to take advantage of cmp_int()
  xfs: use a proper variable name and type for storing a comparison
    result
  xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()

 fs/xfs/libxfs/xfs_alloc_btree.c      | 52 +++++++++------------
 fs/xfs/libxfs/xfs_bmap_btree.c       | 32 +++++--------
 fs/xfs/libxfs/xfs_btree.c            | 31 ++++++-------
 fs/xfs/libxfs/xfs_btree.h            | 41 +++++++++--------
 fs/xfs/libxfs/xfs_ialloc_btree.c     | 24 +++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c   | 18 ++++----
 fs/xfs/libxfs/xfs_rmap_btree.c       | 67 ++++++++++------------------
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 18 ++++----
 fs/xfs/libxfs/xfs_rtrmap_btree.c     | 67 ++++++++++------------------
 fs/xfs/scrub/rcbag_btree.c           | 38 +++++-----------
 10 files changed, 156 insertions(+), 232 deletions(-)

-- 
2.49.0

