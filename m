Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F2F15E96
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 10:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751366492; cv=none; b=eFoAPo77SL/rvqIXgzapPhfhwgpefQp6w/S7UgZI8fdXjzU/wvlZjorn5yY9tyKUgYQerjjKC7qmT59SoTQVkwLttX/hAqkqT4vOfJvw75NP4LaI/EJSN0zmBL/9q/vMWCrv7WGBUfVbI9QEp7SsVVxof6n1Vqs+GpXWDbVF41Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751366492; c=relaxed/simple;
	bh=N8U+IQhqCbKkHzAnOk8Yso5aGWQ2ypHpI5BzosRszmI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bY3ETwJ7b7GsXrplx4OYZ9Zp+JifcrjaBUCrOlJ5mxKpWZXtR+nx7U6L5LC/o5Jwh7+c2hEOzrRCld6GTyGRjDLL25fDdL0XuF6dJSdLknuTS5fTiYT5doBeAvqcfnQGoBt3OgwISKG9gHLbmS1mbxs0Je4jJtfKcBLZ/PSMqRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W266YvJg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W266YvJg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=O3mpaLe1p5tbBse0XHnd7cs6tAkAxSXcYaO1EA0im9w=; b=W266YvJgF2q5tjlGJvvrJcikep
	aXtFHiy7cIFIqcf5VbTn3k+x8g9y5dYPLxxtT5vtQrjYsUUjjgCbcowUt81pGpEjdobDVa3n4HHXo
	Vx1oDxTp0XU1EiCWoGJlKf/GRBol1182xhuVG0MeRTx4exCmtPFncE2ZoI1gfxHcuRrEqHm3RsLfT
	n85GQD9y4Fw/tvj5e89QvFhXSEvx7TfaPKvFeyMp7HLZ3omBWCBFY0JW4cf9jWArlYNH2LPxwG6SN
	pm/di2FuCKsaDAA11W/V0PLFXgMUjOzJVah1H4QKT1R7A6QfAU43ddNsRXwi1WzXjihaCBcvTBAhh
	zgWyuwpg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uWYQb-00000004lyy-0nVX;
	Tue, 01 Jul 2025 10:41:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: misc cleanups v2
Date: Tue,  1 Jul 2025 12:40:34 +0200
Message-ID: <20250701104125.1681798-1-hch@lst.de>
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

this series has a bunch of cleanups, mostly around the mount code and
triggered by various recent changes in the area.

Changes since v1:
 - keep the bdev_validate_blocksize call
 - add a new xfs_group_type_buftarg helper
 - make the buftarg awu names even shorter
 - avoid an unused variable warning for non-DEBUG builds

Diffstat:
 xfs_buf.c            |   31 +++++-----------
 xfs_buf.h            |   23 +-----------
 xfs_buf_mem.c        |    2 -
 xfs_discard.c        |   29 +++------------
 xfs_file.c           |    2 -
 xfs_inode.h          |    2 -
 xfs_iomap.c          |    2 -
 xfs_iops.c           |    2 -
 xfs_mount.c          |   97 ++++++++++++++++++++-------------------------------
 xfs_mount.h          |   17 ++++++++
 xfs_notify_failure.c |    3 -
 xfs_trace.h          |   31 +++++++---------
 12 files changed, 95 insertions(+), 146 deletions(-)
