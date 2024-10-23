Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB07F49620
	for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 04:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729656915; cv=none; b=OkFatBtUCVHIcMPrqBaMKT/UhT5hVapQmBtm+Wq/CTdmOdJpvDr9rRl6Ja2gEWBgns++e39TWlR83Dhn68Tx7+HdEgKqVHjGsKvvBoU2or0wIxIEo8V9MkJTnHFSUb4jp+qOOliVMenT9fTCczBjm6LM1lORyqDUkQBqGEY+EdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729656915; c=relaxed/simple;
	bh=JmwRdTIskf+AsMMCCxjo94Vnxe2+wbrUwIrR6N/UlE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfIzKa3AS3AMNP+FmHdtZIi9h26fn9nC5lUuTeFVDS1VqDMasokl4H/525pIAqZbd0JYY/MenPjRv+y0R/P/ZjMntnak8Ev9NtL8+L06zWDF2PX3LlKMU0brhPMgB+IDs68Jb6OhldfR91yKiyyZvm+kNWJuqeygirg0GpYqBHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TU89Uvm4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TU89Uvm4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729656912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kUoxSHiWDgCVgLsFRPvTqiN+l9Des0mYN1Ckud4gffo=;
	b=TU89Uvm4wF5QnHyotmIluWTzuUqhvwW3C9Ub208McoNReHEdDTX+fPamhPmPDqw+VpwdSL
	XICCSjHB5jsMX7NvbVA2THWttPsHSu+BBB32VlItmS98sZP3mNY3rSS8da227ZFpTqhgxJ
	/DJohz01WabUUXEPAdUFvZtddlkEiKs=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332--DR1_Y5jNCyLmNK3L61T3g-1; Wed, 23 Oct 2024 00:15:09 -0400
X-MC-Unique: -DR1_Y5jNCyLmNK3L61T3g-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2e3ce03a701so6798667a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 21:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729656908; x=1730261708;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kUoxSHiWDgCVgLsFRPvTqiN+l9Des0mYN1Ckud4gffo=;
        b=AIrB5FXr7lbcAiqV7X3E3Ca90p/PqcTYWumD2/uLyzNiblFaqSPL9SnPCkl8QVDlRA
         S5XY4jiPW0LvSkPlkx56t3CVMcjnAQHlq0rDwuFK2FUWwknIrUOLE17y71WRrTvtGJ9K
         yGQJyrrZvjR88UEHdxz6PaiGkTQI2drArBq8EroqMv+WRUDtnkKYNZxa+Tts8/7/7nbf
         R2K+0ldwC5y3UUr6M/MWX8eLhKJLFrdyhgt1WvD1mtgCGTZDW9EiV8jjHsq/UTJ6LKCE
         S7qSL9XTRwohUXAtAoBVSCBuNGL1MPzwxNj8rLPcli1nlVrF+nTz7NV6J+yt7EvoOr+b
         mHow==
X-Gm-Message-State: AOJu0Yw6wo5U/WIljDD6xytToSYlrF1DCud4A0TOpDVkDs1UrGoQEtvi
	MaaFk1+LbIepC+ieDsxaK9cRd6TBeuGtM7X2tcBj02fRBUtXx4ZgWsegYEPhCqqsUrUXeXnzMBi
	itp5ylOQ4n1fQBHyk8FQUIs4bq1KbX3EiGXwriuqqiuYk6BbzV/hAa2IGjg==
X-Received: by 2002:a17:90a:2d82:b0:2e0:8e36:132 with SMTP id 98e67ed59e1d1-2e76b5b57f9mr1417841a91.3.1729656907961;
        Tue, 22 Oct 2024 21:15:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcZY+Y6w/urBHRr5QoKR+rA/UuvJ7bZl0HtBPi7B5QNkmJB1U5Hi4XPjulwGBXdqnaKriCrQ==
X-Received: by 2002:a17:90a:2d82:b0:2e0:8e36:132 with SMTP id 98e67ed59e1d1-2e76b5b57f9mr1417825a91.3.1729656907626;
        Tue, 22 Oct 2024 21:15:07 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e76dfeece3sm294579a91.57.2024.10.22.21.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 21:15:07 -0700 (PDT)
Date: Wed, 23 Oct 2024 12:15:02 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] common/xfs: _notrun tests that fail due to block
 size < sector size
Message-ID: <20241023041502.gwnyxvngsmt4rv3b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
 <172912045609.2583984.9245803618825626168.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172912045609.2583984.9245803618825626168.stgit@frogsfrogsfrogs>

On Wed, Oct 16, 2024 at 04:15:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It makes no sense to fail a test that failed to format a filesystem with
> a block size smaller than the sector size since the test preconditions
> are not valid.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Makes sense to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/xfs |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 62e3100ee117a7..53d55f9907fbb0 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -172,6 +172,11 @@ _try_scratch_mkfs_xfs()
>  		mkfs_status=$?
>  	fi
>  
> +	if [ $mkfs_status -ne 0 ] && grep -q '^block size [0-9]* cannot be smaller than sector size' "$tmp.mkfserr"; then
> +		errormsg="$(grep '^block size [0-9]* cannot be smaller than sector size' "$tmp.mkfserr" | head -n 1)"
> +		_notrun "_scratch_mkfs_xfs: $errormsg"
> +	fi
> +
>  	# output mkfs stdout and stderr
>  	cat $tmp.mkfsstd
>  	cat $tmp.mkfserr >&2
> 

