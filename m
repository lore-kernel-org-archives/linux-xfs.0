Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96B267F69
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 18:24:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 863F28F8033
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 16:24:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	acWnlColdPTxWUTd for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 16:24:16 -0700 (PDT)
Date: Thu, 5 Sep 2013 09:24:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix device lookup in btrfs/003
Message-ID: <20130904232412.GM23571@dastard>
References: <52266055.9050004@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52266055.9050004@suse.com>
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
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

Add xfs@oss.sgi.com to the cc list.

On Tue, Sep 03, 2013 at 06:19:01PM -0400, Jeff Mahoney wrote:
> The DEVHTL lookup in btrfs/003 is broken. It can only handle full LUNs and
> not partitions on a disk.
> 
> Rather than returning 2:0:0:0 for /dev/sdc7, it returns 'block' and we see:
> ./common/rc: line 2081: /sys/class/scsi_device/block/device/delete:
> No such file or directory
> 
> If we look up the device by dev instead of by name, we can handle working
> with full disks and partitions more easily and get the ability to use
> any device name rather than just the ones that match sysfs.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  tests/btrfs/003 |   18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> --- a/tests/btrfs/003
> +++ b/tests/btrfs/003
> @@ -137,9 +137,21 @@ _test_replace()
>  	#pick the 2nd last disk 
>  	ds=${devs[@]:$(($n-1)):1}
>  
> -	# retrive the HTL for this scsi disk
> -	d=`echo $ds|cut -d"/" -f3`
> -	DEVHTL=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
> +	HEXMAJOR="$(stat -c "%t" "$ds")"
> +	HEXMINOR="$(stat -c "%T" "$ds")"
> +	if [ -z "$HEXMAJOR" -o -z "$HEXMINOR" ]; then
> +		_fail "tr: HEXMAJOR and/or HEXMINOR is unset for $ds"
> +	fi
> +
> +	DIR="/sys/dev/block/$(( 0x$HEXMAJOR )):$(( 0x$HEXMINOR ))"
> +
> +	if [ -L "$DIR/device" ]; then # whole disk
> +		DEVHTL="$(basename $(readlink "$DIR/device"))"
> +	elif [ -L "$DIR/../device" ]; then # partition
> +		DEVHTL="$(basename $(readlink "$DIR/../device"))"
> +	else
> +		_fail "tr: Can't locate device backing $ds"
> +	fi
>  
>  	#fail disk
>  	_devmgt_remove ${DEVHTL}
> 
> --
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
