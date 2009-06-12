Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5CFwDer213036 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 10:58:13 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 272F68F813D
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 08:58:33 -0700 (PDT)
Message-Id: <4C196E17-6993-4AE2-9E0B-32AFE6E07720@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090612151911.GA9832@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfs: fix small mismerge in xfs_vn_mknod
Date: Fri, 12 Jun 2009 10:58:32 -0500
References: <20090612151911.GA9832@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Jun 12, 2009, at 10:19 AM, Christoph Hellwig wrote:

> Identation got messed up when merging the current_umask changes with
> the generic ACL support.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2009-06-12  
> 17:16:26.902939418 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2009-06-12 17:16:48.611940327  
> +0200
> @@ -225,8 +225,8 @@ xfs_vn_mknod(
> 		if (IS_ERR(default_acl))
> 			return -PTR_ERR(default_acl);
>
> -	if (!default_acl)
> -		mode &= ~current_umask();
> +		if (!default_acl)
> +			mode &= ~current_umask();
> 	}
>
> 	xfs_dentry_to_name(&name, dentry);
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
