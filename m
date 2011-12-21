Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBLHmKJf046744 for <xfs@oss.sgi.com>; Wed, 21 Dec 2011 11:48:20 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 0NtDnDmJS1CSWOSC for <xfs@oss.sgi.com>;
	Wed, 21 Dec 2011 09:48:17 -0800 (PST)
Message-ID: <4EF21BE0.4020009@sandeen.net>
Date: Wed, 21 Dec 2011 11:48:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: new check 276 to ensure btrfs backref integrity
References: <1323264833-11075-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1323264833-11075-1-git-send-email-list.btrfs@jan-o-sch.net>
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
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 12/7/11 7:33 AM, Jan Schmidt wrote:
> This is a btrfs specific scratch test checking the backref walker. It
> creates a file system with compressed and uncompressed data extents, picks
> files randomly and uses filefrag to get their extents. It then asks the
> btrfs utility (inspect-internal) to do the backref resolving from fs-logical
> address (the one filefrag calls "physical") back to the inode number and
> file-logical offset, verifying the result.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  276           |  230 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  276.out       |    4 +
>  common.config |    1 +
>  group         |    1 +
>  4 files changed, 236 insertions(+), 0 deletions(-)
>  create mode 100755 276
>  create mode 100644 276.out
> 
> diff --git a/276 b/276
> new file mode 100755
> index 0000000..f22d089
> --- /dev/null
> +++ b/276
> @@ -0,0 +1,230 @@
> +#! /bin/bash

Please put copyright, license, test description etc here, following other
existing tests as a template.

> +# creator
> +owner=list.btrfs@jan-o-sch.net
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +# 1=production, 0=avoid touching the scratch dev (no mount/umount, no writes)
> +fresh=1

I asked this on IRC but it seems unlikely that this will ever be changed.
Is this essentially so you can debug a failure?  Might be worth a comment
about under what conditions you would set it to 0.

> +tmp=/tmp/$$
> +status=1
> +FSTYP=btrfs

probably should not be explicitly set; no other test does this.

> +
> +_cleanup()
> +{
> +	if [ $fresh -ne 0 ]; then
> +		echo "*** unmount" 
> +		umount $SCRATCH_MNT 2>/dev/null
> +	fi
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +
> +if [ $fresh -ne 0 ]; then
> +	_require_scratch
> +fi

If fresh == 0 then what device gets tested?

> +_require_nobigloopfs
> +
> +[ -n "$BTRFS_UTIL_PROG" ] || _notrun "btrfs executable not found"
> +$BTRFS_UTIL_PROG inspect-internal --help >/dev/null 2>&1
> +[ $? -eq 0 ] || _notrun "btrfs executable too old"
> +which filefrag >/dev/null 2>&1
> +[ $? -eq 0 ] || _notrun "filefrag missing"

It might be nice to put these checks into (a) common.* file(s) if they
might be useful in other tests going forward.

> +
> +
> +rm -f $seq.full
> +

comment on this filter's function please? :)

> +FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
> +'$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
> +'\s+(\d+)\s+(?:(\d+)\s+)?(\d+)\s+(.*)/) or next; $flags =~ '\
> +'/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
> +'$length * $blocksize, "#", $logical * $blocksize, " "'
> +
> +_filter_extents()
> +{
> +	tee -a $seq.full | $PERL_PROG -ne "$FILEFRAG_FILTER"
> +}
> +
> +_check_file_extents()
> +{
> +	cmd="filefrag -vx $1"
> +	echo "# $cmd" >> $seq.full
> +	out=`$cmd | _filter_extents`
> +	if [ -z "$out" ]; then
> +		return 1
> +	fi
> +	echo "after filter: $out" >> $seq.full
> +	echo $out
> +	return 0
> +}

maybe this should go in a common.* if it might be generically useful (see common.defrag, maybe)

Can leave that to your judgement though.

> +_btrfs_inspect_addr()

I could really do with some comments explaining what this is doing, but then
I am woefully btrfs-illiterate.

> +{
> +	mp=$1
> +	addr=$2
> +	expect_addr=$3
> +	expect_inum=$4
> +	file=$5
> +	cmd="$BTRFS_UTIL_PROG inspect-internal logical-resolve -P $addr $mp"
> +	echo "# $cmd" >> $seq.full
> +	out=`$cmd`
> +	echo "$out" >> $seq.full
> +	grep_expr="inode $expect_inum offset $expect_addr root"
> +	echo "$out" | grep "^$grep_expr 5$" >/dev/null
> +	ret=$?
> +	if [ $ret -eq 0 ]; then
> +		# look for a root number that is not 5
> +		echo "$out" | grep "^$grep_expr \([0-46-9][0-9]*\|5[0-9]\+\)$" \
> +			>/dev/null
> +		ret=$?
> +	fi
> +	if [ $ret -eq 0 ]; then
> +		return 0
> +	fi
> +	echo "unexpected output from"
> +	echo "	$cmd"
> +	echo "expected inum: $expect_inum, expected address: $expect_addr,"\
> +		"file: $file, got:"
> +	echo "$out"
> +	return 1
> +}
> +
> +_btrfs_inspect_inum()
> +{
> +	file=$1
> +	inum=$2
> +	snap_name=$3
> +	mp="$SCRATCH_MNT/$snap_name"

Hm you conditionally required scratch, but use it here unconditionally I think?  Unless
this is only called conditionally ... but I think you get here either way.

> +	cmd="$BTRFS_UTIL_PROG inspect-internal inode-resolve $inum $mp"
> +	echo "# $cmd" >> $seq.full
> +	out=`$cmd`
> +	echo "$out" >> $seq.full
> +	grep_expr="^$file$"
> +	cnt=`echo "$out" | grep "$grep_expr" | wc -l`
> +	if [ $cnt -ge "1" ]; then
> +		return 0
> +	fi
> +	echo "unexpected output from"
> +	echo "	$cmd"
> +	echo "expected path: $file, got:"
> +	echo "$out"
> +	return 1
> +}
> +
> +_btrfs_inspect_check()
> +{
> +	file=$1
> +	physical=$2
> +	length=$3
> +	logical=$4
> +	snap_name=$5
> +	cmd="stat -c %i $file"
> +	echo "# $cmd" >> $seq.full
> +	inum=`$cmd`
> +	echo "$inum" >> $seq.full
> +	_btrfs_inspect_addr "$SCRATCH_MNT/$snap_name" $physical $logical $inum\
> +			$file

scratch used unconditionally here as well?

> +	ret=$?
> +	if [ $ret -eq 0 ]; then
> +		_btrfs_inspect_inum $file $inum $snap_name
> +		ret=$?
> +	fi
> +	return $?
> +}
> +
> +run_check()
> +{
> +	echo "# $@" >> $seq.full 2>&1
> +	"$@" >> $seq.full 2>&1 || _fail "failed: '$@'"
> +}

Hm, that is handy.  :)

