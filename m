Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38116 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751557AbeBYVPR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 25 Feb 2018 16:15:17 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] xfs: fix potential memory leak in mount option parsing
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20180225210524.GE30854@dastard>
Date: Sun, 25 Feb 2018 15:15:15 -0600
Content-Transfer-Encoding: 8BIT
Message-Id: <A8DAD77E-D870-4E88-A2D0-ACCAB0DC7348@sandeen.net>
References: <1519468406-67354-1-git-send-email-cgxu519@icloud.com> <5d92aa93-cec4-2495-70fa-61d082e1cb6b@sandeen.net> <326CF29E-FC88-493B-B16E-7EA318169E9A@icloud.com> <20180225180916.GB19312@magnolia> <fe6ac2e6-bac0-7f8f-4a24-f72439365848@sandeen.net> <20180225210524.GE30854@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Chengguang Xu <cgxu519@icloud.com>, linux-xfs@vger.kernel.org



> On Feb 25, 2018, at 3:05 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
>> On Sun, Feb 25, 2018 at 12:11:28PM -0600, Eric Sandeen wrote:
>> 
>> 
>>> On 2/25/18 12:09 PM, Darrick J. Wong wrote:
>>> On Sun, Feb 25, 2018 at 12:11:23PM +0800, Chengguang Xu wrote:
>>>>> 
>>>>> 在 2018年2月25日，上午1:58，Eric Sandeen <sandeen@sandeen.net> 写道：
>>>>> 
>>>>>> On 2/24/18 4:33 AM, Chengguang Xu wrote:
>>>>>> When specifying string type mount option (e.g., logdev)
>>>>>> several times in a mount, current option parsing may
>>>>>> cause memory leak. Hence, call kfree for previous one
>>>>>> in this case.
>>>>>> 
>>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>> 
>>>>> IMHO multiple specifications of logdev or rtdev should not
>>>>> be allowed; only one may be chosen, and specifying twice
>>>>> should probably be considered and administrative error.
>>>>> 
>>>>> I'd rather see something that fails and cleans up properly
>>>>> if either option is respecified.
>>>> 
>>>> Hi Eric,
>>>> 
>>>> Thanks for quick reply. I think your suggestion makes sense,
>>>> but considering of the consistency with other options, 
>>>> we should check multiple specifications for all options. 
>>>> 
>>>> So I think this patch is the cheapest way to fix the issue.
>>>> What do you think?
>>> 
>>> I think the all the mount options should be cleaned up to allow one
>>> specification only.
>> 
>> Yeah, I think so too, though perhaps it's fair to have one patch
>> to fix the leak as it stands today, and another to clean up the
>> respecification problem.
> 
> Won't that break existing userspace configs? Haven't we had cases in
> the past where mount did something whacky and passed dulicate
> options to the kernel through no fault of the user?
> 
Hmm perhaps on remount yes... worth testing / checking.

Eric

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

