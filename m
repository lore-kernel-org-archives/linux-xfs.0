Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88254C7539
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349361; cv=none; b=ew+xex/Ua+tqL6tC3qJcvmh2BjoAAcqZmhYBCuc67GqfBq/SOAdeWTW2thyoi7pGfR8xeSHKjm4Ho9qs/gdCMF4G3xYyB/PJlokd7sAemUHEsTGFSplfcFJMui+0fKBcP3uAk/9wIu9x0Wioxmx0bPQUl2OSlvgLVoEXuBqUKjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349361; c=relaxed/simple;
	bh=Bippls0cpeWMhdtnbvKDrIVsvu5kfsWbIJczBt6w/4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eaIYR8hkBWbU7ujioQoxmjrAIO06znRELyDfdZmnaUi81CdVh/JRvwb6XOh+pTDKcnnTyDXq4NvknkyLfbq+A/2oJbBBdY74lBbGEjmhxC7pRTEKp4yM1Oa6RjLN0lzqUaAe2bYyjig2XzXgJDQPGygcn2Msm2L3kmY02ck+0u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q7a4axkC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q7a4axkC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=di0ZDuNSQrGI9jdEtWcGBifXNc2EZ7Bjr1zApYZ/g9E=; b=q7a4axkCjJYPjHljDTM0VLBrGO
	9dKFhgENT99Xd/ecZJXCUTMMK2Xsg/gTGIno9/Vcv5uSvC9EY2qjNnYG8ILNVxxg8Xg8fMY5c42kN
	0a6lGs4Uls/r3FdVToLN7l/JpPXLdB15pJBr1NS26veWj46iEoFLTwaEIF6xCrlNf923z4ngNyXrR
	+2dV4/Ws1E/+tDbfqPn/O2nG4k22Hoo0PIU4XzgIqMK5yJJJei69hNM+iQoP0vWD8fNkNA9Vg0FDg
	dAmGrkHDABwjOnxpnjJ2PYopj167RJrfc446bjiinctQE/oead4oWwTtJe3SmpvLxxAgXCBfSxS7X
	5h/oi8Wg==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7eO-0000000DjfS-0ysu;
	Fri, 25 Sep 2026 15:15:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: speedup cache flushes for the RT device
Date: Fri, 25 Sep 2026 17:15:35 +0200
Message-ID: <20260925151543.3382123-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series speeds up multiple caches from log commits by doing them
in parallel, and by not doing non-log device flushes where they are
not needed.

When doing small O_SYNC writes onto the rt device of a file system using
two SSDs known for bad flush performance which do not support FUA this
gives a 70% speedup.  That is a rather academic case where performance
is bound by the cache flush, the speedups for normal setups and workloads
will be much lower.

Changes since v1:
 - drop the already merged bug fixes
 - make the flush only the log device path actually work

Diffstat:
 xfs_file.c     |    3 -
 xfs_log.c      |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 xfs_log_cil.c  |    9 +++--
 xfs_log_priv.h |   10 +++---
 4 files changed, 89 insertions(+), 19 deletions(-)
