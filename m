Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF1128FFFB;
	Fri, 23 Jan 2026 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769177364; cv=none; b=iqt6Hegy1s9s9DDOQusZJnJTnE3Hg4YqKLjifMvGZMH4uOuMbZHrGHGdhEPiABu/b+a/DCDIFU716+vrlZ+X1dvplTOU8vtdZemGHLdF9RrUyBEbegJwD5NySO266rd8XtygU4prs/6KECryYMeyQzoKhM2x6vdS2UqqwXyWTvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769177364; c=relaxed/simple;
	bh=YcylFoh8hgbD8jmyI0bmqlQuyiDsToU2y8mLjIKgTeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ToaBR4WphHWvlvGiLD1sLzk9XLj+8/yBHuCqDrpti5++hYUPvbCcKOomgkQ1AnUNKK8qM+o+vukswbgcT6q/8LGBwdd5Tv0v9FoGw/hj+er3DAfmTXaVnAaKHMGuVi+lZql+cLz8mrswnFuB3QYkSkiwOibTrzwm/SnA2+0aSEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUf2FAa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUf2FAa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7D3C4CEF1;
	Fri, 23 Jan 2026 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769177363;
	bh=YcylFoh8hgbD8jmyI0bmqlQuyiDsToU2y8mLjIKgTeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EUf2FAa/X2irHgYB+8NJxhMnlnRvhDQfbGk2rUlPv6Bts5Pk90m/3w3e8U2LJnEve
	 NNjHt6wlF+tFYGaA+EpheyLq8apvTvmoh14bQ5pDkW4VobR0sq92bw9zfzmqSu96CH
	 4n3aiT/B8JzcR0RWOwY+k94cKSFD9yxnseroFQqNnF5NTYVUrzg5BeM0KrJnOvkmq4
	 0n5uUS+oocqoeCpTanp1O8np1m3L81kfXWnKS4AQog1OpFI+Evls4M9VYyR8fRnKOG
	 3CBAteYCR7c6BL7ayqblwbkMFrHNtLsfsZu7Zg92Oba1Qk68/61eyY4dc3XLWBd36M
	 JsBcr31g9cMZA==
Date: Fri, 23 Jan 2026 07:09:21 -0700
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>, t@kbusch-mbp
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: bounce buffer direct I/O when stable pages are required v2
Message-ID: <aXOBEY63s8JKWB04@kbusch-mbp>
References: <20260119074425.4005867-1-hch@lst.de>
 <CGME20260123121444epcas5p4e729259011e031a28be8379ea3b9b749@epcas5p4.samsung.com>
 <20260123121026.tujkvhxixr6pgz7c@green245.gost>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123121026.tujkvhxixr6pgz7c@green245.gost>

On Fri, Jan 23, 2026 at 05:40:26PM +0530, Anuj Gupta wrote:
> Sequential read
>   | size | zero copy  |  bounce    |   +------+------------+------------+
>   |   4k | 1693MiB/s  | 1245MiB/s  |
>   |  64K | 6518MiB/s  | 4763MiB/s  |
>   |   1M | 6731MiB/s  | 5475MiB/s  |
>   +------+-------------------------+
> For Samsung PM1733:
> 
> Sequential write
>   | size | zero copy  |  bounce    |   +------+------------+------------+
>   |   4k | 155MiB/s   | 153MiB/s   |
>   |  64K | 3899MiB/s  | 3868MiB/s  |
>   |   1M | 4117MiB/s  | 4116MiB/s  |
>   +------+-------------------------+
> 
> Sequential read
>   | size | zero copy  |  bounce    |   +------+------------+------------+
>   |   4k | 602MiB/s   | 244MiB/s  |
>   |  64K | 4613MiB/s  | 2141MiB/s  |
>   |   1M | 5868MiB/s  | 5162MiB/s  |
>   +------+-------------------------+
> 
> [2]
> Write benchmark -
> fio --name=write_new_4k --filename=/mnt/writefile --rw=write --bs=4k --size=20G --ioengine=io_uring --direct=1 --iodepth=16 --numjobs=1 --time_based=1 --runtime=30 --group_reporting
> 
> Read benchmark -
> Prepare the file:
> fio --name=prep_create_prepfile --filename=/mnt/prepfile --rw=write --bs=1M --size=20G --ioengine=io_uring --direct=1 --iodepth=16 --numjobs=1 --group_reporting
> 
> Then run the read workload:
> fio --name=read_4k --filename=/mnt/prepfile --rw=read --bs=4k --size=20G --ioengine=io_uring --direct=1 --iodepth=16 --numjobs=1 --time_based=1 --runtime=30 --group_reporting

For this change, I think it'd be more meaningful to report latency
rather than throughput. Can you try a QD1 workload instead?
