Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 16:43:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5JNh2do015102
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 16:43:03 -0700
Date: Wed, 20 Jun 2007 09:42:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS shrink (step 0)
Message-ID: <20070619234248.GT86004887@sgi.com>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <1182291751.5289.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182291751.5289.9.camel@localhost>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <nahoo82@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, iusty@k1024.org

On Wed, Jun 20, 2007 at 12:22:31AM +0200, Ruben Porras wrote:
> Am Montag, den 04.06.2007, 10:16 +1000 schrieb David Chinner:
> 
> > Here's the "simple" bits that will allow you to shrink
> > the filesystem down to the end of the internal log:
> > 
> > 	0. Check space is available for shrink
> 
> Now that I'm almost* finish with the point 1),

Cool ;)

> is there any place in the
> xfs_code where a similar task is done? This way I would have a basis to
> start off.

No, there isn't anything currently in existence to do this.

It's not difficult, though. What you need to do is count the number of
used blocks in the AGs that will be truncated off, and check whether
there is enough free space in the remaining AGs to hold all the
blocks that we are going to move.

I think this could be done we a single loop across the perag
array or with a simple xfs_db wrapper and some shell/awk/perl
magic.

e.g: Here's the basis:

budgie:~ # for i in `seq 0 1 7`; do
> xfs_db -r -c "agf $i" -c "p freeblks" -c "p btreeblks" /dev/sdb8
> done
freeblks = 32779
btreeblks = 0
freeblks = 63003
btreeblks = 0
freeblks = 124423
btreeblks = 0
freeblks = 114516
btreeblks = 0
freeblks = 126602
btreeblks = 0
freeblks = 125905
btreeblks = 0
freeblks = 127886
btreeblks = 0
freeblks = 125445
btreeblks = 0

Now all you need to extract is the size of each ag from teh superblock,
determine which AGs are going to be freed, and do some math ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
