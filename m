Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52420 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932337AbcIUWTn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2016 18:19:43 -0400
Date: Thu, 22 Sep 2016 08:19:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: fix segfault from uninitialized tp in
 mv_orphanage
Message-ID: <20160921221938.GD10454@dastard>
References: <bb6c5861-23eb-dbd9-bf47-393c9445c9a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb6c5861-23eb-dbd9-bf47-393c9445c9a2@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>, Consigliere <admin@russenmafia.at>

On Wed, Sep 21, 2016 at 12:52:56PM -0500, Eric Sandeen wrote:
> After 9074815 xfs: better xfs_trans_alloc interface, mv_orphanage
> was passing an uninitialized *tp into libxfs_dir_lookup, because
> the trans_alloc() call which was present prior to the call got
> removed in that commit.
> 
> This ultimately led to testing an uninit tp var:
> 
> Conditional jump or move depends on uninitialised value(s)
>    at 0x434D01: libxfs_trans_read_buf_map (trans.c:554)
>    by 0x45152E: libxfs_da_read_buf (xfs_da_btree.c:2610)
>    by 0x456ACB: xfs_dir3_block_read (xfs_dir2_block.c:136)
>    by 0x4570A8: xfs_dir2_block_lookup_int (xfs_dir2_block.c:675)
>    by 0x457DB7: xfs_dir2_block_lookup (xfs_dir2_block.c:623)
>    by 0x455F54: libxfs_dir_lookup (xfs_dir2.c:399)
>    by 0x421C46: mv_orphanage (phase6.c:1095)
>    by 0x4222C2: check_for_orphaned_inodes (phase6.c:3108)
>    by 0x423ABD: phase6 (phase6.c:3287)
>    by 0x42E4B2: main (xfs_repair.c:933)
> 
> and ended with a segfault as we tried to use that tp when
> searching for the buffer in xfs_trans_buf_item_match():
> 
>         list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> 
> I think simply passing in NULL for this tp is sufficient to fix
> this; we'll just go read the buffer from disk in
> libxfs_trans_read_buf_map rather than trying to find it in an
> existing transaction.
> 
> Reported-by: Consigliere <admin@russenmafia.at>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 973a5f8..5507af4 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1092,7 +1092,7 @@ mv_orphanage(
>  					irec->ino_startnum;
>  		nres = XFS_DIRENTER_SPACE_RES(mp, fnamelen) +
>  		       XFS_DIRENTER_SPACE_RES(mp, 2);
> -		err = -libxfs_dir_lookup(tp, ino_p, &xfs_name_dotdot,
> +		err = -libxfs_dir_lookup(NULL, ino_p, &xfs_name_dotdot,
>  					&entry_ino_num, NULL);
>  		if (err) {
>  			ASSERT(err == ENOENT);

Yup, looks fine. tp is definitely not valid in that scope, and we
join the inode that we look up to the transaction when appropriate.

I'll push this in soon.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
