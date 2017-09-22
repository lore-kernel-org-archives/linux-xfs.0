Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35608 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbdIVD75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 23:59:57 -0400
Date: Thu, 21 Sep 2017 20:59:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v5] xfs: Add test for CVE-2017-14340
Message-ID: <20170922035944.GD5728@magnolia>
References: <20170922023446.2616054-1-rwareing@fb.com>
 <20170922035407.GB8034@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922035407.GB8034@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Richard Wareing <rwareing@fb.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Sep 22, 2017 at 11:54:07AM +0800, Eryu Guan wrote:
> On Thu, Sep 21, 2017 at 07:34:46PM -0700, Richard Wareing wrote:
> > Verify kernel doesn't panic when user attempts to set realtime flags
> > on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.  Unpatched
> > kernels will panic during this test.  Kernels not compiled with
> > CONFIG_XFS_RT should pass test.
> > 
> > This bug was fixed via commit b31ff3cdf540110da4572e3e29bd172087af65cc
> > on the main kernel tree.
> > 
> > Signed-off-by: Richard Wareing <rwareing@fb.com>
> > ---
> > Changes since v4:
> > * Check inherit flag on scratch mount via lsattr + grep
> > 
> > Changes since v3:
> > * Tabs not spaces
> > * Test added to auto group
> > * _filter_xfs_io filter only
> > * Removed _require_test
> > 
> > Changes since v2:
> > * Added to dangerous group
> > 
> > Changes since v1:
> > * Corrected copyright text
> > 
> >  tests/xfs/431     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/431.out |  3 ++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 88 insertions(+)
> >  create mode 100755 tests/xfs/431
> >  create mode 100644 tests/xfs/431.out
> > 
> > diff --git a/tests/xfs/431 b/tests/xfs/431
> > new file mode 100755
> > index 0000000..414ec46
> > --- /dev/null
> > +++ b/tests/xfs/431
> > @@ -0,0 +1,84 @@
> > +#! /bin/bash
> > +# FS QA Test 431
> > +#
> > +# Verify kernel doesn't panic when user attempts to set realtime flags
> > +# on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.  Unpatched
> > +# kernels will panic during this test.  Kernels not compiled with
> > +# CONFIG_XFS_RT should pass test.
> > +#
> > +# See CVE-2017-14340 for more information.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017 Facebook, Inc.  All Rights Reserved.
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
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_xfs_io_command "chattr"
> > +_require_xfs_io_command "fsync"
> > +_require_xfs_io_command "pwrite"
> > +_require_scratch
> > +
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +
> > +# Set realtime inherit flag on scratch mount, suppress output
> > +# as this may simply error out on future kernels, we will check
> > +# exit code instead.
> > +$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT &> /dev/null
> > +
> > +# Erroring out here is fine, this would be desired behavior for
> > +# FSes without realtime devices present.
> > +if $XFS_IO_PROG -c 'lsattr' $SCRATCH_MNT |
> > +	grep '^[[:graph:]]\{7\}t[[:graph:]]\{8\}' &> /dev/null; then
> 
> This looks better to me. Though I don't think assuming the fixed
> position of 't' is a good idea. We may add new attr flags so the
> position could change. Why not just grep for 't'? We don't have multiple
> 't's anyway :)
> 
> if $XFS_IO_PROG -c 'lsattr' $SCRATCH_MNT | grep -q 't'; then
> ...
> 
> I can do this update at commit time if this looks fine to you.

With that, I'd say,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> 
> Thanks,
> Eryu
> 
> > +	# Attempt to write/fsync data to file
> > +	$XFS_IO_PROG -fc 'pwrite 0 1m' -c fsync $SCRATCH_MNT/testfile |
> > +		tee -a $seqres.full | _filter_xfs_io
> > +
> > +	# Remove the rt inherit flag after we are done or xfs_repair
> > +	# will fail.
> > +	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT | tee -a $seqres.full 2>&1
> > +fi
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/431.out b/tests/xfs/431.out
> > new file mode 100644
> > index 0000000..8c14f11
> > --- /dev/null
> > +++ b/tests/xfs/431.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 431
> > +wrote 1048576/1048576 bytes at offset 0
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 0a449b9..1765559 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -427,3 +427,4 @@
> >  428 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> >  429 dangerous_fuzzers dangerous_scrub dangerous_repair
> >  430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> > +431 auto quick dangerous
> > -- 
> > 2.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
