Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LE1HE3075737 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 08:01:17 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfstests: fix format string warnings in
	aio-dio-extend-stat.c
Date: Thu, 21 Jan 2010 08:01:13 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69AB@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100121113421.GC3580@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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

Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfstests-dev/src/aio-dio-regress/aio-dio-extend-stat.c
> ===================================================================
> --- xfstests-dev.orig/src/aio-dio-regress/aio-dio-extend-stat.c	2010-01-21 11:27:36.000000000
> +0000 +++ xfstests-dev/src/aio-dio-regress/aio-dio-extend-stat.c	2010-01-21 11:28:15.000000000
> +0000 @@ -149,8 +149,9 @@ void fun_read(void *ptr)
>  			if (filestat.st_size < exSize)
>  				fail("write of %lu bytes @%llu finished, "
>  				     "expected filesize at least %llu, but "
> -				     "got %ld\n", event->obj->u.c.nbytes,
> -				     event->obj->u.c.offset, exSize, filestat.st_size);
> +				     "got %lld\n", event->obj->u.c.nbytes,
> +				     event->obj->u.c.offset, exSize,
> +				     (long long)filestat.st_size);
>  		}
>  	}
>  }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
