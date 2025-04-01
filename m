Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397E11C6FFE
	for <linux-xfs@vger.kernel.org>; Tue,  1 Apr 2025 19:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743537541; cv=none; b=Fp0THbrPVy+DC0nWlS7+Af65hCFcilm+WJ0Im/HJTnkU/Fbpt48X4jP5EVYVdkUV1Rc2xrOKDYpdhiXWNaHE7RwteKKmVBM7OybBTeaSQf7dr7Mk2R3HuQyDd0vRGzElefS6Tu+6Rl8IxKPR8gX9+M6MLfrf5hoboGAHsYZYeQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743537541; c=relaxed/simple;
	bh=OkMdkj6JirOXrdK94X0oCRFOiRNPIGs/j/G8MIG3a7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iH5T29SX/5ndrQ9wHylG1xQ76x6qobjA3WDEGQJI+aOVpt+LA0HlYC/Ix9WE3Yc1mmzQqpI6HUN+HpxAINr71LpLge7B/3///AKy0mSKASDH8ggy+7aBPPKj4DqBEISUk40GeLEC5OA6XRVb1gmkzmEQn4HY8D1IEAOWWLaR9QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FLjDjnKJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FLjDjnKJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743537539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nd0F6xrysyZRvdcOwsCXTIAlwtOfRO1g6Ab4Fb92gFo=;
	b=FLjDjnKJlxQZFSWSyPbxt8NiyCn2WdyB21niO988A7/R0+snXl9BTVbEcPsUSVlsO9G9b2
	5/vh3s2O7UiiOYjPfIKLfQ9aXVWhivrk2uvOmGb2FxIS0GczDTT9LBPF9WgVCRAC6a0SR6
	scDBtC0UYHKGN/LiKTCs5r9+Jfh80B0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-i-6j47bPPfSCwcn204MV3g-1; Tue, 01 Apr 2025 15:58:57 -0400
X-MC-Unique: i-6j47bPPfSCwcn204MV3g-1
X-Mimecast-MFC-AGG-ID: i-6j47bPPfSCwcn204MV3g_1743537536
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39135d31ca4so82625f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Apr 2025 12:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743537536; x=1744142336;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nd0F6xrysyZRvdcOwsCXTIAlwtOfRO1g6Ab4Fb92gFo=;
        b=hNWURSaCx3AwLOnH8y8AldMXbmR6LC6iEeoKINLb1AMMLGFdW+MGpxld9vT63rugYr
         6eKRjJYjbFfudAkiE55LVpU7aUDv0zTb4t+LirOB6rqwSySDL64f4S18X66OmFj+uQPD
         l67CVdJ1eb/hX2OO7SK86LUiJrkWzcR13krHHX4S6Wd7gzP5YpFYzHpRXZ7ZSCGU3nQv
         hr9bfBfIHgyGjSMprRNlBybpsdjz3188NJpoDKGelm/E0xjw6KkI0A292d6zglgcWfq8
         CR0NgfFcwvnHlmsamEihrFkJrPpp6RANg5RNXrSWMGVtDVZ6+skRLN9yRodt8Luut8yv
         2XLA==
X-Forwarded-Encrypted: i=1; AJvYcCXNJXD1390MnIwyifCoLUAXEoHuPrSrCVkMLLqsvqNUmW8BiEcakHTVSw3tQmNAUBf05OZObSrNiF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmPfrQXAdVhvXAjhySWKTiI75cUmnLX0E9N7lLzPD3mXATBH4F
	aMFfYiFrMQyKVFAQ382/h82FWI6mK+rMUu1j7FoRJipKNNYSW1sXQ+CFU0+beA8mDWP/BSiGXvw
	GJHHNWwRKdkzEsvAsUwolo1YlpK2v99wpOM41j45XqeSFVZuqQqrr1BtPyA==
X-Gm-Gg: ASbGncv83uMIEurySch25H3v/yFGbX/NPiZbGvQKhUGOECbQ0pSH449QwXAVGJBBrzn
	kByd+AlP4rXy7bvNdQftT73gprqeg/nEg9nhJqkXElbUErEbE3thmKvjcCJFgQ+m1Oi0Sq3720y
	jMDU62DZB+MUMs8WLtp7037W6nN5D1JawdiyKV2nyAmGU71HYLn9pywcBr8lf6z9j2WtjhycEdv
	KOOfsHDyZVdqNGJDFbV0ncr6cBOTv3JiK2SWPb+MEmgQhiGIv1fLK68NfG8oD3ft5iZFeHbPbyl
	Dnu5CaRZjwAZ8e0Jk20jFhGx7gWQZbrTcscu8fEmhC/FMBEe0MvX
X-Received: by 2002:a05:6000:2284:b0:39a:c9c0:a37d with SMTP id ffacd0b85a97d-39c27f04ca9mr1323646f8f.21.1743537536527;
        Tue, 01 Apr 2025 12:58:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgK0wBZX98uYt+wwbKEBeEq2goKKgmKsFhZQj3Wo3bDjsqN1EAiut29I7KBSfdN/p0bRHo0w==
X-Received: by 2002:a05:6000:2284:b0:39a:c9c0:a37d with SMTP id ffacd0b85a97d-39c27f04ca9mr1323629f8f.21.1743537536140;
        Tue, 01 Apr 2025 12:58:56 -0700 (PDT)
Received: from [192.168.100.149] (gw20-pha-stl-mmo-2.avonet.cz. [131.117.213.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b658b5dsm14831244f8f.3.2025.04.01.12.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 12:58:55 -0700 (PDT)
Message-ID: <25ada3f9-0647-48ee-a506-92caa5129b2d@redhat.com>
Date: Tue, 1 Apr 2025 21:58:54 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] xfs/539: Ignore remount failures on v5 xfs
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>, fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
 zlang@kernel.org, david@fromorbit.com
References: <cover.1741094926.git.nirjhar.roy.lists@gmail.com>
 <5cd91683c8eec72a6016914d3f9e631909e99da8.1741094926.git.nirjhar.roy.lists@gmail.com>
Content-Language: en-US
From: Pavel Reichl <preichl@redhat.com>
In-Reply-To: <5cd91683c8eec72a6016914d3f9e631909e99da8.1741094926.git.nirjhar.roy.lists@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 04/03/2025 14:48, Nirjhar Roy (IBM) wrote:
> Remount with noattr2 fails on a v5 filesystem, however the deprecation
> warnings still get printed and that is exactly what the test
> is checking. So ignore the mount failures in this case.
>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>   tests/xfs/539 | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/xfs/539 b/tests/xfs/539
> index b9bb7cc1..5098be4a 100755
> --- a/tests/xfs/539
> +++ b/tests/xfs/539
> @@ -61,7 +61,7 @@ for VAR in {attr2,noikeep}; do
>   done
>   for VAR in {noattr2,ikeep}; do
>   	log_tag
> -	_scratch_remount $VAR
> +	_scratch_remount $VAR >> $seqres.full 2>&1
>   	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated" || \
>   		echo "Could not find deprecation warning for $VAR"
>   done


Reviewed-by: Pavel Reichl <preichl@redhat.com>

