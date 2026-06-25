Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFFC305698
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 21:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782421407; cv=pass; b=tagN7h3IcD8RhtE+awL172bDUaoI0zi/TiJQbngUlspQB2DYgQ+z1YnjN/v5pL0LUB036WmGJaBpYCQzuZZ33bbF1TBlxvfGprMxH6G+ho+9COU/MpEpDc6kk7l6/d5nbwPSQErGGievLe2D6UyrI0oGTlUw8BXS067L9FhLWZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782421407; c=relaxed/simple;
	bh=8X2qkSio5qy3f6/M4YqpSSJU3EjVoLgo5U7rTJF6bes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sWt5A+y5wXCEdk232QQNShQnqjW4SbplONTfi4BBsNBOwcg5MqsC0nARkNRtOTV7vBOy+Sp7ByuJDuJvA9TGCcQgLF3lUsYK2SVKq9C1exieuvxoc+9Z7EXYgw4UdvNzNmZodYKaADKS9LFQyv3MPBJgVwuAUvfliM699hCVEhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=moK8kURQ; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="moK8kURQ"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-46e335379cbso125315f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 14:03:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782421404; cv=none;
        d=google.com; s=arc-20260327;
        b=cTNHw90h3rJ9eCyUSBmQkhINeqATUZvO6ChjvDQHJLGHjm9pC8kTsVn3X2DSod/99g
         LD+RJUmuv37M2upHy+MDziDsxn3t8j2elRYg+6WNfsqsGGoyx+tfi4XMo8+M/2IC3D2c
         FMQycecxeOUpOuh7yOwQPM07SxAD2AUS+PV5SNqHjdn9SThq0UTKGWC/pyvhjppiXzVP
         ikynhcjPrbxpm22aeah5hKyL/tS3AoNyBinc6yFcV8K1Zesyf5/cqS/HYv1A6k3IhxOc
         vocomNvEJffZPqmRH7OqVOdWis1TfyQiOLnmKmWWmb3o2CHBotMLLtxBZMkp8sDOqjnJ
         jH2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GVg/lYpYcOxnqWcUc1KZUrD79iR8xox/AhH3koJoPkU=;
        fh=ziEIFkY6a/7hpUJhcMfNvFUayU+G47jwa4L6+i4PoCM=;
        b=RNp+w5pxB7gXXp5vtuHxIhU2KcOZNRxMO1EgBQRcvv4PEi9+x4f4ZebZzgjUIATjfp
         cTokTrSPkLr0EMXBtrFMgr/ahTLgTgjNu+WGrsv+vHETICWim+8resy6HtCnRQ6xEG0d
         tYwX2hUbZzEuxHfbTIZLZvJw2iH2L+U2Njy8n9jWsQMf7IrLke03TJ78XR4xJjoAVraH
         uOFKAPTwSQMClSn+SUxZ7AUTsRBkrzjpIrR7fsFKu5X0omFaAW1G24kDuUvIZDQ7V253
         HrV4c+igz4wbLd9sdDccv+n1NTSuWK9ChbRIPMJcOrdBpUHNWYEwN7AWuUgre8e/0lLL
         aGPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782421404; x=1783026204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVg/lYpYcOxnqWcUc1KZUrD79iR8xox/AhH3koJoPkU=;
        b=moK8kURQXdXgtGGZr0Ut1RdqRcn4jih3GAZAp3KIp63yJZ07+X5a69jbvG6or1Su8e
         sUD7zBi54artSRM13BcZ0kZFYx+MrpMVJmonMTqXDTjgHKrqbtEm9bDnAEoVLg5wtoJD
         jN7XQOtSBnFjvbY4vgOAzK1vqmSBYhukVMaRFPcunwqWPFIXhxqF2r498B1FZnW+Ef9t
         5v0H6nZl6BNDfFzVvDkhUfuKS9f4dn1ykvC5MACtl3kw87krqEY8j44FmF3sgLFyL5ws
         18LHzIsAbSkKeQuN4LyLGsS96WvTOGplaNHmp9HK3H89kUG8AXCceOhKz7v0TiYj8z+x
         EmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782421404; x=1783026204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GVg/lYpYcOxnqWcUc1KZUrD79iR8xox/AhH3koJoPkU=;
        b=Jjo0L3f71TRsqfHOm6MhLlz7boi/kabYvD+UHQzD7KuuZEu6yLMGFC0l0YiikT6ZND
         v+ZDYmvbYB2sC+vWEM3EkmzROJWDurVvj2e4DxA2GhdqJfdXJPWIthU2GR4HfLEv2xD3
         GEbkBdQZS1Cu6MeaspalV2nhBj+V8Xjl9G2zydgSVGpVt1txmanXEZSwjdokDhzpOTyg
         SEoxHHThkcI+cn7+DlhI+0dPyhiWACMaSQbw1al9/5+mphOuPw8bCIDWir5+e9VhBgFx
         zAIi142u0i325cq80lns4nWevPkG7LNNBYDbRB4NbHKFuI2TuqfkyPKdo57qkXoZBIoX
         mkHA==
