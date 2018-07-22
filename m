Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38852 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728194AbeGVA57 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Jul 2018 20:57:59 -0400
Subject: Re: Recently-formatted XFS filesystems reporting negative used space
References: <CAKAc_Gwh-KMdnK6LqX3kE9jTmSHsg8_kzQE5fPsnL3xETD1O+w@mail.gmail.com>
 <3895eebe-3fa2-a977-4021-3bd6ef645fdd@sandeen.net>
 <CAKAc_GwXi4U=WceoWo_6dsjT_ThTYKbebOzxkcTAW2_-vfgt=g@mail.gmail.com>
 <CAKAc_GxsR9UxswqJMLhPOqR6HeYLi-rHZiEY8LLxs-hj0n=uMQ@mail.gmail.com>
 <20180717092626.pxb6wzhcswf2f77p@odin.usersys.redhat.com>
 <CAKAc_Gx5RaiEC1C8aSYZXAcZcyyPHPNWHy6ALuzOJvkgkg5nkA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <830a7de7-34ca-7d79-d94a-ff16c98381a3@sandeen.net>
Date: Sat, 21 Jul 2018 17:03:22 -0700
MIME-Version: 1.0
In-Reply-To: <CAKAc_Gx5RaiEC1C8aSYZXAcZcyyPHPNWHy6ALuzOJvkgkg5nkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Filippo Giunchedi <fgiunchedi@wikimedia.org>, linux-xfs@vger.kernel.org

On 7/20/18 3:20 AM, Filippo Giunchedi wrote:
> On Tue, Jul 17, 2018 at 11:26 AM Carlos Maiolino <cmaiolino@redhat.com> wrote:
>>>> Ouch, indeed we've seen this problem on multiple nodes, said hosts
>>>> belong to the same and latest shipment from the OEM. We'll run
>>>> hardware diagnostics on these hosts and others we've received at
>>>> another datacenter (which haven't shown issues so far but don't serve
>>>> reads either).
>>>
>>> Update on this: we've ran hw diagnostics and couldn't find anything
>>> wrong, xfs_repair does fix the issue so we'll be going ahead with
>>> that. Is there anything we can do to help debugging in case this
>>> happens again?
>>>
>>
>> There is a patch being discussed on list to help catch these bit corruptions
>> before they reach the disk, but, bear in mind we can only improve the validation
>> of our metadata. Nothing actually forbids these bit flips are occurring on your
>> data, and you are actually writing corrupted data into your files.
> 
> We've found no other cases of bit flips or corruption in metadata or
> the data itself though.
> To recap what we've seen, hardware bit flipping is extremely unlikely:
> the same type of sb_fdblocks corruption has appeared on four different
> hosts affecting at most one third of xfs filesystems per host. Also
> the corruption looks always the same, namely the 33rd bit flipped
> which also seems suspicious.

Running a debug kernel with memory poisoning, KASAN, or something similar might
help catch it if it's a stray memory write of some sort...

-Eric
