Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50922 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755847AbeEaSID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:08:03 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: buffered writes without buffer heads in xfs and iomap v5
Date: Thu, 31 May 2018 20:07:38 +0200
Message-Id: <20180531180759.21631-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Hi all,

this series adds support for buffered writes without buffer heads to
the iomap and XFS code.

For now this series only contains support for block size == PAGE_SIZE,
with the 4k support split into a separate series.


A git tree is available at:

    git://git.infradead.org/users/hch/xfs.git xfs-iomap-write.5

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-iomap-write.5

Changes since v4:
 - make the logic more clear in xfs_bmap_punch_delalloc_range
 - fix a missing unlock in xfs_bmap_punch_delalloc_range
 - always look up COW extents to check for overlaps
 - lots of patch reshuffling and splitting without impact to the final result

Changes since v3:
 - iterate backwards in xfs_bmap_punch_delalloc_range
 - remove the cow_valid variable in xfs_reflink_trim_irec_to_next_cow
 - additional trivial xfs_map_blocks simplifications
 - split the read side into a separate prep series
 - moved the SEEK_HOLE/DATA patches not strictly required out of the series

Changes since v2:
 - minor page_seek_hole_data tweaks
 - don't read data entirely covered by the write operation in write_begin
 - fix zeroing on write_begin I/O failure
 - remove iomap_block_needs_zeroing to make the code more clear
 - update comments on __do_page_cache_readahead

Changes since v1:
 - fix the iomap_readpages error handling
 - use unsigned file offsets in a few places to avoid arithmetic overflows
 - allocate a iomap_page in iomap_page_mkwrite to fix generic/095
 - improve a few comments
 - add more asserts
 - warn about truncated block numbers from ->bmap
 - new patch to change the __do_page_cache_readahead return value to
   unsigned int
 - remove an incorrectly added empty line
 - make inline data an explicit iomap type instead of a flag
 - add a IOMAP_F_BUFFER_HEAD flag to force use of buffers heads for gfs2,
   and keep the basic buffer head infrastructure around for now.
