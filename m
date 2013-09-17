Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA7BA7F50
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 10:41:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9780304039
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 08:41:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 72dXQcUOSgsrqi6D for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 08:41:39 -0700 (PDT)
Message-ID: <52387831.5010205@sandeen.net>
Date: Tue, 17 Sep 2013 10:41:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: xfs directory unbalance assert test
References: <20130917145946.124195107@sgi.com>
	<20130917145959.333796933@sgi.com>
In-Reply-To: <20130917145959.333796933@sgi.com>
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
Cc: xfs@oss.sgi.com

On 9/17/13 9:59 AM, Mark Tinguely wrote:
> This tests triggers an assert in the XFS directory unbalance code.
> This test originally written by Brian Foster and suggestions
> from Micheal Semon.

cool, thanks.  Comments below.

> Signed-off-by: Mark Tinguely <tinguely@sgi.com> 
> ---
>  tests/generic/319     |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/319.out |    2 +
>  tests/generic/group   |    1 
>  3 files changed, 65 insertions(+)
> 
> Index: b/tests/generic/319
> ===================================================================
> --- /dev/null
> +++ b/tests/generic/319
> @@ -0,0 +1,62 @@
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
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +}

That seems pointless; usually it's done w/ rm -f $tmp.*
right after, but we have no tmpfile, so...

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
> +_scratch_unmount > /dev/null 2>&1

Aside:

I see this done both ways - is it required to unmount scratch at the beginning
of a test?  I don't think so (I know it's done in many tests, though, but
again, C&P & cargo cult?  Or not?  I'm not sure :( )

I guess it doesn't hurt, but at some point I'd like to get it straight
about who's required to umount scratch, and when (if at all).

> +_scratch_mkfs_sized 11g >> $seqres.full 2>&1

_scratch_mkfs_sized doesn't take units like this ('g'), so the above fails to
actually make an 11g fs:

# Create fs of certain size on scratch device
# _scratch_mkfs_sized <size in bytes> [optional blocksize]
_scratch_mkfs_sized()

so we get this in 319.full:

expr: non-numeric argument
./common/rc: line 576: [: 11g: integer expression expected

but then it seems like mkfs carries on anyway w/ defaults.  :(

Apparently the mkfs 11g part isn't actually critical? ;)

maybe _scratch_mkfs_sized needs something like this at the top:

re='^[0-9]+$'
if ! [[ $fssize =~ $re ]] ; then
   _notrun "error: _scratch_mkfs_sized: $fssize not a number of bytes"
fi

> +_scratch_mount > /dev/null 2>&1

is ignore-all-output really the right thing to do?  When does _scratch_mount
emit anything?  (more cargo cult)? :)

> +# Fill the filesystem.
> +FSSTRESS_ARGS="-z -s 1378390208 -fsymlink=1 -n7500000 -p4 -d $SCRATCH_MNT"
> +$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1
> +
> +cd $SCRATCH_MNT >> $seqres.full 2>&1

cd doesn't emit anything except on error, right, and if there's an error we'd better
stop the test right here!

> +sync
> +# A debug XFS may assert in the remove due to a directory bug.
> +rm -rf *

I'd feel a whole lot better if you did rm -rf $SCRATCH_MNT/* just in case
we somehow ended up in the wrong place here.

Or even better if you pointed fsstress at $SCRATCH_MNT/$seq.dir, and
then did rm -rf $SCRATCH_MNT/$seq.dir - just to avoid that nasty
should-never-happen-still-scary "rm -rf /*"

-Eric

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
> +319 stress
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
