Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KGekTX243850 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 11:40:46 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id qvvN7K66uxXBc3kl (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 09:40:44 -0700 (PDT)
Date: Mon, 20 Aug 2012 18:40:42 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfstests: Provide test whether fs supports direct IO
	and use it
Message-ID: <20120820164042.GB17354@quack.suse.cz>
References: <1345125391-15055-1-git-send-email-jack@suse.cz>
	<20120816230400.GZ2877@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120816230400.GZ2877@dastard>
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
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 17-08-12 09:04:00, Dave Chinner wrote:
> On Thu, Aug 16, 2012 at 03:56:31PM +0200, Jan Kara wrote:
> > ext3 in data=journal mode does not support direct IO. Tests which use
> > direct IO fail due to that. Provide function checking whether direct IO
> > is supported and skip tests needing direct IO if it's not.
> > 
> > There are a few tests which use direct IO but would be meaningful even
> > without it since they test several different things. Making these tests
> > useful for filesystems without dio support is left for future if somebody
> > is interested...
> 
> So this is just for the generic tests? There's a lot more XFS
> specific tests that require direct IO that aren't in this patch. ;)
  Right but I was a lazy bastard and went just through the tests that
failed for me, checked that they failed due to direct IO, and added the
requirement. I can go through the XFS specific tests and add the
requirement but frankly I find a little use in that.

> Also, I suspect that you've missed all the tests that run fsstress,
> because that uses direct IO as well. There's probably others as
> well. No doub they didn't produce test failures, but it's entirely
> possible that they are not testing what they are supposed to be
> testing as a result of direct IO failing silently...
  It's not failing silently. For ext3 we return EINVAL from open so I'd
expect reasonably written tests to complain.

> > --- a/198
> > +++ b/198
> > @@ -44,6 +44,7 @@ _cleanup()
> >  
> >  _supported_fs generic
> >  _supported_os Linux
> > +_require_direct_io
> >  _require_aiodio aiodio_sparse2
> 
> For all the tests are already call _require_aiodio, just embed the
> _require_dio test inside that one.
  OK, will do.

> > +#
> > +# Check if the filesystem supports direct IO
> > +#
> > +_require_direct_io()
> > +{
> > +	testfile=$TEST_DIR/$$.dio
> > +	testio=`$XFS_IO_PROG -F -f -d -c "" $testfile 2>&1`
> 
> This assumes that both the test device and the scratch device are
> both using the same mount options, right?
> 
> Some tests use the scratch device with different mount options, so
> may actually allow direct IO to work even though the test device
> fails. I haven't looked at whether any of the tests in this patch do
> that, but if they do then you might also need a _require_scratch_dio
> function for those tests....
  I went through all the changed tests and none of them seem to play tricks
with mount options so _require_direct_io should be fine for all of them.

  Thanks for review, I'll send a new version of the patch after a test run
finishes.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
