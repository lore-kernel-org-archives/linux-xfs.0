Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QIbqEt249245 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 13:37:52 -0500
Message-ID: <508AD8E8.1040301@redhat.com>
Date: Fri, 26 Oct 2012 13:39:36 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: xfstests: test ext4 statfs
References: <5089749C.4050003@redhat.com> <508AD066.4090102@sgi.com>
In-Reply-To: <508AD066.4090102@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 10/26/12 1:03 PM, Rich Johnston wrote:
> On 10/25/2012 12:19 PM, Eric Sandeen wrote:
>> Calculating free blocks in ext[234] is surprisingly hard, since
>> by default we report "bsd" style df which doesn't count filesystem
>> "overhead" blocks as used.
>>
>> With a lot of code dedicated to sorting out what to report as
>> free, things tend to go wrong surprisingly often.
>>
>> Here's a test to actually try to stop the next regression.  ;)
>>
>> NB: For bsddf, the kernel currently does not count journal blocks
>> as overhead; it probably should.  But the test below looks to have
>> the result within 1% of perfection, so it still passes even if
>> the kernel doesn't count the journal against free blocks.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> ---
>>
>>
>> diff --git a/289 b/289
>> new file mode 100755
>> index 0000000..bf0e897
>> --- /dev/null
>> +++ b/289
>> @@ -0,0 +1,103 @@
>> +#! /bin/bash
>> +# FS QA Test No. 286
>                       ^
>                     289
> I know this may change at commit time. ;)

meh, right.  Dumb to have it in the file, maybe.

>> +#
>> +# Test overhead & df output for extN filesystems
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
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
>> +owner=sandeen@redhat.com
>> +
>> +seq=`basename $0`
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1    # failure is the default!
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
>> +. ./common.filter# ./check 289
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 cxfsxe4 3.7.0-rc2+
> MKFS_OPTIONS  -- /dev/sdc2
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sdc2 /xfs_scratch
> 
> 289     - output mismatch (see 289.out.bad)
> --- 289.out    2012-10-26 12:33:27.000000000 -0500
> +++ 289.out.bad    2012-10-26 12:35:03.000000000 -0500
> @@ -1,3 +1,4 @@
>  QA output created by 289
> -minix f_blocks is in range
> +minix f_blocks has value of 7208959
> +minix f_blocks is NOT in range 7323904 .. 7323904
>  bsd f_blocks is in range
> Ran: 289
> Failures: 289
> Failed 1 of 1 tests

Yep - it's an ext4 bug.  I sent a patch to fix it.

[PATCH] ext4: fix overhead calculations in ext4_stats, again

You might want to retest w/ that.

-Eric

>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs ext2 ext3 ext4
>> +_supported_os Linux
>> +_require_scratch
>> +
>> +rm -f $seq.full
>> +
>> +_scratch_mkfs >> $seq.full 2>&1
>> +
>> +# Get the honest truth about block counts straight from metadata on disk
>> +TOTAL_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
>> +        | awk '/Block count:/{print $3}'`
>> +
>> +FREE_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
>> +        | awk '/Free blocks:/{print $3}'`
>> +
>> +# nb: kernels today don't count journal blocks  as overhead, but should.
>> +# For most filesystems this will still be within tolerance.
>> +# Overhead is all the blocks (already) used by the fs itself:
>> +OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS))
>> +
>> +#  bsddf|minixdf
>> +#         Set the behaviour  for  the  statfs  system  call.  The  minixdf
>> +#         behaviour is to return in the f_blocks field the total number of
>> +#         blocks of the filesystem, while the bsddf  behaviour  (which  is
>> +#         the default) is to subtract the overhead blocks used by the ext2
>> +#         filesystem and not available for file storage.
>> +
>> +# stat -f output looks like this; we get f_blocks from that, which
>> +# varies depending on the df mount options used below:
>> +
>> +#   File: "/mnt/test"
>> +#    ID: affc5f2b2f57652 Namelen: 255     Type: ext2/ext3
>> +# Block size: 4096       Fundamental block size: 4096
>> +# Blocks: Total: 5162741    Free: 5118725    Available: 4856465
>> +# Inodes: Total: 1313760    Free: 1313749
>> +
>> +_scratch_mount "-o minixdf"
>> +MINIX_F_BLOCKS=`stat -f $SCRATCH_MNT | awk '/^Blocks/{print $3}'`
>> +umount $SCRATCH_MNT
>> +
>> +_scratch_mount "-o bsddf"
>> +BSD_F_BLOCKS=`stat -f $SCRATCH_MNT | awk '/^Blocks/{print $3}'`
>> +umount $SCRATCH_MNT
>> +
>> +# Echo data to $seq.full for analysis
>> +echo "Overhead is $OVERHEAD blocks out of $TOTAL_BLOCKS ($FREE_BLOCKS free)" >> $seq.full
>> +echo "MINIX free blocks $MINIX_F_BLOCKS" >> $seq.full
>> +echo "BSD free blocks $BSD_F_BLOCKS" >> $seq.full
>> +
> 
> This passes for ext[23] but not ext4.

*nod*

>> +# minix should be exactly equal (hence tolerance of 0)
>> +_within_tolerance "minix f_blocks" $MINIX_F_BLOCKS $TOTAL_BLOCKS 0 -v
> 
> This is what I got when I ran it on an 80G  SSD.
> 
> Model: ATA INTEL SSDSA2M080 (scsi)
> Disk /dev/sdc: 80.0GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt_sync_mbr
> 
> Number  Start   End     Size    File system  Name     Flags
>  1      17.4kB  30.0GB  30.0GB  ext4         primary
>  2      30.0GB  60.0GB  30.0GB  ext4         primary
> 
> # ./check 289
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 cxfsxe4 3.7.0-rc2+
> MKFS_OPTIONS  -- /dev/sdc2
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sdc2 /xfs_scratch
> 
> 289     - output mismatch (see 289.out.bad)
> --- 289.out    2012-10-26 12:33:27.000000000 -0500
> +++ 289.out.bad    2012-10-26 12:35:03.000000000 -0500
> @@ -1,3 +1,4 @@
>  QA output created by 289
> -minix f_blocks is in range
> +minix f_blocks has value of 7208959
> +minix f_blocks is NOT in range 7323904 .. 7323904
>  bsd f_blocks is in range
> Ran: 289
> Failures: 289
> Failed 1 of 1 tests
> 
> 
>> +# bsd should be within ... we'll say 1% for some slop
>> +_within_tolerance "bsd f_blocks" $BSD_F_BLOCKS $(($TOTAL_BLOCKS-$OVERHEAD)) 1% -v
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/289.out b/289.out
>> new file mode 100644
>> index 0000000..a4de760
>> --- /dev/null
>> +++ b/289.out
>> @@ -0,0 +1,3 @@
>> +QA output created by 289
>> +minix f_blocks is in range
>> +bsd f_blocks is in range
>> diff --git a/group b/group
>> index fb0f8eb..a846b60 100644
>> --- a/group
>> +++ b/group
>> @@ -407,3 +407,4 @@ deprecated
>>   286 other
>>   287 auto dump quota quick
>>   288 auto quick ioctl trim
>> +289 auto quick
>>
> 
> Regards
> --Rich
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
