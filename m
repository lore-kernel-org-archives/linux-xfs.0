Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AEDBA3D
	for <linux-xfs@vger.kernel.org>; Sun,  2 Feb 2025 00:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738457929; cv=none; b=YfJCwzHE01ThvkFlp96bUM7yF7CdEFGZ/4AwbmHSKzd2+sgJ6EtqSefnz3mRgDZsJ49TMn9JcA1wTHfe+eJfQjiZ1bK1F/zhcOuXi8XQ6ab7N3hiJJMSSvoEoGS4nlRCjgO07OV8gAdZWdAfRNAIh2WJ9p2i+y8xL65/7XpXgrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738457929; c=relaxed/simple;
	bh=wTdxQSHNowLLmMobvaMcMprIsVZ+/hyqVnL+ii8pks8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HjI7xRe7UAJEVtMT9DVf6dQyHfvpDgwMdrJxkTc3S3Dsf9gVK6l3NOQ32UddTPRy0oXAT/J9ybsxSoe1MoT4r5jSWqtmfZUEnBx/onJNOmPUtraEhIL/yTMLEaPNKGPXKH9237bpc+UgXoSsUTtwGer4C39NRNObWz2+os5smHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H4YWNiKu; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H4YWNiKu"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab2aea81cd8so576699466b.2
        for <linux-xfs@vger.kernel.org>; Sat, 01 Feb 2025 16:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1738457925; x=1739062725; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0i2RBA9AG5RGJ2Y4fhUq4YhT8DGp5O3OFexnsh+308w=;
        b=H4YWNiKuJxm7svy3nGYkMeVz4s6fiiRqKR9K6yesIcZ8SCOeHWSIpWS7qZTeTjQ0/q
         e49p3+AVTZkDA7yy3/Ezviqv1XRWr7GUHH3BeCQ+iNfzl6NcgrDJ/mogP8OCfk0+3nFf
         xhJ2ve+ua06Mk3vSASa4cDdNAi3rvKeXcN79U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738457925; x=1739062725;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0i2RBA9AG5RGJ2Y4fhUq4YhT8DGp5O3OFexnsh+308w=;
        b=Jv4gQlImidoSU8fPFTUuW8kHXgu8tiOmYiWobBcz+nsDrTKduv+9nfSY5G9OIoAIIl
         06hwr2nG+LuDrAm91Yzbnh0TF4SpVkqnPzJLsJHmR1ixf69jKjvobioa5fx4ASM7ZHsv
         VkXRQGUIhhvJRsOSTbm5xw1fsUAxmJzJXg9ScjrOWeGYLuc4OUhI8rF55nNZOplI86oz
         qn3f3ck7eGFwYVf4JlDpij6+e+CSPKp/o7vMRYc+4KKCTHiJahZk7dt6yXjyuE52KInC
         aw+exTwGPoPX2ARXji3SvRewfF6f5FKWvsLOdNqUn4yrjQ/Zc9GPMvTQTLF2LnZ4n+rX
         WSug==
X-Forwarded-Encrypted: i=1; AJvYcCVqKjU6LHlFABuGs4Qn6WqzE91VG9oItYTUUDafXfdp+fjJapc8BDuqqvpl2NL73j6VQrNphue8K00=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRk10soPCJ1w+nW0lV9dzo+KvepgtsQkORxaTezdetoQ5FY2dk
	/GLuHZgSjDB6o3ZSBHBNQiEnVKVE1IsuSf+6eQQzSP3Oq0jLvpz0TOva0gAWsH6wP64KgbT6jwR
	2pd+AkQ==
