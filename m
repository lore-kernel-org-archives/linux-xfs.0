Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41598 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755759AbeEHXNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 19:13:54 -0400
Subject: Re: [PATCH 21/21] xfsprogs: implement the upper half of parent
 pointers
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-22-git-send-email-allison.henderson@oracle.com>
 <f31ce664-7173-7b99-7d65-39abd810a372@sandeen.net>
 <20180508230405.GA11261@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f2a34921-e4e5-3976-675d-8b9b17429358@oracle.com>
Date: Tue, 8 May 2018 16:13:49 -0700
MIME-Version: 1.0
In-Reply-To: <20180508230405.GA11261@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org



On 05/08/2018 04:04 PM, Darrick J. Wong wrote:
> On Tue, May 08, 2018 at 03:52:37PM -0500, Eric Sandeen wrote:
>> On 5/7/18 11:41 PM, Allison Henderson wrote:
>>> From: "Darrick J. Wong" <darrick.wong@oracle.com>
>>>
>>> Add ioctl definitions to libxfs, build the necessary helpers into
>>> libfrog and libhandle to iterate parents (and parent paths), then wire
>>> up xfs_scrub to be able to query parent pointers from userspace.  The
>>> goal of this patch is to exercise userspace, and is nowhere near a
>>> complete solution.  A basic xfs_io parent command implementation
>>> replaces ... whatever that is that's there now.
>>
>> I wonder if it'd be better to send a patch to nuke the current parent code,
>> and then another to add back something that works.  Same result in the end,
>> but it doesn't look like you're trying to fix old code; the patch itself is
>> pretty meaningless since it diffs against nonfunctional(?) code.
> 
> Trouble is, it's exported as a shared library in the xfslibs-dev package
> (should that be libxfs-dev?) so depending on how conservative you like
> to be we can't just rip it out.
> 
> (Though I suppose even Linus has occasionally allowed people to rip and
> replace kernel/user ABIs when they can demonstrate that it was so broken
> it never worked for anybody, ever. :P)
> 
>> Not a huge deal, just a thought.
> 
> Yeah, this patch was quite quick and dirty when I wrote it, on the
> assumption that tons of other stuff was going to need reorganization by
> the time there was a need to land this.
> 
> --D

Oh, would you prefer I not include it then?  I do have an xfstest that's 
using it, but it's not a giant gap to close.  I just assumed you 
probably had a reason for the api you set up. :-)


> 
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
