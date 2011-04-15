Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3F3licC035934 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 22:47:45 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B36281199835
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 20:51:07 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id BsRT32m6v6Ly4OCv for <xfs@oss.sgi.com>;
	Thu, 14 Apr 2011 20:51:07 -0700 (PDT)
Message-ID: <4DA7C0AA.3040104@sandeen.net>
Date: Thu, 14 Apr 2011 22:51:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: reduce error output on 229
References: <1302838310-28095-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1302838310-28095-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 4/14/11 10:31 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Once we get one short write, we know the test has failed. We don't
> ened to keep writing and getting more short writes and spewing
> thousands of errors to the console.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  src/t_holes.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/src/t_holes.c b/src/t_holes.c
> index eba310a..b111baf 100644
> --- a/src/t_holes.c
> +++ b/src/t_holes.c
> @@ -29,8 +29,10 @@ int main(int argc, char **argv)
>  		for (j = 0; j < 1024; j++)
>  			buf[j]  = i | i << 5;
>  
> -		if (write(fd,buf,253*4*sizeof(int))!= 253*4*sizeof(int))
> +		if (write(fd,buf,253*4*sizeof(int))!= 253*4*sizeof(int)) {
>  			printf("Write did not return correct amount\n");
> +			exit(EXIT_FAILURE);
> +		}
>  
>  		if ((i % 9) == 0 && i < 9001)
>  			lseek(fd, 4096 * 110,SEEK_CUR);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
