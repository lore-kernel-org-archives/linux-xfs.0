Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782776;
	b=P5WfjwtM3czsT4j44BuSdmKtSvVnOek51gsjyJYhGoXd53sg2iD0/wJYCaEOw1MwgNeE
	 rClJTE6FHpYGFJW4E8ENeHzR8wVMLqdxNTqQnbOdcIAr235TUuRqt96YXOFnOqf+DHvAq
	 gH6GbHCb+dqhzqIZdzPGOVdULJ21afbeh5T18MMVwGNtOhVi6D5cP3ouEMzrWVLVss7FT
	 9NW3YjXZK4pfI+2BurozLdWv2zYy2SmwgOBLXq5a9XTMZQDOiME3PHplZAhhgpadEYADL
	 F6NNGry+MeZxfCeHpJyLwm5e2gFH8iXnHfujUoWmckSWzVCDkVmJrGuirYo474YXUmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782776;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-SRS-Rewrite;
	bh=oNT4WQ3xYufAl6feKlu7qeRD7fvUyDUZa5chGsvoHdA=;
	b=fIlqoxpdVPdOdtcaq+zD6dBEaW4N2avBd5n4poXQ5y5VLD82FTdCloi0uvzggmROQjo1
	 uyLchrxyVmFmWCiR4dqCt0U0y8H/9dLiYojZ8+bda+bS3Xh5xKFSSqjnylegZMqJdp0+y
	 jPsbHDQm2rS2K4YjvNwiGOzjpPScAkuXRugJXcGwWYVl+41ocCADjAXx54TEHgpgOStyT
	 6XVBBPtoF4pNyhNoiH4CjrGaVwEwPVvCyy0KELeJlitKejUQWKHqxdEr9+TqeGr0Vv9qI
	 anWH5X1kzAMSYvMgOh0TLKrwq2dI0T4a+55DMtfcVccyWjsmzD2rYBHPuieSAhOA0Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=diH5XEBw;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0D5606A31B;
	Wed,  4 Nov 2026 08:59:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F0D5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=diH5XEBw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=oNT4WQ3xYufAl6feKlu7qeRD7fvUyDUZa5chGsvoHdA=; b=diH5XEBw71+zhQTtYYJygP5HH7
	H6ft6/rFjxwAi36jjVgLDCCVdLmVRbHAUqr6CYlfkFSYB+7sQtIbQLeVWl+S4qcUakGS7JXYdU+ne
	4KpeJsj6J8zndNxiJyBoNwsG3GvQlTS2i+1ttMQ80MR5bG2kUNSMigbhJ7UcuA63mpy20FPLccx/m
	0nvudH3fVzA3E4Vvh9WojBVgH/JR7cM8nsgx4LkMlEkvZtBC4I+1g2hRclFAB94jawpMDC+mIl8gD
	s+KM5xt28E17Z/43eA6FSPRbOXo53OEKizNHzbmLTpydV2W9TykYRKjPaa/NtI4p7blr5yQYG98ZE
	ZCZc6zUg==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqD-00000004oIf-1BjB;
	Wed, 04 Nov 2026 08:59:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: support for RT data checksums v2
Date: Wed,  4 Nov 2026 09:57:04 +0100
Message-ID: <20261104085929.317544-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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

This series is repost with all the code review comments from last round
hopefully addressed to resync with -rc1, but without full benchmarking of
the new one-shot log item based approach, and without a design document.
If you need that to digest the code, this version is not for you.

    git://git.infradead.org/users/hch/xfs.git xfs-crc

Gitweb:

    https://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-crc

Note that the series will need a rebase on top of the fsverity work,
but the code points have been chosen to hopefully not conflict.

The userspace repositories are here:

    git://git.infradead.org/users/hch/xfsprorgs.git xfs-crc
    git://git.infradead.org/users/hch/xfstests-dev.git xfs-crc


