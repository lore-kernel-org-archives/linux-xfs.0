Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0D83AA4E9;
	Wed, 19 Aug 2026 07:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123301; cv=none; b=QP5ByrGsSkzATZBzJF7AL6e2lddgKm/s+XP46Z2Ch7prBWxd02n58AQ/DMhbtDQ68DRwvzdqkOllH9EjlnM5fia2HxSNYOF7657cbzdgPE41kE1Cf8kLi9OgS7detEQguQNnUI3nEAvuUrGXSFVXABjNMukW30pPd70Tq2TJFcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123301; c=relaxed/simple;
	bh=1OV1MaFH7ZHPHP/08CUliSRxAFQ8ONRPF2JMZftSqwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I65UuBZ+hyVmo/RP1OZC0xJcElSn/RpvzRPEunG0B+jsvwShekCs5wVZ+WBgL3m8pFOIjlm+tBrmukmcPoID3+ADLEQLRXYSPTtPjD3OH8pSc8gD7ogj8pBpUwRJM8Tiuf/i9e1/LRhg0H8KAEoU0/TCMEvvIBsvxAiQb9a1UE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 27F6D68C7B; Wed, 19 Aug 2026 09:08:15 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:08:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, brauner@kernel.org, hch@lst.de,
	dgc@kernel.org, jack@suse.cz, cem@kernel.org, axboe@kernel.dk,
	kbusch@kernel.org, ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
Message-ID: <20260819070814.GB1541@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com> <20260717125538.508925-2-joshi.k@samsung.com> <20260721030338.GU7380@frogsfrogsfrogs> <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 30, 2026 at 08:22:51PM +0530, Kanchan Joshi wrote:
> Christoph's idea was to use FD for a write-stream so that it remains 
> exclusive to the application and unrelated applications don't collide.
> 
> So, in this version, write-stream ids are implemented as independent 
> resource:
> - To set a file's write-stream ID to X, the app must first obtain the fd 
> for stream X.
> - That stream/fd will be unavailable if some other application has 
> already opened it.
> - If applications gets the stream fd, it can use that to set stream id 
> for multiple files.
> - It can close the stream-fd and that does not change anything for the 
> file resource (i.e, its inode continue to carry the stream-id value that 
> was set).
> 
> Christoph - does this match?

Almost.  I didn't really think of your last point there.  If the
inodes keeps using it when it is dropped that breaks the model a
bit, but revoking it might make things a bit ugly and slow.  Urgg.

> Here are the revised names (suggestions?):
> 
> 1. FS_IOC_QUERY_MAX_WRITE_STREAM_IDS		_IOR('f', 135, __u32)
> 
> Returns (in __u32) number of supported stream-ids.
> 
> 2. FS_IOC_OPEN_WRITE_STREAM_ID			_IOWR('f', 136, struct 
> fs_write_stream_open)
> 
> Open the specific write-stream id (or any available one via a flag) and 
> return its FD. This gives right to use that stream-id.

maybe s/OPEN/ALLOC(ATA)/ ?

> And the following manage setting/clearing/querying write-stream on the file:
> 
> 3. FS_IOC_SET_FILE_WRITE_STREAM_BY_FD		_IOW('f', 137, __s32)
> 
> Sets a file's write-stream value (in inode) to whatever the stream fd 
> (passed as __s32) carries. So one never sets scalar values into a file 
> directly.

I'd drop the _BY_FD.

> 
> 4. FS_IOC_QUERY_FILE_WRITE_STREAM_ID		_IOR('f', 138, __u32)
> 
> Queries the write-stream value (__u32) currently assigned to the file 
> (its inode).

I'm not sure exposing the actual ID to the user space application is a
that good idea, same for passing in the wanted ID when allocating.
That leaks a lot of internal details.

