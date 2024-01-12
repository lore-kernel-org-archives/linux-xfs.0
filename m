Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1885D91A
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cPWcKX51"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705066332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7iaekVqJK9nhSOhPLHVUDDvK2n3hHVPlmo+CJ8u5AZg=;
	b=cPWcKX515aBSBnVuxwPsANLQuGqcGot2AhPJRc1gOuVWIFfje9iKJc9Xohf6if+8yNZ52Y
	VgKpPRKHOFFobDAssGvDc3RAXAfFjlvS0ysAsPts7S/tEPU6Mqr3F6C7aj2wqAIxCmblku
	w9jdvRxw7LVH2f7Vr6ycExLu++K7yBw=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-JGbpsI5ANHOzGRRTjFI05w-1; Fri, 12 Jan 2024 08:32:10 -0500
X-MC-Unique: JGbpsI5ANHOzGRRTjFI05w-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7baa6cc3af2so587444839f.2
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 05:32:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705066329; x=1705671129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7iaekVqJK9nhSOhPLHVUDDvK2n3hHVPlmo+CJ8u5AZg=;
        b=HKT7Kl/4px8D6ThNxh8xSNtiROsE0X7tD4N5o8wA2R99B913orPlv0gMss6Y/K7MbM
         LNm0utygpwV5b+J/vxMbAD2KMx1DNeJCxrMzom5XTpeekoUmNulWPOvcSstyREW6EMKi
         Xmg+CDdDPu/La8oKE71wOe2w6pkHfcal1s6mPyNUhFpSFMMozChQFokNDxq/EeZ74kwg
         Hp8/dhor/Djv/ssdZwxQ0HI0fmMtGcMPF2JAWNWiDQRom0yKF15RuPB8Xw/j/aCRD7mT
         N4ekZMZ71OBA6GRQH2rE258CehWhKYmrwitDJCHCig23nkndc2yKH+zlcl7W8zTeMk6Y
         UHvQ==
X-Gm-Message-State: AOJu0YzO/jnAzzFv3Ak4hcsubZodJcrvL5FerFh/bIFHkgf5F8BdrbnE
	LNEQ9bocsyG+gyQenUKQXknna4Z75ZUC/r9Oe6R0uglFEUHVimt/k7sqse5hh/Z/kV61Zjvt2Li
	0L978i6bp6AZU0POrJb5KBXQQPfPA
X-Received: by 2002:a5e:c008:0:b0:7be:37f6:b998 with SMTP id u8-20020a5ec008000000b007be37f6b998mr1439915iol.21.1705066329472;
        Fri, 12 Jan 2024 05:32:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGei0sml5KQOOeE2JfPQSxzZ5dH/BhexoU6M7HuaZQoZG0x3OIX+3aD12uDrLEgBGGZVkev5A==
X-Received: by 2002:a5e:c008:0:b0:7be:37f6:b998 with SMTP id u8-20020a5ec008000000b007be37f6b998mr1439899iol.21.1705066329165;
        Fri, 12 Jan 2024 05:32:09 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i7-20020a639d07000000b005b7dd356f75sm3131010pgd.32.2024.01.12.05.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 05:32:08 -0800 (PST)
Date: Fri, 12 Jan 2024 21:32:05 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: add a _scratch_require_xfs_scrub helper
Message-ID: <20240112133205.yvdeh27in7l4qzu2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240112050833.2255899-1-hch@lst.de>
 <20240112050833.2255899-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112050833.2255899-3-hch@lst.de>

On Fri, Jan 12, 2024 at 06:08:31AM +0100, Christoph Hellwig wrote:
> Add a helper to call _supports_xfs_scrub with $SCRATCH_MNT and
> $SCRATCH_DEV.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs    | 7 +++++++
>  tests/xfs/556 | 2 +-
>  tests/xfs/716 | 2 +-
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 4e54d75cc..b71ba8d1e 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -662,6 +662,13 @@ _supports_xfs_scrub()
>  	return 0
>  }
>  
> +# Does the scratch file system support scrub?
> +_scratch_require_xfs_scrub()

Usually we name a require helper as _require_xxxxxxxx, you can find that
by running `grep -rsn scratch_require common/` and `grep -rsn require_scratch common/`.

So better to change this name to _require_scratch_xfs_scrub. That's a simple
change, I can help to change that when I merge this patchset.

Thanks,
Zorro

> +{
> +	_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || \
> +		_notrun "Scrub not supported"
> +}
> +
>  # Save a snapshot of a corrupt xfs filesystem for later debugging.
>  _xfs_metadump() {
>  	local metadump="$1"
> diff --git a/tests/xfs/556 b/tests/xfs/556
> index 061d8d572..6be993273 100755
> --- a/tests/xfs/556
> +++ b/tests/xfs/556
> @@ -40,7 +40,7 @@ _scratch_mkfs >> $seqres.full
>  _dmerror_init
>  _dmerror_mount >> $seqres.full 2>&1
>  
> -_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
> +_scratch_require_xfs_scrub
>  
>  # Write a file with 4 file blocks worth of data
>  victim=$SCRATCH_MNT/a
> diff --git a/tests/xfs/716 b/tests/xfs/716
> index 930a0ecbb..4cfb27f18 100755
> --- a/tests/xfs/716
> +++ b/tests/xfs/716
> @@ -31,7 +31,7 @@ _require_test_program "punch-alternating"
>  _scratch_mkfs > $tmp.mkfs
>  _scratch_mount
>  
> -_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
> +_scratch_require_xfs_scrub
>  
>  # Force data device extents so that we can create a file with the exact bmbt
>  # that we need regardless of rt configuration.
> -- 
> 2.39.2
> 
> 

