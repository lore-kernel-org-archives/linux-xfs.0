Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B12C7F87
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 17:53:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 174A9AC002
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 15:53:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iq7bBiGU3pET4JCD for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 15:53:24 -0700 (PDT)
Date: Fri, 10 Apr 2015 08:53:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: interesting MD-xfs bug
Message-ID: <20150409225322.GH13731@dastard>
References: <5526E8E9.3030805@gmail.com> <20150409221846.GG13731@dastard>
	<5526FB2A.8060704@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5526FB2A.8060704@gmail.com>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Thu, Apr 09, 2015 at 06:20:26PM -0400, Joe Landman wrote:
> 
> 
> On 04/09/2015 06:18 PM, Dave Chinner wrote:
> >On Thu, Apr 09, 2015 at 05:02:33PM -0400, Joe Landman wrote:
> >>If I build an MD raid0 with a non power of 2 chunk size, it appears
> >>that I can mkfs.xfs a file system, but it doesn't show up in blkid
> >>and is not mountable.  Yet, using a power of 2 chunk size, this does
> >>work correctly.   This is kernel 3.18.9.
> >>
> 
> [...]
> 
> >That looks more like a blkid or udev problem. try using blkid -p so
> >that it doesn't look up the cache but directly probes devices for
> >the signatures. strace might tell you a bit more, too. And if the
> >filesystem mounts, then it definitely isn't an XFS problem ;)
> 
> Thats the thing, it didn't mount, even when I used the device name
> directly.

Ok, that's interesting. Let me see if I can reproduce it locally. If
you don't hear otherwise, tracing would still be useful. Thanks for
the bug report, Joe.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
