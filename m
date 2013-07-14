Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D5D017F50
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 11:16:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CC1CAC002
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 09:16:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tU3YEoqCJNtY0l6G for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 09:16:31 -0700 (PDT)
Message-ID: <51E2CEDE.5000304@sandeen.net>
Date: Sun, 14 Jul 2013 11:16:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V4] xfstests: generic/314, test sgid inheritance on subdirs
References: <1373658373-8988-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1373658373-8988-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 7/12/13 2:46 PM, Carlos Maiolino wrote:
> Tests if subdirectories created on the filesystem will properly inherit sgid bit
> when this is set on the parent directory, once the process has the properly
> permissions to create a subdirectory, this, should inherit parent's sgid bit if
> this is set and irix_sgid_inherit sysctl is disabled.
> 
> V2: add missing source of "attr" file for _require_acls
> 
> V3: use _ls_l to filter out the selinux "."
>     renumber to 314 to make the merge easier
> 
> V4: fix 314.out to the correct output

Heh, thanks Carlos.  Friday wasn't my best day.

> Thanks to Sandeen who have written this patch
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  tests/generic/314     |   68 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/314.out |    4 +++
>  tests/generic/group   |    1 +
>  3 files changed, 73 insertions(+), 0 deletions(-)
>  create mode 100755 tests/generic/314
>  create mode 100644 tests/generic/314.out
> 
> diff --git a/tests/generic/314 b/tests/generic/314
> new file mode 100755
> index 0000000..2d34ea8
> --- /dev/null
> +++ b/tests/generic/314
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# FS QA Test No. 314
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
> +status=1       # failure is the default!
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
> +_ls_l $TEST_DIR/$seq-dir/ | _filter_test_dir | awk '{print $1,$NF}'
> +
> +status=0
> +exit
> diff --git a/tests/generic/314.out b/tests/generic/314.out
> new file mode 100644
> index 0000000..180be80
> --- /dev/null
> +++ b/tests/generic/314.out
> @@ -0,0 +1,4 @@
> +QA output created by 314
> +total 4
> +drwxr-sr-x subdir
> +drwxrwsr-x+ subdir2
> diff --git a/tests/generic/group b/tests/generic/group
> index bd443c1..7c0ea25 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -115,3 +115,4 @@
>  310 auto
>  311 auto metadata log
>  312 auto quick prealloc enospc
> +314 auto quick acl
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
