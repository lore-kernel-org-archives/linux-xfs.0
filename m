Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q224T38r242264 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 22:29:03 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iKukXA8F03KkTOth for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 20:29:01 -0800 (PST)
Date: Fri, 2 Mar 2012 15:28:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 279: test mkfs with various sector sizes &
	alignments
Message-ID: <20120302042858.GE5091@dastard>
References: <4F5005D1.6040208@redhat.com> <20120302001500.GC5091@dastard>
	<4F50427F.3090204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F50427F.3090204@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 01, 2012 at 09:46:07PM -0600, Eric Sandeen wrote:
> On 3/1/12 6:15 PM, Dave Chinner wrote:
> > On Thu, Mar 01, 2012 at 05:27:13PM -0600, Eric Sandeen wrote:
> >> +	_get_sector_size | tee -a $seq.full
> >> +	device=`echo $@ | awk '{print $NF}'`
> >> +	_wipe_device $device
> > 
> > Not sure what this is supposed to do. The awk statement prints the
> > number of fields in the input record, and _wipe_device uses that as
> > a file name? What am I missing?
> 
> that '{print $NF}' prints the last field...

/me slaps forehead. NF and $NF give different things..

> >> +# Functions useful for tests on unique block devices
> >> +#
> >> +
> >> +_require_scsi_debug()
> >> +{
> >> +	# make sure we have the module and it's not already used
> >> +	modinfo scsi_debug 2>&1 > /dev/null || _notrun "scsi_debug module not found"
> >> +	lsmod | grep -wq scsi_debug && _notrun "scsi_debug module in use"
> >> +	# make sure it has the features we need
> >> +	# logical/physical sectors plus unmap support all went in together
> >> +	modinfo scsi_debug | grep -wq sector_size || _notrun "scsi_debug too old"
> >> +}
> > 
> > Might work for modules, but what about CONFIG_SCSI_DEBUG=y? I
> > thought you could do all this configuration stuff through the
> > /sys/bus/scsi/drivers/scsi_debug interface so you didn't need to
> > screw with modules and parameters?
> 
> sigh, have to handle them both I suppose.

Actaully, having looked at this, don't bother. Just use the module
version. Adding CONFIG_SCSI_DEBUG=y makes your system fail to boot
if you have /dev/sdaX entries as your boot device. The scsi debug
device becomes /dev/sda, and funnily enough stuff stops working
because /dev/sda2 isn't the root filesystem anymore...

> >> +_put_scsi_debug_dev()
> >> +{
> >> +	sleep 1
> >> +	rmmod scsi_debug || _fail "Could not remove scsi_debug module"
> >> +}
> > 
> > What is the sleep for?
> 
> Module stays busy w/o it and the rmmod fails, not sure why offhand....
> which probably makes it not very robust :)

Hmmm. We don't have any active references to it after mkfs exists.
Seems kind of strange. I've seen similar things with blkid running
probes in the background due to udev events when the device is first
created. Given that we are just running a mkfs on it, the lifetime
of the device is under a second, right? Perhaps adding a udev_settle
call after doing the modprobe might solve this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
