Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EFC402435
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970875; cv=none; b=rM2HCQWhl02YeyPdaeRsnQ6YhRg/Ks0ixAAg0N0O5lKzyoYulOx6VPMmiUAQjSVqA5yVSCYZE9Cpd2JvGKC/7gbwQ6D/j5ckjg4vRsQ6xMdwO+xJsi8FdzvJRo4K5XGgj6DF7nNhPOi+1aFcogl2YbG4PXkVkojdyhH1i39z3QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970875; c=relaxed/simple;
	bh=6TW7zkcTYipdi7BGXFB0oF3lUJB0akpN2ooQ4vSmau4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FkvOTawsn9k6C57T5J0p+i02BQVtbV1+jXMWHAyrKOm6rrgAWtuPRjqPx6xGNACpxUN8UCFaTnH6Xmuchz+Hh4SQ+nt3cDEqGCQM2F3bzuornAboheSW4Af1p+BCmuoQW7Kzv1q0WN7jKWlsXfUlXECfcKAx7kdzeh+KZwwxXbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Sxan7P8L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sxan7P8L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZnhnYLy1uksDbGS/3ikdgbaxp1WccpoX+1mNfJHoLA8=; b=Sxan7P8LmmvpxOXeqkatj+eWL7
	aHJRiC7CS5mBUknw/46FjdPvjc2BTyncOMIZ65975jm4by9so2U8FfgErLRiIxpZPmBAX3O7YZ76R
	/G2aBiBJ91avRWaL76TuGEA8vErA3SayWiQC2lfUqwbTn0axsCsI7+XRxILnn37n/c127R+d0/dRJ
	lTjRBLCriQ5PZCjnLWighPBKW0FtiZCu7zOAwo+tzHdsEdv6kR+amYkpFoQ0lPiEXfpmOgI57VO2M
	arCYHy64p9ZD7EFMsPR0dvSbRxAR9l0ZnHr6C5adUCrpoKgtc4IFmLij+L8bfKIrnq98Lk8fn2jVY
	sF61MJnA==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7b0U-0000000DBDG-02CU;
	Tue, 31 Mar 2026 15:27:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: cleanup open GC zone handling v2
Date: Tue, 31 Mar 2026 17:27:22 +0200
Message-ID: <20260331152751.4048218-1-hch@lst.de>
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

this series cleans up the handling of open GC zones so that the
reference counting works more similar to normal open GC zones.
This cleans up the code in general, and also helps with experiments
to support multiple open zones for GC I've started.

Changes since v1:
 - improve various commit messages
 - move over two patches to heree from a different series
 - use READ_ONCE in nr_open_zones_show
 - fix the nr_open_zones_show documentation

Diffstat:
 Documentation/admin-guide/xfs.rst |    4 
 fs/xfs/xfs_sysfs.c                |   13 ++
 fs/xfs/xfs_trace.h                |    1 
 fs/xfs/xfs_zone_alloc.c           |   21 ++-
 fs/xfs/xfs_zone_gc.c              |  230 +++++++++++++++++---------------------
 fs/xfs/xfs_zone_info.c            |   20 +--
 fs/xfs/xfs_zone_priv.h            |   15 --
 7 files changed, 152 insertions(+), 152 deletions(-)
