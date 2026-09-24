Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BB6453A5D;
	Thu, 24 Sep 2026 10:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244054; cv=none; b=ZJAt16PyZe4y1IvRI1QSVvTrEOftH2FyawrO9NMDYoh/4EaNwJDLnUlDtFYaNU38FeFa7pwGGK9x2RYtdZMvgA/TDtY3lr4A9OO9eIrpsLyXvQ+RUjT7jFiG2UAexnxNexvlacoB4MviDhbXV2t1+pilRoGSng9YFUKrSSwOfyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244054; c=relaxed/simple;
	bh=5/Vs7PGu2rYTlv6cjvZoJqQ1BsvN9Bk296JXyh6KQeg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GYgwR9ePzshatDq1pUMwitTLU+lr5i1PztjSzLD6a36NBM0Zv8MKVJHvwiQ3Hq3XrLLmm/gEp5yNZj/pUNunCgTIFi3DCYTsCQte2uRwzZc29IADbh73AiCpEw25ud/S/P8+strw+BxQtKvWjyh3T6FX/RfSpcOBDsgD86bphyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0aXmPAgA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0aXmPAgA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=a8Rw3qczchZq7LmU4fpaxBDamujZQ/FTVBD332SDdGQ=; b=0aXmPAgAEXclM6uQDx60Q65hdd
	0frGZbWGnV88pzqQSoeKdXFO8+EVbMYaC/8kJgX76IHxs8vkHrswURUTn8uMGj3R7xaS4SQ40WPls
	g3qNs7onu7l/SalvdO18Ig8rAxBHH2ojkSrw7zXSTtZeU8kl0rticFqu/0nzb6Y8NGaq8irHDwbQO
	JDjV9uKdZ6rB1gOR8pRsbciph8NszlV27MS89a+NI8Q4UPSv4SSXBO163XRqIrK8fSxTQtltb2F8S
	/dRXxbecfdl4tuVgjkVB+ZiSZW0CAXescCSOlTQuEX9Kth4AzCcuPfVs833h01cGzWQPk4qTP3YoO
	b2CoqfFw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gFo-0000000AeS7-3Zzp;
	Thu, 24 Sep 2026 10:00:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: support for RT data checksums
Date: Thu, 24 Sep 2026 11:59:32 +0200
Message-ID: <20260924100032.2733101-1-hch@lst.de>
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

data checksums provide an additional safeguard against silent data loss.

In classic XFS they were hard to support because they need to be
atomically updated with the written data.  The zoned allocator solves
that problem because it always writes out of place, and the checksums
can be committed at the same as the metadata linking the newly written
file data into place.  In theory, a conventional allocator could be used
in combination with the always_cow option, but there are few upsides of
this compared to using the zoned allocator.

Data checksums are stored in per-realtime group files in the metadir,
similar to other modern RT metadata.  Unlike the checksum design in btrfs
or some other file system, the checksums are associated with the
physical blocks, and not with logical data in files.  This reduces the
mapping overhead, and significantly reduces the write amplification,
and also avoids duplicate checksums for reflinked files (although those
are not yet supported with the zoned allocator anyway).

The initial version provides two checksums algorithms: crc32c and crc64.
Both of those are cyclic redundancy check algorithms which provide known
good detection of bit flips that is better than general purpose hash
functions.  Both are not cryptographic hashes and thus do not provide any
kind of protection against intentional tampering with the data.
The crc32c parameters exactly match those use for xfs metadata checksums,
and also those used by the default btrfs checksum, and the NVMe PI
formats using crc32c.  The crc64 parameters exactly match those using
the NVMe PI formats using crc64.  crc32c provides reasonable assurance
for today's hardware, but might prove limiting for extremely large data
sets, crc64 fills that void, but probably warrants using > 4k file system
block sizes to amortize the overhead.

In this series the checksums are only used to check data integrity
and report issues with it.  That on it's own is a bit of a lame story,
but it is important as a building block for two additional features
under development:

 - exposing the checksum to userspace through io_uring with
   IORING_RW_ATTR_FLAG_PI.  A prototype of this exists, but it needs
   a bit more rework of common code than I'd like for the initial
   review.  As a side effect this support will also support salvaging
   data with bad checksums for analysis in userspace.
 - retrying reads through a different replica from RAID devices that
   provide it.  This has been proposed before and requires some
   hairy block layer infrastructure.  I have a prototype for MD-based
   mirrors that can be extended to other use cases.  The same mechanism
   can also be used to retry reads for the already checksum protected
   XFS metadata.

