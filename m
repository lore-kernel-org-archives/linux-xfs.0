Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KHZpj4099068 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 12:35:51 -0500
Subject: Re: [PATCH 4/4] xfstests: handle filesystems without FIEMAP support
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101015222924.GD3781@infradead.org>
References: <20101015222820.GA3655@infradead.org>
	<20101015222924.GD3781@infradead.org>
Date: Wed, 20 Oct 2010 12:37:01 -0500
Message-ID: <1287596221.2284.97.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2010-10-15 at 18:29 -0400, Christoph Hellwig wrote:
> Do a _notrun in 225 if we get EOPNOSUPP back from FIEMAP instead
> of failing the test.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, but I think if the operation is not
supported you want to delete both "${fiemapfile}"
and "${fiemaplog}".

While you're at it, make use of the "${fiemapfile}"
variable in the fiemap-tester command...  (This
appears to be a bug in the original test.)

Reviewed-by: Alex Elder <aelder@sgi.com>

> --- a/225
> +++ b/225
> @@ -49,13 +49,19 @@ _supported_os Linux
>  _setup_testdir
>  
>  fiemapfile=$TEST_DIR/fiemap.$$
> +fiemaplog=$TEST_DIR/fiemap.$$.log
>  
>  [ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
>  
>  echo "fiemap run without preallocation"
> -$here/src/fiemap-tester -q -p 0 -r 200 $TEST_DIR/fiemapfile
> +$here/src/fiemap-tester -q -p 0 -r 200 $TEST_DIR/fiemapfile 2>&1 | tee $fiemaplog
> +
> +if grep -q "Operation not supported" $fiemaplog; then
> +      _notrun "FIEMAP not supported by this filesystem type: $FSTYP"
> +fi
>  
>  rm -f $fiemapfile
> +rm -f $fiemaplog
>  rm -f $seq.full
>  
>  status=0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
