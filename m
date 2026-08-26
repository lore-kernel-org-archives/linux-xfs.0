Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303E13D7D8C
	for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2026 10:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740984; cv=none; b=dIVJYy6nKyFjc2IKKyCWBG6L0clBYyEBexbrOoI98lTuwhBkBG+P0bVQFWItxM5jeX0F/d4J2tzwcZ4igoChSb/T1mvaB4srONw4F9GB/MB9EzsPn2XR59YPkxVI4uZIOzSe7J3VWiUwxGpRkYy4GjT6u/j+sPYWwLfICEviJT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740984; c=relaxed/simple;
	bh=V9tSR8GlKo14ujIhXUB9kjhVK5L9ZbZ8aUd27vDHVes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=rmdvEtMWDyuoMb+q5FeOffJFypjzaRXsSaBg1BOZvRcTLdr8vcKEsxPXqMXQGYSgMe9TmwKgkK8ZPeFFDG0AAfitJeCkVjL+6j7fD+zvf/KAcqTT55dOTFVB5pClJaNKpyMCf8Z9KRiuhgMGZMOwkR3EFxRGPzFGPnlaEI+XVIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HExBa7vU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HExBa7vU"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260826104256epoutp0181a40acef555528fe7c91d11c87812bb~PVPJZz_kD1362813628epoutp01-
	for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2026 10:42:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260826104256epoutp0181a40acef555528fe7c91d11c87812bb~PVPJZz_kD1362813628epoutp01-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787740976;
	bh=b7S5hM7p1oZO94IHXtrATGeyfj9R7PKi9SWBT1dOY5E=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=HExBa7vUp9qghRwHmU3qqFIBw81gMpe8GwX0oI0iXqm6rDtU940lSZlii0vzzxTBG
	 7/OXvV+v+XlR3xBL9p6XshQVqX5/PW/D4PwaDRoGJxMPihVLts4sg9XTmxd+enMBO+
	 iv6Ah95hJAoK9JQVfWRoeA9Q+e/IqLnjRL9GHw+E=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260826104256epcas5p2bdd7d258c9e9c5551fe9a2db656a933f~PVPI6kYuE0322103221epcas5p24;
	Wed, 26 Aug 2026 10:42:56 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.92]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hVLp75Gppz2SSKX; Wed, 26 Aug
	2026 10:42:55 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260826104255epcas5p373ce91fb30a5a8b6fa5d780d9c1640b1~PVPH1Pyjc0982309823epcas5p3D;
	Wed, 26 Aug 2026 10:42:55 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260826104253epsmtip14cb04dd143758ac8f5f4a88621b3f755~PVPF-MBfK1269512695epsmtip1R;
	Wed, 26 Aug 2026 10:42:53 +0000 (GMT)
Message-ID: <c6064b06-9e34-4790-80ef-c76333c2a11a@samsung.com>
Date: Wed, 26 Aug 2026 16:12:52 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, brauner@kernel.org,
	dgc@kernel.org, jack@suse.cz, cem@kernel.org, axboe@kernel.dk,
	kbusch@kernel.org, ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260825065533.GA24808@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260826104255epcas5p373ce91fb30a5a8b6fa5d780d9c1640b1
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
	<20260819070814.GB1541@lst.de>
	<076db8e7-6c6e-4d91-b442-1471ad7a5c27@samsung.com>
	<20260825065533.GA24808@lst.de>

On 8/25/2026 12:25 PM, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 12:00:46PM +0530, Kanchan Joshi wrote:
>>>> - That stream/fd will be unavailable if some other application has
>>>> already opened it.
>>>> - If applications gets the stream fd, it can use that to set stream id
>>>> for multiple files.
>>>> - It can close the stream-fd and that does not change anything for the
>>>> file resource (i.e, its inode continue to carry the stream-id value that
>>>> was set).
>>>>
>>>> Christoph - does this match?
>>>
>>> Almost.  I didn't really think of your last point there.  If the
>>> inodes keeps using it when it is dropped that breaks the model a
>>> bit, but revoking it might make things a bit ugly and slow.  Urgg.
>>
>> I think it is consistent to the model that says stream fd is a distinct
>> resource and it is a necessary lease/license to set the particular
>> stream(-id) across files.
>> If the stream-fd is held, that stream-id remains exclusive to the
>> application.
>> Closing means, applications is fine to release the license and
>> underlying stream-id becomes available to other users.
> 
> But that also means it can be reallocated to other users, which
> now mix data.  I guess the answer might be "don't do this", but
> I'd love to have interfaces that aren't easy to abuse.  OTOH
> implementing this might be quite an overhead.
> 
>>>> 4. FS_IOC_QUERY_FILE_WRITE_STREAM_ID		_IOR('f', 138, __u32)
>>>>
>>>> Queries the write-stream value (__u32) currently assigned to the file
>>>> (its inode).
>>>
>>> I'm not sure exposing the actual ID to the user space application is a
>>> that good idea,
>>
>> But don't we need a way to know if stream id/value is set on a file or
>> not? This ioctl is more about observability; GET equivalent of SET.
>> Also write stream value is not going to be there if/when in-core inode
>> gets evicted.
> 
> Yes, but the application needs to basically set it after open
> anyway.  Keeping any kind of state over a file descriptor that
> has been closed doesn't make much sense.
> 
>>> same for passing in the wanted ID when allocating.
>>
>> Can drop OPEN_EXACT flag if you prefer that.
>> But this was for the case if application restarted and wanted its new
>> data to go into the bucket where it was previously writing.
> 
> But that assumes that the bucket hasn't otherwise been reused, which
> might not be the case.
> 
>>> That leaks a lot of internal details.
>>
>> I viewed stream-id similar to how we view file-name. Application can
>> list file names, but need the fd to do operations on that file.
>> So, I could not understand internal details part. Could you explain? We
>> have FIEMAP and unprivileged XFS_IOC_FSGEOMETRY already expose the
>> placement of the file.
> 
> There are a lot of operations on filenames.. XFS_IOC_FSGEOMETRY and
> are in a different register than normal file operations.  If we
> want to expose the mapped stream IDs I'd also rather have them in
> a different register than the usual APIs.
> 

So based on the above discussion, do you see this as the right interface?

1. FS_IOC_WRITE_STREAM_GET_MAX : query max write streams
2. FS_IOC_WRITE_STREAM_ALLOC: allocate any write stream (if available) 
and return stream fd. No flag whatsoever.
3. FS_IOC_WRITE_STREAM_SET: set write stream into a file using stream-fd