The performance drop when using data checksums is between not measurable
to about 2% for most workloads on HDD and SSD.  On fast enough SSDs
single threaded large reads can see up to 10% slow down as the
checksum validation runs on a strict per-cpu workqueue through the block
layer in-task bio completion.  If needed, different completion methods
that distribute the I/O completions could be added.

This series is based on the lazy bounce series queued up in a special
block branch, the prep series just send out and fixes queue up in
different maintainer tree, so it is best to use the git branch:

    git://git.infradead.org/users/hch/xfs.git xfs-crc

Gitweb:

    https://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-crc

Note that the series will need a rebase on top of the fsverity work,
but the code points have been chosen to hopefully not conflict.

Diffstat:
 block/bio-integrity-fs.c       |    1 
 fs/iomap/bio.c                 |    3 
 fs/iomap/direct-io.c           |    2 
 fs/iomap/internal.h            |   21 ++
 fs/iomap/ioend.c               |   77 +++++++++
 fs/xfs/Kconfig                 |    1 
 fs/xfs/Makefile                |    2 
 fs/xfs/libxfs/xfs_cksum.h      |    7 
 fs/xfs/libxfs/xfs_format.h     |   46 +++++
 fs/xfs/libxfs/xfs_fs.h         |    6 
 fs/xfs/libxfs/xfs_health.h     |    4 
 fs/xfs/libxfs/xfs_log_format.h |    1 
 fs/xfs/libxfs/xfs_ondisk.h     |    4 
 fs/xfs/libxfs/xfs_rtbitmap.c   |   54 ++++--
 fs/xfs/libxfs/xfs_rtbitmap.h   |    3 
 fs/xfs/libxfs/xfs_rtcsumfile.c |   94 ++++++++++++
 fs/xfs/libxfs/xfs_rtcsumfile.h |  150 +++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.c    |   10 +
 fs/xfs/libxfs/xfs_rtgroup.h    |   26 +++
 fs/xfs/libxfs/xfs_sb.c         |   80 ++++++++++
 fs/xfs/libxfs/xfs_sb.h         |    1 
 fs/xfs/libxfs/xfs_shared.h     |    1 
 fs/xfs/libxfs/xfs_trans_resv.c |   23 ++
 fs/xfs/libxfs/xfs_trans_resv.h |    5 
 fs/xfs/scrub/agheader.c        |    5 
 fs/xfs/xfs_aops.c              |    4 
 fs/xfs/xfs_buf.c               |  130 +++++++++++++---
 fs/xfs/xfs_buf.h               |    4 
 fs/xfs/xfs_buf_item.c          |   10 +
 fs/xfs/xfs_buf_item.h          |    4 
 fs/xfs/xfs_buf_item_recover.c  |    7 
 fs/xfs/xfs_file.c              |   21 ++
 fs/xfs/xfs_inode.h             |    8 -
 fs/xfs/xfs_ioend.c             |  159 ++++++++++++++++++--
 fs/xfs/xfs_ioend.h             |    2 
 fs/xfs/xfs_iomap.c             |   72 ++++++++-
 fs/xfs/xfs_iomap.h             |    4 
 fs/xfs/xfs_iops.c              |   10 +
 fs/xfs/xfs_message.c           |    4 
 fs/xfs/xfs_message.h           |    1 
 fs/xfs/xfs_mount.h             |    9 +
 fs/xfs/xfs_platform.h          |    1 
 fs/xfs/xfs_reflink.c           |    2 
 fs/xfs/xfs_rtalloc.c           |   11 +
 fs/xfs/xfs_rtcsum.c            |  317 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtcsum.h            |   23 ++
 fs/xfs/xfs_super.c             |   14 +
 fs/xfs/xfs_sysfs.c             |    2 
 fs/xfs/xfs_trace.h             |    3 
 fs/xfs/xfs_verify_media.c      |  169 ++++++++++++++++++---
 fs/xfs/xfs_zone_alloc.c        |   40 ++++-
 fs/xfs/xfs_zone_gc.c           |   65 ++++++--
 fs/xfs/xfs_zone_priv.h         |    8 +
 include/linux/iomap.h          |   31 +++-
 54 files changed, 1619 insertions(+), 143 deletions(-)
