Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40647 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752633AbdJUAcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 20:32:11 -0400
Date: Fri, 20 Oct 2017 17:32:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [fstests] hardcoded values in common/rc for xfs (and probably
 others)
Message-ID: <20171021003208.GB4741@magnolia>
References: <CADxRZqwUfeGJOxsdEyaOHHJPmQUp8sNkxQdZPOKjyEejeZXMmA@mail.gmail.com>
 <20171020170558.GY4755@magnolia>
 <CADxRZqx2xitDTYG2cD21mYXFZvNKmNu6VdW+ftfom0wzgr-iUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADxRZqx2xitDTYG2cD21mYXFZvNKmNu6VdW+ftfom0wzgr-iUQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Anatoly Pugachev <matorola@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org

On Fri, Oct 20, 2017 at 10:56:56PM +0300, Anatoly Pugachev wrote:
> On Fri, Oct 20, 2017 at 8:05 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Fri, Oct 20, 2017 at 07:52:31PM +0300, Anatoly Pugachev wrote:
> >> Can someone look into this issue?
> >
> > Does the following xfstests patch help?
> >
> > --D
> >
> > diff --git a/common/punch b/common/punch
> > index c4ed261..5648bd8 100644
> > --- a/common/punch
> > +++ b/common/punch
> > @@ -341,13 +341,26 @@ _test_generic_punch()
> >         testfile=$6
> >         multiple=1
> >
> > +       # This routine was originally written for fallocate modes that
> > +       # don't have alignment requirements so the (sort of) hardcoded
> > +       # 4k offsets didn't matter.  fcollapse and finsert require
> > +       # block-aligned arguments, so increase $multiple until we get
> > +       # to the file's minimum data block size.
> > +       case "$zero_cmd" in
> > +       "fcollapse"|"finsert")
> > +               touch $testfile
> > +               bs=$(_get_file_block_size $testfile)
> > +               test "$bs" -gt 4096 && multiple=$((bs / 4096))
> > +               ;;
> > +       esac
> > +
> >         #
> >         # If we are testing collapse range, we increare all the offsets of this
> >         # test by a factor of 4. We do this because unlike punch, collapse
> >         # range also decreases the size of file hence require bigger offsets.
> >         #
> >         if [ "$zero_cmd" == "fcollapse" ]; then
> > -               multiple=4
> > +               multiple=$((multiple * 4))
> >         fi
> >
> >         _4k="$((multiple * 4))k"
> > diff --git a/common/rc b/common/rc
> > index fe68d67..b585016 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2063,8 +2063,8 @@ _require_xfs_io_command()
> >                 param_checked=1
> >                 ;;
> >         "fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
> > -               testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> > -                       -c "$command 4k 8k" $testfile 2>&1`
> > +               testio=`$XFS_IO_PROG -F -f -c "pwrite 0 256k" -c "fsync" \
> > +                       -c "$command 64k 128k" $testfile 2>&1`
> >                 ;;
> >         "fiemap")
> >                 testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> 
> Darrick,
> 
> I had to change from
> bs=$(_get_file_block_size $testfile)
> to
> bs=$(_get_file_block_size $testdir)
> 
> since _get_file_block_size gets directory as a parameter (and i'm
> puzzled why it's called _get_file_block_size, if it really wants a
> directory as a parameter, and there's _get_block_size as well).
> 
> the patch makes test as passed, but with error.
> 
> For example, with the default mkfs.xfs (4k block size), it is executed
> as follows:
> 
> root@ttip:xfstests-dev# mkfs.xfs -f /dev/vdiskb1
> specified blocksize 4096 is less than device physical sector size 8192
> switching to logical sector size 512
> meta-data=/dev/vdiskb1           isize=512    agcount=4, agsize=1966016 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0,
> rmapbt=0, reflink=0
> data     =                       bsize=4096   blocks=7864064, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=3839, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> root@ttip:xfstests-dev# ./check  generic/012
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/sparc64 ttip 4.14.0-rc5
> MKFS_OPTIONS  -- -f -m reflink=1 /dev/loop0
> MOUNT_OPTIONS -- /dev/loop0 /1/scratch
> 
> generic/012 2s ... 1s
> Ran: generic/012
> Passed all 1 tests
> 
> 
> but if I change block size, it ends with an error:
> 
> 
> root@ttip:xfstests-dev# mkfs.xfs -f -b size=8192 /dev/vdiskb1
> meta-data=/dev/vdiskb1           isize=512    agcount=4, agsize=983008 blks
>          =                       sectsz=8192  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0,
> rmapbt=0, reflink=0
> data     =                       bsize=8192   blocks=3932032, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=8192   ascii-ci=0 ftype=1
> log      =internal log           bsize=8192   blocks=1919, version=2
>          =                       sectsz=8192  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=8192   blocks=0, rtextents=0
> root@ttip:xfstests-dev# ./check  generic/012
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/sparc64 ttip 4.14.0-rc5
> MKFS_OPTIONS  -- -f -m reflink=1 /dev/loop0
> MOUNT_OPTIONS -- /dev/loop0 /1/scratch
> 
> generic/012 1s ... - output mismatch (see
> /1/mator/xfstests-dev/results/generic/012.out.bad)
>     --- tests/generic/012.out   2016-09-24 11:51:48.238890811 +0300
>     +++ /1/mator/xfstests-dev/results/generic/012.out.bad
> 2017-10-20 21:54:51.594814663 +0300
>     @@ -1,49 +1,49 @@
>      QA output created by 012
>         1. into a hole
>     -f4f35d60b3cc18aaa6d8d92f0cd3708a
>     +0a9156c4e3c48ef827980639c4d1e263
>         2. into allocated space
>     -0: [0..95]: extent
>     -f1894a71ac539f6f90426d98a4990a47

Oh, drat, md5 hashes.  I guess we'll have to increase the hardcoded
blocksize to 64k and fix all the resulting test failures. :(

Will try to do that next week.

--D

>     ...
>     (Run 'diff -u tests/generic/012.out
> /1/mator/xfstests-dev/results/generic/012.out.bad'  to see the entire
> diff)
> Ran: generic/012
> Failures: generic/012
> Failed 1 of 1 tests
> 
> root@ttip:xfstests-dev# cat results/generic/012.out.bad
> QA output created by 012
>         1. into a hole
> 0a9156c4e3c48ef827980639c4d1e263
>         2. into allocated space
> 0: [0..191]: extent
> 6f1f8907250bdbf673e1e55212b56b82
>         3. into unwritten space
> 0: [0..191]: extent
> 39bf78f7c676fdcf11558ad3a1a23aef
>         4. hole -> data
> 0: [0..127]: extent
> 1: [128..191]: hole
> c9a5ea7ad1648eee6202850420432dfc
>         5. hole -> unwritten
> 0: [0..127]: extent
> 1: [128..191]: hole
> 39bf78f7c676fdcf11558ad3a1a23aef
>         6. data -> hole
> 0: [0..63]: extent
> 1: [64..191]: hole
> 39bf78f7c676fdcf11558ad3a1a23aef
>         7. data -> unwritten
> 0: [0..127]: extent
> 1: [128..191]: hole
> 39bf78f7c676fdcf11558ad3a1a23aef
>         8. unwritten -> hole
> 0: [0..63]: extent
> 1: [64..191]: hole
> 39bf78f7c676fdcf11558ad3a1a23aef
>         9. unwritten -> data
> 0: [0..127]: extent
> 1: [128..191]: hole
> c9a5ea7ad1648eee6202850420432dfc
>         10. hole -> data -> hole
> 0: [0..63]: extent
> 1: [64..127]: hole
> d5755b0153a84fc6789af22ab8d1bb04
>         11. data -> hole -> data
> 0: [0..127]: extent
> 27c9068d1b51da575a53ad34c57ca5cc
>         12. unwritten -> data -> unwritten
> 0: [0..127]: extent
> d5755b0153a84fc6789af22ab8d1bb04
>         13. data -> unwritten -> data
> 0: [0..127]: extent
> 27c9068d1b51da575a53ad34c57ca5cc
>         14. data -> hole @ 0
> 0: [0..191]: extent
> 6f1f8907250bdbf673e1e55212b56b82
> root@ttip:xfstests-dev#
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
