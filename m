Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E55437F6B
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 20:14:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D186D304039
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 18:14:55 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6w1CFyCV8AKUSogK for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 18:14:53 -0700 (PDT)
Date: Sat, 31 May 2014 11:14:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140531011450.GJ14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-12-git-send-email-arnd@arndb.de>
	<20140531003712.GH14410@dastard> <5389252A.5050503@zytor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5389252A.5050503@zytor.com>
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
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

On Fri, May 30, 2014 at 05:41:14PM -0700, H. Peter Anvin wrote:
> On 05/30/2014 05:37 PM, Dave Chinner wrote:
> > 
> > IOWs, the filesystem has to be able to reject any attempt to set a
> > timestamp that is can't represent on disk otherwise Bad Stuff will
> > happen,
> 
> Actually it is questionable if it is worse to reject a timestamp or just
> let it wrap.  Rejecting a valid timestamp is a bit like "You don't
> exist, go away."

I think having the new systems calls being able to
return EINVAL if the value cannot be stored permanently on disk
correctly is the right thing to do. Having it silently mangled
by the filesystem and returning "everything is just fine, trust me"
is close to the worst solution I can think of. That's exactly what
leads to overflow bugs occurring....

> > and filesystems have to be able to specify in their on
> > disk format what timestamp encoding is being used. The solution will
> > be different for every filesystem that needs to support time beyond
> > 2038.
> 
> Actually the cutoff can be really different for each filesystem, not
> necessarily 2038.  However, I maintain the above still holds.

Sure, but all filesystems are supposed to handle at least the
current unix epoch.

> Consider a filesystem that kept timestamps in YYMMDDHHMMSS format.  What
> would you have expected such a filesystem to do on Jan 1, 2000?

Strawman.

We don't need to cater for fundamentally broken designs that can't
even handle the current unix epoch correctly. If such filesystems
exist, then they can simple say "original unix epoch support only"
and do whatever crap they are doing right now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
