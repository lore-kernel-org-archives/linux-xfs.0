Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 481638040
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 12:12:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA294AC001
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 10:12:50 -0700 (PDT)
Message-ID: <5143568F.5060900@redhat.com>
Date: Fri, 15 Mar 2013 12:12:47 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: enable test 032 (mkfs overwrite) for btrfs
References: <5140A2BC.7010800@redhat.com> <51435555.2020706@sgi.com>
In-Reply-To: <51435555.2020706@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 3/15/13 12:07 PM, Rich Johnston wrote:
> Eric,
> 
> Thanks once more for the patch.  Once I finally got the correct version of mkfs.btrfs this looks good.
> 
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> 
> Interesting that the default make install of btrfs-progs did not install over my btrfsprogs rpm.
> 
> Was running SLES11 SP2 with btrfsprogs-0.19-5.31.1.x86_64.
> 
> It did not put mkfs.btrfs in /sbin.  This did however, validate all the error paths ;).

Heh ;)

Well, mixing & matching upstream installs from source w/ rpm-packaged binaries is usually asking for trouble.

I don't think it's a bug, just bad administrative practice ;)

-Eric

> --Rich
> 
> 
> 
> 
> On 03/13/2013 11:01 AM, Eric Sandeen wrote:
>> Now that btrfs has an "-f" arg, we can test that it doesn't
>> improperly overwrite other filesystems in 032 like we do
>> for xfs.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/032 b/032
>> index bf88492..89fb225 100755
>> --- a/032
>> +++ b/032
>> @@ -38,12 +38,18 @@ rm -f $seq.full
>>   . ./common.filter
>>
>>   # real QA test starts here
>> -_supported_fs xfs
>> +_supported_fs xfs btrfs
>>   _supported_os Linux
>>
>>   _require_nobigloopfs
>>   _require_scratch
>>
>> +# mkfs.btrfs did not have overwrite detection at first
>> +if [ "$FSTYP" == "btrfs" ]; then
>> +    grep -q 'force overwrite' `echo $MKFS_BTRFS_PROG | awk '{print $1}'` || \
>> +        _notrun "Installed mkfs.btrfs does not support -f option"
>> +fi
>> +
>>   echo "Silence is golden."
>>   for fs in `echo ${MKFS_PROG}.* | sed -e 's/.sbin.mkfs.//g'`
>>   do
>> @@ -61,7 +67,7 @@ do
>>       [ $fs = gfs2 ] && preop="echo y |" && preargs="-p lock_nolock -j 1"
>>       [ $fs = reiserfs ] && preop="echo y |" && preargs="-f"
>>       # cramfs mkfs requires a directory argument
>> -    [ $fs = cramfs ] && preargs=/proc/fs/xfs
>> +    [ $fs = cramfs ] && preargs=/proc/fs
>>       [ $fs = ext2 ] && preargs="-F"
>>       [ $fs = ext3 ] && preargs="-F"
>>       [ $fs = ext4 ] && preargs="-F"
>> @@ -77,8 +83,8 @@ do
>>
>>       if [ $? -eq 0 ] ; then
>>           # next, ensure we don't overwrite it
>> -        echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
>> -        ${MKFS_PROG}.xfs $SCRATCH_DEV >>$seq.full 2>&1
>> +        echo "=== Attempting $FSTYP overwrite of $fs..." >>$seq.full
>> +        ${MKFS_PROG}.$FSTYP $SCRATCH_DEV >>$seq.full 2>&1
>>
>>           [ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
>>       else
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
