Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E6B33A027
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 21:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765920837; cv=none; b=debYEMt6DblffaGHxrbJy5jXVo9aTz4fErY8cZdrIP1Ozs8hVpLDUrE7S2B5DDCT+3pMRIG8n4L/jteHNE3hrmOdM5Qt3yQV7DQdVTQ0h6+L+8fv7Kj3+yJ+Ksf0r1FwgaNcDVutzH4sgZpaqCh7TgBO26Wk3x6G5aZl4ecdF2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765920837; c=relaxed/simple;
	bh=wZaXf039VWSmJCJFa8lF9O5x2D3JUq8UNo6b6d51bN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYxpup2Ml4Rhg2Yzbgl13SYUSxyjLPJ5ot+sDr0bv4tSxwYfHAFmE3X0gAj+nREZuV/cOLnqay3R52SMOfEac/mAxpggo9+88fqESYE+WH6VwjT8goxEL1lwGS4lI4CvomHHEo6pmzvD2brEBnTTh750qQ/hBcETbxyfgcKqxGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=a9SzKSxo; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="a9SzKSxo"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so5801687b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 13:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1765920834; x=1766525634; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m7yAZPkwxszj+No3xxGU9I0OwUlCrp2m8jom5MWirYQ=;
        b=a9SzKSxo0MxYBtZzOMhZ89bZYVwN+Jei4Zw7zG5L+pcobpPMSAX/VTy561qzQoXRoc
         OKacuQaY9zsNTmvsBM2TYpUdnNktPuV4Uj5sVHAWT5Ty7wFozWFkn//fIMNPnwa781XZ
         4nT5+QhsIzOH3rNIOAGK1TYtOqX1oHJJTSsLDsVKCGo8u8ZTxkpqfWexvKStljFqk5pB
         v/5FFd3JIvMG6/UeQqF0CDA6+SNrtpZkQ6+q3249DLMBfpavGaANina7ir3we83b8A5J
         DpV70U0Zk8B72Vbyj54XBBnDNeluEL3rf2QPZlPM5Q7P1DLysLIYq5qnZmLbs9jiggik
         N+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765920834; x=1766525634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m7yAZPkwxszj+No3xxGU9I0OwUlCrp2m8jom5MWirYQ=;
        b=eIrqOCZpfw8BvYEatYR1fvXeWGQJh1uVfPAfVFlDPf44N74mAcbJuOFShMtVaSRWT1
         CrGc2quCRvHyOCl3etTkhDvotE1mn31Gv5iaUIaoprsVpSeHccu7UOBKytRbU7aF5g1X
         DR8Hd9dqzdKD0ZPEsVeXSaeNxmAora5OS8KQ6ydYXlwnpeklpYw4xtHMYCaFoiHo3ocJ
         3bhBMYtMFbJs5hE/PgekNqd2NADaPPt1GCKTtnxx9YYNaMHhJvnJRxPW902lKrNASYMV
         GNnKSK4svtcxws/wR2f2hNsKu72HdL7A3NIk+alsw2ch3c5LHoNriYsyqJPvsCBVDGxE
         9ukQ==
X-Forwarded-Encrypted: i=1; AJvYcCVur0vr0BGTkHKQzTaF06nOgoMhQk7b3/qUUduOkNGyHYkakDLBqeI2kY77aBr5SvIXz/XtUj2jpR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmC34Sm8Fyg5PL7xfxLcyXx7yDUgPmhN8h8qVfG/qZqVyAiUnM
	4cIxR4NWUeftKZxANn7S7M/MAnRIK2fyrmwmNEY4Buj6dh8x9IR/Jg2gU75y6951kdBUAlT856f
	YhzYg
X-Gm-Gg: AY/fxX643Dtdf2+wtdJV5kObTl8BUAMZ+/K1bN624WPWrdpBSmHld4AtEcBxIIb60SN
	HyNeUJsKI56tWlvUxGIEOobDmqtRflssQf/8QgHw1kve+cdmfcQM586PUtwyzgbNbG8jofODa4n
	UWoe13fPLdXrE7L3SETpLJVEyGm6Xy9QivoVrbndpVmAIbVLhwxPZ5B28GhHCs+GT0n4Y7RehNp
	0vZvkS+MlOoTIzZBH0dVsLxdVXRUPyHhjZojrsTNQyqNggVcSDepGxzRqY0lkH8lkYoXfpLi4pf
	TbmXg5GKDAlFf2NJRdk+ILBKdznaQIE5ve0hkmbAOSeBvzqbk2ZkxV9BsEoXxacC6/AoAKANTv6
	SAH8KJuDTKjTleNDXrb8j3hO4Vc0kKuHHa7xf71w49IBEcQom4olLfy1TqR9VfQLcyhmLtEPrjG
	72IFyZNDeW7Q5g5ZyeZnk67UYJeYQzbLOznPD3SgazQOB+mFAQAMhDpHFYWps=
X-Google-Smtp-Source: AGHT+IGivr8KL2buP0xUxIAO/vvp3R1op6uoHlLnNT4X3v0UtvhA3grgR5xKfYl6X0U1DIxGeI4JvQ==
X-Received: by 2002:a05:6a00:4388:b0:7ab:6fdb:1d1f with SMTP id d2e1a72fcca58-7f667d1ff24mr14250071b3a.29.1765920834046;
        Tue, 16 Dec 2025 13:33:54 -0800 (PST)
Received: from dread.disaster.area (pa49-195-10-63.pa.nsw.optusnet.com.au. [49.195.10.63])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fcb8742a77sm508766b3a.12.2025.12.16.13.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 13:33:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vVcg3-00000003ind-03Ts;
	Wed, 17 Dec 2025 08:33:51 +1100
Date: Wed, 17 Dec 2025 08:33:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Luca Di Maio <luca.dimaio1@gmail.com>, linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: Re: [PATCH v4] xfs: test reproducible builds
Message-ID: <aUHQPh3QX6Q9CT4Y@dread.disaster.area>
References: <20251215193313.2098088-1-luca.dimaio1@gmail.com>
 <aUCSSuowzrs480pw@dread.disaster.area>
 <aUDryjk9wdZZQ5dz@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUDryjk9wdZZQ5dz@infradead.org>

On Mon, Dec 15, 2025 at 09:19:06PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 16, 2025 at 09:57:14AM +1100, Dave Chinner wrote:
> > > +_cleanup() {
> > > +	rm -r -f "$PROTO_DIR" "$IMG_FILE"
> > > +}
> > 
> > After test specific cleanup, this needs to call _generic_cleanup()
> > to handle all the internal test state cleanup requirements.
> 
> There's no such thing as _generic_cleanup, and none of the
> _cleanup()-using tests that I've looked at recently hooks into any
> kind of generic cleanup routine.

Oh, I forgot that was one of the huge cleanups I have sitting around
in my local fstests tree. i.e.  making all the tests in fstests do
custom _cleanup() operations consistently and sanely.

It factors the _cleanup() function in common/preamble into
_generic_cleanup(), then fixes all the custom test _cleanup()
functions to do the custom test cleanup then call
_generic_cleanup() to do the rest.

The patch fixes a -lot- of random test cleanup failures when
cancelling a test run with ctrl-c because custom cleanup functions
are rarely tested....

Not a small patch, though, and likely needs to be updated because I
haven't touched it in a while:

278 files changed, 326 insertions(+), 1037 deletions(-)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
