Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030488AbdDSSBt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 14:01:49 -0400
Date: Wed, 19 Apr 2017 14:01:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: handle array index overrun in
 xfs_dir2_leaf_readbuf()
Message-ID: <20170419180145.GA41631@bfoster.bfoster>
References: <9d5a5529-894d-bacd-501e-e0d9ece473b8@redhat.com>
 <20170417205712.GA43090@bfoster.bfoster>
 <026eb10c-2745-ad2b-a3f3-f0058f2b9024@redhat.com>
 <20170418165543.GD46764@bfoster.bfoster>
 <20170419000906.GE5193@birch.djwong.org>
 <12d5c25d-7e59-0361-f5e6-ec8bfb8b1fff@redhat.com>
 <20170419002927.GG5193@birch.djwong.org>
 <20170419123254.GB40497@bfoster.bfoster>
 <e6315a52-e8ee-c238-bf8f-66e76af9a68b@redhat.com>
 <20170419160854.GH5193@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419160854.GH5193@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolin@redhat.com>

On Wed, Apr 19, 2017 at 09:08:54AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 19, 2017 at 09:40:20AM -0500, Eric Sandeen wrote:
> > On 4/19/17 7:32 AM, Brian Foster wrote:
> > > On Tue, Apr 18, 2017 at 05:29:27PM -0700, Darrick J. Wong wrote:
> > >> On Tue, Apr 18, 2017 at 07:14:03PM -0500, Eric Sandeen wrote:
> > >>> On 4/18/17 7:09 PM, Darrick J. Wong wrote:
> > >>>> On Tue, Apr 18, 2017 at 12:55:44PM -0400, Brian Foster wrote:
> > >>>>> On Mon, Apr 17, 2017 at 05:12:36PM -0500, Eric Sandeen wrote:
> > >>>>>> On 4/17/17 3:57 PM, Brian Foster wrote:
> > >>>>>>> On Thu, Apr 13, 2017 at 01:45:43PM -0500, Eric Sandeen wrote:
> > >>>>> ...
> > >>>>>>>
> > >>>>>>> This fix seems fine to me, but I'm wondering if this code may have
> > >>>>>>> issues with other kinds of misalignment between the directory blocks and
> > >>>>>>> underlying bmap extents as well. For example, what happens if we end up
> > >>>>>>> with something like the following on an 8k dir fsb fs?
> > >>>>>>>
> > >>>>>>>  0:[0,xxx,3,0]
> > >>>>>>>  1:[3,xxx,1,0]
> > >>>>>>>
> > >>>>>>> ... or ...
> > >>>>>>>
> > >>>>>>>  0:[0,xxx,3,0]
> > >>>>>>>  1:[3,xxx,3,0]
> > >>>>>>
> > >>>>>> Well, as far as that goes it won't be an issue; for 8k dir block sizes
> > >>>>>> we will allocate an extent map with room for 10 extents, and we'll go
> > >>>>>> well beyond the above extents which cross directory block boundaries.
> > >>>>>>
> > >>>>>>>  ...
> > >>>>>>>  N:[...]
> > >>>>>>>
> > >>>>>>> Am I following correctly that we may end up assuming the wrong mapping
> > >>>>>>> for the second dir fsb and/or possibly skipping blocks?
> > >>>>>>
> > >>>>>> As far as I can tell, this code is only managing the read-ahead state
> > >>>>>> by looking at these cached extents. We keep track of our position within
> > >>>>>> that allocated array of mappings - this bug just stepped off the end
> > >>>>>> while doing so.
> > >>>>>>
> > >>>>>> Stopping at the correct point should keep all of the state consistent
> > >>>>>> and correct.
> > >>>>>>
> > >>>>>> But yeah, it's kind of hairy & hard to read, IMHO.
> > >>>>>>
> > >>>>>> Also as far as I can tell, we handle such discontiguities correctly,
> > >>>>>> other than the bug I found.  If you see something that looks suspicious,
> > >>>>>> I'm sure I could tweak my test case to craft a specific situation if
> > >>>>>> there's something you'd like to see tested...
> > >>>>>>
> > >>>>>
> > >>>>> Background: Eric and I chatted a bit on irc to rectify that what I'm
> > >>>>> calling out above is a different issue from what is fixed by this patch.
> > >>>>>
> > >>>>> Eric,
> > >>>>>
> > >>>>> I managed to construct a directory that looks like this:
> > >>>>>
> > >>>>>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
> > >>>>>    0: [0..7]:          88..95            0 (88..95)             8
> > >>>>>    1: [8..15]:         80..87            0 (80..87)             8
> > >>>>>    2: [16..39]:        168..191          0 (168..191)          24
> > >>>>>    3: [40..63]:        5242952..5242975  1 (72..95)            24
> > >>>>>
> > >>>>> The fs has 8k directory fsbs. Dir fsb offset 0 spans extents 0 and 1,
> > >>>>> offset 1 (which corresponds to the 512b range 16-31 above) is covered
> > >>>>> completely by extent 2 and dir offset 2 (range 32-47) spans extents 2
> > >>>>> and 3. An ls of this directory produces this:
> > >>>>>
> > >>>>>  XFS (dm-3): Metadata corruption detected at xfs_dir3_data_reada_verify+0x42/0x80 [xfs], xfs_dir3_data_reada block 0x500058
> > >>>>>  XFS (dm-3): Unmount and run xfs_repair
> > >>>>>  XFS (dm-3): First 64 bytes of corrupted metadata buffer:
> > >>>>>  ffffbcb901c44000: 00 00 00 00 00 00 00 64 0f 78 78 78 78 78 78 78  .......d.xxxxxxx
> > >>>>>  ffffbcb901c44010: 78 78 78 78 2e 38 38 36 01 00 00 00 00 00 10 00  xxxx.886........
> > >>>>>  ffffbcb901c44020: 00 00 00 00 00 00 00 64 0f 78 78 78 78 78 78 78  .......d.xxxxxxx
> > >>>>>  ffffbcb901c44030: 78 78 78 78 2e 38 38 37 01 00 00 00 00 00 10 20  xxxx.887....... 
> > >>>>>
> > >>>>> ... which is yelling about block 184 (dir fsb 2). The fs is otherwise
> > >>>>> clean according to xfs_repair. 
> > >>>>>
> > >>>>> I _think_ something like the appended diff deals with it, but this is
> > >>>>> lightly tested only and could definitely use more eyes.
> > >>>>>
> > >>>>> Brian
> > >>>>>
> > >>>>> --- 8< ---
> > >>>>>
> > >>>>> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > >>>>> index ad9396e..9fa379d 100644
> > >>>>> --- a/fs/xfs/xfs_dir2_readdir.c
> > >>>>> +++ b/fs/xfs/xfs_dir2_readdir.c
> > >>>>> @@ -404,7 +404,8 @@ xfs_dir2_leaf_readbuf(
> > >>>>>  		 * Read-ahead a contiguous directory block.
> > >>>>>  		 */
> > >>>>>  		if (i > mip->ra_current &&
> > >>>>> -		    map[mip->ra_index].br_blockcount >= geo->fsbcount) {
> > >>>>> +		    (map[mip->ra_index].br_blockcount - mip->ra_offset) >=
> > >>>>> +		     geo->fsbcount) {
> > >>>>>  			xfs_dir3_data_readahead(dp,
> > >>>>>  				map[mip->ra_index].br_startoff + mip->ra_offset,
> > >>>>>  				XFS_FSB_TO_DADDR(dp->i_mount,
> > >>>>> @@ -432,7 +433,7 @@ xfs_dir2_leaf_readbuf(
> > >>>>>  			 * The rest of this extent but not more than a dir
> > >>>>>  			 * block.
> > >>>>>  			 */
> > >>>>> -			length = min_t(int, geo->fsbcount,
> > >>>>> +			length = min_t(int, geo->fsbcount - j,
> > >>>>
> > >>>> Looks ok to me to make Eric's bugfix complete.
> > >>>
> > >>> Brian, thanks for crafting the image to expose this.  :)
> > >>>
> > >>> I've been otherwise occupied today, sorry - technically this fixes a separate
> > >>> issue, yes? So 2 patches, 2 bugfixes AFAICT?
> > >>
> > >> Ok.  I don't mind taking two patches since you're right, the first patch
> > >> saves us from running off the end of the shadow bmap array, and the
> > >> second one fixes bookkeepping problems when a dir extent starts midway
> > >> through a large dirblock.
> > >>
> > > 
> > > Yeah, these are definitely separate issues and Eric's original patch
> > > here is probably higher priority on its own.
> > > 
> > > But I'm not clear on the plan here.. do we want this additional patch or
> > > are we planning just to rewrite the readahead bits (or do we want to do
> > > both)? I guess having a bugfix patch in the tree is useful from a stable
> > > perspective... hm?
> > > 
> > > Brian
> > 
> > Yeah.
> > 
> > There's 20 years of the old code in the field with these bugs - I think 2
> > straightforward fixes have value even if we might want to rewrite it in the
> > future.
> 
> Assuming 4.11 is released on Sunday, I was figuring 4.12 for the two
> fixes + backporting to older kernels, and explore the rewrite for 4.13.
> 

Ok, sounds good to me. I'll get this one posted once it survives a bit
more testing. Thanks.

Brian

> --D
> 
> > 
> > -Eric
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
