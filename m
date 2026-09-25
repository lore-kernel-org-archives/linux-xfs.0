Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4F6226D05
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790375999; cv=none; b=VLhpZHQUq+qU2rWH1+IJT0cWBK+66o0yxxsiCvLJV18QQ9cyM1gXTPJOE/+FtLy+acgg+3rYfw5itjB4fkxq3KkawQvJeTlM6Y6QLNJgs+QIAqR8uXx03FH9h+V1wU0Wh1gaRyEo6UYVy4/bKj+2neR5xYSop8KrX9vEFpTN+ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790375999; c=relaxed/simple;
	bh=XLemZETq3VAeK1g6IYnDP5EbQIehmFP8GlmiMYdXopw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VO693yIFDXFPsFi5qcvbkB8IRZOuPyuqsom4opJYYKB9q04t9bRSdBCx6uZGL7wBHB9jGLvpTA0EiLih83SUh721a04KQMul7ttVmSpEpVlwITSdIL5++sxhOCR/LJOBp0DnW1b1QlrXTTGxigS6BlmGVQjSFqvlYjoQy1RXRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pxit4VFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pxit4VFO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B62931F000FF;
	Fri, 25 Sep 2026 22:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790375997;
	bh=ywL+YmrsJ63AuHQXQIntQFKx0IqSna7WcPswm3fagcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pxit4VFOq+s0+jVeULVeRoGA0fjRzN+/Fucrywuhh6/HKTomEYgY1KYmS4ye3oyiY
	 6RdbcMdCQjZMks1o/YeA48rfgzUeN3VIURwWWLT25YuLFtY5YNccSvYtRwKayQg3Ik
	 /QnafjtHFJbiZ10VSSfXRgc1eDjGLJLqn+50TP40ksWNLEOszbu9xxHFAes9hD1XZd
	 MeLwP0eVz8gTDqBoHn9GuM5W2yRza0ziTFIpL4g/yqd5R6ilI+HkiftLKj0OzOODRz
	 x9J9xxRkLf1vPkkzL1cwT0DFEkBHqEuURaJrDDK1fg7QbWrHiRuXAXs6zo1LOwMK7S
	 oKsx8M2FGdw6Q==
Date: Fri, 25 Sep 2026 15:39:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] libxfs: don't clear ->dev in libxfs_device_close
Message-ID: <20260925223957.GU2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925051336.2997014-7-hch@lst.de>

On Fri, Sep 25, 2026 at 07:12:52AM +0200, Christoph Hellwig wrote:
> struct libxfs_init can't be reused for multiple mounts, so there is no
> point in clearing it.  And clearing it defeats the duplicate device
> check in libxfs_close_devices, which would lead to flushing a closed
> device if this wasn't current masked by another bug.

Jeez.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/init.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 85e0b3402bb2..842a2e1e09a9 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -182,7 +182,6 @@ libxfs_device_close(
>  	close(dev->fd);
>  
>  	dev->fd = -1;
> -	dev->dev = 0;
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
