Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532711534FC
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538911; cv=none; b=s8XEwrPjhYqLaiKi1Z4D7uGfgKeedD1wGDMr2ti1CZIrSrft3C7Rd0FFaR9u5d8/eu+yk9Mhl2SMcXNhcx+Fov7KJZ7WXN1tHFK+65fN1hGPD7MPk1m5bak0gBR6l1Cb9syO7NGKhNEcbQa3VcqBM4XLNX7QjHAzUlwIvvR5O8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538911; c=relaxed/simple;
	bh=5y6R8RHgmYzI8FOXw0vbW1+fwXZ5y7Ry/z8BcztYBFo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DXZ4QbOKmOMKuMlJEJHWE+jv/E1u1USC41hAVeO+X/dh8kBr6gLwYoAq/9LlQHuraS8qz0dwrfgx/wQOUOi0TOdaF3urPbZxoiBwQOL1SwgOa0hQdfnuk05GqhDhJBOJJi2wGLsBia5TjmjbLjCcXiMd3R7a+4Iv7RNaMKpetaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vlO8ygZG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vlO8ygZG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=t4aNNle3WP07OWgmpnHw+2FFhErVgwmHlzrKqAK/2yQ=; b=vlO8ygZGBOW9HtZuLnadpeCZBv
	ITVvJ2E3mJIe0V0u0smr5bhz+1FnDT40qss3dMM499uVesd/8SnG6XgAXRDWnqCJe5+giXtWopQnF
	5PLKWmdcJ13ibeWWL2vN33Oi+5QKyfj5Kv37U7+v9/hDNEyiv4/kB1TBCk/kMJOv9zinm597o7mfB
	dpo9QVfpXlMnIYApdpd08ywEGxJ9wAjbLYTL67vBOj2ULMAhAcSEYvRYRjxdWrn1PotW5Qyn6YKsh
	GD0KQFn8XgutpbjOhvfJUhdznkQXJSESfGZqj9KfXTmi2BCOAHbrSqdMvF7xcxbsn5VdVo9SvSeQ4
	a/pMbBlQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSj3-0000000D62v-2uCi;
	Mon, 29 Jan 2024 14:35:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: put the xfs xfile abstraction on a diet v3
Date: Mon, 29 Jan 2024 15:34:42 +0100
Message-Id: <20240129143502.189370-1-hch@lst.de>
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

Now that this series has a fair amount of reviews we also need to
think how we can merge it best.  Should the shmem changes be
merged through the xfs tree?  Should there be a shared branch?

The series is against Linux 6.8-rc2.

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
