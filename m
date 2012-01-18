Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0I43I6l190980 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 22:03:19 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6SN3VUS9IX7c06fq for
	<xfs@oss.sgi.com>; Tue, 17 Jan 2012 20:03:17 -0800 (PST)
Message-ID: <4F16447F.7050406@redhat.com>
Date: Tue, 17 Jan 2012 22:03:11 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: make 275 pass
References: <4F04A6E6.1090304@redhat.com> <4F04BC81.1000207@redhat.com>
	<4F16318E.9080106@cn.fujitsu.com>
In-Reply-To: <4F16318E.9080106@cn.fujitsu.com>
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
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/17/12 8:42 PM, Liu Bo wrote:
> On 01/05/2012 04:54 AM, Eric Sandeen wrote:
>> Ok, this is a significant rework of 275, which made too many
>> assumptions about details of space usage and failed on several
>> filesystems (it passed on xfs, but only by accident).
>>
>> This new version tries to leave about 256k free, then tries
>> a single 1M IO, and fails only if 0 bytes are written.
>>
>> It also sends a lot more to $seq.full for debugging on failure
>> and fixes a few other stylistic things.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/275 b/275
>> index 214262e..8f521f8 100755
>> --- a/275
>> +++ b/275
>> @@ -1,8 +1,8 @@
>>  #! /bin/bash
>>  # FS QA Test No. 275
>>  #
>> -# The posix write test. when write size is larger than disk free size,
>> -# should write as more as possible
>> +# The posix write test.  When write size is larger than disk free size,
>> +# should write as much as possible until ENOSPC.
>>  #
>>  #-----------------------------------------------------------------------
>>  # Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
>> @@ -30,13 +30,12 @@ echo "QA output created by $seq"
>>  
>>  here=`pwd`
>>  tmp=/tmp/$$
>> -status=0    # success is the default!
>> +status=1    # failure is the default!
>>  trap "_cleanup; exit \$status" 0 1 2 3 15
>>  
>>  _cleanup()
>>  {
>>  	cd /
>> -	rm -f $SCRATCH_MNT/* $tmp.*
>>  	_scratch_unmount
>>  }
>>  
>> @@ -49,7 +48,7 @@ _supported_os IRIX Linux
>>  _require_scratch
>>  
>>  echo "------------------------------"
>> -echo "write lack test"
>> +echo "write until ENOSPC test"
>>  echo "------------------------------"
>>  
>>  rm -f $seq.full
>> @@ -59,31 +58,38 @@ _scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
>>  _scratch_mount
>>  
>>  rm -rf $SCRATCH_MNT/*
>> -cd $SCRATCH_MNT
>>  
>> -dd if=/dev/zero of=tmp1 bs=4K count=1 >/dev/null 2>&1
>> -if [ $? -ne 0 ]
>> -then
>> -	echo "create file err"
>> -	status=1
>> -	exit
>> -fi
>> +dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=256K count=1 >>$seq.full 2>&1
>> +[ $? -ne 0 ] && _fail "Error creating file"
>>  
>> -dd if=/dev/zero of=tmp2 bs=1M >/dev/null 2>&1
>> -dd if=/dev/zero of=tmp3 bs=4K >/dev/null 2>&1
>> +# Attempt to completely fill fs
>> +dd if=/dev/zero of=$SCRATCH_MNT/tmp2 bs=1M >>$seq.full 2>&1
>>  sync
>> +dd if=/dev/zero of=$SCRATCH_MNT/tmp3 bs=4K >>$seq.full 2>&1
>> +sync
>> +# Last effort, use O_SYNC
>> +dd if=/dev/zero of=$SCRATCH_MNT/tmp4 bs=4K oflag=sync >>$seq.full 2>&1
>> +# Save space usage info to the full file
>> +echo "Pre rm space:" >> $seq.full
>> +df $SCRATCH_MNT >>$seq.full 2>&1
>>  
>> -rm -f tmp1
>> +# Should leave approx 256k free
>> +rm -f $SCRATCH_MNT/tmp1
>>  sync
>> +echo "Post rm space:" >> $seq.full
>> +df $SCRATCH_MNT >>$seq.full 2>&1
>> +_freespace=`df -k $SCRATCH_MNT | tail -n 1 | awk '{print $4}'`
>> +[ $_freespace -gt 1024 ] && _fail "could not sufficiently fill filesystem"
>> +
> 
> I doubt this cause btrfs has a mixed data+meta mode, which means data and metadata can
> share space, but this mode is only enabled when the filesystem size is less than 1G.
> 
> We can apply the below to avoid it:
> -_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
> +_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1

Ok, I can do that easily enough (assuming scratch space is likely to be at least 2G...)

> 
>> +# Try a write larger than available space
>> +dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=1M count=1 >>$seq.full 2>&1
>> +echo "Bytes written until ENOSPC:" >>$seq.full
>> +du $SCRATCH_MNT/tmp1 >>$seq.full
>>  
>> -dd if=/dev/zero of=tmp1 bs=8K count=1 >/dev/null 2>&1
>> -_filesize=`du tmp1 | awk '{print $1}'`
>> -if [ $_filesize -ne 4 ]
>> -then
>> -	echo "write file err"
>> -	status=1
>> -	exit
>> -fi
>> +# And at least some of it should succeed.
>> +_filesize=`du $SCRATCH_MNT/tmp1 | awk '{print $1}'`
>> +[ $_filesize -eq 0 ] && _fail "write file err: Partial write until enospc failed; wrote 0 bytes."
>>  
> 
> And btrfs will check free space first and then decide if it should allocate blocks, so a partial write
> will fail anyway.

Ok, I'm not quite clear - will the above be a problem for btrfs or is it ok?

Thanks,
-Eric

> 
> Other parts looks good to me :)
> 
> thanks,
> liubo
> 
>>  echo "done"
>> +status=0
>>  exit
>> diff --git a/275.out b/275.out
>> index 30af43c..69b9d52 100644
>> --- a/275.out
>> +++ b/275.out
>> @@ -1,5 +1,5 @@
>>  QA output created by 275
>>  ------------------------------
>> -write lack test
>> +write until ENOSPC test
>>  ------------------------------
>>  done
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
