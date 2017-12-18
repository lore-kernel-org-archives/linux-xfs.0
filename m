Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34961 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757810AbdLRD2I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 Dec 2017 22:28:08 -0500
Subject: Re: Detecting RWF_NOWAIT support
References: <b45afd09-5fa8-74ac-4ba4-9dc9074e30cf@scylladb.com>
 <4ae3426d-8104-c243-72e4-671e89401b23@suse.de>
 <0ae3b9d3-0e57-5562-5a8d-62496a261521@scylladb.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <c4b15d8a-e868-5b31-f499-28151ba36116@suse.de>
Date: Sun, 17 Dec 2017 21:28:03 -0600
MIME-Version: 1.0
In-Reply-To: <0ae3b9d3-0e57-5562-5a8d-62496a261521@scylladb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org



On 12/16/2017 08:49 AM, Avi Kivity wrote:
> 
> 
> On 12/14/2017 09:15 PM, Goldwyn Rodrigues wrote:
>>
>> On 12/14/2017 11:38 AM, Avi Kivity wrote:
>>> I'm looking to add support for RWF_NOWAIT within a linux-aio iocb.
>>> Naturally, I need to detect at runtime whether the kernel support
>>> RWF_NOWAIT or not.
>>>
>>>
>>> The only method I could find was to issue an I/O with RWF_NOWAIT set,
>>> and look for errors. This is somewhat less than perfect:
>>>
>>>   - from the error, I can't tell whether RWF_NOWAIT was the problem, or
>>> something else. If I enable a number of new features, I have to run
>>> through all combinations to figure out which ones are supported and
>>> which are not.
>> Here is the return codes for RWF_NOWAIT
>> EINVAL - not supported (older kernel)
>> EOPNOTSUPP - not supported
>> EAGAIN - supported but could not complete because I/O will be delayed
> 
> Which of these are returned from io_submit() and which are returned in
> the iocb?

These are returned in iocb.

> 
>> 0 - supported and I/O completed (success).
>>
>>>   - RWF_NOWAIT support is per-filesystem, so I can't just remember
>>> not to
>>> enable RWF_NOWAIT globally, I have to track it per file.
>> Yes, the support is per filesystem. So, the application must know if the
>> filesystem supports it, possibly by performing a small I/O.
> 
> So the application must know about filesystem mount points, and be
> prepared to create a file and try to write it (in case the filesystem is
> empty) or alter its behavior during runtime depending on the errors it
> sees.

Well yes. Hopefully, the application knows what it is doing when it
performs RWF_NOWAIT.

-- 
Goldwyn
