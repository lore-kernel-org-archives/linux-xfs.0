Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED6867F58
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 17:54:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82FB5AC006
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 15:54:22 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yPZHZA8UP6a5U97m for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 15:54:20 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6775063D04AA
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 17:54:20 -0600 (CST)
Message-ID: <52FC09AB.3030209@sandeen.net>
Date: Wed, 12 Feb 2014 17:54:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Limits on agi->agi_level (and other btree depths?)
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
To: xfs-oss <xfs@oss.sgi.com>

If agi->agi_level exceeds XFS_BTREE_MAXLEVELS (8), bad things happen.  For example in xfs_inobt_init_cursor() we read it directly off disk into a btree cursor:

xfs_inobt_init_cursor()
	cur->bc_nlevels = be32_to_cpu(agi->agi_level);

and then when it's time to tear it down we'll index into bc_bufs[] buy whatever it said:

xfs_btree_del_cursor()
        for (i = 0; i < cur->bc_nlevels; i++) {
                if (cur->bc_bufs[i])
                        xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);

but bc_bufs[] in the xfs_btree_cur is of fixed size:

        struct xfs_buf  *bc_bufs[XFS_BTREE_MAXLEVELS];  /* buf ptr per level */

where

#define XFS_BTREE_MAXLEVELS     8       /* max of all btrees */

(which means this limits any btree depth, not just agi, right...)

...

So I ran across this on an intentionally corrupted image, but I don't know what stops us from going past XFS_BTREE_MAXLEVELS in normal operations (unless we just hit filesystem limits before then?)

i.e. xfs_btree_new_root() does:

        /* Set the root in the holding structure  increasing the level by 1. */
        cur->bc_ops->set_root(cur, &lptr, 1);

and ->set_root / xfs_inobt_set_root() will happily increase agi_level; I don't see anything limiting it to XFS_BTREE_MAXLEVELS.

I guess XFS_BTREE_MAXLEVELS is just an arbitrary in-memory limit, not a limit of the underlying disk structures, but as it stands, we should be sure that we don't exceed it, right?

I was going to put that limit into xfs_agi_verify, but realized that I wasn't sure if we could actually exceed that depth in normal operations.

(cue dchinner working out that 9 levels is 59 bazillion jillion items, and will never be hit?)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
