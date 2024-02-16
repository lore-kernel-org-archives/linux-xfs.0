Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58B0171D2
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 07:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708069247; cv=none; b=E2tasNS41x5HILPAcj5OKbgBuLCgKAEShHUmif60v2WrfMsd8zq6pIUd4Sjn78bYYAFft6eOIKSaAkN5qvdXt3fCCtpMxSYPFTyGdZfCmy1VLBorEaytJc3Ojrv1oOU+8fZRd4kXcKTzjARI+NKssX6VG082EzM5Fw1xAUe+xqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708069247; c=relaxed/simple;
	bh=Wf4lN2RbogjU3or3Rns6nPfSnGqab7DtuvnJxPSlXQM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gvf5r2kBP2Jsp1KsIPnLismFH5POKmDNyMpaobKDnwJF54+ElTi4oQrbwzDzqqD8Bc8RiJWklj1ZP5cpdldbEBYLt3NjmWVlfiuVFuyY7q7E2IWOaYlycYAqhacUwnobVPFad1ZwecFyxh0frR5xWnsLwPgElNHCCeqn8CTOfVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ePy4Dir/; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePy4Dir/"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-607f8482b88so3978617b3.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 23:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708069245; x=1708674045; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ovLXWtZtTydmOuJYQBdia+RLmYItmrIBSwt8zg/YWmk=;
        b=ePy4Dir/Pi6H4YbXJhhc27OCii9HI8iByFgy3FoSIgtEM8a3TavCxlaCXIKRiCKsNz
         SUJx2BosALRUQl17y+omSwSDI/sDG8JaS1X0a+a+jbANjKJELGkBZ7xoGW7GeAYsC6wC
         W0e8Javx9idpgYme861alsgZa32PnjXkkTRK9M7AjjJLsEaG4M9AdnWr6o67z1mHnYBZ
         oACEPUF6msaECXCca/gy4NjrEVpY+Lz96y++RkJkZCdEt/8v6YeoVzRojcPCjKC8TK8o
         5yVSpA3P7om98ymb6Il7ZW8bYn505PAGUrWLNme1Z1O3A8arJT3LtD7SDCqKeXxOSkqg
         f65Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708069245; x=1708674045;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ovLXWtZtTydmOuJYQBdia+RLmYItmrIBSwt8zg/YWmk=;
        b=N+5o7mrBD1kkM19r9obouD16sxkEwQ1k5A3h3WY39EWICMI62yGfpzXjBRWn9yg4x8
         cSp3odDrDRJLv0mW27nzbQL9ADs9/tvM+FyIDsrPoXJL2vPe3Sz5pH8xAsyAkzc9kP8+
         ius2xVs8mOiSMNA918ZS84OBhd6OCasE3yExeUorzrZxtIVjN+9G0gSG/cDjgjyx7ggW
         piPCo/PSthKR5Q9G6AMydPgetHSuL3hgk5+LWcbctZNrEDe9pqvMceLA0OsLgfR6EklV
         CC/147T8vvdJfHrFpWMuYAFbqjNpql8SCQiVVi8aOxN8keW+Rk0Fczu4QCzdI2N2pbri
         wPKg==
X-Forwarded-Encrypted: i=1; AJvYcCW+P71yA0+dcJyaEXACQO+fLTxoig4KDycwPwIpIB5YIiwInNX566ZJyvJ/MB8WDjHxa26UoUr45MacRqxTfowOWFNa1v168Gx0
X-Gm-Message-State: AOJu0YzphAKghRSZdxwydKf9OuoojsJH1jw59H4FmWlwNni5lpoz6XnT
	S30oXF8m7GQ6QaWCjM0mBKcnNQdUavCnru8eBPai2ySqt1y8DgAW5Goi2K/Zig==
X-Google-Smtp-Source: AGHT+IFRP/V0/OL+0SVHgVYfcJFzbqM573teIpsV9n40jRjl5FF1m2E4UHS7hsCWKPYXdbboHzRICA==
X-Received: by 2002:a0d:d511:0:b0:607:7d11:ea2 with SMTP id x17-20020a0dd511000000b006077d110ea2mr4511710ywd.37.1708069244342;
        Thu, 15 Feb 2024 23:40:44 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id t4-20020a815f04000000b00607b37e2c74sm245013ywb.118.2024.02.15.23.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 23:40:43 -0800 (PST)
Date: Thu, 15 Feb 2024 23:40:41 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Christoph Hellwig <hch@lst.de>
cc: Chandan Babu R <chandan.babu@oracle.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Hugh Dickins <hughd@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH 14/20] xfs: use shmem_get_folio in xfile_obj_store
In-Reply-To: <20240129143502.189370-15-hch@lst.de>
Message-ID: <8eba6e1d-3e93-9586-17f3-86dcf25f5ae4@google.com>
References: <20240129143502.189370-1-hch@lst.de> <20240129143502.189370-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 29 Jan 2024, Christoph Hellwig wrote:

