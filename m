Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC7F1E98E3
	for <linux-xfs@vger.kernel.org>; Sat,  4 Jul 2026 00:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783125313; cv=pass; b=AeweG0MoazDNuOp5YxzUFPmVG6/Ei8ZLjLpxO/upvKo+Nu5ONN+BbKPc5Nlzqz3ZJrnxJf6xwzU+/RqZP0zyAoKmtj8MWOaqGQEvdEDAzk3GY35+pHpw89OH27E1nOLCJu0mxH5Vn7GzAls9mI4opYkNBI2oYEpildG+T/0jyX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783125313; c=relaxed/simple;
	bh=clrDD96YBt5A3a2Rvc28rREplTx9fw9n1eB41uH1mEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qDXMvfqgeWRYku0BnSQ8545ZorokXHMSxBT5AmwCfE3wapgEepwScEIWgq6PtvZmNEz0FEiJ5mg6JTIlbbh3sC+FFqKFJTteVffFv5DEETcZ7G9fjohHz05t/e/XXaqw2kv2pdRyhxfhv9ih6hxuYMrvYZuuD5elfmmsLB9qqo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pSnUN7Z1; arc=pass smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pSnUN7Z1"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493d28b1930so439125e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jul 2026 17:35:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783125311; cv=none;
        d=google.com; s=arc-20260327;
        b=lp1Dm+2ozxs93hKcNuIVWMw00T+FP9RD6OsXbUKpg5jqvdjP/wziuO0YzAEUWWcL8s
         Q7vn9sgvrrh7WBdU94eU/IgTHyymGeJM8ttAuADhkEcgx/KIuZW5p3Ln6Y9e9+Ojjghb
         orWFJSzWUUh7DV4ChU0PZHRUtdd/C36Q+OAtTa9yswtM0edeREm/nbNKcOcjWQLvFd+J
         nY3iKUCWqoEf/unO8pWZoRxXgT0pHZBrE3cM8Z77lQz3Z1TiPysRjJc6qaiPw1JVuj8/
         hFUZNXviO+lDFuTGqOmasSfWnNf4RwjabhU0mftd9EJii+hvxbhiKGrDsRa12IkbZIRB
         iAWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wW7AlhxqGYiRva1oC552NzvH7YtXs9EvRN6VDKKQkfM=;
        fh=ECw/dh6gWvJ2qemWeQFb3wocH5phRSq6jMHZqR814C0=;
        b=sFPf5qjVyLZ105WHwlFGdQWNkf+YT8CIR3eSxabxp4vw4s7/k6j8Fkhak1UzVLiyps
         rkoEENObK3C/5Lo6Z1DsbcNaFA9fTnSBHhkBccr64dr8+tRDPlVS0BzS7cFUO9P2Cc4d
         Dv6goAOnLUL/i89y9uJSt0FaT20d6BnLOR96Mc/+CvLHvbgmQ7EwjE8bc5hECejuq9W2
         BOaGoaD36X31EIpnGGfrcuKfP9bKa2X/5juapSury8VZf6rWMdZramg9e1nMnGoE/Got
         XHPMYYVgzYrYfDPeaDp+ehhX32Np7bij7Ju+fFAyXBVtqFPdAfgjGHsf4KNFoLMpfTFp
         ty6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783125311; x=1783730111; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wW7AlhxqGYiRva1oC552NzvH7YtXs9EvRN6VDKKQkfM=;
        b=pSnUN7Z1IPzl1PUejj1ZbBo/KW7cjP/Q3GRVbjj/54TkXCqh4uwm302JQIauMohZYJ
         mUvkfiO6qyBMktjaZ5S6UJJQplzNMgNEdHyJ+QXaBmfHm/b6UEl2ggeU/4s8ijZzbc7r
         asCQw4+mjoUHkjssFZLc5Iw3B00xouaqqStkeNJ71sRQeB+U+WKPB8jo7KX2siGB3yEh
         MzOIRkvZJmisEPi9wPPdoJ2vmw3Tty+hKT5+3bSXaeiivvZyJtvBQs04+8DiXDwgOXDL
         JxshMTB8jXxOe1uLdfz/a7cNGFV1DyfkM0D4mXN0NaarvA3V5YNE7/5XOuU2dql4egiC
         c3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783125311; x=1783730111;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wW7AlhxqGYiRva1oC552NzvH7YtXs9EvRN6VDKKQkfM=;
        b=QvAN4HzlVp0krvaO/5ifW8iFEcuNlnkvFMjLu/F7cXlou4OklBqxFyJPFO1dHepmdr
         fwleGpRiHo3R8RJE7XecDp4qBHOh046tv6XjYkh6rxnRol/Mln+GBR0yZtZWkiPYwdsB
         WSx2xGrSNOHw+R5hTZ+AZOUYaD8D2gfu0azxIO0gd1vw3R4MBAR5QwB6+W7b7mrCcOXI
         ekfS+gU8sS1WhZUZGSK9qkqx7CXCm1kzevaiQTah8qAjfrDbdWNfGdR0mrvMDT0PqPjA
         UjAABkePnlIj1lLqy1cESdYyIbrEAP4NJfbtMMbSE6LSoSKnxiOFO1WzdLjh3eqRCgBr
         oHlg==
