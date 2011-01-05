Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p051pmYp074246 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 19:51:48 -0600
Subject: Re: [PATCH 0/8] xfs: prevent corruption due to overlapping AIO DIO V2
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294116518-14908-1-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
Date: Tue, 04 Jan 2011 19:53:52 -0600
Message-ID: <1294192432.2485.717.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Tue, 2011-01-04 at 15:48 +1100, Dave Chinner wrote:
> This series aims to serialise unaligned direct IOs to an inode to
> avoid corruption caused by sub-block zeroing races. The previous
> approaches at the direct IO layer fail because for !DIO_LOCKING
> filesystems like XFS, there is no way we can track and serialise all
> the direct IOs to a given inode in a race free manner. While we can
> track them, we cannot close the races between mapping blocks and
> tracked IO completion occuring before subsequent tracking lookups
> without adding some kind of locking to the DIO layer. Hence for
> !DIO_LOCKING users, unaligned direct IO needs to be serialised at a
> higher layer.
> 
> Because the xfs_file_aio_write() path is so twisted and difficult to
> follow, adding new locking cases to the code is difficult to verify
> that it is correct in all cases. Hence the series starts by cleaning
> up the code and splitting apart the direct IO and buffered IO paths
> before adding the unaligned direct IO detection and serialisation.
> 
> The first patch fixes a sync write error handling bug - we should
> consider pushing that to .38. The next patches factor code that is
> common to write and splice into helpers. The direct and buffered IO
> paths are then separated out and the common write checks and bounds
> limiting is factored out into a helper.
> 
> Finally, the serialisation of unaligned direct IOs is added by a
> big-hammer approach. That is, we take the i_mutex and
> XFS_IOLOCK_EXCL and hold them across the unaligned IO submission.
> This means that unaligned direct IO submission is serialised, and
> non-AIO DIO is serialised completely.
> 
> For unaligned AIO DIO, this would only serialise the submission of
> the DIO, leaving the sub-block zeroing races open for unaligned
> writes into unwritten extents. To avoid this problem, we use
> xfs_ioend_wait() to ensure all AIO writes have completed before we
> submit the unaligned write. We do this wait holding the i_mutex so
> we serialise against other unaligned AIO as there is no need to
> serialise against aligned DIO.
> 
> Version 2:
> - fix initial sync write error return fixup
> - add new patch to abstract locking from read/write path and remove
>   the need for the need_i_mutex variable.
> 

I've reviewed this series, and the net result (the
code cleanup leading to the real fix in particular)
is great.

There are some small things among the patches that
ought to be fixed in order to allow them to stand
alone without bugs (to facilitate git bisects, for
example).  I've noted them in my reviews.

I also think that, having looked over them entirely,
a few of my earlier comments get addressed or made
non-applicable because of your changes.  I'm not
going to go fix them now; if you see things like
that you can explain if you feel it's useful or
just mention that the series renders my comment
inoperative or something.

					-Alex



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
