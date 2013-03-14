Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7670E7FAA
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 18:26:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5FE96304048
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 16:26:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mBw8dwwKQeoyC7L8 for
	<xfs@oss.sgi.com>; Thu, 14 Mar 2013 16:26:34 -0700 (PDT)
Message-ID: <51425CA6.3010100@redhat.com>
Date: Thu, 14 Mar 2013 18:26:30 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: test writing to device node on an RO filesystem
References: <514243C0.1000309@redhat.com>
	(sfid-20130315_001049_792066_0DB10787)
	<201303150020.57326.Martin@lichtvoll.de>
In-Reply-To: <201303150020.57326.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

On 3/14/13 6:20 PM, Martin Steigerwald wrote:
> Am Donnerstag, 14. M=E4rz 2013 schrieb Eric Sandeen:
>> we should be able to open device nodes for writing even
>> if they live on a readonly filesytem.
> =

> Just saw a typo. See below.

Just informational ;)  Ok, I can fix it up unless SGI just does it on merge.

Thanks,
-Eric

>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> (I may have *cough* broken this on a backport once, hence the test)
>>
>> diff --git a/315 b/315
>> new file mode 100755
>> index 0000000..8b8ecc6
>> --- /dev/null
>> +++ b/315
>> @@ -0,0 +1,79 @@
>> +#! /bin/bash
>> +# FS QA Test No. 315
>> +#
>> +# Test that we can write to a device node residing on a RO filesystem
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#-----------------------------------------------------------------------
>> +#
>> +# creator
>> +owner=3Dsandeen@redhat.com
>> +
>> +seq=3D`basename $0`
>> +echo "QA output created by $seq"
>> +
>> +here=3D`pwd`
>> +tmp=3D/tmp/$$
>> +status=3D1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    cd /
>> +    rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common.rc
>> +. ./common.filter
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_scratch
>> +
>> +DEVNULL=3D$SCRATCH_MNT/devnull
>> +DEVZERO=3D$SCRATCH_MNT/devzero
>> +
>> +_scratch_mount
>> +
>> +rm -f $DEVNULL $DEVZERO
>> +
>> +mknod $DEVNULL c 1 3 || _fail "Could not create devnull device"
>> +mknod $DEVZERO c 1 5 || _fail "Could not create devzero device"
>> +
>> +_scratch_unmount || _fail "Could not unmount scratch device"
>> +_scratch_mount -o ro || _fail "Could not remount scratch readonly"
>> +
>> +# We should be able to read & write to/from these devices even on an RO
>> fs +echo "=3D=3D try to create new file"
>> +touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
>> +echo "=3D=3D prite to null device"
> =

> prite =3D> pwrite
> =

>> +xfs_io -c "pwrite 0 512" /dev/null | _filter_xfs_io
>> +echo "=3D=3D pread from zero device"
>> +xfs_io -c "pread 0 512" /dev/zero | _filter_xfs_io
>> +
>> +echo "=3D=3D truncating write to null device"
>> +echo foo >> $DEVNULL 2>&1 | _filter_scratch
>> +echo "=3D=3D appending write to null device"
>> +echo foo >> $DEVNULL 2>&1 | _filter_scratch
>> +
>> +# success, all done
>> +status=3D0
>> +exit
>> diff --git a/315.out b/315.out
>> new file mode 100644
>> index 0000000..d07c567
>> --- /dev/null
>> +++ b/315.out
>> @@ -0,0 +1,11 @@
>> +QA output created by 315
>> +=3D=3D try to create new file
>> +touch: cannot touch `SCRATCH_MNT/this_should_fail': Read-only file
>> system +=3D=3D prite to null device
>> +wrote 512/512 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +=3D=3D pread from zero device
>> +read 512/512 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +=3D=3D truncating write to null device
>> +=3D=3D appending write to null device
>> diff --git a/group b/group
>> index fcbdfb6..fd838ef 100644
>> --- a/group
>> +++ b/group
>> @@ -430,3 +430,4 @@ stress
>>  305 aio dangerous enospc rw stress
>>  313 auto quick
>>  314 auto
>> +315 auto rw
> =

> Thanks,
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
