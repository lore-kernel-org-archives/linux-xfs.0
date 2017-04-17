Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754400AbdDQWMi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Apr 2017 18:12:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 21EB63D962
        for <linux-xfs@vger.kernel.org>; Mon, 17 Apr 2017 22:12:38 +0000 (UTC)
Subject: Re: [PATCH] xfs: handle array index overrun in
 xfs_dir2_leaf_readbuf()
References: <9d5a5529-894d-bacd-501e-e0d9ece473b8@redhat.com>
 <20170417205712.GA43090@bfoster.bfoster>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <026eb10c-2745-ad2b-a3f3-f0058f2b9024@redhat.com>
Date: Mon, 17 Apr 2017 17:12:36 -0500
MIME-Version: 1.0
In-Reply-To: <20170417205712.GA43090@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolin@redhat.com>

On 4/17/17 3:57 PM, Brian Foster wrote:
> On Thu, Apr 13, 2017 at 01:45:43PM -0500, Eric Sandeen wrote:
>> Carlos had a case where "find" seemed to start spinning
>> forever and never return.
>>
>> This was on a filesystem with non-default multi-fsb (8k)
>> directory blocks, and a fragmented directory with extents
>> like this:
>>
>> 0:[0,133646,2,0]
>> 1:[2,195888,1,0]
>> 2:[3,195890,1,0]
>> 3:[4,195892,1,0]
>> 4:[5,195894,1,0]
>> 5:[6,195896,1,0]
>> 6:[7,195898,1,0]
>> 7:[8,195900,1,0]
>> 8:[9,195902,1,0]
>> 9:[10,195908,1,0]
>> 10:[11,195910,1,0]
>> 11:[12,195912,1,0]
>> 12:[13,195914,1,0]
>> ...
>>
> 
> This fix seems fine to me, but I'm wondering if this code may have
> issues with other kinds of misalignment between the directory blocks and
> underlying bmap extents as well. For example, what happens if we end up
> with something like the following on an 8k dir fsb fs?
> 
>  0:[0,xxx,3,0]
>  1:[3,xxx,1,0]
> 
> ... or ...
> 
>  0:[0,xxx,3,0]
>  1:[3,xxx,3,0]

Well, as far as that goes it won't be an issue; for 8k dir block sizes
we will allocate an extent map with room for 10 extents, and we'll go
well beyond the above extents which cross directory block boundaries.

>  ...
>  N:[...]
> 
> Am I following correctly that we may end up assuming the wrong mapping
> for the second dir fsb and/or possibly skipping blocks?

As far as I can tell, this code is only managing the read-ahead state
by looking at these cached extents. We keep track of our position within
that allocated array of mappings - this bug just stepped off the end
while doing so.

Stopping at the correct point should keep all of the state consistent
and correct.

But yeah, it's kind of hairy & hard to read, IMHO.

Also as far as I can tell, we handle such discontiguities correctly,
other than the bug I found.  If you see something that looks suspicious,
I'm sure I could tweak my test case to craft a specific situation if
there's something you'd like to see tested...

-Eric

> Brian


