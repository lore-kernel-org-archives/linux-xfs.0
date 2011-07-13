Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6D0CtBh056845 for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 19:12:56 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E24212C1C3A
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 17:12:53 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KxbrGFjqIojAsfrf for <xfs@oss.sgi.com>;
	Tue, 12 Jul 2011 17:12:53 -0700 (PDT)
Date: Wed, 13 Jul 2011 10:12:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] stable: restart busy extent search after node removal
Message-ID: <20110713001234.GN23038@dastard>
References: <4E1CC4BA.1010107@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E1CC4BA.1010107@redhat.com>
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

On Tue, Jul 12, 2011 at 05:03:38PM -0500, Eric Sandeen wrote:
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
> ---
> 
> Index: linux-2.6/fs/xfs/xfs_alloc.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_alloc.c
> +++ linux-2.6/fs/xfs/xfs_alloc.c
> @@ -2664,6 +2664,12 @@ restart:
>  					new->bno + new->length) -
>  				min(busyp->bno, new->bno);
>  		new->bno = min(busyp->bno, new->bno);
> +		/*
> +		 * Start the search over from the tree root, because
> +		 * erasing the node can rearrange the tree topology.
> +		 */
> +		spin_unlock(&pag->pagb_lock);
> +		goto restart;
>  	} else
>  		busyp = NULL;

Looks good.

I'm guessing that the only case I was able to hit during testing of
this code originally was the "overlap with exact start block match",
otherwise I would have seen this. I'm not sure that there really is
much we can do to improve the test coverage of this code, though.
Hell, just measuring our test coverage so we know what we aren't
testing would probably be a good start. :/

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
