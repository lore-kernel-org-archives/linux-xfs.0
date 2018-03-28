Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:33137 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbeC1FwF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 01:52:05 -0400
Subject: Re: [PATCH v2 3/3] fstests: generic: Check the fs after each FUA
 writes
References: <20180328044023.22078-1-wqu@suse.com>
 <20180328044023.22078-3-wqu@suse.com>
 <CAOQ4uxj5ff5-AhoACxZGG+ZeHRh0Qr_=uPqyzMUv5h934dicuQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2956631d-3843-aaf6-8d75-3a2028fea88b@gmx.com>
Date: Wed, 28 Mar 2018 13:51:44 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj5ff5-AhoACxZGG+ZeHRh0Qr_=uPqyzMUv5h934dicuQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q0JisRMqMK0fBlmSdyR7usOEwLgyNJHnP"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q0JisRMqMK0fBlmSdyR7usOEwLgyNJHnP
Content-Type: multipart/mixed; boundary="1GISOmHh2BjpTh9UJjbYfCMDx0vWWYyNg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
 fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>,
 Ext4 <linux-ext4@vger.kernel.org>
Message-ID: <2956631d-3843-aaf6-8d75-3a2028fea88b@gmx.com>
Subject: Re: [PATCH v2 3/3] fstests: generic: Check the fs after each FUA
 writes
References: <20180328044023.22078-1-wqu@suse.com>
 <20180328044023.22078-3-wqu@suse.com>
 <CAOQ4uxj5ff5-AhoACxZGG+ZeHRh0Qr_=uPqyzMUv5h934dicuQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxj5ff5-AhoACxZGG+ZeHRh0Qr_=uPqyzMUv5h934dicuQ@mail.gmail.com>

--1GISOmHh2BjpTh9UJjbYfCMDx0vWWYyNg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8828=E6=97=A5 13:04, Amir Goldstein wrote:
> On Wed, Mar 28, 2018 at 7:40 AM, Qu Wenruo <wqu@suse.com> wrote:
>> Basic test case which triggers fsstress with dm-log-writes, and then
>> check the fs after each FUA writes.
>> With needed infrastructure and special handlers for journal based fs.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> changelog:
>> v2:
>>   Use proper "SUSE Linux Products GmbH" instead of "SuSE"
>>   Get rid of dm-snapshot which is pretty slow if we're creating and
>>   deleting snapshots repeatedly.
>>   (Maybe LVM thin provision would be much better, but current replay
>>    solution is good so far, and no slower than dm-snapshot)
>>   Add back run_check so that we can get the seed.
>> ---
>> Unfortunately, neither xfs nor ext4 survies this test for even single
>> success, while btrfs survives.
>> (Although not what I want, I'm just trying my luck
>> to reproduce a serious btrfs corruption situation)
>>
>> Although btrfs may be the fastest fs for the test, since it has fixed
>> small amount of write in mkfs and almost nothing to replay, it still
>> takes about 240s~300s to finish (the same level using snapshot).
>>
>> It would take longer time for ext4 for its large amount of write durin=
g
>> mkfs, if it can survive the test in the first space.
>=20
> Hmm, how much time would the total test would take if you don't fail
> it on fsck? I am asking because it may be possible to improve this with=

> only a single snapshot after mkfs.

The only fs which can pass the test right now is btrfs, so other
estimation is mostly based on guess.

>=20
> Anyway, if total test run time is expected to be under 10min I wouldn't=

> bother with this optimization, at least not right now. IMO it is more
> important to get the test out there to get the corruption bugs floating=
=2E

I'd say from current status, if XFS doesn't fail, it would definitely
finish in 10min.
For EXT4 I'm not pretty sure.

I'd like to  keep current test case as simple as possible right now, and
for later enhancement, I have several different ideas:

1) Reflink fs + loopback
   Yep, use btrfs/xfs as base filesystem and create copy using reflink,
   then use such files as loopback device.
   The good thing is, AFAIK btrfs/xfs reflink is really fast.
   Much much faster than dm-snapshot or even LVM thin.

   The much much smaller block size (4K default) makes CoW overhead
   (LVM thin is 64K, not sure about dm-snapshot though).

   The problem is, such setup needs extra mount point and can be a
   little hard to setup, and we're introducing another layer of fs,
   if the fs itself has some hidden bug, it would screw up the test
   case.

