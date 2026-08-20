Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BA5222580
	for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2026 05:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787202939; cv=pass; b=F+jFQw8Wal/Zz5FP0j9aj7GdSqQ54RYiGw8JMEzV1AOtQUdYyN0jmtprF7hYssbGxLUoJPmW9zAAcnAr+F2Rlttdn74F747mL/6rEHxJEbnM+JfYG2CKYpAwuuYgbz9zbrDgCITUxX5Aie2i4eE6DFXGdtxP3a18jrvPjWYxdnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787202939; c=relaxed/simple;
	bh=zTnTEoXTuFEFA/C1D4ThX4Y+an6VucxyKo4Nr/GlcI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=grUkD6Nhb12taYyKHA02aZ0dwOsQX8pLPUZH6kDqvwZY/4AHi9skXQnUnXFg74lbyS+aUVh0gsJg1chC7/9xxyVdUF6mSd/tjwzD3VcC6Xa2Ay5ugfZlA/wkDwnqsFcCpiDfDrThqwPCXWF+QIOkq9VgAHnusbFNtEsOWCOr3hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=pR7HueMf; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="pR7HueMf"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c16ac21acso12603961cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 22:15:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787202936; cv=none;
        d=google.com; s=arc-20260327;
        b=FwBxVX+FPNBCFVn5gCMHTfX7cw6nwshj/e+o+zgEhbpzu4O/iz+ROtyswSqqLf/CKC
         BhRw4uJ361CNyf8ZvMHgC/tAHjS9gCty848n67iTlMA4ManiV8dXMAQ37HBsvKP/g03X
         2+zL85XRwS+ZxqsiLyxSYpzhatFC7e2/5eUWHqdQu87Wc24DBpVJYAmrcr29gZhayNoA
         sTiwb0l1qZrFELWFXrRWhkrgm5jFCadPnhCbSy2+t9oXxDlAHFQmHd0zpKKjf/N7aJOm
         aOqbAn9QkLNiSVl52zI13LRPAvCdk6xRqQGrTyYtf5fqTkGeGVGzwOUKfievYiltVFxC
         vBSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=i1qzFHY4MADO+pKP/rYIVSKWuTq1hiwkVURcjqrdi5U=;
        fh=blzlCt+VtcB9z6AtrpoYi4BqpowH+WRUAAIzWp3Lwcw=;
        b=CYUbvqNmCX7xGM6Y5U1swy1rCWzl8eQZCN7rPnoJ3XMsn7Z2b3+pwUDZ10+miWol2G
         nSgnRNA6U+3Jxah6np8kNA4gVfXaVbT4JPmplxTMGfmlYL3cx54mWgc8lA8VviqRsvf7
         JBST0IMoRqrlR+9TR64Sh7DBoBTJUsjaeVraqn9S8G6Ppd/aeekHojLllmeoMh2dxw0i
         Ea9fvI2tRFSIKIc0IXgFo7pGgtdnx1+p6Kog/edFt3ExYg6vUBHKGtvRBJpzsa/PDLvA
         h7cFa1FFjGoJfYhNRuGx5n13cBjKNPjZ5TfdCsvrW/3MArB1tOFRJQJUtjcRxEqs4TXZ
         Sc6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787202936; x=1787807736; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i1qzFHY4MADO+pKP/rYIVSKWuTq1hiwkVURcjqrdi5U=;
        b=pR7HueMfPp5SsP/6XDPqV3w6AakvsUCG6mW9WHE221/ExmC0JJyUt0eAXIvrBlIQce
         OaKeZJhSE6nLUxf6+5vvg44lt0DdRb4U0zCmhK/+AkGn5ccbepOfonR+P6DPnXkjCnYO
         sQ5S7Nerxn7s8+7Dlj91Qv9cdLg7CjgI//4G8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787202936; x=1787807736;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=i1qzFHY4MADO+pKP/rYIVSKWuTq1hiwkVURcjqrdi5U=;
        b=nTYEJHXBh9oSNj0WTOHlZBI1VE2xYA5SvdAI0zNPTX6KmSqMuRTSBdNzz309PRCjRR
         JqWQW2HxZTEXQDrOLYmlRpL46NmuVD0fSZGOMIUVXxz+GGU5sMjGJL2Kvc2FOp+sfn57
         ADts0964Ro+7Q76/XCFwKdWRKbQjJzACoQUwJo3fYxr/9JYve0aQE8FXsGwX3GRiG2n7
         SND70INzeRYn1aXsnISPwtkLq93Euf5FQKHQO1U61IdtGZvxxTNtYwedeew1fapYPA5W
         SjQ3Fi2j43YxFYGfet2wdLisoSFpP6SXhP0+/Lq/4irQDXurTWim5y5ApWJ2fJ6yn7AM
         YpIQ==
