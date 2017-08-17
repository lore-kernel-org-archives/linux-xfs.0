Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from dmzsha2062.multrix.com ([87.233.41.63]:48303 "EHLO
        dmzsha2062.multrix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdHQULQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 16:11:16 -0400
Subject: Re: Issue with "no space left on device"
References: <1502981688167.22881@true.nl>
 <20170817164751.GA62570@bfoster.bfoster>
 <a3012e54-dc24-b069-a7a9-c235168d0499@true.nl>
 <f8390140-cdcf-96ff-3013-3cffe66fc9f6@sandeen.net>
From: Sander van Schie <sander.vanschie@true.nl>
Message-ID: <0a03ddab-6e81-dc89-ab2d-92a005313901@true.nl>
Date: Thu, 17 Aug 2017 22:11:14 +0200
MIME-Version: 1.0
In-Reply-To: <f8390140-cdcf-96ff-3013-3cffe66fc9f6@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>


On 17-08-17 19:45, Eric Sandeen wrote:
> On 8/17/17 12:15 PM, Sander van Schie wrote:
>>
>> On 17-08-17 18:47, Brian Foster wrote:
> 
> ...
> 
>>> With 2k sized inodes, the most likely cause is free space fragmentation.
>>> What does 'xfs_db -c "freesp -s" <dev>' print for this fs?
>>>
>>> Brian
>>>
>>
>> The output of the command is as follows:
>>
>> # xfs_db -c "freesp -s" /dev/vdc1
>>     from      to extents  blocks    pct
>>        1       1      28      28   0,00
>>        2       3      50     149   0,00
>>        4       7     907    3799   0,07
>>        8      15    1369   12990   0,25
>>       16      31  183206 5126962  99,34
>>       32      63     492   17197   0,33
>> total free extents 186052
>> total free blocks 5161125
>> average free extent size 27,7402
>>
>> (not sure what I'm looking at myself)
> 
> It shows you where the freespace is in the filesystem, and how large the
> various freespace extents are; i.e. you have 28 single blocks free,
> and 50 free extents containing two to three free filesystem blocks,
> etc.
> 
> We allocate inodes in contiguous chunks of 64; with 2k inodes and 4k blocks,
> that means we allocate inodes in chunks of 32 blocks.
> 
> So you do have 492 extents with 32 free blocks or more, but allocation also
> has alignment requirements - these allocated chunks must also be aligned,
> in this case aligned to a 32-block boundary.  From the output above, we don't
> know the alignment of that freespace
> 
> recent xfsprogs v4.12 has a new option to freesp, to specify alignment filters,
> i.e.
> 
>      xfs_db> freesp -A 32
>      
>      will show only 32-block aligned free extents.
> 
> You may not have that recent of xfsprogs, but you could check out the git
> tree from git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git, build
> it, and run xfs_db from within the tree, i.e.
> 
> # db/xfs_db -c "freesp -A 32 -s" /dev/vdc1
> 
> Can you provide that output?
> 
> -Eric
> 

Thank you for the explanation!

The output of the command is as follows:

# db/xfs_db -c "freesp -A 32 -s" /dev/vdc1
    from      to extents  blocks    pct
       1       1       1       1   0,00
       2       3       7      21   0,01
       4       7     235     970   0,24
       8      15     130    1313   0,33
      16      31   14214  397375  99,42
total free extents 14587
total free blocks 399680
average free extent size 27,3997

For what it's worth, practically all files (194024 out of 196385) on the 
filesystem are 80102 bytes in size.

- Sander
