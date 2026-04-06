Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCE135DA67;
	Mon,  6 Apr 2026 07:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775459345; cv=none; b=aUgWFpBQ5+kD0Zs9wq/+MWp8mtAZz7em/oicxUUK/MBamyGbcaVi0JIkXsVtfH3X+eA9JnrD4jhzZayERrlfU6dDr6igPdETCruygF0v9B8WKnO0AXJH4uqZIpQYULHm/RYjHML+4IpD4OKkc6DrbmI3JFxkK6YtgLOHIY85Sco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775459345; c=relaxed/simple;
	bh=vg3O1tBFFiXWZbchmD3DTAU3fJ4BEGhd6JtMy5W7RgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cX/wevdK5zxfW24jGoNcFGtEZjwl4tI7gPz/QVyCXjIgNBID6Dpn98swh2bXtqVFFtLmlZpjeY1HLzxRN/XD58dDrF2aCyBI4BzoCQ2txpR1Lai/h5e8nHb0PSxYtP43vDz4u4alCKPmNX37StWQXUGMcnTw6n/pKYoNyTVKwvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BufSNhwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BufSNhwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433F7C4CEF7;
	Mon,  6 Apr 2026 07:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775459345;
	bh=vg3O1tBFFiXWZbchmD3DTAU3fJ4BEGhd6JtMy5W7RgE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BufSNhwZ7siUUb8uEFfZz4gbFkYRBug7im1p3CQy5wr3nJVR2dB3sxywLmaYy5BjS
	 Cc6AdY5m414sbKOUKYOa6QZPqzTd2G8dtYjejocx9ebftGqOA5KXVM/KuNJU9I8xVh
	 1tLehpxbSiVGCoIg9WAk3b2Zr192157evoQWCIjlzqT8aoJNgwxLkAhLF65QJio7qY
	 KJZfhFoYbjHw9q4cgI+9jQs6zT1c0XchQEPvOlOdy/+KIocOh7dpMVWTwL6PhXrVzv
	 jj/xnZHFapyHIIYfXBYL+Jii+fuDxd3w0xgjTa2rrqOn1TNa+Ln/q/YgRUyZpIb1sL
	 yOa1GxPBisqNg==
Message-ID: <748f2ce1-c060-4a64-822c-98f54ccf8282@kernel.org>
Date: Mon, 6 Apr 2026 09:09:03 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] xfs: use bio_await in xfs_zone_gc_reset_sync
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260406055728.472919-1-hch@lst.de>
 <20260406055728.472919-5-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260406055728.472919-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/04/06 7:57, Christoph Hellwig wrote:
> Replace the open-coded bio wait logic with the new bio_await helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
