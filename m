Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF6731A57C
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757694496; cv=none; b=g/PwPIHK6CpT5sRIACGnXZCtrIhoRW27qZzM8BNrvbERFqBZ7HmDq8por4T6cSWlaHYLlafTeN82GPGOVMAO2XwLFGZEZz8QI84R4j3cOZkEGYgk4+L2OBrz8cEtaksVonNxkzlA5KYY83uBKB3BoUcbKt1mSZAoQxQu6gLvznQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757694496; c=relaxed/simple;
	bh=4ZQds+rLQqXKtrUuxNGp9y/Vi70dhfBppH9lnk7gdCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C1cOCLXjtt11IJCy6GWXSvelGtaJ3e28pJDgVw7l5g69LuhoZ0aBW9XYAEO5Fs7RIHG9aSGX+IDc2Gh6iBit3omtjYoyqSkAYL0CvkjI8mWpn595Pbk1nlAMAtlAFiyNnyrjX4yFn/5NJc/KHbfbgun8W9D7wqaWr9JdpGQJTMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fDuJXpnn; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fDuJXpnn"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b5d5b1bfa3so18800641cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 09:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757694494; x=1758299294; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ZQds+rLQqXKtrUuxNGp9y/Vi70dhfBppH9lnk7gdCA=;
        b=fDuJXpnnzZBgy62qA/zbs9nS//r+43P1NYWcv/V/VdowLoQ0o+SChONYShoeUoHeFG
         ygtVQvDW3+mH6sVgUEN8Im4BNY6c7xRwDyz5wC77cSNb3is9JD99KRJAAkhxJTLNF5Fr
         e7gdM4MIJh2Xt/1LSL2v8fOyDPSDq2GwTCpQ19ehQlD/Um2NGuPcd7i5JjsimIhAnJd8
         5eqNOK4/HMp1CoRFSw7gzvJM5tz/vHuwA2gwF59L+TcS4P7q/2o57vgpUaTndAuv3aIP
         /CA/+3Sfyf8Tr6xR2O4tuqrPzrA6gRJkJZyjTL5B1G72SweM9EOiV5N2UYr+PGo9xveV
         bSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757694494; x=1758299294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ZQds+rLQqXKtrUuxNGp9y/Vi70dhfBppH9lnk7gdCA=;
        b=lQB0+4LnDMgxh538RO35vTI7zwVnq9b/w0hf0vQvUBRoiqQh6gBaWw1j4HqTkTP/vP
         ExsJ0HUJeqDLrCM6/p1VGRf+eObmZ+g/QJs+U4aTUkaCn9gMsDav3neOBV+z6DKDoZyP
         Cf4DSXwa/3AzGPQ4eLihWsdQrNKhHSZu5Xmd2UnEBpgrItCtbqLd4cHMoBPxywdwyO5Z
         uyeIpId8K741OKQ94ll3jOz+YECb3eydYk2S/YUahCDjaPE7IxRt3I2LRgWUWkYkgROt
         wGyAQske2wRgtQ6cZ60yHnI8J+1BdrJ2pEh7xCe0lxX3J6wr5Yz17tcm3ll5gnbJGpzT
         kGwA==
X-Forwarded-Encrypted: i=1; AJvYcCVfv8VFOjid7KI9rDTFBziM50Ie/5Fwwi7AbWbZYZyTPgs8IOKp0G2B0XODn5iNur0mKaSR/bZy8do=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJA1sDzhO3fcguy9NOE3pzPAshmnZSgzJW9MMOhM6ntnwZ5w4G
	HgGHwK9ZiEk4B08LsNsTto9hwzOjkakYTDmzRlHs2jV9xX83r8uPpu8TJOrpqUrHzv7LhGn2vMm
	uTsQ73IsxGt93eYRvRz16HMvwC0vjRJM=
X-Gm-Gg: ASbGnct9shioYUKRfsZ+hLfXCEpJiRSgP1zPuHzaz5mrX/3eZDWQ5w/FRxEKEtt4ynI
	cbsPUP/Ejn1pQrgw+1IfPLlg/RDQPu2gosn9pCVnOPZ+Adeek6QHpNJ/rzPmx67TbaNVtlCsEtd
	ROkX1qbrKpyOCZ3UtCbdg6oJknU82bpwgItGD0tN7Tlb9e8jc9kS/za2ympCWXz8kZxwuYvEasv
	beTbR8P8Fj3/GU8G92PuvqTb+soa2X5i/1g3El/5vh0cal3ZK6DJOzrLaCU6fs=
X-Google-Smtp-Source: AGHT+IH3sgRSs+dcbMoU7VA9j2cW53LQyv/IZLN7O9xGcrcKIirLDxNle7DY6XecZsiCSB6AFLxXPVP6mp6QV78ZXRU=
X-Received: by 2002:a05:622a:1c09:b0:4b5:b28e:f0ee with SMTP id
 d75a77b69052e-4b77d035872mr40986501cf.51.1757694493815; Fri, 12 Sep 2025
 09:28:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250908185122.3199171-1-joannelkoong@gmail.com>
 <20250908185122.3199171-6-joannelkoong@gmail.com> <aMKuxZq_MK4KWgRc@infradead.org>
In-Reply-To: <aMKuxZq_MK4KWgRc@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 12 Sep 2025 12:28:02 -0400
X-Gm-Features: Ac12FXxFDjN5YQNfv2vrM4ZDEgMv6WgrZBCDj2pFB-Fs02NqF_4tIokmTzA_qak
Message-ID: <CAJnrk1b8+ojpK3Zr18jGkUxEo9SiFw8NgDCO9crg8jDavBS3ag@mail.gmail.com>
Subject: Re: [PATCH v2 05/16] iomap: propagate iomap_read_folio() error to caller
To: Christoph Hellwig <hch@infradead.org>
Cc: brauner@kernel.org, miklos@szeredi.hu, djwong@kernel.org, 
	hsiangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 7:13=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Mon, Sep 08, 2025 at 11:51:11AM -0700, Joanne Koong wrote:
> > Propagate any error encountered in iomap_read_folio() back up to its
> > caller (otherwise a default -EIO will be passed up by
> > filemap_read_folio() to callers). This is standard behavior for how
> > other filesystems handle their ->read_folio() errors as well.
> >
> > Remove the out of date comment about setting the folio error flag.
> > Folio error flags were removed in commit 1f56eedf7ff7 ("iomap:
> > Remove calls to set and clear folio error flag").
>
> As mentioned last time I actually think this is a bad idea, and the most
> common helpers (mpage_read_folio and block_read_full_folio) will not
> return and error here.
>
>

I'll drop this. I interpreted Matthew's comment to mean the error
return isn't useful for ->readahead but is for ->read_folio.

If iomap_read_folio() doesn't do error returns and always just returns
0, then maybe we should just make it `void iomap_read_folio(...)`
instead of `int iomap_read_folio(...)` then.

Thanks,
Joanne
