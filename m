Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DAB2B7F51
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 14:23:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68D57AC004
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 12:23:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IGPKeWlgQLtfdZ84 for
	<xfs@oss.sgi.com>; Wed, 12 Jun 2013 12:23:27 -0700 (PDT)
Date: Wed, 12 Jun 2013 16:23:20 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V2] xfstests: generic/313, test sgid inheritance on subdirs
Message-ID: <20130612192320.GA12955@andromeda.usersys.redhat.com>
References: <51A68175.9020202@redhat.com>
 <51A7B03E.2080909@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A7B03E.2080909@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

I'm personally working on this bug with Eric, and the test properly trigger the
bug on 100% of the test runs, but, it should also ensure that
`irix_sgid_inherit` sysctl is set to 0, if not, the test will fail.

follow is a suggestion for a better changelog:

Tests if subdirectories created on the filesystem will properly inherit sgid bit
when this is set on the parent directory, once the process has the properly
permissions to create a subdirectory, this, should inherit parent's sgid bit if
this is set and irix_sgid_inherit sysctl is disabled.

Thanks for the test Eric, very helpful :)
On Thu, May 30, 2013 at 03:02:06PM -0500, Eric Sandeen wrote:
> On XFS this test fails today due to some over-eager
> SGID removal in xfs core code; ext4 & btrfs pass.
> Document it in a test, will send xfs patch in a bit.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s.  I'm going to just flaunt my ignorance and say:
> I've never understood acls well.  I'm hoping someone who does
> can help me write a better changelog, because this one
> is no good at all!
> 
> V2: add missing source of "attr" file for _require_acls
> 
> diff --git a/tests/generic/313 b/tests/generic/313
> new file mode 100755
> index 0000000..3dee609
> --- /dev/null
> +++ b/tests/generic/313
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# FS QA Test No. 313
> +#
> +# Test SGID inheritance on subdirectories
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_acls
> +_require_user
> +_need_to_be_root
> +
> +rm -rf $TEST_DIR/$seq-dir
> +
> +# Make dir owned by qa user, and an unrelated group:
> +mkdir $TEST_DIR/$seq-dir
> +chown $qa_user:12345 $TEST_DIR/$seq-dir
> +
> +# Make parent dir sgid
> +chmod 2775 $TEST_DIR/$seq-dir
> +
> +# Make subdirs before & after acl set
> +su $qa_user -c "mkdir $TEST_DIR/$seq-dir/subdir"
> +su $qa_user -c "setfacl -m u:$qa_user:rwx,d:u:$qa_user:rwx $TEST_DIR/$seq-dir"
> +su $qa_user -c "mkdir $TEST_DIR/$seq-dir/subdir2"
> +
> +# Both subdirs should have inherited sgid
> +ls -ld $TEST_DIR/$seq-dir/subdir* | _filter_test_dir | awk '{print $1,$NF}'
> +
> +status=0
> +exit
> diff --git a/tests/generic/313.out b/tests/generic/313.out
> new file mode 100644
> index 0000000..326a929
> --- /dev/null
> +++ b/tests/generic/313.out
> @@ -0,0 +1,3 @@
> +QA output created by 313
> +drwxr-sr-x. TEST_DIR/313-dir/subdir
> +drwxrwsr-x+ TEST_DIR/313-dir/subdir2
> diff --git a/tests/generic/group b/tests/generic/group
> index bd443c1..d5ec8d5 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -115,3 +115,4 @@
>  310 auto
>  311 auto metadata log
>  312 auto quick prealloc enospc
> +313 auto quick acl
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
