Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BC327F59
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 05:54:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5BE5F8F8033
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 03:54:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RByPI3druLaojFjZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 03:54:02 -0700 (PDT)
Date: Wed, 24 Jun 2015 06:54:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfstests: generic xattr enospc cleanup test
Message-ID: <20150624105359.GA61024@bfoster.bfoster>
References: <1435078044-21679-1-git-send-email-bfoster@redhat.com>
	<20150624035918.GD1210@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150624035918.GD1210@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jun 24, 2015 at 11:59:19AM +0800, Eryu Guan wrote:
> On Tue, Jun 23, 2015 at 12:47:24PM -0400, Brian Foster wrote:
> > XFS had a regression where inode reclaim in the unlink codepath would
> > not correctly tear down extended attribute forks where no xattr extents
> > are present. Add a generic test to create this condition.
> > 
> > The test sets extended attributes on a series of files under ENOSPC
> > conditions and then verifies that the files can be removed without
> > syslog warnings or errors.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  tests/generic/103     | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/103.out |  2 ++
> >  tests/generic/group   |  1 +
> >  3 files changed, 94 insertions(+)
> >  create mode 100755 tests/generic/103
> >  create mode 100644 tests/generic/103.out
> > 
> > diff --git a/tests/generic/103 b/tests/generic/103
> > new file mode 100755
> > index 0000000..373cd9d
> > --- /dev/null
> > +++ b/tests/generic/103
> > @@ -0,0 +1,91 @@
> > +#! /bin/bash
> > +# FSQA Test No. 103
> > +#
> > +# Test attribute fork teardown. This test is inspired by a regression in XFS
> > +# that resulted in problematic removal of inodes with remote attribute forks
> > +# without attribute extents. The attribute fork condition is created by
> > +# attempting to set larger attribute values on a filesystem that is at or near
> > +# ENOSPC.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2015 Red Hat, Inc.  All Rights Reserved.
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
> > +#
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +_cleanup()
> > +{
> > +        cd /
> > +        rm -f $tmp.*
> > +}
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15 25
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/attr
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch
> > +_require_attrs
> > +
> > +rm -f $seqres.full
> > +
> > +_consume_freesp()
> > +{
> > +	file=$1
> > +
> > +	# consume nearly all available space (leave ~512kB)
> > +	avail=`_get_available_space $SCRATCH_MNT`
> 
> Seems you missed "_get_available_space" function definition in
> common/rc? I got "command not found" error.
> 

Ah, sorry... that is actually part of a previous patch. I meant to point
out that this depends on the following patch due to the use of the new
helper:

http://thread.gmane.org/gmane.comp.file-systems.fstests/834

Sorry for the confusion.

Brian

> Thanks,
> Eryu
> > +	filesizekb=$((avail / 1024 - 512))
> > +	$XFS_IO_PROG -fc "falloc 0 ${filesizekb}k" $file
> > +}
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +for i in $(seq 0 63); do
> > +	touch $SCRATCH_MNT/$seq.$i
> > +done
> > +
> > +# Generate a large attribute value and consume the rest of the space in the
> > +# filesystem.
> > +$XFS_IO_PROG -fc "pwrite 0 64k" $SCRATCH_MNT/attrval > /dev/null 2>&1
> > +_consume_freesp $SCRATCH_MNT/spc
> > +
> > +# Set attributes on the test files. These should start to hit ENOSPC.
> > +for i in $(seq 0 63); do
> > +	$SETFATTR_PROG -n user.test -v "`cat $SCRATCH_MNT/attrval`" \
> > +		$SCRATCH_MNT/$seq.$i >> $seqres.full 2>&1
> > +done
> > +
> > +# Remove the files with attributes to test attribute fork teardown. Problems
> > +# result in dmesg output.
> > +rm -f $SCRATCH_MNT/$seq.*
> > +
> > +echo Silence is golden.
> > +
> > +status=0
> > +exit
> > diff --git a/tests/generic/103.out b/tests/generic/103.out
> > new file mode 100644
> > index 0000000..ce229bf
> > --- /dev/null
> > +++ b/tests/generic/103.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 103
> > +Silence is golden.
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 0c8964c..41f3039 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -98,6 +98,7 @@
> >  097 udf auto
> >  099 udf auto
> >  100 udf auto
> > +103 auto enospc quick
> >  105 acl auto quick
> >  112 rw aio auto quick
> >  113 rw aio auto quick
> > -- 
> > 1.9.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
