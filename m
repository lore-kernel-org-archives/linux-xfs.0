Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E9C313E2C
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349269; cv=none; b=txPpaiUpAXXEkfjmKyV7VNUNtjJlGMrSyrUy0H3V+bLVUTqg2U3UOHBFVO9tTGaFGH2yGKNBgq8mxyLFAQO/gZ9G7z/Vr3Aj5LGyyD0T4Z/M9Xspo/FOt3L5nN0WyDcRu5YyEnjxqdp7C6DahfAvYvAzDmZsA20m/2Sy/SWCVGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349269; c=relaxed/simple;
	bh=fg37MteT6qY7CtU29ZE8/EHbRk/gkamdt7ir4NJTd3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=CILBZOzpnmzhLnxnHddf5DTxCKyYG1u8sW7aNarmMG0aNzukXkH5C6IjX8AukjpCrFX7xqXHXuQHGUxyMRr5DjOWdiSb/zEuqxK0x8KVwmyr9c6tufEj+E2p5rw+bsokCyDj+cfUIqkJ5Nh3ZlESybiJRi4Hl9PwWOrkzDhVRd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IhKrpIUY; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IhKrpIUY"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260925151401epoutp04ce5ff3a22c4f552002da5b9463ca1352~YmSZSmiTi1412014120epoutp04K
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:14:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260925151401epoutp04ce5ff3a22c4f552002da5b9463ca1352~YmSZSmiTi1412014120epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790349241;
	bh=N8u7AhFgBlad5WR0/tVzgePRA0W94FbpCUUti3H2j+s=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=IhKrpIUYoYHMe/uVmwabXhD60q//eU55FhMLZCVPRDd9SrRWMCQLaE0kRbWcoc2rM
	 fBu6HnkQ3g4F3waPqotJRs2yrWeZ+5BkVYJcRJAEU7fc3aUoiLGeswbuxC3aVur6QD
	 dQsjM9k5GAj5dTf8YpmV10d635V/DYjbER+y5ghk=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260925151401epcas5p440a8f2a08d5d9f1a1fb20ffd97dafc4f~YmSYsWkU40593105931epcas5p4V;
	Fri, 25 Sep 2026 15:14:01 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hrvP432WDz3hhT3; Fri, 25 Sep
	2026 15:14:00 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260925151359epcas5p1c8ac740378cfccbb49b35809a6532025~YmSXOoaWq1249312493epcas5p1W;
	Fri, 25 Sep 2026 15:13:59 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260925151357epsmtip2c124ee0bbf16fef5d59ebc0d79eeabbb~YmSVx3xtN0776207762epsmtip2S;
	Fri, 25 Sep 2026 15:13:57 +0000 (GMT)
Message-ID: <ef9844a0-3a9f-48e4-8092-2de2e03db1c8@samsung.com>
Date: Fri, 25 Sep 2026 20:43:56 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] xfs write streams
To: Dave Chinner <dgc@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, cem@kernel.org,
	jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, gost.dev@samsung.com
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <arG8a7Vcy6_qZi0e@dread>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260925151359epcas5p1c8ac740378cfccbb49b35809a6532025
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921093229epcas5p387ee10f88335ddc5fc930ca919769a60
References: <CGME20260921093229epcas5p387ee10f88335ddc5fc930ca919769a60@epcas5p3.samsung.com>
	<20260921093147.59935-1-joshi.k@samsung.com> <arG8a7Vcy6_qZi0e@dread>

