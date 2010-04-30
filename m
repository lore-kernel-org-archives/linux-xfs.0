Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U3BeT4123968 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 22:11:41 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3FFC1275650
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:13:45 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id ak6pp3a4RUFf2qRV for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:13:45 -0700 (PDT)
Message-ID: <4BDA4AE8.2000406@sandeen.net>
Date: Thu, 29 Apr 2010 22:13:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix fiemap-tester when build without fallocate
References: <20100429103916.GA10535@infradead.org>
In-Reply-To: <20100429103916.GA10535@infradead.org>
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
> Make sure at least the tests passing -p0 like xfstests 225 can work when
> built without fallocate support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for doing that.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>


> Index: xfstests-dev/src/fiemap-tester.c
> ===================================================================
> --- xfstests-dev.orig/src/fiemap-tester.c	2010-04-29 10:32:52.000000000 +0000
> +++ xfstests-dev/src/fiemap-tester.c	2010-04-29 10:35:11.000000000 +0000
> @@ -37,14 +37,10 @@ static void
>  usage(void)
>  {
>  	printf("Usage: fiemap-tester [-m map] [-r number of runs] [-s seed] [-q]");
> -#ifdef HAVE_FALLOCATE
>  	printf("[-p preallocate (1/0)] ");
> -#endif
>  	printf("filename\n");
>  	printf("  -m map    : generate a file with the map given and test\n");
> -#ifdef HAVE_FALLOCATE
>  	printf("  -p 0/1    : turn block preallocation on or off\n");
> -#endif
>  	printf("  -r count  : number of runs to execute (default infinity)\n");
>  	printf("  -s seed   : seed for random map generator (default 1)\n");
>  	printf("  -q        : be quiet about non-errors\n");
> @@ -513,9 +509,10 @@ main(int argc, char **argv)
>  		case 'p':
>  			prealloc = atoi(optarg);;
>  #ifndef HAVE_FALLOCATE
> -			if (prealloc)
> +			if (prealloc) {
>  				printf("Not built with preallocation support\n");
> -			usage();
> +				usage();
> +			}
>  #endif
>  			break;
>  		case 'q':
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
