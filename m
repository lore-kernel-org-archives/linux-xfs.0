Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF05C74BF1
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 23:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709249211; cv=none; b=W18dS+xfhl+CWmlQlvllEGR5o7pgqBxyXRsO5rGA37vb69Sp4kyfu8OuVe+bhDr8hZldExrr/bjgDmFKpP++E2QKjG77jVyqAvoFGZKVr12TnGCU9FEzHHV7z9TvJGQwtRUbwivdSzR8O455e5xUk+P5TzEpy6LF19sLynirIq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709249211; c=relaxed/simple;
	bh=vFGe/JPM+D98FYRCFhoM8TP+K+kv3fj2cPK6Z4iL8bQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jI9p7FJU3IXFIsCeqbFfax2iBYq/yLSx1A8FnczYg2n4yPA+J5w3O5NsfmtsSFO02GSHg4Onbm6BhGuLZa6mkOcuJ7BbF8Qzt3mf8NSgVuh0yw2/llmAsBRV/m42qc+ntTDtMBOzS/8kBVF0qTGiAMr1tcL2xM+6cW8hAc8pOdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xM8dEdSI; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xM8dEdSI"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5cedfc32250so1303877a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 15:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709249208; x=1709854008; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=grHdyJH43EDqTr7lOlPpsv2LnOtPCDv7mkz6AEIU0ok=;
        b=xM8dEdSI0/FTFjeiVslj0L5JrHinrkZRbK0wIXgaF8BK0/xXK48R39MUEVILrw2tlZ
         0y/HJuwAJxr1wFMOoWiyYc3EtldxtiVFQgPvAeoOiXMAUMHcGUScmnsLYYWUbhyLyU6q
         pcaS1Expi4zbTjBNaun9f5cSG0m2dzOOiYpMW5OOG547M9uUewSBC6N3I4yUX3OoKPra
         5yAWS88QIpu0mxdp25Zi96Pl94/StNz/wZOGOQBGxoqeUxMxftRsNi7NgDEwTahvjtrY
         4DUiPcf8eGyEX1ShqWsUB0ZO7Fcd5+wrB6NhB2Z+EOKWDoS+fSOeQAT948ZgqnUtpbqz
         KWmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709249208; x=1709854008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=grHdyJH43EDqTr7lOlPpsv2LnOtPCDv7mkz6AEIU0ok=;
        b=e49IS7MoGRi05/dO3LExktI0BQ3z/hUpxtjpnVSMRgFERDWWOp4G8Qh+UBCcQEnDOU
         EQO3FozK9kXmdKwJUVtzHebpA1Guyk3MScs04IeD5sveUTp6lRU8g0FrLrSRLGy4zgnf
         TjGxdIgeHUi+VYuTYmy/4Ou7OdJZjYjxZO+rTsU8rDt7CxPpuS6Aqecs64UEEjQSVJdr
         x0np25qSgWhtp2hOagjbntySbtZgfNXVUjyR4nnfcHjTF05f+0eyv/zwdN/h7P0S1BQh
         n+kSYzdKIKFJ/sA2aCeA9o7tq8rUrMoq7gEHYnrs1Vd77FwmM12wrmkOfaxaxgOB2b9w
         7PKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNLXVM1GZCuE6HPbFIPDsM+iES5OncnUv62CQfYvPwKJJswuIdrbX7bsAqtEeYNzdEjGkzCU+FCPQ1q1WMLt7bLBKiqI1p4KTf
X-Gm-Message-State: AOJu0Yx+lZ7YRg3xhIMg4YyiVgQnR+g8dLJ1a/lkx9ya374mIwWApoof
	dm5qBMO97qTL9uzQdw3A/yA4pKzZUMgDrS08GkFB8bZFsI9i1rJXMD0zIcWGmqU=
X-Google-Smtp-Source: AGHT+IGiSfuRv3Y76uLW0YYRJRv2KJMhOadB6A35s9PgdU0SN6q4L74ZxSAPem4Amsho3fTWY8H25g==
X-Received: by 2002:a17:90a:a618:b0:29a:795:a132 with SMTP id c24-20020a17090aa61800b0029a0795a132mr99168pjq.18.1709249208246;
        Thu, 29 Feb 2024 15:26:48 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id sj5-20020a17090b2d8500b0029ad78306d8sm4245337pjb.3.2024.02.29.15.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 15:26:47 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rfpnY-00DJUd-1S;
	Fri, 01 Mar 2024 10:26:44 +1100
Date: Fri, 1 Mar 2024 10:26:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: kunwu.chan@linux.dev
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH] xfs: use KMEM_CACHE() to create xfs_defer_pending cache
Message-ID: <ZeEStFZwMu068YTc@dread.disaster.area>
References: <20240229083342.1128686-1-kunwu.chan@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229083342.1128686-1-kunwu.chan@linux.dev>

On Thu, Feb 29, 2024 at 04:33:42PM +0800, kunwu.chan@linux.dev wrote:
> From: Kunwu Chan <chentao@kylinos.cn>
> 
> Use the KMEM_CACHE() macro instead of kmem_cache_create() to simplify
> the creation of SLAB caches when the default values are used.
> 
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 66a17910d021..6d957fcc17f2 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -1143,9 +1143,7 @@ xfs_defer_resources_rele(
>  static inline int __init
>  xfs_defer_init_cache(void)
>  {
> -	xfs_defer_pending_cache = kmem_cache_create("xfs_defer_pending",
> -			sizeof(struct xfs_defer_pending),
> -			0, 0, NULL);
> +	xfs_defer_pending_cache = KMEM_CACHE(xfs_defer_pending, 0);
>  
>  	return xfs_defer_pending_cache != NULL ? 0 : -ENOMEM;
>  }

Please stop wasting our time by trying to make changes that have
already been rejected. I gave you good reasons last time for why we
aren't going to make this change in XFS, and now you've forced
Darrick to waste time repeating all those same reasons. You did not
respond to my review comments last time, and now you are posting
more patches that make the same rejected change.

PLease listen to the feedback you are given. Indeed, please respond
and acknowledge that you have read and understood the feedback you
have been given, otherwise I'll consider anything from this email
address as "just another annoying bot" and killfile it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
