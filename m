Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20DA1862
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744608997; cv=none; b=dY8H3+6Dc/TtQufnnTvvS036V+ydthwUO4Fmo6MLqCzs8kFHh6dByq7HHiE9p/weTV6Hj1cVQPLT4dsm7HjR9V1FRD33IDIEmbTKFy9poYJGG+HXQzczv7dwUGS8yAH8hLFwoQckL90ldbnDWL/V+6EYRT5+apwQo+qHOL+wEQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744608997; c=relaxed/simple;
	bh=tWS6z24cQfF+ziQSv4Y3tmqa8ukuJ014kizoNWG035g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RQVvODoUmp93orahPwdw1HU5Pm4qtaZxkZCufYGkvVqhIl2uSyd9DFYgCxCvdXAl3QKb5PMessupVVblU5ub2ypJ8xlSvYth5R/6lOeByeikcIRz31dqYdtfeUfmSTuSzVHqqiRcjRw9O19hMskeFUyIpOdltZggVgH/0P7tscs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J2P6ozxE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J2P6ozxE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=VbGR8ZmHxluO/xbmcpcVo1qsXQ/PBV3uqIZI+2fbaTA=; b=J2P6ozxEcfmm6iDlMxYeQ52wrB
	v6Sr7hL8A/0vekgwQTNWcwYMZ5NyjhntRctuvH2m+1nrPVZUmhXoD5ibQQ6jS+U1AbNNHe2VuRgze
	fZ9LFtS9VSn2f2qM5yBqigWpCengArhvR9kr6cwdgTilaF0RNUrb4c3UDdTLQ34WEV4GoNpYu2im3
	ojo4kswwe8TD5zvozBi/sABdo9OF4XZm7Frsqw6udgtMOx/pAaGi/hdY+8Kk9fqvvie6Khmb/1FNi
	fy/TuTg4qNf+WaqOTh2BXmj60wC41iR660wn78AUu1I6i8wotgNEITsthqMz/m9+vv4f5Aq7Ux83P
	v02mxv4A==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CUk-00000000i6t-0zT7;
	Mon, 14 Apr 2025 05:36:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: xfsprogs support for zoned devices v2
Date: Mon, 14 Apr 2025 07:35:43 +0200
Message-ID: <20250414053629.360672-1-hch@lst.de>
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

this series add support for zoned devices to xfsprogs, matching the
kernel support that landed in 6.15-rc1.

For the libxfs syncs I kept separate fixup patches for the xfsprogs
local changes not directly ported from the kernel to make rebasing
easier.  I can squash them for the final submission if needed.

Changes since v1:
 - improve an error message in mkfs
 - improve the comments for the new i_used_blocks field
 - improve commit messages
 - add a rtdev_name helper based on a mail from Darrick
 - consolidate geometry reporting in a single patch
 - consistently use xfs_rtblock_t
 - fix indentation in check_zones and report_zones
 - use BTOBB in check_zones and report_zones
 - spelling fix in the mkfs man page
 - s/log/RT/ in ioctl_xfs_fsgeometry.2
 - fix a hung that slipped into the wrong patch
 - split creating validate_rtgroup_geometry into a separate patch
 - add a comment why cfg->rtstart can't be overridden for zoned
   devices
 - drop "xfs_io: don't re-query geometry information in fsmap_f"
   because it was causing problems on non-xfs file systems
 - use sb_rextents to check for a present RT section in
   process_dinode_int
 - check for rtstart instead of XFS_FSOP_GEOM_FLAGS_ZONED in scrub
   phase1_func
 - exit on fatal error in report_zones and report errno values where
   applicable
 - report BLKRESETZONE errno
 - allow overriding -d rthinherit
 - merge the two scrub patches
