Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA20D5473F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 07:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710833197; cv=none; b=bbwSXJ9EdK07kjmohXofxR2IhJr83UsggcRpIuUJzDWoZQuhjWnglFOjqnqK6EhMi2Q8NeF6oHjiGed1BOfb9+wG/5TprsBgRwxwzNH73SkW9iqJGtzPZSEnouQTd0wbaHpNPpaQkj6CtVKcQH95j3K4gkL3PThuxtpi9PXshyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710833197; c=relaxed/simple;
	bh=WKRjff9xCWCFGFkgRmwSzc6ottP+gz4/pZTkB0J3BaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgdBXX8YtnbSNfr6hvsljjLb9bEo7uHLfWjbLEIlifP71mHO7Ik6vhXy8zk1MAW4mJ8JnMm9JekBHqjLzBu4Hh27kdTB8auRO7zL9UQrlowgpP0Y/gJjC6G78gbAplICtg8sPObPTX/4GfQEU5S0wyXWckR15fpr7IfhaKqfo/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AJFmve5E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AJFmve5E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FvvtkiHtkgW+6EOm2yKpANzln/l3T+NRZPeiIriU9AU=; b=AJFmve5E+Sxw1R/ZkdPlRv+MEF
	HPbXWYg7fKvUxshwyGGbLcxxR+YW1rfsehx3QA23APChjWD3zFhCUhCLZRefWEOymY6g+fjR931vC
	tVwpRTfwx19tpyMyZ/zU8EkVYpvhUJ9JJNzDl0m349R3jHkKCd3dXNasqv2hZhcWOxU/f8laaFiWM
	YKGK7wtHCiLW8x6sWXWKRJimUBGNFLNL/T+AKYjlkg4iQL9mHbbAWtdMDMn0MV0U1syp50FxqH6QC
	N11IA6Cn9vzhgQtMrEmgbMjA9F1HBGNEVw3fDETxtYBRrqjtE66LhxGlgrKR89twtro//RdbsZ6xg
	Ipf825DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmTrn-0000000BhLi-1OiP;
	Tue, 19 Mar 2024 07:26:35 +0000
Date: Tue, 19 Mar 2024 00:26:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: separate out inode buffer recovery a bit more
Message-ID: <Zfk-K4c6RBebpgUg@infradead.org>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 19, 2024 at 01:15:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It really is a unique snowflake, so peal off from normal buffer
> recovery earlier and shuffle all the unique bits into the inode
> buffer recovery function.
> 
> Also, it looks like the handling of mismatched inode cluster buffer
> sizes is wrong - we have to write the recovered buffer -before- we
> mark it stale as we're not supposed to write stale buffers. I don't
> think we check that anywhere in the buffer IO path, but lets do it
> the right way anyway.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item_recover.c | 99 ++++++++++++++++++++++-------------
>  1 file changed, 63 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index dba57ee6fa6d..f994a303ad0a 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -229,7 +229,7 @@ xlog_recover_validate_buf_type(
>  	 * just avoid the verification stage for non-crc filesystems
>  	 */
>  	if (!xfs_has_crc(mp))
> -		return;
> +		return 0;
>  
>  	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
>  	magic16 = be16_to_cpu(*(__be16*)bp->b_addr);
> @@ -407,7 +407,7 @@ xlog_recover_validate_buf_type(
>  	 * skipped.
>  	 */
>  	if (current_lsn == NULLCOMMITLSN)
> -		return 0;;
> +		return 0;

Looks like these two should be in the previous patch.

Otherwise this looks good:


Reviewed-by: Christoph Hellwig <hch@lst.de>
