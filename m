Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88E6E7F56
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 00:04:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B816304059
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 22:04:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GnmOVyRMkcNNjQeF for <xfs@oss.sgi.com>;
	Thu, 17 Oct 2013 22:04:20 -0700 (PDT)
Message-ID: <5260C153.6000601@sandeen.net>
Date: Fri, 18 Oct 2013 00:04:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Test xfs_fsr / swapext management of di_forkoff
	w/ selinux
References: <5260B62D.2010507@redhat.com>
	<20131018044822.GD11404@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20131018044822.GD11404@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/17/13 11:48 PM, Eryu Guan wrote:
> On Thu, Oct 17, 2013 at 11:16:45PM -0500, Eric Sandeen wrote:
>> In some cases selinux's creation of an xattr on the temporary
>> fd creates a local xattr, but the file we are trying to 
>> defragment has attrs in extent format, and the forkoff mismatch
>> will cause xfs_fsr to fail.  This test demonstrates it;  I
>> have old patches sent to the list long ago that should fix
>> it.  I'll resend them soon.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/tests/xfs/351 b/tests/xfs/351
>> new file mode 100755
>> index 0000000..b21ba7a
>> --- /dev/null
>> +++ b/tests/xfs/351
>> @@ -0,0 +1,89 @@
>> +#! /bin/bash
>> +# FS QA Test No. 350
>> +#
>> +# Test xfs_fsr / swapext management of di_forkoff w/ selinux
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
> 
> Seems we don't need "creator" in comment now.

yup

>> +
>> +seq=`basename $0`
> 
> Forgot about "seqres=$RESULT_DIR/$seq" ?

crud. :)

...

>> +# Create an extents-format attribute on a file
>> +xfs_io -f -c "pwrite -S 0x63 0 4096" $SCRATCH_MNT/attrvals 2>&1 &> $seqres.full
> 
> Use $XFS_IO_PROG instead?

yup
 
> And seems "2>&1" is redundant, "&>" can do the work.

heh, yeah. Ok, will tidy up and resend tomorrow.

Thanks!

-Eric
 
> Thanks,
> Eryu Guan
> 
>> +cat $SCRATCH_MNT/attrvals | attr -s name $SCRATCH_MNT/$seq.test 2>&1 &> $seqres.full
>> +
>> +# Fragment the file by writing backwards
>> +for I in `seq 6 -1 0`; do
>> +	dd if=/dev/zero of=$SCRATCH_MNT/$seq.test seek=$I bs=4k \
>> +	   oflag=direct count=1 conv=notrunc 2>&1 &> $seqres.full
>> +done
>> +
>> +# See if xfs_fsr works.
>> +
>> +# The target file now has a non-local attribute, but the
>> +# fsr temp file gets assigned a local attribute on creation,
>> +# due to selinux.
>> +    
>> +# In this case, the large-ish selinux attr will create a forkoff
>> +# in the temp file smaller than the forkoff in the target file,
>> +# because the FMT_EXTENTS attr takes up less space.  If there is
>> +# no mechanism to grow the temp forkoff to match, we can end up
>> +# failing to swap these 2 inodes if the result is not enough
>> +# data space in the temp inode as a result.
>> +
>> +$XFS_FSR_PROG -v $SCRATCH_MNT/$seq.test | _filter_scratch
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/xfs/351.out b/tests/xfs/351.out
>> new file mode 100644
>> index 0000000..86cbe5d
>> --- /dev/null
>> +++ b/tests/xfs/351.out
>> @@ -0,0 +1,3 @@
>> +QA output created by 351
>> +SCRATCH_MNT/351.test
>> +extents before:6 after:1 DONE SCRATCH_MNT/351.test
>> diff --git a/tests/xfs/group b/tests/xfs/group
>> index acb92ac..da76770 100644
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -180,4 +180,4 @@
>>  298 auto attr symlink quick
>>  299 auto quota
>>  350 auto dump quota
>> -
>> +351 auto fsr
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
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
