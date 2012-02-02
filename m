Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12I6Tfd067964 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 12:06:29 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Dpp7CNT85hIRGaFV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 10:06:28 -0800 (PST)
Date: Thu, 2 Feb 2012 19:06:26 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] quota: make Q_XQUOTASYNC a noop
Message-ID: <20120202180626.GA7494@quack.suse.cz>
References: <20120202161409.303465214@bombadil.infradead.org>
	<20120202161629.559449485@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120202161629.559449485@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: jack@suse.cz, xfs@oss.sgi.com

On Thu 02-02-12 11:14:12, Christoph Hellwig wrote:
> Now that XFS takes quota reservations into account there is no need to flush
> anything before reporting quotas - in addition to beeing fully transactional
> all quota information is also 100% coherent with the rest of the filesystem
> now.
  Looks fine. You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/quota/quota.c
> ===================================================================
> --- xfs.orig/fs/quota/quota.c	2012-02-02 13:06:30.693396524 +0100
> +++ xfs/fs/quota/quota.c	2012-02-02 13:23:23.181244741 +0100
> @@ -282,10 +282,9 @@ static int do_quotactl(struct super_bloc
>  	case Q_XGETQUOTA:
>  		return quota_getxquota(sb, type, id, addr);
>  	case Q_XQUOTASYNC:
> -		/* caller already holds s_umount */
>  		if (sb->s_flags & MS_RDONLY)
>  			return -EROFS;
> -		writeback_inodes_sb(sb, WB_REASON_SYNC);
> +		/* XFS quotas are fully coherent now, making this call a noop */
>  		return 0;
>  	default:
>  		return -EINVAL;
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
