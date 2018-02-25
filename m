Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53738 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751902AbeBYSL3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 25 Feb 2018 13:11:29 -0500
Subject: Re: [PATCH] xfs: fix potential memory leak in mount option parsing
References: <1519468406-67354-1-git-send-email-cgxu519@icloud.com>
 <5d92aa93-cec4-2495-70fa-61d082e1cb6b@sandeen.net>
 <326CF29E-FC88-493B-B16E-7EA318169E9A@icloud.com>
 <20180225180916.GB19312@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fe6ac2e6-bac0-7f8f-4a24-f72439365848@sandeen.net>
Date: Sun, 25 Feb 2018 12:11:28 -0600
MIME-Version: 1.0
In-Reply-To: <20180225180916.GB19312@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Chengguang Xu <cgxu519@icloud.com>
Cc: linux-xfs@vger.kernel.org



On 2/25/18 12:09 PM, Darrick J. Wong wrote:
> On Sun, Feb 25, 2018 at 12:11:23PM +0800, Chengguang Xu wrote:
>>>
>>> 在 2018年2月25日，上午1:58，Eric Sandeen <sandeen@sandeen.net> 写道：
>>>
>>> On 2/24/18 4:33 AM, Chengguang Xu wrote:
>>>> When specifying string type mount option (e.g., logdev)
>>>> several times in a mount, current option parsing may
>>>> cause memory leak. Hence, call kfree for previous one
>>>> in this case.
>>>>
>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>
>>> IMHO multiple specifications of logdev or rtdev should not
>>> be allowed; only one may be chosen, and specifying twice
>>> should probably be considered and administrative error.
>>>
>>> I'd rather see something that fails and cleans up properly
>>> if either option is respecified.
>>
>> Hi Eric,
>>
>> Thanks for quick reply. I think your suggestion makes sense,
>> but considering of the consistency with other options, 
>> we should check multiple specifications for all options. 
>>
>> So I think this patch is the cheapest way to fix the issue.
>> What do you think?
> 
> I think the all the mount options should be cleaned up to allow one
> specification only.

Yeah, I think so too, though perhaps it's fair to have one patch
to fix the leak as it stands today, and another to clean up the
respecification problem.  They are two separate issues in the end,
I suppose, so two separate patches seems reasonable.

-Eric
