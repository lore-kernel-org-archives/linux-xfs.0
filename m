Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48053 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754372AbcK1RWx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 12:22:53 -0500
Date: Mon, 28 Nov 2016 09:22:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/3] ocfs2: test reflinking to inline data files
Message-ID: <20161128172245.GR16813@birch.djwong.org>
References: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
 <147986706651.27133.4210661621329152871.stgit@birch.djwong.org>
 <20161124015309.GC30324@birch.djwong.org>
 <20161124090148.GC4609@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161124090148.GC4609@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Nov 24, 2016 at 05:01:48PM +0800, Eryu Guan wrote:
> On Wed, Nov 23, 2016 at 05:53:09PM -0800, Darrick J. Wong wrote:
> > Make sure that we can handle reflinking from and to inline-data files.
> > This pounds on a regression test discovered while implementing ocfs2
> > reflink support.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: Format the fs with the feature flags we need.
> > ---
> >  tests/ocfs2/001      |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/ocfs2/001.out  |   14 ++++++++
> >  tests/ocfs2/Makefile |   20 +++++++++++
> >  tests/ocfs2/group    |    1 +
> >  4 files changed, 123 insertions(+)
> >  create mode 100755 tests/ocfs2/001
> >  create mode 100644 tests/ocfs2/001.out
> >  create mode 100644 tests/ocfs2/Makefile
> >  create mode 100644 tests/ocfs2/group
> > 
> > diff --git a/tests/ocfs2/001 b/tests/ocfs2/001
> > new file mode 100755
> > index 0000000..0f9765e
> > --- /dev/null
> > +++ b/tests/ocfs2/001
> > @@ -0,0 +1,88 @@
> > +#! /bin/bash
> > +# FS QA Test No. 001
> > +#
> > +# Ensure that reflink works correctly with inline-data files.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -rf $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs ocfs2
> > +_require_scratch
> 
> I think we still need _require_scratch_reflink, otherwise ocfs2 without
> clone_range support fails and reports Operation not supported.
> 
> But _require_scratch_reflink introduces another issue, it prints
> "mkfs.ocfs2 <ver_number>" at mkfs time and causes test to fail too. But
> I'm working on a patch to fix this in a general way, which also allows
> usage such as
> 
> "_scratch_mkfs --fs-features=local,unwritten,refcount,inline-data"
> 
> to succeed even if there're mkfs option conflicts between MKFS_OPTIONS,
> just like what _scratch_mkfs_xfs does (mkfs again without MKFS_OPTIONS).
> 
> I'll send my patch later after it passed my test run.

Ok.  I'll change it back to _require_scratch_reflink and resubmit.

