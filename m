Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850C66BB51
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cvAXmTn4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705065669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mhi/+JgNV+S+4kaUsq/RAwFdZECY3i+QjvGNP8Cshdw=;
	b=cvAXmTn4CrpERLxld8K4RQba46lzEziqyn5MmB2rTLb2oi2eqLvBVktuYsZ5gOOvJscXkK
	9Sv7ZVs6D3r8YcxEJzI7dXw3ZiwYgTwzRKWTGewwVBlzTEdWmjHanka5W1+vl0+0RkSA/+
	vMMvTieQQKZYR4My8xhM5Or4RG4vPDs=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-gmGMVE7XM9q5kywLJbTtHw-1; Fri, 12 Jan 2024 08:21:03 -0500
X-MC-Unique: gmGMVE7XM9q5kywLJbTtHw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6d9b8fef16aso4797550b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 05:21:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705065661; x=1705670461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mhi/+JgNV+S+4kaUsq/RAwFdZECY3i+QjvGNP8Cshdw=;
        b=YnDouQwP2v1UjZoZnum57DRMwigXuq69BG1y/bmBtmy4R3idl4akLeDYbi0ZQtSE3n
         sh/lg0nDUh94M5r7tojYN3FjDU2j1W1Kb8thBaUs5ISUKOkPOEKhXfUWy1civKS6Jc6h
         s3MPE9/qDF5yWfHn82eblxRcBTCr57arMA8QXjNAciL/yWSDooRh7jO2hDukaxFfi4YF
         Oq5VO/1w27HxpLRRhXakW0b4LbcHJ+uNdooqknUmYpmma/AjZgtdbgcB+PelvbWsFyLY
         1321ZSzbZVMmb2vbiiU7Zl1wLq4wuTYmIBi2/OLfLxuXJZXBMpa7jVA9d5oS4jmWl0ts
         0PzQ==
X-Gm-Message-State: AOJu0Yzemc0JigeftUa7xDoY+eazAHvxi2zcYm2X0OC+zr2zEkS7RUhr
	Si16xF/UtXi8WboAlZz8kNU3OIq6AOEOddH83zKDAA7os8LjXMxgYMQ81r064dK3fwBY0Ymsyzy
	VgsJs1rVQ8a9HGFhfW1C/QEaxY164
X-Received: by 2002:a05:6a00:464f:b0:6d9:acb2:29ac with SMTP id kp15-20020a056a00464f00b006d9acb229acmr1398177pfb.23.1705065661159;
        Fri, 12 Jan 2024 05:21:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHOkbGz4wknQxKd35c5FYm98su9D3XNN32OBsrmlsx3jNtp1Jq9SZFAEwfBLL3+HhBmbphcBQ==
X-Received: by 2002:a05:6a00:464f:b0:6d9:acb2:29ac with SMTP id kp15-20020a056a00464f00b006d9acb229acmr1398164pfb.23.1705065660850;
        Fri, 12 Jan 2024 05:21:00 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j6-20020aa783c6000000b006dab36287bfsm3134732pfn.207.2024.01.12.05.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 05:21:00 -0800 (PST)
Date: Fri, 12 Jan 2024 21:20:57 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: check that the mountpoint is actually mounted
 in _supports_xfs_scrub
Message-ID: <20240112132057.2uunfrh4ar6xurk5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240112050833.2255899-1-hch@lst.de>
 <20240112050833.2255899-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112050833.2255899-2-hch@lst.de>

On Fri, Jan 12, 2024 at 06:08:30AM +0100, Christoph Hellwig wrote:
> Add a sanity check that the passed in mount point is actually mounted
> to guard against actually calling _supports_xfs_scrub before
> $SCRATCH_MNT is mounted.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

This version is good to me, thanks!

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/xfs | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index f53b33fc5..4e54d75cc 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -649,6 +649,9 @@ _supports_xfs_scrub()
>  	test "$FSTYP" = "xfs" || return 1
>  	test -x "$XFS_SCRUB_PROG" || return 1
>  
> +	mountpoint $mountpoint >/dev/null || \
> +		_fail "$mountpoint is not mounted"
> +
>  	# Probe for kernel support...
>  	$XFS_IO_PROG -c 'help scrub' 2>&1 | grep -q 'types are:.*probe' || return 1
>  	$XFS_IO_PROG -c "scrub probe" "$mountpoint" 2>&1 | grep -q "Inappropriate ioctl" && return 1
> -- 
> 2.39.2
> 
> 

