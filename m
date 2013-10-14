Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 756227F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:36:24 -0500 (CDT)
Date: Mon, 14 Oct 2013 15:36:23 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: prevent deadlock trying to cover an active log
Message-ID: <20131014203623.GW10553@sgi.com>
References: <1381278703-23439-1-git-send-email-david@fromorbit.com>
	<52577337.2090901@sandeen.net> <20131014200422.GA1935@sgi.com>
	<20131014202234.GO4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131014202234.GO4446@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Oct 15, 2013 at 07:22:34AM +1100, Dave Chinner wrote:
> On Mon, Oct 14, 2013 at 03:04:22PM -0500, Ben Myers wrote:
> > Hey Fellas,
> > > > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > > > index 136654b..de24ffb 100644
> > > > --- a/fs/xfs/xfs_log_priv.h
> > > > +++ b/fs/xfs/xfs_log_priv.h
> > > > @@ -514,12 +514,10 @@ xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
> > > >  /*
> > > >   * Committed Item List interfaces
> > > >   */
> > > > -int
> > > > -xlog_cil_init(struct xlog *log);
> > > > -void
> > > > -xlog_cil_init_post_recovery(struct xlog *log);
> > > > -void
> > > > -xlog_cil_destroy(struct xlog *log);
> > > > +int	xlog_cil_init(struct xlog *log);
> > > > +void	xlog_cil_init_post_recovery(struct xlog *log);
> > > > +void	xlog_cil_destroy(struct xlog *log);
> > > > +bool	xlog_cil_empty(struct xlog *log)
> > 
> > Huh.  Looks like we're short a semicolon here.  I can add one, unless you
> > prefer to repost?
> 
> \o/
> 
> Someone finally noticed I sent a broken patch.
> 
> I forgot to refresh the commit before I sent it, so this was fixed
> before I even posted it. :/
> 
> Current version of the patch is below.

We'll take this one then.  ;)

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
