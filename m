Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E7D30C625
	for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 16:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758559804; cv=none; b=kRN928ZcUI+Ggg3BuaKvEBxbiTuOAdvQXnnCtto82cEb7KoqwMhuB66ACNWqvoaV+xFVICvjNt7OS+FfD06hxIKGIEiYD+iKWr3/pPu2P3iyGR1RnY1MnRax2LN+rAf89hb326q96YbuQG8UN47BROi57pzVrpLr4C5PTy8a3M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758559804; c=relaxed/simple;
	bh=m9/XGEHINrVzPTUGiEZBd4c6Fi+tGqA4JccCjRyRcuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hSRN2I9D61NJGzW3Z50Z4S+u9B6ShiLlWaQTvpibXGAesXG/n3b3nJwqE1xjoFItnMnOEjxpBTi8gXtBd9crIso0Wqlcth8Wm5eoLO14o1yhna/ZPxygPXpHoPFyvrR7hRNakZ1KJKORP3GL84j9pPQnihjKL7GzPFpUSwFY6fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RFejKAtP; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFejKAtP"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4cdf3772f1dso8543911cf.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 09:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758559802; x=1759164602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WA+alynuVVEEPnntcyqcLLSauhQLoM8gOAgbz++kC00=;
        b=RFejKAtP74up0mb6zIBo/ztzZ+Sf2255tgJnRZKBv6pqR/bH128weEJfGas/TXV/TZ
         9VEqSf+YbClXEI6WiXooTNJbGCXE6u69aSZ6fFDB+NJAHH/iXXUw81QlAs3nMCxgifOb
         m2I+HzjucroSBR1eF8GxhI/vfpwitPSi2XX759NDy0WTS0UecXOTEx/OZ0q6HIZQstz8
         zafcoOd3ah8UHBlSpvZZRSjZfvieU52eCiHotHgOlF2AIq6WSb9HkuxeOrfSuoXsvYwi
         h0Giq5fnu5RjVNjrlFAtYL+9Q38eilZ6EABhXmAHZ5g0BncUcXhVA0RRigGZ5A7WmMhK
         r21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758559802; x=1759164602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WA+alynuVVEEPnntcyqcLLSauhQLoM8gOAgbz++kC00=;
        b=GU4TWj4fW3OjUe/59EYHCHsmUR6QbjKDZvdVUIFNveqf6wUBU1wwhDLbkoFQZygxWz
         tRMi5bkMArYTjTfmy6bJnvb0braXCugsR01ZMfrShhqPDoIjkR/00LILnI3xwBNmYv+w
         hQxOGP7lH8O1InT3ASxLm4Hl0mACGFElWX/aZK008xO1PzwCHGPIVfNl81Y6n7YDsA4B
         FDi7Rh9qWFtU72RPWn+ONGwKppKKQNyMUy00vwtiqkPxJZL9pAoDPHTnNDXbVzxTIO24
         tEjiUpoKqy1FqI6b/PzT3isKiBSzhnfKhd6NFUUQmdlZ+IblQV4D9rxkhLN4suO5Dppi
         Nchw==
X-Forwarded-Encrypted: i=1; AJvYcCU/jihpfUrGZCkxgbFxL4vvp4HAbDakqmB/qZ3c6ecxFUTL4mc6xgjT1wZHGnH5659W+ySrTJUpR2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPEqi+mojtje5sNzvvrIQJBTTAn2ye/Zk6nxs9ctdRSh5vJ1UD
	NR7XvTnGarMh7iikdqeaNmTfhcdvlQiqvgzAHGlXBoSDl5uedzPYtNHWWTzvhe/jpUJ6RoJXzta
	od3AHiH6BSB4Et2PtZkJypSEf96+Eqnw=
X-Gm-Gg: ASbGncuVS+DFXgWPIaGLmrfm9nEvq1tjO9LwNJjU2Ea4MmWTREBu7ao+Whdbu+Orr27
	9Z7QhFyW5cjRxYIjJ1oDZH3HMLGab9qw7jSy9Ei7u1BQmZZfVwUxQ4gNUbX4G6c4AzF3iHjJGVS
	dwKf1dkjKoyV1AAAC5xxKosp7cA9a/cZlhd+8lV0t7FBicRsZbnneedx8xMqXuCKGsNJkwjgzX1
	9pBz61WiJ+v0arsgiGvlLJQv/C6oJr3JTg9XEFJ
X-Google-Smtp-Source: AGHT+IE2GJniwx2CuhW63kr8BKynTNE4Xt9Ay1AkqcPL9FzvjlWdOzfghumDj+pZeJOeKep2YblFDfteGq4gqyUOwfY=
X-Received: by 2002:a05:622a:653:b0:4b7:a62c:3747 with SMTP id
 d75a77b69052e-4c07151d134mr177156361cf.46.1758559801973; Mon, 22 Sep 2025
 09:50:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829235627.4053234-1-joannelkoong@gmail.com>
 <20250829235627.4053234-6-joannelkoong@gmail.com> <aLktHFhtV_4seMDN@infradead.org>
 <aLoA6nkQKGqG04pW@casper.infradead.org>
In-Reply-To: <aLoA6nkQKGqG04pW@casper.infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 22 Sep 2025 09:49:50 -0700
X-Gm-Features: AS18NWCYGl8IVCOH-hPpOfmVBaFG3jn-gUPUQCOuCGVD2SlbTPYRIsrQjTCDT5g
Message-ID: <CAJnrk1ZxQt0RmYnoi3bcDCLn1=Zgk9uJEcFNMH59ZXV7T6c2Fg@mail.gmail.com>
Subject: Re: [PATCH v1 05/16] iomap: propagate iomap_read_folio() error to caller
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, brauner@kernel.org, miklos@szeredi.hu, 
	djwong@kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 2:13=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Wed, Sep 03, 2025 at 11:09:32PM -0700, Christoph Hellwig wrote:
> > On Fri, Aug 29, 2025 at 04:56:16PM -0700, Joanne Koong wrote:
> > > Propagate any error encountered in iomap_read_folio() back up to its
> > > caller (otherwise a default -EIO will be passed up by
> > > filemap_read_folio() to callers). This is standard behavior for how
> > > other filesystems handle their ->read_folio() errors as well.
> >
> > Is it?  As far as I remember we, or willy in particular has been
> > trying to kill this error return - it isn't very hepful when the
> > actually interesting real errors only happen on async completion
> > anyway.
>
> I killed the error return from ->readahead (formerly readpages).
> By definition, nobody is interested in the error of readahead
> since nobody asked for the data in those pages.
>
> I designed an error reporting mechanism a while back that allowed the
> errno to propagate from completion context to whoever was waiting
> on the folio(s) that were part of a read request.  I can dig that
> patchset up again if there's interest.

Could you describe a bit how your design works?

Thanks,
Joanne
>
