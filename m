Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UMoHcV036433 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 17:50:17 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JqmUKWf3NRc5Esfp for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 15:51:10 -0700 (PDT)
Date: Fri, 31 Aug 2012 08:51:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2 00/13] xfs: remove the xfssyncd mess
Message-ID: <20120830225108.GF15292@dastard>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<20120830121516.GA285@x4>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120830121516.GA285@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 30, 2012 at 02:15:16PM +0200, Markus Trippelsdorf wrote:
> On 2012.08.30 at 22:00 +1000, Dave Chinner wrote:
> > Version 2 of the patchset I described here:
> > 
> > http://oss.sgi.com/archives/xfs/2012-06/msg00064.html
> > 
> > This version has run through xfstests completely once, so it's
> > less likely to let smoke out....
> 
> Is there a publicly accessible git tree available where one could pull
> from? (This would be way easier than saving and hand-applying 13
> patches.)

No.

Instead, save all the patches to a single mbox format file, then run:

$ git checkout -b umount-fix-test
$ git am <mbox file>

And it will apply all the patches as separate commits to the
umount-fix-test branch. This is how I take patch sets from my inbox
to git. You can build and testing them from there.

I, personally, convert them to a guilt series first, usually
integrating them into my working/test branch to test them along with
everything else I'm working on at the same time. To do this, I
generally do:

$ git checkout -b umount-fix-test working
$ git am <mbox file>
$ git checkout working
$ git log --pretty=oneline working..umount-fix-test
<record first and last commit id in applied series>
$ guilt import-commits <first-commit..last-commit>

And that adds the commits from the umount-fix-test branch into
individual patches in the guilt series preserving all the metadata
from the original sender in them. i.e. if I then patchbomb them back
to the mailing list, they will have the correct "From:" attribution
and dates as found in the original emails....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
