Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E869D4F1EC
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513541; cv=none; b=aqnVBjdnPnFjEOvvICf3xll0fnCSsYKncLfjS97EO+jMVILAmyzGBWxmZ9DGH/iKPh+k7YsWscB2IberQtoC2D5fmmVLCMsnWP4N3F3bIPGJwxIoY9/++RvuWct9oii0tV4J20/0nh2Ijn7oW9iSE4wpb6/2ilLK9PuprMVBtTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513541; c=relaxed/simple;
	bh=yOXA1oY0G5b90uDz66rP4fzKFRwHPya6j2Tm01dCdUw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VEDxqxrgv7wjcXoF6N1cxM3WDH9/ORkK4kPJh6WhQcU9kgqlvQz3hbeC6iOcFvW9PUASKix2TZSFgsLXspnEuauUuuqP8MWBmemCmK+kUbFe9MEUJAYIEKrzr6tU8bc/TM44ZywxvlLP/8UjV7qS7AFFK9/29E/vMfpukXVamxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=be4fpV7V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="be4fpV7V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=yczdYAM3OaTcM0v9kLb9shvafQ8DwacvTn/DZec8r4o=; b=be4fpV7VFzcCNdmzKDihSWl6Yb
	eC7QoZX6BQJiA+iUobGRQgtsvgTekx476uNx4H+8NfAOxDcP69w0L2ryj7AbN7I1VI01OsqH4viEC
	jX9iGkB0FHjjXrVLwk5v34m+RqOKvlH/y0eZjWDJeXGhXE2n1CGQX9V+EhUe7GuVpY3mr2uhoJR0B
	WBqQCE7exC4BxUUfyLoM+jqgY2WwSW2sU+SkSnQDVHuzVHjiUcIZjEBxNP9zPz/SrKTQqY2SO65+5
	TWtRJhns9nb6xXoG5zlfkljroxNk6JgFkWpnbpSzVbax/Dp2e6mH/WvucMdqaExZLh56PZjuYTf7f
	Rh8iKsrg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM7u-0000000BcZM-0jAz;
	Mon, 29 Jan 2024 07:32:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: decrufify the configure checks
Date: Mon, 29 Jan 2024 08:31:48 +0100
Message-Id: <20240129073215.108519-1-hch@lst.de>
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

Diffstat:
 b/Makefile                |   15 -
 b/configure.ac            |   33 ----
 b/fsr/Makefile            |    4 
 b/fsr/xfs_fsr.c           |    2 
 b/include/bitops.h        |    2 
 b/include/builddefs.in    |   37 ----
 b/include/linux.h         |    2 
 b/include/platform_defs.h |   10 -
 b/io/Makefile             |   69 ---------
 b/io/io.h                 |   36 ----
 b/io/mmap.c               |    8 -
 b/io/pread.c              |    8 -
 b/io/prealloc.c           |    8 -
 b/io/pwrite.c             |    8 -
 b/io/seek.c               |    5 
 b/io/stat.c               |    2 
 b/io/sync.c               |    4 
 b/libfrog/Makefile        |    4 
 b/libfrog/paths.c         |    9 -
 b/libxfs/topology.c       |   37 ----
 b/m4/Makefile             |    1 
 b/m4/package_libcdev.m4   |  349 ----------------------------------------------
 b/repair/bmap.c           |   23 +--
 b/repair/bmap.h           |   13 -
 b/scrub/Makefile          |   20 --
 b/scrub/common.h          |    8 -
 b/scrub/disk.c            |   30 +--
 b/scrub/xfs_scrub.c       |    6 
 m4/package_types.m4       |   14 -
 29 files changed, 35 insertions(+), 732 deletions(-)
