Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775632C375E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 17:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765990895; cv=none; b=Lg217HnvYmXKAD61cuIo8W5DaFDaKc+71S/LOxuSjHre2iO0u0e2VqRFjPxRpl2bgCTVZgukI3VWLN+fqxID737zD0URsZKZKh2p55jFr+a9BRPTDIDat06RYvZVe8iDTlQYG54FL6hXMjWKiK9LV1WUGdnq4/cxMw0g6dBx2OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765990895; c=relaxed/simple;
	bh=fpFnDzhZoXXWC4Kp8cec3dL+gf7xE0QtOfAURsHF3rM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o3Du6MVh7bwZ8sIg0+jkecJjdHER+4H7oEL/uAfnNnGg/q35udHatoQPvsoQW6bLVi3oqM6znmjjg/xjjblvCL4DJojCegLccvy80p4KWgi+6djipRwJMkI3HzCXzJqA++a50HnHee5Vou7V0KkaRnhwD/2r2AEjUymOMmlmorg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRNXm6df; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRNXm6df"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so4912963b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 09:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765990893; x=1766595693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M+FQObq4BlmA1znanAjBgJXenx2Op3zd07yw7QPGN50=;
        b=JRNXm6dfFTxJU7MeiG6VfAxetUn2Yymb8CujQpCWkCS5so955BfghZ5PbbwGBsvvxN
         6Bl7BjhAXs5zuEHUEm3AJYCpUKHdOIDVvLeY+G+yB0lsui8K/R9d4F5vzYYc3q2R9JJF
         sF0wdZvx46yWUQR1LKZX4GxT4h8+Plr3qElmcP/ai1ph/AnWVWz68ay67R8mSxBqv6tu
         GbVebgvwy0NXhLmHqz2WQ1cIVuSTWicbJZC2BCo7YIB6QpI+cMCBEHSPAMQdaSCgNPqI
         ym2dT9H6I8RitVl7RqleKcr7NdEC4XhT+6KMy6kQBwtyuPlP512n/Q5QWHydjYXCIuz0
         1JeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765990893; x=1766595693;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+FQObq4BlmA1znanAjBgJXenx2Op3zd07yw7QPGN50=;
        b=Lj3ob+jL4a/vXVznByPxgqfvFqeXKOH5/6RJ+D724/Rk1goKUOotjAnEmOZ5aWzVIF
         7BZJyDRbjJKw1eMcdE+6ve9v7+XW5JemdTyWM7chBCnuj8M8G6vOd7dHgVHMklLAD2gM
         +ID8xPMk8baUA1sN5KjPCNHG3POGYYVVrgIdUaX4eDKyPlpzXh5u9okSWFe/MCo1CbPR
         mgiMKRZBm/w51an20k9OWjd+0tm+lHHSbgOHRd+zmB24rVKd89y5O3yn31bHUlDjpnHV
         W0rq+Htvd5/Vq/3l0Zj7qSksi3yn23dfOueFhfb9mLcAAGRDo1HFHpPDT0iAholplVEj
         iNzA==
X-Forwarded-Encrypted: i=1; AJvYcCXL+hQ2/CejfnGLnRSgKDgZhVvaXFGAR2dWEBsXvmPqVCzD9vQ6jWhwfkx2Uxj7CwCDIuuycIvBBZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqQCTiqdYLGa/Fk2ZKAzLKE+X0b2RMvI6I2N19Ea7DFkugzFXX
	iXaxF1msub7RMqdBpyoS50LFpWSkcnmZZnXbj0N4Nd854IaPUeoM5mrQ
X-Gm-Gg: AY/fxX7V72I+lviQb8PhkYUfobrM+n/aWj2LEFTZl9bUwNzxufaZT6LC272e8vB2Zeh
	A3iQ215HM0f9ICnUewoStwS+aJ1IorD1XVzmZQjzLrT+R4439dXswBLC95IrEG5KbHKdczuyNso
	TEVIJKpw5XUL9dz/zPB4mUfseT83PmtOSi0JcmJLawK1Uv8Jfq4PzpsEDaHP63edgeprXRQ09S6
	aNQhUXE0ENNOakYw3asm6CzKZ6wuw66oiN0osjkyDjMtx+/EVLirzwVtVwbV5cpwZGwXMIza6Np
	R6BubhQfECj7VKtrsbvlvM8dNMqWYs9dicLLDObcxKLCwZQ1eqeDZ+/BbjVr7fOVOMjrW1FxwK3
	7pHrXYUqbXpBsKVHhTK4U6awWliZIuXGmi8kWvEVG5+x8TXThAVdBKFv9G/cWy7RBZJkbewj+ZP
	jLMh9qpI7OSZa/6OQ=
X-Google-Smtp-Source: AGHT+IGDtgBQ4KQcHdb1LBCvEWJkZILPcU9I11r/0S4sbvgYuq/WsKBoqpiccDIsNUdDum5ypziV5Q==
X-Received: by 2002:a05:6a00:2993:b0:781:4f0b:9c58 with SMTP id d2e1a72fcca58-7f667935e19mr19497642b3a.15.1765990892447;
        Wed, 17 Dec 2025 09:01:32 -0800 (PST)
Received: from [192.168.50.70] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe12316e60sm12290b3a.30.2025.12.17.09.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 09:01:32 -0800 (PST)
Message-ID: <f9913843-07c1-4750-9545-a5af47f5fbd3@gmail.com>
Date: Thu, 18 Dec 2025 01:01:28 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] ext4/006: call e2fsck directly
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20251212082210.23401-1-hch@lst.de>
 <20251212082210.23401-3-hch@lst.de>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251212082210.23401-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Looks good

Reviewed-by: Anand Jain <asj@kernel.org>

Thanks

On 12/12/25 16:21, Christoph Hellwig wrote:
> _check_scratch_fs takes an optional device name, but no optional
> arguments.  Call e2fsck directly for this extN-specific test instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   tests/ext4/006 | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/ext4/006 b/tests/ext4/006
> index 2ece22a4bd1e..ab78e79d272d 100755
> --- a/tests/ext4/006
> +++ b/tests/ext4/006
> @@ -44,7 +44,7 @@ repair_scratch() {
>   	res=$?
>   	if [ "${res}" -eq 0 ]; then
>   		echo "++ allegedly fixed, reverify" >> "${FSCK_LOG}"
> -		_check_scratch_fs -n >> "${FSCK_LOG}" 2>&1
> +		e2fsck -n "${SCRATCH_DEV}" >> "${FSCK_LOG}" 2>&1
>   		res=$?
>   	fi
>   	echo "++ fsck returns ${res}" >> "${FSCK_LOG}"