> > +_require_cp_reflink
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs --fs-features=local,unwritten,refcount,inline-data > $seqres.full 2>&1
> > +tunefs.ocfs2 --query '%H' $SCRATCH_DEV | grep -q 'inline-data' || \
> > +	_notrun "Inline data is not supported."
> > +_scratch_mount >> $seqres.full 2>&1
> > +
> > +testdir=$SCRATCH_MNT/test-$seq
> > +mkdir $testdir
> > +
> > +sz=65536
> > +echo "Create the original files"
> > +$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
> > +echo x > $testdir/file2
> > +echo x > $testdir/file3
> > +echo y > $testdir/file4
> > +$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file5 >> $seqres.full
> > +echo a > $testdir/file6
> > +_scratch_cycle_mount
> > +
> > +echo "reflink into the start of file2"
> > +_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
> 
> I built and installed your ocfs2-vfs-reflink-3 branch and hit this test
> failure, is this expected?
> 
> bootp-73-5-234:~/xfstests # ./check -s ocfs2 ocfs2/001
> SECTION       -- ocfs2
> RECREATING    -- ocfs2 on /dev/sda3
> FSTYP         -- ocfs2
> PLATFORM      -- Linux/x86_64 bootp-73-5-234 4.9.0-rc6.djwong-ocfs2+
> MKFS_OPTIONS  -- --fs-features=local /dev/sda5
> MOUNT_OPTIONS -- /dev/sda5 /mnt/testarea/scratch
> 
> ocfs2/001        - output mismatch (see /root/xfstests/results//ocfs2/ocfs2/001.out.bad)
>     --- tests/ocfs2/001.out     2016-11-24 12:58:34.474925404 +0800
>     +++ /root/xfstests/results//ocfs2/ocfs2/001.out.bad 2016-11-24 16:41:57.307401368 +0800
>     @@ -2,13 +2,16 @@
>      Format and mount
>      Create the original files
>      reflink into the start of file2
>     +cp: failed to reflink '/mnt/testarea/scratch/test-001/file2' from '/mnt/testarea/scratch/test-001/file1': File exists
>      reflink past the stuff in file3
>      reflink an inline-data file to a regular one
>     +cp: failed to reflink '/mnt/testarea/scratch/test-001/file5' from '/mnt/testarea/scratch/test-001/file4': File exists


...no?

$ dpkg --status coreutils | grep Version
Version: 8.25-2ubuntu2

I could try changing the _cp_reflink definition to pass -f to cp.

--D

>     ...
> 
> Thanks,
> Eryu
> 
> > +
> > +echo "reflink past the stuff in file3"
> > +_reflink_range $testdir/file1 0 $testdir/file3 $sz $sz >> $seqres.full
> > +
> > +echo "reflink an inline-data file to a regular one"
> > +_cp_reflink $testdir/file4 $testdir/file5 >> $seqres.full
> > +
> > +echo "reflink an inline-data file to another inline-data file"
> > +_cp_reflink $testdir/file4 $testdir/file6 >> $seqres.full
> > +
> > +echo "Verify the whole mess"
> > +_scratch_cycle_mount
> > +md5sum $testdir/file* | _filter_scratch
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/ocfs2/001.out b/tests/ocfs2/001.out
> > new file mode 100644
> > index 0000000..99fa43a
> > --- /dev/null
> > +++ b/tests/ocfs2/001.out
> > @@ -0,0 +1,14 @@
> > +QA output created by 001
> > +Format and mount
> > +Create the original files
> > +reflink into the start of file2
> > +reflink past the stuff in file3
> > +reflink an inline-data file to a regular one
> > +reflink an inline-data file to another inline-data file
> > +Verify the whole mess
> > +2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-001/file1
> > +2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-001/file2
> > +4e68a2e24b6b0f386ab39d01d902293d  SCRATCH_MNT/test-001/file3
> > +009520053b00386d1173f3988c55d192  SCRATCH_MNT/test-001/file4
> > +009520053b00386d1173f3988c55d192  SCRATCH_MNT/test-001/file5
> > +009520053b00386d1173f3988c55d192  SCRATCH_MNT/test-001/file6
> > diff --git a/tests/ocfs2/Makefile b/tests/ocfs2/Makefile
> > new file mode 100644
> > index 0000000..70a4f16
> > --- /dev/null
> > +++ b/tests/ocfs2/Makefile
> > @@ -0,0 +1,20 @@
> > +#
> > +# Copyright (c) 2016 Oracle.  All Rights Reserved.
> > +#
> > +
> > +TOPDIR = ../..
> > +include $(TOPDIR)/include/builddefs
> > +
> > +OCFS2_DIR = ocfs2
> > +TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(OCFS2_DIR)
> > +
> > +include $(BUILDRULES)
> > +
> > +install:
> > +	$(INSTALL) -m 755 -d $(TARGET_DIR)
> > +	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> > +	$(INSTALL) -m 644 group $(TARGET_DIR)
> > +	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
> > +
> > +# Nothing.
> > +install-dev install-lib:
> > diff --git a/tests/ocfs2/group b/tests/ocfs2/group
> > new file mode 100644
> > index 0000000..28e6807
> > --- /dev/null
> > +++ b/tests/ocfs2/group
> > @@ -0,0 +1 @@
> > +001 auto quick clone
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
