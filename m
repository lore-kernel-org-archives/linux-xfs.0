Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFF728FFE6
	for <linux-xfs@vger.kernel.org>; Mon,  7 Jul 2025 12:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751892809; cv=none; b=SXF7KIh3WoyCBwiwT1+QqApwtvpFaFNm2v4vNPGvP3Z26DWlgucFiJp0jf3LEPjch4knYnl9ZMmdRb83qyuOlAuCL++7H/t6Wa4s8oKOs2IoiewLNvMaw5T9GjfIpdFg75UyqsFAQ6qu1zQBCh6CfRSvLOv/kCznAxW+PWe9Pi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751892809; c=relaxed/simple;
	bh=cfZHcOzGNmOIwG1PTlFjTeJxEJEcR3icm7bVkhwscQY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uRRGi5iOXwYf97L3anQ97FRmqKt5HdXONp/XipFebHOvexiLlAwrsN9o/CksRA9KJmWP38gcsvCH0GvCujdRAsmoC6wtlAipR6s8r6pr527mkiVOSv6twIZPtkCSeu20wKWnGtJwUIZRF6/gL1nj0Z4qYG4353xGPbKjsSwMRVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wnnZmozp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wnnZmozp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=5wYw6Y7lTSddC45NkqBNbEGNlruNdmrgmdVpmmatiHM=; b=wnnZmozp/t5f0vIs7b4DWNq8F+
	Tru9RfYlW6XIFDdgyRezn41GqtdthGN8fV3tCAjrSzJrfp0L6/IZU/xEs/qWnMD1+VCsjbnJ3Q9Ze
	LtZ/XRdI/69CNobZUXHbtgK6Bbi2FJVz8AQPyuRaM/9AOIR9rTFhkP2XjlLLA+IVLPCe4FCrdj6Xc
	j/vMZy5qzYkgcTqpVJTQmSwwZNEZTrd2vfZpiPMECG1uUVaReRSnBU/nZ3hXK5JGU5hZE7AcmSLtz
	IZpiPF0G08lAqE53g/CFyhhNfUxmeifXtubpss7wm8x0CMn19QmRz3UuAAKnUeCS2VAHrBBsQKP7R
	WJbRhiQw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uYlLa-00000002Sgq-1uQt;
	Mon, 07 Jul 2025 12:53:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: misc cleanups v3
Date: Mon,  7 Jul 2025 14:53:11 +0200
Message-ID: <20250707125323.3022719-1-hch@lst.de>
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

Changes since v2:
 - drop a now obsolete comment
 - fix a commit message typo
 - drop the previously last patch

Changes since v1:
 - keep the bdev_validate_blocksize call
 - add a new xfs_group_type_buftarg helper
 - make the buftarg awu names even shorter
 - avoid an unused variable warning for non-DEBUG builds

Diffstat:
 xfs_buf.c            |   11 +----
 xfs_buf.h            |    7 +--
 xfs_discard.c        |   29 +++------------
 xfs_file.c           |    2 -
 xfs_inode.h          |    2 -
 xfs_iomap.c          |    2 -
 xfs_iops.c           |    2 -
 xfs_mount.c          |   97 ++++++++++++++++++++-------------------------------
 xfs_mount.h          |   17 ++++++++
 xfs_notify_failure.c |    3 -
 xfs_trace.h          |   31 +++++++---------
 11 files changed, 88 insertions(+), 115 deletions(-)
