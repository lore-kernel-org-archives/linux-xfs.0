Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E34131F9A7
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 08:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789462728; cv=none; b=XM/wc8tPmhoEpIob64jxj4AGAPzoaPhUc4QZAkBKGTqm+Fw3x+ajop18DYmtQqsOcnBgezjGDuF6zodgCwMTJM8jab0EPmBPbzaz/JKxczGqCxJJECK4Jm8ayAM2Er7Qze0xm32T1iDtmEoO/+dWrvASRXKpuuiTEHS6Ut+vwBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789462728; c=relaxed/simple;
	bh=KlWMWYx/0i1PIluwlSLjyGrDV2+hZo3P4A6fDuq02To=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UHA1+q+TvLAUJc+CuetpS+YDe1hgccLcGZdyfMGYZbilVftFpVAiBW3sm52vipJSC0YgTOZFpZ/NSkvy/Sd8EiczWcIqOzJteS68I63wrveV78XnD/TZ1mEZEgY6RX2On4TjbS/p7OMJKB6cuyHm/Hn0huy8VIGT/LlQB+Ktz/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIMJQYDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIMJQYDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438841F000FF;
	Tue, 15 Sep 2026 08:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789462726;
	bh=dcNFAgetmvoB/ExvPgo7TAb1acAMYDDY6UL/wpYcYEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NIMJQYDpyaYSIiQAezOhlYBhFkYxSvnL43kXThnoA3ROdKZqLSrfrYpbE9YQ3FXpZ
	 4K0cX5014cwYhAcdMUNct8cpqxFJi0thMwQsGolSOYbMwT77UWu0A8XB7/p40hx8RP
	 FifZ6MCcsk14osNCPoYATjvBW3lHw0hO9ahCOsFldLh759xj8cr3CA1uS7RGhPEY5O
	 /q1GLT1jkyGk7A0kLZAtjWAe/hCkRiJa4/SGOo5qkvMuFVkxN7xtKtE47LfHdwpACn
	 pWAlod1BdB/SHT9AKs0/EBn9wi3NH8uFpu5nqGplhN72ij/SnrsAxwkx/zcHHzmrzi
	 AaiktBZ0XeHOQ==
Date: Tue, 15 Sep 2026 10:58:42 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Brian Foster <bfoster@redhat.com>, 
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH RESEND 0/2] xfs: fix NOFS state corruption in btree split
 worker
Message-ID: <aqkIetDJZa56Qvx_@nidhogg.toxiclabs.cc>
References: <20260911104227.2028941-1-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911104227.2028941-1-wangkefeng.wang@huawei.com>

On Fri, Sep 11, 2026 at 06:42:25PM +0800, Kefeng Wang wrote:
> xfs_trans_set_context() overwrites tp->t_pflags, dropping the
> caller's NOFS protection. Replace it with local
> memalloc_nofs_save()/restore() to fix it, also drop the obsolete
> kswapd flag inheritance, which simplifying the fix.
> 
> Note:
> - rebased on v7.3-rc2
> - Add ACK/RB
> - split the patches, suggested by Christoph Hellwig[1]

> [1] https://lore.kernel.org/linux-mm/aqOp035i41XIrDXg@infradead.org/

Can you please give me some more context on why are you resending it? I
received an email from Andrew that he had pulled this patch already from
the previous series.
You were Cc'ed on the email so I'm assuming you didn't see it?

> 
> Kefeng Wang (2):
>   xfs: remove dead kswapd flag inheritance from btree split worker
>   xfs: fix NOFS state corruption in btree split worker
> 
>  fs/xfs/libxfs/xfs_btree.c | 22 ++++++----------------
>  fs/xfs/xfs_platform.h     |  4 ----
>  2 files changed, 6 insertions(+), 20 deletions(-)
> 
> -- 
> 2.55.0
