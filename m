Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A562343D85;
	Wed, 10 Jun 2026 05:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068248; cv=none; b=ayuVqt8fneZCL8JJWSbGXyL7FGUChPV7Eegf6VWg88OL6hBsTs6eAmc0o9c4GfU+Dz+BNz8trXPwpQHTa3NHtE3XSybsaAG0cZWhU9PYsyJoDlPG4pKmGmr2DDQ5W/p4+HdPDviARznydzEMdp8PeWBtIyg+VgA/zzNpFhtivwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068248; c=relaxed/simple;
	bh=4PUKHrgnUIlcaiICXbtZcHWjq36Ig6zvJMn1SLMmv2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rks6x4AKJ4ZMB3WMUgeAEWIldxfXrdsLgJZxn/U/m3GBI4MOTvAF/XHKmUwbwiCv8/xqDs2OylNwQGukVFNtmsbwWG7PooiYGXiJW07d8nOXKo1fQ5H6jH8WDO7yYPTTyVccyBzc2NSFe2T8XvlIUgYoWGgmrPWbXo35WewEJr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkwEEOT1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkwEEOT1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E37841F00893;
	Wed, 10 Jun 2026 05:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781068247;
	bh=BWigdOf2B4uPaqGV90kwv1VByZEo/YY41xwT1ttMEn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EkwEEOT1dlUUnDqI/HRK43qKcl9AUsUH8xEORT6y2iYM5g/QQ5PqYVHQ0XQfxKFr2
	 1hFhQZL8Mg2aR+eQ/15odnNghzcDOCNtRVQXukMlazuKIqhFHiTnGu3b3YgdA/t/9e
	 5YXVftNfPD5uFlDvpcsg4nMtDiJyi0CvCbjtaz2rfTzpLg9i1sceeEM6pE6P+BzRa4
	 uX6sHYNFzYC6eKD1ylOAAH+vqjEKlDFjfCzIKlp6rcGnqhCGU3vWPbujblrSErccyV
	 Q7CxWoJwGHD+tZJZQ5uz677FrEZOBwYTV0/AgPRp9S9slK6rDO0jMjbeWxP1MRWDu/
	 G9Drq3AqPf1iQ==
Date: Tue, 9 Jun 2026 22:10:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: pass the correct len to fserror_report_io in
 __iomap_write_begin
Message-ID: <20260610051046.GE6078@frogsfrogsfrogs>
References: <20260610050642.1906695-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610050642.1906695-1-hch@lst.de>

On Wed, Jun 10, 2026 at 07:06:42AM +0200, Christoph Hellwig wrote:
> len is size of the (larger) write request, plen is the range for which
> the read failed here.
> 
> Fixes: a9d573ee88af ("iomap: report file I/O errors to the VFS")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Sorry about screwing that up.

Cc: <stable@vger.kernel.org> # v7.0
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d7b648421a70..bcf4559e9aa7 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -850,7 +850,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
>  			if (status < 0)
>  				fserror_report_io(iter->inode,
>  						  FSERR_BUFFERED_READ, pos,
> -						  len, status, GFP_NOFS);
> +						  plen, status, GFP_NOFS);
>  			if (status)
>  				return status;
>  		}
> -- 
> 2.53.0
> 
> 
