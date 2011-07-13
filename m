Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DFmmpX090366 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 10:48:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38E1117C156F
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 08:48:46 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id tOJlab4yWaDGLBUx for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 08:48:46 -0700 (PDT)
Message-ID: <4E1DBE5E.3060308@sandeen.net>
Date: Wed, 13 Jul 2011 10:48:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs [stable only]: restart busy extent search after node
	removal
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
To: stable@kernel.org, xfs-oss <xfs@oss.sgi.com>

A user on #xfs reported that a log replay was oopsing in
__rb_rotate_left() with a null pointer deref, and provided
an xfs_metadump image for reproduction and testing.

I traced this down to the fact that in xfs_alloc_busy_insert(),
we erased a node with rb_erase() when the new node overlapped,
but left the erased node specified as the parent node for the
new insertion.

So when we try to insert a new node with an erased node as
its parent, obviously things go very wrong.

Upstream,
97d3ac75e5e0ebf7ca38ae74cebd201c09b97ab2 xfs: exact busy extent tracking
actually fixed this, but as part of a much larger change.  Here's
the relevant code from that commit:

                * We also need to restart the busy extent search from the
                * tree root, because erasing the node can rearrange the
                * tree topology.
                */
               rb_erase(&busyp->rb_node, &pag->pagb_tree);
               busyp->length = 0;
               return false;

We can do essentially the same thing to older codebases by restarting
the tree search after the erase.

This should apply to .35.y through .39.y, and was tested on .39
with the oopsing replay reproducer.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
---

Index: linux-2.6/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.c
+++ linux-2.6/fs/xfs/xfs_alloc.c
@@ -2664,6 +2664,12 @@ restart:
 					new->bno + new->length) -
 				min(busyp->bno, new->bno);
 		new->bno = min(busyp->bno, new->bno);
+		/*
+		 * Start the search over from the tree root, because
+		 * erasing the node can rearrange the tree topology.
+		 */
+		spin_unlock(&pag->pagb_lock);
+		goto restart;
 	} else
 		busyp = NULL;
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
