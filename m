Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6937C13D2B2
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731517076; cv=none; b=Et3VUN31+6ehzChBsEBIH97rQRHZlAZbRToEE0VE+EnaY9Q+QE7lM45vinmZl+QLw6zOGPNSNbJsLV4DBGoClzq74SGvYkkGGucxdlC887EQ8D5W8EWxEKqzdTAMg4IDZhfaeMRpXEvmuFO0yAzzfWtLV8cbp6ksXszrU+aPav8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731517076; c=relaxed/simple;
	bh=csPBoYSDByNBHf+k5gUPUX7+wR76Q1hEBFh0oJb/HtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ebNFEV95MMXc0c3cPPAzc5beJLGG1+h5R0dgQ+SIhzpvDpTxjkmb3VuEi2vkO+Ua1HSYkuHqcuj+cRnHrqsCe+XLb3BgkFt6LstJOuxmaEcgsRPylFrL4unmrrbmkwbaT9L4W/LeGRHkI7jcvCKFCfBc//kOvtqRedofKM7Byzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XsocD30/; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XsocD30/"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5cf6f7ee970so1034968a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 08:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731517072; x=1732121872; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r6dKI9I0XiNa6P0LadyJEAqhNHGcRQ6Z3i6i70GfR1Y=;
        b=XsocD30/gXul2vROh5Ys/l609H69kF00w7ADaURIHXGD2wnw+esQzMhYoLpPUNux1E
         enpgwxayRyyogPs5s0BfTt4louTe7d2f64Fs7nPY/zaEBDf8mHLPx3b/3tIkSuvLY02i
         HEoA0zTwcH3VjX7zxw3Pp+HS25XsCpSdpgnkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731517072; x=1732121872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r6dKI9I0XiNa6P0LadyJEAqhNHGcRQ6Z3i6i70GfR1Y=;
        b=RJhZTB8TQEdh16VlvUrPFvK0p5jCwvbtPH04xpGx7Z6C93+Ml1JiGO8MyYh8IvrR0L
         SEHqxslRZ6CGUUcOleQup5zU9dNvEfBRV9aVeAG1eccsSmixp9/053w9QkrKVjYMG2P5
         setCxH8VTAUqByYVj9rZ5PlVHKlLgTLYr0ws6dfo0l1nT5vjCXSso47ehNeWTdBLNJ6R
         vox8zJstuahmgPe1litaf+J2853z+NV2/VSasT8ImoP9maUvsUCrBe1zjU5CZULa/XSq
         PO8qPXJpipbFw9aQ3Co5olr6HA45cuVfFywow2q+Rt8qr9LHUtOl+YNH1wQ7nc7a4cPG
         57og==
X-Forwarded-Encrypted: i=1; AJvYcCUO6sBbK50tNXuyq7xS1phGWNbSgCSyjC/4E16MT+VAbCYld0bx12Euy7gfLJ995jhj0ZCOfpsAs0s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvcKvYCUbeJABQJBawLIJL55Ig5DpNWVrOtAbhZKbbUeokqsJ8
	ArWv3xSHbM7BdcYWdbFDvRv3IWzc1arEAaewsb10TNkS3A3md54kxGHNDb9slkFq/wkrUWFMdHK
	oRsgXfw==
X-Google-Smtp-Source: AGHT+IFQJfZLPdwDUAFW4DOIqOhmsh2gG7EGsoWN076zUd6p0sCWwRu5s7NicrBulN/dRkE1FreQAQ==
X-Received: by 2002:aa7:d953:0:b0:5cf:66d2:103b with SMTP id 4fb4d7f45d1cf-5cf66d212eemr1832777a12.30.1731517072526;
        Wed, 13 Nov 2024 08:57:52 -0800 (PST)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03b7e803sm7442775a12.22.2024.11.13.08.57.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 08:57:52 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9ed49ec0f1so1197058066b.1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 08:57:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUnIhmBgL2hbjpy06+nVvDrxjB72X1auXASxEKlVbP3yvxp9rxyo4EbEiqZsdIsOVbfZlJ65WfQzVw=@vger.kernel.org
X-Received: by 2002:a17:906:7308:b0:a9a:3718:6d6 with SMTP id
 a640c23a62f3a-aa1c57ffee4mr725890666b.58.1731517070805; Wed, 13 Nov 2024
 08:57:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <141e2cc2dfac8b2f49c1c8d219dd7c20925b2cef.1731433903.git.josef@toxicpanda.com>
 <CAHk-=wjkBEch_Z9EMbup2bHtbtt7aoj-o5V6Nara+VxeUtckGw@mail.gmail.com>
 <CAOQ4uxiiFsu-cG89i_PA+kqUp8ycmewhuD9xJBgpuBy5AahG5Q@mail.gmail.com>
 <CAHk-=wijFZtUxsunOVN5G+FMBJ+8A-+p5TOURv2h=rbtO44egw@mail.gmail.com> <CAOQ4uxjob2qKk4MRqPeNtbhfdSfP0VO-R5VWw0txMCGLwJ-Z1g@mail.gmail.com>
In-Reply-To: <CAOQ4uxjob2qKk4MRqPeNtbhfdSfP0VO-R5VWw0txMCGLwJ-Z1g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Nov 2024 08:57:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=wigQ0ew96Yv29tJUrUKBZRC-x=fDjCTQ7gc4yPys2Ngrw@mail.gmail.com>
Message-ID: <CAHk-=wigQ0ew96Yv29tJUrUKBZRC-x=fDjCTQ7gc4yPys2Ngrw@mail.gmail.com>
Subject: Re: [PATCH v7 05/18] fsnotify: introduce pre-content permission events
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Nov 2024 at 16:06, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Maybe I could use just this one bit, but together with the existing
> FMODE_NONOTIFY bit, I get 4 modes, which correspond to the
> highest watching priority:

So you'd use two bits, but one of those would re-use the existing
FMODE_NONOTIFY? That sounds perfectly fine to me.

             Linus
