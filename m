Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933619AbdDEKw3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 06:52:29 -0400
Date: Wed, 5 Apr 2017 18:52:26 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by
 chattr [ver #5]
Message-ID: <20170405105226.GA22845@eguan.usersys.redhat.com>
References: <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk>
 <149132133562.18980.13032775360715592290.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149132133562.18980.13032775360715592290.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Apr 04, 2017 at 04:55:35PM +0100, David Howells wrote:
> Check the stx_attributes that can be set by calling chattr.
> 
> The script probes the filesystem with chattr to find out which of +a, +c,
> +d and +i are supported before testing combinations of attrs.  Note that if
> a filesystem supports chattr with these, but doesn't paste the flag values
> into stx_attributes, the test will fail as there's no way to distinguish
> cleared from unset.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Can you please add some comments in test and/or commit log explaining
why "a c d i" attrs are chosen for this test and why they must be tested
in combination? It's not clear just from the test itself.

And this test is expected to fail with 4.11-rc5 kernel on all
filesystems, right?

> ---
> 
>  doc/requirement-checking.txt |   16 ++++-
>  src/stat_test.c              |   71 ++++++++++++++++++++
>  tests/generic/421            |  149 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/421.out        |    1 
>  tests/generic/group          |    1 
>  5 files changed, 237 insertions(+), 1 deletion(-)
>  create mode 100755 tests/generic/421
>  create mode 100644 tests/generic/421.out
> 
> diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
> index 29f0b74..523b27f 100644
> --- a/doc/requirement-checking.txt
> +++ b/doc/requirement-checking.txt
> @@ -12,7 +12,11 @@ they have.  This is done with _require_<xxx> macros, which may take parameters.
>  	_require_test_program
>  	_require_xfs_io_command
>  
> - (2) System call requirements.
> + (2) Filesystem capability requirements.
> +
> +	_require_chattr

As Amir pointed out, a bare _require_chattr call doesn't make sense, it
needs an attribute letter as argument. The bug is not fixed yet,
hopefully we can get the doc right first :)

> +
> + (3) System call requirements.
>  
>  	_require_statx
>  
> @@ -59,6 +63,16 @@ _require_xfs_io_command "falloc"
>       the 'falloc' command.
>  
>  
> +==================================
> +FILESYSTEM CAPABILITY REQUIREMENTS
> +==================================
> +
> +_require_chattr
> +
> +     The test requires that the chattr command be available and supported by
> +     the $TEST_DEV filesystem.  No check is made of the scratch filesystem.

And here.

