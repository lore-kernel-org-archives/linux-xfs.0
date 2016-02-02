Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4282A7CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 23:16:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 28E148F8033
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 21:16:49 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PIDtZiVweq7SOvQm for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 21:16:42 -0800 (PST)
Date: Tue, 2 Feb 2016 16:16:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs_io: print dedupe errors to stderr, not stdout
Message-ID: <20160202051628.GC32032@dastard>
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
	<20160123003531.2475.59752.stgit@birch.djwong.org>
	<20160202051410.GB32032@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160202051410.GB32032@dastard>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 02, 2016 at 04:14:10PM +1100, Dave Chinner wrote:
> On Fri, Jan 22, 2016 at 04:35:31PM -0800, Darrick J. Wong wrote:
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  io/reflink.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/io/reflink.c b/io/reflink.c
> > index def01be..a09e82d 100644
> > --- a/io/reflink.c
> > +++ b/io/reflink.c
> > @@ -78,11 +78,13 @@ dedupe_ioctl(
> >  			goto done;
> >  		}
> >  		if (info->status < 0) {
> > -			printf("dedupe: %s\n", _(strerror(-info->status)));
> > +			fprintf(stderr, "dedupe: %s\n",
> > +					_(strerror(-info->status)));
> >  			goto done;
> >  		}
> >  		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
> > -			printf(_("Extents did not match.\n"));
> > +			fprintf(stderr, "dedupe: %s\n",
> > +					_("Extents did not match."));
> >  			goto done;
> >  		}
> >  		if (args->length != 0 &&
> 
> I think this patch breaks dedupe detection in xfstests. I see the
> dedupe tests running instead of being detected as not supported, and
> all the diffs from test failures contain:
> 
>     +dedupe: Invalid argument
> 
> This is on 4.5-rc2, so I suspect it's not returning the expected
> "not supported" error to xfstests from the ioctl.

Oh, never mind. I just found the xfstests patches Christoph sent to
the wrong list that will fix this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
