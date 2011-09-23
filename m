Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NG6PcK121139 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 11:06:26 -0500
Date: Fri, 23 Sep 2011 18:06:19 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add test 257: Check proper FITRIM argument
 handling
In-Reply-To: <1316790040.2879.37.camel@doink>
Message-ID: <alpine.LFD.2.00.1109231753090.3806@dhcp-27-109.brq.redhat.com>
References: <1316787311-23428-1-git-send-email-lczerner@redhat.com>
	<1316787311-23428-2-git-send-email-lczerner@redhat.com>
	<1316790040.2879.37.camel@doink>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Fri, 23 Sep 2011, Alex Elder wrote:

> On Fri, 2011-09-23 at 16:15 +0200, Lukas Czerner wrote:
> > This test suppose to validate that file systems are using the fitrim
> > arguments right. It checks that the fstrim returns EINVAl in case that
> > the start of the range is beyond the end of the file system, and also
> > that the fstrim works without an error if the length of the range is
> > bigger than the file system (it should be truncated to the file system
> > length automatically within the fitrim implementation).
> > 
> > This test should also catch common problem with overflow of start+len.
> > Some file systems (ext4,xfs) had overflow problems in the past so there
> > is a specific test for it (for ext4 and xfs) as well as generic test for
> > other file systems, but it would be nice if other fs can add their
> > specific checks if this problem does apply to them as well.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Better.  Now I'm taking a closer look and have a bunch
> of comments.  Note that I am not actually running the
> test so some of what I say may not apply.
> 
> 					-Alex
> 
> > ---
> > v2: add check for fsblock to agno overflow
> > v3: Update comments, use bc math
> > 
> >  257     |  183 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  257.out |   14 +++++
> >  group   |    1 +
> >  3 files changed, 198 insertions(+), 0 deletions(-)
> >  create mode 100755 257
> >  create mode 100644 257.out
> > 
> > diff --git a/257 b/257
> > new file mode 100755
> > index 0000000..4c820fd
> > --- /dev/null
> > +++ b/257
> > @@ -0,0 +1,183 @@
> > +#!/bin/bash
> > +# FS QA Test No. 251
> > +#
> > +# This test was created in order to verify filesystem FITRIM implementation.
> > +# By many concurrent copy and remove operations and checking that files
> > +# does not change after copied into SCRATCH_MNT test if FITRIM implementation
> > +# corrupts the filesystem (data/metadata).
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright 2010 (C) Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
> 
> Copyright date is wrong.
> 
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
> > +owner=lczerner@redhat.com
> > +
> > +seq=`basename $0`
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=`mktemp -d`
> > +status=0
> > +trap "exit \$status" 0 1 3
> > +trap "exit \$status" 2 15
> 
> Why two trap statements?

Some leftover stuff, will fix it.
> 
> > +chpid=0
> > +mypid=$$
> > +
> > +# get standard environment, filters and checks
> > +. ./common.rc
> > +. ./common.filter
> 
> . . .
> 
> > +echo "[+] Start beyond the end of fs with len set (should fail)"
> > +"$FSTRIM" -s$(_math "$fssize*2048") -l1M $SCRATCH_MNT
> > +[ $? -eq 0 ] && status=1
> 
> Since you reuse it a lot, maybe:
> beyond_eofs=$(_math "$fssize * 2048")
ok

> 
> > +echo "[+] Start = 2^64-1 (should fail)"
> > +"$FSTRIM" -s18446744073709551615 $SCRATCH_MNT
> 
> Since you now have the _math function at your disposal
> you can actually represent this symbolically (here and
> below).
ok

> 
> max64bit=$(_math "2^64 - 1")
> "$FSTRIM" -s${max64bit} $SCRATCH_MNT
> 
> > +[ $? -eq 0 ] && status=1
> > +
> > +echo "[+] Start = 2^64-1 and len is set (should fail)"
> > +"$FSTRIM" -s18446744073709551615 -l1M $SCRATCH_MNT
> > +[ $? -eq 0 ] && status=1
> > +
> > +_scratch_unmount
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +
> > +# All these tests should succeed
> > +# since the length should be truncated
> > +
> > +echo "[+] Default length (should succeed)"
> > +"$FSTRIM" $SCRATCH_MNT
> > +[ $? -ne 0 ] && status=1
> > +echo "[+] Default length with start set (should succeed)"
> > +"$FSTRIM" -s10M $SCRATCH_MNT
> > +[ $? -ne 0 ] && status=1
> > +echo "[+] Length beyond the end of fs (should succeed)"
> > +"$FSTRIM" -l$(_math "fssize*2048") $SCRATCH_MNT
> > +[ $? -ne 0 ] && status=1
> > +echo "[+] Length beyond the end of fs with start set (should succeed)"
> > +"$FSTRIM" -s10M -l$(_math "fssize*2048") $SCRATCH_MNT
> > +[ $? -ne 0 ] && status=1
> 
> Is there any need to make sure these tests both
> with the underlying storage not yet trimmed as
> well as with them already having been trimmed?
> As it is, the first trim (with all defaults) will
> trim the whole filesystem.  Then you're running
> a trim command that will trim starting at offset
> 10M to the end of filesystem, but that stuff's
> already gone by that point.
> 
> If it is important it may be that you should re-make
> the filesystem between tests.  You may be able to
> order the tests in such a way they aren't *always*
> re-made (but then again that may be yet more test
> cases... it depends on whether you're testing the
> fstrim interface handling of limits or whether you're
> testing what the filesystem does under varying
> circumstances).

