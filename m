Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0D6284681
	for <linux-xfs@vger.kernel.org>; Wed,  1 Oct 2025 13:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759327101; cv=none; b=RgkKfEORl9P7novia+actEABvLDYK+tlOmZMTr2TJKSnuHso5qfC4YmXkXo92Iw7cldZGRj4/QflgRs2X1FLJ+lX9idizrmxogckzL/dGyDwiXVc3LiU9xJylKxwI5RyJO2aQRDy6SkJbE6wjKkbAw+Z2Co+yIjgO8NV0Bgykgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759327101; c=relaxed/simple;
	bh=AErz9DRE4zvoV1QAhCMy5Ce5EIwMk6a2u/GPbn+LmQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EY6gUYbwAfKdoZ4S2w+z3XA9/ibdrI+SHDQVK19rIQp02WCxzA0cdRxNsT3XRX8d59eNSrmPNFROscduaUqoLxXK/nSD+RVqO6eevq2Q8KUu+dEgCjsyAEg6kq+pgZRIYq50YZO8+UKMScQQpih2LgAzDD9ZTh7hPjLzccyvsT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1LKbfYf; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1LKbfYf"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so7445902b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 01 Oct 2025 06:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759327099; x=1759931899; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cHICQ9kYf8w+w6O3p0zJJOxecrN+M89vOZ1OdrVwWEc=;
        b=K1LKbfYfUGXFWYvfX9kmYN4cWonxTWwRsQHoZ/jqJmu2PUT3AZ+tIn6EUVgftXh8tB
         4WXSJ2H2fGyw4k2cz5iknj4W9+t4WvIgkeQAZChB4l+giybjKfJDerXnTOpfPNbAglXC
         tj82md1n4DRn171jFJGeQs6jGmklWW4Rlg3Gy0dViy+sW44/D0J862hcZaf6X+V6ysu3
         /6e1ag5aAFU+CM4J3aewn6HBL74th60oJYAGw2MiR7R6jLXlkQE+UzN2Ptj9lcCX1JvD
         uc5cFR9Efhdo1E+n0KB9ZzUz9vPQ6CHBWFSUY4ttEqc7yeeEeEIHvmkVNPrh64/CGTNt
         z51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759327099; x=1759931899;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cHICQ9kYf8w+w6O3p0zJJOxecrN+M89vOZ1OdrVwWEc=;
        b=xDprK8gJNDtc0r8FzpDLNotmQ/b8c/eK6hngD5XIdzkr0DeXZU0PCDOHm4ifAvP5+G
         gRXNLADCZb2aD26FRs3Vt+vjlE3a7vgbGNXsxHvQu8jVl0HYs0R2btxubrocKwAJ+EmT
         xyNl/YMguVfwWzxRsOpUJ5UAjhNfsrjW9rT584IxOFaE6MNGonCvjuEbXJAbV/hb+bos
         ea7Ow+w5PE4Lq3nuFTtP2PdGLIytA2qYfnMdh+jw/ALjC7A7HiwM/nFtCfGbnuYyOmQR
         Kl8IymGmQCdbBLIIbojRPGFUhN7pAPo/zJzSPXgLCbiouhGXp/Ik7z8Z+ZJHtKit4wg4
         CKlA==
X-Forwarded-Encrypted: i=1; AJvYcCW0xSDKK117cqijH2L8Cx/Rjdzl3K576cvyJGGDfIeA+dyGQLTW6YC1i7u/KQq4ppZPXOKmIAgEJu8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwr2x1EPdeLRt7CGQAjPLeOxiXWNK2qjzm2AmbRyDzBpxd0H4H
	nqY08x5T3IodhK+CjFaShquBZTOP1as0mxFthubvYJEsO4/Th5pbtKpf
X-Gm-Gg: ASbGncuQ9KSbFZyoec+mSvjQUkHto9FQSOMngtjfZi2gEtP6gOBRF9txDLX8syKVUvQ
	SlsQwtCOKI9T5+G/xFWgaFBYltYZbjsG2jNYcrkEH76E9XvYe/2l0vARgmL1wZPgwnvL2PrUJVR
	yTldqxW15btEoZxQ/sslkEBhg9CEkrpDH6S9bcsxbp1PL3KJ1W9tJmY02lP1MSXe+61helU1wD5
	oP8/2EedhIt/WxCIPP5BVhp8CKyKXv3yZuKCPN5f9E2IfbJfchm4geYtfR/83MlUqGWwJ9X77NB
	hXjNhrwvq12dgRXrNBt5Tp4nANUl7esBQHO/TlhJ7U5TEVqG9ATnfSv6Qs4Jz4NpAHjr3BV2uIu
	Cnr42XeZ8Mijf/XqBVRMTr1eJYxsArvXwAnwe2F7cyWAyRyCyPsahHvJ4hjLV0YKxppUchA==
X-Google-Smtp-Source: AGHT+IEVrUrSHnJxKWleti3ip/7ssnZbESbu792noCsfEcKl9fEdE1xbBALgSKgo50vIeSR68LO4xQ==
X-Received: by 2002:a17:90b:2249:b0:330:852e:2bcc with SMTP id 98e67ed59e1d1-339a6f38013mr4558738a91.21.1759327099110;
        Wed, 01 Oct 2025 06:58:19 -0700 (PDT)
Received: from [10.0.2.15] ([157.50.95.38])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3399be87425sm2129797a91.1.2025.10.01.06.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 06:58:18 -0700 (PDT)
Message-ID: <425ef7bd-011c-4b05-99fe-2b0e3313c3ce@gmail.com>
Date: Wed, 1 Oct 2025 19:19:13 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: doc: Fix typos
To: Carlos Maiolino <cem@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, linux-bcachefs@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org,
 linux-kernel-mentees@lists.linuxfoundation.org, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com
References: <DrG_H24-pk-ha8vkOEHoZYVXyMFA60c_g4l7cZX4Z7lnKQIM4FjdI_qS-UIpFxa-t7T_JDAOSqKjew7M0wmYYw==@protonmail.internalid>
 <20251001083931.44528-1-bhanuseshukumar@gmail.com>
 <kp4tzf7hvtorldoktxelrvway6w4v4idmu5q3egeaacs7eg2tz@dovkk323ir3b>
Content-Language: en-US
From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
In-Reply-To: <kp4tzf7hvtorldoktxelrvway6w4v4idmu5q3egeaacs7eg2tz@dovkk323ir3b>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/10/25 17:32, Carlos Maiolino wrote:
> On Wed, Oct 01, 2025 at 02:09:31PM +0530, Bhanu Seshu Kumar Valluri wrote:
>> Fix typos in doc comments
>>
>> Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
> 
> Perhaps would be better to split this into subsystem-specific patches?
> 
> This probably needs to be re-sent anyway as bcachefs was removed from
> mainline.
> 
I just did a google search and understood about frozen state of bcachefs
in linux kernel since 6.17 release onward. It is going to be maintained 
externally. 

Thanks for your comment. I will resend the patch excluding bcachefs.

Thanks.


