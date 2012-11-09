Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9NEG5h168617 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 17:14:17 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LftzKBB7iIqrg4sq for <xfs@oss.sgi.com>;
	Fri, 09 Nov 2012 15:16:15 -0800 (PST)
Date: Sat, 10 Nov 2012 10:15:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to reserve disk space in XFS to make the blocks over many
	files continuous?
Message-ID: <20121109231558.GG6434@dastard>
References: <CANS6a=D4SMMqhGJVMLbr-BWqLb-Z4L4LnofzfhqChBvE9dEtPQ@mail.gmail.com>
	<20121107031952.GA6434@dastard>
	<1352473401.3179.48.camel@montana.filmlight.ltd.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352473401.3179.48.camel@montana.filmlight.ltd.uk>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: huubby zhou <huubby1@gmail.com>, xfs@oss.sgi.com

On Fri, Nov 09, 2012 at 03:03:21PM +0000, Roger Willcocks wrote:
> 
> > > My question is, how can I guarantee the file system blocks over files
> > > continuous? Thanks for your time and appreciate your answer.
> > 
> > You can't, directly. 
> 
> We needed to do this so I added code to swapext to support transferring
> leading blocks from one (preallocated single extent) file to another
> empty file. It's pretty straightforward but perhaps too special case for
> general consumption.

Please post the patch - swapping arbitrary ranges between two inodes
is something that is definitely useful. It is needed, for example,
to do directory defragmentation, and I know that non-linear video
editting apps would love ioctls to do similar things within the same
file (e.g. punching ads out of a video stream without having to copy
data around at all).

That's a note for anyone that has implemented stuff like this -
regardless of whether you think it is useful or not, having the
patches out in the open (not matter what the state of the code)
makes it 100x more valuable than keeping it to yourself, and it
allows people to build functionality off them rather than having to
re-invent the wheel.

And, of course, there is the possibility we add the functionality to
the main tree, and you no longer have to maintain and test it
yourself.... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
