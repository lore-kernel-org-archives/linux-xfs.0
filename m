Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE369D518
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980073; cv=none; b=AfJQwDfZZVfp1p69K8OZjIYBHs3bLD9XsfaQiTmstB2UPhGelIxW+M36AAwlH5IRfCStV7H9nl+5yoKqeyPG0RXh38u+YYByBlmH+FLz/eEZKQz9JSEVlMVwmPVieuXHEWVRzcZn1V7h9YXJQh+5L66lOOdjjnWQeb20z+9rAGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980073; c=relaxed/simple;
	bh=lgGLqkSqoF+sGPdFl584oE06tefdHOQV1nvzkHrC0sY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E58ayP1Prz2BQKn4YLcFSnn7XkVr2y/Kvddxt/sHizc4++uy7hraMt/c9KiWoKnD2/cvfHehVlXOb+pQaw9/+49o//Git2Ihy10QmqlsB2CYMe18iSgf06/dclJJVOByVUi87P71ZXS6pd8pb7zTM4CY5mtkpUm7AJDgHRehKxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k1wJmeVj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k1wJmeVj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Cew9kWJ10gPGeU9dRVqrRRt3nBPTd96J5jRBR7/XFCo=; b=k1wJmeVjbavueRN9PjtQ+cHDBw
	3NSmIlaajb+1GZavbFunkH1KomOgGTOXNya/EjDqjvgFf7D+P+k5eFlJmwPJpO10nRVfyLlAilHOC
	NWxWsscXRRU8KRJ4nyM/vYponElwaekHF64cH7OU10F4dejYh53i5AlsLWyz3wzasR9AA3NDo7h5f
	MkqolMN8VauohaDNJFA97KwatPDPmhflvfGlPFpecmMaZauT8WOrmQI6bkodcG7i4ilTxJvc5F8pO
	crlRMO9aTlz0OA5TebjSptKrDHPs0kz9LyOoIfl90uxLQKa12d0KaEDos7kT7edtpHG5EnUaKVNBY
	V7Ru8ftQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVde-0000000F9BJ-3kVQ;
	Thu, 15 Feb 2024 06:54:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: decrufify the configure checks v2
Date: Thu, 15 Feb 2024 07:53:58 +0100
Message-Id: <20240215065424.2193735-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

I've been starting to look into making the xfsprogs build system suck
less.  This series stops generating platform_defs.h and removes a lot
of superfluous configure checks.

Changes since v1:
 - keep the mallinfo check as mallinfo is not supported by musl
 - fix the sizeof(long) checks.

Diffstat:
 b/Makefile                |   15 --
 b/configure.ac            |   32 ----
 b/fsr/Makefile            |    4 
 b/fsr/xfs_fsr.c           |    2 
 b/include/bitops.h        |    2 
 b/include/builddefs.in    |   36 -----
 b/include/linux.h         |    2 
 b/include/platform_defs.h |   10 -
 b/io/Makefile             |   69 ---------
 b/io/io.h                 |   36 -----
 b/io/mmap.c               |    8 -
 b/io/pread.c              |    8 -
 b/io/prealloc.c           |    8 -
 b/io/pwrite.c             |    8 -
 b/io/seek.c               |    5 
 b/io/stat.c               |    2 
 b/io/sync.c               |    4 
 b/libfrog/Makefile        |    4 
 b/libfrog/paths.c         |    9 -
 b/libxfs/topology.c       |   37 -----
 b/m4/Makefile             |    1 
 b/m4/package_libcdev.m4   |  329 ----------------------------------------------
 b/repair/bmap.c           |   23 ++-
 b/repair/bmap.h           |   13 -
 b/scrub/Makefile          |   16 --
 b/scrub/common.h          |    8 -
 b/scrub/disk.c            |   30 +---
 m4/package_types.m4       |   14 -
 28 files changed, 35 insertions(+), 700 deletions(-)
