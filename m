Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Be4D5dP0"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E3AE5;
	Sun, 26 Nov 2023 04:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=0GA45pWrbjr21Nzth6rQ8IuAIAXuwIU3BOHtboHnYz0=; b=Be4D5dP0y1M/5bq2Qv2RSmfSsT
	IOevAGepp547Ql6nAUk7QHRtQHiGd6jjSJ3abbtWgq0Lq9E+wGh4TKBN7ODdt9h3mNsP6xu5lZtKs
	Wi4Wv3nGHuciLXk7FBj6fiwfe1LKwIeHRfSzV5ZYiPTUew/QM9Rxbb4s2g52lxK7R6sTLmgyom+SY
	jFcFbbUgAeJRU77EVBX7PKhDKGEEiqmmvjA5QwrUtJ7boivm1ohoa2nQ2YfLtqabd7LkPFQd+0Ptt
	SrTs8w9qIxZ5TuwDk0gkkgPKuOeC9mg9Zd3odagIo0hXn/Q6/eBi7w5ay4CcsYLV+ezOdK8cVMx04
	8NHMRo2A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r7EXl-00BCAv-0l;
	Sun, 26 Nov 2023 12:47:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: RFC: map multiple blocks per ->map_blocks in iomap writeback
Date: Sun, 26 Nov 2023 13:47:07 +0100
Message-Id: <20231126124720.1249310-1-hch@lst.de>
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

this series overhaults a large chunk of the iomap writeback code with
the end result that ->map_blocks can now map multiple blocks at a time,
at least as long as they are all inside the same folio.

Variants of this have passed a lot of testing on XFS, but I haven't even
starting testing it with other file systems.  In terms of performance
there is a very slight reduction in large write workloads, but the main
point for me was to enable other work anyway.

Diffstat:
 fs/iomap/buffered-io.c |  561 +++++++++++++++++++++++--------------------------
 fs/xfs/xfs_aops.c      |    6 
 include/linux/iomap.h  |   17 +
 3 files changed, 287 insertions(+), 297 deletions(-)
