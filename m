Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35692 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbeBHCfO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Feb 2018 21:35:14 -0500
Subject: Re: XFS over device mapper dm-thin device
References: <147a1764-1988-4efd-4f02-e942a1001b4e@redhat.com>
 <20180202223541.i27bfjij7itt3q5r@destitution>
 <9c3ec8ff-3595-c889-3abe-7f069292be0d@sandeen.net>
 <20180205223604.wgacfnsrsaqrwz7n@destitution>
 <7ed418fa-fa47-1e67-5de8-87d5ba74fbbc@sandeen.net>
 <20180206061100.yqbc55besdmttkzd@destitution>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <89d31e43-a0f7-95f1-080d-1f3bf3d81add@sandeen.net>
Date: Wed, 7 Feb 2018 20:35:12 -0600
MIME-Version: 1.0
In-Reply-To: <20180206061100.yqbc55besdmttkzd@destitution>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Todd Gill <tgill@redhat.com>, linux-xfs@vger.kernel.org



On 2/6/18 12:11 AM, Dave Chinner wrote:
> On Mon, Feb 05, 2018 at 04:37:22PM -0600, Eric Sandeen wrote:
>>
>>
>> On 2/5/18 4:36 PM, Dave Chinner wrote:
>>>> In retrospect I think we (I) should have left the "metadata" uuid as
>>>> the one to match the log, not the user-facing one.
>>> I suspect we can just change the log recovery code to accept either
>>> sb_uuid or sb_metauuid if the metauuid feature bit is set and
>>> change xfs_db to not rewrite the log when metauuid is used....
>>>
>>> Cheers,
>>
>> That was my first thought, but then newer userspace UUID changes
>> won't be mountable on older kernels.   I don't think we can just
>> change it w/o some thought re: compatibility...
> 
> So maybe we should use a log incompat bit and provide an alternative
> command for the old way of changing the UUID in the log?

Sure, if we're happy burning an incompat bit for this, sounds good.

-Eric
