Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A1485508
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 16:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786637643; cv=pass; b=U4lUdIdrxky1wwvHTCQkvuyFuSZ3mOcYHpXm5XMnDfLaXNAZcqReVL/oU70xZypcSUOBN4VhbdHphmCu1hWn8qhKhybaxYpcTkfvNh8LbJTXckQYceAHGFiDg+WvMERxWfpkshGKtIPqsJ1mXySXMfGfKP6jGfcRcJ3eABsJBHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786637643; c=relaxed/simple;
	bh=W4CcLslGoVgES7gXkGgSabrHC7MeZOuqtYUByLWmTsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QOSO5HNibjv4dWMPDVMtn2eho/BxcDi/NwbUpTLGB0Nuee6UGGgRMJ0s18cc5LZUbyXoKx7OGLoe5glCMO0yh1B4HtgR77q2MJfk87ubwIIMjOMHogQd7l0n1jYVJPZoyzUSRGEhlCO7m5MBmYS5SrHq1OpH1kE9k6eFYVJAInA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FRK6A6Tp; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FRK6A6Tp"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso13271566b.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 09:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786637636; cv=none;
        d=google.com; s=arc-20260327;
        b=DUkoD/z4fg/5lGZ3BYCgZcWK8aqmnkYMV/Me8ejG2lpoISaadQf/hZgRK/TVj2prr+
         /ci53NSM5hlCbliH7ikLlTpQVwmWnNbG3VBZ10MLN/ve4glWHxdvTTMZS5NVuTjvXvSo
         VBv4mGENHpk5gJB47wFMfqH+RHReVaGGBoGzhkpXX0w3XsQaSjHRCOtDk7Rid7wCqL3Z
         2siB/7PLO36gc4qsZg8i1qDm63PTGEp+9IqzP3aFyQ5Z7IVfCx2vPl6NC1uKhoGIh2dN
         GN62Z8hGBUqx/IAc/6M9cs2bl7A5IiMghhNz4zC5ukH0kYd12HERbK2dv9U7tYYPtYkR
         J/RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W4CcLslGoVgES7gXkGgSabrHC7MeZOuqtYUByLWmTsk=;
        fh=2+gq3faW99QWN3wChIU63qbnxUuFFzIFXkPlSOAA0Kg=;
        b=l0GvWIHmSdMfmBO9tHqd4ZYbmNdoD4LyKpjb9HoIuQYYCM2ivGYNWyjBJ/Io8Y8Myq
         YQq+KWxLtBbHHzGvXD/cZWyC59fE7QekbsgAk5DXXt2fMKly1+XmrwqvTKqRycQ+zEDO
         AN8b65yU6xHbIcKyCXgE/9c9ugfajyi4VwHpKxnnUMikxxUFiHMqp4fYhnLdd7YRHnWL
         6OWa9oHO9GVvS/mTCUpLktX4dsOw5yFsYs/iARvYS5u7Bwx8QQ+Gv0YsSaqIl8J/kRlz
         7SIrfvZ0OumUKpcEY8YayrApD0H/AV3sQAY6tE8zbyBHulH3BuUDCt6FBN5Hec+tS765
         NncQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786637636; x=1787242436; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W4CcLslGoVgES7gXkGgSabrHC7MeZOuqtYUByLWmTsk=;
        b=FRK6A6Tp3+OpXcmxOIan7kPQqoO5NagAomazQr6TOoYw8vrST507v16Txwis4x1Fpa
         bbXFgUUhhBNzIXoJ700lQDW7yQ/TTeOezCg2LVUlsh0xZKSPDdYf1yMbQkOKaWLyyayS
         mrcDDU+1+yaRsMk+kBKgrTpei2wv3zTfFHNz5QIGesC2YQwxGLWRGwJdnYnJWHPisQ+I
         7unGyxU1kVCfku5xlOgzyXEB8jHhLMgmSCrgV/R379Me/10CkUfEZhu0WFLLN7exPsRc
         rRvpAa/xP7+ryNRGTqkqFrSqgwK7natJeoDVSxMc1mggIizjmO1oToodVuD7zH48pSTM
         KrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786637636; x=1787242436;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W4CcLslGoVgES7gXkGgSabrHC7MeZOuqtYUByLWmTsk=;
        b=RxKLmzXpO5/qAdjEogiy6Yj0nFfYu7eneu7Fi5cbJ6CO8TjZE9eG8YVxBlAqQvXKHv
         cOe0Qjk2l7oNyT7wcIPkjYssD0Sa51JLAP54ntcFGlZQLVP28BS1zB0Baztt8mnwU5c7
         O1t0/P+92Gp03jhdM9CzRGIIzKDi9yRrwghtXboQLjnvwBxSJx6ZLxL/zfvKA0NKxGXE
         S4zn678IRjjeoXkoLJM+mFeW6Q4YubfEZIVinU6VBN8Kfzw5itlYZSgGXvjopYtqQUpT
         GB6lHVeedombUng3/hnvAW18mjhQUWQl+R9S0HuFMfaPTRjNQGj/Qy02yil6T2rrGe55
         vkAg==
