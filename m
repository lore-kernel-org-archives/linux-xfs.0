Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C20917F37
	for <xfs@oss.sgi.com>; Sat, 22 Jun 2013 10:49:47 -0500 (CDT)
Message-ID: <51C5C798.7090701@sgi.com>
Date: Sat, 22 Jun 2013 10:49:44 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 09/60] xfs: Inode create log items
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-10-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/18/13 23:50, Dave Chinner wrote:
> +/*
> + * on disk log item structure
> + *
> + * Log recovery assumes the first two entries are the type and size and they fit
> + * in 32 bits. Also in host order (ugh) so they have to be 32 bit aligned so
> + * decoding can be done correctly.
> + */
> +struct xfs_icreate_log {
> +	__uint16_t	icl_type;	/* type of log format structure */
> +	__uint16_t	icl_size;	/* size of log format structure */
> +	__be32		icl_ag;		/* ag being allocated in */
> +	__be32		icl_agbno;	/* start block of inode range */
> +	__be32		icl_count;	/* number of inodes to initialise */
> +	__be32		icl_isize;	/* size of inodes */
> +	__be32		icl_length;	/* length of extent to initialise */
> +	__be32		icl_gen;	/* inode generation number to use */
> +};
> +
> +/* in memory log item structure */
> +struct xfs_icreate_item {
> +	struct xfs_log_item	ic_item;
> +	struct xfs_icreate_log	ic_format;
> +};
> +

Just a nit: I assume the name was getting a bit long, but having _format 
in the name tells the structure purpose. I know, I know, the 
xfs_icreate_item uses format in the "ic_format" variable name.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
