Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 744217CA1
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 04:06:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0319AC002
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 02:06:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VAPJRyTlGtwibZEa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2016 02:06:25 -0700 (PDT)
Date: Wed, 13 Jul 2016 17:06:23 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] common/rc: avoid mkfs option conflicts in
	_scratch_mkfs_xfs_supported
Message-ID: <20160713090623.GQ2432@eguan.usersys.redhat.com>
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
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com

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

Ping on this.

My first attempt was removing $MKFS_OPTIONS from $MKFS_XFS_PROG command
line, but that broke xfs/186, this is the second attempt to fix this
issue.

Thanks,
Eryu

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
>  
>  _scratch_mkfs_xfs()
> -- 
> 2.7.4
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
