Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5829081720
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585168; cv=none; b=C/2yMFiZZ7/JugPP9fM5qFIQZLqpVOqwb7A1A28Eji8nPSH7kIZD3TbNuk64hL52hUIwc9BeinaFdT0gfJSfS4hHFHyhkCYBQKK3zPzi2rDn1m4ktfu44dIg9ujPgJ9WA+iOiZ6vMvr2FhNfJNrEByDmLElL87H87gaSct2nPYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585168; c=relaxed/simple;
	bh=IEheeb+AUJ5F8Q6fZImnyv8TaITgGFR6DEV9WUcneXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u15PpcfEE7futbBXa45GkBO1XhsmGn6jlCY8tzThRqI2KHSbX4/GTX3Ak9mAXp1Oc59VvEqZJnbFI4b3HWct+qRD2u6Nc5S/kJUpn/IxMeXEQJsYcnLkU84Gop6YUxWtyyJ9BG8hG/msf7sQERYPQRN/9onIw3Ls1dEvAFYcy8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tZ3Au8nK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tZ3Au8nK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=EZ33KpYHWMPedyeds8lUac8/M0wQeOwN+CN6mKRWd8w=; b=tZ3Au8nKvRz2BIaPwmcXRUsrfv
	vfi0nxW6G4uuforrOouk7Dp0+wpCOsWzjm8y3LdqXtp0s+L07IKYO37OwJ0LYsmm7Fw69Tjryr5pQ
	Cdf/nXDG8aLO5WsuQ06JRgk3hbrkHNLt/gzZQ4R4kIDm/r16R30zD2TMfbUCa9bcn91IYjl0ByxcG
	5+QD8C+3It7DqlbN8e1QP2jI0057HIQIxwVHHH58biIJu12qBLf3p2Epp8yDoBjq39p6+pvalhuTn
	9oV6MwXbfo9HkInJGq8ItUDC9vaxaRCRaS0LYU0xjKTCZAUjY0LXJ55P17rmJRa7nxsX9ujG0gBPu
	vyMDV/3g==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiH-00000004PLX-3IjU;
	Wed, 26 Feb 2025 15:52:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: use folios and vmalloc for buffer cache backing memory
Date: Wed, 26 Feb 2025 07:51:28 -0800
Message-ID: <20250226155245.513494-1-hch@lst.de>
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


Diffstat:
 libxfs/xfs_ialloc.c    |    2 
 libxfs/xfs_inode_buf.c |    2 
 scrub/inode_repair.c   |    3 
 xfs_buf.c              |  371 +++++++++++++++++--------------------------------
 xfs_buf.h              |   25 +--
 xfs_buf_item.c         |  114 ---------------
 xfs_buf_item_recover.c |    8 -
 xfs_buf_mem.c          |   43 +----
 xfs_buf_mem.h          |    6 
 xfs_inode.c            |    3 
 xfs_trace.h            |    4 
 11 files changed, 164 insertions(+), 417 deletions(-)
