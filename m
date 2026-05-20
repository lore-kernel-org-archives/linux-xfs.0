Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1603E1D1B
	for <linux-xfs@vger.kernel.org>; Wed, 20 May 2026 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779281180; cv=pass; b=Fmkl0i65mWxpu8E30X8QuhuL6hc6lixhqkuguidVzvt1TM8vjbhqekVIk6MfYOZi6zDPRD1Pfse00QZsrYjjD/0todaemi0pZuA625xQ2YYSri54LaJE5MI79GM+3Zmld4fMOlbBMtw/aUSutflRrC2iitLFFF7FU7vumtwCz6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779281180; c=relaxed/simple;
	bh=kuG2bun+9zV54cDn25VRYLxwlHcI0dB/hyYd5tnEVcQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k3s/Nj0/REgydh/JX0Rc4ciZ5eFc/BDd4ITA971i4JEZxs9EYZOFJIAsNnMzpgjDGupH5OHptqaHN7HDnqxmfHRGpy0UHdDVt3W4Jjq63+Hv+dG1FKv+orGwTtAjFv801aUmVRcTtCrzEZVEbFs0rbAEBeRl4AyMLmBsITY9Ukk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rh5mTX7Q; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rh5mTX7Q"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7c23248f3a3so47085157b3.1
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2026 05:46:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779281178; cv=none;
        d=google.com; s=arc-20240605;
        b=j+oTcd3LlZcQGu4be0CuaosQg9YCeNGYdf7FE9SoRv9UH//Cf2Te+DTyGq3qVQdYRb
         nVM9o8sai+/9D2KiG59y44SXmgjm3B2OFbbuxz11jHg7mKa9oD3EAef665vOjoUmAUbp
         uAM7QellQl/rATbWb0BbOUesO1djCAYITaLvk21Ba8QHTfGXLCnTu0sADHCxpyKObMQd
         TlabKLc5aDEHyR1efTlA/wEJshSslCubSsdjqXtgrnM1KvBxBqveJF/QjG5Ckk41pysM
         fjvsg7dUDap4PMVWeh6iYsmnocc41i/aP9RkrlyR8VDPNDuPnRaydHtujJ4VI3DgnNe0
         xJzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZbAXQVZjjIKD1SGt2FV3sAucnMPapO77enC61ToTrfk=;
        fh=65KvohxJjBi/iUw6z+B5iufA+XaBIz/9SEIvYL+xs0w=;
        b=aqH6L7u+/CI6C0ybWM5Xf2wtM0z6JuT67UPliMTU1/c7Uth+VHbKqYFg81xlEimXZ/
         4zJbAt7/KmriRJ4l8s3J/DGM4UQmdydudKOvFn2Cf5zPWTT621eo4T/4jUrHRTdZOCtJ
         9NI03lY+gbOiKuOPt7+cxQAczuBjmPM9KOj9r5ohXGGVqphgISak3KqRXAaWRqo2kTlb
         axFLs2aL4L53+wxPrV9LGQgWSRlglr+k/sH5IQxaH/9lAR3JnFRBcxJHGsLJlB5Rugr5
         aoLWfwSFsTinPJ5tv3nFLTvdC/tzpf1JrwLgnJPf4kDAcrCen1eWTzu13t7vXhWGx/8y
         bn+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779281178; x=1779885978; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZbAXQVZjjIKD1SGt2FV3sAucnMPapO77enC61ToTrfk=;
        b=Rh5mTX7Q5XGmJ1El8rtcWZghtI9X1eIDXHWGZCjtudg+l2SEasCwlDTSd7LSCU4rd5
         Qjz6vk8LmMEQPQHRS/TaHzTRhXZ/6m32RZPlgyTxmXPpxR+XDCMlXL6FFDB7J1njZZKt
         0VbS5uWFWOpo12oNutkCwgrbuBJMLyTUcTJOoNQJtOdN8CYO/H+JDin8nFcIGeYkZxBx
         /8trQ94oAA5n1lwhLbffb1nrJYgvt5hjAesgWpqhx7z94Ua+96I1LDj9Xc67YdxEWRE5
         LuaKHe4k8y1qG9HOVhWlWKF0n+GxnZ6iDsCDmm7t31Y0H7nHcfH7kVXvaX1YZ0FX+oXA
         z6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779281178; x=1779885978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZbAXQVZjjIKD1SGt2FV3sAucnMPapO77enC61ToTrfk=;
        b=MnEYZ5Sv0Rh3pvP45vZBpV26oYZ8zXBMSMdoS8NmVFKiQTKX3y0FVFH8uFPR6LHg3a
         zDB5HjVrZx7i6hYYsdlnQ+KRdzk5iGPeEpxvgTLHm9SH92oF0O8M8qSxx2ahfnYAFrsp
         rNvl755tBP+DyPJZyuhWAI7W0BjJD7yAVdGOXjz2kQAR1gnPdu02jJLjnGWIaojh/4Bv
         uo2AU1COE+waK7mEYD9FCvA1qWotHlsR51jSSV1LuJ2rM4f8/ej3CFaLguV9sYq2ifL7
         Kk46vx00kCpniR4SLVEtD4kzFmoAgZ9Rw0P/UKM6xh92dsODWMxeDBaNJMddTOzGEjTl
         6oeg==
