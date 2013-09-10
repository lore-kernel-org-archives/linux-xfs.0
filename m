Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B5B707F54
	for <linux-xfs@oss.sgi.com>; Tue, 10 Sep 2013 11:43:22 -0500 (CDT)
Message-ID: <522F4C26.2080106@sgi.com>
Date: Tue, 10 Sep 2013 11:43:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs_repair: test for bad level in dir2 node
References: <52274F96.2010702@sandeen.net> <522F4001.8010104@sandeen.net>
In-Reply-To: <522F4001.8010104@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 09/10/13 10:51, Eric Sandeen wrote:
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
>    traverse_int_dir2block  // returns 0 w/ bno set, only level[0] init'd
>    process_leaf_level_dir2
>      verify_dir2_path(mp, da_cursor, 0) // p_level == 0
>         this_level = p_level + 1;
>         node = cursor->level[this_level].bp->b_addr; // level[1] uninit&  0'd
>
> Fix this by recognizing that an interior node w/ level 0 is invalid, and
> error out as for other inconsistencies.
>
> By the time the level 0 test is done, we have already ensured that
> this block has XFS_DA[3]_NODE_MAGIC.
>
> Reported-by: Jan Yves Brueckner<jyb@gmx.com>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> V2: Drop re-test of hdr magic which is guaranteed to be NODE at this point.
>      fix "interior inode" - s/b "interior node"
>
> My only testcase for this is Jan Yves Brueckner's badly corrupted
> filesystem image.  With this change, we get i.e. :
>
> +bad level in interior inode for directory inode 39869938
> +corrupt block 6 in directory inode 39869957
> +       will junk block
>
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 05bd4b7..24db351 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -220,6 +220,15 @@ _("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"),
>   		 */
>   		if (i == -1) {
>   			i = da_cursor->active = nodehdr.level;
> +			/* Tests above ensure that we have NODE_MAGIC here */
> +			if (i == 0) {
> +				do_warn(
> +_("bad level 0 in interior node for directory inode %" PRIu64 "\n"),
> +					da_cursor->ino);
> +				libxfs_putbuf(bp);
> +				i = -1;
> +				goto error_out;
> +			}
>   			if (i>= XFS_DA_NODE_MAXDEPTH) {
>   				do_warn(
>   _("bad header depth for directory inode %" PRIu64 "\n"),
>

But moving the check out of the (i == -1) block, then the loop can check 
all the intermediate nodes along the way and also the ending leaf.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
