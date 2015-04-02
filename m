Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 997F67F59
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2015 09:41:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D0708F8078
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2015 07:41:40 -0700 (PDT)
Received: from mail-ie0-f174.google.com (mail-ie0-f174.google.com
	[209.85.223.174]) by cuda.sgi.com with ESMTP id
	zT15Dvs1wkNby6Cx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Apr 2015 07:41:39 -0700 (PDT)
Received: by ierf6 with SMTP id f6so70261075ier.2
	for <xfs@oss.sgi.com>; Thu, 02 Apr 2015 07:41:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFLt3phn5ZLXB5FcRv4OrK_d8ffRtz5RStGU5MbjjA_EjEO97A@mail.gmail.com>
References: <551993CF.4060908@binghamton.edu> <20150330194510.GD28621@dastard>
	<551C4CB8.7@binghamton.edu> <20150402001235.GI28621@dastard>
	<551D5316.8050201@binghamton.edu>
	<CAFLt3phn5ZLXB5FcRv4OrK_d8ffRtz5RStGU5MbjjA_EjEO97A@mail.gmail.com>
Date: Thu, 2 Apr 2015 16:41:38 +0200
Message-ID: <CAFLt3pj-ZfU9dp3OsBaJpp+cKaecmXbj-PyTr-TmeZPjxXhGgw@mail.gmail.com>
Subject: Re: Slightly Urgent: XFS No Space Left On Device
From: Grozdan <neutrino8@gmail.com>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: Xfs <xfs@oss.sgi.com>

On Thu, Apr 2, 2015 at 4:36 PM, Grozdan <neutrino8@gmail.com> wrote:
> On Thu, Apr 2, 2015 at 4:32 PM, Dave Hall <kdhall@binghamton.edu> wrote:
>> Thanks for the help.  Rookie error.  I didn't set these mount options, but I
>> see that this option is set for all of the other XFS volumes I have.
>>
>> I am wondering why XFS would default this way though.  Seems like
>> heuristically you could assume that a large volume on a 64-bit OS would need
>> 64-bit inodes.  At least perhaps put out a message from mkfs.xfs suggesting
>> the use of inode64 on the mount command?
>
>
> inode64 has been made default, even for 32-bit systems, by recent
> versions of xfsprogs so I'd suggest to upgrade your xfsprogs

sorry, I was thinking of the crc flag. XFS uses by default inode64
from kernel versions 3.7 and up

>
>>
>> Thanks.
>>
>> -Dave
>>
>> Dave Hall
>> Binghamton University
>> kdhall@binghamton.edu
>> 607-760-2328 (Cell)
>> 607-777-4641 (Office)
>>
>>
>> On 04/01/2015 08:12 PM, Dave Chinner wrote:
>>>
>>> On Wed, Apr 01, 2015 at 03:53:28PM -0400, Dave Hall wrote:
>>>
>>>>
>>>> Please pardon the 'top-post', but here is the additional information
>>>> requested:
>>>>
>>>> This is a Dell R720xd dual 8-core Xeon system with 128GB RAM.  The
>>>> RAID controller is Dell PERC H710 Mini with 12 2TB disks in RAID6.
>>>>
>>>> The OS is Debian 6 with kernel 3.2.0-0.bpo.4-amd64 #1 SMP Debian
>>>> 3.2.65-1+deb7u2~bpo60+1 x86_64.
>>>>
>>>
>>> So defaults to inode32 allocation....
>>>
>>>
>>>>
>>>>  From /proc/mounts:
>>>>
>>>>     /dev/sdb1 /data xfs
>>>>
>>>> rw,noexec,noatime,attr2,delaylog,allocsize=64k,logbsize=64k,sunit=128,swidth=1280,usrquota,prjquota
>>>>     0 0
>>>>
>>>
>>> ... and inode64 is not in the mount options.....
>>>
>>>
>>>>
>>>> The output from xfs_info was previously included, but is repeated here:
>>>>
>>>> # xfs_info /data
>>>> meta-data=/dev/sdb1              isize=256    agcount=19,agsize=268435440
>>>> blks
>>>>
>>>
>>> Inode allocation requires contiguous free space of 16k aligned to 8k
>>> boundaries to allocate new inode chunks. Also, 1TB AGs, so with
>>> inode32, inodes can only be allocated in AG 0.
>>>
>>>
>>>>
>>>> Here are the more extensive freesp outputs for each of the 19 AGs:
>>>>
>>>>     # xfs_db -r /dev/sdb1 -c 'freesp -s -a0'
>>>>         from      to extents  blocks    pct
>>>>            1       1     747     747  19.68
>>>>            2       3    1045    2496  65.77
>>>>            4       7     138     552  14.55
>>>>     total free extents 1930
>>>>     total free blocks 3795
>>>>     average free extent size 1.96632
>>>>
>>>
>>> And that says you have no correctly aligned free 16k extents that
>>> can be allocated in AG 0. i.e. no more inodes can be allocated, and
>>> that's where the ENOSPC is coming from.
>>>
>>> Unmount, add the inode64 mount option, and you'll be able to
>>> allocate inodes again as they will be allowed to be allocated in
>>> any AG, not just AG 0.
>>>
>>> Cheers,
>>>
>>> Dave.
>>>
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
>
>
> --
> Yours truly



-- 
Yours truly

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
