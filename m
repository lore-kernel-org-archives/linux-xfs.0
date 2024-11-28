Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB20383CC1
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 07:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732780601; cv=none; b=gqrOfRTtF8mR4ObYCFHFfxXdK+0pYhK9aTNdHqEUaRRKjFemveoas+lpJNULNSQmiPPxUBBnaw9V3Y3q9K5QZpS8W7LhtOYvN8xTx5uuWb93noq6ASM21WEtPZJZMaVBTWdjW3CznPgbLVUyFyR6v6go35E/uu7yE72QiJS7xVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732780601; c=relaxed/simple;
	bh=T7o7PMjFfZptSONdxwQaXlra6xoNgrVYA5Z1HsJ6hFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iE4MzSqWFvFOz4ZXzVGmYBjlsUZq/wEklonthAV6xfCwSxdnyDwCZ07oZPm12Eq6LmlulfNnQSmZSJ68XBuKLtMEoxYNkhFgAgr9iBc9Of99Zafg2dL56VQuNXzy30DJFPaisf/AHiixvUKODUubBVsC+8pUeJ9ExTv9sCCLIBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QyPuiGQR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QyPuiGQR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732780598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=71i9ce2I/uQhJTU9bdlTAGRpoIBRp3TYA/+yze5rhMs=;
	b=QyPuiGQRs9sSDrydqL3TeKPw/sGNg6Aw6H2A1IAWK9RJGyM7mH59tJ4oFm6tBEEq7ey9K8
	UG043sqnlAtfQ3YjesYwg1yRjr4knmoz9VCO5kIuuooTR1c8a+/SuQdh7o2Gpe2ycyhnLO
	fEIedNcMqN5NHKzd+1VL2RCVMZpzb7E=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-89GXoADHML6qDyR64_8nuw-1; Thu, 28 Nov 2024 02:56:36 -0500
X-MC-Unique: 89GXoADHML6qDyR64_8nuw-1
X-Mimecast-MFC-AGG-ID: 89GXoADHML6qDyR64_8nuw
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2e5efb04da7so665640a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 23:56:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732780595; x=1733385395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71i9ce2I/uQhJTU9bdlTAGRpoIBRp3TYA/+yze5rhMs=;
        b=MOkXntu96rQ76aFIzfrPS+G8cNZWhLWTP1vjo4gGsEAgPSTchu/M5YqmY7ONQ6eUGu
         bbbP0YfMmnsxeNLn6ZKMqpPh513wqxMxGKZK4qgVoUPGvRxawFOB1/0C16/o1FDsRYMr
         8oBi7ZJ3vaXS/QAL5WYKrAYyh0u78z/2AJGARHxJIHC74VPO0JTrv0fP5gQPbqtlKaYN
         wjq8IeRBTAF210eZJLORyJ1v85Du8IN6smCWHP8o6Dz3Dh3YC3WoVrMhrEpG4Znfim1o
         beTY/kHEWN/j/6/wYPtUmEtWUvjBowUb77anj3oYGZaGpYjUVceMPySbtgDhQgfMbDMM
         ychg==
X-Forwarded-Encrypted: i=1; AJvYcCW8fdkxf/wtEXVsPjnzRGCuJQy/VKlTDE2PpwtBNbfAdbf/+cQtmXliaPOlNIi0mG7830pQYR53Ut8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk6RMNbN+++nFIlBTiorapJJt2/4bIVXR/HYGs7K3+5J4w6vdG
	De+YElJZwEnmGHq0kuWzwC5kIJkwhpNIEZT4xhX2YoEGEPsdwu7qM/7whnGldCoRmZDbx36pYgX
	UYO77ohjcAA2lSFI7WcNlx5Iz2BnSwbJ1sk4V36maq4Xc91xA2q/5Dc7MyK3dx6Ppc0me
X-Gm-Gg: ASbGnctgGfvWxRWEwwpJWwG3UioCtAo4dBpg7yJBjC4YkOmRxOxkpdRlmEkrx9yojpo
	+uRO+U50Hp4xiEUNcGQQ/6V12ldM5smQdH0d9HEHANxxRBpnsY6xuyRAi2k2UChMubXS9NK5CAK
	ASMh8rzcXbY2cijn2ThR0UgZphmdVj1G5ItkQhxeaBc9KGBRp55LaW5QMt32v1eJ3e2Bm5rRugl
	H6oSrKdy//Jr/HBAC5sYJWrRzcZoVXCKdmdbEG7Cjalg98T6DG3x4bNUkB8E1Upn1Am6no8b08f
	tH0r79uxwaYoE6U=
X-Received: by 2002:a17:90b:3b4a:b0:2ea:88d4:a0bb with SMTP id 98e67ed59e1d1-2ee08e9e8b1mr9517781a91.12.1732780595685;
        Wed, 27 Nov 2024 23:56:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtoGq/lMRsoxzHe90S7V+PNg9YziwDKZ6PAyp+oX+RKGf1wuiZaWyJPlam7RePWXH9NdAZXw==
X-Received: by 2002:a17:90b:3b4a:b0:2ea:88d4:a0bb with SMTP id 98e67ed59e1d1-2ee08e9e8b1mr9517767a91.12.1732780595357;
        Wed, 27 Nov 2024 23:56:35 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ee0fa341bdsm2859902a91.5.2024.11.27.23.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 23:56:34 -0800 (PST)
Date: Thu, 28 Nov 2024 15:56:31 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] generic/757: fix various bugs in this test
Message-ID: <20241128075631.whxsd2j4yjvd7t45@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
 <173258395086.4031902.11102441101818456621.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258395086.4031902.11102441101818456621.stgit@frogsfrogsfrogs>

On Mon, Nov 25, 2024 at 05:20:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this test so the check doesn't fail on XFS, and restrict runtime to
> 100 loops because otherwise this test takes many hours.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Thanks, this patchset looks good to me now.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/757 |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/generic/757 b/tests/generic/757
> index 0ff5a8ac00182b..37cf49e6bc7fd9 100755
> --- a/tests/generic/757
> +++ b/tests/generic/757
> @@ -63,9 +63,14 @@ prev=$(_log_writes_mark_to_entry_number mkfs)
>  cur=$(_log_writes_find_next_fua $prev)
>  [ -z "$cur" ] && _fail "failed to locate next FUA write"
>  
> -while [ ! -z "$cur" ]; do
> +while _soak_loop_running $((100 * TIME_FACTOR)); do
>  	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
>  
> +	# xfs_repair won't run if the log is dirty
> +	if [ $FSTYP = "xfs" ]; then
> +		_scratch_mount
> +		_scratch_unmount
> +	fi
>  	_check_scratch_fs
>  
>  	prev=$cur
> 

