Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9J9vBcK143005 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 04:57:12 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C93EF26322
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 03:13:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CSwT1LhRwk7EteKy for
	<xfs@oss.sgi.com>; Tue, 19 Oct 2010 03:13:18 -0700 (PDT)
Date: Tue, 19 Oct 2010 11:58:15 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Add test 244: Check filesystem FITRIM
In-Reply-To: <20101019090303.GD11284@dastard>
Message-ID: <alpine.LFD.2.00.1010191126370.2991@dhcp-lab-213.englab.brq.redhat.com>
References: <1285863641-1894-1-git-send-email-lczerner@redhat.com>
	<1287395946-6890-1-git-send-email-lczerner@redhat.com>
	<20101019090303.GD11284@dastard>
MIME-Version: 1.0
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
Cc: Lukas Czerner <lczerner@redhat.com>, sandeen@redhat.com, xfs@oss.sgi.com

On Tue, 19 Oct 2010, Dave Chinner wrote:

> On Mon, Oct 18, 2010 at 11:59:06AM +0200, Lukas Czerner wrote:
> > Check filesystem FITRIM implementation. FITRIM is ioctl that uses
> > filesystem new super_operation->trim_fs. Its purpose is to provide
> > a way to discard free space on mounted filesystem in more efficient
> > manner. More details here:
> > 
> > http://www.spinics.net/lists/linux-ext4/msg21050.html
> > 
> > This test creates checksums of all files in /usr/share/doc directory and
> > run several processes which clear its working directory, then copy
> > everything from /usr/share/doc into its working directory, create list of
> > files in working directory and its checksums and compare it with the
> > original list of checksums. Every process works in the loop so it repeat
> > remove->copy->check, while fstrim tool is running simultaneously.
> > 
> > Fstrim is just a helper tool which uses FITRIM ioctl to actually do the
> > filesystem discard.
> > 
> > I found this very useful because when the FITRIM is really buggy (thus
> > data-destroying) the 244 test will notice, because checksums will most
> > likely change.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  244          |  163 +++++++++++++++++++++++++++++++++++++
> >  244.out      |    4 +
> >  group        |    1 +
> >  src/Makefile |    2 +-
> >  src/fstrim.c |  251 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 420 insertions(+), 1 deletions(-)
> >  create mode 100755 244
> >  create mode 100644 244.out
> >  create mode 100644 src/fstrim.c
> > 
> > diff --git a/244 b/244
> > new file mode 100755
> > index 0000000..01e7545
> > --- /dev/null
> > +++ b/244
> > @@ -0,0 +1,163 @@
> > +#!/bin/bash -
> > +# -*- Shell-script -*-
> 
> That comment can be killed. ;)
> 
> > +#
> > +# Copyright (C) 1999 Bibliotech Ltd., 631-633 Fulham Rd., London SW6 5UQ.
> 
> Ah, where does the code under that copyright come from? What license
> did it originally have?

Well, the script itself is a part of Gensuit (generic test suit) which
I was working on and the script was already there so I assumed that it
is GPL. But when you have mentioned it, I really do not know what the
licence was. I have manage to find the source of it:

http://www.1u-raid5.net/Testing/raid_test_stress.sh.txt

So I'll try to contact the author to confirm licence. I certainly can
write this myself, but I guess there is no point in that since this is
working well (We'll see about the licence).

> > +
> > +	while true ; do
> > +		step=1048576
> > +		start=0
> > +		$here/src/fstrim $SCRATCH_MNT &
> > +		fpid=$!
> > +		wait $fpid
> 
> Why put it in the background, only to wait for it immediately? 

Because trimming the whole device can take a while and when the test
is going to end I really need to wait for it to finish  before the test
exits. And simply waiting for the process running this loop is not enough,
because in some cases I could not umount the disk due to fstrim.

> 
> > +		while [ $start -lt $fsize ] ; do
> > +			$here/src/fstrim -s ${start}k -l ${step}k $SCRATCH_MNT &
> > +			fpid=$!
> > +			wait $fpid
> 
> Ditto - why the background and wait?

same here.

> 
> > +			start=$(( $start + $step ))
> > +		done
> > +		sleep 1
> > +	done
> > +}
> > +
> > +function run_process() {
> > +	local p=$1
> > +	repeat=10
> > +
> > +	# Wait for all processes to start up.
> > +	if [ "$stagger" = "yes" ]; then
> > +	    sleep $((10*$p)) &
> > +		export chpid=$! && wait $chpid &> /dev/null
> > +		chpid=0
> > +	else
> > +	    sleep 10 &
> > +		export chpid=$! && wait $chpid &> /dev/null
> > +		chpid=0
> > +	fi
> 
> why bother with $stagger when itis only ever defined to "yes"?

sorry, there are some thing from the original script which I have
missed. I'll fix that.

> 
> Also, with 10 processes, that means it takes 100s just to start up?

Right after the 100s the last process (out of 10) will start.

> What's the typical runtime of this test?

Well, there is no "typical" since SSD's tend to behave quite differently
from vendor to vendor, but in my test it took at least 15 minutes.

> > +# Check for FITRIM support
> > +echo -n "Checking FITRIM support: "
> > +$here/src/fstrim -l 1G $SCRATCH_MNT
> > +[ $? -ne 0 ] && exit
> > +echo "done."
> 
> This should be a `_notrun "FITRIM not supported"` so the test
> doesn't actually count as a failure if the fs does not support
> FITRIM.

Good point.

Thanks for review Dave, I'll resend it as soon as I get the licence
confirmed.

-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
