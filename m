Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC798379C4C;
	Tue, 12 May 2026 07:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778571098; cv=none; b=r9FjT7OfHX0A8F8PNvbOpuGlU/2R9BkyAg7OvNR0Lk3eKZV1bL79z3eMgFq26DUwGo9hKXoz+PD1/35T0nRaihilZrfasWTv8xUamxFh9hNAYda1UMNuK99q0Pg3C7J5ny42J5ImqB6ET2R0/+uN4q+yPsu6igzrlWNNSpedvMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778571098; c=relaxed/simple;
	bh=aowACr2p+6rSwpChoE3EadCBPCPgSF8E8psfVlXgrO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZGRUnj0oW/K34ozcptsWy4Y6mkzU5dm1rVCtN91Q1TCT7a7DLflY0KuFfARFbaHrnMpntRQIoacsxrR8V/G67kQCZu9HoCQ1xXPEhiHub3s199ve0BRQNulNb6tM7g2/pgoaMxgHIugIzHeYpx9AEDUsUZUt0q2tnz3D7LpAnr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAiB8tFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAiB8tFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3FBC2BCB0;
	Tue, 12 May 2026 07:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571097;
	bh=aowACr2p+6rSwpChoE3EadCBPCPgSF8E8psfVlXgrO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gAiB8tFXXabdPEPYhwa+Fm9YFauBqF8VyymvDAAZmCoURFlvvPu6j0sz4KZ788AbA
	 /Gilye7p4N5y9ZjRoSrFQ6s+fsXJaBGyl0DIg6af6KSVL52pIRTR4QBciuGyf4cE11
	 H2ZLNauyCJw7sUXtWJPUlSY8C+xQSZQ+BLvRl3T6nGZyl3bJmm+w8TMzbUXKvLQq/d
	 867M4z2uhgR5hdCFZzD5aMDreoTDa9a/idDEIGy972SC8TvrPs9rAgOOqsDOp6CIPd
	 afxA9vC7uam6EfUpw1RehUPquNGm1COUq7xNl82JZuOUABbJMJoXu3JE4ABKO33E1I
	 Huh7jhSU82cPw==
Message-ID: <88cdaac7-05a9-41a7-bae4-443db26b7082@kernel.org>
Date: Tue, 12 May 2026 16:31:31 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] swap,iomap: simplify iomap_swapfile_iter
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
 <20260512053625.2950900-9-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 14:35, Christoph Hellwig wrote:
> add_swap_extent already coalesces multiple extents, no need to duplicate
> that in the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
