Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ONUASR136068 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 17:30:10 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BCD91546F46
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 15:32:31 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3wQNCQmPb0vDitDJ for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 15:32:31 -0800 (PST)
Date: Tue, 25 Jan 2011 10:32:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: prevent extsize alignment from exceeding
	maximum extent size
Message-ID: <20110124233218.GC11040@dastard>
References: <1295411400-15614-1-git-send-email-david@fromorbit.com>
	<1295411400-15614-4-git-send-email-david@fromorbit.com>
	<20110124090458.GD26744@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110124090458.GD26744@infradead.org>
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

On Mon, Jan 24, 2011 at 04:04:59AM -0500, Christoph Hellwig wrote:
> > +					/*
> > +					 * make sure we don't exceed a single
> > +					 * extent length when we align the
> > +					 * extent by reducing length we are
> > +					 * going to allocate by the maximum
> > +					 * amount extent size aligment may
> > +					 * require.
> > +					alen = (xfs_extlen_t)XFS_FILBLKS_MIN(
> > +							len,
> > +						MAXEXTLEN - (2 * extsz - 1));
> > +					 */
> 
> This essentially just adds a comment, given that the new code is inside
> the bracing.  Also the xfs_extlen_t cast seems pointless.  The C type
> promotion rules do just fine for going down from a 64bit type to a 32bit
> one, as long as the results fit into the latter - which they always do
> here.

Argh, forgot to refresh the patch after doing some bug hunting.
I'll fix it and retest before I repost it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
