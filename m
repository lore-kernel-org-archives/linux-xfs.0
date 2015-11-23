Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E56FE7F37
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 17:10:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6BFC7AC001
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 15:10:00 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2nwMGT1OfOe169We for <xfs@oss.sgi.com>;
	Mon, 23 Nov 2015 15:09:56 -0800 (PST)
Date: Tue, 24 Nov 2015 10:08:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFSTESTS 5/6] Add richacl tests
Message-ID: <20151123230847.GH26718@dastard>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
	<1447856269-7872-6-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447856269-7872-6-git-send-email-agruenba@redhat.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 18, 2015 at 03:17:48PM +0100, Andreas Gruenbacher wrote:
> Add the Rich Access Control List tests from the richacl package.  The
> new tests require TEST_DEV and TEST_DIR to be set.
> 
> When the check script is run, it first makes sure that the test
> filesystem has richacls enabled or disabled as appropriate: with the
> -richacl option, richacls must be enabled; without the -richacl option,
> richacls must be disabled.  If TEST_DEV has incorrect richacl support,
> the TEST_DEV filesystem is recreated.

No, we don't recreate the testdev like this with the test harness.
The test device is intended to remain unchanged from run to run, so
give us long term aging of the test filesystem over months of
regression test running.

If you want to test the testdev with richacls enabled, then you need
to manually create the testdev with richacls. Any test that
specifically needs to enable richacls should use the scratch device
and use a _requires_scratch_richacls() test to check that the
scratch device can be created with richacl support.

> The -richacl option currently selects the tests in the richacl group to
> be run.  Additional test groups or tests can be specified on the command
> line, e.g.,
> 
>>   ./check -richacl -g quick
> (Eventually, the -richacl option will be changed to only skip tests
> which are incompatible with richacls.)

No, this is wrong. If you want to check richacls, it should be via a
test group, not a specific command line option

   ./check -g richacl

That makes the first 2 patches in the series go away.

> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  .gitignore                          |   1 +
>  check                               |  39 +++++++-
>  common/rc                           |  23 ++++-
>  src/Makefile                        |   2 +-
>  src/require-richacls.c              |  35 +++++++

That's a red flag. For XFS, in common/rc:

_require_xfs_richacl()
{
	_scratch_mkfs_xfs_supported -m richacl=1 >/dev/null 2>&1 \
	           || _notrun "mkfs.xfs doesn't have richacl feature"

	_scratch_mkfs_xfs -m richacl=1 >/dev/null 2>&1 \
	_scratch_mount >/dev/null 2>&1 \
	           || _notrun "Kernel doesn't support richacl feature"
	umount $SCRATCH_MNT
}

_require_scratch_richacl()
{
	case "$FSTYP" in
	xfs)	_require_xfs_richacl
		;;
	ext4)	_require_ext4_richacl
		;;
	*)	_notrun "this test requires a richacl support on SCRATCHDEV"
		;;
	esac
}

>  tests/richacl/001-apply-masks       |   1 +
>  tests/richacl/002-auto-inheritance  |   1 +
>  tests/richacl/003-basic             |   1 +
>  tests/richacl/004-chmod             |   1 +
>  tests/richacl/005-chown             |   1 +
>  tests/richacl/006-create            |   1 +
>  tests/richacl/007-ctime             |   1 +
>  tests/richacl/008-delete            |   1 +
>  tests/richacl/009-setrichacl-modify |   1 +
>  tests/richacl/010-write-vs-append   |   1 +

These seem very short for tests. Oh, they just call one of the
files below:

>  tests/richacl/Makefile              |  44 +++++++++
>  tests/richacl/apply-masks           | 163 ++++++++++++++++++++++++++++++
>  tests/richacl/auto-inheritance      | 191 ++++++++++++++++++++++++++++++++++++
>  tests/richacl/basic                 |  97 ++++++++++++++++++
>  tests/richacl/chmod                 |  40 ++++++++
>  tests/richacl/chown                 |  42 ++++++++
>  tests/richacl/create                |  36 +++++++
>  tests/richacl/ctime                 |  35 +++++++
>  tests/richacl/delete                |  89 +++++++++++++++++
>  tests/richacl/group                 |  15 +++
>  tests/richacl/setrichacl-modify     |  57 +++++++++++
>  tests/richacl/test-lib.sh           | 149 ++++++++++++++++++++++++++++
>  tests/richacl/write-vs-append       |  54 ++++++++++

