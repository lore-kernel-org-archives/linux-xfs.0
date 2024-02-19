Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2675B677
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 22:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708382142; cv=none; b=jhIYRoXvyscYUYJ/W+LJ/3wwTmLCsQ0DrQNvBsUYszummlC5holPYYppa8A8ApSDPcBQnK6ntROpAmklMy3mly3Q5JY3oabzEj3OenoaGZH70O4+3LPglmYWIgawFx7/4p0gZJzbBa2J+bYXh8SE6QnnbVa7KIBmLUx4lh/u48c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708382142; c=relaxed/simple;
	bh=ybQwCn092UmgDFdnvGkPcR3KuSqJZgVDBaYz0Z4gOm8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OmoSx7CK/3PgZYq2d96z4Lpt+p3A7tl2Azk94wvGQva+3H9SRGmX2ulAtXIYCDnawyNkqaLXYBxvfwErFCLOIdXChHlP9f+zwCftLvx8p9hd1zTbAJs/XIblGEYtJeFkJi+ep7Y51pImGXEuXVezzM7SqtQPh/Xk8LAwpvkpkdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U++tJ/im; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U++tJ/im"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dcbc6a6808fso5055541276.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 14:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708382140; x=1708986940; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2LnIFqJqD5R6npETueaLzzFEUVO0eALpRrwN094PGw=;
        b=U++tJ/imx3oW9EqgjqJPeKknNgTYLR4Gb5FdgALsL6be4BzsY/oGdRPeDEy+Aqh0Ls
         m6R4sT+fuel+kqw1FaRceNjvPoSDhDdmELp1jrGZDBIHCt//hzKWwLNDdzoccMMUOPJy
         JMu1ocJ+hjqu+J87O1NxnMcC0RnAY11pfcYdcPFVQwD3PXRFslbkLuwXS8sK16kIO+11
         jXFFSZoYUOC4Q1xi5zVmigWTZG9CRgRNf34WHzETSzBcJ5TUMHxu3pZvi0MqJqvKVBWB
         OiJI9vNFinCRV2jtHqIaF1EkSXfjQuUEnuw8lWhmBcTaZnxj7gqrYooMNw+g2Q/+lWlY
         odeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708382140; x=1708986940;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o2LnIFqJqD5R6npETueaLzzFEUVO0eALpRrwN094PGw=;
        b=enqBskDTSyFRopst6X16H1DF3cnCX4+JPFYrPm37o84WpB8w2wxEVhniV2gxoPYAF0
         S1GSmf4cGQ2HGaX5w5JmD1lWkVMxXaclkbzcEIye/NUTf59BeiAHNlAUruXLInOoWJpx
         vVZC/Uag63JMsVqK3tMyGNmdNNvFHzXVHi2LlGslUBptNZWTBdyuLIKXLqH2DFvcHkSM
         S/EWcmZhNP1HpN07VZdZrIECYTcqfUot5H+dkkNvkcJhxjeKj0jTjBzcLbaVXfx0Iwl0
         beuT9mLBnJBK+fvygRytSJi6HDYMgR1HpBxbK0GZ3/aY9p/ZZ146FrzCQ5t5KaWTZHmI
         vc8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUswXzPoxtrKBn/XuplOacs6pE8Ql+cxOYkENvLSZWNPhgamsrzh2EyyeQBEdpjT7rDpbWygBa1RGThhmeqlqJ4TVzJtdX5jejO
X-Gm-Message-State: AOJu0YxpRTuzhQV8/6pZuEEuW0LIF52vUB6jcSYPSMcdsxFNfGXxYAyG
	nSD1sqSoAVWAdqPeWNViLM4Kj9G2Eh9LDVcFsVDxsW3XdZOsYxyepQTyfxFZRa0rMN91VkhHSyv
	O6w==
X-Google-Smtp-Source: AGHT+IF+r1Zamh+n8JrGZUrsW6nzdDOed2DtH1tSqF8a0cHCBBIVpZyEk/XPScFL4t7aufZlh7KSZQ==
X-Received: by 2002:a25:848d:0:b0:dc6:be64:cfd1 with SMTP id v13-20020a25848d000000b00dc6be64cfd1mr10817332ybk.36.1708382139813;
        Mon, 19 Feb 2024 14:35:39 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id z33-20020a25ada1000000b00dce0a67ac8bsm1607027ybi.23.2024.02.19.14.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 14:35:38 -0800 (PST)
Date: Mon, 19 Feb 2024 14:35:25 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Christoph Hellwig <hch@lst.de>
cc: Chandan Babu R <chandan.babu@oracle.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Hugh Dickins <hughd@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>, 
    Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: put the xfs xfile abstraction on a diet v4
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
Message-ID: <157748fd-18c1-d2ff-8b15-1b218705b355@google.com>
References: <20240219062730.3031391-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 19 Feb 2024, Christoph Hellwig wrote:

> Hi all,
> 
> this series refactors and simplifies the code in the xfs xfile
> abstraction, which is a thing layer on a kernel-use shmem file.
> 
> To do this is needs a slighly lower level exports from shmem.c,
> which I combined with improving an assert and documentation there.
> 
> As per the previous discussion this should probably be merged through
> the xfs tree.
> 
> The series is against current mainline.
> 
> Changes since v3:
>  - improve the shmem_get_folio documentation
>  - use VM_NORESERVE
>  - split and reorder the file setup patches
>  - improve a commit message

Looks good to me (and I was relieved that you resisted
Matthew's temptation to rename shmem_get_folio()).

Thanks,
Hugh
