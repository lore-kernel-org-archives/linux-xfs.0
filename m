Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E9837F4E
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 03:58:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 91B2DAC006
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 01:58:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id C2e7XLH5VM3DmP5J (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 01:58:48 -0800 (PST)
Date: Mon, 16 Feb 2015 07:58:42 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC] xfs shrink feature
Message-ID: <20150216095842.GA1938@hades.maiolino.org>
References: <20150213131446.GC1800@hades.maiolino.org>
	<20150213223507.GV4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150213223507.GV4251@dastard>
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

Hi Dave,

On Sat, Feb 14, 2015 at 09:35:07AM +1100, Dave Chinner wrote:
> On Fri, Feb 13, 2015 at 11:14:46AM -0200, Carlos Maiolino wrote:
> > Hi folks,
> > 
> > I've been seeing a lot of users requesting a shrink feature for XFS, and I
> > believe it's time to have it implemented in XFS.
> 
> I'm not so sure about that.
> 
> > Is there anybody working on a shrink feature? If not, I'm going to
> > start to work on it, if nobody have any objections.
> 
> 
> I currently in design discussions with various other developers
> about a line of development that will make growing and shrinking XFS
> redundant operations. i.e. if we get this right, we'll never need to
> deal with capacity changes of XFS filesystems at the XFS level
> again. both grow and shrink will be instanteneous, and not require
> any modification to the layout of the filesystem at all.
> 
Oh, I had no idea about this discussion :)

> Mind you, that's not the reason for that line of development - it's
> all about integrated snapshots in XFS. We essentially get
> grow/shrink for free with that infrastructure....
>

I suppose LSF will be the place for that design discussion.
 
> I'm not quite ready to publish the docco yet - need to get all my
> ducks in a line first - but if it does work out as a feasible line
> of development, then the old "shrink" method is essentially a dead
> end.
> 
> However, don't let that stop you working towards shrink, because
> there is infrastructure that it requires that we need for other
> things as well. Take you pick:
> 
> 	- parent pointers
> 	- AG state control
> 	- ranged bulkstat call (e.g. AG range)
> 	- allocation location control from userspace
> 	  (which may tie in to AG state control)
> 	- Atomic inode location swaps
> 
> 
> http://oss.sgi.com/archives/xfs/2014-01/msg00263.html
> 
> But it's worth reading the entire discussion starting here because
> it start with a summary of the different approaches taken and why
> they were rejected:
> 
> http://oss.sgi.com/archives/xfs/2014-01/msg00224.html
> 
> Cheers,
> 

Yep, I can work on that stuff, thanks for pointing me up the parent inodes
discussion.

I'll try to show up with something soon.

Cheers

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
