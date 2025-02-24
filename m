Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B6525A342
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740411940; cv=none; b=KIwtnnNLppQnhjOWdFKIWICgoqEPpwMqKSqRUtamkpJbf4DiQvaDVXnpRjBLQfqPUJVhXS7LmQ7upKKDzZHlBjA4ZfxTAHW2MPsQT4EfOdmAz9eVSxgsdoRHQ65itNu2tFjLGOH+lhSaDgHOBbViXPuuvpT0AMSp8fRX8mLZfQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740411940; c=relaxed/simple;
	bh=QR8PQ2mLsQpUR1F0fq8t6LeA0WbrKQ2TFmOHo4xz3F8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mAcdKLmOBnPqvhnBvbOL45PonVgaByoHsZZrToV5d2sf3iG24WiSFS0iykQXWqfaoRD2TtFe+zqqxu/UptDkJs5JSxbKNCRdMdEnuSAhRzOc1lFhd63VyR6tZiSzWl1ZtE4SveYrcoFWelivIUw598Py9SN0PbGvKjsGrDRjZow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com; spf=pass smtp.mailfrom=scylladb.com; dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b=Yugd5ZV7; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scylladb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b="Yugd5ZV7"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2fc291f7ddbso7354770a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 07:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google; t=1740411938; x=1741016738; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vpFPjAJvV1xY/hqE7tYkEGP8ugx8Y4/2E/Q9/wCmV8=;
        b=Yugd5ZV79CI63ZzMcsB6uxbKKBpJC60ivCFpRse/Xso+Y0KDYMfDVDp4lAh/ZRSJTT
         YpBJgCS6qpdr1y7g9yZZwYPPhLyKFK7Vi7njJIJfdm6DQPJEliuwBKqMLKtIftTAAg7v
         rQWfMy6i+kecNIUhnWet+GYCx8a2pcngGD0lmvD5iqebmITIm9+MK5O+AnInaQuqQHIS
         t1KjUdDIPYto8hFfRHZdtoLJhHnomPwDUbFHZXKa9uHR6W7NP+TueShtMpTX8xEg2Qkw
         oK9uxHX7xKAD+2IPX46ruh1GZAtTBLtUuD8sI+KT0P/jMWnwQrVbuY+3R8wrW+RMVDMK
         cIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740411938; x=1741016738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2vpFPjAJvV1xY/hqE7tYkEGP8ugx8Y4/2E/Q9/wCmV8=;
        b=cu/Af247ucjXIm8tp3cpQG5VlVSEh0wGFyVugBhFGcg7kPi5h7GOumMYmXd4M90bUE
         Rn3IxiMQjwbLaE9f03OmiSihMMaBwzZhX946hQUn/FVrG7XhJehedV+t1ey+Og+Hy28p
         MnRQP4cVQbnQt8P2eaE0oQDvJY+usJmAFnM0AS9UqroEYPMNQ5XAfTTgDmqpCx5qjLyC
         4XE7fDI1SrI0M9heRg2ZbcKCbmJmDkjsgAWLpO1zsQeBW8sG/p5F/4OMKivN6+zKJv3U
         qo9BrCCx2PtguOuQ04El1zc7MOgQk3V+xnI7ozGAVplv03TJwrgg+gFJGbhl3uMhYBTo
         qL7A==