> +workout()
> +{
> +	fsz=$1
> +	nfiles=$2
> +	procs=$3
> +	snap_name=$4
> +
> +	if [ $fresh -ne 0 ]; then
> +		umount $SCRATCH_DEV >/dev/null 2>&1
> +		echo "*** mkfs -dsize=$fsz"    >>$seq.full
> +		echo ""                                     >>$seq.full
> +		_scratch_mkfs_sized $fsz >>$seq.full 2>&1 \
> +			|| _fail "size=$fsz mkfs failed"
> +		_scratch_mount                              >>$seq.full 2>&1 \
> +			|| _fail "mount failed"
> +		# -w ensures that the only ops are ones which cause write I/O
> +		run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 1000 \
> +			$FSSTRESS_AVOID
> +
> +		run_check $BTRFS_UTIL_PROG subvol snap $SCRATCH_MNT \
> +			$SCRATCH_MNT/$snap_name
> +
> +		run_check umount $SCRATCH_DEV >/dev/null 2>&1
> +		run_check _scratch_mount "-o compress=lzo"
> +
> +		# -w ensures that the only ops are ones which cause write I/O
> +		run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 2000 \
> +			$FSSTRESS_AVOID
> +	else
> +		echo "*** skipping mkfs part"	>>$seq.full
> +	fi
> +
> +	cnt=0
> +	errcnt=0
> +	dir="$SCRATCH_MNT/$snap_name/"
> +	for file in `find $dir -name f\* -size +0 | sort -R`; do
> +		extents=`_check_file_extents $file`
> +		ret=$?
> +		if [ $ret -ne 0 ]; then
> +			continue;
> +		fi
> +		for i in $extents; do
> +			physical=$i
> +			length=$i
> +			logical=$i
> +			physical=`echo $physical | sed -e 's/#.*//'`
> +			length=`echo $length | sed -e 's/[^#]+#//'`
> +			length=`echo $length | sed -e 's/#.*//'`
> +			logical=`echo $logical | sed -e 's/.*#//'`
> +			_btrfs_inspect_check $file $physical $length $logical \
> +						$snap_name
> +			ret=$?
> +			if [ $ret -ne 0 ]; then
> +				errcnt=`expr $errcnt + 1`
> +			fi
> +		done
> +		cnt=`expr $cnt + 1`
> +		if [ $cnt -ge $nfiles ]; then
> +			break
> +		fi
> +	done
> +	if [ $errcnt -gt 0 ]; then
> +		echo "test failed: $errcnt error(s)"
> +	fi
> +}
> +
> +echo "*** test backref walking"
> +
> +snap_name="snap1"
> +filesize=`expr 2000 \* 1024 \* 1024`
> +nfiles=4
> +numprocs=1
> +
> +workout $filesize $nfiles $numprocs $snap_name
> +
> +echo "*** done"
> +status=0
> +exit
> diff --git a/276.out b/276.out
> new file mode 100644
> index 0000000..2032dea
> --- /dev/null
> +++ b/276.out
> @@ -0,0 +1,4 @@
> +QA output created by 276
> +*** test backref walking
> +*** done
> +*** unmount
> diff --git a/common.config b/common.config
> index 1df2bbd..7bed1c5 100644
> --- a/common.config
> +++ b/common.config
> @@ -185,6 +185,7 @@ case "$HOSTOS" in
>          export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
>          export MKFS_UDF_PROG="`set_prog_path mkudffs`"
>          export MKFS_BTRFS_PROG="`set_prog_path mkfs.btrfs`"
> +        export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
>          export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
>          export MKFS_NFS_PROG="false"
>          ;;
> diff --git a/group b/group
> index 08d999a..dd9f00d 100644
> --- a/group
> +++ b/group
> @@ -389,3 +389,4 @@ deprecated
>  273 auto rw
>  274 auto rw
>  275 auto rw
> +276 auto rw metadata

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