Changes since v1:
 - improve various comments and commit logs in terms of spelling and
   structure
 - minor indentation fixes
 - add a big comment explaining the io_parent/io_csum_alloc/io_csum_alloc
   union and the relation to the io_csum field in struct iomap_ioend.
 - add a log reservation assert in xfs_rtfile_initialize_block
 - use xfs_rgblock_t instead of xfs_rtblock_t in two places that clearly
   deal with rgblock numbers
 - clear oz_csum_bufs on zone open failure for extra belts and suspenders
 - add a comment on the bi_idx assert in xfs_rtcsum_prepare_read
 - add an assert and improve the comment for the no-bp case in
   xfs_rtcsum_verify_ioend
 - add a comment (provided by Darrick) explaining the checksum log vs
   extent remap ordering
 - remove the unused csum_buf field from struct xfs_gc_bio
 - add a comment explaining the xfs_submit_verify_bio_csum return value
 - make the end calculation in xfs_submit_verify_bio_csum more
   rounding-safe with a code snipplet from Darrick, and give up if
   the range is empty afterwards
 - use plural "data checksums" in the experimental warning
 - s/xfs_rgb_to_/rgbno_to_/
 - improve superblock field validation
 - add health reporting (XFS_RTGROUP_GEOM_SICK_CSUM)
 - reduce the log reservation that added a bit too much slack in some
   cases
 - use xfs_buf_set_uptodate
 - fix error handling in xfs_rtcsum_open_zone
 - don't enable xfs_iomap_read_ops for all device that require stable
   pages
 - remove an extra xfs_rtcsum.h include in xfs_zone_alloc.c
 - fix a lost error in xfs_zone_gc_finish_chunk
 - set bi_end_io earlier to fix completions when xfs_rtcsum_prepare_read
   fails
 - add a xfs_min_diosize helper to share code between the aops and
   statx reporting
 - add a XFS_FEAT_* value for rtcsum
 - switch to an INCOMPAT flag as old kernels don't like the padding reuse
   in xfs_dsb
 - fix a buffer double buffer put in the read async error path
 - fix arithmerics on the media verify ioctl
 - refactor get_cache_zone to avoid a sleep under RCU condition
 - hold the IOLOCK over zone reset to synchronize with media verification,
   and check the write pointer and not just for an empty zone
 
Diffstat:
 block/bio-integrity-fs.c        |    1 
 fs/iomap/bio.c                  |    2 
 fs/iomap/direct-io.c            |    2 
 fs/iomap/internal.h             |   27 ++-
 fs/iomap/ioend.c                |   78 +++++++++
 fs/xfs/Kconfig                  |    1 
 fs/xfs/Makefile                 |    3 
 fs/xfs/libxfs/xfs_cksum.h       |    7 
 fs/xfs/libxfs/xfs_format.h      |   46 +++++
 fs/xfs/libxfs/xfs_fs.h          |    7 
 fs/xfs/libxfs/xfs_health.h      |    4 
 fs/xfs/libxfs/xfs_log_format.h  |   13 +
 fs/xfs/libxfs/xfs_log_recover.h |    1 
 fs/xfs/libxfs/xfs_ondisk.h      |    5 
 fs/xfs/libxfs/xfs_rtbitmap.c    |   57 ++++---
 fs/xfs/libxfs/xfs_rtbitmap.h    |    3 
 fs/xfs/libxfs/xfs_rtcsumfile.c  |   95 ++++++++++++
 fs/xfs/libxfs/xfs_rtcsumfile.h  |  150 +++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.c     |   16 ++
 fs/xfs/libxfs/xfs_rtgroup.h     |   26 +++
 fs/xfs/libxfs/xfs_sb.c          |   91 +++++++++++
 fs/xfs/libxfs/xfs_sb.h          |    1 
 fs/xfs/libxfs/xfs_shared.h      |    1 
 fs/xfs/libxfs/xfs_trans_resv.c  |   26 +++
 fs/xfs/libxfs/xfs_trans_resv.h  |    4 
 fs/xfs/scrub/agheader.c         |    5 
 fs/xfs/xfs_aops.c               |    3 
 fs/xfs/xfs_buf.c                |   96 ++++++++++++
 fs/xfs/xfs_buf.h                |    4 
 fs/xfs/xfs_buf_item_recover.c   |   10 +
 fs/xfs/xfs_file.c               |   21 ++
 fs/xfs/xfs_health.c             |    1 
 fs/xfs/xfs_inode.h              |   22 ++
 fs/xfs/xfs_ioctl.c              |    2 
 fs/xfs/xfs_ioend.c              |  175 ++++++++++++++++++++--
 fs/xfs/xfs_ioend.h              |    2 
 fs/xfs/xfs_iomap.c              |   72 ++++++++-
 fs/xfs/xfs_iomap.h              |    4 
 fs/xfs/xfs_iops.c               |    8 -
 fs/xfs/xfs_log.h                |    3 
 fs/xfs/xfs_log_recover.c        |    3 
 fs/xfs/xfs_message.c            |    4 
 fs/xfs/xfs_message.h            |    1 
 fs/xfs/xfs_mount.h              |    6 
 fs/xfs/xfs_platform.h           |    1 
 fs/xfs/xfs_reflink.c            |    2 
 fs/xfs/xfs_rtalloc.c            |   11 +
 fs/xfs/xfs_rtcsum.c             |  315 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtcsum.h             |   30 +++
 fs/xfs/xfs_rtcsum_item.c        |  218 +++++++++++++++++++++++++++
 fs/xfs/xfs_super.c              |   21 ++
 fs/xfs/xfs_sysfs.c              |    2 
 fs/xfs/xfs_trace.h              |    3 
 fs/xfs/xfs_verify_media.c       |  194 +++++++++++++++++++-----
 fs/xfs/xfs_zone_alloc.c         |   43 ++++-
 fs/xfs/xfs_zone_gc.c            |   73 +++++++--
 fs/xfs/xfs_zone_priv.h          |    8 +
 include/linux/iomap.h           |   42 +++++
 58 files changed, 1932 insertions(+), 140 deletions(-)
