Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C97377AAE
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785161854; cv=none; b=kw/tScAkLYeiS3o9p7u9iNIEyF7rc6Xk+CPmf7jvFTT4OYfkrCUm+jsJdgyUs1fX97amSruNZvoCCbBKmwhTfjHVysRpOlh5KhsvQhcdgiD8tqAQRoLpmJ01n1Wl9QpBmoYZ5IOakNFiRJjbmRBUyYC9kuEUpNxeR0Jm052C3dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785161854; c=relaxed/simple;
	bh=YfdmKDMoYPEZCHasO3vceo4NYJMFc6xtTkJj5m+qSN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=dYiMdZRtabHhFWuNJ2gGEKe93t/z3qgXJs6lnKQRrN/AnlbPHUxr6Mr8GAII85PgAPsOdFNZvw004wKlSL2QNo6RVvC5mSDGD5tgrP+2xScGLLp2E7GswDCjn3Fi9w/waLfmos+K1SCvPTw5XW0ee2Hj93UKhz5KVN8PEV9h1hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZuZNbcm6; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZuZNbcm6"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260727141731epoutp043d34cf2e3f08a56357b061b2263a17fe~GKz7PDq612578625786epoutp04Q
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:17:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260727141731epoutp043d34cf2e3f08a56357b061b2263a17fe~GKz7PDq612578625786epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785161851;
	bh=tIV12OnGWLcStnM19ejURF2KKLRf0IVkVUo2Fa2yrVQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ZuZNbcm63KqLfrmEb6BCnPqNb6QdRqRPjuK2lJJ1mvsnZcNlH8B5bJdWyjTuSHpOB
	 B7DSNALiVRtbNMF5zXQ5iP0zv2STORmtp7gCdMT1mJNzC9uwozZlrOtlVLpTklLcjT
	 oNqg8Iknc8FZ+eXtTDOkfnve1fZx+ojm24k8mDZ0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260727141730epcas5p1a7fb7f3241f1eecfdf4e80d458570225~GKz6otSif2417524175epcas5p1U;
	Mon, 27 Jul 2026 14:17:30 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4h80zY70Rxz3hhT4; Mon, 27 Jul
	2026 14:17:29 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260727141729epcas5p3a9c500cd217bfa88587bb828203fb4f7~GKz5n-4ob1231912319epcas5p35;
	Mon, 27 Jul 2026 14:17:29 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260727141728epsmtip16cef9fbed94036b6928d79032eb51509~GKz4at9h-2086520865epsmtip1C;
	Mon, 27 Jul 2026 14:17:27 +0000 (GMT)
Message-ID: <1d08c3f3-29d6-42db-973b-1c544b436e15@samsung.com>
Date: Mon, 27 Jul 2026 19:47:27 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/22] iomap: better read bounce buffering support
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
	Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Carlos
	Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <20260723145000.116419-13-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260727141729epcas5p3a9c500cd217bfa88587bb828203fb4f7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260723145102epcas5p1b832a57cc20b821145a4814f29d4fee5
References: <20260723145000.116419-1-hch@lst.de>
	<CGME20260723145102epcas5p1b832a57cc20b821145a4814f29d4fee5@epcas5p1.samsung.com>
	<20260723145000.116419-13-hch@lst.de>

On 7/23/2026 8:19 PM, Christoph Hellwig wrote:
> +void iomap_bounce_read(struct iomap_ioend *orig_ioend, unsigned int minsize,
> +		void (*submit_ioend)(struct iomap_ioend *ioend))
> +{
> +	struct inode *inode = orig_ioend->io_inode;
> +	struct bio *orig_bio = &orig_ioend->io_bio;
> +	loff_t file_offset = orig_ioend->io_offset;
> +	sector_t sector = orig_ioend->io_sector;
> +	size_t total_len = round_up(orig_ioend->io_size, minsize);
> +
> +	WARN_ON_ONCE(!(orig_ioend->io_flags & IOMAP_IOEND_DIRECT));
> +
> +	do {
> +		struct iomap_ioend *ioend;
> +		struct bio *bio;
> +		int error;
> +
> +		bio = bio_alloc_bioset(orig_bio->bi_bdev,
> +				min(total_len / minsize, BIO_MAX_VECS),
> +				orig_bio->bi_opf, GFP_KERNEL,
> +				&iomap_ioend_split_bioset);

thw new bio inherits REQ_POLLED via orig_bio->bi_opf but iocb->private 
still points to the never submitted orig_bio; hanging polled reads.
Maybe mask REQ_POLLED from the bounce bio?
