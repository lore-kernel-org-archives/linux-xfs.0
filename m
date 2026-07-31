Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740733749F5
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 08:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485767; cv=none; b=lQ5DCeZogYSgoukQLK/GsTCYJZ3qO6lwmor4qV+b+WmPEFtvrOvdf5tjHkK9/f4wUFXNAaP1sRwYqd2U+NsIU2jIEVpeK88vTUlrOy7TbVqPUKdSDNVfncuENZwBmuTMDbQsoiY55pPuXDmsxnZcskIy1eV4Ky1DoFLBTM23qqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485767; c=relaxed/simple;
	bh=LEGCFb+NElwuY3sTf2zJ//Qtom6ZMlFLd44MD8RZ83E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=NoYBdx8v+lQJk02lgaV7M00PguEa4beLkVuxVYzkaFY2sqdx5QkVic21Gnmh7L+NhPv+eHiXbQMoyMAwOn+BU4pojmZOC6URlPhzbxjFn1BrcuC5X2/cW+N51Kf5RJYdIQuGcWG5lJVVQ6f5Vx/7qPcWnUx40na/j9bjO4pUBt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IUprD2T2; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IUprD2T2"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260731081553epoutp01ac42fc878dcb52cc961db8aa4028941c~HUdU4QOyR2227822278epoutp01T
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 08:15:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260731081553epoutp01ac42fc878dcb52cc961db8aa4028941c~HUdU4QOyR2227822278epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785485753;
	bh=igCw0tl9fFz2FsduIL+NR+krbiu+Jm5zFdOTxS/v3h8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=IUprD2T2ZSo7RaVkjXYwp8ON6a6hp/6y5f23qF30bLDBMTBf4XBZmBf+/Ygrq+SF3
	 eT0ENz+nKr4UlvsGvTRONDQBNY5Ug+sjMsX8gTm4QF/zjFl8i1+ULmT4tmzm98UDAU
	 vz/UB3DQLPB6JJSlYOuNXXOxoZp+SP/jguDO78SY=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260731081552epcas5p4b76823bb0e23008f96a1a924c5c5f3d9~HUdUXAjer1602916029epcas5p4y;
	Fri, 31 Jul 2026 08:15:52 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.88]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hBJmR66Y0z2SSKY; Fri, 31 Jul
	2026 08:15:51 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260731081551epcas5p174f7d23ac92db47b6786cd6c046a086d~HUdS1JQ-b0068600686epcas5p1L;
	Fri, 31 Jul 2026 08:15:51 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260731081549epsmtip2dcc8941b67878e07e55eadec0e4fa9f5~HUdQzy1_U0681106811epsmtip2f;
	Fri, 31 Jul 2026 08:15:48 +0000 (GMT)
Message-ID: <6bb9e510-577d-4730-b0e1-c3f95c95ff1e@samsung.com>
Date: Fri, 31 Jul 2026 13:45:48 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260730172211.GF3556460@frogsfrogsfrogs>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260731081551epcas5p174f7d23ac92db47b6786cd6c046a086d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com>
	<20260717125538.508925-2-joshi.k@samsung.com>
	<20260721030338.GU7380@frogsfrogsfrogs>
	<71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com>
	<20260730172211.GF3556460@frogsfrogsfrogs>

On 7/30/2026 10:52 PM, Darrick J. Wong wrote:
> On Thu, Jul 30, 2026 at 08:22:51PM +0530, Kanchan Joshi wrote:
>> On 7/21/2026 8:33 AM, Darrick J. Wong wrote:
>>> On Fri, Jul 17, 2026 at 06:25:33PM +0530, Kanchan Joshi wrote:
>>>> From: Anuj Gupta<anuj20.g@samsung.com>
>>>>
>>>> Wire up the userspace interface for write stream management via four
>>>> ioctls:
>>>>
>>>>     FS_IOC_WRITE_STREAM_GET_MAX  query the max streams supported
>>>>     FS_IOC_WRITE_STREAM_OPEN     open a stream id, returns a stream fd
>>>>     FS_IOC_WRITE_STREAM_SET      attach the stream fd to an open file
>>>>     FS_IOC_WRITE_STREAM_GET      query the stream id value set on a file
>>>>
>>>> Application should query the available streams by using
>>>> FS_IOC_WRITE_STREAM_GET_MAX. If returned value is N, valid stream id for
>>>> the file are 1 to N.
>>>>
>>>> Application calls FS_IOC_WRITE_STREAM_OPEN to get fd for a stream-id.
>>>> By default, kernel picks an available stream-id and returns the fd for
>>>> it. The flag FS_WRITE_STREAM_OPEN_EXACT can be used to request a
>>>> specific stream_id. This is useful if application cares about keeping a
>>>> stable stream-id-to-spatial-isolation-bucket mapping across restarts.
>>> Hmm.  If FS_IOC_WRITE_STREAM_OPEN returns an fd that represents an open
>>> stream id, then why does STREAM_SET below take a pointer to a signed
>>> s32?
>> Not a pointer, that s32 is to pass the stream fd.
> Oh, but that third argument to ioctl()/is/ supposed to be a pointer to
> some data.  From ioctl(2):
> 
> "The third argument is an untyped pointer to memory.  It's traditionally
> char  *argp (from the days before void * was valid C), and will be so
> named for this discussion."
> 
> You can also see this reflected in the discussion of the R/W/WR variants
> of _IO:
> https://docs.kernel.org/driver-api/ioctl.html
> 
> "[data_type] may be a pointer to data to be passed into the kernel
> (_IOW), out of the kernel (_IOR), or both (_IOWR)"
> 
> Granted your kernel code can treat that argp as an integer and not a
> __user pointer if it wants to, but that goes against most ioctl
> implementations.  Further, subsystems that marshal ioctl information for
> passing through to another layer (e.g. fuse) assume that the third
> argument is a pointer and that it can copy sizeof(data_type) bytes at
> that address in and out of the kernel as part of marshalling.

