Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B996A364023
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 10:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776853916; cv=none; b=TB0a4Rar+R0Qk+xYDm2069pptSzkFczryjSGKAxCbnHDaIr/7986AvBfHoTURTEd/El4LH5RX/h+QGFt0g0y7lt64NF8mAJkU9jzongGaDPD5aRfNW7PMlwXaWR4O6UoKy69t7fCK2RI6NtpzJ0LvNUunh0OBlR4SjG/gec2vDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776853916; c=relaxed/simple;
	bh=auORzdCjJvvMpVrHWbHvzVmLzuyBkEv09gxaa6XyIu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUZ4KFlzxNx9GOCPqpIyh5W/Uhh8yv6pDOxQzeUCfB4stZTAkCcbD8xXf0xrA/hjGC/Nt+a+A4aaiKSObwfrg3k8zSfY1Qpj3Rfn+L6hQNNhy9IXnNcEGvgxQinRG77yGTfEBjj8ZPEEJFYDGK4VYrTzccIrQdFjxLwYBKGuO+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sfxmFJuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sfxmFJuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18886C2BCF4;
	Wed, 22 Apr 2026 10:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776853916;
	bh=auORzdCjJvvMpVrHWbHvzVmLzuyBkEv09gxaa6XyIu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sfxmFJuy4M8S5WLWKkL53XQQA+V0pLc1t1R2zeJdjQfsdRYrOj+0hmpFGtngTMrRL
	 qzrYpLvvj3PB++gy2/gQfip0hQpw9s1vLq2zESkKWhtcIOz/osMt/C86fa9bOWnUcn
	 SHdKrRvVWud35eUQFH163b6ExKzFy3/x4Jhs8M7McjiFDwza5S/J5srX/OAkxecA3v
	 fKCOC8QOuI/16WeJhUzGi369TbueJJm31W7dUpeIFgwOM1hVpQlAxRmIT06aGS3x9o
	 zMLaQapRdero0kaMf8hsnOQKUBMTw6v43n5CPm+L6fL/0B3TRygiQeG/TMSAGKejd0
	 AJFrS8SGAH5Mg==
Date: Wed, 22 Apr 2026 12:31:52 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: expose the current zonegc required status in
 sysfs
Message-ID: <aeijmOd6zHDQeA7x@ryzen>
References: <20260420135011.624587-4-cassel@kernel.org>
 <20260420135011.624587-6-cassel@kernel.org>
 <20260422060417.GD5391@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422060417.GD5391@lst.de>

On Wed, Apr 22, 2026 at 08:04:17AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 20, 2026 at 03:50:14PM +0200, Niklas Cassel wrote:
> > The current zonegc required status is currently available in
> > /proc/<pid>/mountstats (which contains stats for all mounted zoned XFS
> > filesystems), under "RT GC required:".
> > 
> > Add a sysfs attribute /sys/fs/xfs/<dev>/zoned/zonegc_required for the same.
> > This makes it trivial for monitoring software to read the value, for a
> > specific filesystem, without any complex parsing.
> 
> GC needed is a very complex internal condition, and I don't think
> exposing the current value as a stable ABI is a good idea.

So we have the following options:
1) /sys/fs/xfs/<dev>/zoned/
2) /sys/fs/xfs/<dev>/stats/stats
3) /sys/kernel/debug/xfs/<dev>/


In my mind, debugfs is usually used for sensitive stuff, however, considering
that the information exposed in this patch is exactly the same information as
"GC required:" in /proc/<pid>/mountstats, I assume that the sensitive
argument is not really applicable here.


Like you say, debugfs can also be used in order to avoid exposing the current
value as a stable ABI. However, since the information exposed in this patch
is accessed using the exact same function call: xfs_zoned_need_gc() as
"GC required:" in /proc/<pid>/mountstats, isn't the current value already
exposed as a stable ABI?


Or perhaps I am missing something here, and for some reason, unlike a sysfs
attribute, the information exposed in /proc/<pid>/mountstats is not considered
a stable ABI ?


That said, if you prefer 2) or 3) over 1) for exposing zonegc_required,
please tell me which you prefer, and I can send a V2 with that.


Kind regards,
Niklas
