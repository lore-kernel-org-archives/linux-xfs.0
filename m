Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4K4bZji179103 for <xfs@oss.sgi.com>; Wed, 19 May 2010 23:37:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED3DE35D9E8
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 21:39:53 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id OCfM3ljcEx2Vqd4j for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 21:39:53 -0700 (PDT)
Message-ID: <4BF4BD18.1020608@sandeen.net>
Date: Wed, 19 May 2010 23:39:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 226: have xfs_io use bigger buffers
References: <201005192244.o4JMiEPY014864@stout.americas.sgi.com>
In-Reply-To: <201005192244.o4JMiEPY014864@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

Alex Elder wrote:
> By default xfs_io uses a buffer size of 4096 bytes.  On test 226,
> the result is that the test runs much slower (at least an order
> of magnitude) than it needs to.
> 
> Add a flag to the "pwrite" command sent to xfs_io so it uses
> larger buffers, thereby speeding things up considerably.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> 
> ---
>  226 |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: b/226
> ===================================================================
> --- a/226
> +++ b/226
> @@ -49,10 +49,14 @@ _scratch_mount
>  
>  loops=16
>  
> +# Buffer size argument supplied to xfs_io "pwrite" command
> +buffer="-b $(expr 512 \* 1024)"
> +
>  echo "--> $loops buffered 64m writes in a loop"
>  for I in `seq 1 $loops`; do
>  	echo -n "$I "
> -	xfs_io -F -f -c 'pwrite 0 64m' $SCRATCH_MNT/test >> $seq.full
> +	xfs_io -F -f \
> +		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seq.full
>  	rm -f $SCRATCH_MNT/test
>  done
>  
> @@ -63,7 +67,8 @@ _scratch_mount
>  echo "--> $loops direct 64m writes in a loop"
>  for I in `seq 1 $loops`; do
>  	echo -n "$I "
> -	xfs_io -F -f -d -c 'pwrite 0 64m' $SCRATCH_MNT/test >> $seq.full
> +	xfs_io -F -f -d \
> +		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seq.full
>  	rm -f $SCRATCH_MNT/test 
>  done
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
