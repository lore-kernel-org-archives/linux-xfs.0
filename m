Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AC2238D52
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 01:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783042891; cv=pass; b=dx1EyUnLyFyvfNTWk/I8awhJ+cNpLTLs8y9FQI47UnaoDenhluAhUYfdkin6kvDmUv4Mf+oTGAM7sVVjMww/vNA9kN+O9pWEWL7oJk3tyj7MKb7KnTdOcHApvtY8J2+p6KDe+L9z084MxV140WOJWwDHSveAttE4ikh8+7DDrDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783042891; c=relaxed/simple;
	bh=w7xoVMyf2fxQGzPR8Ogsy0SlEUtXTDX36yswxAlMwHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aS4+RElczJF3Y8czZBz8HXprOARb7e9Nio8hMfb0BfITlJlPY4q3V8r05sN6RRLoPr37SLAa9xfamO+SHGRU4gc6C4yNncbgyhbuovoqCl/1T7ibMKmeL3H1O9ilEWAk29JLDwz6xU/bK8fXGqTFLiEFpOEfIYMni4bsOTM3w54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJaEv2NL; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJaEv2NL"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-470174001a0so16476f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 18:41:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783042888; cv=none;
        d=google.com; s=arc-20260327;
        b=a0s2iAD1mbeAjyVsyEBcR1ScRyAs9ZY1DIFqe43I1Ix3YOqtnZra9JkOGWFCTLkqjv
         3sIMMzoAz58FtqeoCRCbyNZL20/0LH7fJ5SjUeRFgqT5EX1mNI0MDSz08/ZUXFYERuOf
         rtwt1WWg4L6pSXafzQC4pIChz/eMqUTant/q9X9ls/CgVU+UTR0LPC7dIK5cOJAS7Juv
         21wIqCnkJ02zLNwfcLiejdrJgmeGogV3BMQbfBj81V8LQbwkHvEmlixoK9UVaMwJM89B
         DjOcFNORBKftTzwIJ/Bd3VRUJM+MMo6HqARaYooG8p+js2POuaS4lAd113Oc+qAYnhKQ
         HCLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w7xoVMyf2fxQGzPR8Ogsy0SlEUtXTDX36yswxAlMwHw=;
        fh=M1AZ525XN0dHsrj9dQXyZ1u0JP4RjfTfZKQc+gDL+fU=;
        b=SXxJNmBqKYzVPbeKPDUHwfv04TFfbSWcNVqTDgCoT1nE8d0N5o6MGMPSq/dNoSP632
         Axzwrepk5FAK+dIrcX8rjJ+B3z35gQqfAymm58UVWwGvzok4Rz63nuARPeMgLm6t7ax5
         8qEwvfRJHz8kvaVw/hHXY6AAdsAcLELXNLjeDKJFFWGwy8Y6605VkecKinP5Nc4u+k6i
         Z/S9+hVlGh87qmbLU214/OLTtSq4NzZxPVvLI2bADhGOS9yxrkmEKP8S4Kws8G/YJzKn
         TPU6plTClJ1oWeZZwNnQ3HoRhFBqcnT4E/n3Nl15BT2R4NkIhTM9B6HhNwQaXteDW2of
         R7lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783042888; x=1783647688; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w7xoVMyf2fxQGzPR8Ogsy0SlEUtXTDX36yswxAlMwHw=;
        b=FJaEv2NLwVhGqTj8CIOyAwVbwiP8SYVvLUiPoXu8PE9uWH7OTYWUyNvKm1q1q4RmDX
         boYowXT2BrA3SUph/V6feeWdUvW/6vq+nxx/51l5IDJL9N/TPn8qdtsrWv3MPb7waWkc
         8fpiOzZ2/ggPUq6wJJjLF1BP1Q5tx/usFS1v7SWmCJmhoPE2L4uVPoEq1SwONhFkHp8m
         z9+6XA5gULLjQkTMqnGvL3zC3+HFdfuPiWTDHnGeQ4/oPAA3sRi9KrnDxa1OvTjdcs0K
         8WIIMeGBmyAOZp1SlNhD1Fl+hSZSnhaaCyp57XzbQmpgFCGxwASHAENo4fkT48fFfP6a
         Q9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783042888; x=1783647688;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w7xoVMyf2fxQGzPR8Ogsy0SlEUtXTDX36yswxAlMwHw=;
        b=qqyOqOZScJwKK8eXxE7/igyRTJWWujHqXeh4JtB1FY5HL5z/gnUhcqgRb4/qZ0AHDK
         AyhIIQnDZh2HB03iycReD9hJxF6DuKJ1g+A+qpYmVRJKfTCR04gUZgM2YnRCY8lUWToq
         Z5+mJA0pC/WuKa0hjmQhxCoQyuG+p0ZPx0MHxc4AsAwOcTMIvBi1CmbUrsCqolqrAH6x
         jWDCM407XrIZCOaTxXCYPEhBcLQmtyVPBJ1GmbsXN12A9RQSThPA4c78NCzmA2UQGs1V
         Mo8yRT6Khvp2ovDD72FRA8rZwe1GfNLbIKOiwhX8v3xI2pKF/UknFGWT2ou4/WBO1lBE
         lrZA==
