Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D2AA87CA2
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 19:04:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DE4DAC001
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 17:04:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7fDO2oA0KEvD3VD5 for <xfs@oss.sgi.com>;
	Thu, 14 Jul 2016 17:04:47 -0700 (PDT)
Date: Fri, 15 Jul 2016 10:01:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] common/rc: avoid mkfs option conflicts in
	_scratch_mkfs_xfs_supported
Message-ID: <20160715000129.GT12670@dastard>
References: <1467697153-23189-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1467697153-23189-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 05, 2016 at 01:39:13PM +0800, Eryu Guan wrote:
> In recent mkfs.xfs updates in xfsprogs, commit 9090e187bc3e ("mkfs:
> add respecification detection to generic parsing") added
> re-specification detection to "-m" option, it causes several tests
> _notrun if MKFS_OPTIONS has the same options as those being tested
> in _scratch_mkfs_xfs_supported(), because they're specified multiple
> times.
> 
> 	MKFS_OPTIONS="-m crc=0" ./check xfs/001
> 	xfs/001 3s ... [not run] mkfs.xfs doesn't have crc feature
> 
> Fix it by creating XFS again without MKFS_OPTIONS in
> _scratch_mkfs_xfs_supported(), in case there's conflict between
> MKFS_OPTIONS and mkfs_opts, like what we do in _scratch_mkfs_xfs().
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/rc | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 883bd7b..ad81461 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -473,11 +473,20 @@ _scratch_mkfs_xfs_opts()
>  
>  _scratch_mkfs_xfs_supported()
>  {
> -	mkfs_opts=$*
> +	local mkfs_opts=$*
>  
>  	_scratch_options mkfs
>  
>  	$MKFS_XFS_PROG -N $MKFS_OPTIONS $SCRATCH_OPTIONS $mkfs_opts $SCRATCH_DEV
> +	local mkfs_status=$?
> +
> +	# if $mkfs_opts conflits with $MKFS_OPTIONS,
> +	# try again without $MKFS_OPTIONS
> +	if [ $mkfs_status -ne 0 -a -n "$MKFS_OPTIONS" ]; then
> +		$MKFS_XFS_PROG -N $SCRATCH_OPTIONS $mkfs_opts $SCRATCH_DEV
> +		mkfs_status=$?
> +	fi
> +	return $mkfs_status
>  }


This should match what _scratch_mkfs_xfs does. i.e:

        # a mkfs failure may be caused by conflicts between
        # $MKFS_OPTIONS and $extra_mkfs_options
        if [ $mkfs_status -ne 0 -a ! -z "$extra_mkfs_options" ]; then
                (
                echo -n "** mkfs failed with extra mkfs options "
                echo "added to \"$MKFS_OPTIONS\" by test $seq **"
                echo -n "** attempting to mkfs using only test $seq "
                echo "options: $extra_mkfs_options **"
                ) >> $seqres.full

                # running mkfs again. overwrite previous mkfs output files
                _scratch_mkfs_xfs_opts $extra_mkfs_options \
                        2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
                local mkfs_status=$?
        fi

i.e. it checks if $extra_mkfs_options is not empty, rather than
$MKFS_OPTIONS

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
