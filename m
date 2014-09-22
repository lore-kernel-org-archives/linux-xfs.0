Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB4897F50
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 08:21:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A7A788F804B
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 06:21:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iqUGvCJf2VRW3WIH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 06:21:10 -0700 (PDT)
Date: Mon, 22 Sep 2014 09:21:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] libxfs: use structure initializers for cache_operations
Message-ID: <20140922132107.GB29156@bfoster.bfoster>
References: <541C95B1.9020807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <541C95B1.9020807@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Sep 19, 2014 at 03:44:33PM -0500, Eric Sandeen wrote:
> This makes it a lot easier for cscope etc.
> 
> Surely all modern compilers can cope?
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Seems reasonable to me.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 9ee89d3..80de6fa 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1088,12 +1088,12 @@ libxfs_bcache_overflowed(void)
>  }
>  
>  struct cache_operations libxfs_bcache_operations = {
> -	/* .hash */	libxfs_bhash,
> -	/* .alloc */	libxfs_balloc,
> -	/* .flush */	libxfs_bflush,
> -	/* .relse */	libxfs_brelse,
> -	/* .compare */	libxfs_bcompare,
> -	/* .bulkrelse */libxfs_bulkrelse
> +	.hash		= libxfs_bhash,
> +	.alloc		= libxfs_balloc,
> +	.flush		= libxfs_bflush,
> +	.relse		= libxfs_brelse,
> +	.compare	= libxfs_bcompare,
> +	.bulkrelse	= libxfs_bulkrelse
>  };
>  
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
