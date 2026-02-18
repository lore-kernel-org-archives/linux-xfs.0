Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E202FD1B3
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 10:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771409894; cv=none; b=TGxrvV7AvY0tBUMh9aV6cI9ArtXl+YnVfgt46HxQXgKnbhrBP09ufrH652FK8NYV5ttzah7lpdmTT+J846ETn3AZurH4xZY1V0BK/Ko/NiZ5gGzKsy5StbPyNncyUVKEnWA+ScfHO6WDNkwG7dXjci6R2M45sQksGsg0LiNXolw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771409894; c=relaxed/simple;
	bh=hEkOYoZ+YvzCIzyqbCCHiW1cU9u4+rx18WM/qq/4Keo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dfD1v5BHTdkJha0BE56zcnOXVfWkU9dXrF10HZbpM6mkxaqwadekkHxOirEfRRg77pc/SUA/vPk+lBYZUMW+E7hk+qju5aXx4NCWjb1aTy2OPr93h3CHBKM5to2UwFg0z7/WJIwVwca+BGwZ690klghE26zkLep8+M69qGmAxoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IawcHVff; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oUr6bhcG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IawcHVff";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oUr6bhcG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771409892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CdumppwhlBUdillyHNoUIaTpT4tIY7ONjvEdXG67S8c=;
	b=IawcHVffD/nTBk1rM445HefuamTY+jQe+7rPwgloJUA6jj7+a8ieGq0b4mHU+NcE4m1HZY
	lghGyWbL9/IzwVG83CYkF09LbiVHVIkAb/xiZOD8B6iDMKR+vZG47jAFN8rQcegxzp1CgH
	SclVyddER0IbOsjr3YhVV7EjRITvA3I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-oMcQPDZuP52WtbCF7FIFuA-1; Wed, 18 Feb 2026 05:18:10 -0500
X-MC-Unique: oMcQPDZuP52WtbCF7FIFuA-1
X-Mimecast-MFC-AGG-ID: oMcQPDZuP52WtbCF7FIFuA_1771409889
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4837246211bso54003415e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 02:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771409889; x=1772014689; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CdumppwhlBUdillyHNoUIaTpT4tIY7ONjvEdXG67S8c=;
        b=oUr6bhcG2x4YhoM/N/QevpH+wQFl9gQQM9KVdzimEPUNex9wrf6w9Oc33XuXrOVLgE
         RJ792Rw8QwEhuC++XXoDDDYjVo2+sEEu1HnuFBjoH9nvg8+1WE4zM8tTm2NX4FEr4EQB
         66bqrMdNnlS9Y/l1rK6TkuW82MUgxeLjtBbgiSBi1COh6BVJP7U7GFi1yhfU3kCUSbsh
         AXyPhtHw8WZ1xVzegH4gX2RJ3rMUsFKp8lmKLLdnTVBYvrY2FloOCImx0GyfSpDkM8De
         cT008TvD6checaEAQ6FfI6gH24EaIw+SIxdaVoK2MpcM0Zr7WTOAV07gkwTd7KTT3GmS
         cmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771409889; x=1772014689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CdumppwhlBUdillyHNoUIaTpT4tIY7ONjvEdXG67S8c=;
        b=kfbtnAgmHVGf9Ad2o8+oTtvPq/WTw3MEaRLVw0qDxfQlFYaCvjOFOYOspVHNDI1DRH
         g2dotmJvkcyFy4aSSVXw1kJcOJ8+sOaX4x2Ogw103Dnh0ClToFV51iD9qoGBsm+UN7Cp
         xjRCtELNhNhRV/QBFY8vB1o2So8mcK75t4+kCPl+GFHvJG8+789l+0lFjXeh7S31cByz
         xkX1gMALHeYKPhBsDnlS+suyg/liP4Sqy6KIceGCcPQOkLgmqOkthrIop1WU6ApEIiUD
         YtjdgD62Qzo5DLKtOIhSuy8EcPVqh1ireItVCdIIH08SjhIBpzsX6WgPU6iV1TdlFWxp
         R0FA==
