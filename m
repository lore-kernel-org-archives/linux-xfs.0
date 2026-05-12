Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B775747ECE2;
	Tue, 12 May 2026 07:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778571674; cv=none; b=JDPRYa5bdtCrmARhpSiC3kOJGROCgry1GN+LCdgGZU9YSlVJi2w8X/9HIQ+byVn3HZxfQjSA7zIjxEtSXhO5xQTEKwQSonwdMYXlAnCWcwaZe+eThpMFzEt267LQXlPTmOSEn48nWd2lBL9+DRmeHx2hWbKTgefWUEqnbuqbSZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778571674; c=relaxed/simple;
	bh=uHgramlR2UsacSFL8Nsu5N5X+GjYLWlhcrhT4BezNyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QJzVP9tRXTen1F5ISYncIRmYHoqwQ0rCsTN0GZSqwrMykVNip2g/HJo8BUgKy8HrpRNHXU/jDtAfDnIDReggMkL9bMJUNtktVCdfHv+1omqwXZR2MOVoWKIXts/UJGtEPV19ha3qpE2VVY5HMZVI0tRw2x8tLV3n7HYpiQ0YZoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9sk2Vp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9sk2Vp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C56C2BCB0;
	Tue, 12 May 2026 07:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571674;
	bh=uHgramlR2UsacSFL8Nsu5N5X+GjYLWlhcrhT4BezNyc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O9sk2Vp/6GejyLBdgb0tqXl6XI8Ee217W/WOaFreEgpDwIvDrdcYs5L+UvVMSDEtr
	 VQS8spmPo1GjuFg8lOqv6BgC/h2D4BVJV7320DvGlZ0uQw9DMip1t5wzR+QZ+PZqvX
	 4euKkWF/7dSzn05IMr0YYsxImiQ5qB0q+sVlxBJaaa2seN5mPMPKL9DHtjsuYB7qn5
	 VPCiIaEbt797FILjsA9YdVx/DZCl4+YtNpBHarBuSuyC5IfT8VPCxxOsG44wp00wG0
	 nipgyIPW9XvlM+VpiwqXL2eRV69/I7/NkoZhH5IsZAm++5jfr2M3jbXO5AbKZHbT+w
	 9wE+XnHRqTRmA==
Message-ID: <ec8ae080-56de-490d-a1a3-e646e4a2d629@kernel.org>
Date: Tue, 12 May 2026 16:41:08 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] swap: move swap_info_struct to mm/swap.h
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-13-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 14:35, Christoph Hellwig wrote:
> swap_info_struct is now internal to the MM subsystem, so remove it from
> the public header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
