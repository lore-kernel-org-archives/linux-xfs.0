Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35021 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdHDDgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 23:36:35 -0400
Received: by mail-wm0-f47.google.com with SMTP id m85so9669717wma.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Aug 2017 20:36:34 -0700 (PDT)
Subject: Re: Intermittent zeroed pages with AIO+DIO+XFS
References: <dac170a5-d11f-c8ce-3890-8b5629364c18@scylladb.com>
 <20170803220922.GA21024@dastard>
 <9a63f206-d026-eae4-9556-957ef94855b4@scylladb.com>
 <20170804031410.GC21024@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <cc9d3cd3-3a3d-6652-2073-9dc9b3243c07@scylladb.com>
Date: Fri, 4 Aug 2017 06:36:30 +0300
MIME-Version: 1.0
In-Reply-To: <20170804031410.GC21024@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Glauber Costa <glauber@scylladb.com>, Raphael Carvalho <raphaelsc@scylladb.com>

On 08/04/2017 06:14 AM, Dave Chinner wrote:
> On Fri, Aug 04, 2017 at 05:40:07AM +0300, Avi Kivity wrote:
>> On 08/04/2017 01:09 AM, Dave Chinner wrote:
>>> On Thu, Aug 03, 2017 at 05:52:45PM +0300, Avi Kivity wrote:
>>>> Hello,
>>>>
>>> Hi Avi,
>>>
>>>> I have an application that uses AIO+DIO to write data to a file on
>>>> XFS. The writes use 128k buffers. Very rarely, I see aligned 4k
>>>> blocks within the file that are zeroed. The blocks are not aligned
>>>> to 128k boundary, just 4k. The buffers are allocated in anonymous
>>>> memory, which is usually using transparent hugepages.  The files are
>>>> fully allocated, not sparse (checked post-mortem).
>>> Did you check that the extents are written? i.e. there aren't
>>> sporadic 4k unwritten extents in the file? (xfs_bmap -vvp output)
>> Raphael did that, and the result was that the file was NOT sparse.
> Sure, but a file with unwritten extents is not sparse. It's just got
> extents that will always read as zeros. The extra "-vvp" output
> tells you the unwritten flag state and does not merge contiguous
> extents that differ only in state.

Ah, thanks for the explanation. Raphael, can you check this?

> i.e:
>
> $ sudo xfs_io -fd -c "falloc 0 1M" -c "pwrite 900k 200k" /mnt/scratch/foo
> wrote 204800/204800 bytes at offset 921600
> 200 KiB, 50 ops; 0.0000 sec (13.838 MiB/sec and 3542.5818 ops/sec)
> $ sudo xfs_bmap /mnt/scratch/foo
> /mnt/scratch/foo:
>          0: [0..2199]: 160..2359
>
> Looks fully allocated. However:
>
> $ sudo xfs_bmap -vvp /mnt/scratch/foo
> /mnt/scratch/foo:
>   EXT: FILE-OFFSET      BLOCK-RANGE       AG AG-OFFSET        TOTAL FLAGS
>     0: [0..1799]:       160..1959          0 (160..1959)       1800 010000
>     1: [1800..2199]:    1960..2359         0 (1960..2359)       400 000000
>   FLAG Values:
>      0100000 Shared extent
>      0010000 Unwritten preallocated extent
>      0001000 Doesn't begin on stripe unit
>      0000100 Doesn't end   on stripe unit
>      0000010 Doesn't begin on stripe width
>      0000001 Doesn't end   on stripe width
> $
>
> The first 900k of the file is an unwritten extent, which returns
> zeros...
>
>> btw, we also run with the extent size hint set to 32MB.
> Which means that space is definitely being allocated as unwritten
> extents, then overwritten and converted on IO completion. Hence if
> the overwrite is not complete, or there's a bug in the unwritten
> extent conversion, it may leave unwritten extents where it
> shouldn't....
>
>>> What kernel version is this seen on? We've changed the XFS DIO
>>> IO path implementation substantially in recent times....
>> CentOS 7.2's kernel. Glauber, do you now the precise version string?
> Can you reproduce on an upstream kernel? Problems with highly
> patched distro kernels really need to be directed to the distro...

This is a production cluster, and we've only seen the problem in this 
one cluster, and _very_ rarely there.

>>>> Does this trigger anything in anyone's mind?
>>> Nope - do you have a reproducer you can share?
>>>
>> Run a certain NoSQL database for months on a cluster with lots of
>> activity, and _may_ see it a few time. It's very rare, but it's
>> there.
> Needle in a haystack, then - the problem could be anywhere in the
> storage stack, including hardware.

Yes, unfortunately.

>   You're going to need to
> isolate the problem to the filesystem for us, which means a
> reproducer script of some kind...

It's very unlikely we'll find a simple reproducer; this email was more 
to see if the list has seen this problem before rather than as a 
detailed bug report.
