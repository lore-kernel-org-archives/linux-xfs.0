Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83127376BCB
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 06:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768373635; cv=none; b=giIkXiXq/l818UC07JHEAShnBHpxidgUQuoMDmI6x/XGKYarJSDXt6cWpIFV3m2yC7XsJREA2knPmqx97rH5mWD+SweBuGXOU9wLq4oHcZLPJG09z4FTbEWzIyglVQrFcypChtOA1boCwwQ1HVLf71Bi3NDXp1X85P8eYK8wwvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768373635; c=relaxed/simple;
	bh=mOPltZ5VM4QApHZMHcPQ7lnxP4SHoaBjPqQKVZWBk0w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kGi2/tqLxd0VCpkrNPYB3+wzjv7BJXDZ4TzT7prAIPbUGfPepLoD104Ke0DpguIvsUT6sJOjIkwGqrcIyn5ccG+2FUf4y+XI5RRODRcZzxs+k3zBAe/H1pRx4JhcfhTXv/p3Ng9grHIgi44JXr9zY96P+aLwmF7YWC19NKahVXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X1UbODN4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X1UbODN4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gZp6f8psxCsZOI7FmPN/1pAkzUMwvg7b9HHvftRa80c=; b=X1UbODN4t4jnXN15VFnLsuD++f
	4NRMc45dRwtSHJGHxIi+XsWE/9+AuhFqD9p9TC8QEKeDM//GITm2dsHxSIFfOngkmwzR+a6snWSe5
	2Ffsmfepfa9/+ZuYq3EDNmqMAKEn0nAvwUHy/3ltLM+MkR5Mc+MAwicAAIEGjgbInapYbcNc5y/sJ
	Tfm/+MIWO0KW437y5a4nh6MWLTEw90ODvF4hGLHbWcc6Z9ps+nGPdmJNyrfmli4GIw6PCeS0s0PGn
	DgyCmLdYgpHq/a7caAlGZbinuh/KKdJLVtrWdFaNdHZ/xyFLqxEcdTYsOwTwfcW6/DPAXI8eOEMI1
	wBKtdebw==;
Received: from 85-127-106-146.dsl.dynamic.surfer.at ([85.127.106.146] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfulD-000000089go-3pHk;
	Wed, 14 Jan 2026 06:53:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: refactor zone reporting v2
Date: Wed, 14 Jan 2026 07:53:23 +0100
Message-ID: <20260114065339.3392929-1-hch@lst.de>
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

this series refactor the zone reporting code so that it is more
clearly split between sanity checking the report hardware zone
information, and the XFS zoned RT information.  This reduced the
code size and removes an iteration over all RTGs at boot time.

It will also allow to do smarter checking of hardware zones and
RTG allocation information in repair once ported to userspace.

I've also included Damien's xfsprogs patch to make xfs_zones.h
compile better standalone as it touches the same area.

Changes since v1:
 - merge two functions in the final version to be a little less
   confusing
 - rename one of those functions which later goes away
 - expand a comment a bit
 - rename the libxfs zone validation to make it more clear it is
   all about the blk_zone

Diffstat:
 libxfs/xfs_rtgroup.h |   15 ++++
 libxfs/xfs_zones.c   |  149 +++++++++++---------------------------------
 libxfs/xfs_zones.h   |    6 +
 xfs_zone_alloc.c     |  171 +++++++++++++++++++++++++++++----------------------
 4 files changed, 156 insertions(+), 185 deletions(-)
