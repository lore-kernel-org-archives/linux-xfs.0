Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391012AbfAPOKD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jan 2019 09:10:03 -0500
Date: Wed, 16 Jan 2019 09:10:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: eof trim writeback mapping as soon as it is
 cached
Message-ID: <20190116141000.GA29871@bfoster>
References: <20190111123032.31538-2-bfoster@redhat.com>
 <20190116133539.7BD5620675@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116133539.7BD5620675@mail.kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <sashal@kernel.org>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org

On Wed, Jan 16, 2019 at 01:35:38PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 40214d128e07 xfs: trim writepage mapping to within eof.
> 
> The bot has tested the following trees: v4.20.2, v4.19.15, v4.14.93, v4.9.150.
> 
> v4.20.2: Build OK!
> v4.19.15: Build OK!
> v4.14.93: Failed to apply! Possible dependencies:
>     2d5f4b5bebcc ("xfs: remove unused parameter from xfs_writepage_map")
>     5c665e5b5af6 ("xfs: remove xfs_map_cow")
>     70c57dcd606f ("xfs: skip CoW writes past EOF when writeback races with truncate")
>     a7b28f72ab90 ("xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks")
>     b4d8ad7fd3a1 ("xfs: fix s_maxbytes overflow problems")
> 
> v4.9.150: Failed to apply! Possible dependencies:
>     08438b1e386b ("xfs: plumb in needed functions for range querying of the freespace btrees")
>     092d5d9d5812 ("xfs: cleanup xfs_reflink_find_cow_mapping")
>     11ef38afe98c ("xfs: make xfs btree stats less huge")
>     2d5f4b5bebcc ("xfs: remove unused parameter from xfs_writepage_map")
>     5c665e5b5af6 ("xfs: remove xfs_map_cow")
>     70c57dcd606f ("xfs: skip CoW writes past EOF when writeback races with truncate")
>     755c7bf5ddca ("libxfs: convert ushort to unsigned short")
>     a7b28f72ab90 ("xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks")
>     af7d20fd83d9 ("xfs: make xfs_btree_magic more generic")
>     b4d8ad7fd3a1 ("xfs: fix s_maxbytes overflow problems")
>     c8ce540db5f6 ("xfs: remove double-underscore integer types")
>     cae028df5344 ("xfs: optimise CRC updates")
> 
> 
> How should we proceed with this patch?
> 

The writeback code in XFS has seen a decent amount of rework since these
older kernels. I'm not quite sure how stable deals with these conflicts,
but for reference, I think the appended (untested) diff is essentially
equivalent for the above two kernels. It doesn't cover the xfs_map_cow()
case in 4.14, but that code is experimental. Also note that the upstream
patch is still technically not reviewed.

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b0cccf8a81a8..b93b3064de20 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -421,8 +421,10 @@ xfs_map_blocks(
 	    (!nimaps || isnullstartblock(imap->br_startblock))) {
 		error = xfs_iomap_write_allocate(ip, XFS_DATA_FORK, offset,
 				imap);
-		if (!error)
+		if (!error) {
 			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
+			xfs_trim_extent_eof(imap, ip);
+		}
 		return error;
 	}
 
@@ -433,8 +435,10 @@ xfs_map_blocks(
 		ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 	}
 #endif
-	if (nimaps)
+	if (nimaps) {
 		trace_xfs_map_blocks_found(ip, offset, count, type, imap);
+		xfs_trim_extent_eof(imap, ip);
+	}
 	return 0;
 }
 
