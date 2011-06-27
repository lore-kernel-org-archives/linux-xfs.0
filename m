Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5RLcFZd149520 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 16:38:15 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F83A333B7
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 14:38:14 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id CaaOEHTHc9b1nBb9 for <xfs@oss.sgi.com>;
	Mon, 27 Jun 2011 14:38:14 -0700 (PDT)
Message-ID: <4E08F845.3020804@sandeen.net>
Date: Mon, 27 Jun 2011 16:38:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfstests: add mapped write fsx operations to 091
References: <1309153722-1231-1-git-send-email-david@fromorbit.com>
	<1309153722-1231-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1309153722-1231-5-git-send-email-david@fromorbit.com>
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

On 6/27/11 12:48 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent busted fsx updates caused fsx to execute fsx with direct
> IO and mmapped reads and writes on an XFS filesystem. The result
> uncovered a direct-IO write vs mmap read bug to do with EOF
> sub-block zeroing on the direct IO write.
> 
> Hence whiel we do not recommend that pepole mix DIO with mmap on the
> same file, we should at least have tests that exercise it as they
> often show up other problems like this.
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  091     |    3 +++
>  091.out |    2 ++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/091 b/091
> index a13d979..11b599e 100755
> --- a/091
> +++ b/091
> @@ -88,6 +88,9 @@ kernel=`uname -r  | sed -e 's/\(2\..\).*/\1/'`
>  #run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t PSIZE -w PSIZE -Z -W
>   run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
>  
> + run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> + run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> +
>  # Commented out calls above are less likely to pick up issues, so
>  # save time by commenting them out (leave 'em for manual testing).
>  
> diff --git a/091.out b/091.out
> index 31bd25d..27ed1e3 100644
> --- a/091.out
> +++ b/091.out
> @@ -5,3 +5,5 @@ fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>  fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>  fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>  fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
> +fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> +fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
