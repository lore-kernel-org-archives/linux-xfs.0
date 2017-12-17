Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:46588 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdLQHJS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Dec 2017 02:09:18 -0500
Received: by mail-wm0-f43.google.com with SMTP id r78so24054856wme.5
        for <linux-xfs@vger.kernel.org>; Sat, 16 Dec 2017 23:09:18 -0800 (PST)
Subject: Re: Detecting RWF_NOWAIT support
References: <b45afd09-5fa8-74ac-4ba4-9dc9074e30cf@scylladb.com>
 <4ae3426d-8104-c243-72e4-671e89401b23@suse.de>
 <0ae3b9d3-0e57-5562-5a8d-62496a261521@scylladb.com>
 <20171216180338.w3aujakzh4frepko@shells.gnugeneration.com>
 <20171216181236.kbtlg2makrnmq34g@shells.gnugeneration.com>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <5acc827b-05d1-c64a-8842-f33f1a361b9e@scylladb.com>
Date: Sun, 17 Dec 2017 09:09:13 +0200
MIME-Version: 1.0
In-Reply-To: <20171216181236.kbtlg2makrnmq34g@shells.gnugeneration.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: vcaputo@pengaru.com
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org



On 12/16/2017 08:12 PM, vcaputo@pengaru.com wrote:
> On Sat, Dec 16, 2017 at 10:03:38AM -0800, vcaputo@pengaru.com wrote:
>> On Sat, Dec 16, 2017 at 04:49:08PM +0200, Avi Kivity wrote:
>>>
>>> On 12/14/2017 09:15 PM, Goldwyn Rodrigues wrote:
>>>> On 12/14/2017 11:38 AM, Avi Kivity wrote:
>>>>> I'm looking to add support for RWF_NOWAIT within a linux-aio iocb.
>>>>> Naturally, I need to detect at runtime whether the kernel support
>>>>> RWF_NOWAIT or not.
>>>>>
>>>>>
>>>>> The only method I could find was to issue an I/O with RWF_NOWAIT set,
>>>>> and look for errors. This is somewhat less than perfect:
>>>>>
>>>>>    - from the error, I can't tell whether RWF_NOWAIT was the problem, or
>>>>> something else. If I enable a number of new features, I have to run
>>>>> through all combinations to figure out which ones are supported and
>>>>> which are not.
>>>> Here is the return codes for RWF_NOWAIT
>>>> EINVAL - not supported (older kernel)
>>>> EOPNOTSUPP - not supported
>>>> EAGAIN - supported but could not complete because I/O will be delayed
>>> Which of these are returned from io_submit() and which are returned in the
>>> iocb?
>>>
>>>> 0 - supported and I/O completed (success).
>>>>
>>>>>    - RWF_NOWAIT support is per-filesystem, so I can't just remember not to
>>>>> enable RWF_NOWAIT globally, I have to track it per file.
>>>> Yes, the support is per filesystem. So, the application must know if the
>>>> filesystem supports it, possibly by performing a small I/O.
>>> So the application must know about filesystem mount points, and be prepared
>>> to create a file and try to write it (in case the filesystem is empty) or
>>> alter its behavior during runtime depending on the errors it sees.
>> Can't the application simply add a "nowait" flag to its open file
>> descriptor encapsulation struct, then in the constructor perform a
>> zero-length RWF_NOWAIT write immediately after opening the fd to set the
>> flag?  Then all writes branch according to the flag.
>>
>> According to write(2):
>>
>>         If  count is zero and fd refers to a regular file, then write()
>>         may return a failure status if one of the errors below is
>>         detected.  If no errors are detected,  or error detection is not
>>         performed, 0 will be returned without causing any other effect.
>>         If count is zero and fd refers to a file  other than a regular
>>         file, the results are not specified.
>>
>> So the zero-length RWF_NOWAIT write should return zero, unless it's not
>> supported.
>>
> Oh, I assumed this new flag applied to pwritev2() flags.  Disregard my
> comment, I see the ambiguity causing your question Avi and do not know
> the best approach.
>

Actually it's not a bad idea. I'm using AIO, not p{read,write}v2, but I 
can assume that the response will be the same and that a zero-length 
read will return immediately.
