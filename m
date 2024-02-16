Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB05313FF8
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 06:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708063400; cv=none; b=Hmq1g3QW0lsNgDQR3YpJACp+V0qS6e9QhnkyzxwdAaDl/l53uO7qE417JORpDgD1E4LZMtxOApgxkKoM46NSa1Q+lvJ9G0pYoSvlcyScs0ADEr6c4H9+GJowN3r1h3OY9JMfcLWFqNgDMbcemoKrGHtAlh7auX2Yc1oA0TWsoXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708063400; c=relaxed/simple;
	bh=Kcn1M2ytrt69fsdSaS629BXaLFJSZ/rsP09qRds7fzY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fObfNtHd6kcg7x1ta2Jp72xPqpiYblMo/m+f3t0pu8OuZbBqpjzwgKNd8/62Mdoge5e5RGfKXxDjUIdrbChrTn7Cqou8J1VaSuOqtI4kxyZNJxm1eNv6vMb/SNdMGHRYPuekAiUXCp75whvvzdQmKbT9V2lwfQW7B0iXCMgPTQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=prhDsBNl; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="prhDsBNl"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-607d9c4fa90so13456597b3.2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 22:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708063397; x=1708668197; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HMM56hZb1Vm6K9SjE4SgV0BStCtli5nOUVFVj7yPx9M=;
        b=prhDsBNlMIlZRLB1XkH0QhJLdjgrNFNs/nCznvNhZ9YYBDGIu5mgIYTUI67FINT8FU
         7efqZ84AvKawiQAnGKyxIR2+SUwau9mjTIbtFdDUBk/zY8eWxcl9bWuK9nmTmAJ/DcXf
         t0XfW/xr3UuRVPlJmyxEbQoL6AGH58m4uiYlpQcjFNQSua2hMJrnQEovyEGiuviBeg3V
         +moBBNrDto4qvy+4Z/PwFc307+G3HpOjvypvlWuXsW9MJuwbQbjU58FJwuNzukbf1C6r
         DHk8YhQ+JfkoXwTCD1K1+ySm7YHefTdzkXRxOkIJZZOuuSl+ySyDy+Tk1qa1tV1rMjsm
         OYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708063397; x=1708668197;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HMM56hZb1Vm6K9SjE4SgV0BStCtli5nOUVFVj7yPx9M=;
        b=PYwEjvqFTIWfMdX7PdWSd6jv7rQJG8FGAL/jQsAfXC69F5IVpLYadEAAICs4aXYLW3
         mPkJmjJ5e7KnS2L6CPFksV1SO2MzLTPEVLXNOBzriDv6xGRsHnoRifoFyKxff0WKfmR3
         oTLLw4XeI6UY03fydPJooUM9TrYVx/tGiUwPnfU4mt3j605tKB/EytoF7YESONFA0PIe
         15cIe+mwnpJUc+DQrOxtE45przYkSaZkou8SypUx3EJWHIumQ5SJCnwKJqZN1/2gKduN
         JYtJ3uEta/Rt12DOJzHLW5iBg7G19MzAmP03BA/hRqSgY+lpRaffOtd0qiHEsfSbURGp
         6+gA==
X-Forwarded-Encrypted: i=1; AJvYcCWbr2FnhWy6qu38afLe3hxeNkmEHmD4D+a23EFPK6P8tQUhJ5rFXI4IEKda6qC+J0ktO3AngDA02Eml64dOt0SIqhLl9li5CDoU
X-Gm-Message-State: AOJu0YwIs/jvqzs/fXy7Li4NuQ5pDfSIXWOu5paBUrPs6v8TQxsJTcbu
	HyPgYoAXU7TdGIsI3CCEsrX1ddGnp2quY2mjaEwSTjL9scC2THIE9GDEnODCbA==
X-Google-Smtp-Source: AGHT+IHSLIRCwJ8Aj5LZC9Dr5T3twlSj69RXjK+SmfejRJBCpGGWorVjZHS1LUFkcBz05UbD0yPBRA==
X-Received: by 2002:a0d:d944:0:b0:5ff:5232:8aa1 with SMTP id b65-20020a0dd944000000b005ff52328aa1mr4514949ywe.21.1708063397364;
        Thu, 15 Feb 2024 22:03:17 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id d12-20020a0ddb0c000000b006078c48a26csm221324ywe.25.2024.02.15.22.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 22:03:16 -0800 (PST)
