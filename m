Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P5GZUn163519 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 00:16:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F7271C02C5B
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 22:16:34 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Ptb4hFINi3AF3xRZ for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 22:16:34 -0700 (PDT)
Date: Thu, 25 Aug 2011 01:16:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: use fs netlink interface for ENOSPC conditions
Message-ID: <20110825051631.GB1869@infradead.org>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
	<1313669906-14931-5-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1313669906-14931-5-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

>  	xfs_rw_iunlock(ip, iolock);
> +	if (unlikely(-ENOSPC == ret))
> +		fs_nl_send_warning(inode->i_sb->s_dev, FS_NL_ENOSPC_WARN);

I'd remove the nl from both the name and the constants.  In the end what
matters is the warning, and netlink just is an implementation detail.

> index 9a72dda..dd167a0 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -1731,6 +1731,7 @@ init_xfs_fs(void)
>  	error = register_filesystem(&xfs_fs_type);
>  	if (error)
>  		goto out_sysctl_unregister;
> +	init_fs_nl_family();

Why do we have to call this from the filesystem?  Shouldn't we
initialize it once from the VFS?



Also any chance you could include the quota netlink warnings into the
framework?  Any callers is also going to be interestested in quota
warnings, not just enospc.  Also the xfs project quota code returns
ENOSPC if over the project quota and needs to be handled either way.
Adding another new category inbetween user/group quotas and plain ENOSPC
for it would be nice.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
