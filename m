Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E4CC7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:32:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5476AC008
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:32:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rcKhGguSNEIRWFoO for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 12:32:48 -0800 (PST)
Message-ID: <530FA0EF.50301@sandeen.net>
Date: Thu, 27 Feb 2014 14:32:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: don't leak fd in open -Tr failure case
References: <530F9F37.8020408@redhat.com>
In-Reply-To: <530F9F37.8020408@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 2/27/14, 2:25 PM, Eric Sandeen wrote:
> Coverity spotted this.
> 
> It complained that we didn't close the fd before returning in
> this case of incompatible options, but it seems like we should
> just test for the incompatible flags before even trying to open
> the file, no?
> 
> (The open would have failed in any case, but with a somewhat
> cryptic "Invalid argument" - so it's probably better to state
> it plainly and bail immediately.)

So actually, we wouldn't leak, because the open would fail.
So I guess it's not the best subject & description...

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/io/open.c b/io/open.c
> index 6bb0d46..c106fa7 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -342,6 +342,11 @@ open_f(
>  	if (optind != argc - 1)
>  		return command_usage(&open_cmd);
>  
> +	if ((flags & (IO_READONLY|IO_TMPFILE)) == (IO_READONLY|IO_TMPFILE)) {
> +		fprintf(stderr, _("-T and -r options are incompatible\n"));
> +		return -1;
> +	}
> +
>  	fd = openfile(argv[optind], &geometry, flags, mode);
>  	if (fd < 0)
>  		return 0;
> @@ -349,11 +354,6 @@ open_f(
>  	if (!platform_test_xfs_fd(fd))
>  		flags |= IO_FOREIGN;
>  
> -	if ((flags & (IO_READONLY|IO_TMPFILE)) == (IO_READONLY|IO_TMPFILE)) {
> -		fprintf(stderr, _("-T and -r options are incompatible\n"));
> -		return -1;
> -	}
> -
>  	addfile(argv[optind], fd, &geometry, flags);
>  	return 0;
>  }
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
