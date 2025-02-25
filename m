Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1201219307
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 20:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740515152; cv=none; b=cHueT3LB48fiiXWzRM2/Je218No82Pnq8nyfSMH5XLP2l1eKnYCaPdhjzqk1C5xSkWpVqt0C/nAXNZZNjnVkrGv7dBi7V1NIPkDH4UHt89euia8mk8iqHw94tDPsY2Tttqp2uV0QDvJfImamSuB2gWpFp7b7DF/Gcxqcj7rRmuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740515152; c=relaxed/simple;
	bh=p+pwKqqiJgGoKhhKfKEb2PlC3q2bJ+lUi7mJ6sJw3Fw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4djmURACEO8IS1OW3gu6gH9GX7naEB/RhoAizaCETRPaEXChdWoZEg8Slho7F+EUipFJhvIu26G0WSfviSuIENxsaNUWEsbQUkbOF9Ms8WTxmZ8L2uO236wVxh1xQc+ZKO27aS2LzyTtHbDFrCbMxYAem4gDroRWEQBDUkTmqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=j6+C/8pD; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="j6+C/8pD"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2210d92292eso30112255ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 12:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1740515150; x=1741119950; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3sahSWpKtSWo1rgbQdN3cw9Z14mvbGZlYM9iW6N7nIM=;
        b=j6+C/8pDPk8hVujyWgUeL3kvc+EExreU4AJ+mL5ZDQLkmx3Vafi14JMiXK8+e1yjmy
         WUTkFYLPfyjEeyPddbKPyq6EFWQSTSkj5i+eb3UzAQ2Ok3g4B44o8jcGPnLpSnKxydaf
         sSkwuUEByT4fQ1Ucc/xXI/loz6VLX9iBlCffBhiH1iOoMxVsfT+zkg8lJ3Bd/rYaygzx
         FKtYkW5aeuNRHfp3Kpu4gGiQA/8Hrz/RBMjUHpIVs6h8a1+7pNGXVQ2kvnq7Bl62lqwh
         ORYcXxs7fO86Vn1VKtDruz9srgQIXxxK6mWZtVodvj8GYgi5gaGCDRwSF/CY7xsP8k6v
         0P2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740515150; x=1741119950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3sahSWpKtSWo1rgbQdN3cw9Z14mvbGZlYM9iW6N7nIM=;
        b=l+o0tbOPNraksaHjNOD+fFiZeW4+PX46tliy9yPK1yjK/E5YzH857EMf/LqpMfbhoM
         KmqKGgCCJfTqqxbnZFiiFc8MhATVOhIja+PFUK2PwP3goNs4Demh18GP9YfdSM3d6PEU
         XjL6qbz0fVwDlDfNzHh8ga4BT6KX7HuQa54TvslgC/3/KV0FpE2M/AtC0n8vpF+M0PgC
         ZJ8krESVpZtxm9GP3a19cyEMK21WskJEO3BiViqANvlAQ1E1p7wmhM6lz5lCfi2qMWxN
         38TEaZe9vKD8/VvoR/sHi9wG1L9gfUAYvxTI/y9Afrmdv/EmQ4qD3Khe06FJb1aTaOaR
         KMTw==
X-Forwarded-Encrypted: i=1; AJvYcCV7Va8QmS292NIDCMETfu/P7YX+sTKCNMluqQCZUDg1N9e/pS4LGV+xjkVYzC/USpwCtUp8I3qEWgs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHwTYT3WzOE7aXksS/RvCC9B0w9T+W/BPD4lloDq8UKlSK1JZp
	kto5e52L/bspbZJxoYubPDjMQGHKAv3DqLDmzQ7MQzwZ6MuDUK6rbtBwr9RIII4=
X-Gm-Gg: ASbGncsCx977XjbS3nK7g+Z5wN+M0rQzjm/BN+zv38SG491vaI9iJg5Nb60fZVKji5r
	n+lHjMXte5oRXe8FT91LgaF53tv6rzOqE7p+4DJipNzzsc69aNV9gDNOKL4v1zH2z75dyNV95wS
	531rkwxRkOGk1x5gzvh6W/MkFAgkMSCQuS/l/6WKL09IwXg2CsnDhK22UNw3xAk8+qEuIZ6Ac70
	+BPrC88Q7sA8up2pykgLACwOr+s9axqNXOlBUEq40nng8eLyvbwHoXbfvzj6Nixa9Hv2vdst044
	WxroI4qO8ZwvjX4hYtz6piXr5m3PK6GYlO17LwN3HuBgpSMFoWhgihTBLeZY55pOkNvtaJtbrsw
	MYg==
X-Google-Smtp-Source: AGHT+IFJUKeSO/+jJc8oE4V1Fy6IwtegHWAoWJKcW7vsL+7oK8iiuDIcLUyurk4FQbtZ6ud4ESh4Ow==
X-Received: by 2002:a17:902:d4cf:b0:216:4853:4c0b with SMTP id d9443c01a7336-223201f7d84mr10594015ad.33.1740515150171;
        Tue, 25 Feb 2025 12:25:50 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2230a000830sm18730065ad.30.2025.02.25.12.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:25:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tn1Uw-00000005ugE-3hi6;
	Wed, 26 Feb 2025 07:25:46 +1100
Date: Wed, 26 Feb 2025 07:25:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, hch@lst.de, willy@infradead.org
Subject: Re: [PATCH v3] mm: Fix error handling in __filemap_get_folio() with
 FGP_NOWAIT
Message-ID: <Z74nSu3q2b3sy5wY@dread.disaster.area>
References: <20250224143700.23035-1-raphaelsc@scylladb.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224143700.23035-1-raphaelsc@scylladb.com>

On Mon, Feb 24, 2025 at 11:37:00AM -0300, Raphael S. Carvalho wrote:
> original report:
> https://lore.kernel.org/all/CAKhLTr1UL3ePTpYjXOx2AJfNk8Ku2EdcEfu+CH1sf3Asr=B-Dw@mail.gmail.com/T/
> 
> When doing buffered writes with FGP_NOWAIT, under memory pressure, the system
> returned ENOMEM despite there being plenty of available memory, to be reclaimed
> from page cache. The user space used io_uring interface, which in turn submits
> I/O with FGP_NOWAIT (the fast path).
....

> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 804d7365680c..3e75dced0fd9 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1986,8 +1986,19 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
>  
>  		if (err == -EEXIST)
>  			goto repeat;
> -		if (err)
> +		if (err) {
> +			/*
> +			 * When NOWAIT I/O fails to allocate folios this could
> +			 * be due to a nonblocking memory allocation and not
> +			 * because the system actually is out of memory.
> +			 * Return -EAGAIN so that there caller retries in a
> +			 * blocking fashion instead of propagating -ENOMEM
> +			 * to the application.
> +			 */
> +			if ((fgp_flags & FGP_NOWAIT) && err == -ENOMEM)
> +				err = -EAGAIN;
>  			return ERR_PTR(err);
> +		}
>  		/*
>  		 * filemap_add_folio locks the page, and for mmap
>  		 * we expect an unlocked page.

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
