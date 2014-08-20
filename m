Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB07C7F4E
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 18:47:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2BAB7AC002
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 16:47:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IL4eKUblxLyRBbwP for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 16:47:33 -0700 (PDT)
Date: Thu, 21 Aug 2014 09:47:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump completes very prematurely in low RAM, commit found
Message-ID: <20140820234729.GW20518@dastard>
References: <53F15EEF.4090308@gmail.com> <20140818024114.GK20518@dastard>
	<53F1FBBC.8000903@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F1FBBC.8000903@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Aug 18, 2014 at 09:12:28AM -0400, Michael L. Semon wrote:
> On 08/17/14 22:41, Dave Chinner wrote:
> >On Sun, Aug 17, 2014 at 10:03:27PM -0400, Michael L. Semon wrote:
> >>Hi!  I had some phantom issues that are chasing me through this 3.17
> >>merge window period.  While chasing those issues, I decided to do an
> >>xfsdump of a v5/finobt XFS system rescued from PEBKAC issues.  The
> >>xfsdump completed rather prematurely, ending like this test case
> >>output...
> >>
> >>xfsdump: dumping special file ino 4194523 mode 0x21b0
> >>xfsdump: dumping special file ino 4194524 mode 0x21b0
> >>xfsdump: dumping special file ino 4194525 mode 0x21b0
> >>xfsdump: dumping special file ino 4194526 mode 0x21b0
> >>xfsdump: dumping special file ino 4194527 mode 0x21b0
> >>xfsdump: ending media file
> >>xfsdump: media file size 4512992 bytes
> >>xfsdump: ending stream: 23 seconds elapsed
> >>xfsdump: dump size (non-dir files) : 4452088 bytes
> >>xfsdump: dump complete: 23 seconds elapsed
> >>xfsdump: Dump Summary:
> >>xfsdump:   stream 0 /mnt/xfstests-scratch/blah.0.dump OK (success)
> >>xfsdump: Dump Status: SUCCESS
> >>
> >>That looks fine for a lack of obvious error messages.  However, it
> >>should end like this:
> >>
> >>xfsdump: dumping regular file ino 13653551 offset 0 to offset 12154 (size 12154)
> >>xfsdump: dumping regular file ino 13653555 offset 0 to offset 16554 (size 16554)
> >>xfsdump: dumping regular file ino 13653556 offset 0 to offset 185 (size 185)
> >>xfsdump: dumping regular file ino 13653557 offset 0 to offset 471 (size 471)
> >>xfsdump: dumping special file ino 13653558 mode 0xa1ff
> >>xfsdump: ending media file
> >>xfsdump: media file size 1999127056 bytes
> >>xfsdump: ending stream: 465 seconds elapsed
> >>xfsdump: dump size (non-dir files) : 1963549104 bytes
> >>xfsdump: dump complete: 465 seconds elapsed
> >>xfsdump: Dump Summary:
> >>xfsdump:   stream 0 /mnt/xfstests-scratch/blah.0.dump OK (success)
> >>xfsdump: Dump Status: SUCCESS
> >
> >What's the inode number progression of a successful dump at the
> >point at which the incomplete dump ends? i.e. around inode 4194527?
> >That number is one inode chunk short of 2^22, which implies that
> >there is a failure or some kind moving from one AG to the next.
> >The progrssion of inode numbers will tell me whether this is the
> >case or not...
> 
> It is this, run a bit longer to show xfsdump start to dump regular
> files again:
> 
> xfsdump: dumping special file ino 4194520 mode 0x21b0
> xfsdump: dumping special file ino 4194521 mode 0x21b0
> xfsdump: dumping special file ino 4194522 mode 0x21b0
> xfsdump: dumping special file ino 4194523 mode 0x21b0
> xfsdump: dumping special file ino 4194524 mode 0x21b0
> xfsdump: dumping special file ino 4194525 mode 0x21b0
> xfsdump: dumping special file ino 4194526 mode 0x21b0
> xfsdump: dumping special file ino 4194527 mode 0x21b0
> xfsdump: dumping special file ino 4194528 mode 0x21b0
> xfsdump: dumping special file ino 4194529 mode 0x21b0
> xfsdump: dumping special file ino 4194530 mode 0x21b0
> xfsdump: dumping special file ino 4194531 mode 0x21b0
> xfsdump: dumping special file ino 4194532 mode 0x21b0
> xfsdump: dumping special file ino 4194533 mode 0x21b0
> xfsdump: dumping special file ino 4194534 mode 0x21b0
> xfsdump: dumping special file ino 4194535 mode 0x21b0
> xfsdump: dumping special file ino 4194536 mode 0x21b0

So it's not the end of the AG that is causing problems. Can you get
a tracepoint dump of the failing xfsdump run? i.e.

$ trace-cmd record -e xfs\* <xfsdump command>
.....
$ trace-cmd report > traces.txt

and send me that traces.txt file (compress it first, please).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
