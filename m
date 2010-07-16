Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6G5Iqbp246023 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 00:18:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2F2044F71E
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 22:21:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AcF57iaOHBmtPFJJ for
	<xfs@oss.sgi.com>; Thu, 15 Jul 2010 22:21:49 -0700 (PDT)
Date: Fri, 16 Jul 2010 01:21:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: use GFP_NOFS for page cache allocation
Message-ID: <20100716052149.GD29915@infradead.org>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279154300-2018-5-git-send-email-david@fromorbit.com>
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

On Thu, Jul 15, 2010 at 10:38:19AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Avoid a lockdep warning by preventing page cache allocation from
> recursing back into the filesystem during memory reclaim.

Yeah, I already have this in my queue too.  Noticed that we don't
need it because of i_mutex as suggested in the stack overflow thread,
but for the XFS ilock.

> @@ -1501,8 +1501,9 @@ xfs_vm_write_begin(
>  	void			**fsdata)
>  {
>  	*pagep = NULL;
> -	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
> -								xfs_get_blocks);
> +	return block_write_begin(file, mapping, pos, len,
> +				 (flags | AOP_FLAG_NOFS),
> +				 pagep, fsdata, xfs_get_blocks);


No need for the bracing:

	return block_write_begin(file, mapping, pos, len, flags | AOP_FLAG_NOFS,
				 pagep, fsdata, xfs_get_blocks);


And with my truncate rework in the vfs tree we'll get rejection galore in
linux-next, but Stephen has been pretty good at handling these..

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
