Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D0EB77F51
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:17:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5845EAC001
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 15:17:28 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OouA7RkHcdc5zZdW for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 15:17:26 -0800 (PST)
Date: Tue, 3 Dec 2013 10:16:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/15] mkfs: structify input parameter passing
Message-ID: <20131202231648.GD10988@dastard>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-8-git-send-email-david@fromorbit.com>
	<20131202171103.GC14935@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131202171103.GC14935@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Dec 02, 2013 at 09:11:03AM -0800, Christoph Hellwig wrote:
> > +	const char	name;
> > +	const char	*subopts[MAX_SUBOPTS];
> > +	struct subopt_param {
> > +		int		index;
> > +		long long	minval;
> > +		long long	maxval;
> > +	}		subopt_params[MAX_SUBOPTS];
> > +};
> 
> Any reason to have a separate array for subopts instead of
> moving it into struct subopt_param?

getsubopt() requires a array of tokens for it's parsing, hence the
separation of the subopts names and the related parameters.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
