Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13341DDEE
	for <linux-xfs@vger.kernel.org>; Sun,  2 Jun 2024 22:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717368407; cv=none; b=G8cAZ699uE+5myzQDqo7YG26HQUrbc5ozVJn2FwmnerBfibMEqitepgeKsyfR1Inx1gRNOYXJQBSs2NSYkyiBe3o8x6FNhMnr3QPV8RqeOSXQHZeIoueOgGLmfbquWiYLs9mn9a2kpWbCcxxXcVOx73C8Bn05FaKDC2ozE369gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717368407; c=relaxed/simple;
	bh=tBLJwN1kEKsD1tDXp7MeMVePbCwuaBg5pq+LH6c+vWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXG5HaMOg6dUu5O0Vtwr5fsGlc3Rq6lzcC3KUmiXQIJFVm8vYpAk9wSi3doaSYnDr+u/j4+y0ZJsSEf+boadsrRfQbdfP5E38JAVm0GRCy3S8vt36gBpaXXzaeUgkIf+iRH6xlKhsLslGs8cEGWlueXP6QvrFXJPJaNrdl4bonU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=W1/BzWgT; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="W1/BzWgT"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f62a628b4cso22800915ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 02 Jun 2024 15:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717368404; x=1717973204; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0+5/ASIZvtH/ev8M2o9akbPWGYFY5llwBthDu5pgQ3c=;
        b=W1/BzWgTHqEl0E8+ITUlBB2c6bDkZj0Ou3SjAIiVlKOP1zAh5ZwNFkDh3qECATdkAc
         Y7Qo+FMdg1/cE8MrFnRTqWLzpcnYzqr2dRNM/oXfX3GSziN6uZbUr5x00FKGkR9aYT4L
         LYoCPNxhsVhmzYUqLwBGiFd7t1HGABB8Wt9fFHvxvRjNCxo8DUIXiXz84cN3C2nsFaD2
         Mv7JDAInUAmEkBvVBNr0Y0t04I9hgaUPHQyCLCuHL+SzxUJB3Df90p/25OK5HPBKb5Vt
         iAQbcRXJH64OU0sJtiOj20Iens79jbt9qwTJCHjGlP5GMfSLx42CVzQcF+zq7UWWaJKC
         UCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717368404; x=1717973204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+5/ASIZvtH/ev8M2o9akbPWGYFY5llwBthDu5pgQ3c=;
        b=SGY06yxWAdhBQzP4Jlp5N8CXSANEhFQJfZtIx0Qk5exPn0CbQC7zxt59eYMSA5ycaz
         XOIrcvbfC6eKKWWKaOdJwm5eCpu34PZT6F7woQZOxk40nokpZufA2uatimm/LZDwVn17
         1+CroHri6pLrOaZ6aKqeCrmsqMKr60J+LRLwqN17fC3d2yW+UzkQwhJEGc8lzULorRoU
         efxecglacQylrreOh34Jh0wmsxTs41Jn00733DB2PUBEPtkIAGOsdTBgb5wUeL5NRENW
         045Uokf7RCLyzMAceLM9sCg/6cJlY6B1XguSonObzPJkN2FLSuVOm+esgif8Uxn/BEoa
         cvIw==
X-Gm-Message-State: AOJu0YyYLKPBo0ES73vgPPLC4qWwbNRiO5pHbdQ2OqCkiYlKz3HdCPTi
	JGOONoNnjEoi8wWO+BfShwvKRT2lkHC6DSMkB6jIlR0ySotYlITcoiGxx3SupJY=
X-Google-Smtp-Source: AGHT+IEUjWHLr0t2NBEBIIdSZuY2zu3leS99iYl4wQlznXo1NvIgKvAS4QpNDIeaK12ApukyeqkJkw==
X-Received: by 2002:a17:902:d2c4:b0:1f4:f1c1:647b with SMTP id d9443c01a7336-1f6370c1dafmr86021995ad.61.1717368404050;
        Sun, 02 Jun 2024 15:46:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63241cfecsm51223685ad.298.2024.06.02.15.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 15:46:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sDtyL-002BSc-02;
	Mon, 03 Jun 2024 08:46:41 +1000
