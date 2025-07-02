Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A010224A064;
	Wed,  2 Jul 2025 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751449222; cv=none; b=UV2q5TgP4qHxxoBmNr8IQM8oOSz3qCVxWFBaAohqeM/UDPLYU8jmNth7WPsVUcjfHgk7sY14yKoaV906WmI9gxmK5gSQUrunBcFrW4cVVHepmbJblCf4kLDNggFxUwkoqBCYkCDIaorlSGyMr/pRyvl1gqsS1pwpJUloKgE+6VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751449222; c=relaxed/simple;
	bh=GWDg1DsV7ZUuNOZFTWt0spsHVa1siSyNSPhHN8LfY2U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZOG6rVeSP9KA6ECAxQCFuLCfgCd8a5lhCiZpi/hUx8OMHZxSOfh9CpZtXNpYnpmNMUp8YMGjvYuYRHPBlb9OSqc4fy15mZZHtYb02CD2KOYJJZQBHmkhDh9ETGYSjvuxrcMYnsGYOJ+tJX04gT1DSesxmmMin/Xzgjq3I5kEgfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=TSm1KzR8; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="TSm1KzR8"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.14])
	by mail.ispras.ru (Postfix) with ESMTPSA id A7C554076B26;
	Wed,  2 Jul 2025 09:40:10 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru A7C554076B26
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1751449210;
	bh=SqlyDeJL19m2IBE/mA82Oc+yp/iCsg9QxFSUf4E0sVs=;
	h=From:To:Cc:Subject:Date:From;
	b=TSm1KzR8oTVhJI6J6YqeztuZWtspR7Gx5nyttntXKglGHExjiN0IaNXhGhox3h/PN
	 TCGBylPBs7IqBxUrY5qX8NrTztOk64csI5DZq8mTLZRT2oE+QPCqMGkFq6D47q64LM
	 IGumUN7n2wFxlRHGDD1ZyCkXSONcaygQwj7oTJuE=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v2 0/6] xfs: cleanup key comparing routines
Date: Wed,  2 Jul 2025 12:39:27 +0300
Message-ID: <20250702093935.123798-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.50.0
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

v1: https://lore.kernel.org/linux-xfs/20250612102455.63024-1-pchelkin@ispras.ru/T/#u
v2: tune 6/6 patch to rename the "diff_two_ptrs" part

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
 fs/xfs/libxfs/xfs_btree.c            | 33 +++++++-------
 fs/xfs/libxfs/xfs_btree.h            | 41 +++++++++--------
 fs/xfs/libxfs/xfs_ialloc_btree.c     | 24 +++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c   | 18 ++++----
 fs/xfs/libxfs/xfs_rmap_btree.c       | 67 ++++++++++------------------
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 18 ++++----
 fs/xfs/libxfs/xfs_rtrmap_btree.c     | 67 ++++++++++------------------
 fs/xfs/scrub/btree.c                 |  2 +-
 fs/xfs/scrub/rcbag_btree.c           | 38 +++++-----------
 11 files changed, 158 insertions(+), 234 deletions(-)

-- 
2.50.0

