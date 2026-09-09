Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB30376A06;
	Wed,  9 Sep 2026 06:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934175; cv=none; b=CjREyeosXAJw1j63baUFaW81f+kV9jqW+pMiRIHct9aZJqGZjRJg0OEV7Hj4Rq5VE4F0thH4wx14BVjlDkq2cc6qTzgGSEJbSz/xEA6y+fdTJYDtBG+F3b5juhrNJOvagJcXsA42ahKICz1JUzTl+wBtIJjL/mGD/4z0J5UgZ5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934175; c=relaxed/simple;
	bh=r50sqoThbYc4myXpga5PehtlqgJWFPDPeWrAjzFeBBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GuGfDihEufUlGkml96UJli1ewJD4JV+0tLByojD/UI4jNqQQlq+w6pXGQE26weLG0DyalUTIfcGFy4SWkEhQFTrXRVkivFtxhfaj+f0aAJMG9Iyw5BQ+WjOBp2jtJN72+zp9h95zmX3ob5PGbg/3AfRtpOa4zFPVcX0XTxJAKfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v3pTO9qs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v3pTO9qs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=pR8fMHGb6lehlhbZg0P6MM/nYVxYu2HnDxXPvMOVor8=; b=v3pTO9qs0m/YggYA8bOwTyrS98
	pdyoqrtkaxY+LiguBaF0qZWep+emePh7CClj3FXP0ZIVuXY76dn1lBGKoSYXx5TaOvAAo0g+EtnI9
	YqVNiLhQiaHrAliyGdRUncR5ebbPneN28359ME9CEIP/jWV4h2ek0RNo81itNluZdcmmeGO3tJ1kH
	TAIlUNckj8JzZX7ECPlM28DJxmAMfJ4KB8hZUIjIKpUgCHeaUCtv2xMKMNkIzXkiyTukdkXtaoY/j
	SxcLYKtHc1OMuxIP4zw1KDhx9dvnJN0PRE2Gu3iRyME1F3in5VY6wTzPh1DZdvnOK+B21e4YzUF+9
	GJSGStig==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BUv-0000000Aqe0-1QcO;
	Wed, 09 Sep 2026 06:09:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: lazy bounce buffering for checksummed reads v3
Date: Wed,  9 Sep 2026 09:08:49 +0300
Message-ID: <20260909060924.1102037-1-hch@lst.de>
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

this series improves performance and resource usage for reads from
devices that require stable pages due to checksumming on XFS.

Currently XFS unconditionally bounce buffers reads on such devices to
prevent user modifications to the buffer from corrupting the data,
leading to checksum failures.

This uses DRAM bandwidth and CPU cycles for copies that are not needed
most of the time, and due to the use of a bio_vec for the bounce
buffer to smaller than wanted and unaligned I/O sizes when using 4k
user pages (i.e. 1MB-4k I/O).

This series addresses this by reading without the bounce buffer first,
and then only allocating a buffer and reading into that again on an
initial checksum failure.  To accommodate for rare (or hypothetical?)
applications that have legitimate needs to frequently modify in-flight
buffers, a sysfs know is provided to revert to the old behavior.

NOTE/QUESTION TO SUBSYSTEM MAINTAINERS: The patches in this series are
split over 3 subsystems, and I'd love to hear from the maintainers
about their preferences for merging this.

The baseline of this series is mainline with the
"misc block PI / bounce buffering fixes" series.


A git tree is available to help with the review here:

    git://git.infradead.org/users/hch/misc.git lazy-bounce

Gitweb:

    https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/lazy-bounce

Changes since v2:
 - break out of bio_iov_iter_get_pages when bi_size reaches maxlen
 - various fixes for pre-existing issues pointed out by Sashiko
 - generate zone PI a bit earlier
 - initialize the csum dir in sysfs unconditionally to protect against the
   rather theoretical case of the flag changing underneath us
 - redo sysfs initialization order to avoid a cleanup bug
 - use NOFS allocations in xfs_read_bounce_and_resubmit
 - rework bio setup for reissue to not leave land mines for other uses
 - fix commit message typos
 - fix comment typos

Changes since v1:
 - rebase on 7.3rc-1 and xfs for-next, which has the bio complete in
   task support merged
 - remove the now unused IOMAP_DIO_BOUNCE support for reads
 - fix compilation with integrity disabled
 - make I/O size limitation actually work
 - clear REQ_POLLED when bounce buffering
 - use sysfs string match helpers to allow non -n echo
