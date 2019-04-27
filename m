Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53286 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfD0Kv7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 27 Apr 2019 06:51:59 -0400
Subject: Re: [PATCH] xfs_db: Scan entire file system when using 'frag'
References: <20190426225920.34359-1-jorgeguerra@gmail.com>
 <4c0ed0bf-c980-9379-3816-c8e5dddd61b5@sandeen.net>
 <CAEFkGAz1dnR2RdA458WqjPqoO0rfS5yQX6Py6DRJLaxtErem-w@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e81b1530-c513-7112-26ea-27e31a860aab@sandeen.net>
Date: Sat, 27 Apr 2019 05:51:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAEFkGAz1dnR2RdA458WqjPqoO0rfS5yQX6Py6DRJLaxtErem-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jorge Guerra <jorge.guerra@gmail.com>
Cc: linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, Jorge Guerra <jorgeguerra@fb.com>

On 4/26/19 10:32 PM, Jorge Guerra wrote:
> Thanks Eric,
> 
> I'll update the title.

No need, I can add the fixes tag when I queue it up.

> We are using the frag command to quickly scan the file system and
> obtain info such as file size distribution and overheads.  I'll send
> that change out for review soon :)
> 
> Hopefully that will make the frag command great again! :D

;) ok, if it becomes less meaningless, you may want to remove the printf
which claims that it is meaningless.  :)

-Eric

> On Fri, Apr 26, 2019 at 5:13 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 4/26/19 5:59 PM, Jorge Guerra wrote:
>>> From: Jorge Guerra <jorgeguerra@fb.com>
>>>
>>> While running the 'frag' command of 'xfs_db' we noticed that the
>>> tool is not scanning all the files in the file system.  We noticed
>>> this when we modified the tool to print the inodes of all the files
>>> scanned.  For example:
>>>
>>>  $ find /mnt/xfsdisk -type f | wc -l
>>>  1782674
>>>  $ xfs_db -r -c frag /dev/sdXX  | grep MB | awk '{print $5}' | paste -s -d+ | bc
>>>  656818
>>>
>>> Upon inspecting the code we noticed that the scanfunc_ino function
>>> stops processing a given inode block once it encounters a free leaf.
>>> However, in practice we see that inodes are necessarily always layed
>>> out contiguously on the leaf node.  This resulted in the 'frag'
>>> command skipping some valid inodes.
>>>
>>> In this change we modify the scanfunc_ino function to skip freed
>>> inodes.  With the change in place we ran the same experiment again
>>> and noticed a more accurate file count:
>>>
>>>  $ find /mnt/d0 -type f | wc -l
>>>  1810442
>>>  $ xfs_db -r -c frag /dev/sdXX  | grep MB | awk '{print $5}' | paste -s -d+ | bc
>>>  1810442
>>>
>>> Signed-off-by: Jorge Guerra <jorgeguerra@fb.com>
>>
>> This looks right, but I'll warn you that xfs_db's frag command is largely
>> useless in the first place.  ;)
>>
>> Also, I think:
>>
>> Fixes: 2a5eb70c ("xfs_db: teach the frag command about sparse inode chunks")
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Thanks!
>>
>>> ---
>>>  db/frag.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/db/frag.c b/db/frag.c
>>> index 5f33cb73..91395234 100644
>>> --- a/db/frag.c
>>> +++ b/db/frag.c
>>> @@ -507,7 +507,7 @@ scanfunc_ino(
>>>
>>>                               for (j = 0; j < inodes_per_buf; j++) {
>>>                                       if (XFS_INOBT_IS_FREE_DISK(&rp[i], ioff + j))
>>> -                                             goto next_buf;
>>> +                                             continue;
>>>                                       dip = (xfs_dinode_t *)((char *)iocur_top->data +
>>>                                               ((off + j) << mp->m_sb.sb_inodelog));
>>>                                       process_inode(agf, agino + ioff + j, dip);
>>>
> 
> 
> 
