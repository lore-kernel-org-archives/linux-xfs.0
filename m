Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:54984 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751661AbdJIIGB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 04:06:01 -0400
Received: by mail-wm0-f46.google.com with SMTP id i124so20906921wmf.3
        for <linux-xfs@vger.kernel.org>; Mon, 09 Oct 2017 01:06:00 -0700 (PDT)
Subject: Re: agcount for 2TB, 4TB and 8TB drives
References: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
 <20171006153803.GI7122@magnolia>
 <8e6fd742-8767-e786-746d-2b9f2929b98c@sandeen.net>
 <20171006222031.GU3666@dastard>
 <b97b41f5-76dc-b2d7-3b34-02a331b0d8de@sandeen.net>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <1b5b6410-b1d9-8519-7032-8ea0ca46f5b5@scylladb.com>
Date: Mon, 9 Oct 2017 11:05:56 +0300
MIME-Version: 1.0
In-Reply-To: <b97b41f5-76dc-b2d7-3b34-02a331b0d8de@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-xfs@vger.kernel.org



On 10/07/2017 01:21 AM, Eric Sandeen wrote:
>
> On 10/6/17 5:20 PM, Dave Chinner wrote:
>> On Fri, Oct 06, 2017 at 11:18:39AM -0500, Eric Sandeen wrote:
>>> On 10/6/17 10:38 AM, Darrick J. Wong wrote:
>>>> On Fri, Oct 06, 2017 at 10:46:20AM +0200, Gandalf Corvotempesta wrote:
>>>> Semirelated question: for a solid state disk on a machine with high CPU
>>>> counts do we prefer agcount == cpucount to take advantage of the
>>>> high(er) iops and lack of seek time to increase parallelism?
>>>>
>>>> (Not that I've studied that in depth.)
>>> Interesting question.  :)  Maybe harder to answer for SSD black boxes?
>> Easy: switch to multidisk mode if /sys/block/<dev>/queue/rotational
>> is zero after doing all the other checks. Then SSDs will get larger
>> AG counts automatically.
> The "hard part" was knowing just how much parallelism is actually inside
> the black box.

It's often > 100.

>    But "multidisk mode" doesn't go too overboard, so yeah
> that's probably fine.
>


Is there a penalty associated with having too many allocation groups?
