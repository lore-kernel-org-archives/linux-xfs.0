Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1IjVF177924 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0030FE474F
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:38 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	u0E6sDaXqySJbPb0 for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:38 -0700 (PDT)
Date: Mon, 12 Apr 2010 17:29:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 10/10] xfs: track the log sector size rather than
	log2(that)
Message-ID: <20100412072919.GL2493@dastard>
References: <1271048070.3174.125.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271048070.3174.125.camel@doink>
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

On Sun, Apr 11, 2010 at 11:54:30PM -0500, Alex Elder wrote:
> Change struct log so it keeps track of the size (in basic blocks)
> of a log sector in l_sectsize rather than the log-base-2 of that
> value (previously, l_sectbb_log).
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

OK, this is what I commented on earlier....

> @@ -1050,29 +1051,31 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  
>  	error = EFSCORRUPTED;
>  	if (xfs_sb_version_hassector(&mp->m_sb)) {
> -		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
> -		if (log->l_sectbb_log < 0 ||
> -		    log->l_sectbb_log > mp->m_sectbb_log) {
> -			xlog_warn("XFS: Log sector size (0x%x) out of range.",
> -						log->l_sectbb_log);
> +	        sector_bits = mp->m_sb.sb_logsectlog;
> +		if (sector_bits < BBSHIFT) {
> +			xlog_warn("XFS: Log sector byte size too small "
> +				"(0x%x < 0x%x)", sector_bits, BBSHIFT);

"sector_bits"?  That doesn't seem to fit the units the log sector
size being read from and checked against. i.e. it's not bits, nor is
it bytes (as the error message says). It's really log2(sector size),
so perhaps calling it sector_size_log would be more accurate.

>  			goto out_free_log;
>  		}
>  
> -		/* for larger sector sizes, must have v2 or external log */
> -		if (log->l_sectbb_log != 0 &&
> -		    (log->l_logBBstart != 0 &&
> -		     !xfs_sb_version_haslogv2(&mp->m_sb))) {
> -			xlog_warn("XFS: log sector size (0x%x) invalid "
> -				  "for configuration.", log->l_sectbb_log);
> +	        sector_bits -= BBSHIFT;
> +		if (sector_bits > mp->m_sectbb_log) {
> +			xlog_warn("XFS: Log sector basic block size too large "

It's just the log sector size is too large - no need for "basic
block" in that error message.

> +				"(0x%x > 0x%x)", sector_bits, mp->m_sectbb_log);
>  			goto out_free_log;
>  		}

> -		if (mp->m_sb.sb_logsectlog < BBSHIFT) {
> -			xlog_warn("XFS: Log sector log (0x%x) too small.",
> -						mp->m_sb.sb_logsectlog);
> +
> +		/* for larger sector sizes, must have v2 or external log */
> +		if (sector_bits && (log->l_logBBstart > 0 &&
> +					!xfs_sb_version_haslogv2(&mp->m_sb))) {

no need for the extra ()s there.

> +
> +			xlog_warn("XFS: log sector size (0x%x) invalid "
> +				  "for configuration.", sector_bits);
>  			goto out_free_log;
>  		}
>  	}
> -	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
> +	log->l_sectsize = 1 << sector_bits;
> +	log->l_sectbb_mask = log->l_sectsize - 1;

There's only only place left that uses l_sectbb_mask left (in
xlog_align()), so you could probably kill it while you are at it.

Everything else looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
