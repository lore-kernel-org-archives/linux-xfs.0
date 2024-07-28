Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA5F374CC
	for <linux-xfs@vger.kernel.org>; Sun, 28 Jul 2024 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722178458; cv=none; b=eQanZVUdp6cCus0Vmc9B3buiBf7AtBEFQKtdoIcPmxXw1GCmMLG0kM+Sn24mVJcfAa00RYAvWjjJe5td3woT2s7Re3VL/gCa9Xr7osDo2IbGTEmOwds52ol3kcS1aZVjI0MVeHZMmXdzRAUcjPVVICB4PqbqH5gg5GM7qMtjzKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722178458; c=relaxed/simple;
	bh=SJNolGQqVD0BolHWbLdTZKRWgbqvMQ2HSvj8tlCkMTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EQMxLIY6KfVzFbkNRIRMUsytonvTCFUMLYDR0qFVCBPNbWew1lRS+jtVM4qGcy01rD5hlVCVC6CasEBqcuxf+Iy7rF7/x7MxsiOUIrPIVz3g+UatdC08BZy4Jv7OAsp1wo3ghEmlia0k7A9ZmiNK+nW0J3k0GkFe/gEtN8wIhRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LBDsSYMK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LBDsSYMK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722178456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pqy1ISPnQUGctFt4KkkdUUuShdvIuxpHe5p1UfyNBrQ=;
	b=LBDsSYMKEMUG1tliLiT9mBWuEZGjLwjBd0cwV3168FX3/g1vMAd6NOyxZdRqbU03mdyFmm
	MxSUrFTFqsRfojxTLncuYvtpULmKlTLJIR551pYyHN+LQn1yCz38pBO3OLpmhscThcZtBr
	K7HXTx3SL2Kf8lLk6IjG2Fq3w/jmRNc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-e5TSL7kUNkeUuLnAcPJtFA-1; Sun, 28 Jul 2024 10:54:14 -0400
X-MC-Unique: e5TSL7kUNkeUuLnAcPJtFA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1fc5acc1b96so25867865ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 28 Jul 2024 07:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722178453; x=1722783253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pqy1ISPnQUGctFt4KkkdUUuShdvIuxpHe5p1UfyNBrQ=;
        b=VtRhQCm00RqXj20uqMzrcC1WsTYJ0v/X1/OyYc7XGBuLG3vfplHSG7iEUfsHXAsU95
         D2MUaVNN2JloiwHi/XpL4/oN4NQxhzdT8AHRix5wSnId6FuCsI4aOH+CkQ3B2Fc9xgKi
         VJ7KamXDPkNVzKDfE3lt4SMKYLPhdolIjP4m5b483Og77VNERI291c1Se6gFlVuiCCHX
         nKMPeIkiO6B2rkugOCnMoCTsSwGqdYlb7gIOO6ZItUNxp9P7dFUoqrwL0er0SWe59rGi
         p/gWc2mDNi7/EJ33z5YuqvKKjli3OUOpSx1YpCJI3vCZGZWQ5styz/LIAZNIlVSdHka6
         hlcA==
X-Forwarded-Encrypted: i=1; AJvYcCXoGGcXbRyZ1qru1aBm7cowc2U/4oBSjKSTDPRoaLUCbIw8hogZHjngcYoZLPa8HFg8ToU65vNo40m/GOz4MBn7YTHmP1GHlHUh
X-Gm-Message-State: AOJu0YyovDQR0rG2K4IWCp8n3te52pb0onI7fbk1Vw2RbKhzfrLuAV02
	8WmVlcaM0Gl+kUim0T+6m72s1nolnVPtOpfV8GATNoN00hgV1RF48xqgnHrCRTD4fV3lc6cX7ej
	jxt+ATalq22FUvQzSzoLmatYr4cC+3bUHul6NAkNkw2b1nJSkhAhcT58wRw==
X-Received: by 2002:a17:902:c40e:b0:1fd:69e0:a8e5 with SMTP id d9443c01a7336-1ff048d4cb2mr60208445ad.41.1722178453161;
        Sun, 28 Jul 2024 07:54:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFIYQNYVR/K/P3Y/5W6ri+AJmsXa1xIaawdbOysCmQOkONfRN5lFRrLm/8JxvIrX4spdDOBQ==
X-Received: by 2002:a17:902:c40e:b0:1fd:69e0:a8e5 with SMTP id d9443c01a7336-1ff048d4cb2mr60208245ad.41.1722178452723;
        Sun, 28 Jul 2024 07:54:12 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7c8c1a8sm66231025ad.2.2024.07.28.07.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 07:54:12 -0700 (PDT)
Date: Sun, 28 Jul 2024 22:54:08 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] common: _notrun if _scratch_mkfs_xfs failed
Message-ID: <20240728145408.mu2hmmqmzxb2amrd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240723000042.240981-1-hch@lst.de>
 <20240723000042.240981-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723000042.240981-3-hch@lst.de>

On Mon, Jul 22, 2024 at 05:00:33PM -0700, Christoph Hellwig wrote:
> If we fail to create a file system with specific passed in options, that
> that these options conflict with other options $MKFS_OPTIONS. Don't
> fail the test case for that, but instead _norun it and display the options
> that caused it to fail.
> 
> Add a lower-level _try_scratch_mkfs_xfs helper for those places that want
> to check the return value.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

[snip]

> diff --git a/tests/xfs/178 b/tests/xfs/178
> index e7d1cb0e0..0cc0e3f5b 100755
> --- a/tests/xfs/178
> +++ b/tests/xfs/178
> @@ -52,7 +52,6 @@ _dd_repair_check()
>  _require_scratch
>  _scratch_xfs_force_no_metadir
   ^^^^^

I tried to merge this patch, as it's a xfs particular change, and xfs folks acked
it and would like to give it a try.

But this line blocks the merging process. I can't find "_scratch_xfs_force_no_metadir"
in xfs/178, and even the whole xfstests. Could you help to rebase this patchset on
offical xfstests for-next branch, then send it again? This patch is too big, It's hard
for me to merge it manually ( I'm glad to know if there's an easy way to deal with this
conflict manually :)

Thanks,
Zorro

>  _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> -test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed!"
>  
>  # By executing the followint tmp file, will get on the mkfs options stored in
>  # variables
> @@ -61,7 +60,7 @@ test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed!"
>  # if the default agcount is too small, bump it up and re-mkfs before testing
>  if [ $agcount -lt 8 ]; then
>  	agcount=8
> -	_scratch_mkfs_xfs -dagcount=$agcount >/dev/null 2>&1 \
> +	_try_scratch_mkfs_xfs -dagcount=$agcount >/dev/null 2>&1 \
>  	        || _notrun "Test requires at least 8 AGs."
>  fi
>  
> @@ -69,8 +68,7 @@ _dd_repair_check $SCRATCH_DEV $sectsz
>  
>  # smaller AGCOUNT
>  let "agcount=$agcount-2"
> -_scratch_mkfs_xfs -dagcount=$agcount >/dev/null 2>&1 \
> -        || _fail "mkfs failed!"
> +_scratch_mkfs_xfs -dagcount=$agcount >/dev/null 2>&1
>  
>  _dd_repair_check $SCRATCH_DEV $sectsz
>  

[snip]

