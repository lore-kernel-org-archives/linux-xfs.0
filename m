Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE1A3B786;
	Mon, 22 Jan 2024 11:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705922287; cv=none; b=ono6qyeHKk+axyyKpyBzV1zndqLDlsrIFjQLCak+1GEd3B4EKeIk3DTBwEhGBwxKWlxJDHz6c57gXZz8bA3wA5wpIZzWv7IJMhjVnnSD1u64XFIofX+ww6bOVeKaVZ3EdqI9eMzNStCPLX3jMr/VrC2MltcWdw9LhsXxGHxtMlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705922287; c=relaxed/simple;
	bh=iVIbkWgk+Cr24CWRm4GWke1z+L5W+ZHdA0AbGxydsec=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=s1pO9heoBkkDX3tYTHu/3pYxwZUcX2gQCKB+0bdlM2dQN+0lkxLE8iZFf84HMLptnJ+e7aIJRKsO1wraHgO8IM1S7dp9UKu7urYXR73QDl6B0/2IEnv80UoPJg00w2N3YaGX0O1CkOvsU+Q8UEi3Am79nxOuFNDieRn1wPkG77o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=peJRg2Lj; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="peJRg2Lj"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4TJSPc2Lh7z9sRl;
	Mon, 22 Jan 2024 12:17:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1705922276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qDwvKrwi1fSzEB6aET+7FRLWMcme9+cdOtsBkzBlLQc=;
	b=peJRg2LjJl/ywk/4SDddv6H81wtVa8WjleB3YsMzum/JjFxNXSXUmPKH8+yCiWdCEJS+0T
	fjYGQhy/4PhonLtNrfz94nyeIvxBqWhV4+yNia6brDBvKIkwUPS91G9WJ7unZ4M1N0diOZ
	B0+8Bjo5sxyq3urTiuu1duurG1aDC6bwN3AhhenL9cDdlhFirtNnf57lF22fw3lk9d64QQ
	QU2VWzabslRdO1v7N60oGJU3B//kxQ8DhEu2zZvQ4m2zHzrfHfzdAKDc6ulLtsuuKQTeEi
	cnWPBi7F1HaFH31QBLE3o2Sa+FpoWnOWYmWXiL4pWivixwlayAgh/AZQLP3aRA==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: zlang@redhat.com,
	fstests@vger.kernel.org
Cc: p.raghav@samsung.com,
	djwong@kernel.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] fstest changes for LBS
Date: Mon, 22 Jan 2024 12:17:49 +0100
Message-ID: <20240122111751.449762-1-kernel@pankajraghav.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4TJSPc2Lh7z9sRl

From: Pankaj Raghav <p.raghav@samsung.com>

Some tests need to be adapted to for LBS[1] based on the filesystem
blocksize. These are generic changes where it uses the filesystem
blocksize instead of assuming it.

There are some more generic test cases that are failing due to logdev
size requirement that changes with filesystem blocksize. I will address
them in a separate series.

[1] https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/

Pankaj Raghav (2):
  xfs/558: scale blk IO size based on the filesystem blksz
  xfs/161: adapt the test case for LBS filesystem

 tests/xfs/161 | 9 +++++++--
 tests/xfs/558 | 7 ++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)


base-commit: c46ca4d1f6c0c45f9a3ea18bc31ba5ae89e02c70
-- 
2.43.0

