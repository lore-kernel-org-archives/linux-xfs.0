Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C9F38DC53
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328192; cv=none; b=Q63Oa1UlieAGgCibzWrXf0xLFocWs2rTkSIspG1XVBMZ8c++lWIIx8wWIbYZOkENWKMWe0ZmnhDhw71jACFrux0w/I4gyTm64VXudWV+D5xlQ+BFRFr4YuYBQ1BuAld6r/A5EpvBFBGss6ECwpAG1DFIDHsisqV0KY8OWtOnx8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328192; c=relaxed/simple;
	bh=Qju/g4MdpU+Zt28Hx0S0EK4ezjmT7tr/K6bLjp9f5sk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gYo3FmhrZjs3PY0/KVIoA3PvYGwIHJ3Kb8Wliv8T362EE6qsqPdgAJDLJGJ5aDcLr6eal7SioQcEJb28TzzRkDnRoN+cWDZ/CkyJi7fNlo9ElkDEl4wdlr8VDvroeT+3WVWoV/5KMr9Fq/QYaR3qAKuVf571gSYiuF8CX+x6Zc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xboxU8TE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xboxU8TE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PZoHkTkHW/NT9BypoYDzcQeLhdizlRbVo4N/TTI0f8w=; b=xboxU8TEH1wnSJzOEV0hZbQzD6
	FCYWpXAd3+0m+ffedCtgRqnNJ0Wg//4LTz1l5bFtxAbXHBebN7ns5su+N8KQwFVZOSywtfTkfWULN
	+tdFe3rR2M1w5vXa5cgUqP6agOkqh6ryrwl2omYmVvjgLtVeOnmpUIxSQtO5+5x0Ad3XaXI6pDtRX
	B3yX6Wi9fXw8Cu7MFib8zYENdrSlb6YVqKWOUz5C0CeISUjFTSBgQObej8WvHrMviCNjAz+NRDQDV
	dI9qezo2h2JlOuqv+WYRAe4zIZTeRdePery2lsJkLgMzHLJ+bEwtYfzWFH8iXrV0dV6RQqIMMgaQd
	d+FfuXGQ==;
Received: from 87-119-185-211.ip.elisa.ee ([87.119.185.211] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1dr0-0000000Dp4d-2bV4;
	Wed, 02 Sep 2026 05:49:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: fix and then optimize cache flushes for the RT device
Date: Wed,  2 Sep 2026 08:49:14 +0300
Message-ID: <20260902054942.111988-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

when tracing workloads, I realized that currently the volatile write
cache on RT devices is only flushed by fsync, but never at all for
workloads that do not use fsync.

This series fixes that, and also optimizes cache flushes for file systems
with multiple devices.

Diffstat:
 xfs_file.c     |   50 +++++++------------------
 xfs_log.c      |  113 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 xfs_log_cil.c  |   16 +++++---
 xfs_log_priv.h |   10 +++--
 4 files changed, 129 insertions(+), 60 deletions(-)
