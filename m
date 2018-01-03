Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr014msb.fastweb.it ([85.18.95.103]:39470 "EHLO
        mr014msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbeACWJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 17:09:33 -0500
Subject: Re: Block size and read-modify-write
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Jan 2018 23:09:30 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180103214741.GO5858@dastard>
References: <021d36d95a9de952ddd38cc56d18df4f@assyoma.it>
 <20180102102539.5kh2tjo5gmlewiek@odin.usersys.redhat.com>
 <20180103011926.GJ5858@dastard>
 <b58a3a90-0e7b-abca-91ce-8b2d8819a75b@assyoma.it>
 <20180103214741.GO5858@dastard>
Message-ID: <fa54fea7ec0d836f2c037f7b71a17365@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 03-01-2018 22:47 Dave Chinner ha scritto:
> On Wed, Jan 03, 2018 at 03:54:42PM +0100, Gionatan Danti wrote:
>> 
>> 
>> On 03/01/2018 02:19, Dave Chinner wrote:
>> >Cached writes smaller than a *page* will cause RMW cycles in the
>> >page cache, regardless of the block size of the filesystem.
>> 
>> Sure, in this case a page-sized r/m/w cycle happen in the pagecache.
>> However it seems to me that, when flushed to disk, writes happens at
>> the block level granularity, as you can see from tests[1,2] below.
>> Am I wrong? I am missing something?
> 
> You're writing into unwritten extents. That's not a data overwrite,
> so behaviour can be very different. And when you have sub-page block
> sizes, the filesystem and/or page cache may decide not to read the
> whole page if it doesn't need to immmediately. e.g. you'll see
> different behaviour between a 512 byte write() and a 512 byte write
> via mmap()...

The first "dd" execution surely writes into unwritten extents. However, 
on the following writes real data are overwritten, right?

> IOWs, there are so many different combinations of behaviour and
> variables that we don't try to explain every single nuance. If you
> do sub-page and/or sub-block size IO, then expect to page sized RMW
> to occur. It might be smaller depending on the fs config, the file
> layout, the underlying extent type, the type of ioperation the
> write must perform (e.g. plain overwrite vs copy-on-write), the
> offset into the page/block, etc. The simple message is this: avoid
> sub-block/page size IO if you can possibly avoid it.
> 
>> >Ok, there is a difference between *sector size* and *filesystem
>> >block size*. You seem to be using them interchangably in your
>> >question, and that's not correct.
>> 
>> True, maybe I have issues grasping the concept of sector size from
>> XFS point of view. I understand sector size as an hardware property
>> of the underlying block device, but how does it relate to the
>> filesystem?
>> 
>> I naively supposed that an XFS filesystem created with 4k *sector*
>> size (ie: mkfs.xfs -s size=4096) would prevent 512 bytes O_DIRECT
>> writes, but my test[3] shows that even of such a filesystem a 512B
>> direct write is possible, indeed.
>> 
>> Is sector size information only used by XFS own metadata and
>> journaling in order to avoid costly device-level r/m/w cycles on
>> 512e devices? I understand that on 4Kn device you *have* to avoid
>> sub-sector writes, or the transfer will fail.
> 
> We don't care if the device does internal RMW cycles (RAID does
> that all the time). The sector size we care about is the size of an
> atomic write IO - the IO size that the device guarantees will either
> succeed completely or fail without modification. This is needed for
> journal recovery sanity.
> 
> For data, the kernel checks the logical device sector size and
> limits direct IO to those sizes, not the filesystem sector size.
> i.e.  filesystem sector size if there for sizing journal operations
> and metadata, not limiting data access alignment.

This is an outstanding explanation.
Thank you very much.

>> I want to put some context on the original question, and why I am so
>> interested on r/m/w cycles. SSD's flash-page size has, in recent
>> years (2014+), ballooned to 8/16/32K. I wonder if a matching
>> blocksize and/or sector size are needed to avoid (some of)
>> device-level r/m/w cycles, which can dramatically increase flash
>> write amplification (with reduced endurance).
> 
> We've been over this many times in the past few years. user data
> alignment is controlled by stripe unit/width specification,
> not sector/block sizes.

Sure, but to avoid/mitigate device-level r/m/w, a proper alignement is 
not sufficient by itself. You should also avoid partial page writes. 
Anyway, I got the message: this is not business XFS directly cares 
about.

Thanks again.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
