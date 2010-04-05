Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35NcU9W030634 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 18:38:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBF851247CEA
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 16:40:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	LNulbX48jA22dczY for <xfs@oss.sgi.com>;
	Mon, 05 Apr 2010 16:40:19 -0700 (PDT)
Date: Tue, 6 Apr 2010 09:40:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] xfs: add log item recovery tracing
Message-ID: <20100405234016.GB11036@dastard>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
	<1270125691-29266-5-git-send-email-david@fromorbit.com>
	<20100403093638.GE20166@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100403093638.GE20166@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Apr 03, 2010 at 05:36:38AM -0400, Christoph Hellwig wrote:
> On Thu, Apr 01, 2010 at 11:41:27PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently there is no tracing in log recovery, so it is difficult to
> > determine what is going on when something goes wrong.
> > 
> > Add tracing for log item recovery to provide visibility into the log
> > recovery process. The tracing added shows regions being extracted
> > from the log transactions and added to the transaction hash forming
> > recovery items, followed by the reordering, cancelling and finally
> > recovery of the items.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_trace.c |    3 +
> >  fs/xfs/linux-2.6/xfs_trace.h |  147 ++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_buf_item.h        |    2 +-
> >  fs/xfs/xfs_log_recover.c     |   44 ++++++++++--
> >  4 files changed, 187 insertions(+), 9 deletions(-)
> > 
> 
> > +#define XFS_LOG_ITEM_TYPE \
> > +	{ 0x1236,	"XFS_LI_EFI" }, \
> > +	{ 0x1237,	"XFS_LI_EFD" }, \
> > +	{ 0x1238,	"XFS_LI_IUNLINK" }, \
> > +	{ 0x123b,	"XFS_LI_INODE" }, \
> > +	{ 0x123c,	"XFS_LI_BUF" }, \
> > +	{ 0x123d,	"XFS_LI_DQUOT" }, \
> > +	{ 0x123e,	"XFS_LI_QUOTAOFF" }
> 
> For the other trace events I kept these close to the defintion
> of these flags. 

np, I'll move it.

> Is there a good reason you use the numerical
> and not hte symbolic names on the left side?

Brain fart. I'll fix it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
