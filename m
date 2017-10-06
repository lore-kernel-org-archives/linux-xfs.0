Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47758 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbdJFWVs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Oct 2017 18:21:48 -0400
Subject: Re: agcount for 2TB, 4TB and 8TB drives
References: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
 <20171006153803.GI7122@magnolia>
 <8e6fd742-8767-e786-746d-2b9f2929b98c@sandeen.net>
 <20171006222031.GU3666@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b97b41f5-76dc-b2d7-3b34-02a331b0d8de@sandeen.net>
Date: Fri, 6 Oct 2017 17:21:47 -0500
MIME-Version: 1.0
In-Reply-To: <20171006222031.GU3666@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-xfs@vger.kernel.org



On 10/6/17 5:20 PM, Dave Chinner wrote:
> On Fri, Oct 06, 2017 at 11:18:39AM -0500, Eric Sandeen wrote:
>> On 10/6/17 10:38 AM, Darrick J. Wong wrote:
>>> On Fri, Oct 06, 2017 at 10:46:20AM +0200, Gandalf Corvotempesta wrote:
>>> Semirelated question: for a solid state disk on a machine with high CPU
>>> counts do we prefer agcount == cpucount to take advantage of the
>>> high(er) iops and lack of seek time to increase parallelism?
>>>
>>> (Not that I've studied that in depth.)
>>
>> Interesting question.  :)  Maybe harder to answer for SSD black boxes?
> 
> Easy: switch to multidisk mode if /sys/block/<dev>/queue/rotational
> is zero after doing all the other checks. Then SSDs will get larger
> AG counts automatically.

The "hard part" was knowing just how much parallelism is actually inside
the black box.  But "multidisk mode" doesn't go too overboard, so yeah
that's probably fine.

-Eric
 
> Cheers,
> 
> Dave.
> 
