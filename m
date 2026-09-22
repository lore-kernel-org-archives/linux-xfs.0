Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50858246774;
	Tue, 22 Sep 2026 05:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054560; cv=none; b=qh9wNqGpz/qnjMbmu/RzYN+jHmqikT/b/YZ3VPaTM4PZRzX2EpMzBpIBjnvGkt/4U6EPk4LAP7aWiHBl7Ds1WNbKJohJYRWxw9fSm4YQu85eWV0cbduosxSXLAkQZtiJdGljsEXImhyCIYFf0005nWi6CLk5K6rc/5N6h1gQRSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054560; c=relaxed/simple;
	bh=BUDXTXwmifqGWjBgrdkWtkKy+Sx6RBGSnjfF4TDjBYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcSVbvzzAkT+ZsNeoAth2DKD2dYSNWmfSZNi+NpLW8DafdrIMt7BlG2IEMal0aoXKHTjLQNk6xFgH/yyzFqDLvB71KpZfWq6kSWBERXZVM/ls5mioZ5rbHw4K4/QMArkZVg8+gXtlHXj9XnY0hBt/xkNYaT+FQ36TLrWq2g9xVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DjKEeZpo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DjKEeZpo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Jf8gwETMMbRC2fDdyxmm82vJ3Yk1aIujSU0mcxy+k9I=; b=DjKEeZpoCBJxFDbMhkQcZtaiXU
	2IhTUz60sqw8yhw/KCfa6CuXnt5Wu+j8f5/9E1+NBiCc3OMxGMjICw5UnrMg1IuWM2drsy2JdzRWG
	lZDcY5zinRUgSf1hdBzjIZb1kj/hBsj2VKm5dDCx4OFVNXMJRD1u4IHsgxYhm/9+cmxFolgkSS4K1
	p6uoAi5ymHPTKm58UyVj5LmtgbxQiYVKs8ZkxpfHuk+EDwsk+c0VKlYnkkL+jNciW2uP0N9cpQSrS
	XVBhLjrlyV97FnV59SYfNJeE6R2c0dfJPyKEHrk9kX2xiw7qIEqsPS/OI85Aa2PuXOELU2uYTdFlW
	2dPxfkFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8sxi-00000004Eq1-3Uu4;
	Tue, 22 Sep 2026 05:22:38 +0000
Date: Mon, 21 Sep 2026 22:22:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/14] xfarray: don't crash when sorting if array element
 crosses a folio
Message-ID: <arIQntfRrNKGHyoF@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120763.181988.2563798655569721557.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120763.181988.2563798655569721557.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:17:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that if an array element crosses a folio boundary,
> xfile_get_folio returns a NULL folio pointer.  If this happens,
> si->folio is also set to NULL, and calling folio_pos/folio_address will
> just crash the kernel.  Teach this function to handle this condition by
> falling back to reading the array element into scratchpad memory.
> 
> Cc: <stable@vger.kernel.org> # v6.6
> Fixes: cf36f4f64c2d4e ("xfs: cache pages used for xfarray quicksort convergence")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/xfarray.c |   18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
> index 2ce24bfe4c0fab..30a58e9d4378e4 100644
> --- a/fs/xfs/scrub/xfarray.c
> +++ b/fs/xfs/scrub/xfarray.c
> @@ -830,22 +830,24 @@ xfarray_sort_scan(
>  			return PTR_ERR(folio);
>  		si->folio = folio;
>  
> -		si->first_folio_idx = xfarray_idx(si->array,
> -				folio_pos(si->folio) + si->array->obj_size - 1);
> +		if (si->folio) {
> +			si->first_folio_idx = xfarray_idx(si->array,
> +					folio_pos(si->folio) + si->array->obj_size - 1);

Overly long line.

> +			if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)

Another one.

> +	if (!si->folio || idx < si->first_folio_idx || idx > si->last_folio_idx) {

And one more.