X-Forwarded-Encrypted: i=1; AJvYcCVGFcKJDjxSuExU+/2PfdmYX+CDzrLT8lFLndRHjVDws6wguwasYlACOJFKcuRq7wv8VV5F8AbHxQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7FCNfzZ5pExYFILfYqEoVhsI/eMq2D716KFJUtDg546EwFn1f
	PA/3VjRNehpvV9q8I6/LogdaQNhBplPFqEFBATZggQu0b+xhiPq1Cbu09YjerH2Y6lLeTehtTtb
	sGfOr5k617UqWVVceY26HRQjU+aU0BptbklPMbWydM1uichuKBDB6qvIOwpDfJXuCejCkDZR9j/
	MItvuxI2HYweQNzsXB5iZK9UfL2Kc0iisrfQTX2jfE67G5gZtlipTLXzabkm5b3WBCwXEVO2tgK
	XRcJHkn9Kv+9jdbCOEKj3qDbJKxOAoTDfquIRDCTf8KmtAYejr/4KEfYogxYKLNhUhrXEeGv8Il
	skoHU1HsSncMUQ2xvBn7U3fFlFcNtG0FwPDspEp/nR0d1MajnriKo94WMN9Z9PogPdQeDPbEU4k
	ht5Lmn7BY
X-Gm-Gg: ASbGncuOcSYseZZHQVmZT0kPbdjH2GBYq1krVi6Dt6vLRriYtl6PW6bRFnYXiRzqJ9I
	1o6YPXe+whCzpTl61gvhgDuhvpW12b1CKYEOuclFBcT9IrZV6dWF2kxq8tCtx5hRjGU+ffDxHec
	aqLYnrcQflWu0p+qTrLT6xnA==
X-Google-Smtp-Source: AGHT+IEcQNiAKMUbPh0M58vsweOlxgosMhBo5YTURrJtkfwHfEjps5PLHRpPddIOGjzbuxIf2pQa9/eWZhn97IwVteY=
X-Received: by 2002:a17:90a:d60b:b0:2fa:e9b:33b3 with SMTP id
 98e67ed59e1d1-2fce77a646dmr21092693a91.6.1740411938036; Mon, 24 Feb 2025
 07:45:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250224081328.18090-1-raphaelsc@scylladb.com>
 <20250224141744.GA1088@lst.de> <Z7yRSe-nkfMz4TS2@casper.infradead.org>
In-Reply-To: <Z7yRSe-nkfMz4TS2@casper.infradead.org>
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Date: Mon, 24 Feb 2025 12:45:21 -0300
X-Gm-Features: AWEUYZl1jANUANFo8W3Lf3P8R8iIFWcreRO9Y0ZcM5Jd0irI990vkN6P7vCMcpk
Message-ID: <CAKhLTr1s9t5xThJ10N9Wgd_M0RLTiy5gecvd1W6gok3q1m4Fiw@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Fix error handling in __filemap_get_folio() with FGP_NOWAIT
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, djwong@kernel.org, 
	Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylla,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Mon, Feb 24, 2025 at 12:33=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Mon, Feb 24, 2025 at 03:17:44PM +0100, Christoph Hellwig wrote:
> > On Mon, Feb 24, 2025 at 05:13:28AM -0300, Raphael S. Carvalho wrote:
> > > +           if (err) {
> > > +                   /* Prevents -ENOMEM from escaping to user space w=
ith FGP_NOWAIT */
> > > +                   if ((fgp_flags & FGP_NOWAIT) && err =3D=3D -ENOME=
M)
> > > +                           err =3D -EAGAIN;
> > >                     return ERR_PTR(err);
> >
> > I don't think the comment is all that useful.  It's also overly long.
> >
> > I'd suggest this instead:
> >
> >                       /*
> >                        * When NOWAIT I/O fails to allocate folios this =
could
> >                        * be due to a nonblocking memory allocation and =
not
> >                        * because the system actually is out of memory.
> >                        * Return -EAGAIN so that there caller retries in=
 a
> >                        * blocking fashion instead of propagating -ENOME=
M
> >                        * to the application.
> >                        */
>
> I don't think it needs a comment at all, but the memory allocation
> might be for something other than folios, so your suggested comment
> is misleading.

Isn't it all in the context of allocating or adding folio? The reason
behind a comment is to prevent movements in the future that could
cause a similar regression, and also to inform the poor reader that
might be left wondering why we're converting -ENOMEM into -EAGAIN with
FGP_NOWAIT. Can it be slightly adjusted to make it more correct? Or
you really think it's better to remove it completely?
