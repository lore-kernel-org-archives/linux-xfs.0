Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 74FC67F37
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 11:36:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3900AC004
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 09:36:04 -0700 (PDT)
Received: from mail-qa0-f54.google.com (mail-qa0-f54.google.com
	[209.85.216.54]) by cuda.sgi.com with ESMTP id JQndKA4SkoM3wtb8
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Sep 2013 09:36:03 -0700 (PDT)
Received: by mail-qa0-f54.google.com with SMTP id bv4so3018901qab.6
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 09:36:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130917192538.230164044@sgi.com>
References: <20130917192538.230164044@sgi.com>
Date: Wed, 18 Sep 2013 12:36:03 -0400
Message-ID: <CAJzLF9kacDY3gu7moxfFDRMTCxjQOzp_574Ojagk-kvNySedfg@mail.gmail.com>
Subject: Re: [PATCH] xfstests: v2 xfs directory unbalance assert test
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Looks good.  I tried it on an 11-GB partition with an unpatched git kernel
3.12.0 + xfs-oss/master, coupled with the latest git xfsprogs.  It took a
reasonable amount of time, relatively speaking.  It put forth the error I was
expecting, and a new 32-bit core is available upon your request but not
uploaded yet.

As for the assert itself, according to kgdb, these are the first, last, and
BBTOB(bp->b_length) numbers for this run:

1544 4591 4096

Good work!

Michael

On Tue, Sep 17, 2013 at 3:25 PM, Mark Tinguely <tinguely@sgi.com> wrote:
> This tests triggers an assert in the XFS directory unbalance code.
> This test originally written by Brian Foster and suggestions
> from Micheal Semon.
>
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> v1->v2:
>  remove clean up.
>  remove $seqres.full before test.
>  remove scratch mount.
>  11g -> calculate 11g bytes.
>  check for failing mkfs and mount.
>  add a safer removal of the scratch files.
>
>  put into auto group and "long" group so people can opt out:
>   this test almost an hour on my test box.
>
>  tests/generic/319     |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/319.out |    2 +
>  tests/generic/group   |    1
>  3 files changed, 59 insertions(+)
>
> Index: b/tests/generic/319
> ===================================================================
> --- /dev/null
> +++ b/tests/generic/319
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# FS QA Test No. 319
> +#
> +# Test directory code correctly handles fsstress filling the filesystem
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 SGI.  All Rights Reserved.
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
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +_require_scratch
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +_supported_os IRIX Linux
> +
> +rm -f $seqres.full
> +_scratch_mkfs_sized $((11 * 1024 * 1024 * 1024)) >> $seqres.full 2>&1 \
> +       || _fail "mkfs failed"
> +run_check _scratch_mount >> $seqres.full
> +
> +# Fill the filesystem.
> +FSSTRESS_ARGS="-z -s 1378390208 -fsymlink=1 -n7500000 -p4 -d $SCRATCH_MNT"
> +$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1
> +
> +# A debug XFS may assert in the remove due to a directory bug.
> +rm -rf $SCRATCH_MNT/p?
> +echo "--- silence is golden ---"
> +status=0
> +exit
> Index: b/tests/generic/319.out
> ===================================================================
> --- /dev/null
> +++ b/tests/generic/319.out
> @@ -0,0 +1,2 @@
> +QA output created by 319
> +--- silence is golden ---
> Index: b/tests/generic/group
> ===================================================================
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -121,3 +121,4 @@
>  316 auto quick
>  317 auto metadata quick
>  318 acl attr auto quick
> +319 auto stress long
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
