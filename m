Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97M1ZnS214197 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 17:01:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE273BDA634
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 15:03:00 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id FAMOcx1rXpF2thnC for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 15:03:00 -0700 (PDT)
Message-ID: <4ACD1013.6000502@sandeen.net>
Date: Wed, 07 Oct 2009 17:02:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: add missing CHANGES entry
References: <20091006151102.GA30964@infradead.org>
In-Reply-To: <20091006151102.GA30964@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> The 3.0.4 release for debian actually had a few more changes than documented.
> Add the missing entries so that they appear in the right spot for future
> releases.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

looks fine to me,

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfsprogs-dev/doc/CHANGES
> ===================================================================
> --- xfsprogs-dev.orig/doc/CHANGES	2009-10-06 10:51:31.609004058 -0300
> +++ xfsprogs-dev/doc/CHANGES	2009-10-06 10:54:13.695006442 -0300
> @@ -1,4 +1,10 @@
>  xfsprogs-3.0.4 (17 September 2009)
> +	- Fix a memory leak in xfsprogs.
> +	- Increase hash chain length in xfsprogs when running out of memory.
> +	- Fix dmsetup invocation in libdisk to avoid warnings during mkfs
> +	  on multipath devices.
> +	- Fix the -V option to various installed tools.
> +	- Small internal fixes to please the clang semantical analysis tool.
>  	- Debian packaging updates.
>  	- Rework Makepkgs and Makefiles to improve deb generation.
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
