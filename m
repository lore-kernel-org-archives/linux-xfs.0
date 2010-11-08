Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8BNgIx096020 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 05:23:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8B671C23501
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 03:25:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BcD4Fppi2237Ehr3 for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 03:25:09 -0800 (PST)
Date: Mon, 8 Nov 2010 06:25:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/16] xfs: connect up buffer reclaim priority hooks
Message-ID: <20101108112509.GA7654@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-12-git-send-email-david@fromorbit.com>
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

> +/*
> + * buffer types 
> + */
> +#define	B_FS_DQUOT	1
> +#define	B_FS_AGFL	2
> +#define	B_FS_AGF	3
> +#define	B_FS_ATTR_BTREE	4
> +#define	B_FS_DIR_BTREE	5
> +#define	B_FS_MAP	6
> +#define	B_FS_INOMAP	7
> +#define	B_FS_AGI	8
> +#define	B_FS_INO	9

Is there any good reason to keep/reintroduce the buffer types?  In this
series we're only using the refcounts, and I can't see any good use for
the types either.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
