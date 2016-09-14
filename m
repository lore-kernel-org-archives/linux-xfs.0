Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756348AbcINPLa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Sep 2016 11:11:30 -0400
Date: Wed, 14 Sep 2016 23:11:22 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] fstests: test platform_check_ismounted do its work
Message-ID: <20160914151122.GJ12847@dhcp12-143.nay.redhat.com>
References: <1473840129-19203-1-git-send-email-zlang@redhat.com>
 <d2a3dc67-dfd2-4ec5-6754-f09ae282d8aa@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2a3dc67-dfd2-4ec5-6754-f09ae282d8aa@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Sep 14, 2016 at 09:13:32AM -0500, Eric Sandeen wrote:
> On 9/14/16 3:02 AM, Zorro Lang wrote:
> > There's a bug, the ustat() sysetm call is not implemented on someone
> > arch, but xfsprogs uses this to detect whether a filesystem is
> > mounted in platform_check_ismounted() function.
> > 
> > If ustat() is not implemented, platform_check_ismounted() return
> > "isn't mounted" if a filesystem is mounted, that's a big problem, it
> > will cause corruption.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  tests/xfs/284     | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/284.out |   8 ++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 122 insertions(+)
> >  create mode 100755 tests/xfs/284
> >  create mode 100644 tests/xfs/284.out
> > 
> > diff --git a/tests/xfs/284 b/tests/xfs/284
> > new file mode 100755
> > index 0000000..53fbcb1
> > --- /dev/null
> > +++ b/tests/xfs/284
> > @@ -0,0 +1,113 @@
> > +#! /bin/bash
> > +# FS QA Test 284
> > +#
> > +# Make sure platform_check_ismounted() do its work. A bug cause
> > +# platform_check_ismounted return "isn't mounted" status, even if
> > +# the filesystem is mounted. That maybe cause corruption, so must
> > +# make sure this function always do its work.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2016 Red Hat.  All Rights Reserved.
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
> > +	rm -f $METADUMP_FILE 2>/dev/null
> > +	rm -f $COPY_FILE 2>/dev/null
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
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_test
> > +_require_scratch
> > +
> > +function filter_mounted()
> > +{
> > +	grep "mounted" | _filter_scratch | head -1
> > +}
> > +
> > +METADUMP_FILE="${TEST_DIR}/${seq}_metadump"
> > +COPY_FILE="${TEST_DIR}/${seq}_copyfile"
> > +
> > +# Test dump a mounted device
> 
> comments bout what this should do, what is expected, and why might
> be good, i.e.:
> 
> # xfs_metadump should refuse to dump a mounted device.

Sure, I'll write more comments for every sub-tests.

> 
> (I find bash test scripts to be very hard to debug years after they
> are written; IMHO the more comments, the better) :)
> 
> > +_scratch_mount
> > +_scratch_metadump $METADUMP_FILE 2>&1 | filter_mounted
> > +[ ${PIPESTATUS[0]} -eq 0 ] && echo "Test dump a mounted device [Failed]"
> > +_scratch_unmount
> > +
> > +# Test restore a mounted device
> 
> # Test restore to a mounted device
> # xfs_mdrestore should refuse to restore to a mounted device.
> 
> It might be more clear to move the _scratch_unmount above to just before
> the metadump, so it's very clear whether we're working on a mounted
> or unmounted device, i.e. move it here:
> 
>   +_scratch_unmount

I just tried to make sure before every single sub-tests begin, the SCRATCH_DEV
is always unmounted by default, what do you think about that?

> > +_scratch_metadump $METADUMP_FILE
> > +_scratch_mount
> > +xfs_mdrestore $METADUMP_FILE $SCRATCH_DEV 2>&1 | filter_mounted
> > +[ ${PIPESTATUS[0]} -eq 0 ] && echo "Test restore a mounted device [Failed]"
> > +_scratch_unmount
> > +
> > +# Test xfs_copy to a mounted device
> > +# If source is mounted, xfs_copy will print a warning, but still
> > +# keep on copying. If target is mounted, xfs_copy will failed.
> 
> "xfs_copy should fail."
> 
> Same thing, maybe move the unmount:
> 
>   +_scratch_unmount
> > +$XFS_COPY_PROG $SCRATCH_DEV $COPY_FILE >/dev/null
> > +_scratch_mount
> > +$XFS_COPY_PROG $COPY_FILE $SCRATCH_DEV 2>&1 | filter_mounted
> > +[ ${PIPESTATUS[0]} -eq 0 ] && echo "Test xfs_copy to a mounted device [Failed]"
> > +_scratch_unmount
> > +
> > +# Test xfs_db a mounted device without readonly (-r) option
> 
> "should fail."
> 
> having the explicit _mount below seems good to me, it makes it clear.
> 
> > +_scratch_mount
> > +$XFS_DB_PROG -c sb $SCRATCH_DEV 2>&1 | filter_mounted
> > +[ ${PIPESTATUS[0]} -eq 0 ] &&
> > +	echo "Test xfs_db a mounted device(without -r option) [Failed]"
> > +_scratch_unmount
> > +
> > +# Test mkfs.xfs a mounted device
> > +# Generally mkfs will report device is mounted, but if it can't find
> > +# device is mounted, it'll report device busy.
> > +_scratch_mount
> > +_scratch_mkfs 2>&1 | filter_mounted
> > +[ ${PIPESTATUS[0]} -eq 0 ] && echo "Test mkfs.xfs a mounted device [Failed]"
> > +_scratch_unmount
> > +
> > +# Test xfs_repair (with/without modify flag) a mounted device
> 
> Again, maybe comments about what we really expect to see here?
> 
> > +_scratch_mount
> > +_scratch_xfs_repair -n 2>&1 | filter_mounted
> > +[ ${PIPESTATUS[0]} -eq 0 ] &&
> > +	echo "Test xfs_repair -n a mounted devie [Failed]"
> 
> s/devie/device/
> 
> > +_scratch_xfs_repair 2>&1 | filter_mounted
> > +[ ${PIPESTATUS[0]} -eq 0 ] && echo "Test xfs_repair a mounted devie [Failed]"
> 
> s/devie/device/
> 
> Testing the "-d dangerous" option of repair would also be good.

Hmm... I think this's used to test platform_check_iswritable(). I'm planning
to write another case to test platform_check_iswritable (I'm thinking about
how to write that:)

Thanks,
Zorro

> 
> -Eric
> 
> > +_scratch_unmount
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/284.out b/tests/xfs/284.out
> > new file mode 100644
> > index 0000000..302d75e
> > --- /dev/null
> > +++ b/tests/xfs/284.out
> > @@ -0,0 +1,8 @@
> > +QA output created by 284
> > +xfs_metadump: SCRATCH_DEV contains a mounted and writable filesystem
> > +xfs_mdrestore: a filesystem is mounted on target device "SCRATCH_DEV", cannot restore to a mounted filesystem.
> > +xfs_copy:  a filesystem is mounted on target device "SCRATCH_DEV".
> > +xfs_db: SCRATCH_DEV contains a mounted filesystem
> > +mkfs.xfs: SCRATCH_DEV contains a mounted filesystem
> > +xfs_repair: SCRATCH_DEV contains a mounted and writable filesystem
> > +xfs_repair: SCRATCH_DEV contains a mounted filesystem
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index baa0ff6..0ac4bd5 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -281,6 +281,7 @@
> >  281 dump ioctl auto quick
> >  282 dump ioctl auto quick
> >  283 dump ioctl auto quick
> > +284 auto quick mount
> >  287 auto dump quota quick
> >  290 auto rw prealloc quick ioctl zero
> >  291 auto repair
> > 