Date: Thu, 15 Feb 2024 22:03:05 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Christoph Hellwig <hch@lst.de>
cc: Chandan Babu R <chandan.babu@oracle.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Hugh Dickins <hughd@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>, 
    Vlastimil Babka <vbabka@suse.cz>, linux-xfs@vger.kernel.org, 
    linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 02/20] shmem: move shmem_mapping out of line
In-Reply-To: <20240129143502.189370-3-hch@lst.de>
Message-ID: <44242679-720b-f55e-c0f8-db5bf919931f@google.com>
References: <20240129143502.189370-1-hch@lst.de> <20240129143502.189370-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 29 Jan 2024, Christoph Hellwig wrote:

> shmem_aops really should not be exported to the world.  Move
> shmem_mapping and export it as internal for the one semi-legitimate
> modular user in udmabuf.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I'm okay with this change, but let's be polite and Cc the author
of the change which this reverts - v5.11's commit 30e6a51dbb05
("mm/shmem.c: make shmem_mapping() inline").

Interesting to notice that commit did EXPORT_SYMBOL(shmem_aops),
whereas shmem_mapping() had not been exported before; you're now
exporting it _GPL(), like other examples in mm/shmem.c: agreed.

Hugh

> ---
>  include/linux/shmem_fs.h |  6 +-----
>  mm/shmem.c               | 11 ++++++++---
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 2caa6b86106aa3..6b96a87e4bc80a 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -97,11 +97,7 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
>  		unsigned long len, unsigned long pgoff, unsigned long flags);
>  extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
>  #ifdef CONFIG_SHMEM
> -extern const struct address_space_operations shmem_aops;
> -static inline bool shmem_mapping(struct address_space *mapping)
> -{
> -	return mapping->a_ops == &shmem_aops;
> -}
> +bool shmem_mapping(struct address_space *mapping);
>  #else
>  static inline bool shmem_mapping(struct address_space *mapping)
>  {
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d7c84ff621860b..f607b0cab7e4e2 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -254,7 +254,7 @@ static void shmem_inode_unacct_blocks(struct inode *inode, long pages)
>  }
>  
>  static const struct super_operations shmem_ops;
> -const struct address_space_operations shmem_aops;
> +static const struct address_space_operations shmem_aops;
>  static const struct file_operations shmem_file_operations;
>  static const struct inode_operations shmem_inode_operations;
>  static const struct inode_operations shmem_dir_inode_operations;
> @@ -263,6 +263,12 @@ static const struct vm_operations_struct shmem_vm_ops;
>  static const struct vm_operations_struct shmem_anon_vm_ops;
>  static struct file_system_type shmem_fs_type;
>  
> +bool shmem_mapping(struct address_space *mapping)
> +{
> +	return mapping->a_ops == &shmem_aops;
> +}
> +EXPORT_SYMBOL_GPL(shmem_mapping);
> +
>  bool vma_is_anon_shmem(struct vm_area_struct *vma)
>  {
>  	return vma->vm_ops == &shmem_anon_vm_ops;
> @@ -4466,7 +4472,7 @@ static int shmem_error_remove_folio(struct address_space *mapping,
>  	return 0;
>  }
>  
> -const struct address_space_operations shmem_aops = {
> +static const struct address_space_operations shmem_aops = {
>  	.writepage	= shmem_writepage,
>  	.dirty_folio	= noop_dirty_folio,
>  #ifdef CONFIG_TMPFS
> @@ -4478,7 +4484,6 @@ const struct address_space_operations shmem_aops = {
>  #endif
>  	.error_remove_folio = shmem_error_remove_folio,
>  };
> -EXPORT_SYMBOL(shmem_aops);
>  
>  static const struct file_operations shmem_file_operations = {
>  	.mmap		= shmem_mmap,
> -- 
> 2.39.2
> 
> 
