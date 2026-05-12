Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5E368D73;
	Tue, 12 May 2026 07:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778570514; cv=none; b=QiGidzJNIbj2atDtQU06z30+7yyC5hNZkSeCuXiuvsW7SojVymPRosFVZzUT8JtpSw3+1P/35W0weuQUCZNN4CQKoesklOChWVhYUE/CPbOmua88BTzEYMxtNbc47pyP5wIVb2Pr+ZFHPtl0fsDu1Si1yJvFDyjrle85BykYn0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778570514; c=relaxed/simple;
	bh=Xq9+eEnZyp37k7qXEaOdw0f0Snu5QZQtlvjD1+MYRu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RfxmrbloaMw6v5C+To3ERIGqHbBla+E80Xub1TbWYajfFfBGodg+MTGIV4MzWJemYp0lzjpXIGPBvRZE4xKvZaoSlqi2PaE3fyFIIhmSpOKvBTSQZphhCCJD/ELFTe9v7wHaJoXfW0nMr9bANJrUHda/ATa9/GBmWbryM7SxYtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HpnCduju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HpnCduju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F004C2BCB8;
	Tue, 12 May 2026 07:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778570514;
	bh=Xq9+eEnZyp37k7qXEaOdw0f0Snu5QZQtlvjD1+MYRu4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HpnCdujuSs0wcUGzR0lQTqIJ531e+c+TnGuoVAcjOUCcPqOGeNyWvcWsmYWSE3jxq
	 mF9lVHlk8lkWBf0HidM6p3rU5VPTfQGMU6Po421XDufDTQigS16W5xwg2srgvuTKs/
	 KXvnNJ/6OzLv9KM2ZGR1T2oxhsd+sSbbrbqvxmSKTihw1tl6w2uJS9X1KEKKjpadNN
	 4nuq5EdnivRdW3Qm2oZhiQCb3YBa3DVhaw2PQmZBwhcU/a2lCEilJYilNG/IlNeDSI
	 ro2YyO3EhmNbLo3hYTXPpvz/utb7tHvG+kyLD+U0Yk9qQMEGGIMuLHEz7RaJRZq/gj
	 LeQ/tiiv2eo8A==
Message-ID: <217f91d9-4d5f-47a6-ad20-0404968b8e08@kernel.org>
Date: Tue, 12 May 2026 16:21:47 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] swap,block: limit swap file size to device size
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
 <20260512053625.2950900-8-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 14:35, Christoph Hellwig wrote:
> Don't blindly pass the value from the swap header to swap_add_extent,
> but instead the device size rounded down to page granularity.  This
> activated the sanity checking in the core code that catches a too large
> value in the swap header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me, though this maybe could be folded in the previous patch ?

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
