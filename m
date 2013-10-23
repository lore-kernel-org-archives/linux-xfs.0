Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F6217F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 16:32:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A716304059
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 14:32:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pWAUS7dentPhVYYO for <xfs@oss.sgi.com>;
	Wed, 23 Oct 2013 14:31:57 -0700 (PDT)
Date: Thu, 24 Oct 2013 08:31:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfstests: implemented _no_of_online_cpus() function
Message-ID: <20131023213152.GP2797@dastard>
References: <1382529524-2184-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<1382529524-2184-2-git-send-email-stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382529524-2184-2-git-send-email-stanislav.kholmanskikh@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: vasily.isaenko@oracle.com, xfs@oss.sgi.com

On Wed, Oct 23, 2013 at 03:58:43PM +0400, Stanislav Kholmanskikh wrote:
> Its purpose is to get a number of online cpus.
> 
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
>  common/rc |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 77e96c4..ff2f7fe 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2145,6 +2145,25 @@ _scale_fsstress_args()
>      echo $args
>  }
>  
> +_no_of_online_cpus()
> +{
> +	count=0
> +
> +	for i in `cat /sys/devices/system/cpu/online | $SED_PROG 's/,/ /g'`; do
> +		count=$(( $count + 1 ))

That's just as kernel/platform dependent as using /proc/cpuinfo.

Indeed, note this in generic/273:

_supported_os IRIX Linux

It's supposed to work on Irix as well, which means using sysfs is
just as wrong as using /proc/cpuinfo.

sysconf is the prefered platform neutral interface for getting this
sort of information. Something as simple as:

$ getconf _NPROCESSORS_ONLN
8
$

or adding a sysconf(_SC_NPROCESSORS_ONLN) call to src/features.c (if
we don't want to rely on systems having getconf installed) would be
much better than manually parsing magic proc or sysfs files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
