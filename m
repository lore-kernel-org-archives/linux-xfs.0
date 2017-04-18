Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756371AbdDRRA4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Apr 2017 13:00:56 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 93DEC64A79
        for <linux-xfs@vger.kernel.org>; Tue, 18 Apr 2017 17:00:55 +0000 (UTC)
Date: Tue, 18 Apr 2017 13:00:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: handle array index overrun in
 xfs_dir2_leaf_readbuf()
Message-ID: <20170418170051.GE46764@bfoster.bfoster>
References: <9d5a5529-894d-bacd-501e-e0d9ece473b8@redhat.com>
 <20170417205712.GA43090@bfoster.bfoster>
 <026eb10c-2745-ad2b-a3f3-f0058f2b9024@redhat.com>
 <20170418165543.GD46764@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170418165543.GD46764@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolin@redhat.com>

On Tue, Apr 18, 2017 at 12:55:44PM -0400, Brian Foster wrote:
> On Mon, Apr 17, 2017 at 05:12:36PM -0500, Eric Sandeen wrote:
> > On 4/17/17 3:57 PM, Brian Foster wrote:
> > > On Thu, Apr 13, 2017 at 01:45:43PM -0500, Eric Sandeen wrote:
> ...
> > > 
> > > This fix seems fine to me, but I'm wondering if this code may have
> > > issues with other kinds of misalignment between the directory blocks and
> > > underlying bmap extents as well. For example, what happens if we end up
> > > with something like the following on an 8k dir fsb fs?
> > > 
> > >  0:[0,xxx,3,0]
> > >  1:[3,xxx,1,0]
> > > 
> > > ... or ...
> > > 
> > >  0:[0,xxx,3,0]
> > >  1:[3,xxx,3,0]
> > 
> > Well, as far as that goes it won't be an issue; for 8k dir block sizes
> > we will allocate an extent map with room for 10 extents, and we'll go
> > well beyond the above extents which cross directory block boundaries.
> > 
> > >  ...
> > >  N:[...]
> > > 
> > > Am I following correctly that we may end up assuming the wrong mapping
> > > for the second dir fsb and/or possibly skipping blocks?
> > 
> > As far as I can tell, this code is only managing the read-ahead state
> > by looking at these cached extents. We keep track of our position within
> > that allocated array of mappings - this bug just stepped off the end
> > while doing so.
> > 
> > Stopping at the correct point should keep all of the state consistent
> > and correct.
> > 
> > But yeah, it's kind of hairy & hard to read, IMHO.
> > 
> > Also as far as I can tell, we handle such discontiguities correctly,
> > other than the bug I found.  If you see something that looks suspicious,
> > I'm sure I could tweak my test case to craft a specific situation if
> > there's something you'd like to see tested...
> > 
> 
> Background: Eric and I chatted a bit on irc to rectify that what I'm
> calling out above is a different issue from what is fixed by this patch.
> 
> Eric,
> 
> I managed to construct a directory that looks like this:
> 
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>    0: [0..7]:          88..95            0 (88..95)             8
>    1: [8..15]:         80..87            0 (80..87)             8
>    2: [16..39]:        168..191          0 (168..191)          24
>    3: [40..63]:        5242952..5242975  1 (72..95)            24
> 
> The fs has 8k directory fsbs. Dir fsb offset 0 spans extents 0 and 1,
> offset 1 (which corresponds to the 512b range 16-31 above) is covered
> completely by extent 2 and dir offset 2 (range 32-47) spans extents 2
> and 3. An ls of this directory produces this:
> 
>  XFS (dm-3): Metadata corruption detected at xfs_dir3_data_reada_verify+0x42/0x80 [xfs], xfs_dir3_data_reada block 0x500058
>  XFS (dm-3): Unmount and run xfs_repair
>  XFS (dm-3): First 64 bytes of corrupted metadata buffer:
>  ffffbcb901c44000: 00 00 00 00 00 00 00 64 0f 78 78 78 78 78 78 78  .......d.xxxxxxx
>  ffffbcb901c44010: 78 78 78 78 2e 38 38 36 01 00 00 00 00 00 10 00  xxxx.886........
>  ffffbcb901c44020: 00 00 00 00 00 00 00 64 0f 78 78 78 78 78 78 78  .......d.xxxxxxx
>  ffffbcb901c44030: 78 78 78 78 2e 38 38 37 01 00 00 00 00 00 10 20  xxxx.887....... 
> 

