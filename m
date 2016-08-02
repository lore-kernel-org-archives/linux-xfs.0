Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2BD377CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 18:23:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93031AC002
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 16:23:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	geQhoOOjAhFmrAEf for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 16:23:07 -0700 (PDT)
Date: Wed, 3 Aug 2016 09:23:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic/095: update warning whitelist
Message-ID: <20160802232305.GQ12670@dastard>
References: <1470042176-31447-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470042176-31447-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 01, 2016 at 11:02:56AM +0200, Christoph Hellwig wrote:
> The recent direct I/O path refactor changed the function name in the
> racing read case.  Update the test case to handle the new name in
> addition to the old one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/095 | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/095 b/tests/generic/095
> index c656ef1..4754992 100755
> --- a/tests/generic/095
> +++ b/tests/generic/095
> @@ -125,9 +125,11 @@ $FIO_PROG $fio_config >>$seqres.full 2>&1
>  filter_xfs_dmesg()
>  {
>  	local warn1="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_write.*"
> -	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
> +	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_read.*"
> +	local warn3="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
>  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
> -	    -e "s#$warn2#Intentional warnings in xfs_file_read_iter#"
> +	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
> +	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#"
>  }

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
