Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B76F29DF5
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 19:21:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A43C304043
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 17:21:55 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jIeyJmb759RUhSro for <xfs@oss.sgi.com>;
	Thu, 27 Aug 2015 17:21:52 -0700 (PDT)
Date: Fri, 28 Aug 2015 10:20:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: return errors from partial I/O failures to files
Message-ID: <20150828002028.GA26895@dastard>
References: <20150826190636.GA16540@rage.redhat.com>
	<20150826221951.GE3902@dastard> <55DF13A0.1090706@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55DF13A0.1090706@redhat.com>
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
To: David Jeffery <djeffery@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 27, 2015 at 09:41:52AM -0400, David Jeffery wrote:
> On 08/26/2015 06:19 PM, Dave Chinner wrote:
> >> index 3859f5e..b82b128 100644
> >> --- a/fs/xfs/xfs_aops.c
> >> +++ b/fs/xfs/xfs_aops.c
> >> @@ -356,7 +356,8 @@ xfs_end_bio(
> >>  {
> >>  	xfs_ioend_t		*ioend = bio->bi_private;
> >>  
> >> -	ioend->io_error = test_bit(BIO_UPTODATE, &bio->bi_flags) ? 0 : error;
> >> +	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> >> +		ioend->io_error = error;
> > 
> > We should preserve the original error that was reported, rather than
> > report the last one. ioend->io_error is always initialised to zero,
> > so we can simply do:
> 
> Is there a particular reason to prefer the first error?  Is it just
> standard practice?  I originally made a version which preserved the
> first error but couldn't think of a reason why the first or last would
> be best.  So I went with the patch which has the simpler if statement.

Standard practice in XFS - it's the first error that matters in most
cases. Subsequent errors are usually less meaningful as they are
either a result of the first error (i.e. cascading hardware errors),
tainted by the first error (e.g. first IO completion error shuts
down the fs, second IO completion error caused by the detection of a
shut down filesystem) or just unrelated noise....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
