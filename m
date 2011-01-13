Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0D0nwlU024431 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 18:49:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B57FE1D2B2E2
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 16:52:10 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	cw6KLCz1EQ1YCXPm for <xfs@oss.sgi.com>;
	Wed, 12 Jan 2011 16:52:10 -0800 (PST)
Date: Thu, 13 Jan 2011 11:52:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_bmap_add_extent_delay_real should set br_startoff
Message-ID: <20110113005207.GR28803@dastard>
References: <20110112194228.8449.41844.stgit@lady3jane.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110112194228.8449.41844.stgit@lady3jane.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Wed, Jan 12, 2011 at 01:42:28PM -0600, Ben Myers wrote:
> When filling in the middle of a previous delayed allocation, set
> br_startoff of the new delay extent to the right to NULLSTARTBLOCK
> so that it is ignored by xfs_bmap_extent_to_btree.  This prevents
> a forced shutdown when that in-core extent is converted from delay
> to real and is found to be already in the btree.  The value is
> overwritten below.

I'm not sure I understand what the problem is from your description.
What actually goes wrong in xfs_bmap_extent_to_btree()? I'm assuming
that it counts one too many real extents, and if so, shouldn't it
fire this assert long before you get to a shutdown situation?

	ASSERT(cnt == XFS_IFORK_NEXTENTS(ip, whichfork));

Also, do you have a test case that triggers this? If so, can it be
turned into a xfstests case? I like to have some idea of how the
problem was encountered and verified, because this code is complex
and easy to misunderstand...

> SGI-PV: 1013221

The following is mostly the notes I wrote to understand what your
patch does.  I'm posting them so others don't need to go through the
same analysis to understand the patch. While you might have the
analysis in the above PV we can't see it at all, so it would be
appreciated if you could put a summary of the bug analysis and
test case in the commit message so we don't have to spend a couple of
hours just to work out what the patch does...

> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  fs/xfs/xfs_bmap.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 4111cd3..cd75c77 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -1040,13 +1040,14 @@ xfs_bmap_add_extent_delay_real(
>  		 * This case is avoided almost all the time.
>  		 */
>  		temp = new->br_startoff - PREV.br_startoff;
> +		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
>  		trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
>  		xfs_bmbt_set_blockcount(ep, temp);
>  		r[0] = *new;
>  		r[1].br_state = PREV.br_state;
> -		r[1].br_startblock = 0;
> +		r[1].br_startblock = nullstartblock(
> +				(int)xfs_bmap_worst_indlen(ip, temp2));

As a side note, this would be easier to understand if you converted
all the r[x] notations to LEFT, RIGHT and PREV to match the rest of
the code (i.e. LEFT == r[0], RIGHT = r[1] and PREV = r[2]). if you
are touching this code, then this should probably be done now.

The code starts with:

     +ddddddddddddddddddddddddddddddddddddddddddddddddd+
	 r[2] @ idx
	 PREV @ idx

and we are allocating:
                         +rrrrrrrrrrrrrrr+
			        new
and does:

1042                 temp = new->br_startoff - PREV.br_startoff;
1043                 trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
1044                 xfs_bmbt_set_blockcount(ep, temp);
1045                 r[0] = *new;
1046                 r[1].br_state = PREV.br_state;
1047                 r[1].br_startblock = 0;
1048                 r[1].br_startoff = new_endoff;
1049                 temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
1050                 r[1].br_blockcount = temp2;
1051                 xfs_iext_insert(ip, idx + 1, 2, &r[0], state);

Which translates as:

	LEFT = *new;
	PREV.br_blockcount = LEFT.br_startoff = PREV.br_startoff
	RIGHT.br_state = PREV.br_state;
	RIGHT.br_startblock = 0;
	RIGHT.br_startoff = LEFT.br_startblock + LEFT.br_blockcount;
	RIGHT.br_blockcount = PREV.br_startoff + PREV.br_blockcount
				- RIGHT.br_startoff;

Which means it has been set up as:

     +ddddddddddddddddddd+rrrrrrrrrrrrrrr+ddddddddddddd+
			        new
	 r[2] @ idx        r[0]              r[1]
	 PREV @ idx	   LEFT              RIGHT
	                 inserted @ idx + 1

Ok, that all looks good so far except RIGHT is not yet set up as a
delalloc extent. If the inode is in btree format (i.e. a cursor
exists), it inserts the new extent into the btree, otherwise we
trigger:

1068                 if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
1069                     ip->i_d.di_nextents > ip->i_df.if_ext_max) {
1070                         error = xfs_bmap_extents_to_btree(ip->i_transp, ip,
1071                                         first, flist, &cur, 1, &tmp_rval,
1072                                         XFS_DATA_FORK);
1073                         rval |= tmp_rval;
1074                         if (error)
1075                                 goto done;
1076                 }

OK, so this is done while the incore extent tree is in inconsistent
state. Then we do some delalloc reservation futzing but does not
modify the reservations in the extents based on the numbe of blocks
allocated.

Oh, if the extent->btree conversion allocates more blocks than the
extent allocated reserrved, then it tries to do a new reservation
for the difference (some comments in this code would be nice) and
has some nasty failure code.

But, that doesn't stop us from updating the delalloc block
reservation counts in the extents before we convert the tree format
so long ias we calculate diff (excluding allocated btree blocks) before
we update PREV.br_startblock.

So that means if we move this hunk and the diff calculation up above
the extent->btree conversion check:

1109                 ep = xfs_iext_get_ext(ifp, idx);
1110                 xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
1111                 trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
1112                 trace_xfs_bmap_pre_update(ip, idx + 2, state, _THIS_IP_);
1113                 xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx + 2),
1114                         nullstartblock((int)temp2));
1115                 trace_xfs_bmap_post_update(ip, idx + 2, state, _THIS_IP_);

And add:

	diff -= cur ? cur->bc_private.b.allocated : 0;

after the conversion, everything should work just fine and the
tracing will continue to give the same output.

--

Ok, so the bug looks real, but I'm not sure that the fix really
improves anything. The code needs to use LEFT, RIGHT and PREV, coul
ddo with better variable names than temp and temp2, and probably
should reorder the operations and the associated tracing as well as
comment what the hell the code is actually doing. Typically with a
fix like this I'll end up adding 5-10x as many lines in comments as
code changes that fix the bug, just so I don't have to go through
this process next time I have to look at this code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
