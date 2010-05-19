Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JMd0KA159772 for <xfs@oss.sgi.com>; Wed, 19 May 2010 17:39:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D381E1B0E6DB
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 15:41:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	Vvy7k8riiXNXpk2p for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 15:41:17 -0700 (PDT)
Date: Thu, 20 May 2010 08:41:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/12] xfs: clean up log ticket overrun debug output
Message-ID: <20100519224114.GP8120@dastard>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
	<1274138668-1662-6-git-send-email-david@fromorbit.com>
	<1274296604.2140.55.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274296604.2140.55.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, May 19, 2010 at 02:16:44PM -0500, Alex Elder wrote:
> On Tue, 2010-05-18 at 09:24 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Push the error message output when a ticket overrun is detected
> > into the ticket printing functions. Also remove the debug version
> > of the code as the production version will still panic just as
> > effectively on a debug kernel via the panic mask being set.
> 
> Another not-really-actionable bit of commentary
> below, but this looks good.
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_error.c |    2 +-
> >  fs/xfs/xfs_log.c   |   19 +++++--------------
> >  2 files changed, 6 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index ef96175..047b8a8 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -170,7 +170,7 @@ xfs_cmn_err(int panic_tag, int level, xfs_mount_t *mp, char *fmt, ...)
> >  	va_list ap;
> >  
> >  #ifdef DEBUG
> > -	xfs_panic_mask |= XFS_PTAG_SHUTDOWN_CORRUPT;
> > +	xfs_panic_mask |= (XFS_PTAG_SHUTDOWN_CORRUPT | XFS_PTAG_LOGRES);
> >  #endif
> >  
> >  	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 83be6a6..1efb303 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1645,6 +1645,10 @@ xlog_print_tic_res(xfs_mount_t *mp, xlog_ticket_t *ticket)
> >  			    "bad-rtype" : res_type_str[r_type-1]),
> >  			    ticket->t_res_arr[i].r_len);
> >  	}
> > +
> > +	xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, mp,
> > +		"xfs_log_write: reservation ran out. Need to up reservation");
> > +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> >  }
> >  
> >  /*
> > @@ -1897,21 +1901,8 @@ xlog_write(
> >  	*start_lsn = 0;
> >  
> >  	len = xlog_write_calc_vec_length(ticket, log_vector);
> > -	if (ticket->t_curr_res < len) {
> > +	if (ticket->t_curr_res < len)
> >  		xlog_print_tic_res(log->l_mp, ticket);
> 
> Somehow "xlog_print_tic_res" doesn't suggest to me
> that we're going to panic at this point, and I think
> therefore that bit of information is lost with this
> change.

Normally it won't panic - if there is a problem it will shut down
the filesystem. Only if the kernel is a debug kernel or the admin
has specifically set the panic mask to panic on this failure
will there be a panic.

If we start to document every place where there is in shutdown or
panic inside a function call that is not documented at eh function
call site, we won't be able to see the code for the "this might
panic" comments. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