> +
> +
>  ========================
>  SYSTEM CALL REQUIREMENTS
>  ========================
> diff --git a/src/stat_test.c b/src/stat_test.c
> index cb3d4f4..b1205ec 100644
> --- a/src/stat_test.c
> +++ b/src/stat_test.c
> @@ -102,6 +102,30 @@ static int field_cmp(const void *_key, const void *_p)
>  	return strcmp(key, p->name);
>  }
>  
> +/*
> + * Sorted list of attribute flags for bsearch().
> + */
> +struct attr_name {
> +	const char	*name;
> +	__u64		attr_flag;
> +};
> +
> +static const struct attr_name attr_list[] = {
> +	{ "append",	STATX_ATTR_APPEND },
> +	{ "automount",	STATX_ATTR_AUTOMOUNT },
> +	{ "compressed",	STATX_ATTR_COMPRESSED },
> +	{ "encrypted",	STATX_ATTR_ENCRYPTED },
> +	{ "immutable",	STATX_ATTR_IMMUTABLE },
> +	{ "nodump",	STATX_ATTR_NODUMP },
> +};
> +
> +static int attr_name_cmp(const void *_key, const void *_p)
> +{
> +	const char *key = _key;
> +	const struct attr_name *p = _p;
> +	return strcmp(key, p->name);
> +}
> +
>  struct file_type {
>  	const char *name;
>  	mode_t mode;
> @@ -128,6 +152,13 @@ void format(void)
>  	fprintf(stderr, "usage: %s [-v] [-m<mask>] <testfile> [checks]\n", prog);
>  	fprintf(stderr, "\t<mask> can be basic, all or a number; all is the default\n");
>  	fprintf(stderr, "checks is a list of zero or more of:\n");
> +	fprintf(stderr, "\tattr=[+-]<name> -- check an attribute in stx_attributes\n");
> +	fprintf(stderr, "\t\tappend -- The file is marked as append only\n");
> +	fprintf(stderr, "\t\tautomount -- The object is an automount point\n");
> +	fprintf(stderr, "\t\tcompressed -- The file is marked as compressed\n");
> +	fprintf(stderr, "\t\tencrypted -- The file is marked as encrypted\n");
> +	fprintf(stderr, "\t\timmutable -- The file is marked as immutable\n");
> +	fprintf(stderr, "\t\tnodump -- The file is marked as no-dump\n");
>  	fprintf(stderr, "\tcmp_ref -- check that the reference file has identical stats\n");
>  	fprintf(stderr, "\tref=<file> -- get reference stats from file\n");
>  	fprintf(stderr, "\tstx_<field>=<val> -- statx field value check\n");
> @@ -564,6 +595,40 @@ static void check_field(const struct statx *stx, char *arg)
>  }
>  
>  /*
> + * Check attributes in stx_attributes.  When stx_attributes_mask gets in
> + * upstream, we will need to consider that also.
> + */
> +static void check_attribute(const struct statx *stx, char *arg)
> +{
> +	const struct attr_name *p;
> +	__u64 attr;
> +	bool set;
> +
> +	verbose("check attr %s\n", arg);
> +	switch (arg[0]) {
> +	case '+': set = true;	break;
> +	case '-': set = false;	break;
> +	default:
> +		bad_arg("attr flag must be marked + (set) or - (unset)\n");
> +	}
> +	arg++;
> +
> +	p = bsearch(arg, attr_list, sizeof(attr_list) / sizeof(attr_list[0]),
> +		    sizeof(attr_list[0]), attr_name_cmp);
> +	if (!p)
> +		bad_arg("Unrecognised attr name '%s'\n", arg);
> +
> +	attr = p->attr_flag;
> +	if (set) {
> +		check(stx->stx_attributes && attr,
> +		      "Attribute %s should be set\n", arg);
> +	} else {
> +		check(~stx->stx_attributes && attr,
> +		      "Attribute %s should be unset\n", arg);
> +	}
> +}
> +
> +/*
>   * Do the testing.
>   */
>  int main(int argc, char **argv)
> @@ -669,6 +734,12 @@ int main(int argc, char **argv)
>  	for (; *argv; argv++) {
>  		char *arg = *argv;
>  
> +		if (strncmp("attr=", arg, 5) == 0) {
> +			/* attr=[+-]<attr> - check attribute flag */
> +			check_attribute(&stx, arg + 5);
> +			continue;
> +		}
> +
>  		if (strcmp("cmp_ref", arg) == 0) {
>  			/* cmp_ref - check ref file has same stats */
>  			cmp_ref(&stx, mask);
> diff --git a/tests/generic/421 b/tests/generic/421
> new file mode 100755
> index 0000000..a9eee4c
> --- /dev/null
> +++ b/tests/generic/421
> @@ -0,0 +1,149 @@
> +#! /bin/bash
> +# FS QA Test 421
> +#
> +# Test the statx stx_attribute flags that can be set with chattr
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
> +status=1
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	rm -f $seq-file
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
> +
> +function check_stat () {
> +    $here/src/stat_test $* || echo stat_test failed
> +}
> +
> +touch $seq-file

This $seq-file is created in xfstests root directory, not $TEST_DIR. It
should be "touch $TEST_DIR/$seq-file", or even better

testfile=$TEST_DIR/$seq-file
touch $testfile
<and refer to $testfile in _cleanup and subsequent tests>

> +
> +# Work out what chattrs are supported on the fs under test
> +a_supported=""
> +c_supported=""
> +d_supported=""
> +i_supported=""
> +a_list="0"
> +c_list="0"
> +d_list="0"
> +i_list="0"
> +
> +if chattr +a $seq-file >&/dev/null
> +then
> +    a_supported=1
> +    a_list="+a -a"
> +fi
> +
> +if chattr +c $seq-file >&/dev/null
> +then
> +    c_supported=1
> +    c_list="+c -c"
> +fi
> +
> +if chattr +d $seq-file >&/dev/null
> +then
> +    d_supported=1
> +    d_list="+d -d"
> +fi
> +
> +if chattr +i $seq-file >&/dev/null
> +then
> +    i_supported=1
> +    i_list="+i -i"
> +fi
> +
> +if [ "$a_supported$c_supported$d_supported$i_supported" = "" ]
> +then
> +    _notrun "file system doesn't support any of chattr +a/+c/+d/+i"
> +fi
> +
> +chattr -a -c -d -i $seq-file
> +
> +###############################################################################
> +#
> +# Now do the actual test.  We can turn on and off append (a), compressed (c),
> +# immutable (i) and no-dump (d) and theoretically see the output in the
> +# attribute flags.
> +#
> +# Note, however, that if the filesystem doesn't paste this info into
> +# stx_attributes, there's no way to tell the difference between cleared and
> +# unset.
> +#
> +###############################################################################
> +function try () {
> +    chattr ${a_supported:+$1} \
> +	   ${c_supported:+$2} \
> +	   ${d_supported:+$3} \
> +	   ${i_supported:+$4} \
> +	   $seq-file
> +    check_stat $seq-file \
> +	       ${a_supported:+attr=${1/a/append}} \
> +	       ${c_supported:+attr=${2/c/compressed}} \
> +	       ${d_supported:+attr=${3/d/nodump}} \
> +	       ${i_supported:+attr=${4/i/immutable}} \
> +	       stx_type=file \
> +	       stx_size=0 \
> +	       stx_rdev_major=0 \
> +	       stx_rdev_minor=0 \
> +	       stx_nlink=1
> +}
> +
> +for a in $a_list
> +do
> +    for c in $c_list
> +    do
> +	for d in $d_list
> +	do
> +	    for i in $i_list
> +	    do
> +		try $a $c $d $i
> +	    done
> +	done
> +    done
> +done
> +
> +# Done.  We leave the success determination to the output comparator.
> +status=0
> +exit
> diff --git a/tests/generic/421.out b/tests/generic/421.out
> new file mode 100644
> index 0000000..984fb43
> --- /dev/null
> +++ b/tests/generic/421.out
> @@ -0,0 +1 @@
> +QA output created by 421

Need a "Silence is golden" output to indicate this test expects no
output. (Yes, it's not documented, but at least it's in .out file
template :)

Thanks,
Eryu

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
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