X-Forwarded-Encrypted: i=1; AJvYcCUWnmJab2bvOWlmB9Cm0zHR1JKsgaoAK0VIK/6Zkn/jNg/hKg/WmeY/O63Zi5wxdEYkvrfcocfMFo4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+3VzcR++8ZC11tlcubalV2FxCp3onuUcnVXunYS7iGpOhyjlJ
	mam5S1yvpKJOZvgPissazb4vS2ATS6Qbf2WeQ5r9j0PfuIkMJevguptAL8rO0wdQS8bLI6oji/u
	Y9v8cOQel3PHVfXwNP9cW+aB/DmZjjPXKeX6GLT3FFkw+RVECTC61lFuJfgdm
X-Gm-Gg: AZuq6aJhZuOT3VNVsr0qcy908iEAHvO683n818E63Ci+hvWtALkn7kFxJ9Kals6M97A
	Qvq9E1KC3etojqG+Fxm5q27Ww9Ezr//tQDWVJY+yjY1FSa/ioZQta1d+F17zcGWAXMmU8G7WFrf
	S+W/7ArjmJGEUwLOjX/viE229oZQQMj6nYUtVDlWkQHjK9krNFIOmKXGjBB4WLplgFu25mPfXsW
	1M/xjcR+Bzfqoz8As0IvddT0RrdEJq1z5zn3++vyQtS+iA4BygdhZ3dXPwuzXZyUtMGYy4LUCp0
	h/kA/oRYQl1/WpJZk4DzwJP+QksHBXaO3ardLZlXL+by4d/N58ufGvs+Wp3W3UekBsKSVAExkn2
	kUG+01ToX2yc=
X-Received: by 2002:a05:600c:19c6:b0:480:3bba:1ca9 with SMTP id 5b1f17b1804b1-48398a65e5cmr24011405e9.4.1771409888922;
        Wed, 18 Feb 2026 02:18:08 -0800 (PST)
X-Received: by 2002:a05:600c:19c6:b0:480:3bba:1ca9 with SMTP id 5b1f17b1804b1-48398a65e5cmr24010895e9.4.1771409888328;
        Wed, 18 Feb 2026 02:18:08 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48398244e83sm29376605e9.2.2026.02.18.02.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 02:18:08 -0800 (PST)
Date: Wed, 18 Feb 2026 11:18:07 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 22/35] xfs: add iomap write/writeback and reading of
 Merkle tree pages
Message-ID: <zpdrihys2jk2duk3o76ao4tykc4o7adree2lf3dqzuiqggcaka@xnmbkzswbmpz>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-23-aalbersh@kernel.org>
 <20260218063521.GC8600@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218063521.GC8600@lst.de>

On 2026-02-18 07:35:21, Christoph Hellwig wrote:
> > -	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
> > +	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags, XFS_WPC(wpc)->data_seq);
> 
> Overly long line.
> 
> > +		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION)) {
> > +			wbc->range_start = fsverity_metadata_offset(VFS_I(ip));
> > +			wbc->range_end = LLONG_MAX;
> > +			wbc->nr_to_write = LONG_MAX;
> 
> Shouldn't this be taken care of by the caller?

hmm right, I will update filemap_write_and_wait() call in
xfs_fsverity_end_enable(). That the only place writeback of verity
metadata is requested.

> 
> > +			/*
> > +			 * Set IOMAP_F_FSVERITY to skip initial EOF check
> > +			 * The following iomap->flags would be set in
> > +			 * xfs_map_blocks()
> > +			 */
> > +			wpc.ctx.iomap.flags |= IOMAP_F_FSVERITY;
> 
> I'm usually a fan of more comments rather than less, but I don't think
> this adds any value.

Sure, I will rewrite it

-- 
- Andrey