X-Forwarded-Encrypted: i=1; AHgh+Ro51nnrZ6lCz+DLLliCIhBgRqcHNB/90lDFiOWMWxp1ilaw3E1h29HHd2bkK8nXUH30zO59CFrjw24=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4l9l3MDUY0BtnbsirxyetV79tBeiWqVk9Xm957/nEe28ncKb0
	inXXB6kYZE9ASHsRIllIdlMnjYc0I9bF6C5wsa3zfL5irlWOToLJI46+okyjvQ8c35/XBVQVbYo
	PQBB5lRdQYylsGVNL8nDvoPlSoSnxDJU=
X-Gm-Gg: AR+sD11bctFQ+kUAq6UUGkESBtrroiCV9gMtI0EIfhWAPw52IhErYU3E1tSVpMcIYMh
	LleG/DG2NZcVSbzpqxOMrwJEJdRodnCKUNH7qeMtriI1a/XWp8C3hmdRHhHb6b1bOI4X3TfGhSY
	ptF+MunuRrEe2ZLMdQXQraeihWQrFSX4XFkl5RDaEhbqGhIAXOnQiStyCzo0zgl1zyVyMGEvLEd
	Hh6XquGCiA3dCiZAVTF5Iq5/TUj6jiZ9fM6LQ2iZ8iTENSS67+JZcNIYo/eUTbpJGGGOg6+mCo3
	Kexz+NWkS7IWOGT5SJgbuYRJf+Ck2Cul2Ece8zzZCapLBNbzFVRgjihXV3IQx/1PrL4CK+fhOVL
	g
X-Received: by 2002:a17:907:d0c:b0:c16:6c84:4b8e with SMTP id
 a640c23a62f3a-c2108f76a14mr347283166b.14.1786637636103; Thu, 13 Aug 2026
 09:13:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com> <20260624173531.GQ6078@frogsfrogsfrogs>
 <CAK5ssPP6FL+6i8z+0QdE-9DSp0rC_U2S20qdxY7Kmdp7RS0xRw@mail.gmail.com> <CAK5ssPMyJhvnEQSRoAwVNnZS-A837OOMewEAvp+ZiuWKD=vUdg@mail.gmail.com>
In-Reply-To: <CAK5ssPMyJhvnEQSRoAwVNnZS-A837OOMewEAvp+ZiuWKD=vUdg@mail.gmail.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Thu, 13 Aug 2026 21:43:44 +0530
X-Gm-Features: AUfX_mz4ASx4Wg4jtxq0QE41OyrxWoOEl9k5B9clEEwKWUqr_O2tj4xFQKNj9w0
Message-ID: <CAK5ssPPC4Ov0KBbRphC_wZBZGu1Rr4-d2At4V+ZECFcuHxbEfg@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen filesystems
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 6:49=E2=80=AFPM Aditya Prakash Srivastava
<aditya.ansh182@gmail.com> wrote:
> Hi,
>
> Just a gentle ping on this patch.
>
> I replied to Darrick's suggestion regarding the
> sb_start_write_trylock() approach, but I haven't seen any
> further feedback since then.
>
> Are there any remaining concerns with the current approach,
> or is the patch suitable for merging as-is?
>
> Thanks!
>
> Regards,
> Aditya

Hi,

Are there any remaining concerns or feedback that need
to be addressed with this patch?

Regards,
Aditya
