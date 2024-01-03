Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A9B182A2
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rytIOVbX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=9h8TFr0Cvw76++DeXKTV5CGshHC+4DLFSq++7+O27NI=; b=rytIOVbXITitsD4JrjhfxDefMM
	XkWDvDldEp8F0JkBa6JFYiSmXSlIBm761r0gVFmPk4uDvdJX0UQE4mPEPCmxJASlskDwlOpMVe+/p
	lW1F5qHot8BhUtYSYaMC/z2WfxKJrFJaZOGbQMSfB/EX4e/M6/D2GtL5BWBWlQXq6IFaQyNgthVfT
	x7PoJ5ULq7szMJVbLKFJrj5GNfRLQGnYrmtW7AUueU2CkAsZ6Esp419UpCNUe7NiiPJUlM+27wnQS
	egsb0P3op9ZnLMMpvr9GSJNPYzuJGUewN9taKkATTznOHOr4Ng2R5ksSf8tCjLEnZGiTJ/YZTd8vl
	WDcMLUcg==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwod-00A6TX-1H;
	Wed, 03 Jan 2024 08:41:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: put the xfs xfile abstraction on a diet
Date: Wed,  3 Jan 2024 08:41:11 +0000
Message-Id: <20240103084126.513354-1-hch@lst.de>
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

Do do this is needs a slighly lower level export from shmem.c,
which I combined with improving an assert and documentation there.

One thing I don't really like yet is that xfile is still based on
folios and not pages.  The main stumbling block for that is the
mess around the hwpoison flag - that one still is per-file and not
per-folio, and shmem checks it weirdly often and not really in
at the abstractions levels where I'd expect it and feels very
different from the normal page cache code in filemap.c.  Maybe
I'm just failing to understand why that is done, but especially
without comments explaining it it feels like it could use some
real attention first.

Diffstat:
 Documentation/filesystems/xfs/xfs-online-fsck-design.rst |   10 
 fs/xfs/scrub/trace.h                                     |   38 -
 fs/xfs/scrub/xfarray.c                                   |   60 --
 fs/xfs/scrub/xfarray.h                                   |    3 
 fs/xfs/scrub/xfile.c                                     |  311 +++------------
 fs/xfs/scrub/xfile.h                                     |   62 --
 mm/shmem.c                                               |   24 +
 7 files changed, 143 insertions(+), 365 deletions(-)
