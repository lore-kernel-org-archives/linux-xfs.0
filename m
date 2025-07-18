Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384712E7F19;
	Fri, 18 Jul 2025 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865853; cv=none; b=OPyTb4AuBav3URqymSrbiIfoivbebs0gkAh0iSQv2KeC7z8mvPARblvPCneTJgJ9HkGQtsiAlI8Ka0m00BVxkW5p3aMf25yn8ZvavkIPuI4tZMWRvTBAuVoYkzyjeR56T9I1vUuH52GsJFte+kwe6LZ45s87S3yMCpnxFvjFbr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865853; c=relaxed/simple;
	bh=NBeZpzm7GJCFLtcVOkWgo1+H9JM9w028NRbEWcA1PWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+sX1rKyfA1cGK9Kr4wdu2alm7Vs+BeLwqTya/gOAODbRncFpfJ4Iw1s0Exad+Bjem8C6cCbl45ocAYoF6UVxbydbno/ivlvIYxn0rQYPTTfnECSOiZCp7dSappmXqAq5Onwzf0J2tdk1XRpzzpBDeTqoDGpBcjDeuASuC3pBEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aN4GnqDG; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aN4GnqDG"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-615a02ebcc7so746511eaf.3;
        Fri, 18 Jul 2025 12:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752865851; x=1753470651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBeZpzm7GJCFLtcVOkWgo1+H9JM9w028NRbEWcA1PWU=;
        b=aN4GnqDGXZ8rVwgHKb+lESvEoZmEA+aUwgrFpB7BShCTn+pK6JxyuwkhkpL0t6YgxM
         LATiNz9A/36FVZPLqPXoooyG4tdncCvM1AwVk5qN6M+D7ZJ/gqOLasPkF+DFP3VRJs0H
         YDwrCeIeCzpwxTlBBgEJJ7RSr6kx7pki7b3vTxqWcwiyNGwN1hL9k1/iIz0uMrA+GN++
         rOnvB7290jRYIJ64gCu7UeJ8vqrEXoO222KSWeDA56Xlp1RtCK+cdtQF0u3WQFPQpodz
         vQHzATvNdogX8oVms6vqVK4z4irHQGU/vNDiDf3PPByTKyOOoqhaQ4yrYwZhciwV0und
         cN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865851; x=1753470651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NBeZpzm7GJCFLtcVOkWgo1+H9JM9w028NRbEWcA1PWU=;
        b=tnQumjnE9mO9lGvkJCDNjFEE3XFNBXi4gUg5BSgcM+Fw/zcZnd6mvE7NotFN30c3L+
         mOvLki28QoUf+sJYhmSERO53R34JqAe/rAna/7FfRDOyymf8G8GPPc/6xpHFlX4gW9H+
         4/ldrL01PU8o1bTFNnXUrGd/ehy294H87dnoMdqYN+xyI+nErtBLcPdljKH9nozB1HwV
         n7Qd/VjC9YdVIohta2wYoBBeZJ4MuHWs+TJNJPYMCJWirlEIek5BoHiXAqiahJHtDcSA
         A8/0Bk7+5/keHWDIFz8/RVENYDJwWy5P/0w/g/KUfBozugEU3F2BwVbclzEm+yvW69hZ
         eDTw==
X-Forwarded-Encrypted: i=1; AJvYcCVzUVIUH94UQ25n4kgRdFptEyZYiKgpYTuTR1WBI6UyXP84Qi7v/UzUmRCSN9ReLM7wYuSb98uqSo+cliM=@vger.kernel.org, AJvYcCXhqCS2I5/iFtjgxb0mn1j92up35qca0JqNT+RdUn7Sky+ylYsWn9p6Det8zeLJBdVQRgifp1TvTOsk@vger.kernel.org
X-Gm-Message-State: AOJu0YzsqPVBy512RZHuc/vKrp4JV6k4DUu0XKy7PqF7ZCUY0ZLyr80h
	I6Kxerc4wbRY7+4AjoZEhOFbJ36SV5pkiTDGyLyhN5cm5I9Uznh13B60K4aXsS9jl5o2dekSgn1
	Xi7ozlkGPyHW7H4nSirjye/+E1OodW88=
X-Gm-Gg: ASbGncvEHKB/xlPmyhnDSSLLGS6UlYyFXrXe2VHeHjLb4z0EM9lfOlZueYFlvEoxkS/
	+dX4bjUAR8UDQHAHTlNYPBtbWjcTZS51WW9AdOuAv1oMOYDMR5TCXQZsuzasMCpy4WdA70it5bF
	MTChpVpw2YyjhtjXDb3RMQ/eCSqfnrVsqvjihQKVL50tbG0jQbScHk6d428xSVuEhotrlyK1DpV
	BvjsGhVGNaj2nFyd0E=
X-Google-Smtp-Source: AGHT+IFvT9uZeX9R+yE8NA4HuE9JOuCVycgp4n4KGotR19hAge+18sehg3O/ostkpGjx7rtjx/On6spc1kzGGj+W8SM=
X-Received: by 2002:a05:6820:1b0a:b0:613:cd27:2fe0 with SMTP id
 006d021491bc7-615bbb1d011mr2697179eaf.1.1752865851181; Fri, 18 Jul 2025
 12:10:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716182220.203631-1-marcelomoreira1905@gmail.com>
 <aHg7JOY5UrOck9ck@dread.disaster.area> <CAPZ3m_gL-K1d2r1YSZhFXmy4v3xHs5uigGOmC2TdsAAoZx+Tyg@mail.gmail.com>
 <aHos-A3d0T6qcL0o@dread.disaster.area>
In-Reply-To: <aHos-A3d0T6qcL0o@dread.disaster.area>
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
Date: Fri, 18 Jul 2025 16:10:39 -0300
X-Gm-Features: Ac12FXyZ6w5FS6LO45cJmpbQwjoFWm7SdiNSX09zxUTjp_5jnU0jujAIHAJKXV0
Message-ID: <CAPZ3m_iwS6EOogN0gN51JcweYH0zuHmrgVvD7yTXTi1AoDA7hQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: Replace strncpy with strscpy
To: Dave Chinner <david@fromorbit.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em sex., 18 de jul. de 2025 =C3=A0s 08:16, Dave Chinner
<david@fromorbit.com> escreveu:
>
> On Thu, Jul 17, 2025 at 02:34:25PM -0300, Marcelo Moreira wrote:
> > Given that the original `strncpy()` is safe and correctly implemented
> > for this context, and understanding that `memcpy()` would be the
> > correct replacement if a change were deemed necessary for
> > non-NUL-terminated raw data, I have a question:
> >
> > Do you still think a replacement is necessary here, or would you
> > prefer to keep the existing `strncpy()` given its correct and safe
> > usage in this context? If a replacement is preferred, I will resubmit
> > a V2 using `memcpy()` instead.
>
> IMO: if it isn't broken, don't try to fix it. Hence I -personally-
> wouldn't change it.
>
> However, modernisation and cleaning up of the code base to be
> consistent is a useful endeavour. So from this perspective replacing
> strncpy with memcpy() would be something I'd consider an acceptible
> change.
>
> Largely it is up to the maintainer to decide.....

Hmm ok, thanks for the teaching :)

So, I'll prepare v2 replacing `strncpy` with `memcpy` aiming for that
modernization and cleanup you mentioned, but it's clear that the
intention is to focus on changes that cause real bugs.
Thanks!

--=20
Cheers,
Marcelo Moreira