Next version will refactor all ioctls to use pointer to struct.

>>> And why does STREAM_GET take a pointer to a u32?
>> This also is a scalar value and not a pointer. The returned stream-id is
>> a u32.
>>
>>> IOWs it'd be much easier to distinguish these things if the ioctls took
>>> pointers to structs instead of u32/s32 pointers directly.
>> Maybe IOCTL naming is the source of confusion, because we introduced
>> stream-fds alongside stream-ids. More on this below.
>>> Also it's a little weird that STREAM_SET associates an open file with a
>>> stream fd, but STREAM_GET returns the stream*id* (not the fd)
>>> associated with an open file.
>> The confusion stems from keeping symmetric names for different
>> operations. Let me explain the intent and propose revised names below.
>>
>> Christoph's idea was to use FD for a write-stream so that it remains
>> exclusive to the application and unrelated applications don't collide.
>>
>> So, in this version, write-stream ids are implemented as independent
>> resource:
>> - To set a file's write-stream ID to X, the app must first obtain the fd
>> for stream X.
>> - That stream/fd will be unavailable if some other application has
>> already opened it.
>> - If applications gets the stream fd, it can use that to set stream id
>> for multiple files.
>> - It can close the stream-fd and that does not change anything for the
>> file resource (i.e, its inode continue to carry the stream-id value that
>> was set).
>>
>> Christoph - does this match?
>>
>> Here are the revised names (suggestions?):
>>
>> 1. FS_IOC_QUERY_MAX_WRITE_STREAM_IDS		_IOR('f', 135, __u32)
>>
>> Returns (in __u32) number of supported stream-ids.
>>
>> 2. FS_IOC_OPEN_WRITE_STREAM_ID			_IOWR('f', 136, struct
>> fs_write_stream_open)
>>
>> Open the specific write-stream id (or any available one via a flag) and
>> return its FD. This gives right to use that stream-id.
>>
>> And the following manage setting/clearing/querying write-stream on the file:
>>
>> 3. FS_IOC_SET_FILE_WRITE_STREAM_BY_FD		_IOW('f', 137, __s32)
>>
>> Sets a file's write-stream value (in inode) to whatever the stream fd
>> (passed as __s32) carries. So one never sets scalar values into a file
>> directly.
>>
>> 4. FS_IOC_QUERY_FILE_WRITE_STREAM_ID		_IOR('f', 138, __u32)
>>
>> Queries the write-stream value (__u32) currently assigned to the file
>> (its inode).
>>
>> 5. FS_IOC_CLEAR_FILE_WRITE_STREAM_ID		_IO('f', 139)
>>
>> To clear (zeroing) the write-stream value on the file's inode.
>>
>>
>>> Can you extract the stream id from the fd that FS_IOC_WRITE_STREAM_OPEN
>>> returns?
>> Can be done by implementing the ioctl handler for that stream fd, but
>> did not feel the need of it. Do you see the utility? If yes, name can
>> potentially be FS_IOC_QUERY_WRITE_STREAM_ID_FROM_FD.
> Why not reuse FS_IOC_QUERY_FILE_WRITE_STREAM_ID?

That's for the file (with data), it requires regular file-fd. It's not 
working on the stream-fd. You asked for knowing the stream-id associated 
to stream-fd.
