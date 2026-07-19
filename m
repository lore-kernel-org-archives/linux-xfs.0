Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24A130D406;
	Sun, 19 Jul 2026 20:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784494653; cv=none; b=O4iyhlr/OA+v82v8udh3uM9TyPk0VvgUuLBKk+UKSflRQTfNoW1d0zAotf3qMNXvSz5WCdUVEQmQjNljA6uGZR9uDr+ZL0dfjMstnhugbtx6z22aKrxlAU41tCVImPlE2GpN+SXZWQgCnZqrgqh6o0YDs1GqWF9aqgJHeULMkYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784494653; c=relaxed/simple;
	bh=uQCMPOJFD1ZWLft0T131Bbj2cHG7R/CC4tHIoK4sufM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RlJo2dxCGv1Dgp2Kp9203wbYPzZoliZiQZWx5/crapjFmy6s998ctWVtu4HPAPtNDNdJRXaGf8WfKAhbB8W8ZE0qv1Xss6puou/r1xnK+3T21aLMr7tC3LGsmaiqJPZaEHs2JwgQfWB+Ej7eC2FZRRdE8x7Qcia1XcMt1/ffVx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Px0/OulM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Px0/OulM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68181F000E9;
	Sun, 19 Jul 2026 20:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784494648;
	bh=Kf/D2eGXofeqwU06mgJD2zI/DQOENIt/7RlYfrGzglk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Px0/OulMXHjLridg50I95gUYfcWrh709oeu1hQg+2u64ry9sGaMHSG0/UT7hAmPH+
	 6cNHP66EAgoprnTu2QgMWiW8Blq3j+G7uIjN4oPiADbyGfh2x1pJ4Aea+tNHdVEUs6
	 Qrug01ntXR0xV9jN2gHvXq5fGIDgE8qG69LFI6Zo=
Date: Sun, 19 Jul 2026 13:57:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: <cem@kernel.org>, <djwong@kernel.org>, <hch@lst.de>,
 <willy@infradead.org>, <hwenwur@gmail.com>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm: introduce memalloc_flags_move() for
 transferring allocation scopes
Message-Id: <20260719135728.cb036d8c922c5cea1e263ca1@linux-foundation.org>
In-Reply-To: <20260719095732.1813590-2-yun.zhou@windriver.com>
References: <20260719095732.1813590-1-yun.zhou@windriver.com>
	<20260719095732.1813590-2-yun.zhou@windriver.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 19 Jul 2026 17:57:31 +0800 Yun Zhou <yun.zhou@windriver.com> wrote:

> Add memalloc_flags_move() to transfer a saved memalloc scope from one
> tracking variable to another.  The source is zeroed so that a
> subsequent memalloc_flags_restore() on it becomes a no-op, effectively
> transferring ownership of the scope to the destination.
> 
> This is needed when a subsystem hands off an allocation context from
> one structure to another (e.g. during transaction rolling in
> filesystems), and needs to ensure the scope remains active without an
> extra save/restore cycle.
> 
> ...
>

Thanks.  fyi, Sashiko might have found a pre-existing xfs issue:
	https://sashiko.dev/#/patchset/20260719095732.1813590-1-yun.zhou@windriver.com

>  include/linux/sched/mm.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

This file isn't mentioned in MAINTAINERS.  Could someone please propose
a patch?

From the MM side, probably just place it in every record which mentions
include/linux/mm.h - close enough.

> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -342,6 +342,23 @@ static inline void memalloc_flags_restore(unsigned flags)
>  	current->flags &= ~flags;
>  }
>  
> +/**
> + * memalloc_flags_move - transfer a memalloc scope from one tracking
> + * variable to another.
> + * @old_flags: pointer to the source flags (will be zeroed)
> + *
> + * Returns the flags value to store in the destination.  The source is
> + * set to zero so that a subsequent memalloc_flags_restore() on it is
> + * a no-op.
> + */
> +static inline unsigned int memalloc_flags_move(unsigned int *old_flags)
> +{
> +	unsigned int ret = *old_flags;
> +
> +	*old_flags = 0;
> +	return ret;
> +}
> +

I've added linux-mm to cc here.  Please include it in any future
versions of this patchset.