X-Forwarded-Encrypted: i=1; AFNElJ/MJRwV56mxwNGy36egzRxfCLn7PJPGdkiQ9FJnZzALXJLbGqboA6cMV46C275ywchwVCPm8cGZbtU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnAybJsEojEdrJWEgRGAGeY7igH6pP+uNk06AEa8kHm/JcSdaq
	46wwMVOckfRglEoOmaaRIr40PoVtGrWXG0nMxeDf991XDLRjq3XhflLC+L1l0+fAD390wMRuNBA
	5r9I8wiupjFzdCMUPVtmclsQMZ9E95b4=
X-Gm-Gg: AfdE7clEe89wU+UwHbAEMEGZH6hetkLFVmMKtZ2c425DjAl3cZtCpCBzn3m0hKkUmNA
	o2B7KO+48B9QH34+n51b6XOomv3gEK45AouvQfAoxfFocUxvMRy6uFhQvUFtT6k7RkWb47QzVS4
	UaooZ+tDU9sDld/eMOQvLGbLMaL0msVf1vS2Md30FBbaBGgLOoiKcwFV1d8dLikZt1UEcSPLkxl
	vWlS/d9ZZmGumOhxY5Jk+hXdIqDWu67fdW9UPmvcbS59xhr8UTeCar+wH3z5cQscIMS/MQ0/WsQ
	/7jMzfCVqxzlfpBB8E2+cQ282hYwwjpPe568R+MmmOCE/FwTdxoM
X-Received: by 2002:a05:600c:5250:b0:493:bb0:3b43 with SMTP id
 5b1f17b1804b1-493d11cefc8mr15023595e9.2.1783125311110; Fri, 03 Jul 2026
 17:35:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-19-joannelkoong@gmail.com> <20260702192658.GN9392@frogsfrogsfrogs>
 <CAJnrk1YZQOQ0D6p6qYx1BPvKQaDgZsrKzLbGZzaH8tUkj_OoOQ@mail.gmail.com>
 <20260703020020.GS9392@frogsfrogsfrogs> <20260703124331.GA26440@lst.de> <20260703161147.GB9407@frogsfrogsfrogs>
In-Reply-To: <20260703161147.GB9407@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 3 Jul 2026 17:34:59 -0700
X-Gm-Features: AVVi8Cc9z61uFW2rqHr93JegF3VWx93elWcFHjnHavv8xxM4AtcZoZcVqoAB6DI
Message-ID: <CAJnrk1Zv8FEAD+T=1+ZLi6q8ztHVY1zray019QNdeLpYjTNQAQ@mail.gmail.com>
Subject: Re: [PATCH v2 18/18] Documentation: iomap: update docs to reflect
 iomap_next model
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 3, 2026 at 9:11=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Fri, Jul 03, 2026 at 02:43:31PM +0200, Christoph Hellwig wrote:
> > On Thu, Jul 02, 2026 at 07:00:20PM -0700, Darrick J. Wong wrote:
> > > The ->begin method can still set iomap::private and the ->end method =
can
> > > dispose of it, right?  Oh, wait, no, that doesn't work because you're
> > > talking about ->begin/->end passing something to the next ->begin.
> >
> > Should we move ->private from struct iomap to struct iomap_iter?
> > That'll deal with the constness and the fact that private data
> > really is a per-operation thing.

I'm not sure I understand. Doesn't struct iomap_iter already have a
private field that holds caller-supplied per-operation context?
afaics, the users of iomap->private (gfs2, ntfs3, fuse-dax) do use it
for per-mapping data and release it in the same iteration.

>
> I dunno -- towards the end of the fuse-iomap development work I actually
> had started using iomap.private to store per-mapping private data.  But
> that work is dead now, so that's not a strong argument.
>
> > That also reminds me that now that we actually still keep the low-level
> > begin/end ops we need to switch them to a calling convention that
> > passes the iter instead of the ugly container_of.  This is something
> > I wanted deferred until we get the iter conversion, but it turns out
> > that now leaves them untouched..

That's a good point. Do you think it'd be better to include those
changes as part of this series or do that as a separate follow-up
series that targets the same merge window timeline as this one?

>
> Oh, you mean changing the signature to:
>
> typedef int (iomap_begin_fn)(struct iomap_iter *iter...);
>
> instead of passing parts of the iter as separate arguments?
> Yeah, that would be nice.

Agreed.

Thanks,
Joanne
