Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 147EB7F54
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 06:22:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E33238F807A
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 04:22:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DrhweuxQEonrF4py for
	<xfs@oss.sgi.com>; Tue, 10 Jun 2014 04:22:45 -0700 (PDT)
Date: Tue, 10 Jun 2014 07:22:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfstests: test speculative preallocation reclaim on
	ENOSPC/EDQUOT
Message-ID: <20140610112243.GB46344@bfoster.bfoster>
References: <1401807238-59437-1-git-send-email-bfoster@redhat.com>
	<20140610020626.GK4453@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140610020626.GK4453@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 10, 2014 at 12:06:26PM +1000, Dave Chinner wrote:
> On Tue, Jun 03, 2014 at 10:53:58AM -0400, Brian Foster wrote:
> > XFS can allocate significant amounts of space to files via speculative
> > preallocation. Such preallocation may not be reclaimed automatically on
> > file close() if a file is repeatedly opened and extended. For smaller
> > filesystems with relatively large and slow growing files, this
> > preallocation can linger for some time, including contributing to out of
> > space conditions.
> > 
> > Create a situation where an fs is near out of space while several files
> > still have lingering, significant preallocations. Verify that new
> > writers reclaim the preallocated space rather than return ENOSPC. Repeat
> > a similar test for quota limits and EDQUOT.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Couple of minor things.
> 
> > +# Create a file using a repeated open, extending write and close pattern. This
> > +# causes the preallocation to persist after the file is closed. Preallocation
> > +# will not be reclaimed unless the inode is evicted or we hit an allocation
> > +# failure.
> > +_spec_prealloc_file()
> > +{
> > +	file=$1
> > +
> > +	rm -f $file
> > +
> > +	# a few file extending open-write-close cycles should be enough to
> > +	# trigger the fs to retain preallocation. write 256k in 32k intervals to
> > +	# be sure
> > +	for i in $(seq 0 32768 262144)
> > +	do
> 
> 	for .... ; do
> 
> > +		$XFS_IO_PROG -fc "pwrite $i 32k" $file | \
> > +			_filter_xfs_io >> $seqres.full
> > +	done
> 
> If you are dumping the output into $seqres.full, then it doesn't
> need to be filtered. Filtering is only necessary for golden image
> matching; $seqres.full is for debug output and so should be
> pristine...
> 

Err... right. I think I was changing the output redirection around as I
was writing these tests and just lost track of the filtering. I'll fix
that.

> Also, I prefer $XFS_IO_PROG -f -c "..." (separate -c "...") because
> the -c arg must be followed by the command and so order is
> important...
> 

Ok.

> > +	# write a 4k aligned amount of data to keep the calculations simple
> > +	$XFS_IO_PROG -c "pwrite 0 128m" $file | _filter_xfs_io >> $seqres.full
> > +
> > +	size=`stat -c "%s" $file`
> > +	blocks=`stat -c "%b" $file`
> > +	blocksize=`stat -c "%B" $file`
> > +
> > +	prealloc_size=$((blocks * blocksize - size))
> > +	if [ $prealloc_size -eq 0 ]
> > +	then
> 
> 	if [ ... ]; then
> 
> > +		echo "Warning: No speculative preallocation for $file." \
> > +			"Check use of the allocsize= mount option."
> > +	fi
> > +
> > +	# keep a running total of how much preallocation we've created
> > +	TOTAL_PREALLOC=$((TOTAL_PREALLOC + prealloc_size))
> > +}
> > +
> > +_consume_free_space()
> > +{
> > +	dir=$1
> > +
> > +	# calculate the rough amount of free space in MB
> > +	fsblocksize=`$XFS_IO_PROG -x -c "statfs" $dir | grep f_bsize | \
> > +			awk '{ print $3 }'`
> > +	blocksavail=`$XFS_IO_PROG -x -c "statfs" $dir | grep f_bavail | \
> > +			awk '{ print $3 }'`
> > +	freesp=$((fsblocksize * blocksavail / 1024 / 1024))
> > +
> > +	# allocate all but 10MB
> > +	freesp=$((freesp - 10))
> 
> 	freesp=`$DF_PROG -m $dir | awk '/^\// { print $4 - 10 }'`
>  

Thanks. ;) The rest of the fixes look good to me so I'll get those in.
Thanks again for the review.

Brian