X-Gm-Gg: ASbGncsUsrtCyewCNqvdjyEhRJTq3XxCprxygjUqCNOU4oDYzCnYwRfD06rqCseiC4m
	SJy17w5Wbd6VPyjnWhjNuycV5prsx3MojD5QchosfkPpgENzo9wRKZ9pBgAaPNzG6rSCxtoKQGt
	JbUKKXltAVOJNFLS0ObEnjWsq3un2jt8MBo/TcBXD8sdRST9c3W42CPK1mliXypOPqjIlECR8jj
	mf3BOwjFh047qytbq5Yg0JF6HE13wvozcq22bXzi5ututtMxGiCnXoHob59geIc4gU1UX7R6G0x
	x1iWmwysVGwtDzE3ZBXLYPVnu8cDJBcaUxf0fypJpy2Gb5VC3rJkGheodxdCeEXCTg==
X-Google-Smtp-Source: AGHT+IFaxOQQVqxvH6iHErLov7tGrTKoeP/NeD1lPexxgLzHDObPCcshb8sg2OLlKn/BXxKkRjTLZA==
X-Received: by 2002:a17:907:72ca:b0:ab6:cdb1:cc6f with SMTP id a640c23a62f3a-ab6cfcc6ef7mr1795149766b.2.1738457925131;
        Sat, 01 Feb 2025 16:58:45 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47f1dcasm503350066b.79.2025.02.01.16.58.43
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 16:58:44 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d3cf094768so5867293a12.0
        for <linux-xfs@vger.kernel.org>; Sat, 01 Feb 2025 16:58:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX7ft587Ay/lS+p3nZeKN/6ni8Qe7SLSi0qvJl6AqY3QL5suDiCiM7xMIEw/48y7RIpsdav/gET/Z0=@vger.kernel.org
X-Received: by 2002:a05:6402:50ca:b0:5d9:a55:42ef with SMTP id
 4fb4d7f45d1cf-5dc5efc4586mr20023222a12.17.1738457922880; Sat, 01 Feb 2025
 16:58:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731684329.git.josef@toxicpanda.com> <9035b82cff08a3801cef3d06bbf2778b2e5a4dba.1731684329.git.josef@toxicpanda.com>
 <20250131121703.1e4d00a7.alex.williamson@redhat.com> <CAHk-=wjMPZ7htPTzxtF52-ZPShfFOQ4R-pHVxLO+pfOW5avC4Q@mail.gmail.com>
 <Z512mt1hmX5Jg7iH@x1.local> <20250201-legehennen-klopfen-2ab140dc0422@brauner>
In-Reply-To: <20250201-legehennen-klopfen-2ab140dc0422@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Feb 2025 16:58:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi2pThSVY=zhO=ZKxViBj5QCRX-=AS2+rVknQgJnHXDFg@mail.gmail.com>
X-Gm-Features: AWEUYZkrc1rbpsukghJrnBMXjfiiupnnm33djYsyEN114ENNjNC4tG_tthCj53k
Message-ID: <CAHk-=wi2pThSVY=zhO=ZKxViBj5QCRX-=AS2+rVknQgJnHXDFg@mail.gmail.com>
Subject: Re: [REGRESSION] Re: [PATCH v8 15/19] mm: don't allow huge faults for
 files with pre content watches
To: Christian Brauner <brauner@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, amir73il@gmail.com, viro@zeniv.linux.org.uk, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-ext4@vger.kernel.org, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 1 Feb 2025 at 06:38, Christian Brauner <brauner@kernel.org> wrote:
>
> Ok, but those "device fds" aren't really device fds in the sense that
> they are character fds. They are regular files afaict from:
>
> vfio_device_open_file(struct vfio_device *device)
>
> (Well, it's actually worse as anon_inode_getfile() files don't have any
> mode at all but that's beside the point.)?
>
> In any case, I think you're right that such files would (accidently?)
> qualify for content watches afaict. So at least that should probably get
> FMODE_NONOTIFY.

Hmm. Can we just make all anon_inodes do that? I don't think you can
sanely have pre-content watches on anon-inodes, since you can't really
have access to them to _set_ the content watch from outside anyway..

In fact, maybe do it in alloc_file_pseudo()?

Amir / Josef?

              Linus
