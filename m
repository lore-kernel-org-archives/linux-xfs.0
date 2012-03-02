Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q223k92R234442 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 21:46:10 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id IENKdZOrWDFanwuV for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 19:46:08 -0800 (PST)
Message-ID: <4F50427F.3090204@sandeen.net>
Date: Thu, 01 Mar 2012 21:46:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 279: test mkfs with various sector sizes &
	alignments
References: <4F5005D1.6040208@redhat.com> <20120302001500.GC5091@dastard>
In-Reply-To: <20120302001500.GC5091@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 3/1/12 6:15 PM, Dave Chinner wrote:
> On Thu, Mar 01, 2012 at 05:27:13PM -0600, Eric Sandeen wrote:
>> This test uses the scsi_debug module to test mkfs against
>> various physical & logical sector sizes, and with aligned
>> and unaligned devices.
>>
>> Check out the scenarios in the test, I think I have the right
>> outcomes specified...
>>
>> Hope it's not looking too hacky.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/279 b/279
>> new file mode 100755
>> index 0000000..b7ad622
>> --- /dev/null
>> +++ b/279
>> @@ -0,0 +1,115 @@
>> +#! /bin/bash
>> +# FS QA Test No. 279
>> +#
>> +# Test mkfs.xfs against various types of devices with varying
>> +# logical & physical sector sizes and offsets.
> ....
>> +seq=`basename $0`
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=0	# failure is the default!
> 
> status=1 means failure is the default....

stupid cut & paste....

>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    cd /
>> +    rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common.rc
>> +. ./common.filter
>> +. ./common.scsi_debug
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_supported_os Linux
>> +
>> +_require_scsi_debug
>> +
>> +rm -f $seq.full
>> +
>> +_get_sector_size()
>> +{
>> +	xfs_db -c "sb 0" -c "p sectsize" $SCSI_DEBUG_DEV | awk '{print $3}'
>> +}
> 
> Hmmm. seems unnecessary - can be got from mkfs output.

Thanks, forgot about that trick.

>> +
>> +_wipe_device()
>> +{
>> +	device=$1
>> +	dd if=/dev/zero of=$device bs=4k count=1 &> /dev/null
>> +}
>> +
>> +_check_mkfs()
>> +{
>> +	echo "===================" | tee -a $seq.full
>> +	echo "mkfs with opts: $@" | sed -e "s/\/dev\/sd./DEVICE/" | tee -a $seq.full
> 
> you could use sed's alternative delimiter to avoid needing to escape
> the path name. i.e | sed -e "s,/dev/sd.,DEVICE,"

good idea.

>> +	mkfs.xfs $@ >> $seq.full 2>&1
> 
> mkfs.xfs $@ | tee -a $seq.full | filter_mkfs 2> $tmp.mkfs
> 
>> +	if [ $? -ne 0 ]; then
>> +		echo "Failed." | tee -a $seq.full
>> +		return
>> +	fi
>> +	echo "Passed." | tee -a $seq.full
> 
> 
>> +	echo -n "Got sector size: " | tee -a $seq.full
> 
> . $tmp.mkfs
> echo -n "Got sector size: $sectsz " | tee -a $seq.full
> 
>> +	_get_sector_size | tee -a $seq.full
>> +	device=`echo $@ | awk '{print $NF}'`
>> +	_wipe_device $device
> 
> Not sure what this is supposed to do. The awk statement prints the
> number of fields in the input record, and _wipe_device uses that as
> a file name? What am I missing?

that '{print $NF}' prints the last field...

>> +}
> 
> pretty much the entire output of this function is teed to $seq.full.
> You could do that at the call site. i.e.
> 
> 	_check_mkfs .... | tee -a $seq.full
> 
> Even better:
> 
>> +
>> +# === 4k physical 512b logical aligned
>> +echo "===================" | tee -a $seq.full
>> +echo "4k physical 512b logical aligned" | tee -a $seq.full
>> +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 128`
>> +# sector size should default to 4k
>> +_check_mkfs "" $SCSI_DEBUG_DEV
>> +# blocksize smaller than physical sectorsize should revert to logical sectorsize
> 
> (missing a test case here?)

yep

>> +_put_scsi_debug_dev
> 
> (
> 	echo "==================="
> 	echo "4k physical 512b logical aligned"
> 	SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 128`
> 	# sector size should default to 4k
> 	_check_mkfs "" $SCSI_DEBUG_DEV
> 	# blocksize smaller than physical sectorsize should revert to logical sectorsize
> 	_put_scsi_debug_dev
> ) | tee -a $seq.full

ok... will see if I can get the right stuff to the right place ...

> .....
>> +
>> +exit
> 
> status=0
> exit
> 
>> +# Functions useful for tests on unique block devices
>> +#
>> +
>> +_require_scsi_debug()
>> +{
>> +	# make sure we have the module and it's not already used
>> +	modinfo scsi_debug 2>&1 > /dev/null || _notrun "scsi_debug module not found"
>> +	lsmod | grep -wq scsi_debug && _notrun "scsi_debug module in use"
>> +	# make sure it has the features we need
>> +	# logical/physical sectors plus unmap support all went in together
>> +	modinfo scsi_debug | grep -wq sector_size || _notrun "scsi_debug too old"
>> +}
> 
> Might work for modules, but what about CONFIG_SCSI_DEBUG=y? I
> thought you could do all this configuration stuff through the
> /sys/bus/scsi/drivers/scsi_debug interface so you didn't need to
> screw with modules and parameters?

sigh, have to handle them both I suppose.

/sys/bus/pseudo/drivers/scsi_debug actually...

# ls /sys/bus/pseudo/drivers/scsi_debug/
adapter0  bind         dif     every_nth  map        no_lun_0   num_tgts  scsi_level   unbind
add_host  delay        dix     fake_rw    max_luns   no_uld     opts      sector_size  virtual_gb
ato       dev_size_mb  dsense  guard      max_queue  num_parts  ptype     uevent       vpd_use_hostno

not sure offhand how to do things like set alignment there.

>> +
>> +# Args: [physical sector size, [logical sector size, [unaligned(0|1), [size in megs]]]]
>> +_get_scsi_debug_dev()
>> +{
>> +	# Defaults to phys 512, logical 512, aligned
>> +	physical=${1-512}
>> +	logical=${2-512}
>> +	unaligned=${3-0}
>> +	size=${4-128}
>> +
>> +	phys_exp=0
>> +	while [ $logical -lt $physical ]; do
>> +		let physical=physical/2
>> +		let phys_exp=phys_exp+1
>> +	done
>> +	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size"
>> +	echo "scsi_debug options $opts" >> $seq.full
>> +	modprobe scsi_debug $opts
>> +	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
>> +	sleep 1
>> +	device=`grep -wl scsi_debug /sys/block/sd*/device/model | awk -F / '{print $4}'`
>> +	echo "/dev/$device"
>> +}
>> +
>> +_put_scsi_debug_dev()
>> +{
>> +	sleep 1
>> +	rmmod scsi_debug || _fail "Could not remove scsi_debug module"
>> +}
> 
> What is the sleep for?


Module stays busy w/o it and the rmmod fails, not sure why offhand.... which probably makes it not very robust :)

-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
