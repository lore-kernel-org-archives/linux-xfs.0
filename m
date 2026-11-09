Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794260552;
	b=hNaHmKdJ7XxbWZc4WhKDXT/Rjpsr3amBWREcsTw8Km17u2dK7vbYi7FEdR2FC1/ve1MO
	 Nq4qLN2h6tmNq5H3HuxDQrsASHtin3B4LweezblENYdslcrvc40kbthpNY4OCNrohLGU0
	 UJemV7w0TBFsRj8y+2Kw7oCUxbiZcQBsHNAnxfQkBO1bypQ30JrP6veyAZzc8P0YpxJyt
	 BLlmA0Lx/8d5xnnkWzB6MmLC3C/QOuq/SLgzwAELu3y5wXy/SRXJPKj6wuiezpbLdLvwu
	 M7JO9JzKuVRT5arEkL2Ax8j6llMN9Dm6bpif66c7Ok42B+ZpARA0gLLkxSfcIobUVvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794260552;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=j/0luRaQjk8DAv+qNQCj7UHNNttcpKdxunwjJE8v/UU=;
	b=xXHAFOnbZ4r6XWUV+C/0ooerHjQu+x/L2bXA9W76EgYA99qtIZBg1KkMs/lOBWMVBc8R
	 SndGLyBoXC2Jhx7S30hv5WgLlJNBHyVcQcdRuZ4kiI3x5xqjBbyPbM7QfZg5cwU2rh14u
	 HPPMezdr7HYaVu9pRsahtvzIGEkcKicVHEbpo7LEAocVjPVudLvY7QqtaEWdSIvAAOV39
	 WptiMPT6kX2H+oqdUzjWyZIIMUGsiY33Dq8qb3i6GEXLJK24lOVnz7yxhXXqBtK8B5Ew6
	 KOBBe+2o+wVqKWxAhlAJL3qhYtaNWxs9EqZ2CZPYM8eUVwrMwrNjlgCZmvZQcFy9J5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="h/7WjUIW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC46606A321
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 21:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h/7WjUIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC2D1F0089F;
	Mon,  9 Nov 2026 21:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794260551;
	bh=j/0luRaQjk8DAv+qNQCj7UHNNttcpKdxunwjJE8v/UU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/7WjUIWgvbxOLtFmNnpfAmuHwe19TBzfR8AeG6VPeFXz38ERWMrP6D07Z6NHpx7T
	 fXpi+4h1KbnT05QLWOzAc492sszdLrSWXuBMp89kIXMxTKZTc/WAcoqQqWIfNZ3VKn
	 eUo9n8zqmOLL1HjrpXsmqXiabla5k7aJc1iglQBlyR0VbZz2gn6VwyW4wuAT4/Mu17
	 Q9zxmpYrQtA5oCfNDKYfsbVCzJz0JVrKK7ZLsvgzA490nCkdwOiK5i/ZlxaEisBJME
	 VPUnZ6RqKhFOY8wBNGOoZ5tKm9vYDaRMezfuksXGktsyZVjOXAClFKw+8vG4VwsCNP
	 0WZkKcb+xy+zg==
Date: Tue, 10 Nov 2026 08:42:23 +1100
From: Dave Chinner <dgc@kernel.org>
To: Guikun Yang <yangguikun19@qq.com>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: reject a continuation op with no buffered region in
 log
Message-ID: <avI-P53bBM9ZSkFe@dread>
References: <tencent_C48E4451F8984465A7BA7D338D003925980A@qq.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_C48E4451F8984465A7BA7D338D003925980A@qq.com>

On Tue, Nov 10, 2026 at 08:00:00PM +0800, Guikun Yang wrote:
> xlog_recover_add_to_cont_trans() takes the tail item of the transaction
> and indexes ri_buf[ri_cnt - 1] without checking that the item has any
> region buffered:
> 
> 	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
> 			  ri_list);
> 	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
> 
> An item created by xlog_recover_add_item() has ri_cnt == 0 and
> ri_buf == NULL - the transaction header itself is copied into
> trans->r_theader, not into the item - so this evaluates to NULL[-1].
> xlog_recovery_process_trans() dispatches to this function for any op
> whose header carries XLOG_WAS_CONT_TRANS, and nothing on the way
> checks that flag sequence against the item state; the only related
> assertion in the recovery code is XFS_DEBUG-only.
> 
> A crafted dirty log with a valid transaction header followed by an op
> header with XLOG_WAS_CONT_TRANS therefore faults at mount time on a
> stock kernel, without any sanitizer enabled:
> 
>   BUG: unable to handle page fault for address: fffffffffffffff0
>   #PF: supervisor read access in kernel mode
>   Oops: 0000 [#1] SMP
>   RIP: xlog_recover_add_to_cont_trans+0xf9/0x460
>    xlog_recovery_process_trans
>    xlog_recover_process_ophdr
>    xlog_recover_process_data
>    xlog_recover_process
>    xlog_do_recovery_pass
> 
> Note that reaching it does not require an actual split region: a single
> continuation op right after the transaction header is enough, because
> the dispatcher never checks that the previous region had a buffer
> attached.
> 
> Treat it as log corruption and fail recovery, matching the other
> -EFSCORRUPTED paths in this file.
> 
> Reported-by: Guikun Yang <yangguikun19@qq.com>
> Signed-off-by: Guikun Yang <yangguikun19@qq.com>

NACK, again, for the same reasons.

-- 
Dave Chinner
dgc@kernel.org
