Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F69159596
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157377; cv=none; b=krm0aQ385hb6gEozcUl6flrBhXZLQOwOdVksf6yzK7QJtOfxvlzn+sOfFIcg9+W/ohYMnHqbwapDrwkB7ul8zQmYLSsA+qWogKIgYS3ETU80p8GNcQ+jOmFUlonkxDgAIbldYIzWES5SMPc3a1NdRs0xOLG2kjgMpxcfrY8ylHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157377; c=relaxed/simple;
	bh=/AqkK7hjGzBCV6oDUi7z7mt+NMmOoeXwBLInzs5wGlY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dGFmAcMiZQyAyZoLjssC5fmVBCH4BlyoDXeBtNt6aPJC2orbmiYwEppGrp8FtkjOpktPLcHMV46FrnA4oQfozS4WT4DZpzu3C3C2eTMfKYbvtu5h23x9mDhU6WRkGfGxv/fBjmhQYDD+IuI+VZA81oKBwzj4KpCknBaNVw7xe+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t06q6YIc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t06q6YIc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=nJouWYzXVy1VccFobjdyFOn7PmQSvLO13LjdK+DLcF0=; b=t06q6YIchB+9nOTZ8ljrefxsEY
	KfjI7oadujFChoilMtE9kRFiHSnh9wkdGtsb/d+RHhyFSa5qdp8YWPZ7dRWwWFYN5mRw38MsSZv8x
	8/QLF9E4HQ94y7TJFSiJwYEv+k1wbdrj3jyLiIXc+sRGKyFGbULHIEzzQQ0rvdKnF12Bs7I2CUC8R
	mAONIT8TZoVUazmoaiQr62pP3LjGDaMMYHcI0/Hzoh0OjSiB/oumeEXeyYek9QALG2JqW8Fn7zaul
	aVaEssKF4S6OY5GX7wZNi4al7aKrPEPg8zARKn285+Kk0ceY57HKv8sNURl9Mzr9qYnLfb7BDk1/P
	33yx5Ntg==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqI-00000000lBw-4AfM;
	Mon, 06 Jan 2025 09:56:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: buffer cache cleanups
Date: Mon,  6 Jan 2025 10:54:37 +0100
Message-ID: <20250106095613.847700-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

over the holidays I dusted off some old buffer cache cleanup as the bio
splitting in the zoned code gave me a better idea how to handle
discontiguous buffer bio submission.  This spiraled a bit into various
additional minor fixes and cleanups.

Diffstt:
 xfs_buf.c        |  508 ++++++++++++++++++++-----------------------------------
 xfs_buf.h        |    9 
 xfs_buf_item.h   |    5 
 xfs_dquot.c      |   14 -
 xfs_inode_item.c |   14 -
 xfs_trans_ail.c  |    9 
 xfs_trans_buf.c  |    8 
 7 files changed, 195 insertions(+), 372 deletions(-)