On 9/22/2026 4:53 AM, Dave Chinner wrote:
> On Mon, Sep 21, 2026 at 03:01:39PM +0530, Kanchan Joshi wrote:
>> This series introduces a generic interface [2,3] for write stream management on
>> files.
>> It enables spatial isolation (at sw and hw level) and concurrency improvments [1]
>> in xfs by
>> (a) steering each write stream to its own set of allocation groups (patch #5)
>>      and realtime groups (patch #6).
>> (b) connecting xfs write streams to block write streams (FDP capable NVMe).
>>
>> Write streams allow the abstraction provider (fs, block, raid etc.) to
>> leverage application's intent (file relationships/lifecycle).
>> - application: reserves a stream and sets it on the files it wants
>>    placed together.
>> - xfs: maps streams to AGs/RGs; allocates without interleaving; gains
>>    higher concurrency due to reduced lock contention.
>> - hardware: maps streams to underlying allocation unit; reduces device
>>    internal write amplification, improved life, predictable QoS.
>>
>> Also
>> - A stream is handed out using an fd. The filesystem is free to map streams
>>    onto its own geometry, and the reservation/fd machinery is generic
>>   (fs/write_streams.c) so other filesystems can reuse it.
>>
>> - Since high-level write stream (in xfs) and logical placement can work
>>    without the low-level write streams (in block device), series has a general
>>    value beyond the hardware that provides spatial isolation. Patches 1-7 are
>>    software only and work on any block device; patch 8 aligns the stream
>>    count to the hardware streams when the device has them.
> 
> So, how would I set up a stream that directs all writes to AG 1, and
> returns ENOSPC to write operations if that AG is full?

You can't, and that's a deliberate and necessary design choice for the 
usecase (and I mentioned soft boundary in patch #5). While AG/RG are 
fixed-sized XFS buckets, stream is a high-level (vfs) bucket with its 
opaque handle (fd) that does not come with fixed size constraint. 
Applications may tag many files (more data) with one stream and tag few 
(less data) with another stream.


> What about having several streams, each pointing at a different,
> known AG that the application directly controls (i.e. a known 1:1
> mapping between stream_fd and agno)?

We can't use agno here.
Stream lets the application state intent: these files belong together, 
those stay apart. It does not dictate layout. AG/RG is xfs-only 
vocabulary, and that's fine for xfs-only interface. But we are doing a 
generic interface that needs to remain portable across filesystems.


> This is functionality that we could use in xfs_fsr to get rid of all
> the historic tmpdir/tmpfile heuristics that allow it to "control"
> locality of the data placement of files that it defragments. We also
> need such control of data placement to empty AGs for shrink
> operations. Yes, this only occurred to me a couple of days ago, but
> now that I've made the connection between write streams and fs
> allocation policy direction, it seems like a natural fit.
> 
> FWIW, that also means that, for XFS, write streams need to be
> applicable to directories, so that directory block allocation also
> gets placed according to the stream ID, and that new inodes in that
> directory are created in the same AG as the stream ID points to.
> This directly allows us to rebuild directories using FICLONE/UNSHARE
> tricks and have all the indoes, data and metadata placed in the AG
> we desire (i.e. necessary functionality for online shrink).


With this, we are discussing xfs tools (and not fs-agnostic 
applications) that speak nitty-gritty of xfs layout. This usecase does 
not require stream and stream-fd based workflow of this series; it can 
be served more cleanly with XFS only ioctl. Something like:

  XFS_IOC_SET_GROUP(AG/RG no, flags) on the file

To set the 'hard' allocation-directive so that all allocations happens 
from that AG/RG no and ENOSPC if not.

Also it seems shrink usecase will also require that target AG remains 
exclusive (not available for allocations) while it is getting emptied. 
That, exclusive capacity locking, also we don't do with write-stream. We 
can't return ENOSPC to other allocators just because somebody decided to 
use/abuse stream to create artificial lack of free space.

> So:
> 
>> [2]
>> ### Application interface
>>
>> Three new ioctls:
>>        FS_IOC_WRITE_STREAM_GET_MAX  number of streams the filesystem offers
>>        FS_IOC_WRITE_STREAM_ALLOC    reserve a stream, returns an fd
>>        FS_IOC_WRITE_STREAM_SET      set or clear a stream on a file
> 
> How does this interface enable such usage of write streams to direct
> purely filesystem level allocation policy requirements?

As mentioned above, you might agree that interface should remain 
portable across filesystems.

> I don't see
> how I can use this API to direct where in the filesystem to map the
> stream to. I can see that there is a 'set' command, but all it has
> is a flags field. There's nothing passed to the ALLOC command to
> allow the application to indicate to the filesystem where it wants
> the new stream to point to.

FWIW, we had a 'stream-id' as part of ALLOC in the previous version.
Christoph suggested to remove that from UAPI.
https://lore.kernel.org/linux-xfs/20260825065533.GA24808@lst.de/

The direction has been to be more opaque and less explicit.

> IOWs, it appears taht there is no way to provide the FS with any
> sort of direction as to how the stream should be set up. If we want
> a FS specific stream (e.g. an AG) then we don't want it mapped to a
> hardware stream, and we don't want it mapped to some random set of
> AGs (like this patchset implements). The only real reason for
> filesystem level write streams is to expose allocation locality
> control to applications, so it seems kinda silly to have an API that
> prevents any real application level control...
> Indeed, how do we ask for a fs-level write stream instead of a
> hardware-level write stream? They are different things, and have
> different use cases (obviously!) so there definitely needs to be
> some level of though put into this. And, FWIW, the write stream id
> will probably need to be a u32 if we are going to support FS level
> write streams, as we can have more than 65536 AGs in a
> filesystem....

All this gets handled cleanly with the above xfs-ioctl based approach.
In that, one can put the actual AG/RG no into xfs-inode itself so that 
future allocation can happen from that.


> 
>> - Usage model: application needs to get a handle (fd) for a write stream
>>    before being able to use it. This avoids multi-application conflicts.
> 
> Why can't multiple applications use the same write stream locality
> mapping independently? If the application wants an exclusive write
> stream (i.e. exclusive access to a set of AGs in the filesystem),
> then surely that's a flag for the ALLOC API, right?

Fair; But I should clarity that exclusive access is only for stream 
resource/handle (fd) so that another unrelated application does not pick 
the same stream and start colliding. This matters more for hardware 
stream. But exclusivity is not about AGs, we don't lock AGs on 
per-stream basis.




