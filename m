Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42358 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755620AbeEHV57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 17:57:59 -0400
Subject: Re: [PATCH 20/21] xfsprogs: Add parent pointers during protofile
 creation
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-21-git-send-email-allison.henderson@oracle.com>
 <20180508174305.GT11261@magnolia>
 <782721c1-f929-a5a6-ed45-b7f42b3a5c05@sandeen.net>
 <6bad30c4-7bd0-5f87-8ded-c464d9991c73@oracle.com>
 <c1419f69-962a-fee2-7a66-f373ce2e9154@sandeen.net>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <2d08d4f3-fc78-29f2-68e7-1965b700321a@oracle.com>
Date: Tue, 8 May 2018 14:57:55 -0700
MIME-Version: 1.0
In-Reply-To: <c1419f69-962a-fee2-7a66-f373ce2e9154@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 05/08/2018 02:17 PM, Eric Sandeen wrote:
> 
> 
> On 5/8/18 4:14 PM, Allison Henderson wrote:
>>
>>
>> On 05/08/2018 01:39 PM, Eric Sandeen wrote:
>>>
>>>
>>> On 5/8/18 12:43 PM, Darrick J. Wong wrote:
>>>> On Mon, May 07, 2018 at 09:41:18PM -0700, Allison Henderson wrote:
>>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>>> ---
>>>>>    mkfs/proto.c         | 59 ++++++++++++++++++++++++++++++++++------------------
>>>>>    repair/attr_repair.c | 16 ++------------
>>>>>    repair/phase6.c      | 47 +++++++++++++++++++++++++----------------
>>>
>>>> Separate patches for separate utilities, please.
>>>
>>> Or at least patch per functional change; it's not at all clear to me how protofile
>>> creation has anything to do with xfs_repair, and there's nothing in the commit
>>> log to help me figure it out.  :)
>>>
>>> (I think it doesn't have anything to do w/ protofile creation, and the repair
>>> patches are fixing up orphanage entry creation; the attr_repair changes seem
>>> like some third thing that I don't grok yet, sorry - removing namecheck() for
>>> some reason?).
>>>
>>> -Eric
>>
>> Ok, it took me a minute to remember why I did this too.  We had ended up adding a parameter to libxfs_dir_createname to get the offset needed for creating the parent pointer in the protofile, and I ended up following the compiler errors back around the repair code that uses the same function calls as well.
> 
> Except that this patch isn't fixing the parameter count, it's changing it from NULL, right?
> 
> @@ -1170,7 +1181,7 @@ mv_orphanage(
>   
>   			libxfs_defer_init(&dfops, &first);
>   			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
> -						ino, &first, &dfops, nres, NULL);
> +						ino, &first, &dfops, nres, &offset);
> 
> 
> ...I wonder if there's much hope for doing this series in a bisectable way.  :)
> 
>> Maybe I should make a separate patch just for the offset like the kernel space set does, and then have two smaller patches for the protofile and repair code.
> 
> That might be good.  Any hint about what the attr_repair.c changes are?
> 
> Thanks,
> -Eric
> 
Oh, you're right.  I probably just tracked it down then.  Reasoning that 
anything using it would likely need the pptr update to go along with it. 
It can still be a separate patch though.

The changes in repair/attr_repair.c are because the parent pointer names 
are not strings, they are the binary {ino, gen, diroffset}.  So it 
doesnt make sense to run a name check on them.  I'll try to get 
something added to only skip the check for pptrs though.

Allison

