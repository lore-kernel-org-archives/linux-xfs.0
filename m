Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99N48uw121466 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 18:04:08 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gEED1rgiHhNXUv8v for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 16:05:38 -0700 (PDT)
Date: Wed, 10 Oct 2012 10:05:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs_io: configure tests for preadv/pwritev &
	sync_file_range
Message-ID: <20121009230536.GV23644@dastard>
References: <50749EE2.6070408@redhat.com> <5074A05A.6000709@sandeen.net>
	<20121009222806.GS23644@dastard> <5074A5FE.50101@sandeen.net>
	<20121009225620.GU23644@dastard> <5074ABF4.2000807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5074ABF4.2000807@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 09, 2012 at 05:57:56PM -0500, Eric Sandeen wrote:
> On 10/9/12 5:56 PM, Dave Chinner wrote:
> > On Tue, Oct 09, 2012 at 05:32:30PM -0500, Eric Sandeen wrote:
> >> On 10/9/12 5:28 PM, Dave Chinner wrote:
> >>> On Tue, Oct 09, 2012 at 05:08:26PM -0500, Eric Sandeen wrote:
> >>>> On older systems we may not have preadv/pwritev and/or
> >>>> sync_file_range.
> >>>>
> >>>> Add the configure magic, and stub out the code
> >>>> where needed.
> >>>>
> >>>> (sync_file_range just needed a better test; preadv/pwritev
> >>>> took a little more rearranging)
> >>>>
> >>>> And fix a couple typos ("numberic") while we're at it.
> >>>>
> >>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>>
> >>> Looks fine, though the "HAVE_PREADV" in the pwritev case is a bit
> >>> wierd. Perhaps doing this:
> >>>
> >>>> diff --git a/include/builddefs.in b/include/builddefs.in
> >>>> index 81ebfcd..4a0e910 100644
> >>>> --- a/include/builddefs.in
> >>>> +++ b/include/builddefs.in
> >>>> @@ -101,6 +101,8 @@ HAVE_GETMNTENT = @have_getmntent@
> >>>>  HAVE_GETMNTINFO = @have_getmntinfo@
> >>>>  HAVE_FALLOCATE = @have_fallocate@
> >>>>  HAVE_FIEMAP = @have_fiemap@
> >>>> +HAVE_PREADV = @have_preadv@
> >>>
> >>> HAVE_PWRITEV = @have_preadv@
> >>>
> >>> Would reduce that wierdness a bit when looking at the pwritev
> >>> code....
> >>
> >> Yeah I was a little unhappy w/ that.  But I think then we'd also need:
> >>
> >> +ifeq ($(HAVE_PWRITEV),yes)
> >> +LCFLAGS += -DHAVE_PWRITEV
> >> +endif
> > 
> > True.
> > 
> >> and at some point we might run out of room on the cmdline ;)
> > 
> > Unlikely ;)
> > 
> >> Could change it to HAVE_PREADWRITEV or something ...
> > 
> > HAVE_VECTORED_IO?
> 
> Thought about that but we already have readv/writev, just not *P*readv/writev.

xfs_io doesn't use readv/writev, so I don't think it' a major
concern.

Red, green, blue, the colour of the bike shed  really doesn't matter
that much....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
