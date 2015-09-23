Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 87A187F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 22:44:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1053EAC00A
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 20:44:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GBquUt0hWvZskcBL for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 20:44:08 -0700 (PDT)
Date: Wed, 23 Sep 2015 13:44:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 02/12] libxfs: track largest metadata LSN in use via
	verifiers
Message-ID: <20150923034406.GR3902@dastard>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
	<1441997742-37160-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441997742-37160-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 11, 2015 at 02:55:32PM -0400, Brian Foster wrote:
> The LSN validation helper is called in the I/O verifier codepath for
> metadata that embed a last-modification LSN. While the codepath exists,
> this is not used in userspace as in the kernel because the former
> doesn't have an active log.
> 
> xfs_repair does need to check the validity of the LSN metadata with
> respect to the on-disk log, however. Use the LSN validation mechanism to
> track the largest LSN that has been seen. Export the value so repair can
> use it once it has processed the entire filesystem. Note that the helper
> continues to always return true to preserve existing behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
....
> +xfs_lsn_t		libxfs_max_lsn = 0;
> +pthread_mutex_t		libxfs_max_lsn_lock = PTHREAD_MUTEX_INITIALIZER;
> +
>  void
>  xfs_detect_invalid_lsn(
>  	struct xfs_mount	*mp,
>  	xfs_lsn_t		lsn)
>  {
> +	int			cycle = CYCLE_LSN(lsn);
> +	int			block = BLOCK_LSN(lsn);
> +	int			max_cycle;
> +	int			max_block;
> +
> +	if (lsn == NULLCOMMITLSN)
> +		return;
> +
> +	pthread_mutex_lock(&libxfs_max_lsn_lock);
> +
> +	max_cycle = CYCLE_LSN(libxfs_max_lsn);
> +	max_block = BLOCK_LSN(libxfs_max_lsn);
> +
> +	if ((cycle > max_cycle) ||
> +	    (cycle == max_cycle && block > max_block))
> +		libxfs_max_lsn = lsn;
> +
> +	pthread_mutex_unlock(&libxfs_max_lsn_lock);

This will have the same lock contention problems that the kernel
code would have had - my repair scalablity tests regularly reach
over 1GB/s of metadata being prefetched through tens of threads, so
this is going have a significant impact on performance in those
tests....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
