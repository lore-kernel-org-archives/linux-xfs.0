Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF8E27F00A
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 09:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756201580; cv=none; b=R/SdKX3SNtokI+PY0BUSv0qi/6ebW8JluxYNuTNNC1SU0gvLxshSjzowLCkcDH6YWHSoEBf3GEciIbB7QHEHCipQpAaTPY7Wpb4OyN8rT4SEgDQ8Wuk13YWy27JG637Sb9mNre2fUHzFCJ5zLUqd0WbLrIyS6QQtcZwbIk6iHMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756201580; c=relaxed/simple;
	bh=OPAZZxNYE58hJae/e/m2Tf7VPpzwodHhO2tzCOR73hA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c+5Rdkem1qoNyK5bAwJix8VaNBp3pzFsPlVEsNx4JxmjZ522xgzlS7YEvOaQB56STq3m8Shl9dfsxiZjH9RkB+pA81ZUE+vffDeaDght0ac7p7RT5wsvR4hmKkn3dQyXApKhlLYu8VD7W+p+hREvgE4ylH1Dpwk9/FlGwEt95JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=POHt1stG; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="POHt1stG"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-435de818a74so3045982b6e.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 02:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756201577; x=1756806377; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGNJFCgl4cuzHPkyc+Ken0/krtCf4Ypf9u2DKlmbJSI=;
        b=POHt1stGUpr2mPxf57ewGczQRQR5qIsikpfCJZv9JSeBu2TCuJRoFmC6aY50IY7hDw
         VeT3BXLjvsRGKbMfNTvD9uVYz7WR70YarJoSM/PX/1eHHmtR3VkHpkcGtWP44z8yXB/G
         ONw/+Z/vWxZrtSTt/Y0KpUx7LTe8PCbZJwzsa0EhHHHtXRPRHUniGpjfHtMi1d/k9XIM
         AA8B/SRxjP+VkSJ8tuDrk22AeR2BMxtB1dYnsipo8TmP+A+F+izpMY+il6CFkAkXrgcS
         134WZwQGfMHz/KK286ZNUmbdlnyvgzKKPjS4ju+1r8ATk6LZEYFdkn54f86mE4NFWJIa
         zwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756201577; x=1756806377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sGNJFCgl4cuzHPkyc+Ken0/krtCf4Ypf9u2DKlmbJSI=;
        b=edA+K9eLcwYYYH2pM2mbrIMCckD6hTYMqLN8uajv8LkZ+pZY02AVK1BW0bjh5rwHfK
         dyBzFRCyLNPMUpjsGWZ+g5n9ksht9lN1UxXUiN8+fjQwAEHmpId8T2oxHng1jh6Hr7Xt
         radXY42es80FK8uM1ZL0ZACktSur5oFQ6ohOc37bQrzisCfH6Y3J6UZuet3uk/j0OgWZ
         fsDFl4HBCf+SuY7uyiKfe001N0YcGvbojvtCY2iEN3lNbZ0p2jx7b+nMJVuKBi8SQs7l
         e39ZnInkeNvj6kpA8UgY++50V2dpT+F9ljMYdjlvRsGlekv4kVh3NOGMOM3h2eWciPO0
         zRcA==
X-Forwarded-Encrypted: i=1; AJvYcCV5csQZtizyc5GN1bemsV5TlCtoj8Ij0s4O2XY+78mKLiGxV28CDL5uKE+TIMnz6yhJzSyqoDSY828=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFORPsN+dxX8WsH9YeFUpi86r5jPi/B9aC+FjsywYncMW7flNt
	UGfYqhmDro/lY56irF8Ew1B125GL0NGkBY/tejaOdTJLQ2I6/y2V/Dpq2ZPJjFTJ+BAAkxByqfL
	UcKy6d5aUvqSD3MmbE5IcRGr4BVlT6Q/G+uYtkfL+Lw==
X-Gm-Gg: ASbGncutlg9Tf87p/yltQoNWJCJ6tp3f0gP8oyPG6Bkjsl5TRxPCCXsdqNABKGO7Msv
	EVdFkLNNAlBEHLV91tWqm/SjsrvAeAmkSXFQBEGVCYTHHbNFPSh8B541Ex+GcKr5gxUN8ELUp25
	BsB2wnTedYXs+FGCCd18YAK9TvaKhT0AXrNTfbUfD7Sc2oABGdJOTWjZS8OdmIkJ8eq01xdXZEV
	52an237jgqQ
X-Google-Smtp-Source: AGHT+IF5+Gw96sL9RY4NRRpY4/PqOPO6y5oEcC2tJqWM/kg3CPBQzUej8mAwKMn7/3T/5r3lecdpgQOOx/9Rqy2e5Ik=
X-Received: by 2002:a05:6808:f16:b0:434:2d4:f198 with SMTP id
 5614622812f47-4378524c0fcmr7225038b6e.31.1756201577356; Tue, 26 Aug 2025
 02:46:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822082606.66375-1-changfengnan@bytedance.com>
 <20250822150550.GP7942@frogsfrogsfrogs> <aKiP966iRv5gEBwm@casper.infradead.org>
 <877byv9w6z.fsf@gmail.com> <aKif_644529sRXhN@casper.infradead.org>
 <874ityad1d.fsf@gmail.com> <CAPFOzZufTPCT_56-7LCc6oGHYiaPixix30yFNEsiFfN1s9ySMQ@mail.gmail.com>
 <aKwq_QoiEvtK89vY@infradead.org> <CAPFOzZvBvHWHUwNLnH+Ss90OMdu91oZsSD0D7_ncjVh0pF29rQ@mail.gmail.com>
 <aKw_XSEEFVG4n79_@infradead.org>
In-Reply-To: <aKw_XSEEFVG4n79_@infradead.org>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Tue, 26 Aug 2025 17:46:03 +0800
X-Gm-Features: Ac12FXwhbCfrLvQfnya8JqMdT-q61XbBqqnKzdiMRp9wFxXNvgUveywUyXpPL3E
Message-ID: <CAPFOzZuH=Mb2D_sNTZrnbcx0SYKcQOqMydk373_eTLc19-H+cQ@mail.gmail.com>
Subject: Re: [PATCH] iomap: allow iomap using the per-cpu bio cache
To: Christoph Hellwig <hch@infradead.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, brauner@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B48=E6=9C=8825=E6=
=97=A5=E5=91=A8=E4=B8=80 18:48=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Aug 25, 2025 at 05:41:57PM +0800, Fengnan Chang wrote:
> > I'm test random direct read performance on  io_uring+ext4, and try
> > compare to io_uring+ raw blkdev,  io_uring+ext4 is quite poor, I'm try =
to
> > improve this, I found ext4 is quite different with blkdev when run
> > bio_alloc_bioset. It's beacuse blkdev ext4  use percpu bio cache, but e=
xt4
> > path not. So I make this modify.
> > My test command is:
> > /fio/t/io_uring -p0 -d128 -b4096 -s1 -c1 -F1 -B1 -R1 -X1 -n1 -P1 -t0
> > /data01/testfile
> > Without this patch:
> > BW is 1950MB
> > with this patch
> > BW is 2001MB.
>
> Interesting.  This is why the not yet merged ext4 iomap patches I guess?
> Do you see similar numbers with XFS?
Yes, similar numbers with XFS.

>
> >
