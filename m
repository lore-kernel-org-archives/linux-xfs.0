Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E2817F3F
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 09:15:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3FEA0304032
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 07:15:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 5DZ8RVt595kL9HEJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Jul 2014 07:15:10 -0700 (PDT)
Date: Fri, 4 Jul 2014 07:15:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] libxfs: reused invalidated buffers leak state and data
Message-ID: <20140704141509.GB29520@infradead.org>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
	<1404453435-1915-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1404453435-1915-5-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, Jul 04, 2014 at 03:57:13PM +1000, Dave Chinner wrote:
> @@ -632,6 +632,12 @@ libxfs_putbuf(xfs_buf_t *bp)
>  			pthread_mutex_unlock(&bp->b_lock);
>  		}
>  	}
> +	/*
> +	 * ensure that any errors on this use of the buffer don't carry
> +	 * over to the next user.
> +	 */
> +	bp->b_error = 0;
> +
>  	cache_node_put(libxfs_bcache, (struct cache_node *)bp);

This seems a bit fishy to me.  For one I'm pretty sure it needs to be
done before unlocking b_lock, second it's different behavior from the
kernel where we explicitly clear it in the caller for the rare case
we want to reuse a buffer that had an error (xfs_buf_iodone_callbacks
seems to be the only one).  Any reason to do this differently in
userspace?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
