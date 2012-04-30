Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U0WaPV176026 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 19:32:36 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fPEEr9o3vUUA11qE for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 17:32:35 -0700 (PDT)
Date: Mon, 30 Apr 2012 10:32:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 28/37] xfs: move xfsagino_t to xfs_types.h
Message-ID: <20120430003233.GB3283@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-29-git-send-email-david@fromorbit.com>
	<20120429214917.GG19889@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429214917.GG19889@infradead.org>
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

On Sun, Apr 29, 2012 at 05:49:17PM -0400, Christoph Hellwig wrote:
> On Mon, Apr 23, 2012 at 03:58:58PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Untangle the header file includes a bit by moving the definition of
> > xfs_agino_t to xfs_types.h. This removes the dependency that xfs_ag.h has on
> > xfs_inum.h, meaning we don't need to include xfs_inum.h everywhere we include
> > xfs_ag.h.
> 
> This patch by itself looks good to me, but is there any good reason to
> keep xfs_inum.h around at all?

I have that same question written down on my todo list. Seems like
most of what remains could be added to xfs_ag.h or similar. One step
at a time ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
