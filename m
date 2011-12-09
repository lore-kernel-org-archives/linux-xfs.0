Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB9MPRHp236979 for <xfs@oss.sgi.com>; Fri, 9 Dec 2011 16:25:28 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC2DB1A62E26
	for <xfs@oss.sgi.com>; Fri,  9 Dec 2011 14:25:25 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2zHmNjEvhB5fpere for <xfs@oss.sgi.com>;
	Fri, 09 Dec 2011 14:25:25 -0800 (PST)
Date: Sat, 10 Dec 2011 09:25:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 276: Ensure lost+found is not created with
	wrong link count
Message-ID: <20111209222523.GF14273@dastard>
References: <1323449801-29183-1-git-send-email-cmaiolino@redhat.com>
	<4EE25FA2.4000102@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EE25FA2.4000102@sandeen.net>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Fri, Dec 09, 2011 at 01:21:06PM -0600, Eric Sandeen wrote:
> On 12/09/2011 10:56 AM, Carlos Maiolino wrote:
> > xfs_repair was leaving lost+found directory with a wrong link count when a
> > cleaned inode was re-used to create lost+found. This test case confirm that,
> > after xfs_repair is executed, the lost+found inode is left in a consistent
> > state.
> > See commit: 198b747f255346bca64408875763b6ca0ed3d57d from xfsprogs tree
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  276     |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  276.out |    2 +
> >  group   |    1 +
> >  3 files changed, 89 insertions(+), 0 deletions(-)
> >  create mode 100755 276
> >  create mode 100644 276.out
> > 
> > diff --git a/276 b/276
> > new file mode 100755
> > index 0000000..970169d
> > --- /dev/null
> > +++ b/276
> > @@ -0,0 +1,86 @@
> > +#! /bin/bash
> > +# FS QA Test No. 276
> > +#
> > +# Test xfs_repair to ensure it fixes the lost+found link count
> > +# at the first run. See also commit 198b747f255346bca64408875763b6ca0ed3d57d
> > +# from xfsprogs tree.
> > +# 
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
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
> > +# creator
> > +owner=cmaiolino@redhat.com
> > +
> > +seq=`basename $0`
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
> > +. ./common.rc
> > +. ./common.filter
> > +
> > +# real QA test starts here
> > +_supported_fs xfs 
> > +_supported_os Linux
> > +_require_scratch
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +
> > +mkdir -p $SCRATCH_MNT/dir/subdir
> > +
> > +#get inodes to be changed
> > +DIR_INO=`ls -i $SCRATCH_MNT |awk '{print $1}'`
> > +SUBDIR_INO=`ls -i $SCRATCH_MNT/dir |awk '{print $1}'`
> > +
> > +_scratch_unmount
> > +
> > +echo "Silence is goodness..."
> > +
> > +# Corrupt DIR
> > +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0" $SCRATCH_DEV > /dev/null 2>&1
> > +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0" $SCRATCH_DEV >/dev/null 2>&1
> > +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0" $SCRATCH_DEV >/dev/null 2>&1
> > +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0" $SCRATCH_DEV >/dev/null 2>&1
> > +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >/dev/null 2>&1
> > +xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >/dev/null 2>&1
> > +
> > +# Corrupt SUBDIR
> > +xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >/dev/null 2>&1
> > +xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >/dev/null 2>&1
> 
> You might want to capture the xfs_db output to hte output file,
> if it's not expected to change; that way if something fails, the test
> will fail properly

I'd just direct it to $seq.full, and not worry about whether it
succeeds or not, because the check will catch any errors in setting
bits.

> > +xfs_check $SCRATCH_DEV >/dev/null 2>&1

_check_scratch_fs  is the correct way to validate a scratch
filesystem from a test.

> > diff --git a/276.out b/276.out
> > new file mode 100644
> > index 0000000..8b8888b
> > --- /dev/null
> > +++ b/276.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 276
> > +Silence is goodness...
> > diff --git a/group b/group
> > index 08d999a..16e9f10 100644
> > --- a/group
> > +++ b/group
> > @@ -389,3 +389,4 @@ deprecated
> >  273 auto rw
> >  274 auto rw
> >  275 auto rw
> > +276 repair

Why not the auto group?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
