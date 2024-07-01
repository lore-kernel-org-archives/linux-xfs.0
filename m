Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975AD3D62
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 02:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719801229; cv=none; b=uBXx+pBjm6PdPEj0XSU25auC9z+kqOpizrqUZ1xhfQQLVJGNZBHvbVkwmZqlrUAIZDiMTJ80zTQ/pvDw3j+hevMKi/TDXR5mocarahrw/Ku3t8MW0li3x1OImW0OdSrVB1Rjb8ySF25xWI+/XrckHcS94ncQ8/MTihoAzfBG0bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719801229; c=relaxed/simple;
	bh=Tzz6OH3xcrTyBiwZpsOD58wxZR4RscGIx7I08rw0hko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJ8+pPGLJN4feD4S07fqf/58OJYgtIy4CQp4yPCrYnh+BdxgpDF4O6oLdm1VSHXONzd+FObELFEDLyu9/DPa85iFwy+vavoRUFdnCuRWA+Qz5SUOjHAmmLH/aA6ZcG8aWzrcyh5ntt7mhEK6sqEaCl2AsOBG79IQCL2Dmsai3xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=sGVtzYc8; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="sGVtzYc8"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e036eabc97dso1179235276.3
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 19:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719801226; x=1720406026; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rAT5VJO6josRz7Xd2YJx3BcgEAz55TMwlzh28Gf/4Kc=;
        b=sGVtzYc8mINDq0tXtChFz1lvJpzOZreKheKasEEZx2t9rH9XifuUYIMEZCqVl+DQz6
         c40Pu9WDJGbZ1qJwPqY7KvFZ7nEhtjdczUqW375i8RArmsKpBhLkfnDAQzR9FX06kFb1
         j3SkvkKnz3gybjyDu8qteRk5QEQMxQMoHFhNgVQ8UgRV4Z6hatV6uw19dUyDDRweapgI
         HtVNtjkxs/JJVJ/0mQTed7WElsY0littWwIasISXsjGPzUFarDggIWZNwzipjpF3rRiq
         pfEHlD+fM5c9mjpQheQcc6hu3VOPWlK020jKawXEftSTf3fd5XHM0d6rM+30m3NUKv81
         Hv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719801226; x=1720406026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rAT5VJO6josRz7Xd2YJx3BcgEAz55TMwlzh28Gf/4Kc=;
        b=eP9hd65ACRIg0Xqk7AgV2DJ0FbTApGfst2cY4bW7g0bg/YvBLFjRDgCwObqV2xWWsf
         wzw9rhm04Dfyz1RS1U6nUvg88ZnB7navEvr2puMIhfA8h1hfOvOQX+vUJpjE+7nAldFO
         +HhW568wcPCzBmkd3+NtYOofdT4Pm2N4FM9tBWOwosPTWCALcE6pcraPEUSHFdhP58mD
         8EcNlnguNWkxT0f5mFVoSTAbIA6DNqpqCHKBvMhCXGuJdtBI6bZ419cacXyKPTHGyl3g
         BGXUodgjUbVeOixMS/41FdQnkjf1YIV454dJQUkwYKwKMlVGSj4dl7spslY5OL93eFAG
         6Cww==
X-Forwarded-Encrypted: i=1; AJvYcCV6Vbp/1+fJg7pXsLdXZbP0SO3nRzvCSAZ6QfVfhWRwvPG240xqWJJM35a9A7Fdkue5jYC7ecnGPDdghuEcSJNgyhXLBD0TDMBH
X-Gm-Message-State: AOJu0YwXCpm3xJJd4rEW+rM9QpARodBGJgzF+VmGVsOMnp9TGQI6OO1x
	12oeYsP3vU/APD/jsI9O3qTw6RFpKW2BK/WbQLjRn47TpoNh0bSjLBxY6pTlgn8=
X-Google-Smtp-Source: AGHT+IFPkkSrPPqv4X4aSJd3e/zTZRULT6hsrrhdjadbuvfh9lj4wv9ZexQEyZCPWxG2Sz5avisCCw==
X-Received: by 2002:a25:c307:0:b0:dfd:b3bb:ac11 with SMTP id 3f1490d57ef6-e036ec8b54bmr4805340276.59.1719801226290;
        Sun, 30 Jun 2024 19:33:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6a31b463sm4237653a12.21.2024.06.30.19.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 19:33:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO6rP-00HQxp-12;
	Mon, 01 Jul 2024 12:33:43 +1000
Date: Mon, 1 Jul 2024 12:33:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: willy@infradead.org, chandan.babu@oracle.com, djwong@kernel.org,
	brauner@kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, yang@os.amperecomputing.com,
	linux-mm@kvack.org, john.g.garry@oracle.com,
	linux-fsdevel@vger.kernel.org, hare@suse.de, p.raghav@samsung.com,
	mcgrof@kernel.org, gost.dev@samsung.com, cl@os.amperecomputing.com,
	linux-xfs@vger.kernel.org, hch@lst.de, Zi Yan <zi.yan@sent.com>
Subject: Re: [PATCH v8 08/10] xfs: expose block size in stat
Message-ID: <ZoIVhyNjgtkmvvBt@dread.disaster.area>
References: <20240625114420.719014-1-kernel@pankajraghav.com>
 <20240625114420.719014-9-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625114420.719014-9-kernel@pankajraghav.com>

On Tue, Jun 25, 2024 at 11:44:18AM +0000, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> For block size larger than page size, the unit of efficient IO is
> the block size, not the page size. Leaving stat() to report
> PAGE_SIZE as the block size causes test programs like fsx to issue
> illegal ranges for operations that require block size alignment
> (e.g. fallocate() insert range). Hence update the preferred IO size
> to reflect the block size in this case.
> 
> This change is based on a patch originally from Dave Chinner.[1]
> 
> [1] https://lwn.net/ml/linux-fsdevel/20181107063127.3902-16-david@fromorbit.com/
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/xfs/xfs_iops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index a00dcbc77e12..da5c13150315 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -562,7 +562,7 @@ xfs_stat_blksize(
>  			return 1U << mp->m_allocsize_log;
>  	}
>  
> -	return PAGE_SIZE;
> +	return max_t(uint32_t, PAGE_SIZE, mp->m_sb.sb_blocksize);
>  }

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
