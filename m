Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53458 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932314AbeEHW1h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 18:27:37 -0400
Subject: Re: [PATCH 20/21] xfsprogs: Add parent pointers during protofile
 creation
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-21-git-send-email-allison.henderson@oracle.com>
 <20180508174305.GT11261@magnolia>
 <782721c1-f929-a5a6-ed45-b7f42b3a5c05@sandeen.net>
 <6bad30c4-7bd0-5f87-8ded-c464d9991c73@oracle.com>
 <c1419f69-962a-fee2-7a66-f373ce2e9154@sandeen.net>
 <2d08d4f3-fc78-29f2-68e7-1965b700321a@oracle.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e9bf1de5-5473-0b7d-31ac-baa0ec63e816@sandeen.net>
Date: Tue, 8 May 2018 17:27:36 -0500
MIME-Version: 1.0
In-Reply-To: <2d08d4f3-fc78-29f2-68e7-1965b700321a@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 5/8/18 4:57 PM, Allison Henderson wrote:
> On 05/08/2018 02:17 PM, Eric Sandeen wrote:

...

>>> Ok, it took me a minute to remember why I did this too.  We had ended up adding a parameter to libxfs_dir_createname to get the offset needed for creating the parent pointer in the protofile, and I ended up following the compiler errors back around the repair code that uses the same function calls as well.
>>
>> Except that this patch isn't fixing the parameter count, it's changing it from NULL, right?
>>
>> @@ -1170,7 +1181,7 @@ mv_orphanage(
>>                 libxfs_defer_init(&dfops, &first);
>>               err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
>> -                        ino, &first, &dfops, nres, NULL);
>> +                        ino, &first, &dfops, nres, &offset);
>>
>>
>> ...I wonder if there's much hope for doing this series in a bisectable way.  :)
>>
>>> Maybe I should make a separate patch just for the offset like the kernel space set does, and then have two smaller patches for the protofile and repair code.
>>
>> That might be good.  Any hint about what the attr_repair.c changes are?
>>
>> Thanks,
>> -Eric
>>
> Oh, you're right.  I probably just tracked it down then.  Reasoning that anything using it would likely need the pptr update to go along with it. It can still be a separate patch though.

It's fine by me if the commit is something like "xfsprogs: update parent pointers in mkfs and repair"

It's just confusing to have a terse commit log stating that it does one thing, and in fact it is doing 3 unrelated things.

> The changes in repair/attr_repair.c are because the parent pointer names are not strings, they are the binary {ino, gen, diroffset}.  So it doesnt make sense to run a name check on them.  I'll try to get something added to only skip the check for pptrs though.

Ah, that makes sense (and sounds necessary) - we can't skip the check on every attribute name just because it might possibly be a parent pointer.

Thanks,
-Eric
