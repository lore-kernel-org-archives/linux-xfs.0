Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q86EJBXd089218 for <xfs@oss.sgi.com>; Thu, 6 Sep 2012 09:19:12 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id k353Hs4tVrDdbHbk for
	<xfs@oss.sgi.com>; Thu, 06 Sep 2012 07:20:11 -0700 (PDT)
Message-ID: <5048B11A.3070709@redhat.com>
Date: Thu, 06 Sep 2012 09:20:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 285: verify extN statfs f_blocks
References: <5047D01E.1070104@redhat.com>
	<CA+dCu8936Jrwi2tVh6Yx10-Nb8jSZOx+m+Ho34oVYY1sJsh=Yw@mail.gmail.com>
In-Reply-To: <CA+dCu8936Jrwi2tVh6Yx10-Nb8jSZOx+m+Ho34oVYY1sJsh=Yw@mail.gmail.com>
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
To: guaneryu@gmail.com
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 9/6/12 3:49 AM, Eryu Guan wrote:
> On Thu, Sep 6, 2012 at 6:20 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> extN can report f_blocks in statfs in 2 different ways, based
>> on whether or not metadata overhead is counted.  This has broken
>> in the past, so here's a test for it.
>>
>> It looks at dumpe2fs output to get total blocks and free blocks
>> right after mkfs.  The difference should be, by definition, the
>> exact amount of metadata overhead.
>>
>> It then compares this to what's reported via stat -f for f_blocks.
>> For "minix" df, it should be exactly equal to the total blocks,
>> and for "bsd" df, it should be total blocks less overhead.
>>
>> It tests that the latter is accurate to within a 1% tolerance.
>>
>> Today the journal doesn't count as overhead in the statfs call;
>> this should be fixed kernelside but for many filesystems it'll be
>> within the threshold anyway.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/285 b/285
>> new file mode 100755
>> index 0000000..cda8531
>> --- /dev/null
>> +++ b/285
>> @@ -0,0 +1,97 @@
>> +#! /bin/bash
>> +# FS QA Test No. 286
> 
> The Test No. should be 285 here?

Oh, yes. I figure I'll have to renumber before commit anyway ;)

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
>> +status=1       # failure is the default!
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
>> +_supported_fs ext2 ext3 ext4
>> +_supported_os Linux
>> +_require_scratch
>> +
>> +rm -f $seq.full
>> +
>> +_scratch_mkfs >> $seq.full 2>&1
>> +
>> +TOTAL_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
>> +               | awk '/Block count:/{print $3}'`
>> +
>> +FREE_BLOCKS=`dumpe2fs -h $SCRATCH_DEV 2>/dev/null \
>> +               | awk '/Free blocks:/{print $3}'`
> 
> I guess TOTAL_BLOCKS and FREE_BLOCKS will be wrong when testing ext4
> on RHEL5 which has a separate dumpe4fs for ext4.

dumpe2fs would fail, yes ... I don't know if we really want to special case rhel5's
weirdness in xfstests or not ...

-Eric

> Thanks,
> Eryu Guan
>> +
>> +# nb: kernels today don't count journal blocks  as overhead, but should.
>> +# For most fileystems this will still be within tolerance.
>> +OVERHEAD=$(($TOTAL_BLOCKS-$FREE_BLOCKS))
>> +
>> +#  bsddf|minixdf
>> +#         Set the behaviour  for  the  statfs  system  call.  The  minixdf
>> +#         behaviour is to return in the f_blocks field the total number of
>> +#         blocks of the filesystem, while the bsddf  behaviour  (which  is
>> +#         the default) is to subtract the overhead blocks used by the ext2
>> +#         filesystem and not available for file storage.
>> +
>> +# stat -f output looks like; we get f_blocks from that, which
>> +# varies depending on the df mount options used below:
>> +
>> +# Filesystem           4K-blocks      Used Available Use% Mounted on
>> +# /dev/sda8              2405312   2208933    196379  92% /
>> +
>> +_scratch_mount "-o minixdf"
>> +MINIX_F_BLOCKS=`stat -f $SCRATCH_MNT | awk '/^Blocks/{print $3}'`
>> +umount $SCRATCH_MNT
>> +
>> +_scratch_mount "-o bsddf"
>> +BSD_F_BLOCKS=`stat -f $SCRATCH_MNT | awk '/^Blocks/{print $3}'`
>> +umount $SCRATCH_MNT
>> +
>> +echo "Overhead is $OVERHEAD out of $TOTAL_BLOCKS" >> $seq.full
>> +echo "BSD blocks $BSD_F_BLOCKS" >> $seq.full
>> +echo "MINIX blocks $MINIX_F_BLOCKS" >> $seq.full
>> +
>> +# minix should be exactly equal (hence 0)
>> +_within_tolerance "minix f_blocks" $MINIX_F_BLOCKS $TOTAL_BLOCKS 0 -v
>> +# bsd should be within ... we'll say 1%
>> +_within_tolerance "bsd f_blocks" $BSD_F_BLOCKS $(($TOTAL_BLOCKS-$OVERHEAD)) 1% -v
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/285.out b/285.out
>> new file mode 100644
>> index 0000000..2075e21
>> --- /dev/null
>> +++ b/285.out
>> @@ -0,0 +1,3 @@
>> +QA output created by 285
>> +minix f_blocks is in range
>> +bsd f_blocks is in range
>> diff --git a/group b/group
>> index 104ed35..0b33178 100644
>> --- a/group
>> +++ b/group
>> @@ -403,3 +403,4 @@ deprecated
>>  282 dump ioctl auto quick
>>  283 dump ioctl auto quick
>>  284 auto
>> +285 auto
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
