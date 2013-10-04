Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A7D1E7F53
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 19:49:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42EB6AC006
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 17:49:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	hJYw0J8KvTLAYNo7 for <xfs@oss.sgi.com>;
	Thu, 03 Oct 2013 17:49:54 -0700 (PDT)
Date: Fri, 4 Oct 2013 10:49:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/16] xfs: decouple log and transaction headers
Message-ID: <20131004004952.GC4446@dastard>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
	<1380510433-8353-5-git-send-email-david@fromorbit.com>
	<20131003145650.GD10316@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131003145650.GD10316@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Oct 03, 2013 at 07:56:50AM -0700, Christoph Hellwig wrote:
> > @@ -33,16 +33,6 @@ struct xfs_log_vec {
> >  #define XFS_LOG_VEC_ORDERED	(-1)
> >  
> >  /*
> > - * Structure used to pass callback function and the function's argument
> > - * to the log manager.
> > - */
> > -typedef struct xfs_log_callback {
> > -	struct xfs_log_callback	*cb_next;
> > -	void			(*cb_func)(void *, int);
> > -	void			*cb_arg;
> > -} xfs_log_callback_t;
> > -
> > -/*
> 
> Looking at the code I don't think this one needs to be moved as the
> t_logcb field in struct xfs_trans is dead already.  Just remove it in
> a separate patch and this declaration can stay where it is.

Ok, I debated whether to just remove the t_logcb fields, and decided
just to move the declaration on the toss of a coin. I'll just remove
it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
