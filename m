Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B6447F52
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 21:31:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 904B6AC002
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 19:31:19 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id WG8CcNmqVfpDO61e (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 19:31:14 -0700 (PDT)
Date: Thu, 31 Oct 2013 10:31:01 +0800
From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH v2] xfstests: add regression test for running btrfs
	balance and defrag concurrently
Message-ID: <20131031023100.GA23474@localhost.localdomain>
References: <1383142372-18852-1-git-send-email-bo.li.liu@oracle.com>
	<20131030221027.GI6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131030221027.GI6188@dastard>
Reply-To: bo.li.liu@oracle.com
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
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 31, 2013 at 09:10:27AM +1100, Dave Chinner wrote:
> On Wed, Oct 30, 2013 at 10:12:52PM +0800, Liu Bo wrote:
> > The test aims to trigger snapshot-aware defrag path in write endio by
> > running balance, which is not expected and leads to a crash.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: remove useless words as required.
> > 
> >  tests/btrfs/021     |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/021.out |    2 +
> >  tests/btrfs/group   |    1 +
> >  3 files changed, 93 insertions(+), 0 deletions(-)
> >  create mode 100755 tests/btrfs/021
> >  create mode 100644 tests/btrfs/021.out
> > 
> > diff --git a/tests/btrfs/021 b/tests/btrfs/021
> > new file mode 100755
> > index 0000000..23eff47
> > --- /dev/null
> > +++ b/tests/btrfs/021
> > @@ -0,0 +1,90 @@
> > +#! /bin/bash
> > +# FS QA Test No. 021
> > +#
> > +# A regression test of running btrfs balance and defrag concurrently.
> > +#
> > +# The test aims to trigger snapshot-aware defrag path in endio by
> > +# running balance, which is not expected and leads to a crash.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2013 Oracle.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +run_test()
> > +{
> > +	$BTRFS_UTIL_PROG balance start $SCRATCH_MNT >> $seqres.full &
> > +
> > +	sleep 0.5
> > +
> > +	find $SCRATCH_MNT -type f -print0 | xargs -0 $BTRFS_UTIL_PROG filesystem defrag -f
> 
> Lines longer than 80 columns.
> 
> > +
> > +	sync
> > +	wait
> > +}
> > +
> > +# Modify as appropriate.
> 
> Comment not needed.
> 
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs > /dev/null 2>&1
> > +_scratch_mount
> > +
> > +
> > +for ((j=0; j<100; j++))
> > +do
> > +	touch $SCRATCH_MNT/padding-$j
> > +done
> > +
> > +for ((j=0; j<50; j++))
> > +do
> > +	for i in `seq 20 -1 1`
> 
> Please us a single syntax for for loops.
> 
> for j in `seq 0 50`; do
> 	for i in `seq 20 -1 1`; do
> ...
> 
> > +	do
> > +		dd if=/dev/zero of=$SCRATCH_MNT/foo-$j bs=4k count=1 seek=$i oflag=direct conv=notrunc 2>/dev/null;
> > +	done
> 
> Using xfs_io is preferable to dd.
> 
> 		$XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
> 			$SCRATCH_MNT/foo-$j | _filter_xfs_io
> > +done
> > +
> > +sync
> 
> Why do direct IO if you then run sync? If you are trying to fragment
> the file, then please add a comment that you are doing a backwards
> write to fragment it and how it interacts with the "touch loop"
> above it. That way, if in future backwards writes are fixed to no
> longer fragment files, we know that this test needs a new method of
> fragmenting files...
> 
> > +# success, all done
> > +echo "Silence is golden"
> 
> And with the use of the _filter_xfs_io, you get detection of write
> failures due to xfs_io failures because the golden image match will
> fail....

Thanks for reviewing this, Dave, I'll follow the comments.

-liubo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
