Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD17352017
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791880809; cv=none; b=uD65zJ/dHE/NmipRxKlUb8pz7SMjFWXDA4j3jTuJ3jgVJ7n/j46vYeollhgiR6h1SIiQeE8rH+AWLPYHtvKZP/fcXJmjcDc+xgUj2uZN1k0TviO2XvdKSdtx4fq4yFRhRvXVFfcTncgb27rGY9QbNHi8QkwIneBFCDH/oPTmNlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791880809; c=relaxed/simple;
	bh=O2VyeBUpyQZ7N4gxSQ/4x9ZYwCTMTmWwc5NCJmvVYgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=td6qArpJ6t25ByqJHEnVd6Hkc2hN0czsmu0ZsJyAE+GHVSlo2SVUZJ8RxYQ214SEuf6/ztxzQ29W7ZTsKuflUPjp9GNtU/gYBnwM6ueGXU2beJsEtQ/6fNH4JSRSD8oFbLQbL56fUPHbgZi6TwLAMiIo7K4E1eSlJMDmPUrU4UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZzHENh9u; arc=none smtp.client-ip=91.218.175.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZzHENh9u"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=O2VyeBUpyQZ7N4gxSQ/4x9ZYwCTMTmWwc5NCJmvVYgw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791880804; v=1; x=1792485604;
 b=ZzHENh9uxR9TBh1yQhpMGm73IbFbV7DFY3UWWrcJ3lMHpI2ErQc2OCdHCuwEuRVbJ0Gf6V09
 k2OoVFxJFTQ8BRMwltYoRHICet1eWY3qnzdiVnAXnnspwbmcRjD8Du5edjiueO3x0ftDfzVZSYA
 PWp/wDxg+hCYG8tBEb+K/VNU=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 8b2403653d9a654d;
	Tue, 13 Oct 2026 08:40:02 +0000
X-Mizu-Trace-ID: 8b2403653d9a654d
X-Migadu-Flow: FLOW_OUT
Message-ID: <82978d5c-3e08-48e9-bf0a-7913e1cd0507@linux.dev>
Date: Tue, 13 Oct 2026 09:40:01 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/9] block: fail a short atomic pin in
 bio_iov_iter_get_pages()
To: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Hannes Reinecke <hare@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261009-blkdev-fixes-v6-0-307939c387df@columbia.edu>
 <20261009-blkdev-fixes-v6-5-307939c387df@columbia.edu>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20261009-blkdev-fixes-v6-5-307939c387df@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/26 17:50, Tal Zussman wrote:
> On a partial page pin, __blkdev_direct_IO_simple() and
> __blkdev_direct_IO_async() submit what was pinned with REQ_ATOMIC set
> and leave the rest to the buffered fallback, tearing an IOCB_ATOMIC
> write.
> 
> This can be triggered deterministically. A 16K pwritev2(RWF_ATOMIC)
> whose last page is PROT_NONE, on a scsi_debug device with atomic_wr=1,
> completes short with only three of the four pages written, violating
> RWF_ATOMIC semantics.
> 
> Make bio_iov_iter_get_pages() release the pins and return -EINVAL when
> a REQ_ATOMIC bio doesn't cover the whole iterator, since an atomic
> write is submitted as a single bio and a short one would be torn. That
> covers iomap as well, where a partially unmapped buffer could trip the
> WARN_ON_ONCE() in iomap_dio_bio_iter_one(). The async block device path
> currently sets REQ_ATOMIC after pinning, so set it before, and move
> REQ_NOWAIT along with it.
> 
> Fixes: caf336f81b3a ("block: Add fops atomic write support")
> Reported-by: Sashiko<sashiko-bot@kernel.org>
> Link:https://sashiko.dev/#/patchset/20260802-blkdev-fixes-v1-0- 
> a82fc549fd74%40columbia.edu?part=2
> Assisted-by:Claude:claude-fable-5
> Reviewed-by: John Garry<john.garry@linux.dev>
> Reviewed-by: Hannes Reinecke<hare@kernel.org>
> Signed-off-by: Tal Zussman<tz2294@columbia.edu>

I think that you can now remove the REQ_ATOMIC check after the 
iomap_dio_bio_iter_one() -> bio_iov_iter_get_pages() call also; however, 
considering the trees, it's better to wait until 7.4-rc1 is released.

Thanks,
John
