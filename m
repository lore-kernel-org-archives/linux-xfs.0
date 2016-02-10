Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 18ACD29DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 19:07:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5EEC304039
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 17:07:35 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yjVHWZ17DNxklpaU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 17:07:30 -0800 (PST)
Date: Tue, 9 Feb 2016 17:07:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/23] xfs: test rmapbt functionality
Message-ID: <20160210010723.GH6350@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209011348.23099.30668.stgit@birch.djwong.org>
	<20160209082639.GO19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209082639.GO19486@dastard>
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
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 07:26:40PM +1100, Dave Chinner wrote:
> On Mon, Feb 08, 2016 at 05:13:48PM -0800, Darrick J. Wong wrote:
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/xfs        |   44 ++++++++++++++++++++++
> >  tests/xfs/233     |   78 ++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/233.out |    6 +++
> >  tests/xfs/234     |   89 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/234.out |    6 +++
> >  tests/xfs/235     |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/235.out |   14 +++++++
> >  tests/xfs/236     |   93 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/236.out |    8 ++++
> >  tests/xfs/group   |    4 ++
> >  10 files changed, 450 insertions(+)
> >  create mode 100644 common/xfs
> >  create mode 100755 tests/xfs/233
> >  create mode 100644 tests/xfs/233.out
> >  create mode 100755 tests/xfs/234
> >  create mode 100644 tests/xfs/234.out
> >  create mode 100755 tests/xfs/235
> >  create mode 100644 tests/xfs/235.out
> >  create mode 100755 tests/xfs/236
> >  create mode 100644 tests/xfs/236.out
> > 
> > 
> > diff --git a/common/xfs b/common/xfs
> > new file mode 100644
> > index 0000000..2d1a76f
> > --- /dev/null
> > +++ b/common/xfs
> > @@ -0,0 +1,44 @@
> > +##/bin/bash
> > +# Routines for handling XFS
> > +#-----------------------------------------------------------------------
> > +#  Copyright (c) 2015 Oracle.  All Rights Reserved.
> > +#  This program is free software; you can redistribute it and/or modify
> > +#  it under the terms of the GNU General Public License as published by
> > +#  the Free Software Foundation; either version 2 of the License, or
> > +#  (at your option) any later version.
> > +#
> > +#  This program is distributed in the hope that it will be useful,
> > +#  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +#  GNU General Public License for more details.
> > +#
> > +#  You should have received a copy of the GNU General Public License
> > +#  along with this program; if not, write to the Free Software
> > +#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> > +#  USA
> > +#
> > +#  Contact information: Oracle Corporation, 500 Oracle Parkway,
> > +#  Redwood Shores, CA 94065, USA, or: http://www.oracle.com/
> > +#-----------------------------------------------------------------------
> > +
> > +_require_xfs_test_rmapbt()
> > +{
> > +	_require_test
> > +
> > +	if [ "$(xfs_info "$TEST_DIR" | grep -c "rmapbt=1")" -ne 1 ]; then
> > +		_notrun "rmapbt not supported by test filesystem type: $FSTYP"
> > +	fi
> > +}
> > +
> > +_require_xfs_scratch_rmapbt()
> > +{
> > +	_require_scratch
> > +
> > +	_scratch_mkfs > /dev/null
> > +	_scratch_mount
> > +	if [ "$(xfs_info "$SCRATCH_MNT" | grep -c "rmapbt=1")" -ne 1 ]; then
> > +		_scratch_unmount
> > +		_notrun "rmapbt not supported by scratch filesystem type: $FSTYP"
> > +	fi
> > +	_scratch_unmount
> > +}
> 
> No, not yet. :)
> 
> Wait until I get my "split common/rc" patchset out there, because it
> does not require:

Ok, I moved all the common/xfs stuff back to common/rc.

> 
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/xfs
> 
> This.
> 
> And i don't want to have to undo a bunch of stuff in tests yet. Just
> lump it all in common/rc for the moment.
> 
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs xfs
> > +_require_xfs_scratch_rmapbt
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs -d size=$((2 * 4096 * 4096)) -l size=4194304 > "$seqres.full" 2>&1
> > +_scratch_mount >> "$seqres.full" 2>&1
> 
> _scratch_mkfs_sized ?

Done.
> 
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    #rm -f $tmp.*
> 
> More random uncommenting needed.
> 
> > +
> > +echo "Check for damage"
> > +umount "$SCRATCH_MNT"
> > +_check_scratch_fs
> > +
> > +# success, all done
> > +status=0
> > +exit
> 
> Cull.

Done

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