X-Forwarded-Encrypted: i=1; AFNElJ9OICWBZ9APGdv7zJQGvdj+CUQUUNV00jxepskXrgb3NNcC6lO5APtKPa6OQ5nWadtS90uUEeJg5Hg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkm+X8P+Ib45XLs4lerIOJvsRw9Qzg47ETUlf0q+lCA7kojYqs
	YSHFRrwHCFcZ2AHoZ74rgujr/53i7OOSfGsEPDVeoVRCUmHrxUcj/R+jkRJPT+b3FKTKTXAV8or
	u3XqHRRcgN2XiqnsFyAEzghMDt5Ae3LI=
X-Gm-Gg: Acq92OEBuDyU//9kMTgjfLVTMvNAHI0WeGr9GkceYgAfrauTa05TXT/ddxljSV4biZc
	051y8AJfl+jCpPOS+xwFDngHTYHRPq6dQV55hFaW5ygnQf3F2/VuZv6MY9TRdbeu9JYePxs+B/H
	ZNluNN7P29Jf5kuqWZB/382QYuRO8lxZav58uoBqcwqubiwTwNJFaDHHDa3BhexxnSkMuGsoSu0
	yPOm9BUTxfnRjgrZedxtfpPn8TbFq1/slLloGLnH3Vr900ZM2xJLfC2U2uuYzMV7bDwybQcAX7V
	4ebw6y7Bw+kV7xJXgpgpCFv4/uhNPXEX240goY3tcL029uc=
X-Received: by 2002:a05:690c:95:b0:7bd:6432:d9c with SMTP id
 00721157ae682-7c95c8f07e1mr240866727b3.37.1779281173013; Wed, 20 May 2026
 05:46:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260518013143.1532327-1-michael.bommarito@gmail.com>
 <20260519050235.GI9568@frogsfrogsfrogs> <agwfrZAchLLFX7c7@infradead.org>
 <20260519124833.2020871-1-michael.bommarito@gmail.com> <ag2kHyI7IzzyWC1z@nidhogg.toxiclabs.cc>
In-Reply-To: <ag2kHyI7IzzyWC1z@nidhogg.toxiclabs.cc>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Wed, 20 May 2026 08:46:01 -0400
X-Gm-Features: AVHnY4L3AvtzO5haGRdHN03XhK6fdLRSoSa1a-8JV55jdHEGsapeDdfrDB_uGMs
Message-ID: <CAJJ9bXypUC-o8Y6ZMd0=-4ZOquS-0oFi5NQ4hoXs1XOORprhxw@mail.gmail.com>
Subject: Re: [PATCH] xfs: detect cycles in recovered unlinked inode lists
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 8:19=E2=80=AFAM Carlos Maiolino <cem@kernel.org> wr=
ote:
>
> Please leave the message you're replying to quoted in your email...

(Sorry about that. Christoph's message was never actually delivered to
my @gmail.com so I had to respond like it was 1999.  @Christoph, not
sure if on my end or yours...)

> The patch ain't completely invalid, but by the time you've somebody
> untrusted with physical access to the system to put a USB stick on,
> your security is already gone.
> Automounting filesystems (a thing we've been fighting against for
> years) just adds on top of it.

I get it.  Better a known and accepted risk than hidden.

> I don't think such tests belongs neither in-tree nor in xfstests, but
> this seems a good idea to start a project related to test filesystems
> resiliency against those issues. syscaller already does a lot of fuzzing
> but mostly random and not containing a bunch of carefully crafted
> filesystems to triggers specific issues.

Yes, and this is where LLMs have been very helpful in particular.
Given an AST or parser / format specification, you can delegate the
mechanics of implementing hundreds of different tests / perturbations.
Many of those strategies are analogous across file systems.  For
example, this XFS finding was found by expanding from my NTFS finding
here:
https://lore.kernel.org/all/20260517234140.1261718-1-michael.bommarito@gmai=
l.com/

I found a little prior work but nothing that seems active and comprehensive=
:
https://github.com/sslab-gatech/janus
https://github.com/stevegrubb/fsfuzzer

I'm close to finishing triage and disclosure for all of the stuff I've
found so far, so as soon as that's done, I'll share what I have
publicly and RFC to continue this thread separately.

In the meantime, it sounds like we just park this until we know it
won't break things.
