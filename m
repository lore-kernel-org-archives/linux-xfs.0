Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC07480341;
	Tue, 21 Jul 2026 10:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630708; cv=none; b=tfH0aI/8Wqu87aRazeKChP7zMmAN+tbXULiM+R6sepnidXG80d5tNIhHPgAy6gK/jLHF5397erRO0RY0HVyk1s2cT23TWmx1RhhonPndI6r2+xFupv+omK9mmLImHxUDa/BED3V4YzjaSxcDKIXtfjdr2/gnFqTqFjPagy8Zr/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630708; c=relaxed/simple;
	bh=EKDHNaDopp5fhs8uZquxf0cx5mtkXhjeH9fl7LvhNos=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ECcXtgV9M9+kIDpcTSmCG/Xf2l7nnTFVmk0ONsAdXP+jTCs9ui0+sO48Gi4uppDCz7XGM5nPZHXCohWRW3mhjpku3a3d+Jp6/y0lYnw10Z7HQLWv6s+LPa0XQQoZYum1sHVaqe95kM+RDWG+VzrZvD3xWLVWFwRW6diA0FI5b8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hpGiG75Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hpGiG75Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433511F00ADE;
	Tue, 21 Jul 2026 10:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630695;
	bh=TF1FROrz+/3Nrrqz7OrrWgxhCu3TGd4/hCWiBmCcAI0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=hpGiG75Y2P3lYU+E0uHclfq4UTAIQv+ejuFOPlxwDgY2mkHfnUSCHd/L2TzgLwks9
	 ahErt27hpNwpwp5PQup2Lh9KwVRotSrZ/63BJwOdMsPeVYIw/FLC62LhhpMuTEDSF7
	 4w/ITxynU+msvNw0JDMMEDhBsgFi/4Efz9Pjmc2oF3ctmt9YpvcHbq/56DslPe9Ayp
	 syVcRLXxPwhAt9EBTIkdwoTOmm8dmVvWXgSIL/aPnYr4MgJApprIZSjp5VKJwRkuLk
	 UfepIir9s7wYnpPjIA3Ra2CZHAYUTvl4mgTxwuDofMhLNcc6KiFKY55Q7WWEZvatP2
	 CorOcuE6nEWYQ==
From: Carlos Maiolino <cem@kernel.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260719151124.3514077-1-yun.zhou@windriver.com>
References: <20260719151124.3514077-1-yun.zhou@windriver.com>
Subject: Re: [PATCH] xfs: handle NULL b_addr in xfs_buf_free
Message-Id: <178463069397.324722.16521599214171804128.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:53 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Sun, 19 Jul 2026 23:11:24 +0800, Yun Zhou wrote:
> When xfs_buf_alloc_backing_mem() fails, xfs_buf_free() is called with
> bp->b_addr still NULL.  The code falls through to the folio_put path
> which calls virt_to_folio(NULL), dereferencing an invalid address and
> causing a kernel crash.
> 
>  Call Trace:
>   xfs_buf_free+0x25f/0x510
>   xfs_buf_alloc+0xc98/0x19b0
>   xfs_buf_find_insert+0x55/0x14d0
>   xfs_buf_get_map+0x122b/0x17c0
>   xfbtree_init_leaf_block+0x11c/0x4a0
>   xfbtree_init+0x1bb/0x460
>   xrep_rmap_setup_scan+0x100/0x1f0
>   xrep_rmapbt+0x41/0xc0
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: handle NULL b_addr in xfs_buf_free
      commit: 2ba9288085f15d2eec21cdafe438a9d03f44737a

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

