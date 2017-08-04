Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35460 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdHDCuq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 22:50:46 -0400
Received: by mail-pg0-f53.google.com with SMTP id v189so2295449pgd.2
        for <linux-xfs@vger.kernel.org>; Thu, 03 Aug 2017 19:50:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9a63f206-d026-eae4-9556-957ef94855b4@scylladb.com>
References: <dac170a5-d11f-c8ce-3890-8b5629364c18@scylladb.com>
 <20170803220922.GA21024@dastard> <9a63f206-d026-eae4-9556-957ef94855b4@scylladb.com>
From: Glauber Costa <glauber@scylladb.com>
Date: Thu, 3 Aug 2017 22:50:44 -0400
Message-ID: <CAD-J=zZ-jq=O76NsoQxMvPpfD3cGSu4n4Rv2505RrGRPr-cJ4w@mail.gmail.com>
Subject: Re: Intermittent zeroed pages with AIO+DIO+XFS
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Raphael Carvalho <raphaelsc@scylladb.com>

On Thu, Aug 3, 2017 at 10:40 PM, Avi Kivity <avi@scylladb.com> wrote:
> On 08/04/2017 01:09 AM, Dave Chinner wrote:
>>
>> On Thu, Aug 03, 2017 at 05:52:45PM +0300, Avi Kivity wrote:
>>>
>>> Hello,
>>>
>> Hi Avi,
>>
>>> I have an application that uses AIO+DIO to write data to a file on
>>> XFS. The writes use 128k buffers. Very rarely, I see aligned 4k
>>> blocks within the file that are zeroed. The blocks are not aligned
>>> to 128k boundary, just 4k. The buffers are allocated in anonymous
>>> memory, which is usually using transparent hugepages.  The files are
>>> fully allocated, not sparse (checked post-mortem).
>>
>> Did you check that the extents are written? i.e. there aren't
>> sporadic 4k unwritten extents in the file? (xfs_bmap -vvp output)
>
>
> Raphael did that, and the result was that the file was NOT sparse.
>
> btw, we also run with the extent size hint set to 32MB.
>
>> If you turn off transparent huge pages, does the problem go
>> away?
>
>
> We did not check yet.
>
>> What kernel version is this seen on? We've changed the XFS DIO
>> IO path implementation substantially in recent times....
>
>
> CentOS 7.2's kernel. Glauber, do you now the precise version string?

Yes I do, sir!

3.10.0-327.el7.x86_64

(Hey, Dave!)

>
>>> The writes are concurrent and adjacent. To avoid serialization, we
>>> ftruncate() the file to a larger size, then ftruncate() it back when
>>> we know its final size.
>>
>> So it's not extending the file on the writes, so it shouldn't be
>> triggering EOF block zeroing. The only thing I can think of is
>> either the data contains zeros or there's an occasional unwritten
>> extent in the file.
>
>
> The data is compressed, so it can't contain zeros originally. Of course it's
> possible the application zeroed that page after preparing the buffer and
> before the write hit the disk, but that's fairly unlikely. Zeroing pages is
> a kernel thing; even if the application allocated 4k of memory (not very
> common, but it does happen), it wouldn't zero it; and that buffer of course
> is held during the write.
>
> We're adding code to check the buffer before and after the write, and also
> read back from disk.
>
>>
>>> Does this trigger anything in anyone's mind?
>>
>> Nope - do you have a reproducer you can share?
>>
>
> Run a certain NoSQL database for months on a cluster with lots of activity,
> and _may_ see it a few time. It's very rare, but it's there.
>
