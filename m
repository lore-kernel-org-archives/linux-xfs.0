Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9132F3BADBD
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 12:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774873144; cv=none; b=NXnXij7PwJ7eBKIePmbuJB10JFfELMt6Y1uGAwc3MxhTh/ynmkBL+Hr4sVZU8XHpKN8rQCoAhKxRc9AcEqsr/IMx2y+QWUgGDIc2mwaVl2BZL6PdVvW8C68A9XwFVoWbaTaLZfpOPWPH3ikZxS8xCxrzIgPeUZb0HqksDnjw378=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774873144; c=relaxed/simple;
	bh=/wMBZ0HuWgPox6Xc3ZFB9RPGXS5mjUcSjvSjLNyBeYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVe3KXqJpBeK5Yd5EblzFh9vmrKoy+nEGsnmzSqwrhfRVesFJqsHT/PAv6fw8zwzHE8zYRvcH8hKJB480PvX7JpLq+cVbFOO7Udl8vVoOL+BytGWDJCn8k/4+WLH40TcvTIEQKiukJS1ZZEONyzVWdyLOOTgVXdKo2czfWV3AoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QPV+Vjdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QPV+Vjdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D805C4CEF7;
	Mon, 30 Mar 2026 12:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774873144;
	bh=/wMBZ0HuWgPox6Xc3ZFB9RPGXS5mjUcSjvSjLNyBeYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QPV+VjdlIUFTmVGu7hCQx/+TO6LZc9pdlnuYkd9j1SPnWa5VQqRCXmwZZaKgRT1Va
	 4KYjW2/+Mtgwns6JiP4755SYpwA24pM3K9Ow6Kou88c0SivQZ3cNrtzGghpSOAnXgy
	 aZ5xNfRQK8/mUvcRnG71JsInI9VfvZRdrqAy3eTjGPljhxYSi+LM30zhpTkqSUNi+Q
	 /c5sxWsOuPgp2451pwUffPxutyZzjzxgOMKtAd+3WjH1yRacnRr3SPRODYMWx1nEN8
	 FkiaMxK5lMojDVWBLAP4zKQ3t0+OdWh/8SJYV3L22A2Gk5HskPZF7/3fomtexT30TH
	 lqD6H8XxPjPKA==
Date: Mon, 30 Mar 2026 14:19:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: add a separate tracepoint for stealing an open
 zone for GC
Message-ID: <acpqK_w64MCgEhNT@nidhogg.toxiclabs.cc>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054533.3856339-3-hch@lst.de>

On Mon, Mar 30, 2026 at 07:44:12AM +0200, Christoph Hellwig wrote:
> The case where we have to reuse an already open zone warrants a different
> trace point vs the normal opening of a GC zone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_trace.h   | 1 +
>  fs/xfs/xfs_zone_gc.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 433f84252119..c1aa15973e74 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -394,6 +394,7 @@ DEFINE_ZONE_EVENT(xfs_zone_full);
>  DEFINE_ZONE_EVENT(xfs_zone_opened);
>  DEFINE_ZONE_EVENT(xfs_zone_reset);
>  DEFINE_ZONE_EVENT(xfs_zone_gc_target_opened);
> +DEFINE_ZONE_EVENT(xfs_zone_gc_target_stolen);
>  
>  TRACE_EVENT(xfs_zone_free_blocks,
>  	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno,
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index f076f66c5d57..273c496c2f1c 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -543,7 +543,7 @@ xfs_zone_gc_steal_open(
>  		return -EIO;
>  	}
>  
> -	trace_xfs_zone_gc_target_opened(found->oz_rtg);
> +	trace_xfs_zone_gc_target_stolen(found->oz_rtg);
>  	found->oz_is_gc = true;
>  	list_del_init(&found->oz_entry);
>  	zi->zi_nr_open_zones--;
> -- 
> 2.47.3
> 
> 
