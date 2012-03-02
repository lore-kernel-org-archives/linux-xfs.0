Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22KFpoh143196 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 14:15:52 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id JZ7B8eKIjPpa0TAF for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 12:15:50 -0800 (PST)
Message-ID: <4F512A75.9030300@sandeen.net>
Date: Fri, 02 Mar 2012 14:15:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfstests patch] 113: add testing for O_DIRECT + O_SYNC
References: <x49ipim7r19.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ipim7r19.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 3/2/12 1:15 PM, Jeff Moyer wrote:
> Hi,
> 
> This patch adds a couple more aio-stress runs to test 113.  The first
> simply adds -S, to test out AIO+DIO+O_SYNC.  The second adds -S and -o
> 2, which directs aio-stress to only perform the random write test.
> These two tests helped identify several bugs in ext4.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Looks fine, I'll check it into xfstests-dev, thanks!

-Eric

> 
> diff --git a/113 b/113
> index 23676e0..b2ec510 100755
> --- a/113
> +++ b/113
> @@ -100,4 +100,10 @@ _do_test 2 "-s 10m" $count $procs
>  # as above, but now using direct IO
>  _do_test 3 "-s 10m -O" $count $procs
>  
> +# dio with O_SYNC and unwritten extent conversion
> +_do_test 4 "-s 10m -O -S" $count $procs
> +
> +# random dio writes with O_SYNC and unwritten extent conversion
> +_do_test 5 "-s 10m -O -S -o 2" $count $procs
> +
>  exit
> diff --git a/113.out b/113.out
> index 1f3b866..aa856a6 100644
> --- a/113.out
> +++ b/113.out
> @@ -12,3 +12,11 @@ aio-stress.2 : -t 20 -s 10m
>  -----------------------------------------------
>  aio-stress.3 : -t 20 -s 10m -O
>  -----------------------------------------------
> +
> +-----------------------------------------------
> +aio-stress.4 : -t 20 -s 10m -O -S
> +-----------------------------------------------
> +
> +-----------------------------------------------
> +aio-stress.5 : -t 20 -s 10m -O -S -o 2
> +-----------------------------------------------
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
