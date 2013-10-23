Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BED037F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 08:08:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9FDDA8F8040
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 06:08:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Pcw6y0TF4U83cBmw for
	<xfs@oss.sgi.com>; Wed, 23 Oct 2013 06:08:36 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9ND8atq016590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 09:08:36 -0400
Received: from orion.maiolino.org (ovpn-113-152.phx2.redhat.com [10.3.113.152])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r9ND8X8f030727
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 09:08:35 -0400
Date: Wed, 23 Oct 2013 11:08:32 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfstests: implemented _no_of_online_cpus() function
Message-ID: <20131023130831.GB31449@orion.maiolino.org>
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
To: xfs@oss.sgi.com

This looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
> +
> +		lnumber=`echo $i | cut -d '-' -f 1`
> +		rnumber=`echo $i | cut -d '-' -f 2`
> +
> +		while [ $lnumber -lt $rnumber ]; do
> +			lnumber=$(( $lnumber + 1 ))
> +			count=$(( $count + 1 ))
> +		done
> +	done
> +
> +	echo $count
> +}
> +
>  run_check()
>  {
>  	echo "# $@" >> $seqres.full 2>&1
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
