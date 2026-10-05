Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6E841A4EE
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236715; cv=none; b=ibMEkO0lpU+W58llHrSACsns4ReLxblMKoABnWD4/JLZ1lg5o701bBNBLJDvLSPg608yZNZD0GtozkrJeW0KKH5KMexywbDVa3qeVyBberSEuvQgHp8axCJkMKGsXU3aENJ3OrxAWdJVLrCqlXjqm1C4ixVrDvDkW7crTJGhQV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236715; c=relaxed/simple;
	bh=EHCC0QBtWSYIrD+kJYz2nfS4U4GHhUC05eji7yJMHGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Al8EIO+ZGbRtRrIj/X1a9bbmkhst4UsiLHzan0ZRMI1B3m7pxDLG3wgfFHcQTKGP9GfxAruuiG6RHpl1lYTyBzS1VchpfntVmOT8PVQPKqAp0TdeJTAKhmyrBbONkitzMKccrb3waGsfKJON8t6qQ/iVcz/Zbar8PjBrlzCx11s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMGekQVs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMGekQVs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3044B1F000FF;
	Mon,  5 Oct 2026 21:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236711;
	bh=79+yaCRRkbYE6hIEd+2whrDfzWm5swSG5WV9xjvySzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nMGekQVsg7My5ZY1RP26COqO1QiuaMLtAdsAGrXWIUUVv0lgASPPR50DAfOKd663z
	 Pra/B5c9Ibt/PC8gl5PUPcyF/AylCT5M+4IKtcv0xsCKBHItcDgBsLjeks0TQG1T+d
	 Y4UfsHHQ9E4fsBZGRoBK5v0Hj2yc77zMsOypUJLQAs2Y7IANzEoggwr7VWNAVecnCL
	 Nev9VLhXmpulS4ZgguDxrTYTpPn7D7kJIK8N8fe7+ZHoHcBOSwhVeqgLb6iO8jyetx
	 xG2b079Dfj64T8+Wlu/gt3DhbjMqLPNXbFmgED8sLQeQGtMQOh8c2tlq80Y+i7/5Th
	 ukPlz9jP9/Heg==
Date: Mon, 5 Oct 2026 14:45:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] libxfs: provide memalloc_nofs_{save,restore} stubs
Message-ID: <20261005214510.GI2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-3-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:12PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/libxfs.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 7f0c22ef4991..549176cf0b2c 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -54,6 +54,9 @@ struct iomap;
>  #define unlikely(x) (x)
>  #define likely(x) (x)
>  
> +#define memalloc_nofs_save()		(0)
> +#define memalloc_nofs_restore(flags)	do { } while (0)
> +
>  /*
>   * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
>   * every files via a similar include in the kernel xfs_linux.h.
> -- 
> 2.53.0
> 
> 
