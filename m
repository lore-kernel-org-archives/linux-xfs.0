Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F800346776
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 19:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773169432; cv=none; b=H9eZfROkjtp4RkndirRK8vvqMSta63ebqL1mCBjU0Pd3SJ1IEag8CXWXqSNneFJ/8j8F0nmmROUr1djIowtUZue4KA+ekJC5VaR8N2/nqawjJMSQHLEtRXsVDRj/x1K5Av4vtHOIhcuwEQy+Dr99dk04HfGUMj2r8B59mX3QWNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773169432; c=relaxed/simple;
	bh=dlv00AgLM+KouvtSokdVKlP46ycLQjKEHfebwFemrBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=EQouwkPzHowPMja/91xWe+GT5185pSOJh6eJ85CjQxbxVha17B2ZOfPDpoUvGhnpn5GhNsYbF3TXhLu5yvvqnB9F7klAKnksL93jXrSjmssrx3B15DrK4vQ88DUfQosdrCt5GLuMx+vfMmz/TIeHkuCJ9PKk/P68gCBF6xUGVew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sOxX9Pe5; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sOxX9Pe5"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260310190348epoutp0232ede5b5b71b92e7c8d952bc7e7bf274~bkDM-fpjk0531005310epoutp02k
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 19:03:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260310190348epoutp0232ede5b5b71b92e7c8d952bc7e7bf274~bkDM-fpjk0531005310epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773169428;
	bh=RSII0xHq4bz2UU0P23lD0uAewQb3K85xxRg2UTCbBVM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=sOxX9Pe5Jna37SeKBIHP9GhA7DOVsoMSLKHE90bYRsTm8podOUy6Gp0qHwZWEZ8pc
	 tkSzuadq1aHEmEUPMWBlDsXMJ13+phZcXICR8D4rgXKfd3IBFe485Et0Lc7zaug48z
	 q0XeZib6y/ycIRMzPYkaDGNbK7bn7h4hswhM1QVA=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260310190346epcas5p226e65dec37b1a28903da42190b3d5b0e~bkDLvl6DH3114431144epcas5p2H;
	Tue, 10 Mar 2026 19:03:46 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4fVjw15SbNz6B9m6; Tue, 10 Mar
	2026 19:03:45 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260310190345epcas5p3177958f481ce13557a665c6f4223a022~bkDKYREoO0888908889epcas5p30;
	Tue, 10 Mar 2026 19:03:45 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260310190343epsmtip2d2e2e5624a38c4d0b330bd1963c5b029~bkDIu6Uv22357523575epsmtip2U;
	Tue, 10 Mar 2026 19:03:43 +0000 (GMT)
Message-ID: <7a4f9902-d87d-4032-9df0-efa807c6aade@samsung.com>
Date: Wed, 11 Mar 2026 00:33:42 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] xfs: steer allocation using write stream
To: Dave Chinner <dgc@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, jack@suse.cz,
	cem@kernel.org, kbusch@kernel.org, axboe@kernel.dk,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <aa-whgDFL7h8-gIl@dread>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260310190345epcas5p3177958f481ce13557a665c6f4223a022
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260309053434epcas5p308acff894c6735e382c0e5e1e737c9de
References: <20260309052944.156054-1-joshi.k@samsung.com>
	<CGME20260309053434epcas5p308acff894c6735e382c0e5e1e737c9de@epcas5p3.samsung.com>
	<20260309052944.156054-5-joshi.k@samsung.com> <aa-whgDFL7h8-gIl@dread>

On 3/10/2026 11:17 AM, Dave Chinner wrote:
>> When write stream is set on the file, override the default
>> directory-locality heuristic with a new heuristic that maps
>> available AGs into streams.
>>
>> Isolating distinct write streams into dedicated allocation groups helps
>> in reducing the block interleaving of concurrent writers. Keeping these
>> streams spatially separated reduces AGF lock contention and logical file
>> fragmentation.
> a.k.a. the XFS filestreams allocator.

Yes, but there is difference between what I am doing and what is 
present. Let me write that in the end.
> 
> i.e. we already have an allocator that performs this exact locality
> mapping. See xfs_inode_is_filestream() and the allocator code path
> that goes this way:
> 
> xfs_bmap_btalloc()
>    xfs_bmap_btalloc_filestreams()
>      xfs_filestream_select_ag()
> 
> Please integrate this write stream mapping functionality into that
> allocator rather than hacking a new, almost identical allocator
> policy into XFS.
> 
> filestreams currently uses the parent inode number as the stream ID
> and maps that to an AG. It should be relatively trivial to use the
> ip->i_write_stream as the stream ID instead of the parent inode.

Yeah, should be possible. Will try that in V3.

>> If AGs are fewer than write streams, write streams are distributed into
>> available AGs in round robin fashion.
>> If not, available AGs are partitioned into write streams. Since each
>> write stream maps to a partition of multiple contiguous AGs, the inode hash
>> is used to choose the specific AG within the stream partition. This can
>> help with intra-stream concurency when multiple files are being written in
>> a single stream that has 2 or more AGs.
>>
>> Example: 8 Allocation Groups, 4 Streams
>> Partition Size = 2 AGs per Stream
>>
>>     Stream 1 (ID: 1)         Stream 2 (ID: 2)         Streams 3 & 4
>>   +---------+---------+    +---------+---------+    +-------------
>>   |   AG0   |   AG1   |    |   AG2   |   AG3   |    |  AG4...AG7
>>   +---------+---------+    +---------+---------+    +-------------
>>        ^         ^              ^         ^
>>        |         |              |         |
>>        | File B (ino: 101)      | File D (ino: 201)
>>        | 101 % 2 = 1 -> AG 1    | 201 % 2 = 1 -> AG 3
>>        |                        |
>>   File A (ino: 100)        File C (ino: 200)
>>   100 % 2 = 0 -> AG 0      200 % 2 = 0 -> AG 2
>>
>> If AGs can not be evenly distributed among streams, the last stream will
>> absorb the remaining AGs.
> Yeah, this should all be hidden behind xfs_filestream_select_ag()
> when ip->i_write_stream is set....

Added in the TBD list.

>> Note that there are no hard boundaries; this only provides explicit
>> routing hint to xfs allocator so that it can group/isolate files in the way
>> application has decided to group/isolate. We still try to preserve file
>> contiguity, and the full space can be utilized even with a single stream.
> Yes, that's pretty much exactly what the filestreams allocator was
> designed to do. It's a whole lot more dynamic that what you are
> trying to do above and is not limited fixed AGs for streams - as
> soon as an AG is out of space, it will select the AG with the most
> free space for the stream and keep that relationship until that AG
> is out of space.
> 
> IOWs, filestreams does not limit a stream to a fixed number of AGs.
> All it does is keep IO with the same stream ID in the same AG until
> the AG is full and, as much as possible, prevents multiple streams
> from using the same AG.


filestream: 1 filestream == 1AG, at a time. And that can cause AGF lock 
contention on high-concurrency NVMe workloads i.e., when multiple 
threads writing to different files in same filestream.

What I am doing here with new write stream has two aspects:

(a) inter stream concurrency: multiple threads writing to different 
files in different streams are not going to run into AGF lock.

(b) intra stream concurrency: multiple threads writing to different 
files in single stream will also face 'reduced' contention if each 
stream is a collection of AG and we are spreading the load (with inode 
hash). Therefore, each stream is partitioned into a group of AGs.

Also, with filestream we can't do cross-directory grouping, of 
file-level granularity. Write stream is a more explicit model. 
Application decides what files are to be spatially separated/grouped and 
what kind of concurrency buckets should be chosen for its N threads/files.

