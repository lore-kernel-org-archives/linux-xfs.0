Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D35412E6F
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708672524; cv=none; b=s6NT1hepqD0FbWALsk3oWlFi8wWQtsGrlmjWRHJ3rSIRs5YDtJ+5wTHk/nEKfrBceJWeDZh0VkBQNP8ddFLAXNe+qqvyaPl69zZntUru2Ul0HqGAmYlCHpCQjA8e4x3fDmgxZX63sD8yPLkAmmDdtt9hsqPDbrhmimT7bQx6vAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708672524; c=relaxed/simple;
	bh=9BdjrcZIW6BvYGv/SVW/jYMZeHmgAnitTPDR0BDIIyk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kxe8WH9jy7phveQAZ3pOiYybbK8z9UMNZML9RIt4AZsENGORUct+PmxZNj8fJSb1YcNOjx4MqQUwy2xa8xxOgHtpbGwaUbEqkM1G2qGf6QNkLbaESI796q0Q93zSnhJTJ0ec7ZHeX/O0BEQjXjPtr6RHtxunkCOA3/MJiMMArKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AmAb98cG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AmAb98cG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=AChq2371UXaWp5o5OHcfHDADzxzf+K70MJih4dzAi3Y=; b=AmAb98cGBRBTcXlrdlEiB6UKq4
	nJxMbq4Gnpxu510EhMSPx07jeDXfjT85zBToOZVl5Hg12wuUOpOsnCvZ8pU7fLvjdmiKRpHm64V+k
	knzU6glIkZ5cSA49gtbal4GoakqBVXe36NJ/0Lkne8Kxw/uRTKPWFf9D6qCerhZJNxDkQcz5Ut/6U
	Pl8awevxk25nkrKwWxixNxlW1iFa0BrOffccu0naIxVcdn3Ew1Iqa2DCs//MR7hawT51UjPZ1fHsz
	Bv9AmTIRQ00LJN1m3wkWNprJrwMIDAiad251VF+nIkdTo1R7PyfDBKEMwbZXkPNIYHwwp1sjOnsha
	ltgCf+2w==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPm1-00000008Gpw-38Yv;
	Fri, 23 Feb 2024 07:15:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: bring back RT delalloc support v2
Date: Fri, 23 Feb 2024 08:14:56 +0100
Message-Id: <20240223071506.3968029-1-hch@lst.de>
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

this series adds back delalloc support for RT inodes, at least if the RT
extent size is a single file system block.  This shows really nice
performance improvements for workloads that frequently rewrite or append
to files, and improves fragmentation for larger writes.  On other workloads
it sometimes shows small performance improvements or flat performance.

Changes since v1:
 - keep casting to int64_t for xfs_mod_delalloc
 - add a patch to clarify and assert that the block delta in
   xfs_trans_unreserve_and_mod_sb can only be positive

Diffstat:
 libxfs/xfs_ag.c       |    4 -
 libxfs/xfs_ag_resv.c  |   24 ++--------
 libxfs/xfs_ag_resv.h  |    2 
 libxfs/xfs_alloc.c    |    4 -
 libxfs/xfs_bmap.c     |  102 ++++++++++++++++++++++++++-----------------
 libxfs/xfs_rtbitmap.c |   14 +++++
 libxfs/xfs_shared.h   |    6 +-
 scrub/fscounters.c    |    5 +-
 scrub/repair.c        |    5 --
 xfs_fsops.c           |   29 +++---------
 xfs_fsops.h           |    2 
 xfs_inode.c           |    3 -
 xfs_iomap.c           |   44 ++++++++++++------
 xfs_iops.c            |    2 
 xfs_mount.c           |  117 +++++++++++++++++++++++++-------------------------
 xfs_mount.h           |   41 ++++++++++++++---
 xfs_rtalloc.c         |    2 
 xfs_super.c           |   17 ++++---
 xfs_trace.h           |    1 
 xfs_trans.c           |   63 ++++++++++++++------------
 20 files changed, 276 insertions(+), 211 deletions(-)
