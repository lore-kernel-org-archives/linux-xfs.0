Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE10119DF66
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 07:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758611438; cv=none; b=h8cLi8kwF64d+q7VedtA2R2xuoMAy2YpI7r/hbL7Q6uZzhW5XsSKblg+QhFVRg+hvBWzjoXb1qeCO5N/PROX1bBswj8EEw6tNPvMld1N+zZxp6fxd1pxdpgOormOokDbEeKFDPghH505ot2rqe6Rt2hDDH/4MWrNuy+euNtliH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758611438; c=relaxed/simple;
	bh=fH12eOrJkeuIYzMN4uSILgjgrPsFe7pqoYldSObT19M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hlpBfnQug/LCYy0+rZOKOBph5mmRHJWoUnQVXjDUiyyjVdORoDo4S0hjmmqKh3CVFh+NWTQealcCGo5rI3ih6KiY/boKu/1Lw/1ZB0UjE3O6GymP/Z80M+VRnxMAQsJz7AHXs7xnr8S8tntqh/wK8L7kCUmaMb6a796nRKHPOcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=MUDl3+Ds; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="MUDl3+Ds"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4d3aad01a9dso3438281cf.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 00:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758611435; x=1759216235; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Zx4KAtlXII6+MRsPkHeERk1awByqcg438XULFFE7xJY=;
        b=MUDl3+DsUDKHQtkBNBhnwlJwXqY7+y2cclbaXiWmxxhHODhlcWlfjAQO48OMZGeEan
         MMFmea4LS2Zb+teGW9KWuDavN5Wm9r/m+J7QrezDZB0A9ZDW9iMnlO5nnjcOOgPURJCa
         nXHTncNcj9TUKZ/N/IBbPeZUCkwviCOxG8anY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758611435; x=1759216235;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zx4KAtlXII6+MRsPkHeERk1awByqcg438XULFFE7xJY=;
        b=YlU7PRtwX7G+i1l24Ktc/W0F0DuX7mSatLdF9OuI5np1y/8piOAAmEk0xHjDbBpT6g
         94mOsZEicbYE6ZlfhJ0oPy5Hlf+LhFp5yHEllzZDbRsF5Ox+PpTaDiPMvAOX6+G39jSr
         RVBD6T2KyiJ2cvosN3tLN/ITFS2Ft8PIwHGBCXAhX9fUKQGr4ZgHiarZR3cza0O+rRaF
         6UJoKsQW7VUmDnma2Er+bvhAPfSf3tiBLToib+DmPz6N217hTLWUtGTH2PSqhg5/cYS4
         0bHCoGNEZuvYv7kFCZWdd1DOXaQHrkjPJ5XnldUqnoZeHo6sMwu9PDsQHjdpKth3zemP
         1VOA==
X-Forwarded-Encrypted: i=1; AJvYcCUJwIFk6KP5Ye3htuK+IwAxlx5Bb+MKnsaNYMkbmyAxchvLqrZtAy8lFUZk6aNb41hqVR5K2N813VI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPLkJOuMkCrJbK9ueqFjMd1z9hNWQpCV4vG/5mk5T5xOl6HLE5
	K64SH7FcqBHh/se9AnZAuPDQilvKgEzv8ZLIpkoHoG1Kp1VuhU/6nMi9i6Z8+vUXiEbpM2Mk7C0
	VBPAyty7kIKzoyz/6G4kxqoyYIz5m+5ywAGu59g3eAA==
X-Gm-Gg: ASbGncvLXhmedQ8jKZzoIZ/XFEvs2CyxBwjx26F+8nQm1Dyp0BPJfBvd859PEi+qSG3
	WUkgxy8TZ1bcn1iTivkpO26Z8l8+yTKSZoN/tFi+RWmjjOCuFc49sFU8JSDXoZ8dG+mwYiGINT3
	A0ORQFL8LVtbPKMgKiQIzeNovTnkWAUlbKeUq0vFmXFo1qwDGUcV1S9kJkLrUpuiJo1UYzw4UgV
	iEg/i7NgdsQIYLP6wVfZbAVsFaLsffLHr5p6Dw=
X-Google-Smtp-Source: AGHT+IHtIqh1nO/q8WRo3P7LNY5Dh+zBK2hbR8HfJdSGOKW3ZudbQtvlNUueEbZ6VdEgSehhe/S2kkvRpCjJza+llGM=
X-Received: by 2002:a05:622a:5587:b0:4b7:7fc4:45f7 with SMTP id
 d75a77b69052e-4d36e5dee72mr17411201cf.42.1758611434712; Tue, 23 Sep 2025
 00:10:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798151087.382724.2707973706304359333.stgit@frogsfrogsfrogs>
 <175798151352.382724.799745519035147130.stgit@frogsfrogsfrogs>
 <CAOQ4uxibHLq7YVpjtXdrHk74rXrOLSc7sAW7s=RADc7OYN2ndA@mail.gmail.com>
 <20250918181703.GR1587915@frogsfrogsfrogs> <CAOQ4uxiH1d3fV0kgiO3-JjqGH4DKboXdtEpe=Z=gKooPgz7B8g@mail.gmail.com>
 <CAJfpegsrBN9uSmKzYbrbdbP2mKxFTGkMS_0Hx4094e4PtiAXHg@mail.gmail.com>
 <CAOQ4uxgvzrJVErnbHW5ow1t-++PE8Y3uN-Fc8Vv+Q02RgDHA=Q@mail.gmail.com> <20250919174217.GE8117@frogsfrogsfrogs>
In-Reply-To: <20250919174217.GE8117@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Sep 2025 09:10:23 +0200
X-Gm-Features: AS18NWCbS-teU2d7wmg71KZ8kBTNgaO5RTISqeIfj5N88p9b4fmTz2JnSimimuk
Message-ID: <CAJfpegsEL9oD5z+UQ9NDEQtKv55vHcbZGko0ZgMY9RXnZzFmBQ@mail.gmail.com>
Subject: Re: [PATCH 04/28] fuse: adapt FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} to
 add new iomap devices
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Sept 2025 at 19:42, Darrick J. Wong <djwong@kernel.org> wrote:
> I think capping at 1024 now (or 256, or even 8) is fine for now, and we
> can figure out the request protocol later when someone wants more.

Yeah, whichever.

> Alternately, I wonder if there's a way to pin the fd that is used to
> create the backing id so that the fuse server can't close it?  There's
> probably no non-awful way to pin the fd table entry though.

I don't think this could work.

My idea back then was to create a kernel thread for each fuse instance
and have FUSE_DEV_IOC_BACKING_OPEN/_CLOSE operate on the file table of
this thread.  Not sure how practical this would be.

Thanks,
Miklos


>
> --D
>
> > Thanks,
> > Amir.
