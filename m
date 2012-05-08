Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48Mgc4S034895 for <xfs@oss.sgi.com>; Tue, 8 May 2012 17:42:38 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ud3SHOwLbQcAAI7F for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 15:42:37 -0700 (PDT)
Date: Wed, 9 May 2012 08:42:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: prevent needless mount warning causing test
	failures
Message-ID: <20120508224224.GJ5091@dastard>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
	<1335519922-14371-4-git-send-email-david@fromorbit.com>
	<20120508162942.GK16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120508162942.GK16881@sgi.com>
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

On Tue, May 08, 2012 at 11:29:42AM -0500, Ben Myers wrote:
> On Fri, Apr 27, 2012 at 07:45:22PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Often mounting small filesystem with small logs will emit a warning
> > such as:
> > 
> > XFS (vdb): Invalid block length (0x2000) for buffer
> > 
> > during log recovery. This causes tests to randomly fail because this
> > output causes the clean filesystem checks on test completion to
> > think the filesystem is inconsistent.
> > 
> > The cause of the error is simply that log recovery is asking for a
> > buffer size that is larger than the log when zeroing the tail. This
> > is because the buffer size is rounded up, and if the right head and
> > tail conditions exist then the buffer size can be larger than the log.
> > Limit the variable size xlog_get_bp() callers to requesting buffers
> > smaller than the log.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_recover.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index d7abe5f..ca38690 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -441,6 +441,8 @@ xlog_find_verify_cycle(
> >  	 * a log sector, or we're out of luck.
> >  	 */
> >  	bufblks = 1 << ffs(nbblks);
> > +	while (bufblks > log->l_logBBsize)
> > +		bufblks >>= 1;
> 
> AFAICS you don't need a loop here.  The following would be sufficient to make
> xlog_buf_bbcount_valid return 0. 
> 
> if (bufblks > log->l_logBBsize)
> 	bufblks = log->l_logBBsize;

Yes, I could do that, but then there is a different set of boundary
conditions to test. I know that the >>=1 logic works, but I have no
idea what new corner cases occur when bufblks == log->l_logBBsize.

> It is a bit more obviously correct.

It may be to read, but it's certainly more different from a
verification point of view. Given how long and arduous the process
was to find the source of the problem, I am very wary of changing
logic to run in ways that are different and very difficult to
actually test....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
