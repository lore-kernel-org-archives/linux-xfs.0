Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FFFB673
	for <linux-xfs@vger.kernel.org>; Sun,  3 Mar 2024 13:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709471458; cv=none; b=taPgvEJ0U82q+jkUSDuh3E/AoKFnS2DWnq7Jq9pXqgMB7Y4zuufJ1Pd9tF9u5ahdU9ctCAftM2nsHPc+1GS3lGa3Jr7qA3pfI8avXqOQnFr8MfhGpjy+sf/3l0Omka2xkwEMuP0F4zeLqPfdVH3uWhoT93+I8aeW00xcdR29Ino=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709471458; c=relaxed/simple;
	bh=aTMzKaZRxU23i409OjT26LlFjB63Hs/hnKqJHhzYDYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RySej3LQlUXwum7FEYcDU8jshbVvYCHyGcijrhFPfHwlQ/wLAxKNlUekLMEhg0m9rVdn5jl/yIvjmW80wyDJIqRTJnV0fxzedGQPKHj3x/eEDcEzoOdQXN4S+/Dh50Nx4EG9B622RWR5DvhsHf+Ehx4h+WanPuyXMPZ1PAoUL+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lv2T76GV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lv2T76GV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709471455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K7+CBVUOb3nwftCqW3xQMHPRcaIeoQg9DrW8Xr4mB3U=;
	b=Lv2T76GVX6pjuT8zOz7BU2nu04pozdRKLuRo+4VEBPxblmnaXngYzs2I8wiTcQoDxRQYUp
	2LVvozY+f5i3yAO3E5HC3tPP/pN7slYACEUDXobbvEEjT5weSz6mpC+Hk48HbalwrCn36A
	8K+6ZVQ1yO3UxqsqfSCC0f0MoKB5/qE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-ARuUYUuaOcKbH4M22zJrxA-1; Sun, 03 Mar 2024 08:10:53 -0500
X-MC-Unique: ARuUYUuaOcKbH4M22zJrxA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-29ae60ce114so2389102a91.1
        for <linux-xfs@vger.kernel.org>; Sun, 03 Mar 2024 05:10:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709471452; x=1710076252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7+CBVUOb3nwftCqW3xQMHPRcaIeoQg9DrW8Xr4mB3U=;
        b=Lxwok89TJgEfGkT2ubz3DRzPPZc/UlnDVZ2MfSK/Cw52Mnt2VjsbzLGPNFoNhO8t/a
         AkRSSNKwDiMapnLyW/P0kxwa3HH11U6GGKgOeLHtvPxVlqW+w2x5ctDz7khvY+Ppuuwg
         sS19h1mIrEax7WG3ag1pw2eFu1ANUzwFgntUQGDwnpmYsCHNubw5NK3V6cpgxlIDiymS
         JX4AwQRz7vofQFqvj2YQElG1eGklULCGpfR4IPL/0qtxvFSaNJfsiiWaGu98skR9+imv
         egLSXmdsodAZ8CdJhl590Nm9eY1HYybxRSP/FT5UVwF91Jl/Lbf9OUx5Ykd+gUlvZJlV
         f6BQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtgXI7mGSgutOFQcFOBf6pAiVMWYx01JQBv8Wa+MNqyYT3gIMlS91aZdBVVblGcSKMxqy/nu4uz3hoeHpgK6n3c37wLDdpLgIa
X-Gm-Message-State: AOJu0Yw2Ay70wp1+62L3OhHEpTU5hsDy1HTTQEaiSvK8rTi2gd1z19pT
	TXiLb27TfxhiV7iV+tm00GCftOiMgVhvfTdhdH4H6w3gmdq+25YlGN/GH5oxVnpLpOeH3aY7e+v
	jH1zMdXNONBtEA9n/mro1JSiREz7++iAMs4MYf/7FJcnQZy1OgoPh+qQoH6f41vVA7Y2F
X-Received: by 2002:a17:903:288:b0:1dc:df18:c5c1 with SMTP id j8-20020a170903028800b001dcdf18c5c1mr6473853plr.33.1709471452158;
        Sun, 03 Mar 2024 05:10:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0JtfiD4ETPl4rGH/BswkXyPj0FZ70SYDWMJOlWEhTAhFy3wQuGYIewUydxmrq5H/Mq39Cig==
X-Received: by 2002:a17:903:288:b0:1dc:df18:c5c1 with SMTP id j8-20020a170903028800b001dcdf18c5c1mr6473830plr.33.1709471451688;
        Sun, 03 Mar 2024 05:10:51 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c20c00b001dbab519ce7sm6584824pll.212.2024.03.03.05.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Mar 2024 05:10:51 -0800 (PST)
Date: Sun, 3 Mar 2024 21:10:48 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] shared/298: run xfs_db against the loop device instead
 of the image file
Message-ID: <20240303131048.kx4a4b2463deud7t@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240301152820.1149483-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301152820.1149483-1-hch@lst.de>

On Fri, Mar 01, 2024 at 08:28:20AM -0700, Christoph Hellwig wrote:
> xfs_db fails to properly detect the device sector size and thus segfaults
> when run again an image file with 4k sector size.  While that's something
> we should fix in xfs_db it will require a fair amount of refactoring of
> the libxfs init code.  For now just change shared/298 to run xfs_db
> against the loop device created on the image file that is used for I/O,
> which feels like the right thing to do anyway to avoid cache coherency
> issues.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/shared/298 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/shared/298 b/tests/shared/298
> index 071c03dee..f657578c7 100755
> --- a/tests/shared/298
> +++ b/tests/shared/298
> @@ -69,7 +69,7 @@ get_free_sectors()
>  	agsize=`$XFS_INFO_PROG $loop_mnt | $SED_PROG -n 's/.*agsize=\(.*\) blks.*/\1/p'`
>  	# Convert free space (agno, block, length) to (start sector, end sector)
>  	_umount $loop_mnt
        ^^^^^^^
Above line causes a conflict, due to it doesn't match the current shared/298 code. It's
"$UMOUNT_PROG $loop_mnt" in current fstests. So you might have another patch to do this
change.

> -	$XFS_DB_PROG -r -c "freesp -d" $img_file | $SED_PROG '/^.*from/,$d'| \
> +	$XFS_DB_PROG -r -c "freesp -d" $loop_dev | $SED_PROG '/^.*from/,$d'| \

As this patch focus on this change, so I'll only make this change. But if above
"_umount $loop_mnt" is needed too, please tell me.

Thanks,
Zorro

>  		 $AWK_PROG -v spb=$sectors_per_block -v agsize=$agsize \
>  		'{ print spb * ($1 * agsize + $2), spb * ($1 * agsize + $2 + $3) - 1 }'
>  	;;
> -- 
> 2.39.2
> 
> 

