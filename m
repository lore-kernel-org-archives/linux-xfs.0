Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B0E0A7F66
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 20:21:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 829A330407B
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 18:21:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	r91jbPcriUuIv9tU for <xfs@oss.sgi.com>;
	Mon, 09 Jun 2014 18:21:52 -0700 (PDT)
Date: Tue, 10 Jun 2014 11:21:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: create a test for xfs log grant head leak
	detection
Message-ID: <20140610012149.GH4453@dastard>
References: <1402060483-22195-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402060483-22195-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 06, 2014 at 09:14:43AM -0400, Brian Foster wrote:
> Changes in the XFS logging code have lead to small leaks in the log
> grant heads that consume log space slowly over time. Such problems have
> gone undetected for an unnecessarily long time due to code complexity
> and potential for very subtle problems. Losing only a few bytes per
> logged item on a reasonably large enough fs (10s of GB) means only the
> most continuously stressful workloads will cause a severe enough failure
> (deadlock due to log reservation exhaustion) quickly enough to indicate
> something is seriously wrong.
> 
> Recent changes in XFS export the state of the various log heads through
> sysfs to aid in userspace/runtime analysis of the log. This test runs a
> workload against an XFS filesystem, quiesces the fs and verifies that
> the log reserve and write grant heads have not leaked any space with
> respect to the current head of the physical log.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
....
>
> +# Determine the system device name for a particular block device. The device
> +# name is how the block dev is referenced under sysfs.
> +_get_device_name()
> +{
> +	devpath=$1
> +
> +	# check for a symlink (i.e., device mapper)
> +	if [ -L $devpath ]
> +	then
> +		devpath=`readlink -f $devpath`
> +	fi
> +
> +	# grab the major minor and convert from hex to decimal
> +	major=$((0x`stat -c %t $devpath`))
> +	minor=$((0x`stat -c %T $devpath`))
> +
> +	# refer to sysfs by major minor
> +	basename `readlink /sys/dev/block/$major:$minor`
> +}

$ basename `readlink -f /dev/mapper/vg0-home`
dm-2
$ basename `readlink /sys/dev/block/253:2`
dm-2

Why is _short_dev() not sufficient?

> +# Use the information exported by XFS to sysfs to determine whether the log has
> +# active reservations after a filesystem freeze.
> +_check_scratch_log_state()
> +{
> +	devname=`_get_device_name $SCRATCH_DEV`
> +	attrpath="/sys/fs/xfs/$devname/log"
> +
> +	# freeze the fs to ensure data is synced and the log is flushed. this
> +	# means no outstanding transactions, and thus no outstanding log
> +	# reservations, should exist
> +	xfs_freeze -f $SCRATCH_MNT
> +
> +	# the log head is exported in basic blocks and the log grant heads in
> +	# bytes. convert the log head to bytes for precise comparison
> +	log_head_cycle=`cat $attrpath/log_head_lsn | awk -F : '{ print $1 }'`
> +	log_head_bytes=`cat $attrpath/log_head_lsn | awk -F : '{ print $2 }'`

awk can read files directly:

	log_head_cycle=`awk -F : '{ print $1 }' $attrpath/log_head_lsn`

> +	log_head_bytes=$((log_head_bytes * 512))
> +
> +	for attr in "reserve_grant_head" "write_grant_head"
> +	do
> +		cycle=`cat $attrpath/$attr | awk -F : '{ print $1 }'`
> +		bytes=`cat $attrpath/$attr | awk -F : '{ print $2 }'`
> +
> +		if [ $cycle != $log_head_cycle ] ||
> +		   [ $bytes != $log_head_bytes ]
> +		then
> +			echo "$attr ($cycle:$bytes) does not match" \
> +				"log_head_lsn ($log_head_cycle:$log_head_bytes)," \
> +				"possible leak detected."
> +		else
> +			echo "$attr matches log_head_lsn"
> +		fi
> +	done
> +
> +	xfs_freeze -u $SCRATCH_MNT
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_require_scratch
> +_require_freeze
> +
> +if [ ! -e /sys/fs/xfs ]
> +then
> +	_notrun "no kernel support for XFS sysfs attributes"
> +fi

_requires_xfs_sysfs

> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs_xfs | _filter_mkfs 2>> $seqres.full
> +_scratch_mount
> +
> +_check_scratch_log_state
> +
> +$FSSTRESS_PROG -d $SCRATCH_MNT/fsstress -n 1000 -p 2 -S t \
> +	>> $seqres.full 2>&1
> +
> +_check_scratch_log_state

wouldn't it be better to run fsstress as a background process and do
several freeze/check/thaw cycles on a running workload?

> +
> +umount $SCRATCH_MNT
> +_check_scratch_fs
> +
> +status=0
> +exit
> diff --git a/tests/xfs/011.out b/tests/xfs/011.out
> new file mode 100644
> index 0000000..a3f3805
> --- /dev/null
> +++ b/tests/xfs/011.out
> @@ -0,0 +1,11 @@
> +QA output created by 011
> +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> +         = sunit=XXX swidth=XXX, unwritten=X
> +naming   =VERN bsize=XXX
> +log      =LDEV bsize=XXX blocks=XXX
> +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX

Any particular reason for dumping the filtered mkfs information
here? It won't ever cause a test failure unless we break
_filter_mkfs...

> +reserve_grant_head matches log_head_lsn
> +write_grant_head matches log_head_lsn
> +reserve_grant_head matches log_head_lsn
> +write_grant_head matches log_head_lsn
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 19fd968..99bf0e1 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -8,6 +8,7 @@
>  008 rw ioctl auto quick
>  009 rw ioctl auto prealloc quick
>  010 auto quick repair
> +011 auto quick freeze

log and metadata, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
