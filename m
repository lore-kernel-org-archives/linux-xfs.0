Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DB2146A7D;
	Wed, 14 Aug 2024 22:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723676160; cv=none; b=YBZ6BZ1JkkhrqZauMpsoAPiKzeKskYvjI/4avrf7Kzud1jNJMnmLknjCjwASUVY3nWFVpTBxm526iV5h60VlD/OvvYbWvLrsPhq/rhHz3eiEEgvMWKoeQ2aXR/gUsrDUNHhNlbcMg7mOrnp2CFFt8R3e5sCfnE76lluIYasty4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723676160; c=relaxed/simple;
	bh=0Siz89VcGW8U4QXrejsGirWfD/VSEaA89z+rYwMoA+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FPmvDDZMQOZ3at7jweWTpMHm1Xl/FYV1RBq/m3TRJhKzZEcl1nUBRDFHjY0dyBtlzXATcMly8CxnJ1zWVhocjbr2RCZtxchAUsVGOKlV9aX0lOSCVq11BkLMqPn5J814vuW37hMzWu2qK6fmuztlK5ZtcWmoQxao6ceFhXy9zgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZepPHp1n; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZepPHp1n"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e116e2727dcso309481276.0;
        Wed, 14 Aug 2024 15:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723676158; x=1724280958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Siz89VcGW8U4QXrejsGirWfD/VSEaA89z+rYwMoA+w=;
        b=ZepPHp1n+GJ5DLj3zI4/HojuzpMIm4fTQ01oRn9fE6t/H+avkMJWoLCxkHOUPux5qo
         cJf4lIIZwVagFH6DFc8PhDjqBbfw/guXeYm3G+/qNJC9dnEuLlsmSmnYBYmeKwW0wkym
         2Wnfe2H8Z/CL5UK9NxeOewTwVvOOYVTFpyZumXA9Ams1EIvwTnVCSx8OO9g/qLykc5nw
         2su7qhtZWhbWR3H+q4tfpe/VDdcezGBUSZHfT2XkbZUdjyjx/F/ad4/QGg5rkrcGWFyM
         vZig+5Q1AcJm+re64qRH0fArTFkPzAQgFgO7obqRV5gs32PPaLpQ18eUe5p4yL8ucejX
         J8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723676158; x=1724280958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Siz89VcGW8U4QXrejsGirWfD/VSEaA89z+rYwMoA+w=;
        b=gj0UgbHJImf3F9tuG6nLQxkh00hIL21QFwlT49algIRdlZiSGIdZH7A+2eztoUF/wB
         KU1HFn7F0l3oBBoBgSOF2oVNmhgpjYUg3/vkvjv/cyOv7xBqx3bE/+neRboq6f0Ra170
         xGHhnj/FSZhOrtjNTKtCWYAD8gdXm5cMDZVUo5tMVtZMvBaizx3d3YgYW/RZsakS4ge9
         k7hpf7NLipFSHV9Q+pHhYWUss2x0mcpYTkwrS65HeL61/T4P6SSkeJ+80jxldzDtrEqz
         bFxEP/DH5bJzpVq3BpxKbAYVtSUB0SYBfydxcyfjHs41KcixjAACdwK28oJyncRxqWD0
         3kmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXResFqdTtX+WX3tNe8d2IHceTPhhYxkwpCqvY9DwcZaQN8gQP0UVwzfVdVUi66yzyxwtuqAEvF4WIIjXbRytfEHa7EUl4CTH5yAFX3OcO4NvJZ75VDM5MQHpuA+2cflqYMlka6SrW20lI4aXt54wKbYA99jbpPYkHdgODxJMsb
X-Gm-Message-State: AOJu0YyQtj+p0xg6Rpq9ISfz4geuh+0qvOfHCplHOLEbKwnsMJ+00ZDX
	bgsth0zqmzW/KZ9/1NZNZYZOfsDuSvTPztERirU1UqtJiVHEUSSrEESDjzkdZmdNj9R8lFf5PoW
	YuE4yv9Hib4wt3zyWj7kB6pBIlTc=
X-Google-Smtp-Source: AGHT+IHQ2TqZnJV1mxSjnzpxWCx+nfJNemzi8w1aw5mIOa61nNOnvPe+92b9GLy1tbgEUTyfwE+zYlG3cylwl8Lzk7s=
X-Received: by 2002:a05:6902:2510:b0:e0b:d3a5:9604 with SMTP id
 3f1490d57ef6-e1155ae1dc4mr5245810276.26.1723676158206; Wed, 14 Aug 2024
 15:55:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2024081244-emit-starlit-dd23@gregkh> <20240812195128.1095045-1-jain.abhinav177@gmail.com>
In-Reply-To: <20240812195128.1095045-1-jain.abhinav177@gmail.com>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Wed, 14 Aug 2024 15:55:47 -0700
Message-ID: <CACzhbgQ7Smz21qi+XnQwy-gDecnhYw432oUAgQBJng0go-=kvg@mail.gmail.com>
Subject: Re: [PATCH 6.1.y] xfs: remove WARN when dquot cache insertion fails
To: Abhinav Jain <jain.abhinav177@gmail.com>
Cc: gregkh@linuxfoundation.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org, syzbot+55fb1b7d909494fd520d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Abhinav,

Thanks for your message! Fixing bot noise from WARNs isn't a high
priority for me for patches to backport to stable, but I'm currently
working on a set anyways so I'll throw this patch in. No need to
resend anything.

- Leah

On Mon, Aug 12, 2024 at 12:51=E2=80=AFPM Abhinav Jain <jain.abhinav177@gmai=
l.com> wrote:
>
> On Mon, 12 Aug 2024 16:40:13 +0200, Greg K-H wrote:
> > You lost all of the ownership and original signed-off-by attributes for
> > the commit :(
> >
>
> I will work on this to understand how to avoid such mistake moving forwar=
d.
>
> > Please work with the xfs developers if they wish to see this backported
> > or not, that's up to them.
> >
> > thanks,
> >
> > greg k-h
>
> I am tagging XFS maintainers so that they can confirm the same. If there
> is a go ahead, only then I will submit a v2 retaining the original
> signed-off-by attributes.
>
> Thanks,
> Abhinav
> ---
