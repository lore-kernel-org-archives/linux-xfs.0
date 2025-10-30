Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDA62367DF
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761835790; cv=none; b=CuUgCxslJ7jz82242cDYkH8W1R+75R28PuyRYiDBIu762RgEWphx5UczLrjCBjv9+ykVrplm8LDWabR0+5objI55RVL2dgbWXOaFEyn/QvaMBXIJg+/O4rrs9sk8HQ1/jrUDMoOHdVsRYVvpznqVLjlz1oLb9IQxu3zrhZQXmn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761835790; c=relaxed/simple;
	bh=JKUkYQFYfSKuY2NAj4FakhbORQRR18EzkK5lE8rhiHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k/L2Lgf3Z5LcN4yVbcgWGeJQ948bRG62CLrmMD14q2pkOH4YggNzBRRtyNJb35LwZhq+MiuhCEsa/xc5bYL/WFxKHMRLWG9rpgGBjBzvkfxPjE+lOy4NpTlEhD/6cFIRQBYD1XExXbXNvzZqF5u2AXE6fKKiklcHf/g5/AY8WOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f2xuHqKx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f2xuHqKx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=GL4nK2rwPgl1hgz3ZGHdIvmdZV3SdM4uIuzoVO/jG3s=; b=f2xuHqKx+ec3Abnc9RqxVQF3YH
	1vHDYzn2fqzccvivelYuPs1M4+qwgBQU3hJbldI0ctQ1P1cGfsdJdDEBOU0tDyhpHvrHsxqENZ654
	ulCyzWoy46GtJ+CxW6oUe0rol2sfP7xyZGot8Auonei7wd9b37NrxbDl6GY/gf8m/408Pq1QtpG2f
	a/+57WJ4KphIa2MGQ2r39K/Fg3mbidzaa74MZzI3mto3tewFfOqKqZoMQYC4eEU/eQVsHaAWFBQCz
	lDLgVOnnbJH9hb+6Wg/iC/5MiS0j+ks4eYGjTLzIKaSb0RIaXzcWXkrvvNve+YYZkkx2iBtQc7b39
	qulYcgLQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vETyG-00000004KMs-1gGA;
	Thu, 30 Oct 2025 14:49:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup log item formatting v2
Date: Thu, 30 Oct 2025 15:49:10 +0100
Message-ID: <20251030144946.1372887-1-hch@lst.de>
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

I dug into a rabit hole about the log item formatting recently,
and noticed that the handling of the opheaders is still pretty
ugly because it leaks pre-delayed logging implementation
details into the log item implementations.

The core of this series is to remove the to reserve space in the
CIL buffers/shadow buffers for the opheaders that already were
generated more or less on the fly by the lowlevel log write
code anyway, but there's lots of other cleanups around it.

Note that sits on top of the "kill xlog_in_core_2_t v3" because
a struct removal there sits right next to a struct moved here.

Changes since v1:
 - rebased and dropped the already merged patches

Diffstat:
 libxfs/xfs_log_format.h |    7 -
 xfs_attr_item.c         |   27 +---
 xfs_bmap_item.c         |   10 -
 xfs_buf_item.c          |   19 +--
 xfs_dquot_item.c        |    9 -
 xfs_exchmaps_item.c     |   11 -
 xfs_extfree_item.c      |   10 -
 xfs_icreate_item.c      |    6 
 xfs_inode_item.c        |   49 +++-----
 xfs_log.c               |  292 ++++++++++++++++++------------------------------
 xfs_log.h               |   65 +---------
 xfs_log_cil.c           |  111 ++++++++++++++++--
 xfs_log_priv.h          |   20 +++
 xfs_refcount_item.c     |   10 -
 xfs_rmap_item.c         |   10 -
 xfs_trans.h             |    4 
 16 files changed, 313 insertions(+), 347 deletions(-)
