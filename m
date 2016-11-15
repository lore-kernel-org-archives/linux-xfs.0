Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25801 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755295AbcKOHyF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 02:54:05 -0500
Subject: Re: About difference in extent sharing in btrfs and xfs
References: <1de48152-0ec5-1bf0-1ea9-b5ccbe4a3867@cn.fujitsu.com>
 <20161115074715.GA23680@birch.djwong.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <598d644b-fe2c-f0d8-6deb-cbd4889e77ec@cn.fujitsu.com>
Date: Tue, 15 Nov 2016 15:53:49 +0800
MIME-Version: 1.0
In-Reply-To: <20161115074715.GA23680@birch.djwong.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>



At 11/15/2016 03:47 PM, Darrick J. Wong wrote:
> On Tue, Nov 15, 2016 at 02:33:31PM +0800, Qu Wenruo wrote:
>> Hi, xfs guys and btrfs guys.
>>
>> Although the test case generic/372 exists for some time, I noticed that
>> btrfs always fails the test case, due to the difference in how btrfs
>> and xfs handle shared extents.
>>
>> The difference is, btrfs can handle shared extents which points to a subset
>> of a larger extent, so it doesn't need to split reflink source.
>>
>> In case of the test case.
>>
>> On Disk Extent A:
>> Bytenr X
>> |<-----------Data=0x61, Length=320K---------------------------|
>>
>>
>> File1: File Extent 0 -> Extent A, offset=0, referred len=320K
>>
>> File2: File Extent 0 -> Hole
>>        File Extent 64K -> Extent A, offset=192k, refferred len=64k
>>        File Extent 128K -> Hole
>>        File Extent 192K -> Extent A, offset=64k, refferred len=64k
>>
>> Unlike Xfs, Btrfs don't split the source extent, as its file extent has more
>> fields which can handle offset/length inside the large extent.
>
> XFS doesn't split the extent either, internally.  The FIEMAP
> implementation cross-references extent data with the refcount records,
> using extra struct fiemap_extent to report precisely which blocks are
> shared and which aren't.  ocfs2 exhibits the same behavior.
>
> It's only btrfs that reports file1 as having one big shared extent when
> only parts of that extent are actually shared.  I'd rather btrfs only
> report blocks that are actually shared as shared, but since fiemap
> results can be obsolete as soon as the ioctl returns I don't consider it
> a huge priority.
>
>> The btrfs way to handle shared extent has its pros and cons.
>> For example, it's very flex, but it wastes more space for COW since the
>> whole extent can only be freed after all referencer is freed.
>
> Wait, what?  So if I reflinked a single block of file1 into file3 and
> then deleted file1 and file2, btrfs would hold on to all 320K?

Yep. That's the biggest problem for such extent booking.
Normally it's defrag to split and free the unused part...

But ironically, current btrfs defrag can't handle shared extents at all.
So defrag is only useful when there is only last referencer on that extent.

>
>> But since the test case is generic test case, I think it doesn't take such
>> btrfs behavior into consideration.
>> So it always fails on btrfs.
>>
>> How about moving it to xfs specific tests?
>
> I'd prefer the testcase be left in generic/ and _notrun'd on btrfs since
> two of the three reflink fses have this behavior.
>
> (Assuming the btrfs behavior doesn't get changed.)

I don't think btrfs will change the behavior soon, so I'd prefer to 
blacklist btrfs for this test case.

Thanks,
Qu
>
> --D
>
>>
>> Thanks,
>> Qu
>>
>>
>
>


