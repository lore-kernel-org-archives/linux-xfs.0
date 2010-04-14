Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3ENjMLs109897 for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 18:45:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DA4712FCC25
	for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 16:47:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	cDcqJidr3bIGHJec for <xfs@oss.sgi.com>;
	Wed, 14 Apr 2010 16:47:16 -0700 (PDT)
Date: Thu, 15 Apr 2010 09:47:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext34_free_inode's mess
Message-ID: <20100414234713.GM2493@dastard>
References: <87pr2246y4.fsf@openvz.org>
 <4BC5E6CC.7030709@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BC5E6CC.7030709@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>, xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 14, 2010 at 11:01:16AM -0500, Eric Sandeen wrote:
> Dmitry Monakhov wrote:
> > I've finally automated my favorite testcase (see attachment), 
> > before i've run it by hand.
> 
> Thanks!  Feel free to cc: the xfs list since the patch hits
> xfstests.  (I added it here)
> 
> >  227     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  227.out |    5 +++
> >  group   |    1 +
> >  3 files changed, 111 insertions(+), 0 deletions(-)
> >  create mode 100755 227
> >  create mode 100644 227.out
> > 
> > diff --git a/227 b/227
> > new file mode 100755
> > index 0000000..d2b0c7d
> > --- /dev/null
> > +++ b/227
> > @@ -0,0 +1,105 @@
> > +#! /bin/bash
> > +# FS QA Test No. 227
> > +#
> > +# Perform fsstress test with parallel dd
> > +# This proven to be a good stress test
> > +# * Continuous dd retult in ENOSPC condition but only for a limited periods
> > +#   of time.
> > +# * Fsstress test cover many code paths
> 
> just little editor nitpicks: 
> 
> +# Perform fsstress test with parallel dd
> +# This is proven to be a good stress test
> +# * Continuous dd results in ENOSPC condition but only for a limited period
> +#   of time.
> +# * Fsstress test covers many code paths

This is close to the same as test 083:

# Exercise filesystem full behaviour - run numerous fsstress
# processes in write mode on a small filesystem.  NB: delayed
# allocate flushing is quite deadlock prone at the filesystem
# full boundary due to the fact that we will retry allocation
# several times after flushing, before giving back ENOSPC.

That test is not really doing anything XFS specific,
so could easily be modified to run on generic filesystems...

> > +
> > +    #Timing parameters
> > +    nr_iterations=5
> > +    kill_tries=20
> > +    echo Running fsstress. | tee -a $seq.full
> > +
> > +####################################################
> 
> What is all this for?
> 
> FWIW other fsstress tests use an $FSSTRESS_AVOID variable,
> where you can set the things you want to avoid easily
> 
> > +##    -f unresvsp=0 -f allocsp=0 -f freesp=0 \
> > +##    -f setxattr=0 -f attr_remove=0 -f attr_set=0 \
> > +## 
> > +######################################################
> > +    mkdir -p $SCRATCH_MNT/fsstress
> > +    # It is reasonable to disable sync, otherwise most of tasks will simply
> > +    # stuck in that sync() call.
> > +    $FSSTRESS_PROG \
> > +	-d $SCRATCH_MNT/fsstress \
> > +	-p 100 -f sync=0  -n 9999999 > /dev/null 2>&1 &
> > +
> > +    echo Running ENOSPC hitters. | tee -a $seq.full
> > +    for ((i = 0; i < $nr_iterations; i++))
> > +    do
> > +	#Open with O_TRUNC and then write until error
> > +	#hit ENOSPC each time.
> > +	dd if=/dev/zero of=$SCRATCH_MNT/BIG_FILE bs=1M 2> /dev/null
> > +    done

OK, so on a 10GB scratch device, this is going to write 50GB of
data, which at 100MB/s is going to take roughly 10 minutes.
The test should use a limited size filesystems (mkfs_scratch_sized)
to limit the runtime...

FWIW, test 083 spends most of it's runtime at or near ENOSPC, so
once again I wonder if that is not a better test to be using...

> > +workout
> > +umount $SCRATCH_MNT
> > +echo 
> > +echo Checking filesystem
> > +_check_scratch_fs

You don't need to check the scratch fs in the test - that is done by
the test harness after the test completes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
