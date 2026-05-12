Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8526A357CE3;
	Tue, 12 May 2026 07:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778570345; cv=none; b=jeMvLtA0HJl7xuVpwlndgobQQL5w5udT/Sy+2oQqGVWA6U5myytTyLLxj2iv34OwSeQc2jvaBs+J5bNGMguFM01C4vGd2cAjoroQztE152xYbQ2SynJaSGgCjJjuQwlA8NMxaybQTpGms6QpIjcBniZeHQmPimevrj3vtspjX6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778570345; c=relaxed/simple;
	bh=d5SXioBPZwBUI6+SvSlauBL+rdn+SyAPRvBRa2uxfM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EjcTnj7n2IN+tK5pcq3/ofEcka4ZEY889LEA0Ozo8KW8Kh+UOawZiorJFAQjUgSpnTvGxH1CCTJt55J4q9c99CkdU7Ovbp4C9qnziyEEGudRvFzEmji7QkMlwPvWEwIfnC0heqY0jNY3LPgYxzDPUy3T0I8qFBNaJDPd4EWsqBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rzpOZbhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rzpOZbhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9397DC2BCB0;
	Tue, 12 May 2026 07:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778570344;
	bh=d5SXioBPZwBUI6+SvSlauBL+rdn+SyAPRvBRa2uxfM8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rzpOZbhShhQy53uHWdXI2cpciYpCJ920LLOVTxryHf9v8OKxdXcXv9PcbtWsHhvyX
	 AYph9XZFDOqDQwZsiKpkaAi5Tj4jgjyto4NZ8GZ1d1lrpRbMH6BEl1FmQDWqHh9aKt
	 wR9hASUhwEfR/x7muZ/iQU+ZY4Unac7EpcjljUYFspFcTRdnBtE6xUk0dzsWRcdpwK
	 N2xzyLJkDls7Vy9tVuzq9XXM2918R97/uSORI1dlwtkQ+yKrj8aK6cWW6NBweJ5PnN
	 m3/udQQng+yYpR0EBFqLsp20DKAl82altPlAL8TvQYjfsAOHgqXK+IqxQKVepy1L7g
	 Pst3cIKtZvjWQ==
Message-ID: <48752f6c-39ad-4409-9d41-646922a668cc@kernel.org>
Date: Tue, 12 May 2026 16:18:58 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/12] swap: cleanup setup_swap_extents
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
 <20260512053625.2950900-6-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 14:35, Christoph Hellwig wrote:
> Reflow setup_swap_extents so that the flag checking is not conditional on
> a swap_activate method.  This is currently a no-op because the swapoff
> code still checks the presence of a swap_deactivate method, but it
> simplifies adding a new check, and also makes the SWP_ACTIVATED flag
> more consistent.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