X-Forwarded-Encrypted: i=1; AHgh+RpfqZWFke0s30fjiIGKqrIKoZTdxANCvn1y26D4958yN99Jpab0FSu2pFnGdFha+4I0yFQl+sACZB0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5c0PN9s3JGmS1dFAofie72VhjWmbjyT5AziZFAbG6S3TVu5bX
	Kcj3YVnBA/FvMV6Zw7pIrHTmu/GFMm5OR7Ozr7zE9A+X0mxJ016uuib6EZNft8sR9evcmPkm5CQ
	w4bew9xCmTyuazazW6LHkChn3qE370IWhm1lZ8KXCSw==
X-Gm-Gg: AR+sD11VGgwQIZb0xzd/SgY+LJodnb0iTf9dWBvLUs2TdEQ+ruqvJkh3yzyZOvlgg2t
	wrNCbu4QXBoYwaggE93VhLns0W+HRhMtf4PWBhohMVtuoKZUPbyh5A9/EsevTLDM2MOoJlsmy02
	paoTXnRF/1ENP/iv36fiGh2pcwoQEEs1oy4m2z/Tibo3P6tpMv+SEQka9QLXVsBxETB0EcyupWK
	sWA2xMThhwLh1tkT1s+Rsb78dDl5kgpkGpV67RBQPPgkhfDFX9mBtwRw6HgK72lE0ed67f2lGcq
	Q8wx/GE5RDZVxkLBYtYQnWMYCwAs5FgJOtOKcbaE6hrheE3Hfb8i8xSCVqR7S7lAo0ROu65UT3q
	FMJ8GrZfjwj8=
X-Received: by 2002:a05:622a:608f:b0:51c:1e2f:1281 with SMTP id
 d75a77b69052e-52dd5e1114cmr96727921cf.42.1787202936231; Wed, 19 Aug 2026
 22:15:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com>
 <20260717125538.508925-2-joshi.k@samsung.com> <20260721030338.GU7380@frogsfrogsfrogs>
 <71ae458a-a6e3-4c6f-8fb9-7e8bc088bb87@samsung.com> <20260730172211.GF3556460@frogsfrogsfrogs>
 <20260819070459.GA1541@lst.de>
In-Reply-To: <20260819070459.GA1541@lst.de>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 Aug 2026 07:15:25 +0200
X-Gm-Features: AcwNN1XXT5xefF0BXUU_TM3qwY6KZTggS9AZTFDK2j8DH58mqjaIjJ16-hbRpyc
Message-ID: <CAJfpeguAkB01swoTKmqcEOQrej3g8yjr2RZSPQQPeo-4UE908g@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>, brauner@kernel.org, 
	dgc@kernel.org, jack@suse.cz, cem@kernel.org, axboe@kernel.dk, 
	kbusch@kernel.org, ritesh.list@gmail.com, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Aug 2026 at 09:06, Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Jul 30, 2026 at 10:22:11AM -0700, Darrick J. Wong wrote:

> > passing through to another layer (e.g. fuse) assume that the third
> > argument is a pointer and that it can copy sizeof(data_type) bytes at
> > that address in and out of the kernel as part of marshalling.
>
> That is not a good assumption and things will break.

Right.  Fuse server should send a whitelist of ioctl numbers it can handle.

But ioctl's are a bad interface anyway.  Why not add proper syscalls instead?

Thanks,
Miklos
