Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM0Jjps028121 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 18:19:45 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCCE41278E80
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:19:42 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PHMAGCHYtKo9YHFu for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 16:19:42 -0800 (PST)
Date: Tue, 22 Nov 2011 11:19:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inode64 readiness testing
Message-ID: <20111122001940.GH2386@dastard>
References: <501A7AEB-6708-4181-AAE2-D145DC23B938@yahoo.com>
	<20111120191050.GB11957@infradead.org>
	<C5842F44-178B-403C-9C07-BA475B16DE75@yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C5842F44-178B-403C-9C07-BA475B16DE75@yahoo.com>
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
To: Peter Kimball <peterakimball@yahoo.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 21, 2011 at 03:46:04PM -0500, Peter Kimball wrote:
> 
> On Nov 20, 2011, at 2:10 PM, Christoph Hellwig wrote:
> 
> > On Fri, Nov 18, 2011 at 12:33:16PM -0500, Peter Kimball wrote:
> >> I created a blank 1GB disk image, created an XFS filesystem on
> >> that image, and mounted it on a loopback device using the ino64
> >> flag.  
> >> 
> >> I wrote a bunch of data to the filesystem (lots of small
> >> files), approximately 600MB.
> >> 
> >> At this point, I think I have a filesystem in which inodes use
> >> 64-bit addresses, even if the actual address value would fit in
> >> 32 bits.  I would expect any program that can't handle 64-bit
> >> addresses to barf when trying to access any data on the
> >> filesystem.
> > 
> > You will never not see 64-bit inodes on a filesystem that small
> > ever.  Try to create a (sparse) 10TB loop image, and create some
> > deep directories in it.  This should create some larger inodes
> > number for you if you had it mounted with the inode64 flag.  You
> > can verify that by checking that the inode number returned from
> > the stat systsem call or from ls -i is larger than 32 bits.
> > 
> 
> Thank you for that guide, Christoph.  I followed your directions
> and the directory tree I created included some >32-bit inode
> numbers so I was able to successfully test all of our NFS clients.
> 
> From what I'd read, I thought that the ino64 mount option would do
> the work for me (bring 32-bit inode numbers into 64-bit range),
> apparently that is not the case.  This method worked great,
> hopefully the next person to search can find this happy thread.

The ino64 mount option does not exist any more - it got removed
quite some time ago as it was debug-only code that nobody ever
tested or verified did the right thing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
