Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B4C332EBB
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 13:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343431; cv=none; b=BtiYiqSkIhtOTuOI0O5uBNWHeDv26OtMD8KMn+Pg8Xu3y9llkTreOdUcLlx4a5ZInO/N2IYWtslAx05ZVaFzzXr83E3wIMzBkfLr+wnqYaNkwQyS8aT4fbPO/KCgkwUjdu3+RYpc3tzzDhXeBpkK1zF/1vXT14fMhWb6WOF8i6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343431; c=relaxed/simple;
	bh=yUbhz4q8Bk6ad7ykhWaGlMSrczLK4cYYxIxLGl+Ap/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OOWjCCkrfJ1TAwDpoRUjMYbfnQugVS3rDuQ9kTTtlpLjXQezDbGsprMWUfc2o9BkDoV4fQQjhwY2gRcjn+Dr/6hbjbDEqjJONhAGvQULoHudldQclahIbYLYVInEuYVRTomsDe97BbdR5BHqZycLAjaAka3mOyxUVwccBkSaYBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vn+8m5D3; arc=none smtp.client-ip=91.218.175.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vn+8m5D3"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yUbhz4q8Bk6ad7ykhWaGlMSrczLK4cYYxIxLGl+Ap/U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790343427; v=1; x=1790948227;
 b=Vn+8m5D3XbZZbmpKW7i1GL+bvbo5sKSYuE2nPA2GuBqNylNoSfWFPYzhIe36e9OTc/1cu8wH
 ojAoxowslfc5l7IKiugjESin6K+vCIml6X0/DUSsE8DuIy6ZOEphUFKFcpb5RgIK3c9drm4l7Tu
 T1oBvIFQUn5SUs7kHN44bO1A=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 5d53d689c26fed9d;
	Fri, 25 Sep 2026 13:37:07 +0000
X-Mizu-Trace-ID: 5d53d689c26fed9d
X-Migadu-Flow: FLOW_OUT
Message-ID: <69579dae-285d-472c-ba69-4279e5170502@linux.dev>
Date: Fri, 25 Sep 2026 14:37:06 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/9] block: fail a short atomic pin in
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
References: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
 <20260923-blkdev-fixes-v5-5-89e60d66eb38@columbia.edu>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260923-blkdev-fixes-v5-5-89e60d66eb38@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 00:56, Tal Zussman wrote:
> On a partial page pin, __blkdev_direct_IO_simple() and
> __blkdev_direct_IO_async() submit what was pinned with REQ_ATOMIC set
> and leave the rest to the buffered fallback, tearing an IOCB_ATOMIC
> write.
> 
> This can be triggered deterministically. A 16K pwritev2(RWF_ATOMIC)
> whose last page is PROT_NONE, on a scsi_debug device with atomic_wr=1,
> completes short with only three of the four pages written, violating
> RWF_ATOMIC semantics.

I don't mean to load more work, but a blktests case for this would be 
great. I am consider doing it if you are too busy.

Thanks!