Oops, snipped the wrong part. This is the full output:

 XFS (dm-3): Metadata CRC error detected at xfs_dir3_data_read_verify+0x5e/0x100 [xfs], xfs_dir3_data block 0xb8
 XFS (dm-3): Unmount and run xfs_repair
 XFS (dm-3): First 64 bytes of corrupted metadata buffer:
 ffffbcb901c44000: 58 44 44 33 bb bf aa 94 00 00 00 00 00 00 00 b8  XDD3............
 ffffbcb901c44010: 00 00 00 01 00 00 04 95 00 5b 7c 62 71 fb 47 92  .........[|bq.G.
 ffffbcb901c44020: b4 49 02 c4 e8 1a 75 2f 00 00 00 00 00 00 00 63  .I....u/.......c
 ffffbcb901c44030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 XFS (dm-3): Metadata corruption detected at xfs_dir3_data_reada_verify+0x42/0x80 [xfs], xfs_dir3_data_reada block 0x500058
 XFS (dm-3): Metadata CRC error detected at xfs_dir3_data_read_verify+0x5e/0x100 [xfs], xfs_dir3_data block 0xb8
 XFS (dm-3): Unmount and run xfs_repair
 XFS (dm-3): First 64 bytes of corrupted metadata buffer:
 ffffbcb901c44000: 58 44 44 33 bb bf aa 94 00 00 00 00 00 00 00 b8  XDD3............
 ffffbcb901c44010: 00 00 00 01 00 00 04 95 00 5b 7c 62 71 fb 47 92  .........[|bq.G.
 ffffbcb901c44020: b4 49 02 c4 e8 1a 75 2f 00 00 00 00 00 00 00 63  .I....u/.......c
 ffffbcb901c44030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 XFS (dm-3): metadata I/O error: block 0xb8 ("xfs_trans_read_buf_map") error 74 numblks 16
 XFS (dm-3): Unmount and run xfs_repair
 XFS (dm-3): First 64 bytes of corrupted metadata buffer:
 ffffbcb901c46000: 00 00 00 00 00 00 00 64 0f 78 78 78 78 78 78 78  .......d.xxxxxxx
 ffffbcb901c46010: 78 78 78 78 2e 38 38 36 01 00 00 00 00 00 10 00  xxxx.886........
 ffffbcb901c46020: 00 00 00 00 00 00 00 64 0f 78 78 78 78 78 78 78  .......d.xxxxxxx
 ffffbcb901c46030: 78 78 78 78 2e 38 38 37 01 00 00 00 00 00 10 20  xxxx.887....... 

Brian

> ... which is yelling about block 184 (dir fsb 2). The fs is otherwise
> clean according to xfs_repair. 
> 
> I _think_ something like the appended diff deals with it, but this is
> lightly tested only and could definitely use more eyes.
> 
> Brian
> 
> --- 8< ---
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index ad9396e..9fa379d 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -404,7 +404,8 @@ xfs_dir2_leaf_readbuf(
>  		 * Read-ahead a contiguous directory block.
>  		 */
>  		if (i > mip->ra_current &&
> -		    map[mip->ra_index].br_blockcount >= geo->fsbcount) {
> +		    (map[mip->ra_index].br_blockcount - mip->ra_offset) >=
> +		     geo->fsbcount) {
>  			xfs_dir3_data_readahead(dp,
>  				map[mip->ra_index].br_startoff + mip->ra_offset,
>  				XFS_FSB_TO_DADDR(dp->i_mount,
> @@ -432,7 +433,7 @@ xfs_dir2_leaf_readbuf(
>  			 * The rest of this extent but not more than a dir
>  			 * block.
>  			 */
> -			length = min_t(int, geo->fsbcount,
> +			length = min_t(int, geo->fsbcount - j,
>  					map[mip->ra_index].br_blockcount -
>  							mip->ra_offset);
>  			mip->ra_offset += length;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