2) LVM thin provision
   LVM thin provision looks much like btrfs/xfs for block level, and
   smaller default block size (64K vs original 2M) makes CoW overhead
   smaller.

   I'm currently testing this method, the good thing is it's a little
   easier to setup and we can use single mount point.

Anyway, with proper and efficient snapshot ability implemented, I will
definitely convert this test case, and add Flush test case.

Thanks for your review too,
Qu

>=20
> Thanks for working on this!
> You can add
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>=20
>=20
>>
>> As a comparison, btrfs takes about 5 seconds to replay log, mount,
>> unmount and run fsck at the end of the test.
>> But for ext4, it already takes about 5 seconds to do the same thing
>> before triggering fsck error.
>>
>> Fsck fail for ext4:
>> _check_generic_filesystem: filesystem on /dev/mapper/test-scratch1 is =
inconsistent
>> *** fsck.ext4 output ***
>> fsck from util-linux 2.31.1
>> e2fsck 1.43.8 (1-Jan-2018)
>> Pass 1: Checking inodes, blocks, and sizes
>> Inode 131076 extent tree (at level 1) could be shorter.  Fix? no
>>
>> Inode 131262, i_size is 0, should be 258048.  Fix? no
>>
>> Pass 2: Checking directory structure
>> Pass 3: Checking directory connectivity
>> Pass 4: Checking reference counts
>> Pass 5: Checking group summary information
>>
>> For xfs:
>> _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch1 is inco=
nsistent (r)
>> *** xfs_repair -n output ***
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - zero log...
>>         - scan filesystem freespace and inode maps...
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan (but don't clear) agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno =3D 0
>>         - agno =3D 1
>>         - agno =3D 2
>> bad symlink header ino 8409190, file block 0, disk block 1051147
>> problem with symbolic link in inode 8409190
>> would have cleared inode 8409190
>>         - agno =3D 3
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>>         - check for inodes claiming duplicate blocks...
>>         - agno =3D 0
>>         - agno =3D 1
>>         - agno =3D 3
>>         - agno =3D 2
>> entry "lb" in shortform directory 8409188 references free inode 840919=
0
>> would have junked entry "lb" in directory inode 8409188
>> bad symlink header ino 8409190, file block 0, disk block 1051147
>> problem with symbolic link in inode 8409190
>> would have cleared inode 8409190
>> No modify flag set, skipping phase 5
>> Phase 6 - check inode connectivity...
>>         - traversing filesystem ...
>> entry "lb" in shortform directory inode 8409188 points to free inode 8=
409190
>> would junk entry
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> Phase 7 - verify link counts...
>> Maximum metadata LSN (1:396) is ahead of log (1:63).
>> Would format log to cycle 4.
>> No modify flag set, skipping filesystem flush and exiting.
>>
>> And special note for XFS guys, I also hit an XFS internal metadata
>> warning during journal replay:
>> [ 7901.423659] XFS (dm-4): Starting recovery (logdev: internal)
>> [ 7901.577511] XFS (dm-4): Metadata corruption detected at xfs_dinode_=
verify+0x467/0x570 [xfs], inode 0x805067 dinode
>> [ 7901.580529] XFS (dm-4): Unmount and run xfs_repair
>> [ 7901.581901] XFS (dm-4): First 128 bytes of corrupted metadata buffe=
r:
>> [ 7901.583205] 00000000b8963f41: 49 4e a1 ff 03 02 00 00 00 00 00 00 0=
0 00 00 00  IN..............
>> [ 7901.584659] 00000000f35a50e0: 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00  ................
>> [ 7901.586075] 00000000386eea9e: 5a b2 0e 69 0a f3 43 27 5a b2 0e 69 0=
a f3 43 27  Z..i..C'Z..i..C'
>> [ 7901.587561] 00000000ac636661: 5a b2 0e 69 0d 92 bc 00 00 00 00 00 0=
0 00 00 00  Z..i............
>> [ 7901.588969] 00000000d75f9093: 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00  ................
>> [ 7901.590475] 00000000d2af5688: 00 00 00 02 00 00 00 00 00 00 00 00 8=
4 d7 6a e9  ..............j.
>> [ 7901.591907] 00000000e8dd8211: ff ff ff ff 34 93 a9 3a 00 00 00 00 0=
0 00 00 04  ....4..:........
>> [ 7901.593319] 00000000b7610e4e: 00 00 00 01 00 00 00 45 00 00 00 00 0=
0 00 00 00  .......E........
>> ---
>>
>>  common/dmlogwrites    |  56 +++++++++++++++++++++++++++
>>  tests/generic/481     | 104 +++++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  tests/generic/481.out |   2 +
>>  tests/generic/group   |   1 +
>>  4 files changed, 163 insertions(+)
>>  create mode 100755 tests/generic/481
>>  create mode 100644 tests/generic/481.out
>>
>> diff --git a/common/dmlogwrites b/common/dmlogwrites
>> index 467b872e246f..bf643a77ad09 100644
>> --- a/common/dmlogwrites
>> +++ b/common/dmlogwrites
>> @@ -126,3 +126,59 @@ _log_writes_cleanup()
>>         $UDEV_SETTLE_PROG >/dev/null 2>&1
>>         _log_writes_remove
>>  }
>> +
>> +# Convert log writes mark to entry number
>> +# Result entry number is output to stdout, could be empty if not foun=
d
>> +_log_writes_mark_to_entry_number()
>> +{
>> +       local mark=3D$1
>> +       local ret
>> +
>> +       [ -z "$mark" ] && _fatal \
>> +               "mark must be given for _log_writes_mark_to_entry_numb=
er"
>> +
>> +       ret=3D$($here/src/log-writes/replay-log --find --log $LOGWRITE=
S_DEV \
>> +               --end-mark $mark 2> /dev/null)
>> +       [ -z "$ret" ] && return
>> +       ret=3D$(echo "$ret" | cut -f1 -d\@)
>> +       echo "mark $mark has entry number $ret" >> $seqres.full
>> +       echo "$ret"
>> +}
>> +
>> +# Find next fua write entry number
>> +# Result entry number is output to stdout, could be empty if not foun=
d
>> +_log_writes_find_next_fua()
>> +{
>> +       local start_entry=3D$1
>> +       local ret
>> +
>> +       [ -z "$start_entry" ] && start_entry=3D0
>> +       ret=3D$($here/src/log-writes/replay-log --find --log $LOGWRITE=
S_DEV \
>> +             --next-fua --start-entry $start_entry 2> /dev/null)
>> +       [ -z "$ret" ] && return
>> +
>> +       # Result should be something like "1024@offset" where 1024 is =
the
>> +       # entry number we need
>> +       ret=3D$(echo "$ret" | cut -f1 -d\@)
>> +       echo "next fua is entry number $ret" >> $seqres.full
>> +       echo "$ret"
>> +}
>> +
>> +# Replay log range to specified entry
>> +# $1:  End entry. The entry with this number *WILL* be replayed
>> +_log_writes_replay_log_range()
>> +{
>> +       local end=3D$1
>> +
>> +       [ -z "$end" ] && _fail \
>> +       "end entry must be specified for _log_writes_replay_log_range"=

>> +
>> +       # To ensure we replay the last entry,
>> +       # we need to manually increase the end entry number to ensure
>> +       # it's played
>> +       echo "=3D=3D=3D replay to $end =3D=3D=3D" >> $seqres.full
>> +       $here/src/log-writes/replay-log --log $LOGWRITES_DEV \
>> +               --replay $SCRATCH_DEV --limit $(($end + 1)) \
>> +               >> $seqres.full 2>&1
>> +       [ $? -ne 0 ] && _fail "replay failed"
>> +}
>> diff --git a/tests/generic/481 b/tests/generic/481
>> new file mode 100755
>> index 000000000000..6b03786c8cb4
>> --- /dev/null
>> +++ b/tests/generic/481
>> @@ -0,0 +1,104 @@
>> +#! /bin/bash
>> +# FS QA Test 481
>> +#
>> +# Test filesystem consistency after each FUA operation
>> +#
>> +# Will do log replay and check the filesystem.
>> +#
>> +#--------------------------------------------------------------------=
---
>> +# Copyright (c) 2018 SUSE Linux Products GmbH.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation=
,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#--------------------------------------------------------------------=
---
>> +#
>> +
>> +seq=3D`basename $0`
>> +seqres=3D$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=3D`pwd`
>> +tmp=3D/tmp/$$
>> +status=3D1       # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +       cd /
>> +       $KILLALL_PROG -KILL -q $FSSTRESS_PROG &> /dev/null
>> +       _log_writes_cleanup &> /dev/null
>> +       rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/dmlogwrites
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs generic
>> +_supported_os Linux
>> +
>> +_require_command "$KILLALL_PROG" killall
>> +# Use $SCRATCH_DEV as replay device
>> +_require_scratch
>> +# and we need extra device as log device
>> +_require_log_writes
>> +
>> +
>> +nr_cpus=3D$("$here/src/feature" -o)
>> +fsstress_args=3D$(_scale_fsstress_args -w -d $SCRATCH_MNT -n 512 -p $=
nr_cpus \
>> +               $FSSTRESS_AVOID)
>> +
>> +_test_unmount
>> +_log_writes_init
>> +_log_writes_mkfs >> $seqres.full 2>&1
>> +_log_writes_mark mkfs
>> +
>> +_log_writes_mount
>> +run_check $FSSTRESS_PROG $fsstress_args > /dev/null 2>&1
>=20
> I am not sure that is what Eryu meant, but he can fix that on commit.
>=20
>> +_log_writes_unmount
>> +
>> +_log_writes_remove
>> +prev=3D$(_log_writes_mark_to_entry_number mkfs)
>> +[ -z "$prev" ] && _fail "failed to locate entry mark 'mkfs'"
>> +cur=3D$(_log_writes_find_next_fua $prev)
>> +[ -z "$cur" ] && _fail "failed to locate next FUA write"
>> +
>> +while [ ! -z "$cur" ]; do
>> +       _log_writes_replay_log_range $cur >> $seqres.full
>> +
>> +       # Here we need extra mount to replay the log, mainly for journ=
al based
>> +       # fs, as their fsck will report dirty log as error.
>> +       # We don't care to preserve any data on $SCRATCH_DEV, as we ca=
n replay
>> +       # back to the point we need, and in fact sometimes creating/de=
leting
>> +       # snapshots repeatedly can be slower than replaying the log.
>> +       _scratch_mount
>> +       _scratch_unmount
>> +       _check_scratch_fs
>> +
>> +       prev=3D$cur
>> +       cur=3D$(_log_writes_find_next_fua $(($cur + 1)))
>> +       [ -z "$cur" ] && break
>> +done
>> +
>> +echo "Silence is golden"
>> +
>> +# success, all done
>> +status=3D0
>> +exit
>> diff --git a/tests/generic/481.out b/tests/generic/481.out
>> new file mode 100644
>> index 000000000000..206e11635bd6
>> --- /dev/null
>> +++ b/tests/generic/481.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 481
>> +Silence is golden
>> diff --git a/tests/generic/group b/tests/generic/group
>> index ea2056b1e93c..c4cc800aa2aa 100644
>> --- a/tests/generic/group
>> +++ b/tests/generic/group
>> @@ -483,3 +483,4 @@
>>  478 auto quick
>>  479 auto quick metadata
>>  480 auto quick metadata
>> +481 auto replay
>=20
> IMO metadata group is also appropriate.
>=20
> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--1GISOmHh2BjpTh9UJjbYfCMDx0vWWYyNg--

--q0JisRMqMK0fBlmSdyR7usOEwLgyNJHnP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq7LXAACgkQwj2R86El
/qhnBwf/YRGY9qcSdwJeZXafF10ubs73cF3nYUcRvYT8QmoBjd+L+uRtW7sZbjj7
zeWFRr3aFkSFIRdMt7bfwHjTOzl7sUxDOjD/6kMNQrdX0f2U5B6NHLyfVtkpRDEZ
27/f6JHKVTyGmzarKedErxn1Y6WC97MkFF3NjHKwNG0FAflLFYM0zPljzTQirAMg
c0SK4Lk4PfyyLiYRCh3qfFl/jRCrZ1jMldE+ZxAaiRXLoOkz1t+NiDgk7Rx4CYPS
2BksLhGSnzkFny7EsUlhmx9J38ZVdzLH1ZAzgFCv6eVb7rk/mh09CLnEQvAdXwFy
X88y8dAZ8v+tyqu5hPU+XKP22JBYfQ==
=bqri
-----END PGP SIGNATURE-----

--q0JisRMqMK0fBlmSdyR7usOEwLgyNJHnP--
