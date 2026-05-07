Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E11734F497
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 09:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778145690; cv=none; b=cGJ1FOmSV2zgckkyLIbb7Ijk//udv4ePVbdMlzBRdOZgicJ0GhNw28gUHlqSHcHc+srLtBDW6c+2GAqLN82TxtEBy284Dy2c8aD07kuUvkmU658ZQKyIyke+V4LkSqmRWBHmonbVJKzW4Udw6Bw4VpnUEA3o+D/lhTUYJJVQSQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778145690; c=relaxed/simple;
	bh=ZJC8mprVwWo583tIRvOh0mthBjgcXQqS/BF/zwTJYbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RmBTWmzgV/J7csXdnZoydNGl5c0mLum6PM/YHO05gh283LJbj18PZZSFHOmJrGm1RFcuNt0dv2g5BFz8tOGcAAhOx7sYDMVSBIwwTllV0b8yHspOCokXikiFU+4WT6qExPLGYl4hblMyx1S/EgQvDZKccqXZl9sy+EpBf5vsyQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdRB8Ktp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdRB8Ktp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E44CC2BCB2;
	Thu,  7 May 2026 09:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778145689;
	bh=ZJC8mprVwWo583tIRvOh0mthBjgcXQqS/BF/zwTJYbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kdRB8Ktp0Sq289L5kFGaBCesvaPQryfuH5EIWD8JwNUOpBPtlQxLM7urzSZcF6vy/
	 1ogtaTkctiAsQf27ppt9TPdjglfWk9Bq7ZeJ77svF84+JmVxdrucSat9L10WkGgsaO
	 so2+17eKgKccCK8oDdfUp/U0FKIdhliyj9wkvUwppiBTAXy4Rd1tRamSs6RhK0Cy/7
	 RrhlbUota8DVwFB1xlo6VrjYeJgg/4PtqKXsmtsdI7VZNf2JrolUNfJlt0yGyjRKTX
	 FDt1Ip7iV07l8JCfOjVrpu0BQPaJdxzfbZQUzRo8bVt4Yeid3WIEgGT2HU7s3pGVqQ
	 sr/KNLGCF3AAg==
Date: Thu, 7 May 2026 11:21:26 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix the "limiting open zones" message
Message-ID: <a3rzpekmyzfwy5aiqnpkrmryufjb6na6bhts3p7c33acrjxq2z@4otgli5meezc>
References: <20260507052457.1305016-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507052457.1305016-1-hch@lst.de>

On 2026-05-07 07:24:57, Christoph Hellwig wrote:
> The xfs logging macros include a newline, remove the \n, which adds an
> extra one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
