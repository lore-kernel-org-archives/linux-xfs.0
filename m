Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20254200A8
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324050; cv=none; b=CF2S3hXnqaaVH+YHX96L5oQGfMM93yHY68LxLS05b3gUYKRO6SSj6RDESXqaCXQL4zPPOYWsXcFXJFHiJkXMuyK7neGrT6lylKkR7V0BH9c5TBWvkvSaR4JhGyzbHkz5g17gwIpqyrmCxxj1RedKIb4flmUcfDPG/Y6Z4KR0qEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324050; c=relaxed/simple;
	bh=wE8iMd/jsJC+LO+2K2+lS/x7CvXz45nFbWJI8TGNwsM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rNo+2w+x9OOlSMIYOV1Ji8RNcbVENg0ptdmq7DgiuADCO3uACrdwj51XoxSja56gZMPFV8j/A4e3muIlVnEB8nm2Z2YbXPOLstSMbi2CuG5dx3mjmEpLsaA79v19g2FC6hZeoiObCy2JRuIKR5BGG+Amy36Vt43rEh6ib5r/Bwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pKxF6ZaM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pKxF6ZaM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=vV++dU5JT51ucxUqh6s0pRaBXnOqDkHCc96TVOpagEA=; b=pKxF6ZaMFOAGiLGlWzCs++QbH9
	vQo5toWFiiUUo5YyMhFlp95pga3apgL5nWvGTBqDGgCc8yjXwH0C6kkX8y0xpHHyOJSiYFh9jGR2H
	XsEBLlzcO2SDf0OIbDUZgofpSemw1p/58JlHu/qeBTpUyJUirxKYB+n8Y4GT2l1iMCw38lRN7Qa3Z
	vjqizWBV01U+HkBaT9zUapNPoZ2zybCTYKBsOpUIJnCmFKY0SOvx/JDrY4gwXq3VLK0f6ADOP7drO
	NgMTa5NcedWeqkej8P0YcrxQ6giPcEjMhJGvUwtgsdj3/cbJ6lqJZFOiHNt3bi862DFzUyfBsfTMg
	236Gamng==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7d-00000009F57-11Zr;
	Mon, 19 Feb 2024 06:27:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: put the xfs xfile abstraction on a diet v4
Date: Mon, 19 Feb 2024 07:27:08 +0100
Message-Id: <20240219062730.3031391-1-hch@lst.de>
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

this series refactors and simplifies the code in the xfs xfile
abstraction, which is a thing layer on a kernel-use shmem file.

To do this is needs a slighly lower level exports from shmem.c,
which I combined with improving an assert and documentation there.

As per the previous discussion this should probably be merged through
the xfs tree.

The series is against current mainline.

Changes since v3:
 - improve the shmem_get_folio documentation
 - use VM_NORESERVE
 - split and reorder the file setup patches
 - improve a commit message

Changes since v2:
 - include internal.h in workingset.h to avoid a buildbot warning
 - update the usage comment for shmem_get_folio
 - improve the xfile_load/store documentation
 - don't use highmem for xfiles for real
 - only call filemap_check_wb_err to check for errors on the mapping

Changes since v1:
 - fix reading i_blocks
 - provide wrappers for reading i_size and i_blocks
 - update the xfile load/store documentation
 - improve a commit message
 - use shmem_kernel_file_setup
 - add a missing folio unlock in the hwpoison path in xfile_get_page
 - fix checking for shmem mappings
 - improve I/O error handling (Darrick)
 - convert to folios (partially from Darrick)

Diffstat:
 Documentation/filesystems/xfs/xfs-online-fsck-design.rst |   25 -
 fs/xfs/scrub/rtsummary.c                                 |    6 
 fs/xfs/scrub/trace.h                                     |   81 ++-
 fs/xfs/scrub/xfarray.c                                   |  234 ++++------
 fs/xfs/scrub/xfarray.h                                   |   11 
 fs/xfs/scrub/xfile.c                                     |  345 +++++----------
 fs/xfs/scrub/xfile.h                                     |   62 --
 include/linux/shmem_fs.h                                 |    6 
 include/linux/swap.h                                     |   10 
 mm/filemap.c                                             |    9 
 mm/internal.h                                            |    4 
 mm/shmem.c                                               |   37 +
 mm/workingset.c                                          |    1 
 13 files changed, 349 insertions(+), 482 deletions(-)
