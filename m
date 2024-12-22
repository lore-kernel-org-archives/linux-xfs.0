Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C508718A959
	for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2024 12:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734871472; cv=none; b=Eul/qqwbAe6GlPUN5F/LAcIxUW9dnE0I+QFslxvSzNXwfAfRMZ4KiRuf+t8LCyW85UW3ki76RyZG/qgmm0SvxaKZP2rcdMQpQYKkS9MvugrA83lO4xma9T9sqPSsdYnk1YV1jiTIiC218ua4Ha4WTkMGFsqtYxlYHMemK0TKp44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734871472; c=relaxed/simple;
	bh=/27kcdU79OnKH+rkpq6Z4t8NC5yXS2jxPPRtNI1ISzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFQxveIov9NnROVdY+9EfhJNoRWv5oe8rteQQ5/D5dc8JCFYssRWTaR1Z7eCjoUEynSJczvhJBXjNBZnGnEmFFaCub2w1xo0/ZnQlqNEwTEghCKsLQ7DNAAo8OzRhV8k00KOV9SXm5mUJAI8KCi8H4fDTLjjC1G+Cl+AiCssSDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hxSk0yEX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hxSk0yEX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734871469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fYkW1W2ZrOx2ksISMuvdqOlwwDXgHvtkfNFwXVUFaJc=;
	b=hxSk0yEXBOdq8jntY+xxkKGIwh+PY8jy7dFEJzwv6H1N7Xoy25nCtVd/gks13l6plRr3jv
	S7c3ekhI5bj8qzlH5pTlIeObbKG+6jQ3Y8N+RFTP0GBl47MyiwkWReXS6Il5nhS647u+5L
	BJt4l2+iwCR3rxSIvaT+DMiuiOZo8sg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-UgZRWNDhML6r9Q0QdsT1PA-1; Sun, 22 Dec 2024 07:44:27 -0500
X-MC-Unique: UgZRWNDhML6r9Q0QdsT1PA-1
X-Mimecast-MFC-AGG-ID: UgZRWNDhML6r9Q0QdsT1PA
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-725e59e41d2so3046289b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2024 04:44:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734871466; x=1735476266;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYkW1W2ZrOx2ksISMuvdqOlwwDXgHvtkfNFwXVUFaJc=;
        b=JMhVFwoFisMxz+GEphI25ymHLSuzHnOHVMtSMRSxjPU0c4itcL9QAv109syXcgs1VQ
         MhjJMOQslJ8xZiB4N6bWBsABuc0fTltMmoPOf/4fir//Q5ZvTjplI0yXRsfHqIj/BkIe
         2zUGtXmwCe3thxQM/x/FdOWOS1ebW/LO5U4ccRIqRB5SQLQyz3qpBngmVqeXqNgCCgK6
         kvcUiKtNcQd7Xe8gSv6ywnKvDXEgfh/o+uPC89wk01ZzcxJjyuPy3+c3FZCKxcEB0vHH
         +q0ALH151IvtNLqUDp9T4xdD/qBesBOT2UWTb9AWyCUUCkAB8LQPFDbIBlA7x22QUmco
         8DiA==
X-Gm-Message-State: AOJu0Yw5vkxo5fSazOZyQr5TYBcR/HeurCmOYOijevp9i3tDBXkK5HPD
	EhBu7I5MlM+uKtcUXGw9Nm7kMxEGmOEQoln0wlvFIMnwF/JNcESo7SsD0JGfpU3Pb0mYoYW2hTu
	XwWiX42cBfYOBZehLnFgq2WZQjl8LDhYrAP+RA00wDI4Q0q5JxsP6vXKFYEVGlylnTJ5U
X-Gm-Gg: ASbGncvfmhjXN1fvrhN+8M1sUJGB+fpDrCOZYGPcQ8GXFOfxUoLfnY68U7tQQZ3GUO2
	TwLfwYjvd3EHUnDRMQKbeJ75gcd1NQmx2UKE+DGj4ELcC/2GyhpfZe+lKcxFLvkCiUINAI528Dl
	Lw0qt+tdcb2qjFd8Sos4wfwt5+czg4UD1zeoGHaXxuhiBg4AauLkxi4KoxOJNWAZsMyApaEuNty
	Tu1cRsElBi6+JSbtVYgq01hf85yy4TDxtsl/BRV4An0WjASpOSyHqXBLwPFc/ceSQuAh5T9Sunw
	KrkMajnlnNuFewllLoYloQ==
X-Received: by 2002:a05:6a00:3a19:b0:727:3c8f:3707 with SMTP id d2e1a72fcca58-72abdecdcc7mr14770107b3a.23.1734871465881;
        Sun, 22 Dec 2024 04:44:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG020bZ4u7yl6RYtLjZ+ENU5zuUBeRDIaj/RGK50eykKIMf7IXqpqZI1bPDJ2YsVXUmFbXo1A==
X-Received: by 2002:a05:6a00:3a19:b0:727:3c8f:3707 with SMTP id d2e1a72fcca58-72abdecdcc7mr14770090b3a.23.1734871465532;
        Sun, 22 Dec 2024 04:44:25 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8fd4e2sm6076065b3a.169.2024.12.22.04.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2024 04:44:25 -0800 (PST)
Date: Sun, 22 Dec 2024 20:44:21 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/032: try running on blocksize > pagesize
 filesystems
Message-ID: <20241222124421.skfeoi35bpvjjamt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>
 <173328390001.1190210.8027443083835172014.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328390001.1190210.8027443083835172014.stgit@frogsfrogsfrogs>

On Tue, Dec 03, 2024 at 07:45:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we're no longer limited to blocksize <= pagesize, let's make
> sure that mkfs, fsstress, and copy work on such things.  This is also a
> subtle way to get more people running at least one test with that
> config.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Hi Darrick, sorry for missing this patchset long time :-D

>  tests/xfs/032 |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> 
> diff --git a/tests/xfs/032 b/tests/xfs/032
> index 75edf0e9c7268d..52d66ea182d47e 100755
> --- a/tests/xfs/032
> +++ b/tests/xfs/032
> @@ -25,6 +25,17 @@ IMGFILE=$TEST_DIR/${seq}_copy.img
>  
>  echo "Silence is golden."
>  
> +# Can we mount blocksize > pagesize filesystems?
> +for ((blocksize = PAGESIZE; blocksize <= 65536; blocksize *= 2)); do
> +	_scratch_mkfs -b size=$blocksize -d size=1g >> $seqres.full 2>&1 || \
> +		continue
> +
> +	_try_scratch_mount || continue
> +	mounted_blocksize="$(stat -f -c '%S' $SCRATCH_MNT)"

_get_block_size $SCRATCH_MNT

> +	_scratch_unmount
> +	test "$blocksize" -eq "$mounted_blocksize" && PAGESIZE=$blocksize
> +done

I'm wondering if we can have a helper likes _has_lbs_support(), if it
returns 0, then set PAGESIZE to 65536 directly? (and we'd better to
change name of PAGESIZE, e.g. MAX_BLOCKSIZE)

Thanks,
Zorro

> +
>  do_copy()
>  {
>  	local opts="$*"
> 

