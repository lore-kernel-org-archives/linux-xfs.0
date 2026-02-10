Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E1022B8AB;
	Tue, 10 Feb 2026 15:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737940; cv=none; b=tTFg0zCFrdKF7fKvhszK5R8orKGRiQM9loo3OKaTfbo860XVKBwgC5Av5j7qBjQEwtziof3y4nahlnW7nFjZqE7bzVkHDhEqQSPSP35umReKZJCZlK33UUl0JiyO8WqO7e0WXqI4VWj9p6wz5oIEvBEGFMpPPhOeudCRI/JoRW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737940; c=relaxed/simple;
	bh=uFcjjkA3WFiZqFMy3mxET9pV3Rhqx7NQjS+2SqxHlZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qvn/xpIfGnXwDPdB7P1WlEL1PlGoa3iAhjM/WfmVyOxiVVvJuFyNnV7PjkncyIuJB3R7JkKajZLTxEW/0L9kkhD9tHq4MJkn/zvC7/o9QtXn1QW3V7eTkGIachb4aE6pt08y319OY9BPI7ErGQvdNkGRMhAYXpae2Qg2KuKtO9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E3B9468CFE; Tue, 10 Feb 2026 16:38:54 +0100 (CET)
Date: Tue, 10 Feb 2026 16:38:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <20260210153854.GA2484@lst.de>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com> <20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster> <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com> <aXN3EtxKFXX8DEbl@bfoster> <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com> <20260206062527.GA25841@lst.de> <5b11145d-15e2-485c-a978-365b58854371@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b11145d-15e2-485c-a978-365b58854371@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 09, 2026 at 09:24:49PM +0530, Kundan Kumar wrote:
> - Create a bounded number of bdi wb contexts at mount time (capped,
> e.g. ≤ agcount).

Yeah.  And then optimally map them to CPU cores, similar to the
blk-mq cpumap.

> - Store a per-inode stream/shard id (no per-folio state).

Yes.

> - Assign the stream id once and use it to select the wb context for
> writeback.

Yes.

> - In the delalloc allocator, bias AG selection from the stream id by
> partitioning AG space into per-stream "bands" and rotating the start
> AG within that band; fall back to the existing allocator when
> allocation can't be satisfied.

Yes.

We might also need something that falls back to less helpers if
the free space is distributed unevently, but probably not for the
first prototype.

