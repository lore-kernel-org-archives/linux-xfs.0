Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MNOMnH133287 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 18:24:22 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97BB9DFF79E
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 16:24:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rvbdvykUQceJU0rF for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 16:24:20 -0700 (PDT)
Date: Thu, 23 Jun 2011 09:24:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair: "fatal error -- ran out of disk space!"
Message-ID: <20110622232418.GV32466@dastard>
References: <BANLkTi=gS5iO9R9pVk_df-4ofkkb0ZJgfw@mail.gmail.com>
	<4E026C42.2030500@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E026C42.2030500@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Patrick J. LoPresti" <lopresti@gmail.com>, xfs@oss.sgi.com

On Wed, Jun 22, 2011 at 05:27:14PM -0500, Eric Sandeen wrote:
> On 6/22/11 4:32 PM, Patrick J. LoPresti wrote:
> > I have a 5.1TB XFS file system that is 93% full (399G free according to "df").
> > 
> > I am trying to run "xfs_repair" on it.
> > 
> > The output is appended.
> > 
> > Question:  What am I supposed to do about this?  "xfs_repair -V" says
> > "xfs_repair version 3.1.5".  (I downloaded and built the latest
> > version hoping it would fix the issue, but no luck.)  Should I just
> > start deleting files at random?
> 
> You could start by removing a few files you know you don't need, rather than
> at random.  :)
> 
> TBH I've not seen this one before, and the error message is not all that
> helpful.  It'd be nice to know how many blocks it was trying to reserve
> when it ran out of space; I guess you'd need to use gdb, or instrument
> all the calls to res_failed() in phase6.c to know for sure...

Also, the number of inodes and directories in your filesystem might
tell us whether we should expect an ENOSPC, as well. I suspect that
there's an accounting error, because 400GB of transaction
reservations is an awful lot of directory rebuilds....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
