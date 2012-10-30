Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UKcpDt071127 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 15:38:51 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9radOaESgzECz115 for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 13:40:40 -0700 (PDT)
Date: Wed, 31 Oct 2012 07:40:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] Add new standard loop handling functions
Message-ID: <20121030204038.GY29378@dastard>
References: <1350549946-17192-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1350549946-17192-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Thu, Oct 18, 2012 at 10:45:44AM +0200, Tomas Racek wrote:
> Add _create_loop_device and _destroy_loop_device to uniformly handle
> loopback devices.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>  common.rc | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/common.rc b/common.rc
> index 966fc93..b5edd22 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -1804,6 +1804,21 @@ _test_batched_discard()
>  	$FSTRIM_PROG ${1} &>/dev/null
>  }
>  
> +_create_loop_device()
> +{
> +	file=$1
> +	dev=`losetup -f`
> +	losetup $dev $file || _fail "Cannot associate $file with $dev"
> +	echo $dev
> +}
> +
> +_destroy_loop_device()
> +{
> +	dev=$1
> +	losetup -d $dev || _fail "Cannot destroy loop device $dev"
> +}
> +
> +
>  ################################################################################

Perhaps a followup patch that converts existing loop device users to
use this interface is appropriate?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
