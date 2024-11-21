Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E2D1A3BC8
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 09:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732182993; cv=none; b=hYjwcwxMhatfUCByyAGtIjngMbODDYfD98tOh2c7/xTucoc/ZQGdEdVq4Y371rZLEbFf2GRQpr4o6xHXn7dKjtWuYVHLNZaKdQ599Ek09aRoByrsU+Cs8auVLNiOVGgiUsYy78r3NUnjTF+WXgdxSMba3pCMZGphGAUBG9/aY3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732182993; c=relaxed/simple;
	bh=owWfgXMJceoVKQYu2Y1hPvKmkBh3F7Uq/Rj5+cAtqs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRXHSH77qA8ZQffC6HDYsQE4QGcQw2aD3Iy1EdGvGGXEF7YaUQR9DKxZ8hq3B5k903aL1AYpkiv/y/2eHVaEn9wuQMr0UzhWj13DFqoPzYM7owjv/6jOTgek5uBXZDfjUflW2gGdD40oQlICXQmLWjwhvarNw4KRJg3ftXyyyx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d5aMDsgL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d5aMDsgL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732182990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aGie0N2Elnl/yy7t8WxFnMGt+3b74fXr2zpNlwvjC50=;
	b=d5aMDsgL7zth6e8QdlFPnEKg7/CyCKwRIK1mJsQVcmQ3a8EXK+i84JL/Yde8l+d64or9V0
	qBQwha5DG4MNv1BjGfBEVHLmLDAVRoWKK+HabySgRJA3J5AulLfSQmN3G/zt7WNeHTxOYd
	sh9Q+UrxutJT9QKas0vdJLot+cK8jd8=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-d9NB6It1OdK4pVy6VN59Qg-1; Thu, 21 Nov 2024 04:56:29 -0500
X-MC-Unique: d9NB6It1OdK4pVy6VN59Qg-1
X-Mimecast-MFC-AGG-ID: d9NB6It1OdK4pVy6VN59Qg
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3e6095eac8bso754103b6e.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 01:56:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732182988; x=1732787788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGie0N2Elnl/yy7t8WxFnMGt+3b74fXr2zpNlwvjC50=;
        b=feXPaql7oLBqEEMSdbaTi40ytIULdk0E1CG5eTJhMe3jh0sjdRKyZcP6h/Sk2fgl9h
         ErWGtvhkQc5RHyJ8jqRh7JmIos43oYwxWlGZ3nuRFonXluSOrHDO2TftQmcBUtY6HCxo
         UAkcWMtFnEMdzdMWPrSp9GQKZkJb1dcsnLJ1w3Ywjh8rqlj5jk9Cami/9HgGFoHbFEjL
         CXRAzCmCcKd2DmsUz5IY+nZu2RQQEjU50eOHDBoVd/ytT1v4fXvmuM216cD3lt7XnLpK
         dU27InZTDXbPh85Xw9z/xXBcTwHvyc7/ailnfkHbkJY+02Mnj6AyIkDdj9QM2FQgEgi1
         ogCw==
X-Forwarded-Encrypted: i=1; AJvYcCUNOGQw5jcnU5LUlCs+xAu0J8ZzS5j1tnQf2nT6POiqbgMQWuoAMPOIIRppJIrN02BOlLSUo0331WY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg7RZCgCuonhK2Zu9SVaHSYEIOlpTy5JEREQLK1+yXM7iToiKt
	1YgXzSQ18PQ8hVSCWnTlJ4s/gf0gCB2Q2/kMIJEyCZCYnGiwT5sUSJSsiuaOGyfZlDOg48LuOIm
	YcHo0NSU9bhASRzIgJJeXpN+ssFZNvr7VshKOFeHVSJKa6xQo20H5avwpZQ==
X-Gm-Gg: ASbGncsLcDrYbsCtfdxY7TdjzdjrLNuUubPYGemHko4h9fDTXpH3y4WfLFT9OSqPG2A
	Mp2+MCvCayqcyxN9zxF20MYGmQ32dtaIX2GyAwjMzG/0OZLDJb3FqwEL50T5rmi2wjmPEl0OqRR
	T4mL3PXoWztdP7vaPO8lFHgu6yffbHXfqAaNz8DaFMlvOztdX8We6QREQPSPYNB7WJkBINlLEn3
	gclurh05Uqr5bFElhy2wC1d/BsJhjap5Vt91i2bE30M1kESkYXdyerUCOCmW5EK/8TfQgRWekoY
	u4Zs9vW1DOlpQsY=
X-Received: by 2002:a05:6808:1528:b0:3e6:10d1:ecb6 with SMTP id 5614622812f47-3e7eb7aaa78mr7689134b6e.28.1732182988400;
        Thu, 21 Nov 2024 01:56:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHcGGO/fuAZjCdB1UZnr8/UR+CZuGi0NubZ2YSXZ52z9fb8OlenUf9bjt8btrftDQe/e66hw==
X-Received: by 2002:a05:6808:1528:b0:3e6:10d1:ecb6 with SMTP id 5614622812f47-3e7eb7aaa78mr7689116b6e.28.1732182988087;
        Thu, 21 Nov 2024 01:56:28 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbb6581d66sm950539a12.65.2024.11.21.01.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 01:56:27 -0800 (PST)
Date: Thu, 21 Nov 2024 17:56:24 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>

On Mon, Nov 18, 2024 at 03:01:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this test so the check doesn't fail on XFS, and restrict runtime to
> 100 loops because otherwise this test takes many hours.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/757 |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/generic/757 b/tests/generic/757
> index 0ff5a8ac00182b..9d41975bde07bb 100755
> --- a/tests/generic/757
> +++ b/tests/generic/757
> @@ -63,9 +63,14 @@ prev=$(_log_writes_mark_to_entry_number mkfs)
>  cur=$(_log_writes_find_next_fua $prev)
>  [ -z "$cur" ] && _fail "failed to locate next FUA write"
>  
> -while [ ! -z "$cur" ]; do
> +for ((i = 0; i < 100; i++)); do
>  	_log_writes_replay_log_range $cur $SCRATCH_DEV >> $seqres.full
>  
> +	# xfs_repair won't run if the log is dirty
> +	if [ $FSTYP = "xfs" ]; then
> +		_scratch_mount
> +		_scratch_unmount
> +	fi

Hi Darrick,

I didn't merge this patch last week, due to we were still talking
about the "discards" things:

https://lore.kernel.org/fstests/20241115182821.s3pt4wmkueyjggx3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/T/#u

Do you think we need to do a force discards at here, or change the
SCRATCH_DEV to dmthin to support discards?

Thanks,
Zorro

>  	_check_scratch_fs
>  
>  	prev=$cur
> 

