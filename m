Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB0141D625
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 14:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423188; cv=none; b=J3R8jWvMcM+dELu1ceD+2aUrtBBNuuimCgv2x+IQN6bWa1I4oYnBA05Wj+M2v3G84f92m0eWW9mXtTgjLw6zAURxaTzPiHWqiRcnbpvz2r23CCHkSdEaJv+YO9YySjKPux8w9oXJ6b0Ppzdo/vgYEkBSnCNfJBP94HOR4f0kmCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423188; c=relaxed/simple;
	bh=JFvzplvbus/2kYURLL1As5wrffPNUN1jD/Gn1VXQyfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ArFWiMZRkZqjr5ikduMetvt9q3mbmcrHO+RGfJQN3qIh2P8x4KsWB6g5bV1ZKzgbFu6BqTQOW2zzDlQuNwpiPe8mqY8x/wC6C/D8HmSsp8bMdJa3FHxYbm2PHzcPeJ4zEzhTfKlnh66cc4EC8N7GRdS0deKS3Jtr374cWMIxGDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QbrPcklU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QbrPcklU"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260730145256epoutp012404869f893c6cb3a88ece77b14f4e4a~HGOtvNTnd1082910829epoutp01D
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 14:52:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260730145256epoutp012404869f893c6cb3a88ece77b14f4e4a~HGOtvNTnd1082910829epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785423176;
	bh=4xilCRaoznc9RobxFg1o+gyR5JVXgQvjMd852A/HQH4=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=QbrPcklUlggA3I2zBiY5rerioThQTxm7vLm+OT9Y61cuzjPu2dgWspEz73wDowtxP
	 fqeaPUVLkGqcz1kBAP5GWbYtcxcE3YxlMvqPCpnswMiNsbb0tAb+CIcNlQ4M/bEeoT
	 bbHP/8kUzQtb4D1C0n+ipcyKB+41h6i6y1uiTF0w=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260730145255epcas5p191c9aef2712848a1834dc86e4444f9c9~HGOs8MzRf2930629306epcas5p10;
	Thu, 30 Jul 2026 14:52:55 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4h9sd26j6tz2SSKX; Thu, 30 Jul
	2026 14:52:54 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260730145254epcas5p1af021ebbff5009fe362522f33a622711~HGOroDPqy2929729297epcas5p17;
	Thu, 30 Jul 2026 14:52:54 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260730145252epsmtip2cfb198552ce68aa76ff4c69eaed27064~HGOp4weFf1740717407epsmtip22;
	Thu, 30 Jul 2026 14:52:52 +0000 (GMT)
Message-ID: <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com>
Date: Thu, 30 Jul 2026 20:22:51 +0530
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
In-Reply-To: <20260721030338.GU7380@frogsfrogsfrogs>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260730145254epcas5p1af021ebbff5009fe362522f33a622711
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

On 7/21/2026 8:33 AM, Darrick J. Wong wrote:
> On Fri, Jul 17, 2026 at 06:25:33PM +0530, Kanchan Joshi wrote:
>> From: Anuj Gupta<anuj20.g@samsung.com>
>>
>> Wire up the userspace interface for write stream management via four
>> ioctls:
>>
>>    FS_IOC_WRITE_STREAM_GET_MAX  query the max streams supported
>>    FS_IOC_WRITE_STREAM_OPEN     open a stream id, returns a stream fd
>>    FS_IOC_WRITE_STREAM_SET      attach the stream fd to an open file
>>    FS_IOC_WRITE_STREAM_GET      query the stream id value set on a file
>>
>> Application should query the available streams by using
>> FS_IOC_WRITE_STREAM_GET_MAX. If returned value is N, valid stream id for
>> the file are 1 to N.
>>
>> Application calls FS_IOC_WRITE_STREAM_OPEN to get fd for a stream-id.
>> By default, kernel picks an available stream-id and returns the fd for
>> it. The flag FS_WRITE_STREAM_OPEN_EXACT can be used to request a
>> specific stream_id. This is useful if application cares about keeping a
>> stable stream-id-to-spatial-isolation-bucket mapping across restarts.
> Hmm.  If FS_IOC_WRITE_STREAM_OPEN returns an fd that represents an open
> stream id, then why does STREAM_SET below take a pointer to a signed
> s32? 

Not a pointer, that s32 is to pass the stream fd.

> And why does STREAM_GET take a pointer to a u32?

This also is a scalar value and not a pointer. The returned stream-id is 
a u32.

> IOWs it'd be much easier to distinguish these things if the ioctls took
> pointers to structs instead of u32/s32 pointers directly.

Maybe IOCTL naming is the source of confusion, because we introduced 
stream-fds alongside stream-ids. More on this below.
> Also it's a little weird that STREAM_SET associates an open file with a
> stream fd, but STREAM_GET returns the stream*id* (not the fd)
> associated with an open file.

The confusion stems from keeping symmetric names for different 
operations. Let me explain the intent and propose revised names below.

Christoph's idea was to use FD for a write-stream so that it remains 
exclusive to the application and unrelated applications don't collide.

So, in this version, write-stream ids are implemented as independent 
resource:
- To set a file's write-stream ID to X, the app must first obtain the fd 
for stream X.
- That stream/fd will be unavailable if some other application has 
already opened it.
- If applications gets the stream fd, it can use that to set stream id 
for multiple files.
- It can close the stream-fd and that does not change anything for the 
file resource (i.e, its inode continue to carry the stream-id value that 
was set).

Christoph - does this match?

Here are the revised names (suggestions?):

1. FS_IOC_QUERY_MAX_WRITE_STREAM_IDS		_IOR('f', 135, __u32)

Returns (in __u32) number of supported stream-ids.

2. FS_IOC_OPEN_WRITE_STREAM_ID			_IOWR('f', 136, struct 
fs_write_stream_open)

Open the specific write-stream id (or any available one via a flag) and 
return its FD. This gives right to use that stream-id.

And the following manage setting/clearing/querying write-stream on the file:

3. FS_IOC_SET_FILE_WRITE_STREAM_BY_FD		_IOW('f', 137, __s32)

Sets a file's write-stream value (in inode) to whatever the stream fd 
(passed as __s32) carries. So one never sets scalar values into a file 
directly.

4. FS_IOC_QUERY_FILE_WRITE_STREAM_ID		_IOR('f', 138, __u32)

Queries the write-stream value (__u32) currently assigned to the file 
(its inode).

5. FS_IOC_CLEAR_FILE_WRITE_STREAM_ID		_IO('f', 139)

To clear (zeroing) the write-stream value on the file's inode.


> Can you extract the stream id from the fd that FS_IOC_WRITE_STREAM_OPEN
> returns?

Can be done by implementing the ioctl handler for that stream fd, but 
did not feel the need of it. Do you see the utility? If yes, name can 
potentially be FS_IOC_QUERY_WRITE_STREAM_ID_FROM_FD.
