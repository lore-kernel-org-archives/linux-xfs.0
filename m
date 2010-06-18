Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5I8Jrb0215133 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 03:19:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC5FC1B7666D
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 01:22:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Xr9YSVo48fhRFBsr for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 01:22:31 -0700 (PDT)
Date: Fri, 18 Jun 2010 04:22:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: remove block number from inode lookup code
Message-ID: <20100618082229.GA30787@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<1276846374-23916-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1276846374-23916-5-git-send-email-david@fromorbit.com>
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
Cc: security@kernel.org, xfs@oss.sgi.com

> -	ip->i_imap.im_blkno = bno;
> +	ip->i_imap.im_blkno = 0;
>  	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, iget_flags);

The im_blkno initialization before calling xfs_imap can be removed now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
