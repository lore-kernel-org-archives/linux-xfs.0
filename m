Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DA877CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 03:40:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7161AC001
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 01:40:25 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id KK5ffTcXBIl5KZAz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 01:40:24 -0800 (PST)
Date: Mon, 8 Feb 2016 01:40:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] xfs: use vfs inode nlink field everywhere
Message-ID: <20160208094021.GA4487@infradead.org>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
	<1454905461-2773-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454905461-2773-7-git-send-email-david@fromorbit.com>
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

On Mon, Feb 08, 2016 at 03:24:18PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The Vfs tracks the inodenlink just like the xfs_icdinode. We can

s/Vfs/VFS/

> +STATIC int
>  xfs_iunlink(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*ip)
> +	struct xfs_trans *tp,
> +	struct xfs_inode *ip,
> +	bool		ignore_linkcount)

I'd say kill the ignore_linkcount parameter and the assert depending on it.
There are just two callers: xfs_droplink checks for i_nlink just before
the call, and xfs_create_tmpfile has to set the override flag.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
