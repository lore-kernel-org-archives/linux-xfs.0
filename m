Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CDD7762B
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gfqf5u4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56200C433F1;
	Fri, 12 Jan 2024 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705078365;
	bh=aKdFLwosKkoidfBtw5/r2ZASWXjUgZH9A7+2Rhaq97g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gfqf5u4xI6Pmj630M2HpZVQQTQ3eYUIcWprgeUyan0G2PM1ldyaV/LFcVUaAvFEuq
	 KdY1EzMjzlJHX+Oal6UBF/E4xKDe1Ky4T6i2N0q6PUbov8M+dmTCALN0xUyB3qbs36
	 JmpyuczH/cyjTx79eorIwn+c6CPX8969SkVDFihqWN0NRnxtqdwveK8u/XM7+8rqvU
	 zFFN9AU2tmSuZuKkkRe/EVf+biKdNt7BgfjOlVqGTNmVvaWpD/YJoZwZuZsXPmEztl
	 2EQMAeTF397thm4TQb+UkKA5DiotXkmRbuxmIn4oW/+CkHf3rfASFWdLdC1/62YNgW
	 7uI/y4xIGAUjw==
Date: Fri, 12 Jan 2024 08:52:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] libxfs: also query log device topology in
 get_topology
Message-ID: <20240112165244.GW722975@frogsfrogsfrogs>
References: <20240112044743.2254211-1-hch@lst.de>
 <20240112044743.2254211-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112044743.2254211-4-hch@lst.de>

On Fri, Jan 12, 2024 at 05:47:42AM +0100, Christoph Hellwig wrote:
> Also query the log device topology in get_topology, which we'll need
> in mkfs in a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  libxfs/topology.c | 1 +
>  libxfs/topology.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/libxfs/topology.c b/libxfs/topology.c
> index 227f8c44f..991f82706 100644
> --- a/libxfs/topology.c
> +++ b/libxfs/topology.c
> @@ -346,4 +346,5 @@ get_topology(
>  {
>  	get_device_topology(&xi->data, &ft->data, force_overwrite);
>  	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
> +	get_device_topology(&xi->log, &ft->log, force_overwrite);
>  }
> diff --git a/libxfs/topology.h b/libxfs/topology.h
> index ba0c8f669..fa0a23b77 100644
> --- a/libxfs/topology.h
> +++ b/libxfs/topology.h
> @@ -20,6 +20,7 @@ struct device_topology {
>  struct fs_topology {
>  	struct device_topology	data;
>  	struct device_topology	rt;
> +	struct device_topology	log;
>  };
>  
>  void
> -- 
> 2.39.2
> 
> 
