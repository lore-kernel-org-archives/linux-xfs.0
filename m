Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 780FA7F4E
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 02:03:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A475304043
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 00:03:30 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 0YkVGOKfHGuOO9Ww (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Apr 2014 00:03:29 -0700 (PDT)
Date: Mon, 14 Apr 2014 09:03:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/9] xfs: split xfs_bmap_btalloc_nullfb
Message-ID: <20140414070325.GA22490@lst.de>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
	<1397289723-26243-3-git-send-email-hch@lst.de>
	<20140414015544.GH27694@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140414015544.GH27694@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 14, 2014 at 11:55:44AM +1000, Dave Chinner wrote:
> > +static void
> > +xfs_bmap_fix_args(
> > +	struct xfs_bmalloca	*ap,
> > +	struct xfs_alloc_arg	*args,
> > +	xfs_extlen_t		*blen,
> > +	int			notinit)
> 
> Not a big fan of the "fix_args" name here. What it's actually doing
> is setting the minimum allocation length. Also, it could return the
> minimum length rather than set it inside the function, and pass
> blen by value rather than reference as it isn't modified in the
> function...

Sure.  A any good suggestion for a name?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
