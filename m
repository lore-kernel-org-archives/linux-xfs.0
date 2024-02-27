Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871352F73
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 05:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709010909; cv=none; b=qupWpzXomf0fjL8AC3FQHmHn6m26J0+yI4/WS1e0Et/93rpFqE9dcQlFdqbq8Rbm62yg+Vs3OhurD6ad04offOSw+737nwn0eumEsVirPSz6d69de9R9VIEQ4bu/+1uLsg8cipKCIlE+So3Y/R5meNYGO+dm+KXFg3QiC5RYlzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709010909; c=relaxed/simple;
	bh=DrLpN6ng2aMOGRNg1QAj1X/q9SNuOgYRclDkbOr+hKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyMMmncre6s0dHwqDxL6Xdm66eLkJA3Tdq4rudyE2Stgb3WnZi7DKtcWdyMh92VgGeS6WedHy9VW3+hQHXvenjzJHJu3GedYJJ+Nnl7HNiTi7n515DoSGDUWRDFPi87z4W9PDankx4VQz2zNfxPcA4BBq9NkSoLOHd9NIk/WOHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iHTgfKkH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iHTgfKkH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709010906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94RnUBU789GCXN3tAcemptI74oqgzIecnmT6YemaLoA=;
	b=iHTgfKkH4t8Vb5DoXyMF/YZzxypT6+1B+896BoePOV9lDT72kxOqKOOL6B2rEn8K8sxxG8
	XS+VIhpi2GswzIeWbQBIkTEw0GajST09LNhwI5bQZFqs10UFAmWf/GRkwtjWn7FwaE533A
	NpAZC71+VC7f7wJOv8uIbMTj50Wrq9M=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-DBYlirnANeqD3kr9bXkJlw-1; Tue, 27 Feb 2024 00:15:04 -0500
X-MC-Unique: DBYlirnANeqD3kr9bXkJlw-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso2970788a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 21:15:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709010904; x=1709615704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=94RnUBU789GCXN3tAcemptI74oqgzIecnmT6YemaLoA=;
        b=m5ZNHKBPrPHW8WJw+KKuMM0RN7a/CMhaz2Vw651lhP8j8DmwL9BWO8g4W3FMZ7t2J1
         x1+UR8ouzaGWPqu8Jm4WX1rm1z7ffOFnzxT60KtgvRXYaC+LpZk4rzktMyLo7MMR4mef
         YKjgwsp39lu2TOvz03hhl0xqlv/A2044482qEl1Uk1Bh/FdfMh/e0FKY0/q+nevhkxhL
         fsO3jR6a5F1tVIaLce5K5fRbbKOoXoVTmY9ux2b4fcIOFMNvtlSuCnT74hqZABMiVsyN
         B+Rb2keXeRRS/kDBUuY7qT+VDsZBDCu3MSMN4W+a7zpg4s85WaUZX7Wwb26nAN2vxj3s
         HTnA==
X-Gm-Message-State: AOJu0Yz9SLidwBRV5LYdK3fkVleapXMq47fZfw8I1yl1Jc9fABWK1FXw
	5N0vzAifV0YCfgOmWYfw4If6W1usMWno6axuKYOAcQ5nGTu0B53vHavLc2EdLVD6iRxIVAPb4Pv
	ZBZieGCyClPjOVzd7eKkxiTTRlUKw/wYuJT6IITxwZZqORYsQmBtHHaZqEA==
X-Received: by 2002:a05:6a20:9c9b:b0:1a0:b414:a53f with SMTP id mj27-20020a056a209c9b00b001a0b414a53fmr1457261pzb.23.1709010903828;
        Mon, 26 Feb 2024 21:15:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGu0sCnzvxirkLDaEfFm2TasO6uXB/xlu3iPkoiqNAV+eDb3IOjKAzKEaymSygIkyUNZN9n/g==
X-Received: by 2002:a05:6a20:9c9b:b0:1a0:b414:a53f with SMTP id mj27-20020a056a209c9b00b001a0b414a53fmr1457253pzb.23.1709010903533;
        Mon, 26 Feb 2024 21:15:03 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id cv17-20020a17090afd1100b00299947ed2efsm5477001pjb.2.2024.02.26.21.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 21:15:03 -0800 (PST)
Date: Tue, 27 Feb 2024 13:15:00 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 1/8] generic/604: try to make race occur reliably
Message-ID: <20240227051500.5zjn6w4fs7nhyqyx@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915233.896550.17140520436176386775.stgit@frogsfrogsfrogs>
 <20240227044021.GT616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227044021.GT616564@frogsfrogsfrogs>

On Mon, Feb 26, 2024 at 08:40:21PM -0800, Darrick J. Wong wrote:
> This test will occasionaly fail like so:
> 
>   --- /tmp/fstests/tests/generic/604.out	2024-02-03 12:08:52.349924277 -0800
>   +++ /var/tmp/fstests/generic/604.out.bad	2024-02-05 04:35:55.020000000 -0800
>   @@ -1,2 +1,5 @@
>    QA output created by 604
>   -Silence is golden
>   +mount: /opt: /dev/sda4 already mounted on /opt.
>   +       dmesg(1) may have more information after failed mount system call.
>   +mount -o usrquota,grpquota,prjquota, /dev/sda4 /opt failed
>   +(see /var/tmp/fstests/generic/604.full for details)
> 
> As far as I can tell, the cause of this seems to be _scratch_mount
> getting forked and exec'd before the backgrounded umount process has a
> chance to enter the kernel.  When this occurs, the mount() system call
> will return -EBUSY because this isn't an attempt to make a bind mount.
> Slow things down slightly by stalling the mount by 10ms.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v1.1: indent commit message, fix busted comment
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/604 |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/generic/604 b/tests/generic/604
> index cc6a4b214f..00da56dd70 100755
> --- a/tests/generic/604
> +++ b/tests/generic/604
> @@ -24,10 +24,12 @@ _scratch_mount
>  for i in $(seq 0 500); do
>  	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
>  done
> -# For overlayfs, avoid unmouting the base fs after _scratch_mount
> -# tries to mount the base fs
> +# For overlayfs, avoid unmouting the base fs after _scratch_mount tries to
> +# mount the base fs.  Delay the mount attempt by a small amount in the hope
> +# that the mount() call will try to lock s_umount /after/ umount has already
> +# taken it.
>  $UMOUNT_PROG $SCRATCH_MNT &
> -_scratch_mount
> +sleep 0.01s ; _scratch_mount
>  wait
>  
>  echo "Silence is golden"
> 

