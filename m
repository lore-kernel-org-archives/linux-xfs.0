Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 002797F5D
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 19:46:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBFDE304051
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 17:46:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wGusZ37YrML5n7j0 for <xfs@oss.sgi.com>;
	Mon, 09 Sep 2013 17:46:13 -0700 (PDT)
Date: Tue, 10 Sep 2013 10:45:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: test for bad level in dir2 node
Message-ID: <20130910004539.GY12779@dastard>
References: <52274F96.2010702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52274F96.2010702@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Sep 04, 2013 at 10:19:50AM -0500, Eric Sandeen wrote:
> In traverse_int_dir2block(), the variable 'i' is the level in
> the tree, with 0 being a leaf node.  In the "do" loop we
> start at the root, and work our way down to a leaf.
> 
> If the first node we read is an interior node with NODE_MAGIC,
> but it tells us that its level is 0 (a leaf), this is clearly
> an inconsistency.
> 
> Worse, we'd return with success, bno set, and only level[0]
> in the cursor initialized.  Then down this path we'll
> segfault when accessing an uninitialized (and zeroed) member
> of the cursor's level array:
> 
> process_node_dir2
>   traverse_int_dir2block  // returns 0 w/ bno set, only level[0] init'd
>   process_leaf_level_dir2
>     verify_dir2_path(mp, da_cursor, 0) // p_level == 0
>        this_level = p_level + 1;
>        node = cursor->level[this_level].bp->b_addr; // level[1] uninit & 0'd
> 
> Fix this by recognizing that an interior node w/ level 0 is invalid, and
> error out as for other inconsistencies.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> My only testcase for this is Jan Yves Brueckner's badly corrupted
> filesystem image.  With this change, we get i.e. :
> 
> +bad level in interior inode for directory inode 39869938
> +corrupt block 6 in directory inode 39869957
> +       will junk block
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 05bd4b7..20c6e1a 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -220,6 +220,16 @@ _("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"),
>  		 */
>  		if (i == -1) {
>  			i = da_cursor->active = nodehdr.level;
> +			if (i == 0 &&
> +			    (nodehdr.magic == XFS_DA_NODE_MAGIC ||
> +			     nodehdr.magic == XFS_DA3_NODE_MAGIC)) {
> +				do_warn(
> +_("bad level 0 in interior inode for directory inode %" PRIu64 "\n"),
> +					da_cursor->ino);
> +				libxfs_putbuf(bp);
> +				i = -1;
> +				goto error_out;
> +			}
>  			if (i >= XFS_DA_NODE_MAXDEPTH) {
>  				do_warn(
>  _("bad header depth for directory inode %" PRIu64 "\n"),

Looks sane, though wouldn't it be better to check for the correct
header magic number (i.e LEAF1/LEAFN) here? i.e. if we are at level
zero and we don't have a leaf, then there's something wrong. This
will only catch the case of a node replacing a leaf, not a free
space block or data block being at the wrong place...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
