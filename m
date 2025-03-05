Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362E524BC17
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 14:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183535; cv=none; b=ahclL1JPg5lipPrt8qIODYGGlVKZjlNsymEFoZD3rO4QJfWpc+OR0nIF89gCMtNoIyxV+NSiKHInTwpPNDE0reoGwmzesvrPvC98bvDH2qsGROL0WJjRsXISIZp9RwAFhvz+PLMI7DoBlmjdjaXKe1UJlRFwoS1Gv14h4hk0CpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183535; c=relaxed/simple;
	bh=eUJZnbYdMcg/R3X7Sz1C9X+e6rQmRZ60ls0Mpab7yQw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GUhYD2mn8dSdAdhBKUDqa3QA5gX17j41DZGfLWvX0ZV4YK3RM87xkvFP/SdPsWIvL3TqlPL91BEkq4Js1O5+cEKweskBlVM0SNBfO6NT+B+87rPBrvWUTjV2HoVmI646enw7Ja2xckQmkTvgrAeHhY3WnW4zOosnnVCoa4D5VzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ejYkvmaU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ejYkvmaU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=94/JiHk8bzWOmWg/vIAofEsojI0iXBO1n3sn5jvvw3g=; b=ejYkvmaUo+J5VWfUmLv2znrmmT
	oMGuxOCmCwJyeGPhDIAtPxUzrlC9TWYl4wDkMQnCh6l9ee29OFfNjX2zZDM0+LSY0mI3c7cshpQPj
	d5ecv5J56nZpuixRMD7TezVh7bDbxPfbmBs+XjaDJ8P9gKMe3aFOLrTyOMcB1bn2YpbA6M8F4I9Zb
	3ubrKbUKFUJ26uaJZfzCcLSXFn/He5RhLFXgfzFVmneqm+0cVGmZuOKyFaoUrrkgk//Greu3pavAm
	MKewc9kaRC4PLQMksQQd2J0LTSr1gHjMPTtdwYtXJ2PrhOTvsA0mtSWwvE8ZyfH8TppYMu70B/xF7
	rX+Eu4/w==;
Received: from [199.117.230.82] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tppNM-00000008Hnw-1Xr4;
	Wed, 05 Mar 2025 14:05:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: use folios and vmalloc for buffer cache backing memory v2
Date: Wed,  5 Mar 2025 07:05:17 -0700
Message-ID: <20250305140532.158563-1-hch@lst.de>
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

this is another spin on converting the XFS buffer cache to use folios and
generally simplify the memory allocation in it.  It is based on Dave's
last folio series (which itself had pulled in bits from my earlier
vmalloc series).

It converts the backing memory allocation for all large buffers that are
power of two sized to large folios, converts > PAGE_SIZE but not power of
two allocations to vmalloc instead of vm_map_ram and generally cleans up
a lot of code around the memory allocation and reduces the size of the
xfs_buf structure by removing the embedded pages array and pages pointer.

I've benchmarked it using buffer heavy workloads, most notable fs_mark
run on null_blk without any fsync or O_SYNC to stress the buffer memory
allocator.  The performance results are disappointingly boring
unfortunately: for 4k directory block I see no significant change
(although the variance for both loads is very high to start with), and
for 64k directory block I see a minimal 1-2% gain that is barely about
the variance.  So based on the performance results alone I would not
propose this series, but I think it actually cleans the code up very
nicely.

Changes since v1:
 - use a WARN_ON_ONCE for the slab alignment guarantee check
 - fix confusion about units passed to the vmap flushing helpers
 - remove a duplicate setting of __GFP_ZERO
 - use howmany more
 - improve a code comment
 - spelling fixes

Diffstat:
 libxfs/xfs_ialloc.c    |    2 
 libxfs/xfs_inode_buf.c |    2 
 scrub/inode_repair.c   |    3 
 xfs_buf.c              |  368 ++++++++++++++++---------------------------------
 xfs_buf.h              |   25 +--
 xfs_buf_item.c         |  114 ---------------
 xfs_buf_item_recover.c |    8 -
 xfs_buf_mem.c          |   43 +----
 xfs_buf_mem.h          |    6 
 xfs_inode.c            |    3 
 xfs_trace.h            |    4 
 11 files changed, 159 insertions(+), 419 deletions(-)