That's a strange way of running tests, an dmost definitely not the
way xfstests are written or supposed to be executed. And looking at
tests/richacl/Makefile, these files need to be installed somewhere
in the path for the tests to work. This is unnecessary complexity;
the tests should simply execute in place in the source tree and not
require any special installation steps.

i.e. only the numbered version of the test should exist,
and all the other files be moved into them. They shouldn't be in
tests/richacl, either - these are generic tests and so should
be in tests/generic, using whatever the next unused test numbers
are. And then, in the tests/generic/group file, there will be
entries like:

178-apply-masks	auto quick richacl
179-auto-inheritance auto quick richacl
....

These tests need to use the common xfstests structure (i.e. the
setup code from the "new" script).

The file that has all the common functionality in it (test-lib.sh)
needs to be moved to common/richacl and included along with the
necessary common files. At this point, the makefile can also go
away.

> diff --git a/tests/richacl/apply-masks b/tests/richacl/apply-masks
> new file mode 100755
> index 0000000..7a99cf9
> --- /dev/null
> +++ b/tests/richacl/apply-masks
> @@ -0,0 +1,163 @@
> +#! /bin/sh

We use /bin/bash in xfstests.

> +
> +. ${0%/*}/test-lib.sh
> +
> +require_richacls
> +use_tmpdir

No test actually uses $tmpdir, so why does this exist?

> +
> +ncheck "touch x"
> +ncheck "setrichacl --set 'owner@:rwp::allow group@:rwp::allow everyone@:r::allow' x"
> +check "getrichacl x" <<EOF
> +x:
> +    owner@:rwp----------::allow
> +    group@:rwp----------::allow
> + everyone@:r------------::allow
> +EOF

Ok, let's break this down, because most of the tests are similar.

ncheck is not needed, as golden output matching will catch an
unexpected error.

check is not needed, because the output of the command should
match what is in the golden output file. i.e, this test should be
simply:

touch x
setrichacl --set 'owner@:rwp::allow group@:rwp::allow everyone@:r::allow' x
getrichacl x

And the golden output file should contain:

x:
    owner@:rwp----------::allow
    group@:rwp----------::allow
 everyone@:r------------::allow

The fact that you do golden output matching directly in the script
to calculate "checks_succeeded" and "checks_failed" and then check
those at the end of the test to set the exit status is completely
unnecessary. The xfstests tsts harness does all this pattern
matching for you via the golden output file. Using output files
correctly make patches 3 and 4 in this series go away.

> +# We cannot set the acl as another user
> +runas -u 99 -g 99
> +check "setrichacl --set '99:rwc::allow' a || echo status: \$?" <<EOF
> +a: Operation not permitted
> +status: 1
> +EOF

In this case, check hides the fact the test attempts to run as a
different user. now we've got rid of the "check" wrappers, we should
just be doing:

runas=$here/src/runas

$runas -u 99 -g 99 -- setrichacl --set '99:rwc::allow' 

and capturing the expected error in the golden output file. This is
the same as ACL and other permission tests in xfstests. e.g:

$ git grep -l runas
.gitignore
src/Makefile
tests/generic/026
tests/generic/093
tests/generic/099
tests/generic/237
tests/shared/051
$

> +cleanup() {
> +    status=$?
> +    checks_succeeded=`expr $checks_succeeded`
> +    checks_failed=`expr $checks_failed`
> +    checks_total=`expr $checks_succeeded + $checks_failed`
> +    if test $checks_total -gt 0 ; then
> +	if test $checks_failed -gt 0 && test $status -eq 0 ; then
> +	    status=1
> +	fi
> +	echo "$checks_total tests ($checks_succeeded passed," \
> +	     "$checks_failed failed)"
> +    fi
> +    if test -n "$tmpdir" ; then
> +	chmod -R u+rwx "$tmpdir" 2>/dev/null
> +	cd / && rm -rf "$tmpdir"
> +    fi
> +    exit $status
> +}

This is all completely unnecessary because the golden output
matching done by the harness will fail the test if there is any
error at all. The whole point of using xfstests is that you don't
need to carry all this test harness install/run/test/check stuff in
the tests themselves. This stuff should be no different to the posix
ACL tests in structure (e.g. see generic/099), and should be just as
simple to maintain.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
