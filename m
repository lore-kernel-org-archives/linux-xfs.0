Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39362 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965034AbeEIQXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 12:23:08 -0400
Date: Wed, 9 May 2018 09:22:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: limit xfs_growfs size if test with --large-fs
Message-ID: <20180509162248.GT11261@magnolia>
References: <20180427082254.25524-1-zlang@redhat.com>
 <20180509160214.GK8373@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509160214.GK8373@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, May 10, 2018 at 12:02:14AM +0800, Eryu Guan wrote:
> [cc linux-xfs list for xfs test]
> 
> On Fri, Apr 27, 2018 at 04:22:54PM +0800, Zorro Lang wrote:
> > When test on large SCRATCH_DEV, grow a small XFS to huge size is a
> > horrible thing (e.g grow 128m to 500T). So add a helper named
> > _scratch_xfs_growfs_limited() to do below things:
> > 
> > 1) If --large-fs is used, limit growfs size.
> > 2) If a limit size parameter is specified, make sure growfs won't
> > beyond this size.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> 
> Sorry for the late review..
> 
> This looks fine to me, but I'd like to let XFS developers to take a look
> too, I'm not sure if "10 times larger" is a sane default value.
> 
> BTW, the subject doesn't quite describe what the patch does:
> 
> "xfs: limit xfs_growfs size if test with --large-fs"
> 
> The patch also limits the growfs size based on the user-specified fs
> size.

Agreed.

> > ---
> >  common/xfs    | 34 ++++++++++++++++++++++++++++++++++
> >  tests/xfs/002 |  2 +-
> >  tests/xfs/127 |  2 +-
> >  tests/xfs/233 |  2 +-
> >  4 files changed, 37 insertions(+), 3 deletions(-)
> > 
> > diff --git a/common/xfs b/common/xfs
> > index e0bc3f43..6200297c 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -721,3 +721,37 @@ _require_xfs_db_write_array()
> >  	rm -f $TEST_DIR/$seq.img
> >  	[ $supported -eq 0 ] && _notrun "xfs_db write can't support array"
> >  }
> > +
> > +# If test on large device or a limit size is specified, this helper make sure
> > +# xfs_growfs won't beyond this limit (try to grow 10 times current fs size by
> > +# default).
> > +#   usage: _scratch_xfs_growfs_limited [size_by_byte]
> > +_scratch_xfs_growfs_limited()
> 
> I think we could just name it as _scratch_xfs_growfs().

And tweak the documentation to make its behavior clearer:

"Grows the mounted scratch filesystem.

"If max_size_in_bytes is specified, the filesystem will not be grown
larger than that size.  Otherwise, if LARGE_SCRATCH_DEV == yes, the
filesystem will not be grown larger than 10x the current size.  If
max_size_in_bytes is not specified and LARGE_SCRATCH_DEV != yes, the
scratch filesystem will be expanded to fit the scratch device."

Assuming that's the intended behavior.

--D

> 
> Thanks,
> Eryu
> 
> > +{
> > +
> > +	local limit_size="$1"
> > +	local option=""
> > +
> > +	if [ "$LARGE_SCRATCH_DEV" = "yes" -o -n "$limit_size" ]; then
> > +		local tmp=`mktemp -u`
> > +		xfs_info $SCRATCH_MNT | _filter_mkfs > /dev/null 2>$tmp.info
> > +		. $tmp.info
> > +		rm -f $tmp.info
> > +
> > +		local fs_size=$((dbsize * dblocks))
> > +		local dev_size_kb=`_get_device_size $SCRATCH_DEV`
> > +
> > +		# default limit_size is 10 times current fs size.
> > +		if [ -z "$limit_size" ]; then
> > +			limit_size=$((fs_size * 10))
> > +		fi
> > +		# don't limit growfs size if device size is smaller
> > +		if [ $((dev_size_kb * 1024)) -gt $limit_size ]; then
> > +			option="-D $((limit_size / dbsize))"
> > +		else
> > +			option=""
> > +		fi
> > +	fi
> > +
> > +	$XFS_GROWFS_PROG $option $SCRATCH_MNT
> > +}
> > diff --git a/tests/xfs/002 b/tests/xfs/002
> > index 741117be..42d2e2d7 100755
> > --- a/tests/xfs/002
> > +++ b/tests/xfs/002
> > @@ -68,7 +68,7 @@ _scratch_xfs_db -x -c "sb 2" -c "type data" -c "write fill 0xff 224 4"
> >  _scratch_mount
> >  
> >  # This should pass
> > -$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "growfs failed"
> > +_scratch_xfs_growfs_limited >> $seqres.full 2>&1 || _fail "growfs failed"
> >  
> >  # success, all done
> >  status=0
> > diff --git a/tests/xfs/127 b/tests/xfs/127
> > index 9df99904..c05fcee9 100755
> > --- a/tests/xfs/127
> > +++ b/tests/xfs/127
> > @@ -61,7 +61,7 @@ _cp_reflink $testdir/original $testdir/copy1
> >  _cp_reflink $testdir/copy1 $testdir/copy2
> >  
> >  echo "Grow fs"
> > -$XFS_GROWFS_PROG $SCRATCH_MNT 2>&1 |  _filter_growfs >> $seqres.full
> > +_scratch_xfs_growfs_limited 2>&1 | _filter_growfs >> $seqres.full
> >  _scratch_cycle_mount
> >  
> >  echo "Create more reflink copies"
> > diff --git a/tests/xfs/233 b/tests/xfs/233
> > index e61c444d..a0dd42e7 100755
> > --- a/tests/xfs/233
> > +++ b/tests/xfs/233
> > @@ -59,7 +59,7 @@ cp -p $testdir/original $testdir/copy1
> >  cp -p $testdir/copy1 $testdir/copy2
> >  
> >  echo "Grow fs"
> > -$XFS_GROWFS_PROG $SCRATCH_MNT 2>&1 |  _filter_growfs >> $seqres.full
> > +_scratch_xfs_growfs_limited 2>&1 |  _filter_growfs >> $seqres.full
> >  _scratch_cycle_mount
> >  
> >  echo "Create more copies"
> > -- 
> > 2.14.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
