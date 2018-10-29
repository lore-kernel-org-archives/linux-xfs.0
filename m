Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43864 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbeJ3D05 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Oct 2018 23:26:57 -0400
Subject: Re: [PATCH 5/5] xfs_metadump: Zap dev inodes
References: <20181026201943.24131-1-stefanrin@gmail.com>
 <20181026201943.24131-6-stefanrin@gmail.com>
 <e9fb6661-858a-250a-ec2f-a9232e0309ae@sandeen.net>
 <CAAxjCEwi5i0B1Gg4fE-KPf3px4zNgvksY_z=RDfwR_=u=5zAEA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e74e127c-e0a0-20e8-f34c-7775bc5f972f@sandeen.net>
Date: Mon, 29 Oct 2018 13:37:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAAxjCEwi5i0B1Gg4fE-KPf3px4zNgvksY_z=RDfwR_=u=5zAEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org

On 10/29/18 1:33 PM, Stefan Ring wrote:
> On Mon, Oct 29, 2018 at 4:38 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 10/26/18 3:19 PM, Stefan Ring wrote:
>>> ---
>>>  db/metadump.c | 22 +++++++++++++++++++++-
>>>  1 file changed, 21 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/db/metadump.c b/db/metadump.c
>>> index 39183fb7..bdc6f2f4 100644
>>> --- a/db/metadump.c
>>> +++ b/db/metadump.c
>>> @@ -2269,6 +2269,24 @@ process_inode_data(
>>>       return 1;
>>>  }
>>>
>>> +static int
>>> +process_dev_inode(
>>> +     xfs_dinode_t            *dip)
>>> +{
>>> +     if (XFS_DFORK_NEXTENTS(dip, XFS_ATTR_FORK) ||
>>> +         XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
>>> +             if (show_warnings)
>>> +                     print_warning("inode %llu has unexpected extents",
>>> +                                   (unsigned long long)cur_ino);
>>> +             return 0;
>>> +     } else {
>>> +             int used = XFS_DFORK_DPTR(dip) - (char*)dip;
>>> +
>>> +             memset(XFS_DFORK_DPTR(dip), 0, mp->m_sb.sb_inodesize - used);
>>> +             return 1;
>>> +     }
>>> +}
>>> +
>>>  /*
>>>   * when we process the inode, we may change the data in the data and/or
>>>   * attribute fork if they are in short form and we are obfuscating names.
>>> @@ -2321,7 +2339,9 @@ process_inode(
>>>               case S_IFREG:
>>>                       success = process_inode_data(dip, TYP_DATA);
>>>                       break;
>>> -             default: ;
>>> +             default:
>>> +                     success = process_dev_inode(dip);
>>> +                     break;
>>
>> Probably:
>>                 case S_IFBLK:
>>                 case S_IFCHR:
>>                         success = process_dev_inode(dip);
>>                         break;
>>                 default:
>>                         break;
>>
>> no?
> 
> Does this catch pipes and sockets, which are also dev inodes?

heh, whooops, nope.

        case S_IFIFO:
        case S_IFCHR:
        case S_IFBLK:
        case S_IFSOCK:
...

sorry, my point was just that it's probably better to explicitly name them
than to fall through to a default but I forgot about 2 formats.

-Eric

>>
>>>       }
>>>       nametable_clear();
>>>
>>>
> 
