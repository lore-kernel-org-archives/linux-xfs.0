Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789423E49E2
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 06:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787553059; cv=none; b=tq0edsfF8FTZNmMteBNfUaEOJ48aMZX/sh8pOX6vKc47A9L4psWkKSKFXVj/Vk+hYMeWuzt4RUrDjYpo7+acBoHyivrU8ni/sra0EMbZRrbm4JV9slfuEZqcI1XqvAJxoPBb7ptgJXWYc+dgbR8bLh941JjOLvXBU5bl+OrwXA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787553059; c=relaxed/simple;
	bh=K+IYTtofw2pmaKZFzqJXikVzycHfs/qx5Aut57MsMzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=e4339xEII8wVrZ6LYFRBZIPDSJx1lIVs54EtEEWsnkQ0WUMtggKSKTdDP5kyZfSyOy15/c5m46wOTxqRkZs8pLwoCxNowqohwFT31QFeanyxnIREdgmQhq4W481AeV9lm9d28brVwzP+J4bnuKlu6inWKvgejMrKMHjFYnK+klw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Yt/qX8Du; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Yt/qX8Du"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260824063054epoutp043bf17a1fd3bdee43a632c0adc3392650~OqggqEkml2891328913epoutp04W
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 06:30:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260824063054epoutp043bf17a1fd3bdee43a632c0adc3392650~OqggqEkml2891328913epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787553054;
	bh=l9ewL7Vj/+p0l9PBJ+KUTT26wzlxtPIKe9UQzgg8mPM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Yt/qX8Dur57r4cpC53xiQSYhSqbKlPdBEZTQ0vQU9wS8J9sm505jtf5KJO/000peo
	 L1reEYE8xKZ6lpd5JFJpDpEQAr0g85/TS8jph1ASW1c68QBZHKiDTyaMDG0cx2/3D9
	 SKFC4CTEd97PVzfBM8K3dnNxpsbJsOwn/SvqPOWg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260824063051epcas5p4dae4dc9bf4b75eff3a7c11b7344c085c~Oqgd0tAvO3238232382epcas5p4G;
	Mon, 24 Aug 2026 06:30:51 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hT1JB0MrNz6B9m4; Mon, 24 Aug
	2026 06:30:50 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260824063049epcas5p1058d0ae3078a8468e455052136c16d91~OqgcZoIVy0699106991epcas5p1o;
	Mon, 24 Aug 2026 06:30:49 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260824063047epsmtip2bf0e54344178bbad0c86a273542d5388~OqganKjN_2928529285epsmtip28;
	Mon, 24 Aug 2026 06:30:47 +0000 (GMT)
Message-ID: <076db8e7-6c6e-4d91-b442-1471ad7a5c27@samsung.com>
Date: Mon, 24 Aug 2026 12:00:46 +0530
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
In-Reply-To: <20260819070814.GB1541@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260824063049epcas5p1058d0ae3078a8468e455052136c16d91
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

On 8/19/2026 12:38 PM, Christoph Hellwig wrote:
> On Thu, Jul 30, 2026 at 08:22:51PM +0530, Kanchan Joshi wrote:
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
> 
> Almost.  I didn't really think of your last point there.  If the
> inodes keeps using it when it is dropped that breaks the model a
> bit, but revoking it might make things a bit ugly and slow.  Urgg.

I think it is consistent to the model that says stream fd is a distinct 
resource and it is a necessary lease/license to set the particular 
stream(-id) across files.
If the stream-fd is held, that stream-id remains exclusive to the 
application.
Closing means, applications is fine to release the license and 
underlying stream-id becomes available to other users.
Application may use stream-fd license and set corresponding write-stream 
id into N files. We don't need to track those N files and negate the 
effect (clear stream-id in those N inodes) when the license was released.

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
> 
> maybe s/OPEN/ALLOC(ATA)/ ?

Yes.
If we are doing away with stream-id, ALLOC is better.
If we retain (as this version does), OPEN may still be better.

>> And the following manage setting/clearing/querying write-stream on the file:
>>
>> 3. FS_IOC_SET_FILE_WRITE_STREAM_BY_FD		_IOW('f', 137, __s32)
>>
>> Sets a file's write-stream value (in inode) to whatever the stream fd
>> (passed as __s32) carries. So one never sets scalar values into a file
>> directly.
> 
> I'd drop the _BY_FD.

Sure, I will drop.

That said, we may need a way to clear the stream-id of a file.
We don't need stream-fd for that. An explicit flag here can convey that 
intent.

>>
>> 4. FS_IOC_QUERY_FILE_WRITE_STREAM_ID		_IOR('f', 138, __u32)
>>
>> Queries the write-stream value (__u32) currently assigned to the file
>> (its inode).
> 
> I'm not sure exposing the actual ID to the user space application is a
> that good idea, 

But don't we need a way to know if stream id/value is set on a file or 
not? This ioctl is more about observability; GET equivalent of SET.
Also write stream value is not going to be there if/when in-core inode 
gets evicted.

> same for passing in the wanted ID when allocating.

Can drop OPEN_EXACT flag if you prefer that.
But this was for the case if application restarted and wanted its new 
data to go into the bucket where it was previously writing.
> That leaks a lot of internal details.

I viewed stream-id similar to how we view file-name. Application can 
list file names, but need the fd to do operations on that file.
So, I could not understand internal details part. Could you explain? We 
have FIEMAP and unprivileged XFS_IOC_FSGEOMETRY already expose the 
placement of the file.
