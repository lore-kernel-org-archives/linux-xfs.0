Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2N1iBK197612 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 18:01:44 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	l4VDTzk6D6Dkx615 for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 16:03:36 -0700 (PDT)
Date: Sat, 3 Nov 2012 10:03:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: status of userspace release
Message-ID: <20121102230334.GA29378@dastard>
References: <20121025151501.GV1377@sgi.com> <20121102055102.GY29378@dastard>
	<20121102185923.GG9783@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121102185923.GG9783@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 02, 2012 at 01:59:23PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Fri, Nov 02, 2012 at 04:51:02PM +1100, Dave Chinner wrote:
> > On Thu, Oct 25, 2012 at 10:15:01AM -0500, Ben Myers wrote:
> > > Hi Folks,
> > > 
> > > We're working toward a userspace release this month.  There are several patches
> > > that need to go in first, including backing out the xfsdump format version bump
> > > from Eric, fixes for the makefiles from Mike, and the Polish language update
> > > for xfsdump from Jakub.  If anyone knows of something else we need, now is the
> > > time to flame about it.  I will take a look around for other important patches
> > > too.
> > > 
> > > This time I'm going to tag an -rc1 (probably later today or tomorrow).  We'll
> > > give everyone a few working days to do a final test and/or pipe up if we have
> > > missed something important.  Then if all goes well we'll cut the release next
> > > Tuesday.
> > 
> > I think that dump/restore need more work/testing.
> 
> Sounds good.  AFAIK there is no blazing hurry to release immediately.

Agreed. better to get it right ;)

> > Running some large filesystem testing, however, I see more problems.
> > I'm using a 17TB filesytsem and the --largefs patch series. This
> > results in a futex hang in 059 like so:
....
> > I can't reliably reproduce it at this point, but there does appear
> > to be some kind of locking problem in the multistream support.
> 
> One of my machines hit this overnight without --largefs.  I wasn't able to get
> a dump though.  Just another data point.

Ok, that's good to know it is directly related to the largefs
testing I'm doing.

> > Speaking of which, most large filesystems dump/restore tests are
> > failing because of this output:
> > 
> > 026 20s ... - output mismatch (see 026.out.bad)
> > --- 026.out     2012-10-05 11:37:51.000000000 +1000
> > +++ 026.out.bad 2012-11-02 16:20:17.000000000 +1100
> > @@ -20,6 +20,7 @@
> >  xfsdump: media file size NUM bytes
> >  xfsdump: dump size (non-dir files) : NUM bytes
> >  xfsdump: dump complete: SECS seconds elapsed
> > +xfsdump:   stream 0 DUMP_FILE OK (success)
> >  xfsdump: Dump Status: SUCCESS
> >  Restoring from file...
> >  xfsrestore  -f DUMP_FILE  -L stress_026 RESTORE_DIR
> > @@ -32,6 +33,7 @@
> >  xfsrestore: directory post-processing
> >  xfsrestore: restoring non-directory files
> >  xfsrestore: restore complete: SECS seconds elapsed
> > +xfsrestore:   stream 0 DUMP_FILE OK (success)
> >  xfsrestore: Restore Status: SUCCESS
> >  Comparing dump directory with restore directory
> >  Files DUMP_DIR/big and RESTORE_DIR/DUMP_SUBDIR/big are identical
> > 
> > Which looks like output from the multistream code. Why it is
> > emitting this for large filesystem testing and not for small
> > filesystems, I'm not sure yet. 
....
> Rich also reported some golden output related changes with --largefs awhile
> back.  I don't think he saw this one though.

No, this one is new, caused by upgrading xfsdump. As it turns out,
the previous version of xfsdump on this particular VM was from
before the multistream dump was implemented - it was a distro
package rather than one I'd custom built.

And, as it is, I just removed the --large-fs config (so my scratch
device is just an empty 17TB device) and I still get this extra
output. So it's not related to the --large-fs behaviour at all.

> The TODO list for userspace release currently stands at:
> 
> 1) fix the header checksum failures... which is resolved
> 2) fix a futex hang in 059
> 3) fix the golden output changes related to multistream support in xfsdump
>    and --largefs

Well, understand them first, then fix ;)

> 4) test on more platforms

I suspect that the futex hang is only going to be solvable if it can
be reliably reproduced. I haven't seen it again since the hang I
reported. Otherwise, sounds good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
