Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC57B7F4E
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 02:17:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35CD3AC002
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 00:17:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ORh4rGiydTgsGyoN for <xfs@oss.sgi.com>;
	Mon, 14 Apr 2014 00:17:15 -0700 (PDT)
Date: Mon, 14 Apr 2014 17:17:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: split xfs_bmap_btalloc_nullfb
Message-ID: <20140414071711.GL27694@dastard>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
	<1397289723-26243-3-git-send-email-hch@lst.de>
	<20140414015544.GH27694@dastard> <20140414070325.GA22490@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140414070325.GA22490@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Apr 14, 2014 at 09:03:25AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 14, 2014 at 11:55:44AM +1000, Dave Chinner wrote:
> > > +static void
> > > +xfs_bmap_fix_args(
> > > +	struct xfs_bmalloca	*ap,
> > > +	struct xfs_alloc_arg	*args,
> > > +	xfs_extlen_t		*blen,
> > > +	int			notinit)
> > 
> > Not a big fan of the "fix_args" name here. What it's actually doing
> > is setting the minimum allocation length. Also, it could return the
> > minimum length rather than set it inside the function, and pass
> > blen by value rather than reference as it isn't modified in the
> > function...
> 
> Sure.  A any good suggestion for a name?

<shrug>

xfs_bmap_select_minlen()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
