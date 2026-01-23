Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F54341AC0;
	Fri, 23 Jan 2026 08:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769158728; cv=none; b=MUEkcgTpf83fus6u8zs7HJL8KB2Mzyc6R5mEcUQ5GdRHWO3ZLGDjERgh+8HqTZKIftU/rHgnn7zoMZKTcafEhF+P+Vxz/tWHVgxcNMztL30f4IqgMUT/CT/tzsil3+a/4coLpECzBd/vueo+1f8kUc4HK7Npao7Hx5GHsch8i1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769158728; c=relaxed/simple;
	bh=S46zZhYUynee6Ht/PF/JzHVrx1QV2QE+nQGKCu7eYxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=geGfaP7jLKd7THldZag9s7HRs1YvIB2l+e1yZghMjbNHeF7Dq1MDLhVJNCJjEThTgO/ElSlac/hSQiqTafSwZhrK75C9566zHWVioDNUSppymmOSqlQzOR1FZPyfHLYUCyvbJJfQVLmooZhfaGJnaIFsQp3OT+EqbJAQhi63MrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9v06MoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9v06MoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECCBC2BCB8;
	Fri, 23 Jan 2026 08:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158727;
	bh=S46zZhYUynee6Ht/PF/JzHVrx1QV2QE+nQGKCu7eYxw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J9v06MoA4PnHn0TC/mInCIuTZmMn7ZgzxmjNhMuX8e0gkEeShxBmtQEcOxrprcEaf
	 np3kemv1HQrecrmiRs6POU3EEtcmNW+zCmoaL80nFGiSIP/lyGkEqkpm1ChgQZk0In
	 rG7/H0VrlkoWVX9niXAHul8DjePjgxGfSXS3e7zfyieFmPkJgpXrDCgpTHxhEdPLeV
	 OqvA/tgfv4HmYg2kVLwTI6caMB0GyPJ14WhvcaToUL2ptqZU6GzsPuVppDzecDOW0k
	 rvRHUHA2+unWmB5T8YXwtiqUdFrZIp0UceyvJMSHeOZWZUQVFq+uTsbA2mdMpufWC2
	 B0vO5v1qotQrQ==
Message-ID: <d2c4d23c-e3eb-4264-b687-86a76414da8d@kernel.org>
Date: Fri, 23 Jan 2026 19:58:42 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/14] iomap: share code between iomap_dio_bio_end_io and
 iomap_finish_ioend_direct
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-10-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> Refactor the two per-bio completion handlers to share common code using
> a new helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
