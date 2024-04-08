Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BBD13F016
	for <linux-xfs@vger.kernel.org>; Mon,  8 Apr 2024 14:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588101; cv=none; b=V4+gTY8QedEI9alLoZcdAMGeW9AaFevwpkfHts0avCjzrllEvBi1za1yTcyDFKxBDQ4r3nQLovn74dJuLtCm3YPPiAh5eVwvPgRJ33W2OTp/p/4a4kBZLmG9C7IrFiNre14R/YohPL1SiDoNSja+vcDAtcAvxS5GHdFguVCF+eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588101; c=relaxed/simple;
	bh=JtXETLAslmL0f2AZ15dlaeVj/aYfEJsLKJ3BD6kWSDE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B8GTNhDVWurwnJqhOTPpEXkIaSVg3funzj7yXoPyvk191VsVYL0Hfj37fxAiL5rLOH5xqRQEV4OH1qMASiCTg4o1fDZetg458hfz2u3C30MJTrqIVXvlhGSn09pDkWJ9RQ/pJ973uuhmtbpN0zW1BH2tYBL5dhU0+hty4rRFJS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SfiyI6YL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SfiyI6YL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=52Lq6DfLbunrYHBl4ViMtvKqRXaBx6v5fK6pz1fMT48=; b=SfiyI6YLJUMKEkRRlQW8FNJ2KX
	3acDfhcZroxpzST/Lwx1EXiu0qE58HIttiY9zl3/nYqf9UoA06IP9P3nd1W8odcm1YRs04DXQvMmZ
	I8Ca5Jbf4nW2y0/MyVRz7H6CcRlIETbdCoLn8bhp/1uLw9MHV0iZnkOapFqYRb6NKLwljx2vaIoOt
	9Cvqv0S+fcO8xXXkfPtpT1WUBgnpvw3Bmd4x8reIAcW72mWfvdolsVPj1sAkwHKJPNW+BYfSVAmOl
	oWywy4kLDp9uN+1YiwKO0PFGfdeiU3hRg3C6hhLo1zdbXwxkNmdd5fs+34yrxefSyLuiVa6hZka7U
	i6Fg1IZw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtqOf-0000000FwWX-2Foz;
	Mon, 08 Apr 2024 14:54:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: RFC: extended version of the xfs_bmapi_write retval fix
Date: Mon,  8 Apr 2024 16:54:46 +0200
Message-Id: <20240408145454.718047-1-hch@lst.de>
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

this series tries to take the xfs_bmapi_wite retval fix a little further,
but I'm not entirely happy with the result.

The first patch is the actual return value fix with the comments fixed
up as per the comment from Darrick, and a dead check removed I found
while developing the rest.

The following patches are random cleanups to get the code in shape for
the last patches.

The second to last patch fixes long-standing issues in
xfs_bmap_add_extent_delay_real in code paths that haven't been used much
or at all.

The last patch changes xfs_bmapi_write to not convert the entire
delalloc extent if it hits one.  This sounds simpler than it is, because
delalloc conversion has been designed to always convert the entire
extent since the initial delalloc commits.   I'm not really sure that
putting strain on this code now will do us much good, so I'll just leave
these patches out for comments for now and will look into how coding up
a loop of delalloc conversion calls in every place that could allocate
blocks in the data fork of a regular file and thus hit delalloc so we
can compare the approaches.

In the mean time I think that patch 1 is a candidate for 6.9 as it fixes
the fuzzer problem.

Diffstat:
 libxfs/xfs_attr_remote.c |    1 
 libxfs/xfs_bmap.c        |  120 ++++++++++++++++++++++++++++-------------------
 libxfs/xfs_da_btree.c    |   20 +------
 scrub/quota_repair.c     |    6 --
 scrub/rtbitmap_repair.c  |    2 
 xfs_bmap_util.c          |   31 +++++-------
 xfs_dquot.c              |    1 
 xfs_iomap.c              |    8 ---
 xfs_reflink.c            |   14 -----
 xfs_rtalloc.c            |    2 
 10 files changed, 93 insertions(+), 112 deletions(-)
