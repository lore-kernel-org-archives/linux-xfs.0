Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752318AbeGBO6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:15 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: stop using buffer heads in xfs v7
Date: Mon,  2 Jul 2018 08:57:51 -0600
Message-Id: <20180702145813.22496-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Hi all,

this series adds support for buffered writes without buffer heads to
the iomap and XFS code.

A git tree is available at:

    git://git.infradead.org/users/hch/xfs.git xfs-iomap-write.7

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-iomap-write.7

Changes since v6:
 - fixe EOF zeroing for small blocksizes
 - various comment updates
 - new patch to update copyrights

Changes since v5:
 - merged the leftovers of the previous series into one
 - rebased on top of the gfs2 iomap prep series
 - fixed the map_blocks map conditions
 - clean up a loop in __iomap_write_begin

Changes since v4:
 - make the logic more clear in xfs_bmap_punch_delalloc_range
 - fix a missing unlock in xfs_bmap_punch_delalloc_range
 - always look up COW extents to check for overlaps
 - lots of patch reshuffling and splitting without impact to the final
   result

Changes since v3:
 - iterate backwards in xfs_bmap_punch_delalloc_range
 - remove the cow_valid variable in xfs_reflink_trim_irec_to_next_cow
 - additional trivial xfs_map_blocks simplifications
 - split the read side into a separate prep series
 - moved the SEEK_HOLE/DATA patches not strictly required out of the
   series

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
--
To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

