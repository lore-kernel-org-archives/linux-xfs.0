Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E7A1078B
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 08:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQuQt/W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29840C433C7;
	Mon, 18 Dec 2023 08:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702888636;
	bh=vaaxXyDsKdw5SQWufg9ZJBObpsPcCgXBl9X9oNJ6EbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gQuQt/W56tLYR2ccxBDmI2A8/7PKMfWmbtnT3QrJRxNTZ+U1F0pJVqXdLx7NURXuv
	 PsrqrsSbTYsrsduYZvforK9lnpsMQNKLiNFcg6nIioeQe8EkWqEp6w3UCw5hp2Rwb3
	 MgHlWJON2B2NgZWTCFPVp6LReOfhqjOR/3mL4DJV+PWicoN2LsGSgReCnTgegzG0BF
	 CL7gdoFToatnVhF3Lgp39l/G2/A5m1phcYbQv5aZ7qJ0SJhdMwE7C53GwRsLVa88rT
	 tm+ds6JjZi6EYP832aRJdWHCeWKifjxAdtPLDEVu2K0BG+HpfAZ5+tprnh8hKRUHau
	 jyf5cf2yHHPcQ==
Date: Mon, 18 Dec 2023 09:37:11 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/23] libxfs: remove the unused icache_flags member from
 struct libxfs_xinit
Message-ID: <5gtkridlkab4y4gprbq5k3t6xn7spkvm73hq7e7sxtlq74wnde@emzraxlcipzl>
References: <20231211163742.837427-1-hch@lst.de>
 <fuhBetcVDsrihTN_5vYvky49V3YfblUr2D2QIUKH49EHa3ObWUGU4v0U1oFJRQvN8GaTl61uA8WuPopiH9hCfw==@protonmail.internalid>
 <20231211163742.837427-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-2-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:20PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  include/libxfs.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index b28781d19..9b0294cb8 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -124,7 +124,6 @@ typedef struct libxfs_xinit {
>  	int             dfd;            /* data subvolume file descriptor */
>  	int             logfd;          /* log subvolume file descriptor */
>  	int             rtfd;           /* realtime subvolume file descriptor */
> -	int		icache_flags;	/* cache init flags */
>  	int		bcache_flags;	/* cache init flags */
>  } libxfs_init_t;
> 
> --
> 2.39.2
> 
> 
