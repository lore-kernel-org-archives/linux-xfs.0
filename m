Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A13C7083C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532608; cv=none; b=C5gkTGwf6wEZSXmwLBaiqVQCQrnmeMo6PojTdmhUkixINUpTVfJLLz027Q/lWsCTCpyFZZsHUZzeFlBzlGcCV6dYRRzk0nRmhz95ttvJjXNk85l4lgGffypEUcLee86uYnPMF+WhVYVwY91c9l3r9d4QG28vkWMPSnvAy/u3aUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532608; c=relaxed/simple;
	bh=NI9zbz57OhJ7AC/3fkLbzB9iWz4RT2YOCpi7xpuJSBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=elDHT1bra3mQx8VxdUlUXXCTNgkKwnFK7LVaEVfkSBT7+UI2RHiNCCyIQFHx023hBbkgLC6BbjW4Hzsozv9EyWD7/Eoc4DscFb88kw97ganUVQueLp4PG7+csjuM6DRHOY+bilSAB29pIHO70TDy93iL/DAm4iIx4Npognh7QNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JWR9p6vu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JWR9p6vu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=kCaOQsYpAMXnxFpiPWXBX4OJ0wgUdDduM3NGSGjs7l0=; b=JWR9p6vujVhKPNz4X/6GyDSfcz
	E6P0Qfh7Plx1Ij1i3xp60Q1A0ksmL4lJdpsN86JZcV4FJYFFYw2AjrkZR3lI+25M1KyHTj6Kgjfzw
	XUy8uyRmO7/H19asJAAc0mhMfGmC2RnirzOPjHnT6Z0WDyII9/rz3VrAblRDA+D4sg9O13yrFNODG
	j5dS07LyXCqlY9Ii5Js0EMafA8biufGkwrLK+pIOQQIc0dqwBEC3d8LnTmIpq8tKM4Viu00wuxhG7
	Ex4UuFDxSS6YH0sny9dFgYlA1U8yr58cDGvJqogRoBSZ8sTFW1cHo70wk+244wbGSfEPAV7nZ7hCF
	+mnTYAVA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrLq-00000005pG4-1kVt;
	Tue, 10 Jun 2025 05:16:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: cleanup log item formatting
Date: Tue, 10 Jun 2025 07:14:57 +0200
Message-ID: <20250610051644.2052814-1-hch@lst.de>
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

I dug into a rabit hole about the log item formatting recently,
and noticed that the handling of the opheaders is still pretty
ugly because it leaks pre-delayed logging implementation
details into the log item implementations.

The core of this series is to remove the to reserve space in the
CIL buffers/shadow buffers for the opheaders that already were
generated more or less on the fly by the lowlevel log write
code anyway, but there's lots of other cleanups around it.

Diffstat:
 libxfs/xfs_log_format.h  |   54 -----
 libxfs/xfs_log_recover.h |    6 
 xfs_attr_item.c          |  156 +++++++-------
 xfs_attr_item.h          |    8 
 xfs_bmap_item.c          |   28 +-
 xfs_buf_item.c           |   27 +-
 xfs_buf_item.h           |    2 
 xfs_buf_item_recover.c   |   38 +--
 xfs_dquot_item.c         |    9 
 xfs_dquot_item_recover.c |   20 -
 xfs_exchmaps_item.c      |   19 -
 xfs_extfree_item.c       |   69 +++---
 xfs_icreate_item.c       |    8 
 xfs_inode_item.c         |   55 ++---
 xfs_inode_item.h         |    4 
 xfs_inode_item_recover.c |   26 +-
 xfs_log.c                |  503 ++++++++++++++++++-----------------------------
 xfs_log.h                |  106 ++++-----
 xfs_log_cil.c            |  195 ++++++++++--------
 xfs_log_priv.h           |   29 ++
 xfs_log_recover.c        |   16 -
 xfs_refcount_item.c      |   44 +---
 xfs_rmap_item.c          |   44 +---
 xfs_trans.h              |    5 
 24 files changed, 668 insertions(+), 803 deletions(-)
