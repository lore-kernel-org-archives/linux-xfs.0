Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35545 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdDDLe5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2017 07:34:57 -0400
MIME-Version: 1.0
In-Reply-To: <149129917749.27400.15662735475670266227.stgit@warthog.procyon.org.uk>
References: <149129915546.27400.6279610388611835844.stgit@warthog.procyon.org.uk>
 <149129917749.27400.15662735475670266227.stgit@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 4 Apr 2017 14:34:55 +0300
Message-ID: <CAOQ4uxjcVFzDudSPb3aB+kohJKb=nrOVJRrYbb_DzCZwtZA2-A@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr
 [ver #4]
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Apr 4, 2017 at 12:46 PM, David Howells <dhowells@redhat.com> wrote:
> Check the stx_attributes that can be set by calling chattr.
>
> The script probes the filesystem with chattr to find out which of +a, +c,
> +d and +i are supported before testing combinations of attrs.  Note that if
> a filesystem supports chattr with these, but doesn't paste the flag values
> into stx_attributes, the test will fail as there's no way to distinguish
> cleared from unset.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---

Looks good. minor comment below.

> +
> +touch $seq-file
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
> +    # We really want to say "skipped" here

Easy. either:

_require_chattr acdi

OR:

 _notrun "file system doesn't support any of chattr +a/+c/+d/+i"

> +    status=0
> +    exit

_notrun already sets status and exists

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
> +          ${c_supported:+$2} \
> +          ${d_supported:+$3} \
> +          ${i_supported:+$4} \
> +          $seq-file
> +    check_stat $seq-file \
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


So I see we have ~40 tests with the one liner output
and ~150 tests with "Silence is golden" output.

Eryu,

Do you have a strong preference to either?
Should we have tests with no output stick to one standard?
I personally don't mind.

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
