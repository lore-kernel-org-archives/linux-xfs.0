Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49202EB5D4
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 08:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763973841; cv=none; b=FTe9y6cXu5/rr5J7MU54G39Hxjbx4GsJcSvQXnT6jC4S6XvKBxLWXTbjRIZMNerX0yWRuNNBavqMsMyB5ILj19G57CPUjPoKkJaQdwNrRUxpE3lelLFLUYJgJN/IT8xhlVftsyNgwQhH7mLp3sDdWEA3l2qOJBThlSQrWgBUm50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763973841; c=relaxed/simple;
	bh=nT/LnUqPQZLgDkoi1Mvr92Mr1LfrzfdIhCgiLi2qokE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VqlCMrhBngSZYHNBU25Evp7IahJ22hXIdX2cz8w+5bSQLWBTLzBXWiKTw0FB98xG8e/MaWI//88/T5uWL8IpVJIativqk7w2bhB/tb1S6+sBu1BHDwgCRVRRE8mvuD9KCMDXAiwxJ1rQa2BgzYtFSS+SQ6pIicS7xg8g6r8hf+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lupTjO3p; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lupTjO3p"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7c75a5cb752so2341253a34.2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 00:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763973839; x=1764578639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nT/LnUqPQZLgDkoi1Mvr92Mr1LfrzfdIhCgiLi2qokE=;
        b=lupTjO3pMWDIf0AY5maLH9hyLcDCL+oV4dhfKL86Euz1d3jpt1wHaVTIPUJxGXSnyv
         v3PPpngy5wBe08PILcy4fAPx2nDLc3kRPbKVR/ZUZdrLaGgVbScJjLDdVaSrg9ehKfk1
         6jZPZz4NCZU8Kx9JHU7NlFnzfSJWUnmHemtdnzNXcZzEs/KU7QECeLocdQ6h9baPPNfi
         RSD+p53+cDynAM+/AjhBDNxcVH+2Y3fZoRd3Ar+fjrUn4oxrmTJlNGbV8usAqAJrm5u5
         Z33m23JOBELa8Uy0H3VHVfyml8wMJKeBoMGUJmWrM1nITsHOEfwtmMLqsbxmQersnTU3
         Y4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763973839; x=1764578639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nT/LnUqPQZLgDkoi1Mvr92Mr1LfrzfdIhCgiLi2qokE=;
        b=A5mHwFrtD6R4SiIiz4FmM6M2BszI1RbMhhndrw6N4Vlrqp/FJQXcHQfoD26qfhxhV4
         Mtiiu6GDQ5qGxEwE3Nf1tCF0i4XFPu+3lVp0DgR/tXJb7C4bTKNY+gqBuXpWcAoHTLg7
         8XA3ke9NqzG3ATjHW5LuuwgWlIesFCA9l3WOjyCMNQY9MQZNTQaCXyHXgoHScLeYpEl8
         hJwp4GE5N7Hxpl32IeJD4n6D9FviBZQw5eD9PAZ8YaaGWmU/2f95cu7Oq8VHi7z5ZQFe
         rn2tJlKiPiaA54PzD/W3aapgMrUBBkIqVZlpsTwu2ZwW1Bgcq9tlrTAR3Pi8g7QSO2Xc
         IYSw==
X-Forwarded-Encrypted: i=1; AJvYcCWEd4bdWCLXZFgFS79ukLfhHGxljrlzZTsBWJH87rGCMLMSlGsGdKZ7TLB3GWQ4f4SfvVlvFLc05pQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsZyyj4h0cYcwUGJf46RlsjJWQiukps9Wh3QQ3JGdul28/Kqfv
	99ZI1wWADOw4ldgBLQMkQVlAiWnaJGluuIhMwj3tH8qVEeE3ZUTdeS/57Fvib4Mq2pRQHrnmSoE
	D0RCEDCSv9OPJZwbJ3pR5t2mSY0Mky+XnmdwNHR28
X-Gm-Gg: ASbGnctJNjBs6rwaGHPgAzVeyJnVPtPLCtHP6CjaIfe+5LCds5YfY8XgYoABQRYs/3V
	GnZ4M26ZUM1KilRF+zZdYxKPjdz9+CULLb0C458xdfOmLOkRjzSgRwdTcTIgfigJbZjuCVPD1tj
	72wEEs4KoSt37AI/J3zZSfehMpaBrSLyEX62ebzJTcl4mdqhQm/E2W691FlXX/XXjIhnLTtOiRT
	P6D9lxdcIg+Y2OSwrevkUfnzQ5sMiBg+jiXIcf5CcjVMR0nN2FUuOWSolF4To3MumywyGoHjt2a
	Du6aHf2qW/Qb1BIQkor23xB+hAjIS9S8dghD732ox/8i1INn9oQbM/CwNA==
X-Google-Smtp-Source: AGHT+IHRRjZRGEzaAf6Eb3jUeVUi3aRCEzz5d/QZ4xaIN4wVaQR1ViZ9Sw+qtRGMDmrq1KoAdA8ULAjs6VeCCqVgQ1s=
X-Received: by 2002:a05:6830:3494:b0:7c7:261:6745 with SMTP id
 46e09a7af769-7c798b8a7d0mr7045992a34.8.1763973838832; Mon, 24 Nov 2025
 00:43:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <692296c8.a70a0220.d98e3.0060.GAE@google.com> <aSQE_Q6DTMIziqYV@infradead.org>
In-Reply-To: <aSQE_Q6DTMIziqYV@infradead.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 24 Nov 2025 09:43:47 +0100
X-Gm-Features: AWmQ_bnJSLSG2zunLoVqYU_cGYRuDxxOD8v3Yt1AnTHAbW6cp95IEQTp4ywIhZI
Message-ID: <CANp29Y700kguy+8=9t7zG2NWZDYtgxfqkUqsRmE+C6_hFdh73g@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] WARNING: kmalloc bug in xfs_buf_alloc
To: Christoph Hellwig <hch@infradead.org>
Cc: syzbot <syzbot+3735a85c5c610415e2b6@syzkaller.appspotmail.com>, cem@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 8:10=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> This got fixed in vmalloc by adding GFP_NOLOCKDEP to the allow vmalloc
> flags.
>
> Is syzbot now also running on linux-next?
>

Linux-next has been one of the targets for a very long time already.
