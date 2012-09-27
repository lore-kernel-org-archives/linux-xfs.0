Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QNx8Zo011621 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 18:59:08 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jq60rvKNv7ami77U for <xfs@oss.sgi.com>;
	Wed, 26 Sep 2012 17:00:25 -0700 (PDT)
Date: Thu, 27 Sep 2012 10:00:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprog: remove duplicate vector memalign from xfs_io
Message-ID: <20120927000024.GA15236@dastard>
References: <20120925142414.660506845@sgi.com>
	<20120925142421.398175185@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120925142421.398175185@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 25, 2012 at 09:24:15AM -0500, Mark Tinguely wrote:
> The vector feature of xfs_io uses its own memory buffer in the iov structure
> and does not use the buffer entry. Remove the duplicate memalign.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  io/pread.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: b/io/pread.c
> ===================================================================
> --- a/io/pread.c
> +++ b/io/pread.c
> @@ -76,8 +76,7 @@ alloc_iovec(
>  	buffersize = 0;
>  	for (i = 0; i < vectors; i++) {
>  		iov[i].iov_base = memalign(pagesize, bsize);
> -		buffer = memalign(pagesize, bsize);
> -		if (!buffer) {
> +		if (!iov[i].iov_base) {
>  			perror("memalign");
>  			goto unwind;
>  		}

Classic copy'n'paste bug. My fault.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
