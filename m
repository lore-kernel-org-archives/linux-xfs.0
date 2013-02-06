Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC6167F60
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 18:44:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89632304032
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 16:44:47 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	w8gj7OHJ4b0bEK20 for <xfs@oss.sgi.com>;
	Tue, 05 Feb 2013 16:44:45 -0800 (PST)
Date: Wed, 6 Feb 2013 11:44:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs deadlock on buffer semaphore while reading directory
Message-ID: <20130206004442.GS2667@dastard>
References: <20130202192007.GS30577@one.firstfloor.org>
	<510D6EDE.1080409@sgi.com> <510E054B.2070500@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <510E054B.2070500@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs@oss.sgi.com

On Sat, Feb 02, 2013 at 10:35:55PM -0800, Linda Walsh wrote:
> 
> 
> Mark Tinguely wrote:
> >On 02/02/13 13:20, Andi Kleen wrote:
> >>
> >>On a older 3.6-rc9 opensuse kernel I had the following deadlock with
> >
> >That looks like a hang fixed by the series:
> >
> >    http://oss.sgi.com/archives/xfs/2012-12/msg00071.html
> ----
> 
> That may be so -- I used to see things like that on some older
> kernels with random progs but with traces down in xfs..
> 
> Seemed to be rare and not cause problems....but don't notice those any
> more...
> 
> Odd thing about my current probs -- my current system has been
> up 12 days...but before that it had been up 43 days...
> 
> 
> I can't get the buffers to 'free' no matter what
> echo 3> /proc/sys/vm/drop_caches does nothing.

What buffers are you talking about? The deadlock is in metadata
buffer handling, which you can't directly see, and will never be
able to entirely free via drop caches.

if you are talking about what is reported by the "free" command,
then that number can be ignored as it is mostly meaningless for XFS
filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
