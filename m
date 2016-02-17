Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7A057CAD
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:35:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A81D0304032
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:35:13 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yFif4sc88nwC5D5c (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:35:07 -0800 (PST)
Date: Tue, 16 Feb 2016 23:35:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/15] xfs: use vfs inode nlink field everywhere
Message-ID: <20160217073506.GC16363@infradead.org>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
	<1455693652-3899-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455693652-3899-13-git-send-email-david@fromorbit.com>
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

> index 685c7a7..1408be3 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -108,4 +108,8 @@
>  
>  #define xfs_verify_cksum		libxfs_verify_cksum
>  
> +/* inode link counts */
> +#define set_nlink(inode, nlink)	({ (inode)->i_nlink = (nlink); })
> +#define inc_nlink(inode)	(inode)->i_nlink++

Can we defines these as inlines?

> +		ip->i_vnode.i_nlink++;		/* account for . */

Shouldn't we use VFS_I() like everywhere else?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
