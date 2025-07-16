Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DC62F5331
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669838; cv=none; b=Jrn42ZZf2gjvYME7rL15I0rKZP6nf922nqxks3O8m22VX1rQ3aQ4uk6uEhpKHayr869Fo2L01Kp7VU/wTd/kE2qmMq1R83NSVAETmRZg0J+01IMk4r6N9p5OnUHJxa7uWF5LQVmN8Z1xIbhuo1gLCHIcVp+2QHZ1Fhn66EuJJt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669838; c=relaxed/simple;
	bh=eNKcR/ziXJegIqTkbwrfVi2eTh3nNYI6ywRZgeRIOVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QAw+I4yk38lGaqBtCKaxgi/+aczMW48fvZSA63ioMGcIcon3cC0yye9BHbqbg65GDk4c+ERRLqsNQgtwYoG4Qf3KQPmWjePWGwrOPSiIVwV+UD5eaB7mkiQJmkK23vTxYPB4gwrlraPatSq8I/HkIqSHlMPRihqQpK2LhnFPBeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ADfvmCj4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ADfvmCj4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=OweSdYDUFvUy13VF5PZF1OKvODNWs+rdokrU4tOvWC4=; b=ADfvmCj4x/4noW52v1BnWWFOkS
	Ks+CSEg7CKJfft8mwrvkbWXAVzzYilOAS0CVUqzxU5ooj+B/MofA90Djkx0xGNvl53SSsbCqVo09i
	SPCUpjG5nSSuA97R7P3mitbvv5WP+ruT4YxbTwTMYYTxTzZ6/FlnbjPJysJlZsvandZgPFEr9fjVm
	PTXy2PCioSu45O6s7xLGBq4IGoY6PRcWISe9uNPUQ6NLtnDTQHuFr8HHlJ0RlaoCE4tgcYOKBSlMk
	XXHZSRO7tCol70RB2S7cwScQXG2z7eXJmt+3XhMY9vcm6fD02BovsZKUl/SLFYy3wmSb0sEIylVvP
	bbpM5mFQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1UK-00000007gsB-2P2d;
	Wed, 16 Jul 2025 12:43:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup transaction allocation v2
Date: Wed, 16 Jul 2025 14:43:10 +0200
Message-ID: <20250716124352.2146673-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series cleans up the xfs_trans_alloc* and xfs_trans_reserve*
interfaces by keeping different code paths more separate and thus
removing redundant arguments and error returns.

A git tree is also available here:

    git://git.infradead.org/users/hch/xfs.git xfs-trans-cleanups

Gitweb:

    https://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-trans-cleanups

Changes since v1:
 - drop the scrub handling for ->journal_info
 - clean up xfs_trans_roll a bit more
 - clean up xfs_trans_reserve_more a bit more
 - fix an potentially uninitialized error variable

Diffstat:
 libxfs/xfs_refcount.c |    4 
 scrub/common.c        |    7 -
 scrub/common.h        |    2 
 scrub/dir_repair.c    |    8 -
 scrub/fscounters.c    |    3 
 scrub/metapath.c      |    4 
 scrub/nlinks.c        |    8 -
 scrub/nlinks_repair.c |    4 
 scrub/parent_repair.c |   12 --
 scrub/quotacheck.c    |    4 
 scrub/repair.c        |   36 --------
 scrub/repair.h        |    4 
 scrub/rmap_repair.c   |   14 ---
 scrub/rtrmap_repair.c |   14 ---
 scrub/scrub.c         |    5 -
 xfs_attr_item.c       |    5 -
 xfs_discard.c         |   12 --
 xfs_fsmap.c           |    4 
 xfs_icache.c          |    5 -
 xfs_inode.c           |    7 -
 xfs_itable.c          |   18 ----
 xfs_iwalk.c           |   11 --
 xfs_log.c             |    6 -
 xfs_log_priv.h        |    4 
 xfs_notify_failure.c  |    5 -
 xfs_qm.c              |   10 --
 xfs_rtalloc.c         |   13 ---
 xfs_trans.c           |  208 +++++++++++++++++++++++---------------------------
 xfs_trans.h           |    3 
 xfs_zone_gc.c         |    5 -
 30 files changed, 151 insertions(+), 294 deletions(-)
