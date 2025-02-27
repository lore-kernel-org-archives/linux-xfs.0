Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C1E23816C
	for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2025 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740668719; cv=none; b=laFJDDbs173yps5LW4BEfaCvrSBTi3kb65H6ht+L9Tt5ncHUGtq7wmwc62F4CkXPVGISWBYmyGjo3CZkpru5c0ttHMeBSkRI7JkL1TGhs+NJjim2M63kA0IkXTfpesKJfmguhStj012RMk48u16RXvhPcE2f9ekirkca8flMpTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740668719; c=relaxed/simple;
	bh=zPtFTW9MnWY5Dq9gnaoERgft2PEz093AYw6aSafZ+FY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWxbGvViy6YIzLQ3mbLh6SEawmKN9WkwpQ0DjJve8DtIRR1L54/PBD23mU+pMIktutUxnOuSVQ8UGsU42DCCj/PiN7BMHsz6pI+D8EenpPxRLh5GUchJLYnlByA8y8goGxfQz+Gb5Uyt35sLwieAcnix8LE3Vz7LuES14InCjpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oyt8vvuZ; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oyt8vvuZ"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85592116ca4so82958939f.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2025 07:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740668717; x=1741273517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ic58lyGCp1MAy04s53geTj2JzDZ1PbEj2+yvGnH8jm0=;
        b=oyt8vvuZDGZQdhGRNpsYqT1eTIruVgI7U+7qkhxxxj2Gi0xMfR22gta3pEPna5XlQx
         diFFsSoalQINu2ICZYZjSSS7YB9kseEuIFgdrcwtmlraM79+RHstrhnhRW8VR/gePSKL
         eb1MarkFACGG6grRKRDWrI3Ug+wT3WLdnpzeVvU0MsmK4tXRIpw1V49vINZvdnLR31xQ
         tc4YPCAWJEGrmSlgGfaMlzQPhll8q9r1qgXTqxPzGd3T9tnkqw5A2+PYBlpWFmnG9LPe
         L4EkSJ1V2U+a8SA605wzgmg5Asw4nlbVgniaitjMi54XDdCjkPq0O6mSLImKpof0NBI1
         TtsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740668717; x=1741273517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ic58lyGCp1MAy04s53geTj2JzDZ1PbEj2+yvGnH8jm0=;
        b=IYdE1SzqZvWiVZVliw4Z3CbPaMENWfV4OX7+FnPFMjxMveyNCEoo7TAj5rhneBMhTX
         5Z8gxOvRjWleDotdCw5ckZNpY+fxU67Jznv14bvdfuMt6qL/HMeV7h+myiDvkQmeHvdi
         is3amw/msanrAhqJejUFj4Y4rc7g1FXhdlhIgSUBV/DlX2Vlk3+ZwnRDlImp4y9Yu0Zd
         L/glW+3G+kdyZdj3A8ZKd6Y/xXHp4xjgkb3nILHdISWQ7+YsGku7Zxacq5qi67usuVlt
         qhl5Vwbqy/KR/QNdbU7y4ekoyaMJXNMc9cTJ3AKoxN/DXfIh4vkYRJwzkQtVcwaUoe/i
         i6bA==
X-Forwarded-Encrypted: i=1; AJvYcCXfgTpGiOEq9ASzrWzsipPosqfqdFADaT+PGnhzFPlKksc7uKBzf7DyoOE+SGdorPlj/2UZbPX2Rhs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjR+l6DsUxtoQ9KLeNSqEAX9RC/UdldKF92OWhB3mQ3vWWtzvc
	XaSSZzke1cBYQZ1QdGXb/bPLsp4DdkaJBAj8928H0gFofLmGg848HmZ54quiJ/vcy+jqdJVXYoM
	5
