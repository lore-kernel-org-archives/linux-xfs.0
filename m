Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1E82F616B;
	Wed, 18 Feb 2026 23:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771455975; cv=none; b=U0VuIv875t48o1+vNVUtaS4H/jOV2uAjWrgQzIUrrUBgF+fPh41I7NMBKtPAixUF505rJHSqF/FFxTnzkMqJYILTFwo8C2IU4vHt8oRqq0Gs+Ao9NSY1MNiue8btWyXp/Ri+sEWR5uY/AH3j+Z5+saHIuJBIq1HW1TC+SU9fkyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771455975; c=relaxed/simple;
	bh=vWc9pjDxYfDOGUUahUs8C4GcRMhanIR5qN6sDvlcoSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQwVuYNH7e2v1F3SOoD88cnskmrgR6SNSPNmBQaMIJTiGrmEn6CfbqjXeBRVBL/BKEOkRKs89UsgXZcpOGtF+hd+d+lwLKRjUiiWt4Ov87CKbGe1Rs5c60Naxt/hWhvyV9H+qFYsbWtL23/cJLWz9oyg/R7FBVDGZLIEdfSIEb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TP2WG13Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TP2WG13Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768DAC116D0;
	Wed, 18 Feb 2026 23:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771455975;
	bh=vWc9pjDxYfDOGUUahUs8C4GcRMhanIR5qN6sDvlcoSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TP2WG13QiNgYz2sJEHdMnJuTED4lgLssAmVwmY3qT9LY1v6a0ISQjHY25lovFAqi3
	 6dko+RVqriVRQDuRYWDvGLmg6ZnxZ0OpXMhHl8sAIBnTO+nFXvFrvqy7weZYXdoEeR
	 CnwCNymgeE++8j73DV+R37F/m9CkOED3qqAmU6dyAyray1XZjtKzoy5s1i/ZmUDP55
	 Qf8boYHiIgV7QKOJW2sQxvdth6nTctcFIoadajJZqQb/vfKQATLHaTd3HR4CGD+2F1
	 9ff6aiAW90TjvaG8M+c/6Pz4sRj9P8CrKeotNK4Kwc+UMOzcGSR7PREwSM0urtOFrc
	 4lr2VNAsh8Fzw==
Date: Wed, 18 Feb 2026 15:06:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 10/35] iomap: issue readahead for fsverity merkle tree
Message-ID: <20260218230614.GH6467@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-11-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-11-aalbersh@kernel.org>

On Wed, Feb 18, 2026 at 12:19:10AM +0100, Andrey Albershteyn wrote:
> Issue reading of fsverity merkle tree on the fsverity inodes. This way
> metadata will be available at I/O completion time.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Seems fine to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index cd74a15411cf..bd3ab4e6b2bf 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -570,8 +570,12 @@ void iomap_read_folio(const struct iomap_ops *ops,
>  
>  	trace_iomap_readpage(iter.inode, 1);
>  
> -	if (fsverity_active(iter.inode))
> +	if (fsverity_active(iter.inode)) {
>  		ctx->vi = fsverity_get_info(iter.inode);
> +		if (iter.pos < fsverity_metadata_offset(iter.inode))
> +			fsverity_readahead(ctx->vi, folio->index,
> +					   folio_nr_pages(folio));
> +	}
>  
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>  		iter.status = iomap_read_folio_iter(&iter, ctx,
> -- 
> 2.51.2
> 
> 
