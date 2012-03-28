Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2SIhL5d171376 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 13:43:21 -0500
Date: Wed, 28 Mar 2012 13:43:30 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/8] xfs: initialise xfssync work before running
	quotachecks
Message-ID: <20120328184330.GC8451@sgi.com>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-4-git-send-email-david@fromorbit.com>
	<20120328173829.GD7762@sgi.com>
	<20120328180203.GA24483@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120328180203.GA24483@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Mar 28, 2012 at 02:02:03PM -0400, Christoph Hellwig wrote:
> On Wed, Mar 28, 2012 at 12:38:29PM -0500, Ben Myers wrote:
> > I haven't seen a patch to use d_make_root instead of d_alloc_root, so we'll
> > take the earlier version of this patch... this one doesn't apply.  ;)
> 
> d_alloc_root is gone in mainline.  Maybe get the next pull request out
> without this patch, and then send it post -rc1 on a tree based upton
> rc1?

That sounds good to me.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
