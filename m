Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36236 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752153AbdDCKxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 06:53:48 -0400
MIME-Version: 1.0
In-Reply-To: <149121524183.22344.1748203777026246762.stgit@warthog.procyon.org.uk>
References: <149121523070.22344.187602366514567082.stgit@warthog.procyon.org.uk>
 <149121524183.22344.1748203777026246762.stgit@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Apr 2017 13:53:46 +0300
Message-ID: <CAOQ4uxhBgQ6q5GMe=G14Swvxto+y2_rZucZzK521Z4mCryOrZg@mail.gmail.com>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Apr 3, 2017 at 1:27 PM, David Howells <dhowells@redhat.com> wrote:
> Add a statx test script that does the following:
>
[...]
> +++ b/tests/generic/420
> @@ -0,0 +1,180 @@
> +#! /bin/bash
> +# FS QA Test 420
> +#
> +# Test the statx system call
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
> +# Written by David Howells (dhowells@redhat.com)
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

I know Eryu told you that you can change the default of status to success,
but I don't don't that this is a good idea or what's the benefit of doing that.
(see below)

> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +       rm -rf $TEST_DIR/$seq-*
> +}
> +
> +

[...]

> +# Done.  We leave the determination to the output comparator.

Not exactly. what happens if stat_test crashes without any output?
or if the test script itself gets kills while running this last stat_test.
test output would still look sane.

A simple way to deal with this is to do

function check_stat () {
    $here/src/stat_test $* || exit
}

and set status=0 here at the end of the test, like all the other tests
in xfstests do.
I think the reasoning is that some (older) common functions can sometimes
exit without setting status and you want exit status to be non zero when that
happens.

Eryu,

do you agree?

> +exit
> diff --git a/tests/generic/420.out b/tests/generic/420.out
> new file mode 100644
> index 0000000..21d6ffc
> --- /dev/null
> +++ b/tests/generic/420.out
> @@ -0,0 +1,11 @@
> +QA output created by 420
> +Test statx on a fifo
> +Test statx on a chardev
> +Test statx on a directory
> +Test statx on a blockdev
> +Test statx on a file
> +20+0 records in
> +20+0 records out
> +Test statx on a symlink
> +Test statx on an AF_UNIX socket
> +Test a hard link to a file
> diff --git a/tests/generic/group b/tests/generic/group
> index 0781f35..5678101 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -422,3 +422,4 @@
>  417 auto quick shutdown log
>  418 auto rw
>  419 auto quick encrypt
> +420 auto quick
>
