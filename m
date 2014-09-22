Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C5447F50
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 14:40:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8EC28AC001
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 12:40:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FZYHPO52QwGo7ZEl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 12:40:29 -0700 (PDT)
Date: Mon, 22 Sep 2014 15:40:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs/062: add xfs unwritten extent data corruption
	reproducer
Message-ID: <20140922194018.GA39580@bfoster.bfoster>
References: <1411150385-32121-1-git-send-email-bfoster@redhat.com>
	<20140920234500.GK4267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140920234500.GK4267@dastard>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Sun, Sep 21, 2014 at 09:45:00AM +1000, Dave Chinner wrote:
> On Fri, Sep 19, 2014 at 02:13:05PM -0400, Brian Foster wrote:
> > XFS had a data corruption problem where writeback of pages to unwritten
> > extents would fail to run unwritten extent conversion at I/O completion.
> > This causes subsequent reads of written, but unconverted regions to
> > return zeroes. This occurs on sub-page block size filesystems when
> > writeback contends for the inode lock (e.g., with a file writer).
> > 
> > Add a test that creates the conditions to reproduce the data corruption
> > and detect it by looking for unwritten extents after all said extents
> > have been overwritten.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > Here's a test for the data corruption issue I sent a fix for yesterday:
> > 
> > 	http://oss.sgi.com/archives/xfs/2014-09/msg00259.html
> > 
> > It took a little time to improve the effectiveness of the test, but I've
> > been able to run it in current form for 90+ iterations without a false
> > negative (e.g., test passes when it shouldn't) on my setup. It runs in
> > ~30s when there is no failure.
> > 
> > Brian
> > 
> >  tests/xfs/062     | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/062.out |   5 +++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 120 insertions(+)
> >  create mode 100755 tests/xfs/062
> >  create mode 100644 tests/xfs/062.out
> 
> There's nothing XFS specific about this test. Yes, it exposes a bug
> on XFS, but every filesystem should be able to run and pass this
> test.
> 

Indeed, converted to a generic test.

> > 
> > diff --git a/tests/xfs/062 b/tests/xfs/062
> > new file mode 100755
> > index 0000000..61f8cf4
> > --- /dev/null
> > +++ b/tests/xfs/062
...
> > +	if [ $? == 0 ]
> > +	then
> > +		xfs_bmap -v $SCRATCH_MNT/file
> > +		break
> > +	fi
> 
> 	if [...]; then.
> 
> That's also a failure, right? So shouldn't it set status=1 and exit,
> leaving the cleanup function to kill and wait for everything to
> finish?
> 

It's the main/expected failure. The intent was to use the hexdump as the
determination for success/failure, but I had to determine when to break
out of the loop since the reproducer requires several iterations. I
figured the raw extent map output would be useful (the output of which
also calls out something is wrong when compared to the golden output) as
well as the content diff, so both are printed in the failure case.

I've added an additional comment here for the v2 I'm about to post. I
can just dump the extent map here and exit with status=1 if that is
preferred, but it seems appropriate to include the hexdump in the
failure scenario as well.

Brian

> > +done
> > +
> > +echo $iters iterations
> > +
> > +kill $syncpid
> > +wait
> > +
> > +# clear page cache and dump the file
> > +_scratch_unmount
> > +_scratch_mount
> 
> _scratch_remount
> 
> > +hexdump $SCRATCH_MNT/file
> > +
> > +_scratch_unmount
> > +_check_scratch_fs
> 
> Don't need to do that anymore.
> 
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/062.out b/tests/xfs/062.out
> > new file mode 100644
> > index 0000000..420f2e4
> > --- /dev/null
> > +++ b/tests/xfs/062.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 062
> > +100 iterations
> > +0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> > +*
> > +0100000
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 09bce15..685cbe7 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -57,6 +57,7 @@
> >  059 dump ioctl auto quick
> >  060 dump ioctl auto quick
> >  061 dump ioctl auto quick
> > +062 auto quick
> 
> and the rw group, too.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
