Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p71NRs7f046042 for <xfs@oss.sgi.com>; Mon, 1 Aug 2011 18:27:54 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15437124B0B4
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2011 16:28:32 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id iwwiDqXZT5XXMBhR for <xfs@oss.sgi.com>;
	Mon, 01 Aug 2011 16:28:32 -0700 (PDT)
Message-Id: <20110801232056.712213193@clark.kroah.org>
Date: Mon, 01 Aug 2011 16:19:16 -0700
From: Greg KH <gregkh@suse.de>
Subject: [61/70] xfs [stable only]: restart busy extent search after node
	removal
In-Reply-To: <20110801232124.GA15313@kroah.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, stable@kernel.org, xfs-oss <xfs@oss.sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@sandeen.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 fs/xfs/xfs_alloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2610,6 +2610,12 @@ restart:
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
