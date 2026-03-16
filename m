Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50053A1A2B
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 15:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675742; cv=none; b=gU/o1Rd4sdQaKiuRVNXksc1kvkz2UEIttUm8+Iv08phuvwUcPiUDz9G9cT1f1PgeNmLtZvlK8zwnrxjchLJi4Bo+JsEQEuFtbMB9EWpvqRprL2RQNK3i30s4qkh5dOqQ40IkR8wn/v6bBlWQINV80rq8eJQmruRjw0puBn+WMUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675742; c=relaxed/simple;
	bh=MChR2YiVZfOYgIlY7JIqe6OucPNqwC0TBQ6GGGNAAt8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aGDi01Wl4hCXpgfgDvpap9Am2c6IgAOm1FftyHD6OFPu/ajIStAw6H3qG7EaoxBSw9xczyelmvWvI1gTXGeU3LigeVAY69/yVf2psaIeE+3JVPSE5/wPsWIOj/Wkg/5CG2vnNWzyZ5OMuFatiKjy/WrNgVXGhfNpkq1SxH0dbWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rzOfqnWT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rzOfqnWT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4VWsNhJ3qefZcJVhIWKLPOVwPG6ErhIkUBgJPoUzLAM=; b=rzOfqnWT1nEBTI1wuGjc3RQeRX
	BvXz+R/I++/JrsBJNuny6Ha4qnh2VpdoBRtIq7aD6y3jbDBFw0MRsXApV/sRVWh++D8EdKKq0+kYa
	Z8lJv7CvepFdUvtDLGLRdlY+onB2QGlduN7a9c4ouAcTFapVJeVHGdolngwOTtriykhR6/6TpAMBR
	C+Xeb1LA5COK37+T4QKzOE8OUbqLRC+peVMJaLAtFrtbVBoW/uZXkgz2xRM6kQ6J28XPjTpOnVMQG
	V+PB1y+gj3hJIWm6jcgSV410m40tH28Ic0FwCWpaKIiLImxXwQItBTuE+Td3JMtJiN+W5922UFto9
	oE02JLHw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2A5D-00000004MKZ-3D5Q;
	Mon, 16 Mar 2026 15:42:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: buffer cache simplification v4
Date: Mon, 16 Mar 2026 16:41:32 +0100
Message-ID: <20260316154216.1598410-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has a few old patches that simplify the LRU handling, and
moves back to only having a per-buftarg hash now that the buffer hash
is using the scalable rhashtable.  While some of this looks like
performance work, performance and scalability is unchanged even on the
80 core dual socket system I test this on.  Besides cleaning up the
code nice, it also happens to fix a syzcaller reported use after free
during buffer shutdown, which happened incidentally because of how the
tear down of the buftarg vs the perag structures is handled.

Changes since v3:
 - split the change to handling how referenced buffers on the LRU
   are handled into a separate patch

Changes since v2:
 - mark b_hold as signed in patch 1 before removing it in patch 2
 - document the changed locking in xfs_buf_rele_cached.

Changes since v2:
 - add more details and a link to a commit message

Diffstat:
 libxfs/xfs_ag.c |   13 ----
 libxfs/xfs_ag.h |    2 
 xfs_buf.c       |  148 ++++++++++++++++++++------------------------------------
 xfs_buf.h       |   14 +----
 xfs_buf_mem.c   |   11 ----
 xfs_trace.h     |   10 +--
 6 files changed, 66 insertions(+), 132 deletions(-)
