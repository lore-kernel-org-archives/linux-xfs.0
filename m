Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF4C329DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:20:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB3E8304097
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 15:20:34 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9tvYOV0zoulv4rWL for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 15:20:33 -0800 (PST)
Date: Tue, 3 Dec 2013 10:20:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/15] mkfs: merge getnum
Message-ID: <20131202232028.GE10988@dastard>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-13-git-send-email-david@fromorbit.com>
	<20131202172233.GD28630@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131202172233.GD28630@infradead.org>
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

On Mon, Dec 02, 2013 at 09:22:33AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 29, 2013 at 12:43:47PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > getnum() is now only called by getnum_checked(). Move the two
> > together into a single getnum() function and change all the callers
> > back to getnum().
> 
> So we now have two different getnums in mkfs now.  Maybe the one in
> proto.c should have a different name? 

Probably should.

> 
> > +static long long
> > +getnum(
> > +	const char	*str,
> > +	unsigned int	blksize,
> > +	unsigned int	sectsize,
> > +	bool		convert)
> > +{
> > +	long long	i;
> > +	char		*sp;
> > +
> > +	if (convert)
> > +		return cvtnum(blksize, sectsize, str);
> 
> Also the whole if convert is true sillyness lives on here.  The caller
> that wants cvtnum should just call it directly.

Yes, but soon it doesn't just return the value directly ;)

> > +	else {
> > +		char		*sp;
> > +
> > +		c = strtoll(str, &sp, 0);
> > +		if (c == 0 && sp == str)
> > +			illegal_option(str, opts, index);
> > +		if (*sp != '\0')
> > +			illegal_option(str, opts, index);
> > +	}
> 
> And given that the strtoll wrapping code is the same for both getnums
> I suspect we shoud just have a mkfs_strtoll that gets called here,
> and directly by the proto.c callers.

I'll have a look at doing that once everything else falls out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
