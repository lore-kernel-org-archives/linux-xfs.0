Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D742331A813
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949706; cv=none; b=YtZWcqUkKSCg7BdqLKCGhl9/EY+T0prC4GxSsvYuBpS7cqjo/g9vr6L2Gz1qng+V6Yi78+YDJUOIu1UnlFW/xo2RcOok9aKhrkm4kC3u8CtxTgDhoALXENPcoTmlPGM98IB0Zk337ptAnaIM6gf0PYz84iZeNao8mHDRyi8/y3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949706; c=relaxed/simple;
	bh=qGS56OHIhS9QyQuGCBMKWKzUb91JcZNiRTIvo4f7hy0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iMf61pjLWFPrUlNwGI1rRf4L194q3c3a61d10CRbvgHmVeN251fwwCA3EXMXFLlqAsn4E5GRXN84Zv1r/WDB0yJwwyezHltFV8NkANNeOPQdoNT6q3OBOvAROClWt61ahnbttRKmIPjhUOmsRU+OtS1lblWjiAErY21HYdXYFuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=21ubQ3rY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="21ubQ3rY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ER8bQn36pSP2SdiIymdd9YrsSLt8cKFDRSHhJswc11s=; b=21ubQ3rY0I7ga1YiX3k/DNqIJr
	QBEuDfgIcBRE2w/GzpOSBIHXR74ht/qFkksSsEog1FH6ueTBJrXBUAZgsYyVkNg5/hJxCDXwfpCHF
	1uRazRzgw5Rijb/ThAgliwCuUlSZ82ZvNi9BcBK5x0jxIOS0uQ9QMIBLzcZ9lbBje5V8XpBrvwaWU
	MmwVLzNHrxXCtDXjdYMfNQ71XkeClfV1VPV5NCEx3TaJ+umflqyAwRgG/4idiqun5xk5DvfEOejVh
	N+xctb7fXoTijPsojOGH/lIn3hiXQiTgHlb7ymzv4GnOO6f20MBXiX5+Sf84Fm9yS48Hf/TTRzXMv
	vEXdUZSQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ9kb-00000008l9z-487m;
	Wed, 12 Nov 2025 12:15:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup log item formatting v3
Date: Wed, 12 Nov 2025 13:14:16 +0100
Message-ID: <20251112121458.915383-1-hch@lst.de>
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

Changes since v2:
 - rebased to the latest xfs-6.19-merge branch
 - expand and improve a few commit messages
 - add a Fixes tag

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
