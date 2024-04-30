Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE89717107C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 13:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714482169; cv=none; b=HIwJZNHS6b+1ojBKS84uwjq3Zbl/buZVfRG0I1zL8Lg4TGDWekOYJljk/+lNKeWZMdV8bnRTjmUoNw5Eq/04zDH2sK5bmMHSMw5lipYNjho1eEB19CdTCSajy4qM+dRsNdENuIva9lWYBiPNTD9+MhzmDEpfRbfhSr0sm+7L8K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714482169; c=relaxed/simple;
	bh=uNA3xvlHg49E3hzcRGO5DiB55Ff++VuWM7eWoUi66a0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0h+ZyH3b7jQFbHhmXdP0Uc5lJ/QFF0NXV9ixSQRovyzpfqdYD0fiOgfSzy/VvhQHESk4vIG6dU8jPBN9fJvKMTnNgJG3XCqsyPZdbSZSaerBxvzzwV/CIZZZKrHGAle48tvtg8Jo4hT010JG0DyNlOVdJpo6UcM79QftvfIF5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y1fpQWBx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y1fpQWBx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714482166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJJVrbUvK84cKXJPWoMrD8EIdMaV6tJACMZb9O9Qsus=;
	b=Y1fpQWBxKXoHKUxWwD5xHz7HjYq+nYAg6IEO4h7mqmU3Ys0JpuaRZSc7BjYiOU93L5QKOs
	wTE7GlO6xvOJPGKiKF3k66Rl/um8RETu08vKC4BRN7CogcFVZcrXcNmNOtQeXimP4BIizr
	dwiq9luQJWPqaBO9zlw0aSoBVBWutKA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-ixmJn63KNF-VXti5TgDdqQ-1; Tue, 30 Apr 2024 09:02:45 -0400
X-MC-Unique: ixmJn63KNF-VXti5TgDdqQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1e45572fb3fso55578845ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 06:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714482164; x=1715086964;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJJVrbUvK84cKXJPWoMrD8EIdMaV6tJACMZb9O9Qsus=;
        b=dddvbIXLiM2mTJWHS/41jRoxtRuxmaon8HNLiO26bFr6ReVLUEOCBnUwWW5vCIFYfh
         PHsixzNKTs7Fxr4/kJDVpDD5kl4my5VVVveVtMBRqMKdk8NP5QE4LlDOCaY3JOoHMba8
         tpKU9uI05dh5jmHDHxbyHRpEp4Q+dgue7XcezNRjUAl9mWpFrMPJRmIg8AgQr6vrZTtp
         qQa1eviGnNsGY5G/YipB3iVQoqHwY6MyjVioWx6fzN6A5zMTOBfcWthD3uILTOFR3m/J
         bB89gP10mmU1WyiW01mFGCVD8u8f0932D5WFSp4AJMe4vuMh45eA1sqHKDgcs1Uyq61w
         Vh8g==
X-Forwarded-Encrypted: i=1; AJvYcCX3VqPrVRA7Ncfb3D1kM/SxjJwSraPNgFC2B3mb0KfM8cYjzmIoe59fmsRL7/LVDDupu0B+aRbNMB1elXS33vfW0uLDOQFC6umU
X-Gm-Message-State: AOJu0YxweX1VzvtlKX+dlqmYYgqiSfOlu9TW1Qmv3TTzIGxNfRBG6dZh
	Kzf+bxIGQ+m6F7cic/QKFa+PASMPaU4ggbEDYoL/lrxjdVyEoY+jFnl254zbVlDrD8m/hMAefa+
	K0PPK2cHj38CzbV/ZZ4O3nAqmSKZrX0nWah2jUDvQiKvPFEVK2JK9Mwk1LQ==
X-Received: by 2002:a17:903:264f:b0:1e0:e85f:3882 with SMTP id je15-20020a170903264f00b001e0e85f3882mr12076220plb.38.1714482164137;
        Tue, 30 Apr 2024 06:02:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOvnBcuyyK/ktO+06jlafUocaJJlNf9t8SByiwoWmCk0pXgZfDsndOSZjgLEWgwKxtO7xgFw==
X-Received: by 2002:a17:903:264f:b0:1e0:e85f:3882 with SMTP id je15-20020a170903264f00b001e0e85f3882mr12076040plb.38.1714482161634;
        Tue, 30 Apr 2024 06:02:41 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j14-20020a170903024e00b001e4753f7715sm22294731plh.12.2024.04.30.06.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 06:02:41 -0700 (PDT)
Date: Tue, 30 Apr 2024 21:02:37 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH] xfs/077: remove _require_meta_uuid
Message-ID: <20240430130237.dgbxexni2r3vf7ga@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240429170548.1629224-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429170548.1629224-1-hch@lst.de>

On Mon, Apr 29, 2024 at 07:05:48PM +0200, Christoph Hellwig wrote:
> _require_meta_uuid tries to check if the configuration supports the
> metauuid feature.  It assumes a scratch fs has already been created,
> which in the part was accidentally true to do a _require_xfs_crc call
> that was removed in commit 39afc0aa237d ("xfs: remove support for tools
> and kernels without v5 support").
> 
> As v5 file systems always support meta uuids, and xfs/077 forces a v5
> file systems we can just remove the check.
> 
> Reported-by: Chandan Babu R <chandanbabu@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs    | 15 ---------------
>  tests/xfs/077 |  1 -
>  2 files changed, 16 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 733c3a5be..11481180b 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1232,21 +1232,6 @@ _require_scratch_xfs_shrink()
>  	_scratch_unmount
>  }
>  
> -# XFS ability to change UUIDs on V5/CRC filesystems
> -#
> -_require_meta_uuid()
> -{

OK, I thought you might want to add a _scratch_mkfs at here. But sure,
I'm good to remove it too.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> -	_scratch_xfs_db -x -c "uuid restore" 2>&1 \
> -	   | grep -q "invalid UUID\|supported on V5 fs" \
> -	   && _notrun "Userspace doesn't support meta_uuid feature"
> -
> -	_scratch_xfs_db -x -c "uuid generate" >/dev/null 2>&1
> -
> -	_try_scratch_mount >/dev/null 2>&1 \
> -	   || _notrun "Kernel doesn't support meta_uuid feature"
> -	_scratch_unmount
> -}
> -
>  # this test requires mkfs.xfs have case-insensitive naming support
>  _require_xfs_mkfs_ciname()
>  {
> diff --git a/tests/xfs/077 b/tests/xfs/077
> index 37ea931f1..4c597fddd 100755
> --- a/tests/xfs/077
> +++ b/tests/xfs/077
> @@ -24,7 +24,6 @@ _supported_fs xfs
>  _require_xfs_copy
>  _require_scratch
>  _require_no_large_scratch_dev
> -_require_meta_uuid
>  
>  # Takes 2 args, 2nd optional:
>  #  1: generate, rewrite, or restore
> -- 
> 2.39.2
> 
> 

