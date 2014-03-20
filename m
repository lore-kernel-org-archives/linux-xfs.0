Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D3ECB7F8B
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 23:17:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 987B830407F
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 21:17:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GhJA4CSSWORA6VXS for
	<xfs@oss.sgi.com>; Wed, 19 Mar 2014 21:17:14 -0700 (PDT)
Date: Thu, 20 Mar 2014 12:17:11 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] shared: new test to use up free inodes
Message-ID: <20140320041711.GY8312@dhcp-13-216.nay.redhat.com>
References: <1395221269-11085-1-git-send-email-eguan@redhat.com>
	<532A34D3.8060805@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <532A34D3.8060805@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Mar 19, 2014 at 07:22:43PM -0500, Eric Sandeen wrote:
> On 3/19/14, 4:27 AM, Eryu Guan wrote:
> > Stress test fs by using up all inodes and check fs.
> > 
> > Also a regression test for xfsprogs commit
> > d586858 xfs_repair: fix sibling pointer tests in verify_dir2_path()
> 
> Thanks Eryu.  I had started to write this test but ran into another bug
> (where xfs blows past the maximum inode space %) so got distracted.

I didn't notice this. Do I need to add extra check to detect this in
my test? I want to cover this in one test case if possible.

> 
> I see Dave's already picked apart the patch so I won't comment specifically
> on it, but you might be aware of the possibility that xfs won't stop when
> we hit the default imaxpct, and may actually fill the entire fs.  That's
> not necessarily a problem but it may take longer than you expect.

Yes, I noticed that testing on xfs didn't give ENOSPC error as testing
on ext4 do. The number of extra files created is less than 1000, so I
think that's fine.

> 
> I also wonder what's necessary to actually test the sibling pointer problem;
> on xfs, it's probably just a sufficiently large directory, not necessarily
> a full fs?

I've seen list corruption and then xfs force shutdown by running the
same test(at the time removing all created files) on earlier RHEL7
test kernels, then the bug was fixed by xfs update. So I'm not sure
it's large directory or taking all free inode trigger the bug, I think
I'd better still to fulfill the fs.

Thanks,
Eryu
> 
> -Eric
> 
> 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> >  tests/shared/006     | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/shared/006.out |  2 ++
> >  tests/shared/group   |  1 +
> >  3 files changed, 99 insertions(+)
> >  create mode 100755 tests/shared/006
> >  create mode 100644 tests/shared/006.out
> > 
> > diff --git a/tests/shared/006 b/tests/shared/006
> > new file mode 100755
> > index 0000000..a3b13b6
> > --- /dev/null
> > +++ b/tests/shared/006
> > @@ -0,0 +1,96 @@
> > +#! /bin/bash
> > +# FS QA Test No. shared/006
> > +#
> > +# Stress test fs by using up all inodes and check fs.
> > +#
> > +# Also a regression test for xfsprogs commit
> > +# d586858 xfs_repair: fix sibling pointer tests in verify_dir2_path()
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2014 Red Hat Inc.  All Rights Reserved.
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
> > +create_file()
> > +{
> > +	local dir=$1
> > +	local nr_file=$2
> > +	local prefix=$3
> > +	local i=0
> > +
> > +	while [ $i -lt $nr_file ]; do
> > +		touch $dir/${prefix}_${i}
> > +		let i=$i+1
> > +	done
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs ext4 ext3 ext2 xfs
> > +_supported_os Linux
> > +
> > +_require_scratch
> > +
> > +rm -f $seqres.full
> > +echo "Silence is golden"
> > +
> > +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
> > +_scratch_mount
> > +
> > +i=0
> > +free_inode=`df -iP $SCRATCH_MNT | tail -1 | awk '{print $2}'`
> > +loop=$((free_inode / 1000 + 1))
> > +mkdir -p $SCRATCH_MNT/testdir
> > +
> > +echo "Create $((loop * 1000)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> > +while [ $i -lt $loop ]; do
> > +	create_file $SCRATCH_MNT/testdir 1000 $i >>$seqres.full 2>&1 &
> > +	let i=$i+1
> > +done
> > +wait
> > +
> > +# log inode status in $seqres.full for debug purpose
> > +echo "Inode status after taking all inodes" >>$seqres.full
> > +df -i $SCRATCH_MNT >>$seqres.full
> > +
> > +_check_scratch_fs
> > +
> > +# Check again after removing all the files
> > +rm -rf $SCRATCH_MNT/testdir
> > +echo "Inode status after deleting all test files" >>$seqres.full
> > +df -i $SCRATCH_MNT >>$seqres.full
> > +_check_scratch_fs
> > +
> > +status=0
> > +exit
> > diff --git a/tests/shared/006.out b/tests/shared/006.out
> > new file mode 100644
> > index 0000000..675c1b7
> > --- /dev/null
> > +++ b/tests/shared/006.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 006
> > +Silence is golden
> > diff --git a/tests/shared/group b/tests/shared/group
> > index 29f17b0..230e560 100644
> > --- a/tests/shared/group
> > +++ b/tests/shared/group
> > @@ -8,6 +8,7 @@
> >  003 auto quick prealloc
> >  004 auto quick prealloc
> >  005 auto prealloc
> > +006 auto stress enospc
> >  032 mkfs auto quick
> >  051 acl udf auto quick
> >  218 auto fsr quick
> > 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
