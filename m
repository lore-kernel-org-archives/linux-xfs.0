Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F309529DFC
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 16:17:46 -0500 (CDT)
Message-ID: <52322F76.4080306@sgi.com>
Date: Thu, 12 Sep 2013 16:17:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfs_repair: test for bad level in dir2 node
References: <52274F96.2010702@sandeen.net> <52322A84.1030007@sandeen.net>
In-Reply-To: <52322A84.1030007@sandeen.net>
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

On 09/12/13 15:56, Eric Sandeen wrote:
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
> V3: Simplify the test.
>
> Mark, Dave, I know you had some concerns about other conditions being
> tested, but I think those are separate from this fix, which simply ensures
> that the level we find for this _NODE block is within the valid range
> for a node.  (It also matches the test currently present in xfs_check).
>

Nod.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
