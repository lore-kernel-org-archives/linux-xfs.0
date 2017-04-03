Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32848 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752118AbdDCLCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 07:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <149121525845.22344.2910294693531349827.stgit@warthog.procyon.org.uk>
References: <149121523070.22344.187602366514567082.stgit@warthog.procyon.org.uk>
 <149121525845.22344.2910294693531349827.stgit@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Apr 2017 14:02:02 +0300
Message-ID: <CAOQ4uxj3heVi+x4Gf_-PBAK5gE36DVCsqi8wWXaNniZxNxgZQQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Apr 3, 2017 at 1:27 PM, David Howells <dhowells@redhat.com> wrote:
> Check the stx_attributes that can be set by calling chattr.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
[...]
> diff --git a/tests/generic/421 b/tests/generic/421
> new file mode 100755
> index 0000000..6fca8f6
> --- /dev/null
> +++ b/tests/generic/421
> @@ -0,0 +1,94 @@
> +#! /bin/bash
> +# FS QA Test 421
> +#
> +# Test the statx stx_attribute flags that can be set with chattr
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 YOUR NAME HERE.  All Rights Reserved.
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
> +status=0

Better default to failure. see my comments on test 420.

> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +       rm -f $seq-file
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os IRIX Linux
> +_require_test
> +_require_test_program "stat_test"
> +_require_statx
> +_require_chattr
> +
> +function check_stat () {
> +    $here/src/stat_test $*
> +}
> +
> +touch $seq-file
> +
> +function try () {
> +    chattr $* $seq-file
> +    check_stat $seq-file \
> +              attr=${1/a/append} \
> +              attr=${2/c/compressed} \
> +              attr=${3/i/immutable} \
> +              attr=${4/d/nodump} \
> +              stx_type=file \
> +              stx_size=0 \
> +              stx_rdev_major=0 \
> +              stx_rdev_minor=0 \
> +              stx_nlink=1
> +}
> +
> +# We can turn on and off append (a), compressed (c), immutable (i) and
> +# no-dump (d)
> +for a in +a -a
> +do
> +    for c in +c -c
> +    do
> +       for i in +i -i
> +       do
> +           for d in +d -d
> +           do
> +               try $a $c $i $d
> +           done
> +       done
> +    done
> +done
> +
> +# Done.  We leave the determination to the output comparator.
> +exit
> diff --git a/tests/generic/421.out b/tests/generic/421.out
> new file mode 100644
> index 0000000..984fb43
> --- /dev/null
> +++ b/tests/generic/421.out
> @@ -0,0 +1 @@
> +QA output created by 421

If the output is meant to stay empty, please copy from the tests that do
echo "Silence is golden"
Again, I believe this is to protect from test crashing and resulting in empty
output (well in addition to the status thingy...)

> diff --git a/tests/generic/group b/tests/generic/group
> index 5678101..f8b01fc 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -423,3 +423,4 @@
>  418 auto rw
>  419 auto quick encrypt
>  420 auto quick
> +421 auto quick
>
