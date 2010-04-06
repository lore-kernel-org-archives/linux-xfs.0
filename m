Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o36NvQo9145336 for <xfs@oss.sgi.com>; Tue, 6 Apr 2010 18:57:27 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08AE91D3D970
	for <xfs@oss.sgi.com>; Tue,  6 Apr 2010 16:59:16 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id 38RTHVrK4Dn54rdp for
	<xfs@oss.sgi.com>; Tue, 06 Apr 2010 16:59:16 -0700 (PDT)
Date: Wed, 7 Apr 2010 09:59:08 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <1369590830.403251270598348701.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20100403103321.GA20739@infradead.org>
Subject: Re: [PATCH] xfsprogs: add a platform_discard_blocks stub to gnufreebsd
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/include/gnukfreebsd.h
> ===================================================================
> --- xfsprogs-dev.orig/include/gnukfreebsd.h	2010-04-03
> 12:29:57.048004157 +0200
> +++ xfsprogs-dev/include/gnukfreebsd.h	2010-04-03 12:30:12.913005989
> +0200
> @@ -119,4 +119,10 @@ static __inline__ void platform_uuid_cop
>  	uuid_copy(*dst, *src);
>  }
>  
> +static __inline__ int
> +platform_discard_blocks(int fd, uint64_t start, uint64_t len)
> +{
> +	return 0;
> +}
> +
>  #endif	/* __XFS_KFREEBSD_H__ */
> 

Looks good to me, thanks Christoph.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
