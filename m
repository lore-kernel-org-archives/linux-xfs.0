Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935383AbeE2QNG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 12:13:06 -0400
Date: Wed, 30 May 2018 00:13:04 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfstests/shared: dedup integrity test by duperemove
Message-ID: <20180529161304.GB4893@hp-dl360g9-06.rhts.eng.pek2.redhat.com>
References: <20180528045427.11159-1-zlang@redhat.com>
 <20180529150759.GC30110@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529150759.GC30110@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, May 29, 2018 at 08:07:59AM -0700, Darrick J. Wong wrote:
> On Mon, May 28, 2018 at 12:54:27PM +0800, Zorro Lang wrote:
> > Duperemove is a tool for finding duplicated extents and submitting
> > them for deduplication, and it supports XFS. This case trys to
> > verify the integrity of XFS after running duperemove.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > Hi,
> > 
> > There's not many softwares support XFS dedup now, duperemove is a rare one.
> > So I write this case by using duperemove.
> > 
> > I use fsstress to make many files and data randomly, I don't know if there're
> > better things I can use? Because fsstress only write '0xff' into files, maybe
> > I should add an option to make fsstress can write random character?
> 
> Heh.  But you probably don't want totally random contents because then
> dupremove doesn't do much.

No matter how random contents I get, I will copy once :)

> 
> > 
> > Please tell me, if you have better ideas:)
> > 
> > PS: This case test passed on XFS(with reflink=1) and btrfs. And the duperemove
> > can reclaim some space in the test, see below:
> > 
> >   Before duperemove
> >     Filesystem                 1K-blocks    Used Available Use% Mounted on
> >     /dev/mapper/xxxx-xfscratch 31441920K 583692K 30858228K   2% /mnt/scratch
> > 
> >   After duperemove
> >     Filesystem                 1K-blocks    Used Available Use% Mounted on
> >     /dev/mapper/xxxx-xfscratch 31441920K 345728K 31096192K   2% /mnt/scratch
> > 
> > Thanks,
> > Zorro
> > 
> >  common/config        |  1 +
> >  tests/shared/008     | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/shared/008.out |  2 ++
> >  tests/shared/group   |  1 +
> >  4 files changed, 92 insertions(+)
> >  create mode 100755 tests/shared/008
> >  create mode 100644 tests/shared/008.out
> > 
> > diff --git a/common/config b/common/config
> > index 02c378a9..def559c1 100644
> > --- a/common/config
> > +++ b/common/config
> > @@ -207,6 +207,7 @@ export SQLITE3_PROG="`set_prog_path sqlite3`"
> >  export TIMEOUT_PROG="`set_prog_path timeout`"
> >  export SETCAP_PROG="`set_prog_path setcap`"
> >  export GETCAP_PROG="`set_prog_path getcap`"
> > +export DUPEREMOVE_PROG="`set_prog_path duperemove`"
> >  
> >  # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
> >  # newer systems have udevadm command but older systems like RHEL5 don't.
> > diff --git a/tests/shared/008 b/tests/shared/008
> > new file mode 100755
> > index 00000000..dace5429
> > --- /dev/null
> > +++ b/tests/shared/008
> > @@ -0,0 +1,88 @@
> > +#! /bin/bash
> > +# FS QA Test 008
> > +#
> > +# Dedup integrity test by duperemove
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
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
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# duperemove only supports btrfs and xfs (with reflink feature).
> > +# Add other filesystems if it supports more later.
> > +_supported_fs xfs btrfs
> > +_supported_os Linux
> 
> _require_command "$DUPEREMOVE_PROG" duperemove ?

Yes, it would be better to use this template, not check
[ "$DUPEREMOVE_PROG" = "" ].

> 
> > +_require_scratch_reflink
> 
> _require_scratch_dedupe

Yes, I should check XFS_IOC_FILE_EXTENT_SAME, not XFS_IOC_CLONE*.

> 
> > +
> > +[ "$DUPEREMOVE_PROG" = "" ] && _notrun "duperemove not found"
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount >> $seqres.full 2>&1
> > +
> > +testdir=$SCRATCH_MNT/test-$seq
> > +mkdir $testdir
> > +
> > +fsstress_opts="-w -r -f mknod=0"
> > +# Create some files and make a duplicate
> > +$FSSTRESS_PROG $fsstress_opts -d $testdir \
> > +	       -n $((500 * LOAD_FACTOR)) -p 10 >/dev/null 2>&1
> > +duptestdir=${testdir}.dup
> > +cp -a $testdir $duptestdir
> > +
> > +# Make some difference in two directories
> > +$FSSTRESS_PROG $fsstress_opts -d $testdir -n 200 -p 5 >/dev/null 2>&1
> > +$FSSTRESS_PROG $fsstress_opts -d $duptestdir -n 200 -p 5 >/dev/null 2>&1
> > +
> > +# Record all files' md5 checksum
> > +find $testdir -type f -exec md5sum {} \; > $TEST_DIR/${seq}md5.sum
> > +find $duptestdir -type f -exec md5sum {} \; > $TEST_DIR/dup${seq}md5.sum
> > +
> > +# Dedup
> > +echo "== Duperemove output ==" >> $seqres.full
> > +$DUPEREMOVE_PROG -dr $SCRATCH_MNT/ >>$seqres.full 2>&1
> > +
> > +# Verify all files' integrity
> > +md5sum -c --quiet $TEST_DIR/${seq}md5.sum
> > +md5sum -c --quiet $TEST_DIR/dup${seq}md5.sum
> 
> Can we _scratch_mount_cycle and md5sum -c again so that we test that the
> pagecache contents don't mutate and a fresh read from the disk also
> doesn't show mutations?

If so, is the md5sum data safe? Should I do cycle_mount before get md5 checksum?
What 'fresh read' do you mean, from above duperemove processes? Or you hope to
read all files once before cycle_mount?

Thanks,
Zorro

> 
> --D
> 
> > +
> > +echo "Silence is golden"
> > +
> > +status=0
> > +exit
> > diff --git a/tests/shared/008.out b/tests/shared/008.out
> > new file mode 100644
> > index 00000000..dd68d5a4
> > --- /dev/null
> > +++ b/tests/shared/008.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 008
> > +Silence is golden
> > diff --git a/tests/shared/group b/tests/shared/group
> > index b3663a03..de7fe79f 100644
> > --- a/tests/shared/group
> > +++ b/tests/shared/group
> > @@ -10,6 +10,7 @@
> >  005 dangerous_fuzzers
> >  006 auto enospc
> >  007 dangerous_fuzzers
> > +008 auto quick dedupe
> >  032 mkfs auto quick
> >  272 auto enospc rw
> >  289 auto quick
> > -- 
> > 2.14.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
