Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2231l0245632 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 20:03:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7471A1C851FE
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 18:04:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	QE2qd7gdZnmAbtmS for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 18:04:44 -0800 (PST)
Date: Thu, 2 Dec 2010 13:04:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/14] xfs: convert log grant heads to atomic variables
Message-ID: <20101202020441.GS16922@dastard>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-9-git-send-email-david@fromorbit.com>
	<20101201125920.GF612@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201125920.GF612@infradead.org>
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

On Wed, Dec 01, 2010 at 07:59:20AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 29, 2010 at 12:38:26PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Convert the log grant heads to atomic64_t types in preparation for
> > converting the accounting algorithms to atomic operations. his patch
> > just converts the variables; the algorithmic changes are in a
> > separate patch for clarity.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_trace.h |   18 +++++++------
> >  fs/xfs/xfs_log.c             |   54 +++++++++++++++++++++--------------------
> >  fs/xfs/xfs_log_priv.h        |    4 +-
> >  fs/xfs/xfs_log_recover.c     |    8 +++---
> >  4 files changed, 44 insertions(+), 40 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
> > index d2cdc85..68c3bdd 100644
> > --- a/fs/xfs/linux-2.6/xfs_trace.h
> > +++ b/fs/xfs/linux-2.6/xfs_trace.h
> > @@ -768,8 +768,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
> >  		__field(unsigned int, flags)
> >  		__field(void *, reserveq)
> >  		__field(void *, writeq)
> > -		__field(xfs_lsn_t, grant_reserve_lsn)
> > -		__field(xfs_lsn_t, grant_write_lsn)
> > +		__field(xfs_lsn_t, grant_reserve_head)
> > +		__field(xfs_lsn_t, grant_write_head)
> 
> What about just naming them _head from the beginning?  That would
> be a tad cleaner.  Same for the actual variables in the log, even
> if they change the type here.

Will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
