Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81432E06ED
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 09:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756804925; cv=none; b=Akio6byfrsM5buaLNry5Ig6LDVpkgeL6WTCQgPuk8o6JIITYcbpdOyV5hh6INr6FIJgui00pKtGxlunXWNojFUiiPr1Np1ZVzKiBY0xLjWzZT+pGml2ssJY+L2ezly8wEcwQARjrCiFkEmZlf9Dt41MDQMm11PJjjNrbL6RDGZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756804925; c=relaxed/simple;
	bh=oZ/oMsImSwXy0iurVEV8OYWOj1EK5Ol1S2elCURr6o8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UEh2/nZt3L5EgXUrqJAswZ86MkHYRoZS8fHhHX2VfVRXxjaM1AZUPt6SqxQ/+ulalzkoNRSCrF6IlgrB1YKWJy99WcgJd25VQ7g1V55TAibhCZ/SpoPHPycFMUGVMdxDbY0x9gDo6gc03FD5B8wjc7K60f12A4iuhRcAUHsrUR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=pPMk8ro8; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="pPMk8ro8"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b32c1fdcb4so25302811cf.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Sep 2025 02:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1756804922; x=1757409722; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KlEqu4WxUDiABf2a30g8zFkM2TpzDalMOcCpeUi3kyM=;
        b=pPMk8ro8+Yj2e5GcMg+nnrdCbWMa8u1B2AHCvpmpG4WYnwkCAtHfQf/mPrDcLvVJzI
         vfoKD8hrHyXIyTaeXOhT1Iyo2KSngHpPf6d+8aO/AmL8zWLxIItynXCxDE9ZcClhxjmK
         LGk4n+XYjMdT7QESQ4oENa+2wZK2c6zlQnh8w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756804922; x=1757409722;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KlEqu4WxUDiABf2a30g8zFkM2TpzDalMOcCpeUi3kyM=;
        b=gVNmz0hnwBRMgP4z8NBg31lAUtDRc017SnqMyvQBJvMfhwtitHF/Td2jPPX93aSx7W
         vB7fiw81dersUmmHGk4ZOJMZqimJXqUUv1YVk0RmapWNDes6ctP0A0FN5iLk3c8wpMb2
         090V/h7peYUoCFWytFwSit6f6SNLznsGaht9CQ4a7AarE4MAMmVdgJuQOiLiUtgOeqqU
         rtMsiVM3CfZmFay6VE7wHDFrniI59mLEo1EfXh2QwS33Am5CJlv9f6j+SRa3/lamhHMC
         cgeL6YMug4gC37cNNWS1SnDuZfTqBw69Y9A7B0S1DXjjiLPwhIjWS/HWcLPR+ar+oy1t
         gI+A==
X-Forwarded-Encrypted: i=1; AJvYcCUTLcfOWqClA7LI8ozsht2uiXEZyoeccDo5YvLAhS2KQTzW8DS5OvLVkBt7E/HEQ5xQxV1UgFc0JMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhsvzFKTzEGdim6lnjg4A6zFP96xrCcHIzWuB42jB9tjQ9Sdrk
	96Pir2kkCCZSR1rq4UKmPSFq1sBO/iCG63Kn+G2bgifgp4D1ha5veZsArL+1Sw6wSr1Z4ySJxSO
	Z6O/EAVYfHsR9JYZ0WE9zjjcxKaMF64aL+FLzAEdLNQ==
X-Gm-Gg: ASbGncs6MtfHaaBeVICNklYZnDbG+aZwojI73MBh//rGcLofSvyqNcSl3A+7Bf496h0
	5n295S1sQaqf1/x8PW8IlQP+uFDc82/CNDs3Xhl0sBTNV20ugBsM/lm4oosVPr66pc4lQzFsy4W
	UojOVJDaCnolF8Sp0oCUbwJFo25NAKAwoMft46PyHfCon1Y5RFjExp545yfSxqemA9uvTrlakXu
	BDCXpHUjQ==
X-Google-Smtp-Source: AGHT+IHGEIqkQ7T/iYNa57/nLq67pz6kDXn62sDrEEuPOwlRvgJBGGtL0MCc4sflnVaHrwo9btUA3j959kBW+PZAoRU=
X-Received: by 2002:a05:622a:1448:b0:4b1:103b:b67a with SMTP id
 d75a77b69052e-4b31b9c3777mr140959691cf.32.1756804921620; Tue, 02 Sep 2025
 02:22:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829235627.4053234-1-joannelkoong@gmail.com> <20250829235627.4053234-17-joannelkoong@gmail.com>
In-Reply-To: <20250829235627.4053234-17-joannelkoong@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 2 Sep 2025 11:21:50 +0200
X-Gm-Features: Ac12FXymFicVPinwbFSWp8veqgoTeVOVPPlBCbz_Zbd4N-bMcdXkFmiPs4wTQ0w
Message-ID: <CAJfpegvjaNZSJcyNWxyz0gQk-_9AXqcPuX71m7yoT2s0cd53iw@mail.gmail.com>
Subject: Re: [PATCH v1 16/16] fuse: remove fuse_readpages_end() null mapping check
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@infradead.org, djwong@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 30 Aug 2025 at 01:58, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> Remove extra logic in fuse_readpages_end() that checks against null
> folio mappings. This was added in commit ce534fb05292 ("fuse: allow
> splice to move pages"):
>
> "Since the remove_from_page_cache() + add_to_page_cache_locked()
> are non-atomic it is possible that the page cache is repopulated in
> between the two and add_to_page_cache_locked() will fail.  This
> could be fixed by creating a new atomic replace_page_cache_page()
> function.
>
> fuse_readpages_end() needed to be reworked so it works even if
> page->mapping is NULL for some or all pages which can happen if the
> add_to_page_cache_locked() failed."
>
> Commit ef6a3c63112e ("mm: add replace_page_cache_page() function") added
> atomic page cache replacement, which means the check against null
> mappings can be removed.

If I understand correctly this is independent of the patchset and can
be applied without it.

Thanks,
Miklos
