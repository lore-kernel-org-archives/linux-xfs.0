Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HNBnhu110002 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 18:11:49 -0500
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id S71MuKzInSiLiVb7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Aug 2012 16:11:47 -0700 (PDT)
Date: Fri, 17 Aug 2012 19:11:44 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Message-ID: <20120817231144.GC573@thunk.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
	<20120816024654.GB3781@thunk.org>
	<20120816111051.GA16036@localhost>
	<20120816152513.GA31346@thunk.org>
	<20120817060110.GA28786@localhost>
	<20120817131558.GA11439@thunk.org>
	<20120817174841.GA4519@infradead.org>
	<20120817203438.GA573@thunk.org>
	<20120817210527.GA22716@infradead.org>
	<20120817225524.GA19235@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120817225524.GA19235@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, ext4 hackers <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Aug 18, 2012 at 08:55:24AM +1000, Dave Chinner wrote:
> 
> No.  The whole point of moving to multiple directories is to allow
> easy extension for domain specific tests without having to hack up
> the check script or play other games with test naming. Duplicate
> names in different test subdirectories are most certainly allowed.

Oh, I agree, using separate directories is *way* better than the hack
we're using internally.  The main benefit of what we did was the
patches were minimally intrusive....

> > Can you take a look at Dave's series if that helps you?  I haven't
> > really reviewed it much myself yet, but I'll try to get to it ASAP.
> 
> Well, I'd apprepciate it if somebody looked at it. It's been almost
> a month since I posted it and all I've heard is crickets so far...

I definitely want to look at it, but realistically, I probably won't
have time until after San Diego....  I've been crazy busy lately.

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
