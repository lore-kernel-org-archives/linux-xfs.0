Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BGtYCO131975 for <xfs@oss.sgi.com>; Wed, 11 May 2011 11:55:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA7781BDCE68
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 09:55:33 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id kx6rZ7XwkZHvBCfA for <xfs@oss.sgi.com>;
	Wed, 11 May 2011 09:55:33 -0700 (PDT)
Message-ID: <4DCABF85.4080705@sandeen.net>
Date: Wed, 11 May 2011 11:55:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: print the message that fallocate is not supported to
	stdout unless quiet output
References: <1305126445.22267.37.camel@dhcp-31-190.brq.redhat.com>
In-Reply-To: <1305126445.22267.37.camel@dhcp-31-190.brq.redhat.com>
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
To: Boris Ranto <branto@redhat.com>
Cc: xfs <xfs@oss.sgi.com>

On 5/11/11 10:07 AM, Boris Ranto wrote:
> ltp/fsx.c tests whether the filesystem it is run on supports fallocate. If it is not supported the fsx will print warning to stderr.
> This leads to fails of tests 075, 112, 127 for the filesystems that do not support fallocate. The tests use ltp/fsx but do not filter out stderr.
> Since ltp/fsx.c can work without fallocate support I propose to move this message to stdout unless quiet output is not requested.
> Previous patch printed the message even if -q flag was used. This patch honours the flag.
> 
> This simple patch fixes the issue for me, tested on all the mentioned tests:
> 
> Signed-off-by: Boris Ranto <branto@redhat.com>

Good idea, sorry about that!

I'll commit this with my signoff.

-Eric

> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index fe072d3..43e7efe 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -1424,7 +1424,8 @@ main(int argc, char **argv)
>  #ifdef FALLOCATE
>         if (!lite && fallocate_calls) {
>                 if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
> -                       warn("main: filesystem does not support fallocate, disabling");
> +                       if(!quiet)
> +                               prt("fsx: main: filesystem does not support fallocate, disabling\n");
>                         fallocate_calls = 0;
>                 } else
>                         ftruncate(fd, 0);
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