The only thing we are trying to catch here is the argument handling, it
does not matter whether the discard will be issued or not. We just have
to make sure that the implementation does not return error on certain
circumstances.

> 
> > +_scratch_unmount
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +
> > +# This is a bit fuzzy, but since the file system is fresh
> > +# there should be at least (fssize/2) free space to trim.
> > +# This is supposed to catch wrong FITRIM argument handling
> > +out=$("$FSTRIM" -v -s10M $SCRATCH_MNT)
> > +bytes=${out%% *}
> 
> So this is verifying that trimming all but the first
> 10MB should never report more than the filesystem
> size as the number of bytes being requested to the
> filesystem to trim?  The man page only says that
> this reports the size requested, not the amount
> trimmed.  (Maybe my man page is wrong.)

Yes, it reports the number of bytes that has been requested to trim. We
just do not know what the block layer, or device itself will do with it,
and at this point we do not care. In this case we just have to make sure
that the implementation does not report anything bigger than the size of
the file system, since it would not make sense. Note that it is possible
to get it wrong because we are allowed to pass in much bigger 'len' then
the actual size of the file system and it should be adjusted by the
implementation.

> 
> > +if [ $bytes -gt $(_math "$fssize*1024") ]; then
> > +	status=1
> > +	echo "After the full fs discard $bytes bytes were discarded"\
> > +	     "however the file system is $(_math "$fssize*1024") bytes long."
> > +fi
> > +
> > +# Btrfs is special and this test does not apply to it
> > +# It is because btrfs does not have not-yet-used parts of the device
> > +# mapped and since we got here right after the mkfs, there is not
> > +# enough free extents in the root tree.
> > +if [ $bytes -le $(_math "$fssize*512") ] && [ $FSTYP != "btrfs" ]; then
> > +	status=1
> 
> Same comment as above.
> 
> > +	echo "After the full fs discard $bytes bytes were discarded"\
> > +	     "however the file system is $(_math "$fssize*1024") bytes long."
> > +fi
> > +
> > +# Now to catch overflows due to fsblk->allocation group number conversion
> > +# This is different for every file system and it also apply just to some of
> > +# them. In order to add check specific for file system you're interested in
> > +# compute the arguments as you need and make the file system with proper
> > +# alignment in function _check_conversion_overflow()
> 
> Looks like this function no longer exists.

oh, right.

> 
> > +
> > +# (2^32-1) + 2 (this is set to overflow 32bit variable by 2)
> > +base=$(_math "4294967295+2")
> 
> Consider using $(_math "2^32 + 1")
> 
> > +case $FSTYP in
> > +	ext[34])
> > +		agsize=32768
> > +		bsize=4096
> > +		start=$(_math "$base*$agsize*$bsize")
> > +		len=$(_math "$base*$agsize*$bsize")
> > +		export MKFS_OPTIONS="-F -b $bsize -g $agsize"
> > +		;;
> > +	xfs)
> > +		agsize=65538
> > +		bsize=4096
> > +		start=$(_math "$base*$agsize*$bsize")
> > +		len=$(_math "$base*$agsize*$bsize")
> > +		export MKFS_OPTIONS="-f -d agsize=$(_math "$agsize*$bsize") -b size=$bsize"
> > +		;;
> > +	*)
> > +		# (2^32-1) * 4096 * 65536 == 32bit max size * block size * ag size
> > +		start="1152921504875282432"
> 
> Here too, use _math()
> 
> > +		len="1152921504875282432"
> > +		;;
> > +esac
> > +
> > +_scratch_unmount
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +# It should fail since $start is beyond the end of file system
> > +"$FSTRIM" -s$start -l$(_math "$fssize/2") $SCRATCH_MNT &> /dev/null
> > +if [ $? -eq 0 ]; then
> > +	status=1
> > +	echo "It seems that fs logic handling start"\
> > +	     "argument overflows"
> > +fi
> > +
> > +_scratch_unmount
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +
> > +# len should be big enough to cover the whole file system, however this
> > +# test suppose for the overflow, so if the number of discarded bytes is
> 
> I'm not sure I understand this.  Do you mean "however this test is
> checking to see if overflow occurs, and if the result is smaller
> than fssize/2 then there most likely was an overflow"?

yes, exactly! however there are some words missing :) it should rather say:

# len should be big enough to cover the whole file system, so if the
# number of discarded bytes is smaller than fssize/2 then it most likely
# overflowed

> 
> > +# smaller than fssize/2 than it most likely does overflow.
> > +out=$("$FSTRIM" -v -l$len $SCRATCH_MNT)
> > +bytes=${out%% *}
> 
> This again assumes that the verbose flag reports
> what's trimmed, as opposed as how big the request
> to trim is.  (This may be a correct assumption.)
> 
> > +# Btrfs is special and this test does not apply to it
> > +# It is because btrfs does not have not-yet-used parts of the device
> > +# mapped and since we got here right after the mkfs, there is not
> > +# enough free extents in the root tree.
> 
> Move the calculation of "out" and "bytes" here, just
> before it's used and *after* the comment.
ok

> 
> > +if [ $bytes -le $(_math "$fssize*512") ] && [ $FSTYP != "btrfs" ]; then
> > +	status=1
> > +	echo "It seems that fs logic handling len argument overflows"
> > +fi
> > +
> > +echo "Test done"
> > +exit
> 
> . . .

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
