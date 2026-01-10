Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFA41C7012
	for <linux-xfs@vger.kernel.org>; Sat, 10 Jan 2026 00:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768006254; cv=none; b=Vp59BlnBb8u9XRJ4ufMcVVPZ0ABXGdJnVgPcvkOA476JqWRZB5AfDTfThlPg7vXsLgW2UNkghXvaBqYSpQy29dVwqviRfkj6NbGSsV85XGL8QPjiPcZ2orRhlN/D0snYheMSSfUXYJRt9CmW76OjpNspDfUY8jcIeuosgcX1D44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768006254; c=relaxed/simple;
	bh=q7a4k6ALujm4aPyO3Ycf5hrj14CT8hhIzjsPox/G/s8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W8+hyLC3/1kN0mhP4MnkmSt/ZBV/kQn+ntSR6JYs/VZrNMgZNMlB3gD5sbh5snt97dRkLyLYj7+QM/MNs22YjIADa/b9XSUfZn5L0fpflMoWtZz1ldwSwI9ivaG/IjF2EqdX+UsBl4UFac8KXl5kX6rcWrRO4K6K+1QWObKA8I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nEHHfzbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nEHHfzbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACE9C4CEF1;
	Sat, 10 Jan 2026 00:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768006254;
	bh=q7a4k6ALujm4aPyO3Ycf5hrj14CT8hhIzjsPox/G/s8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nEHHfzbWmjwNxn3T6TUTnswzujulixIGLOWNScSEFGlHNt83xC7PuLHXQDED23ypp
	 knrgX1CVXwv1FeOxfVX4HlyYBdNXoDE8B9CcU0z1Kg10McQvmwmNZf4pPxeKws9ZNv
	 SOLwf67YxtzVlC1Z4sFpcv7psU4Ki+azlfiQCUmmq9JrKrT+Mk5iOFa/7x71JoKVVK
	 z3gYglBfOlM474Bc/3w5V4kXGT0g775+In+XGbU3av9SW9vALczKZSbPcsCvYjpUox
	 iG/UZo1+2SbBy1VhEkoe5VoPN3pfkORtOWxgQ6XxzhDjctAkpSL7q+20+QvXGLfqA8
	 aJGDGWyxLGciA==
Date: Fri, 9 Jan 2026 16:50:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: add missing forward declaration in xfs_zones.h
Message-ID: <20260110005053.GV15551@frogsfrogsfrogs>
References: <20260109172139.2410399-1-hch@lst.de>
 <20260109172139.2410399-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109172139.2410399-2-hch@lst.de>

On Fri, Jan 09, 2026 at 06:20:46PM +0100, Christoph Hellwig wrote:
> From: Damien Le Moal <dlemoal@kernel.org>
> 
> Add the missing forward declaration for struct blk_zone in xfs_zones.h.
> This avoids headaches with the order of header file inclusion to avoid
> compilation errors.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_zones.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
> index 5fefd132e002..df10a34da71d 100644
> --- a/fs/xfs/libxfs/xfs_zones.h
> +++ b/fs/xfs/libxfs/xfs_zones.h
> @@ -3,6 +3,7 @@
>  #define _LIBXFS_ZONES_H
>  
>  struct xfs_rtgroup;
> +struct blk_zone;
>  
>  /*
>   * In order to guarantee forward progress for GC we need to reserve at least
> -- 
> 2.47.3
> 
> 