X-Forwarded-Encrypted: i=1; AHgh+Rp9B2oAMiZgOjlueLCle2jGWDYo2zEGjRWM0tDwDjNzGUpKGHO5aRcJ19UsNyn2e5whB/Xq6+OQOjA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg/NAcBrr+ROHSxb1f/reMFhANl+ICrD/fGZxwtWmk0bWX5qLF
	o2BTdLin2DG7QAMYApiE8mTctzbPFS/nfm/EYRhu1FE7M9xRI/2EnYMSlYISuLKspb/3R35jJCx
	EYxCjQGdnyLipRiWMtXZlwTlJFtGzKyw=
X-Gm-Gg: AfdE7cmxKywYDrbtzC6+4Y+g9tqR0JOFvKVR1dNf8DTYnHOzyghYGLxghKM/9kbyGlw
	P6WMdyHCmC7MhZ+lMSN1acUZA6F8s2pQKQQN/YVrZYQYSSEIDaltCMPLbCqdptMoCrEfuXRIsMy
	xlw4aLJQyrhCvO5fsICvoejM1o930USfocZIcucSeUA6hX9Ao88g4VTfrPogD3xFnV5KQSTUPrT
	bVcyWCSaGw96pSnOB2aokCAvFwji9DmKh2cA3TXI2oxNfgN1QFA4QpxhxpN8TvlvokcIXuLR7Ck
	6x5Pw0xr+ldZc3YlFKceRDaI5lHxLnbY/9WCKfoB6AFLG1pOR9pz
X-Received: by 2002:a05:6000:26c3:b0:460:65dc:e9a0 with SMTP id
 ffacd0b85a97d-477b32c1c51mr10901152f8f.8.1783042888437; Thu, 02 Jul 2026
 18:41:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-16-joannelkoong@gmail.com>
In-Reply-To: <20260701000949.1666714-16-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 18:41:15 -0700
X-Gm-Features: AVVi8CcRneq-fIwRap2df2tKD9YQ2vVg4344FfSnO7szL3HDxW5fsSJcnqXc4jo
Message-ID: <CAJnrk1b==c6KYO8a6wKzMxXmEYdzdR3AXBX+ePGagwqG3m0H9Q@mail.gmail.com>
Subject: Re: [PATCH v2 15/18] exfat: convert iomap ops to ->iomap_next()
To: brauner@kernel.org, hch@lst.de
Cc: djwong@kernel.org, willy@infradead.org, hsiangkao@linux.alibaba.com, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 5:12=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Convert fuse iomap_ops to the new ->iomap_next() callback. This uses the

This should be exfat, not fuse. I'll fix this.

Thanks,
Joanne
