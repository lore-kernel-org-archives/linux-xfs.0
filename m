Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C331A22256F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602998; cv=none; b=IWh1NYgnSdDV8aN2B7dq3909I7Ya6Atr4nfpsEWzct11r2geUJTvAaO7XYTZqzms3A+hRk4c/yumJ3kfu/wGJFztuHPf09b3PLq1lolhVKlofVAyOfIxXPbCQ2DmkvMaJ2KaQtZTAOoGcurf3iw9w2QO4/DtPEcr4C+gP6L+Jpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602998; c=relaxed/simple;
	bh=vFWdb3PBX2zBDqdrtWvluSHxOAFMa8qzzSmnhwckFpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LI+Pe/2BQdip3OyVSly6mgPjBcIs3JQYHhyejiNtXJRsUpyzWkvrYw4uJD7sk5EZjRAkNIZgiWj19tj3l/ci1oQUt6xkwJL3poy78kizgLxkbr04S0pitbGd6wNq3fIoqJSpCjWQZRTUzBXrX3+kvOmHhZFEI1paw4HCELw6h0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kjJ8CTRp; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kjJ8CTRp"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c2a9a9b43b1so3826411a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 04:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769602996; x=1770207796; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oUdr6DX+iZadrtnG4gSybF93zfd1qmcT/Pp5WRh3xdg=;
        b=kjJ8CTRpl7iN6Si2cCJhQcHgNw6V1gDkp4xAQWZN/PlY2R8pAAC/O5tlN74HgxmKIz
         gvOwkn0+CzTCsYc11vXg6nPEhDRfgqUJk08CXapeCK684iMU25sJlKh7lEw2rmD3qmMK
         SBgz6WYnCesfDeGxRVz1p/IYQr9nVV1SPIqEftX2xVj/Aj0vDveQ9u8unmdp6OAjS2Ui
         0yFpLfy9BVObbYhmkyepBajds+bG4mRxyLUCaKlOW4BUi06O7JqVB00UoJfRuHEyQwQS
         zwlpzoyevFpxd20UbeyMSdk1HuRtanMOLcC+YKJcohLXLnCfxeJlsP8FZ7ERqOuHPKZP
         5LgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769602996; x=1770207796;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oUdr6DX+iZadrtnG4gSybF93zfd1qmcT/Pp5WRh3xdg=;
        b=BTRzte1Ke8EnZbuoK3lnt4FfCIWeYBmIzXT48SnvhgQQsiztN0C6Z5h8WCZjJNzKE7
         mQPwuwkx8qpy7C22tffUe0aCaHKLEt3XFPcKpZEMRfquLJ+XRfsHJrB4wQaNQ+jROLcm
         A/5jyokftTIgI3qmDeM0fbbpii7cVjYKcrWjo/ismhH+QU8mE2uP9A6LlMHSCkbXyQrM
         7WMa0VfBAfS1p0fbHu5+XTvgLZH5Vva6w9eGS5/1DZDznj0VJYaRFJFeWSZNSyLfVbLD
         bpDX9UxXizMO4qeFlVHU5iJC0UzdJYh9DMLjB0lUNfDpihQZvMDmYmTPjfwmiDsRjcl3
         oRAw==
X-Forwarded-Encrypted: i=1; AJvYcCUpsfsUrDztnG/mKsbmArobEQO9vai05cnJW+bWv638C1g8t+hVCidimH40q86sSQAZFaGTZAibMrc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9L9TkfLfuv1TXRcCBhEYtQ1YVDPADKovUpWk88Vrz/cQvVBAQ
	IUxLqaWYMYvoatkVMDwpoZTJSukBb/BPaVV7MNUHerFtmYm5EgARm0VkdovhQ5/7Ayl9YeyNSLR
	3ddrd9Vs=
X-Gm-Gg: AZuq6aIrguRVVO0K+v51NcEiQOCt1kI30xL+Ojb5qE1dFsirKIzqsWzJ/frqIN844cG
	fUUp/nUDHG3uV/6Cz/4bYdTwxHjuhCqc9mD4O5Ejpug6yxe6dYIyaQ4uvmxIeKmueXHM49AQJLu
	NCfHBwR2BohfQgIaMlImlpkvShIaka+P5GzkYLuiYm8VnKzjJasjA9o1wRf482ELcoDYfSaE1AL
	FqU8rNrIkDwX9SG5fKpuE7DOxz2v9YbzZiH+AfdAopUpBjS+YT9uEAxRWmXP46NqdhJDmwCXXL0
	+P3TCuPXqklBQmFKJRFUUuxLo3fOh7y6kFMsieEKsy++mfuW5RgT5TjetSQnrPg6RrgjL3eG4J4
	mpd1N8JWq++lcQeyGIHjCpK0q8HMK9r/j2n+3rnLcSwHGvRA6VNy+6HDDwuoj2X8IxI+HSpP2K8
	LCJ85N3zCuRk/ZZUoDw0eGRM0zDRyjWSpsYn2M3/PoNrfV2EA8g7uEwuKGSEeivGYNmPJhP7A=
X-Received: by 2002:a05:622a:2d5:b0:502:6ed5:7b0d with SMTP id d75a77b69052e-5032f8f0e01mr63543941cf.48.1769602665322;
        Wed, 28 Jan 2026 04:17:45 -0800 (PST)
Received: from [192.168.201.17] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5033745c4e3sm14749451cf.6.2026.01.28.04.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 04:17:44 -0800 (PST)
Message-ID: <16e41d3d-401f-4600-a304-08f1d2ba6892@kernel.dk>
Date: Wed, 28 Jan 2026 05:17:42 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bounce buffer direct I/O when stable pages are required v3
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260126055406.1421026-1-hch@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260126055406.1421026-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/25/26 10:53 PM, Christoph Hellwig wrote:
> Hi all,
> 
> [note to maintainers:  we're ready to merge I think, and Christian
> already said he'd do on Friday.  If acceptable to everyone I'd like
> to merge it through the block tree, or topic branch in it due to
> pending work on top of this]

Queued up in a fork off for-7.0/block, for-7.0/block-stable-pages.

-- 
Jens Axboe

