Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932262AbeALA2T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 19:28:19 -0500
Date: Thu, 11 Jan 2018 16:28:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/27] xfs_scrub: wrap the scrub ioctl
Message-ID: <20180112002808.GM5602@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520356170.2027.18237412048679725855.stgit@magnolia>
 <9f5dd182-d51a-e52f-c99b-719c712f481b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f5dd182-d51a-e52f-c99b-719c712f481b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 05:12:49PM -0600, Eric Sandeen wrote:
> On 1/5/18 7:52 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create some wrappers to call the scrub ioctls.
> 
> > +/*
> > + * Sleep for 100ms * however many -b we got past the initial one.
> > + * This is an (albeit clumsy) way to throttle scrub activity.
> > + */
> > +void
> > +background_sleep(void)
> > +{
> > +	unsigned long long	time;
> > +	struct timespec		tv;
> > +
> > +	if (bg_mode < 2)
> > +		return;
> > +
> > +	time = 100000 * (bg_mode - 1);
> 
> <coverity pass>
> 
> Probably want to cast the constant(s) to something larger if someone
> issues -b $HUGE ... 100000ULL?

I suppose, though I doubt anyone will pass -b 42,950 times. 8-)

(-b doesn't take an argument)

Fixed.

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