X-Forwarded-Encrypted: i=1; AHgh+Rob7hhiyCzMrZm+0X9oupazPvcsUA47SrARhaV7gly+OETym+R4sYs/Jxm139/INj5Cg8GKW50/PWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRZFPbet/j73A8BAWoPcrQdYfH94FBLal+L08jrY1P4XNsahl7
	Y1WT53hiwsR6r6UVuIiwKoZSyD+3sYEptZnzgkLp+UNkQRbgqVFQa3pt+vwA6IWztGru9xfCnse
	F7lcJwlPCGmowwPq0j1nnchrX6wEC+mjkQiFY
X-Gm-Gg: AfdE7cl2ApyM7P5Esc9Zq9GMwR5JvOFjBh3jqqtfbPeuu2Bhqf3s+4Kiyy4Z9XgFu3Y
	1IH/y/S/UiAaifHfbheGWMnnHwQeuhelgqYPByRZepIjarQEBugrx9t2qAwN7HFWRym/xsavXs0
	Pv5mOtp+JbK6LSqN5K2/wCp3cpm/9xRE0zXwYSSIfBlueVxUsnYZMqWi3YXGPrDAcKl9+DbQR57
	J/MEdbx22xQWGASqkfCAslu5OrTXekbYVac9dVIRB+u275F9gCzDhOsfPDMP8Rry+gSesvj/otj
	Rv/lBOk3WYBf+1cl76d9onGd7VQwCRh5j5PNddhHUV3LMW/L8Mee
X-Received: by 2002:a05:6000:2884:b0:46c:8f47:3b5a with SMTP id
 ffacd0b85a97d-46dc20764e4mr6647539f8f.23.1782421404613; Thu, 25 Jun 2026
 14:03:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
 <20260625024723.1611000-2-joannelkoong@gmail.com> <20260625125656.GA22620@lst.de>
In-Reply-To: <20260625125656.GA22620@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 25 Jun 2026 14:03:13 -0700
X-Gm-Features: AVVi8CfUb1ewUa5iwyynGN-pNOt-tT5BQjLMm4XbQDUjecT5437YaC673hlN6Do
Message-ID: <CAJnrk1a3dY9r=jGVyTLT0k-J11wrdFc4sM6P94FBKwpi5TQTNw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/3] iomap: add ->iomap_next() and iomap_process() helper
To: Christoph Hellwig <hch@lst.de>
Cc: willy@infradead.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 5:56=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> > +     /*
> > +      * Produce the next mapping (finishing the previous one if needed=
).
> > +      * Return 1 to continue iterating, 0 if the range is fully consum=
ed,
> > +      * or a negative error on failure.
> > +      */
> > +     int (*iomap_next)(const struct iomap_iter *iter, struct iomap *io=
map,
> > +                     struct iomap *srcmap);
>
> If you add function typedefs for all the other two methods I'd one one he=
re
> as well for consistency.  We'll need it anywone once the legacy ops are
> entirely gone we can kill of the ops and just pass this function pointer.

Sounds good, I'll do this in v2.

>
> As for the arguments:  I don't really see much of a point in passing
> the iomap/scrmap separately vs just the iter.  Or am I missing something
> here?

It was meant to safeguard against a callback modifying iomap-internal
non-mapping fields (iter->pos/len/status/iter_start_pos) but maybe
this is unnecessary. I'll drop the 2 args and make it non-const.

Thanks,
Joanne