> Switch to using shmem_get_folio and manually dirtying the page instead
> of abusing aops->write_begin and aops->write_end in xfile_get_page.
> 
> This simplifies the code by not doing indirect calls of not actually
> exported interfaces that don't really fit the use case very well, and
> happens to get us large folio support for free.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/xfile.c | 73 ++++++++++++++++----------------------------
>  1 file changed, 27 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index a669ebbbc02d1d..2b4819902b4cc3 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -183,11 +183,7 @@ xfile_store(
>  	loff_t			pos)
>  {
>  	struct inode		*inode = file_inode(xf->file);
> -	struct address_space	*mapping = inode->i_mapping;
> -	const struct address_space_operations *aops = mapping->a_ops;
> -	struct page		*page = NULL;
>  	unsigned int		pflags;
> -	int			error = 0;
>  
>  	if (count > MAX_RW_COUNT)
>  		return -ENOMEM;
> @@ -196,60 +192,45 @@ xfile_store(
>  
>  	trace_xfile_store(xf, pos, count);
>  
> +	/*
> +	 * Increase the file size first so that shmem_get_folio(..., SGP_CACHE),
> +	 * actually allocates a folio instead of erroring out.
> +	 */
> +	if (pos + count > i_size_read(inode))
> +		i_size_write(inode, pos + count);
> +
>  	pflags = memalloc_nofs_save();
>  	while (count > 0) {
> -		void		*fsdata = NULL;
> -		void		*p, *kaddr;
> +		struct folio	*folio;
>  		unsigned int	len;
> -		int		ret;
> +		unsigned int	offset;
>  
> -		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
> -
> -		/*
> -		 * We call write_begin directly here to avoid all the freezer
> -		 * protection lock-taking that happens in the normal path.
> -		 * shmem doesn't support fs freeze, but lockdep doesn't know
> -		 * that and will trip over that.
> -		 */
> -		error = aops->write_begin(NULL, mapping, pos, len, &page,
> -				&fsdata);
> -		if (error) {
> -			error = -ENOMEM;
> +		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> +				SGP_CACHE) < 0)o

SGP_CACHE is the safest choice, yes.  It will tend to do an unnecessary
clear_highpage() which you immediately overwrite with the actual data;
but saves calculating exactly what needs to be zeroed above and below
the data - not worth bothering with, unless shaving off CPU cycles.

>  			break;
> -		}
> -
> -		/*
> -		 * xfile pages must never be mapped into userspace, so we skip
> -		 * the dcache flush.  If the page is not uptodate, zero it
> -		 * before writing data.
> -		 */
> -		kaddr = page_address(page);
> -		if (!PageUptodate(page)) {
> -			memset(kaddr, 0, PAGE_SIZE);
> -			SetPageUptodate(page);
> -		}
> -		p = kaddr + offset_in_page(pos);
> -		memcpy(p, buf, len);
> -
> -		ret = aops->write_end(NULL, mapping, pos, len, len, page,
> -				fsdata);
> -		if (ret < 0) {
> -			error = -ENOMEM;
> +		if (filemap_check_wb_err(inode->i_mapping, 0)) {

Hah.  I was sceptical what that could ever achieve on shmem (the "wb"
is misleading); but it's an ingenious suggestion from Matthew, to avoid
our current horrid folio+page HWPoison handling.  I followed it up a bit,
and it does look as if this filemap_check_wb_err() technique should work
for that; but it's not something I've tried at all.

And that's all I've got to say on the series (I read on, but certainly
did not delve into the folio sorting stuff): looks good,  but the
VM_NORESERVE question probably needs attention (and that docbook
comment to mention "locked").

XFS tree stil seems to me the right home for it all.

Hugh

> +			folio_unlock(folio);
> +			folio_put(folio);
>  			break;
>  		}
>  
> -		if (ret != len) {
> -			error = -ENOMEM;
> -			break;
> -		}
> +		offset = offset_in_folio(folio, pos);
> +		len = min_t(ssize_t, count, folio_size(folio) - offset);
> +		memcpy(folio_address(folio) + offset, buf, len);
> +
> +		folio_mark_dirty(folio);
> +		folio_unlock(folio);
> +		folio_put(folio);
>  
> -		count -= ret;
> -		pos += ret;
> -		buf += ret;
> +		count -= len;
> +		pos += len;
> +		buf += len;
>  	}
>  	memalloc_nofs_restore(pflags);
>  
> -	return error;
> +	if (count)
> +		return -ENOMEM;
> +	return 0;
>  }
>  
>  /* Find the next written area in the xfile data for a given offset. */
> -- 
> 2.39.2
> 
> 
