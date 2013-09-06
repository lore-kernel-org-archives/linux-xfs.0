Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6D9B27F50
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 09:03:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 03EEDAC001
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 07:03:44 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id iXbGcoogLDlXJ1MZ for <xfs@oss.sgi.com>;
	Fri, 06 Sep 2013 07:03:40 -0700 (PDT)
Date: Fri, 6 Sep 2013 16:03:37 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: fix device lookup in btrfs/003
Message-ID: <20130906140337.GK32382@twin.jikos.cz>
References: <52266055.9050004@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52266055.9050004@suse.com>
Reply-To: dsterba@suse.cz
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

The test assumes tha SCRATCH_DEV_POOL consists of standalone devices
and more strongly that they can be removed from the system by

$ echo 1 > /sys/class/scsi_device/sdx/device/delete

via _devmgt_remove. Ordinary sdX devices are ok, but eg. MD devices are
not because they do not have a corresponding "2:0:0:0"-like entry (I
haven't checked device-mapper devices).

Looks like the tests have to do more fine grained checks of the devices
in SCRATCH_DEV_POOL because eg. the 'device replace' test btrfs/011 is
just fine with partitions.


david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