> > +	$XFS_IO_PROG -fc "falloc 0 ${freesp}M" $dir/spc
> > +}
> > +
> > +# Create several files with preallocation and consume the remaining free space
> > +# via fallocate to the put the fs at ENOSPC. Create a set of background writers
> > +# to write into ENOSPC and cause the preallocation to be reclaimed and
> > +# reallocated to the new writers.
> > +_test_enospc()
> > +{
> > +	dir=$1
> > +
> > +	rm -rf $dir/*
> > +
> > +	TOTAL_PREALLOC=0
> > +	for i in $(seq 0 3)
> > +	do
> 
> for (); do
> 
> > +		_spec_prealloc_file $dir/pre$i
> > +	done
> > +
> > +	_consume_free_space $dir
> > +
> > +	# consume 1/2 of the current preallocation across the set of 4 writers
> > +	write_size=$((TOTAL_PREALLOC / 2 / 4))
> > +	for i in $(seq 0 3)
> > +	do
> > +		$XFS_IO_PROG -fc "pwrite 0 $write_size" $dir/file.$i | \
> > +			_filter_xfs_io >> $seqres.full &
> 
> no filter, for (); do
> 
> > +	done
> > +
> > +	wait
> > +}
> > +
> > +# Create preallocations accounted by both user and group quotas. Set the
> > +# associated quota hard limits to put them at EDQUOT. Verify that a new writer
> > +# reclaims the preallocated space and proceeds without error.
> > +_test_edquot()
> > +{
> > +	dir=$1
> > +
> > +	rm -rf $dir/*
> > +
> > +	TOTAL_PREALLOC=0
> > +	_spec_prealloc_file $dir/user
> > +	chown $qa_user $dir/user
> > +
> > +	_spec_prealloc_file $dir/group
> > +	chgrp $qa_group $dir/group
> > +
> > +	# writing to a file under both quotas means both will be reclaimed on
> > +	# allocation failure
> > +	touch $dir/file
> > +	chown $qa_user $dir/file
> > +	chgrp $qa_group $dir/file
> > +
> > +	# put both quotas at EDQUOT
> > +	blks=`$XFS_QUOTA_PROG -xc "quota -u $qa_user" $dir | \
> > +		tail -n 1 | awk '{ print $2 }'`
> > +	$XFS_QUOTA_PROG -xc "limit -u bhard=${blks}k $qa_user" $dir
> > +	blks=`$XFS_QUOTA_PROG -xc "quota -g $qa_grup" $dir | \
> > +		tail -n 1 | awk '{ print $2 }'`
> > +	$XFS_QUOTA_PROG -xc "limit -g bhard=${blks}k $qa_group" $dir
> > +
> > +	# each quota has a single file worth of preallocation to reclaim. leave
> > +	# some wiggle room and write to 1/3 the total.
> > +	write_size=$((TOTAL_PREALLOC / 3))
> > +	$XFS_IO_PROG -c "pwrite 0 $write_size" $dir/file | \
> > +		_filter_xfs_io >> $seqres.full
> 
> no filter.
> 
> > +}
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +
> > +_require_scratch
> > +_require_xfs_io_command "falloc"
> > +_require_loop
> > +_require_quota
> > +_require_user
> > +_require_group
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs_xfs | _filter_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +# make sure the background eofblocks scanner doesn't interfere
> > +orig_sp_time=`cat /proc/sys/fs/xfs/speculative_prealloc_lifetime`
> > +echo 9999 > /proc/sys/fs/xfs/speculative_prealloc_lifetime
> > +
> > +LOOP_FILE=$SCRATCH_MNT/$seq.fs
> > +LOOP_MNT=$SCRATCH_MNT/$seq.mnt
> > +
> > +$MKFS_XFS_PROG -d "file=1,name=$LOOP_FILE,size=$((1024*1024*1024 * 10))" | \
> > +	_filter_mkfs >> $seqres.full 2>&1
> 
> mkfs takes "size=10g" as a valid size.
> 
> > +mkdir -p $LOOP_MNT
> > +mount -t xfs -o loop,uquota,gquota $LOOP_FILE $LOOP_MNT || \
> > +	_fail "Failed to mount loop fs."
> > +
> > +_test_enospc $LOOP_MNT
> > +_test_edquot $LOOP_MNT
> > +
> > +umount $LOOP_MNT
> > +
> > +echo $orig_sp_time > /proc/sys/fs/xfs/speculative_prealloc_lifetime
> > +
> > +umount $SCRATCH_MNT
> > +_check_scratch_fs
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/014.out b/tests/xfs/014.out
> > new file mode 100644
> > index 0000000..a825535
> > --- /dev/null
> > +++ b/tests/xfs/014.out
> > @@ -0,0 +1 @@
> > +QA output created by 014
> 
> The test writes nothing to the output file? Perhaps it should
> indicate that (silence is golden....)....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
