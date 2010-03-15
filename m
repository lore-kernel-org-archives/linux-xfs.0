Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F2CQUN003148 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:12:27 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19ECA24032F
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 19:13:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	Va71TXSSKJXz2SvF for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 19:13:58 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	17005183-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 12:43:56 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1NqzoY-000133-SR
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:13:54 +1100
Date: Mon, 15 Mar 2010 13:13:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/9] xfs: log ticket reservation underestimates the
	number of iclogs
Message-ID: <20100315021354.GJ4732@dastard>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
	<1267840284-4652-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267840284-4652-8-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

Ping?

On Sat, Mar 06, 2010 at 12:51:22PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When allocation a ticket for a transaction, the ticket is initialised with the
> worst case log space usage based on the number of bytes the transaction may
> consume. Part of this calculation is the number of log headers required for the
> iclog space used up by the transaction.
> 
> This calculation makes an undocumented assumption that if the transaction uses
> the log header space reservation on an iclog, then it consumes either the
> entire iclog or it completes. That is - the transaction that is first in an
> iclog is the transaction that the log header reservation is accounted to. If
> the transaction is larger than the iclog, then it will use the entire iclog
> itself. Document this assumption.
> 
> Further, the current calculation uses the rule that we can fit iclog_size bytes
> of transaction data into an iclog. This is in correct - the amount of space
> available in an iclog for transaction data is the size of the iclog minus the
> space used for log record headers. This means that the calculation is out by
> 512 bytes per 32k of log space the transaction can consume. This is rarely an
> issue because maximally sized transactions are extremely uncommon, and for 4k
> block size filesystems maximal transaction reservations are about 400kb. Hence
> the error in this case is less than the size of an iclog, so that makes it even
> harder to hit.
> 
> However, anyone using larger directory blocks (16k directory blocks push the
> maximum transaction size to approx. 900k on a 4k block size filesystem) or
> larger block size (e.g. 64k blocks push transactions to the 3-4MB size) could
> see the error grow to more than an iclog and at this point the transaction is
> guaranteed to get a reservation underrun and shutdown the filesystem.
> 
> Fix this by adjusting the calculation to calculate the correct number of iclogs
> required and account for them all up front.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c |   55 +++++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 42 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 1f26a97..7c6b0cd 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -664,7 +664,10 @@ xfs_log_item_init(
>  /*
>   * Write region vectors to log.  The write happens using the space reservation
>   * of the ticket (tic).  It is not a requirement that all writes for a given
> - * transaction occur with one call to xfs_log_write().
> + * transaction occur with one call to xfs_log_write(). However, it is important
> + * to note that the transaction reservation code makes an assumption about the
> + * number of log headers a transaction requires that may be violated if you
> + * don't pass all the transaction vectors in one call....
>   */
>  int
>  xfs_log_write(
> @@ -3156,14 +3159,16 @@ xfs_log_ticket_get(
>   * Allocate and initialise a new log ticket.
>   */
>  STATIC xlog_ticket_t *
> -xlog_ticket_alloc(xlog_t		*log,
> -		int		unit_bytes,
> -		int		cnt,
> -		char		client,
> -		uint		xflags)
> +xlog_ticket_alloc(
> +	struct log	*log,
> +	int		unit_bytes,
> +	int		cnt,
> +	char		client,
> +	uint		xflags)
>  {
> -	xlog_ticket_t	*tic;
> +	struct xlog_ticket *tic;
>  	uint		num_headers;
> +	int		iclog_space;
>  
>  	tic = kmem_zone_zalloc(xfs_log_ticket_zone, KM_SLEEP|KM_MAYFAIL);
>  	if (!tic)
> @@ -3207,16 +3212,40 @@ xlog_ticket_alloc(xlog_t		*log,
>  	/* for start-rec */
>  	unit_bytes += sizeof(xlog_op_header_t);
>  
> -	/* for LR headers */
> -	num_headers = ((unit_bytes + log->l_iclog_size-1) >> log->l_iclog_size_log);
> +	/*
> +	 * for LR headers - the space for data in an iclog is the size minus
> +	 * the space used for the headers. If we use the iclog size, then we
> +	 * undercalculate the number of headers required.
> +	 *
> +	 * Furthermore - the addition of op headers for split-recs might
> +	 * increase the space required enough to require more log and op
> +	 * headers, so take that into account too.
> +	 *
> +	 * IMPORTANT: This reservation makes the assumption that if this
> +	 * transaction is the first in an iclog and hence has the LR headers
> +	 * accounted to it, then the remaining space in the iclog is
> +	 * exclusively for this transaction.  i.e. if the transaction is larger
> +	 * than the iclog, it will be the only thing in that iclog.
> +	 * Fundamentally, this means we must pass the entire log vector to
> +	 * xlog_write to guarantee this.
> +	 */
> +	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> +	num_headers = (unit_bytes + iclog_space - 1) / iclog_space;
> +
> +	/* for split-recs - ophdrs added when data split over LRs */
> +	unit_bytes += sizeof(xlog_op_header_t) * num_headers;
> +
> +	/* add extra header reservations if we overrun */
> +	while (!num_headers ||
> +	       ((unit_bytes + iclog_space - 1) / iclog_space) > num_headers) {
> +		unit_bytes += sizeof(xlog_op_header_t);
> +		num_headers++;
> +	}
>  	unit_bytes += log->l_iclog_hsize * num_headers;
>  
>  	/* for commit-rec LR header - note: padding will subsume the ophdr */
>  	unit_bytes += log->l_iclog_hsize;
>  
> -	/* for split-recs - ophdrs added when data split over LRs */
> -	unit_bytes += sizeof(xlog_op_header_t) * num_headers;
> -
>  	/* for roundoff padding for transaction data and one for commit record */
>  	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
>  	    log->l_mp->m_sb.sb_logsunit > 1) {
> @@ -3238,7 +3267,7 @@ xlog_ticket_alloc(xlog_t		*log,
>  	tic->t_trans_type	= 0;
>  	if (xflags & XFS_LOG_PERM_RESERV)
>  		tic->t_flags |= XLOG_TIC_PERM_RESERV;
> -	sv_init(&(tic->t_wait), SV_DEFAULT, "logtick");
> +	sv_init(&tic->t_wait, SV_DEFAULT, "logtick");
>  
>  	xlog_tic_reset_res(tic);
>  
> -- 
> 1.6.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
