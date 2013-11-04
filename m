Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CF78B7F51
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 03:18:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1887304043
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 01:18:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id JS6nwiPNe0gIzEVP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 01:18:28 -0800 (PST)
Date: Mon, 4 Nov 2013 01:18:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 28/30] db: enable metadump on CRC filesystems
Message-ID: <20131104091828.GH23564@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-29-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-29-git-send-email-david@fromorbit.com>
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

On Wed, Oct 30, 2013 at 03:31:19PM +1100, Dave Chinner wrote:
> While there, add IO stack unwinding to xfs_db to prevent metadump
> and other db programs from exiting with unreleased buffers in the IO
> stack and hence emitting warnings like:
> 
> cache_purge: shake on cache 0x69e4f0 left 7 nodes!?

Seems like that should be a separate patch.


> @@ -202,7 +204,8 @@ close_devices:
>  	 * make sure that we pop the last buffer context we held so that the
>  	 * buffer is released before purge the caches during unmount.
>  	 */
> -	pop_cur();
> +	while (iocur_sp > start_iocur_sp)
> +		pop_cur();

The comment above this needs an update.


Otherwise looks fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
