Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from dmzsha2063.multrix.com ([87.233.41.67]:26534 "EHLO
        dmzsha2063.multrix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753238AbdHQVoD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 17:44:03 -0400
Subject: Re: Issue with "no space left on device"
References: <1502981688167.22881@true.nl>
 <20170817164751.GA62570@bfoster.bfoster>
 <a3012e54-dc24-b069-a7a9-c235168d0499@true.nl>
 <f8390140-cdcf-96ff-3013-3cffe66fc9f6@sandeen.net>
 <0a03ddab-6e81-dc89-ab2d-92a005313901@true.nl>
 <8dbbdb4d-300c-e625-1402-d1720b6cfe60@sandeen.net>
 <f7d1164f-07fc-940d-b350-c6572fae7d2b@sandeen.net>
From: Sander van Schie <sander.vanschie@true.nl>
Message-ID: <33e3a585-7fb8-c2f3-426d-252d7740f582@true.nl>
Date: Thu, 17 Aug 2017 23:44:01 +0200
MIME-Version: 1.0
In-Reply-To: <f7d1164f-07fc-940d-b350-c6572fae7d2b@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>



On 17-08-17 23:28, Eric Sandeen wrote:
> On 8/17/17 4:21 PM, Eric Sandeen wrote:
>> On 8/17/17 3:11 PM, Sander van Schie wrote:
>>>
>>> On 17-08-17 19:45, Eric Sandeen wrote:
>>
>> ...
>>
>>>> recent xfsprogs v4.12 has a new option to freesp, to specify alignment filters,
>>>> i.e.
>>>>
>>>>       xfs_db> freesp -A 32
>>>>            will show only 32-block aligned free extents.
>>>>
>>>> You may not have that recent of xfsprogs, but you could check out the git
>>>> tree from git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git, build
>>>> it, and run xfs_db from within the tree, i.e.
>>>>
>>>> # db/xfs_db -c "freesp -A 32 -s" /dev/vdc1
>>>>
>>>> Can you provide that output?
>>>>
>>>> -Eric
>>>>
>>>
>>> Thank you for the explanation!
>>>
>>> The output of the command is as follows:
>>>
>>> # db/xfs_db -c "freesp -A 32 -s" /dev/vdc1
>>>     from      to extents  blocks    pct
>>>        1       1       1       1   0,00
>>>        2       3       7      21   0,01
>>>        4       7     235     970   0,24
>>>        8      15     130    1313   0,33
>>>       16      31   14214  397375  99,42
>>
>> So, I think that's the problem: There are no 32-block aligned
>> free regions of 32 blocks length or greater.
>>
>> (now that I think about it, the -A filter filters on free extents
>> /starting/ on that alignment; I don't know if the inode allocator
>> can make use of, say, a 64 block free extent which /overlaps/ an
>> aligned 32-block range... hm)
>>
>> Out of curiosity, what was the reason for 2k inodes?

The filesystem was created by a default Ceph deployement, so no 
particular reason. An inode size of 2k seems to be the default of 
Ceph(-deploy) to prevent performance issues due to, as I understand it, 
metadata otherwise possibly not fitting in a single extent.

Is this currently primarily an issue due to the fairly small partition 
size and big inode size? Will this be less of an issue with a partition 
of let's say 1 TB?

I'll do some more research as it's not very clear for me yet (due to my 
lack of experience regarding XFS, or filesystems in general). Your 
information was very insightful though, so thank you for that!

> 
> Also for what it's worth - the sparse inodes feature, which is
> default on newer filesystems, alleviates this problem.  When
> mounted, what does xfs_info /mount/point say, does it contain
> output for "spinodes?"

Currently it's set to 0: spinodes=0

> 
> If you need 2k inodes, you probaboy want to get userspace+kernel
> that can support sparse inode allocati
I will look into this

> 
> -Eric
> 


