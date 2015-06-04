Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 579707FF9
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 10:54:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46F1B304048
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 08:54:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n6yIubBvuICugokc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 08:54:00 -0700 (PDT)
Date: Thu, 4 Jun 2015 11:53:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfstests/xfs: test inode allocation with fragmented free
	space
Message-ID: <20150604155356.GA62425@bfoster.bfoster>
References: <1433358506-27002-1-git-send-email-bfoster@redhat.com>
	<20150603223204.GF9143@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150603223204.GF9143@dastard>
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

On Thu, Jun 04, 2015 at 08:32:04AM +1000, Dave Chinner wrote:
> On Wed, Jun 03, 2015 at 03:08:26PM -0400, Brian Foster wrote:
> > XFS dynamic inode allocation has a fundamental limitation in that an
> > inode chunk requires a contiguous extent of a minimum size. Depending on
> > the level of free space fragmentation, inode allocation can fail with
> > ENOSPC where the filesystem might not be near 100% usage.
> > 
> > The sparse inodes feature was implemented to provide an inode allocation
> > strategy that maximizes the ability to allocate inodes under free space
> > fragmentation. This test fragments free space and verifies that
> > filesystems that support sparse inode allocation can allocate a minimum
> > percentage of inodes on the fs.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > This is a test I've been using to verify the effectiveness of the XFS
> > sparse inodes feature. I put some effort into trying to make it generic
> > and have kind of gone back and forth on the matter. That said, it's kind
> > of pointless on ext4, doesn't work well on btrfs because it doesn't
> > track inode counts, and is generally expected to fail on XFS filesystems
> > without sparse inodes support.
> > 
> > Given all of that, I kind of went in the other direction and let it run
> > only for XFS when sparse inodes is supported. We still have broader
> > functional sparse inodes testability by virtue of DEBUG, of course.
> > Thoughts?
> 
> I think it's fine as an xfs specific test given the nature of what
> it is testing....
> > +
> > +_avail_bytes()
> > +{
> > +	avail_kb=`$DF_PROG $SCRATCH_MNT | tail -n1 | awk '{ print $5 }'`
> > +	echo $((avail_kb * 1024))
> 
> DF_PROG --output=avail ?
> 

Doesn't work with -P ($DF_PROG).

> And maybe should go into common/rc as _get_available_space, along
> with the _get_*_inode functions?
> 

Ok.

> > +
> > +_consume_freesp()
> > +{
> > +	file=$1
> > +
> > +	# consume nearly all available space (leave ~1MB)
> > +	avail=`_avail_bytes`
> > +	filesizemb=$((avail / 1024 / 1024 - 1))
> > +	$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $file \
> > +		2>> $seqres.full || _fail "falloc failed"
> > +}
> 
> Don't use _fail here - just have xfs_io output the error message
> and let the golden image catch it. It's only a small filesystem,
> if it fails it won't blow the runtime out badly, and we'll still get
> sparse inode test coverage...
> 

Ok.

> > +# Allocate inodes in a directory until failure.
> > +_alloc_inodes()
> > +{
> > +	dir=$1
> > +
> > +	i=0
> > +	while [ true ]; do
> > +		touch $dir/$i 2>> $seqres.full || break
> > +		i=$((i + 1))
> > +	done
> > +}
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +
> > +_require_scratch
> > +_require_xfs_io_command "falloc"
> > +_require_xfs_io_command "fpunch"
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Silence is golden."
> > +
> > +_scratch_mkfs_sized $((1024*1024*50)) | _filter_mkfs > /dev/null 2> $tmp.mkfs ||
> > +	_fail "mkfs failed"
> > +. $tmp.mkfs	# for isize
> 
> That should pass "-i sparse" to _scratch_mkfs_sized, after....
> 
> > +
> > +# This test runs a workload that is known to fail on XFS unless the sparse
> > +# inodes chunk feature is enabled. Skip the test if it is not supported to avoid
> > +# unnecessary and expected test failures.
> > +$XFS_DB_PROG -c version $SCRATCH_DEV | grep SPARSE_INODES > /dev/null ||
> > +	_notrun "requires sparse inodes support"
> 
> ... calling this:
> 
> _require_xfs_sparse_inodes()
> {
> 	_scratch_mkfs_xfs_supported -m crc=1 -i sparse > /dev/null 2>&1 \
> 		|| _notrun "mkfs.xfs does not support sparse inodes"
> 	_scratch_mkfs_xfs -m crc=1 -i sparse > /dev/null 2>&1
> 	_scratch_mount >/dev/null 2>&1 \
> 		|| _notrun "kernel does not support sparse inodes"
> 	umount $SCRATCH_MOUNT
> }
> 

Sounds good. So we'll always format with sparse inodes so long as it is
supported by the environment.

> > +
> > +_scratch_mount
> > +
> > +# magic heuristic value of 64 - # of inodes in an XFS inode record
> > +FRAG_FACTOR=$((isize * 64))
> > +[ $FRAG_FACTOR != 0 ] || _fail "could not calculate fragmentation factor"
> 
> Why would isize be zero? And what does this magic hueristic do?
> 

This is some historical checking that I don't quite recall the reasoning
for. It could have to do with making the test more generic, but it's
probably unnecessary at this point. I'll drop that check and add some
comments about the frag. factor.

> > +_consume_freesp $SCRATCH_MNT/spc
> > +
> > +offset=`stat -c "%s" $SCRATCH_MNT/spc`
> > +offset=$((offset - $FRAG_FACTOR * 2))
> 
> I dislike having to look up man pages to understand what code does.
> It is grabbing the file size, and stepping back a magic number from
> the EOF. I think it is punching inode chunk size holes in the file,
> but I could be mistaken...
> 

It's just setting the starting hole punch offset from the end of the
file. I'll add a comment to precede the algorithm that follows.

> > +while [ $offset -ge 0 ]; do
> > +	# punch small holes in the file to fragment free space
> > +	$XFS_IO_PROG -c "fpunch $offset $FRAG_FACTOR" $SCRATCH_MNT/spc \
> > +		2>> $seqres.full || _fail "fpunch failed"
> > +
> > +	# allocate as many inodes as possible
> > +	mkdir -p $SCRATCH_MNT/offset.$offset > /dev/null 2>&1
> > +	_alloc_inodes $SCRATCH_MNT/offset.$offset
> > +
> > +	offset=$((offset - $FRAG_FACTOR * 2))
> > +done
> > +
> > +# check the inode % usage
> > +iusepct=`$DF_PROG -i $SCRATCH_MNT | tail -n 1 | awk '{ print $6 }' |
> > +	 sed -e 's/%//'`
> 
> _get_inode_used_percent()
> {
> 	$DF_PROG --output=ipcent $SCRATCH_MNT | tail -1 | sed -e 's/%//'
> }
> 

Has the same --output problem, but I'll create the helper.

> > +if [ $iusepct -lt 95 ]; then
> 
> if [ ! _within_tolerance .... ]
> 

Ok.

> > +	$DF_PROG -i $SCRATCH_MNT
> > +	_fail "could not allocate enough inodes"
> > +fi
> > +
> > +_scratch_unmount
> 
> No need to unmount scratch here.
> 

Thanks.

Brian

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
