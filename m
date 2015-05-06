Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9ED197F37
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 23:38:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 82D6E304032
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 21:38:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id EQannKujjJ2CW0kl (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 21:38:08 -0700 (PDT)
Date: Tue, 5 May 2015 21:38:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: inode counter needs to use
	__percpu_counter_compare
Message-ID: <20150506043807.GB10940@infradead.org>
References: <1430863299-9341-1-git-send-email-david@fromorbit.com>
	<1430863299-9341-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430863299-9341-3-git-send-email-david@fromorbit.com>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 02f827f..900f8ce 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1106,8 +1106,9 @@ xfs_mod_icount(
>  	int64_t			delta)
>  {
>  	/* deltas are +/-64, hence the large batch size of 128. */
> -	__percpu_counter_add(&mp->m_icount, delta, 128);
> -	if (percpu_counter_compare(&mp->m_icount, 0) < 0) {
> +#define _ICOUNT_BATCH	128
> +	__percpu_counter_add(&mp->m_icount, delta, _ICOUNT_BATCH);

Can you give XFS_ prefixes to the atch sizes and move them otuside the
function?  And fix up the instance in xfs_mod_fdblocks as well while
you're at it.

Otherwise looks fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
