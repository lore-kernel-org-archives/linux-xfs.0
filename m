Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:37415 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753478AbeBGKys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 05:54:48 -0500
Received: by mail-wr0-f170.google.com with SMTP id a43so508012wrc.4
        for <linux-xfs@vger.kernel.org>; Wed, 07 Feb 2018 02:54:47 -0800 (PST)
Subject: Re: xfs_extent_busy_flush vs. aio
References: <20180123164718.GE32478@bfoster.bfoster>
 <e1229a02-33ea-e5d5-d66f-36fa553a3393@scylladb.com>
 <20180123173902.GF32478@bfoster.bfoster>
 <f4751375-0710-cec8-ac6d-1f9546bba1ce@scylladb.com>
 <20180125130830.GD43198@bfoster.bfoster>
 <dd148ae0-fe9b-b5b6-5b03-05f0894ce969@scylladb.com>
 <20180129113556.fd4y3t5yupeqtn5t@destitution>
 <6eddde50-ad81-f2ce-c273-86442598a934@scylladb.com>
 <20180129215645.c5dfa3mmoio2iovo@destitution>
 <e76c840f-edd0-2dcc-e070-313cd2ea31da@scylladb.com>
 <20180207015741.yrhe3zfaypwljsdu@destitution>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <9184712f-65e8-5591-2f2f-aeba48cde3f4@scylladb.com>
Date: Wed, 7 Feb 2018 12:54:43 +0200
MIME-Version: 1.0
In-Reply-To: <20180207015741.yrhe3zfaypwljsdu@destitution>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org



On 02/07/2018 03:57 AM, Dave Chinner wrote:
> On Tue, Feb 06, 2018 at 04:10:12PM +0200, Avi Kivity wrote:
>> On 01/29/2018 11:56 PM, Dave Chinner wrote:
>>> On Mon, Jan 29, 2018 at 01:44:14PM +0200, Avi Kivity wrote:
>>>>> There's many reasons this can happen, but the most common is the
>>>>> working files in a directory (or subset of directories in the same
>>>>> AG) have a combined space usage of larger than an AG ....
>>>> That's certainly possible, even likely (one huge directory with all of the
>>>> files).
>>>>
>>>> This layout is imposed on us by the compatibility gods. Is there a way to
>>>> tell XFS to change its policy of on-ag-per-directory?
>>> mount with inode32. That rotors files around all AGs in a round
>>> robin fashion instead of trying to keep directory locality for  a
>>> working set. i.e. it distributes the files evenly across the
>>> filesystem.
>> http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch06s09.html
>> says:
>>
>> "When 32 bit inode numbers are used on a volume larger than 1TB in size,
>> several changes occur.
>>
>> A 100TB volume using 256 byte inodes mounted in the default inode32 mode has
>> just one percent of its space available for allocating inodes.
>>
>> XFS will reserve the first 1TB of disk space exclusively for inodes to
>> ensure that the imbalance is no worse than this due to file data
>> allocations."
> s/exclusively//
>
>> Does this mean that a 1.1TB disk has 1TB reserved for inodes and 0.1TB left
>> over for data?
> No, that would be silly.

Suggest doc changes for both.

>
>> Or is it driven by the "one percent" which is mentioned
>> above, so it would be 0.011TB?
> No, you're inferring behavioural rules that don't exist from a
> simple example.
>
> Maximum number of inodes is controlled by min(imaxpct, free space).
> For inode32, "free space" is what's in the first 32 bits of the inode
> address space. For inode64, it's global free space.
>
> To enable this, inode32 sets the AGs wholly within the first 32 bits
> of the inode address space to be "metadata prefered" and "inode
> capable".
>
> Important things to note:
>
> 	- "first 32 bits of inode address space" means the range of
> 	  space that inode32 reserves for inodes changes according
> 	  to inode size. 256 byte inodes = 1TB, 2kB inodes = 8TB. If
> 	  the filesystem is smaller than this threshold, then it
> 	  will silently use the inode64 allocation policy until the
> 	  filesystem is grown beyond 32 bit inode address space
> 	  size.
>
> 	- "inode capable" means inodes can be allocated in the AG
>
> 	- "metadata preferred" means user data will not get
> 	  allocated in this AG unless all non-prefered AGs are full.
>
>
> So, assuming 256 byte inodes, you 1.1TB fs will have a imaxpct of
> ~25%, allowing a maximum of 256GB of inodes or about a billion
> inodes.  But once you put more than 0.1TB of data into the
> filesystem, data will start filling up the inode capable AGs as
> well, and then your limit for inodes looks just like inode64 (i.e.
> depedent on free space).
>
> IOWs, inode32 limits where and how many inodes you can
> create, not how much user data you can write inode the filesystem.
>

Thanks a lot for the clarifications. Looks like inode32 can be used to 
reduce some of our pain.

There's a danger that when switching from inode64 to inode32 you end up 
with the inode32 address space already exhausted, right? Does that 
result in ENOSPC or what?

Anyway, can probably be fixed by stopping the load, copying files 
around, and moving them back.