Date: Mon, 3 Jun 2024 08:46:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
	brauner@kernel.org, chandanbabu@kernel.org, jack@suse.cz,
	willy@infradead.org, yi.zhang@huawei.com, chengzhihao1@huawei.com,
	yukuai3@huawei.com
Subject: Re: [RFC PATCH v4 5/8] xfs: refactor the truncating order
Message-ID: <Zlz2UCS4jqQO3Vm6@dread.disaster.area>
References: <20240529095206.2568162-1-yi.zhang@huaweicloud.com>
 <20240529095206.2568162-6-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529095206.2568162-6-yi.zhang@huaweicloud.com>

On Wed, May 29, 2024 at 05:52:03PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When truncating down an inode, we call xfs_truncate_page() to zero out
> the tail partial block that beyond new EOF, which prevents exposing
> stale data. But xfs_truncate_page() always assumes the blocksize is
> i_blocksize(inode), it's not always true if we have a large allocation
> unit for a file and we should aligned to this unitsize, e.g. realtime
> inode should aligned to the rtextsize.
> 
> Current xfs_setattr_size() can't support zeroing out a large alignment
> size on trucate down since the process order is wrong. We first do zero
> out through xfs_truncate_page(), and then update inode size through
> truncate_setsize() immediately. If the zeroed range is larger than a
> folio, the write back path would not write back zeroed pagecache beyond
> the EOF folio, so it doesn't write zeroes to the entire tail extent and
> could expose stale data after an appending write into the next aligned
> extent.
> 
> We need to adjust the order to zero out tail aligned blocks, write back
> zeroed or cached data, update i_size and drop cache beyond aligned EOF
> block, preparing for the fix of realtime inode and supporting the
> upcoming forced alignment feature.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
.....
> @@ -853,30 +854,7 @@ xfs_setattr_size(
>  	 * the transaction because the inode cannot be unlocked once it is a
>  	 * part of the transaction.
>  	 *
> -	 * Start with zeroing any data beyond EOF that we may expose on file
> -	 * extension, or zeroing out the rest of the block on a downward
> -	 * truncate.
> -	 */
> -	if (newsize > oldsize) {
> -		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
> -		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
> -				&did_zeroing);
> -	} else if (newsize != oldsize) {
> -		error = xfs_truncate_page(ip, newsize, &did_zeroing);
> -	}
> -
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * We've already locked out new page faults, so now we can safely remove
> -	 * pages from the page cache knowing they won't get refaulted until we
> -	 * drop the XFS_MMAP_EXCL lock after the extent manipulations are
> -	 * complete. The truncate_setsize() call also cleans partial EOF page
> -	 * PTEs on extending truncates and hence ensures sub-page block size
> -	 * filesystems are correctly handled, too.
> -	 *
> -	 * We have to do all the page cache truncate work outside the
> +	 * And we have to do all the page cache truncate work outside the
>  	 * transaction context as the "lock" order is page lock->log space
>  	 * reservation as defined by extent allocation in the writeback path.
>  	 * Hence a truncate can fail with ENOMEM from xfs_trans_alloc(), but
......

Lots of new logic for zeroing here. That makes xfs_setattr_size()
even longer than it already is. Can you lift this EOF zeroing logic
into it's own helper function so that it is clear that it is a
completely independent operation to the actual transaction that
changes the inode size. That would also allow the operations to be
broken up into:

	if (newsize >= oldsize) {
		/* do the simple stuff */
		....
		return error;
	}
	/* do the complex size reduction stuff without additional indenting */

-Dave.

-- 
Dave Chinner
david@fromorbit.com
