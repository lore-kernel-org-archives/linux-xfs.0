Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9FNlUX9001108 for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 18:47:30 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tZEfApC93lOrj7zD for <xfs@oss.sgi.com>;
	Mon, 15 Oct 2012 16:49:05 -0700 (PDT)
Date: Tue, 16 Oct 2012 10:49:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
Message-ID: <20121015234902.GH2739@dastard>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-7-git-send-email-bfoster@redhat.com>
	<20121011141335.GY13214@sgi.com> <507749A2.4020206@redhat.com>
	<20121015224626.GU24986@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121015224626.GU24986@sgi.com>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Oct 15, 2012 at 05:46:26PM -0500, Ben Myers wrote:
> Hey Brian,
> 
> On Thu, Oct 11, 2012 at 06:35:14PM -0400, Brian Foster wrote:
> > On 10/11/2012 10:13 AM, Ben Myers wrote:
> > > Hey Brian,
> > > 
> > > On Fri, Oct 05, 2012 at 10:17:12AM -0400, Brian Foster wrote:
> > >> The XFS_IOC_FREE_EOFBLOCKS ioctl allows users to invoke an EOFBLOCKS
> > >> scan. The xfs_eofblocks structure is defined to support the command
> > >> parameters (scan mode).
> > > 
> > > It would help to have an xfstest to exercise this ioctl to pull in with this
> > > series.  Do you have any code that could be wrangled into a test case?
> > > 
> > 
> > Yes, makes sense. I have some very basic test code I could put somewhere
> > to invoke the ioctl(). One of the questions I've been meaning to ask is
> > whether it would be relevant for that code to live in a common tool,
> > such as adding a new command to xfs_io. Then perhaps create an xfstests
> > test using that. Thoughts?
> 
> IMO you are right on the mark.  xfs_io is a great place for this.
> 
> > FYI, I have a few other things on my plate at the moment so
> > unfortunately it will be a bit before I can get back to XFS work... But
> > I'm fine with the set pending until I can come up with some test
> > coverage if that is preferable, of course.
> 
> I do think it is preferable to have a test case go in with the code where
> possible.  Since you don't mind waiting a bit, that seems to be the way to go.
> The other option could be to look for a volunteer to work on the test.  ;)

FWIW, given the background cleanup code can be trivially verified to
work (open, apend, close, repeat, wait 5 minutes) and is the
functionality that is needed in mainline, having something to test
the ioctls should not stop the patchset from being merged.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
