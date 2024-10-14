Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8F413777E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 06:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885922; cv=none; b=RQ9M8cigHQGY5FpCgtDX10VrRARbg54Qh68pevbFWsrOt29q+ylC/lrDICzuI/KvTtGQ17C+WE+IeSrltDQJMo4GUNp0+qMH+8um4PagYx8M/1Bi7tsgdEcaCTj8NM9YawOftITuMiHJy65b6wUl47QRDU5M5rFQi+/GMqWYjak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885922; c=relaxed/simple;
	bh=V6xzH/KNJzL40bqIVFD3hnM1zvIkoHXV9heAgAjC0VA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YbxnfUaH7ReNsX6CM1tAdo5ABbI2qwGQUHVC4Q1B+pbmE3Kzbi3TjhUQ4/eoQUpfV+ukN+PdMMDW/EFW6uqJPA8cM1c1X5cj/Tb4yGWfP0LGENMghrG9Zz9/NCwJcWz63VDRJZj1aGGhOTypgdCV1uKiH95HrXdsst1oi2uyykU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QQSw9YhP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QQSw9YhP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=sellLsw+XG+iVQTLTSKjWKcPIV72oFuc5UIQsgVC32o=; b=QQSw9YhPrUk0RoMUk+Lf7XZd3w
	NUTfJ2/rpejPmZtNOFdkbDYGpheImQZ24FFXXzMHSemUu8eCmiOibrN+Opq/WoerH2CHNYTyU/XHq
	epHP8w6m6KYWc4I8Z4Bo4fgPyVOQK7Lvf+t+NmhvFirZLrxyJC3tPyXgDj1dNQr0+0AiOeI/qIdhe
	4T9VDEq5lIBIgZ/vOQw1q+hbRgg4urgjKUEXYP8JaC8712rpeC5S0qx8dDmOIhYZg3M6/8G3tWIsv
	5CH0vssh4DcglulYLcwzVK41xZktDPpms6u31TTCitoBdeZFrTxx7iTH/4zzOpyJ02GSJCpDURnat
	GST08gdw==;
Received: from 2a02-8389-2341-5b80-fa4a-5f67-ca73-5831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fa4a:5f67:ca73:5831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0ECm-00000003pd1-181E;
	Mon, 14 Oct 2024 06:05:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: fix recovery of allocator ops after a growfs
Date: Mon, 14 Oct 2024 08:04:49 +0200
Message-ID: <20241014060516.245606-1-hch@lst.de>
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

auditing the perag code for the generic groups feature found an issue
where recovery of an extfree intent without a logged done entry will
fail when the log also contained the transaction that added the AG
to the extent is freed to because the file system geometry in the
superblock is only updated updated and the perag structures are only
created after log recovery has finished.

This version now also ensures the transactions using the new AGs
are not in the same CIL checkpoint as the growfs transaction.

Changes since v1:
 - rename old_agcount to orig_agcount in xlog_do_recover
 - remove a redundant check in xfs_initialize_perag
 - remove xlog_recover_update_agcount and fold it into the only caller
 - add a new patch to update the pag values for the last AG
 - add more detailed comments
 - dropped the changes to ensure post-growfs transactions touching the
   superblock are forced into their own checkpoint for now.  Based on
   reviews this needs a lot more work, and isn't needed to fix the known
   failing test. 

Diffstat:
 libxfs/xfs_ag.c        |   75 ++++++++++++++++++-------------------------------
 libxfs/xfs_ag.h        |   23 +++++++++------
 libxfs/xfs_alloc.c     |    4 +-
 xfs_buf_item_recover.c |   70 +++++++++++++++++++++++++++++++++++++++++++++
 xfs_fsops.c            |   20 +++++--------
 xfs_log_recover.c      |    7 ----
 xfs_mount.c            |    9 ++---
 7 files changed, 129 insertions(+), 79 deletions(-)
