Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6CM3gFc052669 for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 17:03:42 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D82F65428
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 15:03:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YN98fLSudLFgWC7s for
	<xfs@oss.sgi.com>; Tue, 12 Jul 2011 15:03:40 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6CM3eT1017492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 18:03:40 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p6CM3cli031641
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 18:03:40 -0400
Message-ID: <4E1CC4BA.1010107@redhat.com>
Date: Tue, 12 Jul 2011 17:03:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] stable: restart busy extent search after node removal
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
To: xfs-oss <xfs@oss.sgi.com>

Sending this for review prior to stable submission...

A user on #xfs reported that a log replay was oopsing in
__rb_rotate_left() with a null pointer deref.

I traced this down to the fact that in xfs_alloc_busy_insert(),
we erased a node with rb_erase() when the new node overlapped,
but left it specified as the parent node for the new insertion.

So when we try to insert a new node with an erased node as
its parent, obviously things go very wrong.

Upstream,
97d3ac75e5e0ebf7ca38ae74cebd201c09b97ab2 xfs: exact busy extent tracking
actually fixed this, but as part of a much larger change.  Here's
the relevant bit:

                * We also need to restart the busy extent search from the
                * tree root, because erasing the node can rearrange the
                * tree topology.
                */
               rb_erase(&busyp->rb_node, &pag->pagb_tree);
               busyp->length = 0;
               return false;

We can do essentially the same thing to older codebases by restarting
the search after the erase.

This should apply to .35 through .39, and was tested on .39
with the oopsing replay reproducer.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
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
