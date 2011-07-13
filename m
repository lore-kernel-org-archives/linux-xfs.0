Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DDo5FS085839 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 08:50:05 -0500
Subject: Re: [PATCH] stable: restart busy extent search after node removal
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4E1CC4BA.1010107@redhat.com>
References: <4E1CC4BA.1010107@redhat.com>
Date: Wed, 13 Jul 2011 08:50:01 -0500
Message-ID: <1310565001.1998.7.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, 2011-07-12 at 17:03 -0500, Eric Sandeen wrote:
> Sending this for review prior to stable submission...
> 
> A user on #xfs reported that a log replay was oopsing in
> __rb_rotate_left() with a null pointer deref.
> 
> I traced this down to the fact that in xfs_alloc_busy_insert(),
> we erased a node with rb_erase() when the new node overlapped,
> but left it specified as the parent node for the new insertion.
> 
> So when we try to insert a new node with an erased node as
> its parent, obviously things go very wrong.
> 
> Upstream,
> 97d3ac75e5e0ebf7ca38ae74cebd201c09b97ab2 xfs: exact busy extent tracking
> actually fixed this, but as part of a much larger change.  Here's
> the relevant bit:
> 
>                 * We also need to restart the busy extent search from the
>                 * tree root, because erasing the node can rearrange the
>                 * tree topology.
>                 */
>                rb_erase(&busyp->rb_node, &pag->pagb_tree);
>                busyp->length = 0;
>                return false;
> 
> We can do essentially the same thing to older codebases by restarting
> the search after the erase.
> 
> This should apply to .35 through .39, and was tested on .39
> with the oopsing replay reproducer.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
