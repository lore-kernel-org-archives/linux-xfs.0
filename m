Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35902 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdDENpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2017 09:45:15 -0400
MIME-Version: 1.0
In-Reply-To: <149139658242.12368.4089798272550801222.stgit@warthog.procyon.org.uk>
References: <149139655968.12368.18434671350530288572.stgit@warthog.procyon.org.uk>
 <149139658242.12368.4089798272550801222.stgit@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 5 Apr 2017 16:45:13 +0300
Message-ID: <CAOQ4uxhsv2xyUCXh08sOOYa1Lc80FKtUm5a1fmrEFhi70SR2-g@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr
 [ver #6]
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 5, 2017 at 3:49 PM, David Howells <dhowells@redhat.com> wrote:
> Check the stx_attributes that can be set by calling chattr.
>
> The script probes the filesystem with chattr to find out which of +a, +c,
> +d and +i are supported before testing combinations of attrs.  Note that if
> a filesystem supports chattr with these, but doesn't paste the flag values
> into stx_attributes, the test will fail as there's no way to distinguish
> cleared from unset.
>
> Certain chattr flags are reflected in specific stx_attributes flags:
>
>         chattr flag     stx_attributes flag
>         +a              STATX_ATTR_APPEND
>         +c              STATX_ATTR_COMPRESSED
>         +d              STATX_ATTR_NODUMP
>         +i              STATX_ATTR_IMMUTABLE
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
[...]

> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*

You need to
$CHATTR_PROG -a -i $testfile

otherwise rm will fail on non clean exit

> +       rm -f $testfile
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

I am only giving this comment because your new documentation
reminded me about it... I hope this won't discourage you from keep
writing more docs :-)

_require_command "$CHATTR_PROG" chattr

For the record, there is only one test that does this out
of 38 tests that use chattr. As you have already realized, there
are some good practices in xfstests that grew over the years,
but some tests date back to before those practices and some
tests we just did not review well enough...

I feel the need to apologize for the number of review rounds
because I keep noticing new nits. I am also new to this.
Thanks for your patience!

> +
> +function check_stat () {
> +    $here/src/stat_test $* || echo stat_test failed
> +}
> +
> +testfile=$TEST_DIR/$seq-file
> +touch $testfile
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
> +if chattr +a $testfile >&/dev/null

$CHATTR_PROG +a (and all below)

> +then
> +    a_supported=1
> +    a_list="+a -a"
> +fi
> +
> +if chattr +c $testfile >&/dev/null
> +then
> +    c_supported=1
> +    c_list="+c -c"
> +fi
> +
> +if chattr +d $testfile >&/dev/null
> +then
> +    d_supported=1
> +    d_list="+d -d"
> +fi
> +
> +if chattr +i $testfile >&/dev/null
> +then
> +    i_supported=1
> +    i_list="+i -i"
> +fi
> +
> +echo "a=$a_supported d=$d_supported c=$c_supported i=$i_supported" >>$seqres.full
> +
> +if [ "$a_supported$c_supported$d_supported$i_supported" = "" ]
> +then
> +    _notrun "file system doesn't support any of chattr +a/+c/+d/+i"
> +fi
> +
> +chattr -a -c -d -i $testfile
> +
> +###############################################################################
> +#
> +# Now do the actual test.  We can turn on and off append (a), compressed (c),
> +# immutable (i) and no-dump (d) and theoretically see the output in the
> +# attribute flags.  The following associations can be seen:
> +#
> +#      chattr flag     stx_attributes flag
> +#      +a              STATX_ATTR_APPEND
> +#      +c              STATX_ATTR_COMPRESSED
> +#      +d              STATX_ATTR_NODUMP
> +#      +i              STATX_ATTR_IMMUTABLE
> +#
> +# Note, however, that if the filesystem doesn't paste this information into
> +# stx_attributes, there's no way to tell the difference between cleared and
> +# unset.
> +#
> +###############################################################################
> +function try () {
> +    echo Trying "$*" >>$seqres.full
> +    chattr ${a_supported:+$1} \
> +          ${c_supported:+$2} \
> +          ${d_supported:+$3} \
> +          ${i_supported:+$4} \
> +          $testfile
> +    check_stat $testfile \
> +              ${a_supported:+attr=${1/a/append}} \
> +              ${c_supported:+attr=${2/c/compressed}} \
> +              ${d_supported:+attr=${3/d/nodump}} \
> +              ${i_supported:+attr=${4/i/immutable}} \
> +              stx_type=file \
> +              stx_size=0 \
> +              stx_rdev_major=0 \
> +              stx_rdev_minor=0 \
> +              stx_nlink=1
> +}
> +
> +for a in $a_list
> +do
> +    for c in $c_list
> +    do
> +       for d in $d_list
> +       do
> +           for i in $i_list
> +           do
> +               try $a $c $d $i
> +           done
> +       done
> +    done
> +done
> +
> +# For tradition's sake

For tradition's sake, better add it to 420 as well ;-)

> +echo "Silence is golden"
> +
> +# Done.  We leave the success determination to the output comparator.
> +status=0
> +exit
> diff --git a/tests/generic/421.out b/tests/generic/421.out
> new file mode 100644
> index 0000000..6986277
> --- /dev/null
> +++ b/tests/generic/421.out
> @@ -0,0 +1,2 @@
> +QA output created by 421
> +Silence is golden
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
