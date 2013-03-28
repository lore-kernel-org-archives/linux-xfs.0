Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3EDE07F50
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 01:43:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 002518F804C
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 23:43:45 -0700 (PDT)
Received: from mail-qe0-f42.google.com (mail-qe0-f42.google.com
	[209.85.128.42]) by cuda.sgi.com with ESMTP id ytq3Vn1uYTDLMp7T
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Mar 2013 23:43:44 -0700 (PDT)
Received: by mail-qe0-f42.google.com with SMTP id da11so4193465qeb.1
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 23:43:44 -0700 (PDT)
Message-ID: <5153E697.7060800@gmail.com>
Date: Thu, 28 Mar 2013 02:43:35 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: oops from deliberate block trashing (of course!)
References: <CAJzLF9nPt9aOrH+Dj12b5os74XT8ke9g4G=DA9xgR0AyehvaBA@mail.gmail.com>
	<20130328061415.GF6369@dastard>
In-Reply-To: <20130328061415.GF6369@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 03/28/2013 02:14 AM, Dave Chinner wrote:
> On Thu, Mar 28, 2013 at 01:18:24AM -0400, Michael L. Semon wrote:
>> ==== SECOND OOPS: xfs_db blocktrash test
>>
>> root@oldsvrhw:~# xfs_db -x /dev/sdb2
>> xfs_db> blockget
>> xfs_db> blocktrash -n 10240 -s 755366564 -3 -x 1 -y 16
>> blocktrash: 0/17856 inode block 6 bits starting 423:0 randomized
>> [lots of blocktrash stuff removed but still available]
>> blocktrash: 3/25387 dir block 2 bits starting 1999:1 randomized
>> xfs_db> quit
>> root@oldsvrhw:~# mount /dev/sdb2 /mnt/hole-test/
>> root@oldsvrhw:~# cd /mnt/hole-test/
>> root@oldsvrhw:/mnt/hole-test# find . -type f
>>
>> XFS (sdb2): Mounting Filesystem
>> XFS (sdb2): Ending clean mount
>> XFS (sdb2): Invalid inode number 0x40000000800084
>> XFS (sdb2): Internal error xfs_dir_ino_validate at line 160 of file
>> fs/xfs/xfs_dir2.c.  Caller 0xc12b9d0d
>>
>> Pid: 97, comm: kworker/0:1H Not tainted 3.9.0-rc1+ #1
>> Call Trace:
>>   [<c1270cbb>] xfs_error_report+0x4b/0x50
>>   [<c12b9d0d>] ? __xfs_dir3_data_check+0x3cd/0x710
>>   [<c12b6326>] xfs_dir_ino_validate+0xb6/0x180
>>   [<c12b9d0d>] ? __xfs_dir3_data_check+0x3cd/0x710
>>   [<c12b9d0d>] __xfs_dir3_data_check+0x3cd/0x710
>>   [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
>>   [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0
>
> And here we validating a different directory block, and finding that
> the inode number it points to is invalid. So, same thing - debug
> kernel fires an assert, production kernel returns EFSCORRUPTED.
>
> What you are seeing is that the verifiers are doing their job as
> intended - catching corruption that is on disk as soon as we
> possibly can. i.e. before it has the chance of being propagated
> further.
>
> Cheers,
>
> Dave.

Very good!  It's good to learn that all of those verifiers are doing 
their jobs...that the ASSERTs all have some kind of dedicated 
purpose...and that I shouldn't face this in non-debug mode.

These proof-positve crash reports are excellent.  I just wish I knew how 
to make them on purpose.

Thanks again, Dave.

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
