Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94183947B8
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781642897; cv=none; b=L5dy3qKHRVPPmsMRxLU43peYyvqb5nT100ywYanuP6OCIye7vCGjPhpP4vXwlsvKIbJmHh1Onf2nJzWdXPlNWAt4qwd1PaxjfJ6Q+uPkvBuQFIqPWLUVQpGw7NYEaDfW79zbVNi8ALbXiLK5ji+yfRBmxhNR5vwKsxxQ35y5EDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781642897; c=relaxed/simple;
	bh=Sw5kaEYR+kOXbMOw6h0GSGzuO0FP6TMElZAcRsybMMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XDp1PpfcLWhF5LIeTq5qOl6jy6z40PRCo84yc1T8i0kZixpphsefWpTQb/MjYZ2OOdek8MmzKBti+2EpziBOrmPrFWNjmWXiga6nxJy2HG1EyB67ymtOsumcmNRJWquEizVlp6wcuZPKxCJZHOLoGb3/PDQyq4pzS+7Oc5AFiEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=sZNhXX9+; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="sZNhXX9+"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-487135fd4f9so2067314b6e.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 13:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781642895; x=1782247695; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vHjBmEtaY4MZyV1ZaXFC26z+hDeMIBdFKC6hpsQyryE=;
        b=sZNhXX9+cpbkSuQrhd/qkVQ9KMH3MK5AEqY2ezI3n3tT1VZzI+G7CTD7+R8ZgLGmaH
         hWaORWu6giR94C52lhyZfjX7iTve0DPwv6YIYH1jVlQ5hAZ0vj6cLwaFHwjFRIAetijA
         9w2sNQewsF/ifGCOHm+Wvg5+cmLpbkU8eurUQyGiJlz/R3ilAKxEyunoMSjeaZGqQnby
         oIvGV5C67Kl7t01rdI64ijkrzxsltfL88+wBVdLcjMrPO1b2V0xqg+SvnLQ7ncXp0uQ2
         uTaq7SHsZNLiYSAOOy7V6E+tzOFxF3wzNECrwH91h3AW9p0697UZNO8bcDXFsgt9DEUy
         y4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781642895; x=1782247695;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vHjBmEtaY4MZyV1ZaXFC26z+hDeMIBdFKC6hpsQyryE=;
        b=ARk8tUVfvI8WNcJl/NEKz6auplaGU2yARf5Fs+vk6izNdxdYJGbpKu7oDqXrIfrEAH
         444QECfnhnmohlTM2tizGsnuY1nR/kGamXi80wU/spPoAJlFDiWdodMBZdkE42h3MZHf
         tyJbklO5C1RoK0l/cQBl/N5edr99vdHPfV7FmiNKDFY4XU+Yl1etX9Xp2mBGUa8sfMJc
         D6odO7dX7gHIONR0IGTxVoD2tyEJC1Ke7w2ugGeKmQdhlRiMjwPVe+sOuXMLmnZYcyod
         eSbfkIqbzuS1MWLnc2YFLtCYtysLqkMxdvZoFXvTij9jzDsNnXoCfpWezyUZ2cAzawtD
         QKEQ==
X-Forwarded-Encrypted: i=1; AFNElJ/c0nrDCRInK5chPuJFx0TaVv/hK2UmCd2RRgkMxf4X7xT5AojFR3Evrta+Ax0BaolMb93qWeXaR/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1k141z4Z4R7qctBPnQJsdbPEKpkg1xM0xStkRImNQkO2uApd0
	pvjGLantA5d3Kbcw26cFssHZHHMym2WvLuD6Zfb+SA73ly3t20x6LjoWo8tm30/3sIc=
X-Gm-Gg: Acq92OGT8RPruauTS23YPURsScKOyyWL0gUH0dQLSqbbZCSSntIQI19nXUNaZPxoNDM
	UJuZuWLkjVRqmdiYAFMCnQfPuN8u2GpsSYXudcLViwrD/FvtA3dY5gWvKQRqoyOWg9rUo3busI1
	yXTrcJDbjv1j/90QZSEAC6Ydmon9/V9HHd235LyyTder00jIdvvUhApLsnGuEXYwOWh4KRaEH3P
	44Z8fuVBS4eOnBJtOVMLsdVGSJRM4wVx1KG3eu8r7sGQPV37sJsdQbtmsgIIzqx/qA9jzi7kzPX
	86dalqGUA0eh+5l7bM5OC1TNIW9myfN5nL7EffKuZL6ga6PIENDhvjBdSMBfrydqlFpRVWnPsSB
	3adOExaZYPF/wtqLNHaRCflpbLNXDP+ewqVj6U2O8ExyRbgUStKCFXQQLFh9HVOA4WvKdL1OGCG
	UU6FY2iI8oubSp0vBj5pGRmFCptQP7HWZ52vP9jMoPvUJPNU7gtznGMPzYH7S6J5CJEQc/4p4lK
	4egx1dsMQ==
X-Received: by 2002:a05:6808:f89:b0:479:dc74:3696 with SMTP id 5614622812f47-4894285f7a5mr987811b6e.7.1781642895670;
        Tue, 16 Jun 2026 13:48:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4875dfe4a89sm5237391b6e.18.2026.06.16.13.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 13:48:14 -0700 (PDT)
Message-ID: <e94bfdb4-6932-4cae-9693-6f0d6f51aa17@kernel.dk>
Date: Tue, 16 Jun 2026 14:48:10 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] btrfs: use IOMAP_DIO_BOUNCE flag instead of
 falling back to buffered IO
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <cover.1781597506.git.wqu@suse.com>
 <ajFFYT10i1dvAy89@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ajFFYT10i1dvAy89@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/26 6:45 AM, Christoph Hellwig wrote:
> Note: You'll need to include Jens for the block bits to get either an
> ACK or a merge through the block tree.

I can queue 1-2, then Qu can push the btrfs change in once that lands.

-- 
Jens Axboe