X-Gm-Gg: ASbGncsQhTXoZhfNHFkprN3vrH+cApdrR8wEWzC/mMw4uIeCgSad12lh4kFT3dvK5zh
	3D2y4PL86jSVz/JOb7UcQFaiUpUlVpFP5IX1Wnw3obP4AMsZb6yx0LkHkZVQc74ddnTYldue8Rs
	V14cmLqeLF+d1WNbp8IbQ4RHl6m1ZlQn5zsn2NWawKzrH17WvDiQhltUR5F3181HGLL2wdUevNL
	m7YgCit2+W6ljXdUjqh9mDcACpAjWIGmAyGZwn3QaQKXdaJj5MCw5piB97V9NIwRbc/rHnpybQr
	oR3c0qQYLc3I460DzvY27w==
X-Google-Smtp-Source: AGHT+IHIH6BlLS0SxlbTDSqG0EJDF3m8oxx6dlzbNFcnjKBFtoaWi6LPiFq5Dh9kCUZSXOsQXC/T9Q==
X-Received: by 2002:a92:cda2:0:b0:3d2:b0f1:f5b5 with SMTP id e9e14a558f8ab-3d3d1f14038mr92382965ab.3.1740668716908;
        Thu, 27 Feb 2025 07:05:16 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d3deeca830sm3418965ab.55.2025.02.27.07.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 07:05:16 -0800 (PST)
Message-ID: <234045ff-87ef-4403-b97e-ef63438ccf2b@kernel.dk>
Date: Thu, 27 Feb 2025 08:05:15 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/2] Add XFS support for RWF_DONTCACHE
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
References: <20250204184047.356762-1-axboe@kernel.dk>
 <3qAP6uD7IZfsvM_o-0b_bXiyjJeNN1cMEaz_Nwk3W6LJ82RK423PSvZPG2VLZU8dIA4Cq1F5uU50XmgFQZgOTA==@protonmail.internalid>
 <ba718fc2-08ba-4d7e-98f9-47f3f52c13a8@kernel.dk>
 <vc7eqsqiyb2pnom4ekaaxmz4abt535a73bnathq2nxbt3yspoe@fnehin4xmzdu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <vc7eqsqiyb2pnom4ekaaxmz4abt535a73bnathq2nxbt3yspoe@fnehin4xmzdu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/27/25 2:25 AM, Carlos Maiolino wrote:
> On Wed, Feb 26, 2025 at 10:30:05AM -0700, Jens Axboe wrote:
>> On 2/4/25 11:39 AM, Jens Axboe wrote:
>>> Hi,
>>>
>>> Now that the main bits are in mainline, here are the XFS patches for
>>> adding RWF_DONTCACHE support. It's pretty trivial - patch 1 adds the
>>> basic iomap flag and check, and patch 2 flags FOP_DONTCACHE support
>>> in the file_operations struct. Could be folded into a single patch
>>> at this point, I'll leave that up to you guys what you prefer.
>>>
>>> Patches are aginst 6.14-rc1.
>>>
>>> Since v1:
>>> - Remove stale commit message paragraph
>>> - Add comments for iomap flag from Darrick
>>
> 
> Hello Jens
> 
>> Is this slated for 6.15? I don't see it in the tree yet, but I also
>> don't see a lot of other things in there. Would be a shame to miss the
>> next release on this front.
> 
> The changes looks fine, they are for 6.15, so I don't push things to
> for-next for the next release while working on the current one, I'm

Hmm ok, that seems like an odd choice, surely you'd want things in
for-next earlier rather than later? At least that's what everybody else
is doing.

> not sure I got your point. What else are these 'lot of other things'
> you don't see in there you mentioned?

Oh, it was just a comment on there not seeming to be any xfs changes for
6.15 in your for-next (or other branches) yet, which made me think that
perhaps I was looking in the wrong spot. This where I looked, fwiw:

https://web.git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/

which does seem to have a few changes for 6.15, but really not much.
Maybe this is all normal for xfs?

-- 
Jens Axboe
