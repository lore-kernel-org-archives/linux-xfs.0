Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p71J0I07021092 for <xfs@oss.sgi.com>; Mon, 1 Aug 2011 14:00:18 -0500
Received: from out2.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78AA918572BF
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2011 12:00:16 -0700 (PDT)
Received: from out2.smtp.messagingengine.com (out2.smtp.messagingengine.com
	[66.111.4.26]) by cuda.sgi.com with ESMTP id vJxEonEpet8lOlgl
	for <xfs@oss.sgi.com>; Mon, 01 Aug 2011 12:00:16 -0700 (PDT)
Subject: Patch "xfs [stable only]: restart busy extent search after node
	removal" has been added to the 2.6.39-stable tree
From: <gregkh@suse.de>
Date: Mon, 01 Aug 2011 11:58:41 -0700
In-Reply-To: <4E1DBE5E.3060308@sandeen.net>
Message-ID: <13122251213985@kroah.org>
MIME-Version: 1.0
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
To: sandeen@sandeen.net, aelder@sgi.com, dchinner@redhat.com, gregkh@suse.de, sandeen@redhat.com, xfs@oss.sgi.com
Cc: stable@kernel.org, stable-commits@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xfs [stable only]: restart busy extent search after node removal

to the 2.6.39-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-restart-busy-extent-search-after-node-removal.patch
and it can be found in the queue-2.6.39 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@kernel.org> know about it.


>From sandeen@sandeen.net  Mon Aug  1 11:47:45 2011
From: Eric Sandeen <sandeen@sandeen.net>
Date: Wed, 13 Jul 2011 10:48:46 -0500
Subject: xfs [stable only]: restart busy extent search after node removal
To: stable@kernel.org, xfs-oss <xfs@oss.sgi.com>
Message-ID: <4E1DBE5E.3060308@sandeen.net>

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
 


Patches currently in stable-queue which might be from sandeen@sandeen.net are

queue-2.6.39/xfs-restart-busy-extent-search-after-node-removal.patch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
