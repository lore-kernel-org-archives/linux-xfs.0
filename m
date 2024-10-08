Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFDFDF58
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 00:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728348877; cv=none; b=C6svRTSi9y8TKy20SqJEofQWshnrwdT9hYxIzodphL7dVCd2rXLt5hoVJ88ua24/a5/JUd3YXJHxLMs2UHnj/2KRbtj8pf9UDgwB5ap2V2pZSu9KXbB2kKD7XFrcUFoL4OKkI7Xx2VT7NkThwuQ831RNtAYi+9bKulqPhLMvryI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728348877; c=relaxed/simple;
	bh=NqYO63ftG4Vh81Um6zsjfmC5SEgFzFYHUlSf+opM8ws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FeCiPsyZprb/Hs/OWo/a30AcHaR/GTW9aNp56oH1BwzOfImPcwEpbYwwCK9FhqUGNjfAZ0rHfCxGYUv3FYq8Im01djH7lm2ux546A6WZ0mqDH0Xv/cM2UtbDi8+xwGRMcZ3lwltEUMoBrd5W/9wXF5O6okZ3te0uaUWGY1jOCfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NdaZhrdV; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NdaZhrdV"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5399041167cso7866113e87.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Oct 2024 17:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1728348874; x=1728953674; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tnmN82gruhjoauaDPVFxp6c7gOVhPQGFyw+79HJzqU8=;
        b=NdaZhrdVGnvC+ynbG0T9KCf7DMjktaeRH4d4I6bNUmXk6Ilf1uLQo+62QMJeoeYD/O
         t/anE2EUJPZC+Jg3HfplLd1VxFoiK1cbfEqGiVFasyiWbSZH9caf/Y2rwIbjw0BG4tR8
         e4AvmBDn0+VOW6eArHhZ20eckBBH4xwa3Qdec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728348874; x=1728953674;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tnmN82gruhjoauaDPVFxp6c7gOVhPQGFyw+79HJzqU8=;
        b=hSlg0NfF2PpMcl/xALJx1JIVScR0g//VrDHUlDFDtQyepdMItyRnWPV1LLrakb31hj
         qWMGwhRqXHmxEazaJKsEJPxQg+5QuPZJ8DpoS6BHnmLw/ucHVsNLe3UdYNgMlum2137M
         fHla2vyr68eSDPphCFy6M5wh9Ydd5cd3iIDM5Kbo06Ha2wO+KKO8MvAg8ehcoGGrzxz4
         /5Y6lGXDmzZFkdjqI1Rbg/fdgvx2zFFmhYUQl+QjmwoTA4zK4nYRfHwd4kxXQxjwmwtl
         78jio7V3aYAbsLQvvVn6EnF6awbohndasMkb+UoyDiWn67lNem1SE1Q7xORLsbJ1uqmv
         3jsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUQ7dwQlaFpmHjwTn7JzNFwfKzx8KxFn9/j3QTgjZEhTRbJOwyd6vMmWr5BiJgYrOGsDn3dYufG34=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz+6Qx0qdO3VS2eKunLII7mpiY3mdzq56GaQafcurPA17iT0Yb
	3dHYyrVbP8dT9XwvDpEDxSFez2aUjshQvdqVqV/4au7LmCQiZvdXcqXvbC55E56KhhG38CnMjTC
	RjCiNng==
X-Google-Smtp-Source: AGHT+IFPaHSPn3dCeFNmIv4V9QKpj55OWiEGa7Xnr6bLGOKoGtuVtBYh+WmdQp0iegzaOrhTY4KoXw==
X-Received: by 2002:a05:6512:3da2:b0:539:94f5:bf with SMTP id 2adb3069b0e04-539ab9e8706mr9543048e87.59.1728348873625;
        Mon, 07 Oct 2024 17:54:33 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-539afec1592sm1000267e87.34.2024.10.07.17.54.32
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 17:54:32 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5399041167cso7866088e87.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Oct 2024 17:54:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUl6xr8GOVwbozED57/hj6OScxfsBQHOkduK7RArK2dY0QVc6XNBc4uTpLOklGvQXFxZErY/3REi/g=@vger.kernel.org
X-Received: by 2002:a05:6512:3d07:b0:52e:fa5f:b6a7 with SMTP id
 2adb3069b0e04-539ab8659c5mr8118408e87.13.1728348872429; Mon, 07 Oct 2024
 17:54:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241002014017.3801899-1-david@fromorbit.com> <20241002014017.3801899-5-david@fromorbit.com>
 <Zv5GfY1WS_aaczZM@infradead.org> <Zv5J3VTGqdjUAu1J@infradead.org>
 <20241003115721.kg2caqgj2xxinnth@quack3> <CAHk-=whg7HXYPV4wNO90j22VLKz4RJ2miCe=s0C8ZRc0RKv9Og@mail.gmail.com>
 <ZwRvshM65rxXTwxd@dread.disaster.area> <CAHk-=wi5ZpW73nLn5h46Jxcng6wn_bCUxj6JjxyyEMAGzF5KZg@mail.gmail.com>
In-Reply-To: <CAHk-=wi5ZpW73nLn5h46Jxcng6wn_bCUxj6JjxyyEMAGzF5KZg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Oct 2024 17:54:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgW0RspdggU630JYUe5CyzNi5MHT4UEfx2+yZKoeezawg@mail.gmail.com>
Message-ID: <CAHk-=wgW0RspdggU630JYUe5CyzNi5MHT4UEfx2+yZKoeezawg@mail.gmail.com>
Subject: Re: lsm sb_delete hook, was Re: [PATCH 4/7] vfs: Convert sb->s_inodes
 iteration to super_iter_inodes()
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	kent.overstreet@linux.dev, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>, 
	Jann Horn <jannh@google.com>, Serge Hallyn <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, 
	linux-security-module@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Oct 2024 at 17:28, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And yes, this changes the timing on when fsnotify events happen, but
> what I'm actually hoping for is that Jan will agree that it doesn't
> actually matter semantically.

.. and yes, I realize it might actually matter. fsnotify does do
'ihold()' to hold an inode ref, and with this that would actually be
more or less pointless, because the mark would be removed _despite_
such a ref.

So maybe it's not an option to do what I suggested. I don't know the
users well enough.

         Linus
