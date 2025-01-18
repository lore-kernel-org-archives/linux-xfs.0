Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD321E531
	for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2025 23:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737244299; cv=none; b=JzDjrR1iWBL54vlMjK3TuyFFkpEpm5lTtpLohZGcEWEusGIAkkCxbgGvqHhTan5jfzCKwG4lk9YeQZ+GRVb3mHfIvPnhYhb80s8yEO276c9FiDo5BzjQRbt3nopOhjlukQQ/gmW04fByQVE98ZQLWduzVwsPfroEywhx1WQPu2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737244299; c=relaxed/simple;
	bh=soxmDpfsPRHjfp1Jyg8H4xyhMjTUxeXfJE8FbhFGqRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mrMcelba6MIUeWBidqz6K3LU4RlAl84I7X+fggXJ+/0Y1+oQudBN4FNRyCebJ4xdJKBQHNMk1Ranw/lAnTq/sl5zGPvx2d2zfM8FeSdge5GYzWn+iMW7Kl/ie7prk0s2zkoa0L+OYBhRSwinbOwXm3MzOIGkz+VUxsVO/qdGsfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Psu0+HJ4; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Psu0+HJ4"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5161d5b8650so932137e0c.3
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2025 15:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737244296; x=1737849096; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=soxmDpfsPRHjfp1Jyg8H4xyhMjTUxeXfJE8FbhFGqRo=;
        b=Psu0+HJ4bxImEIuvckzahJEJnXMHB76ZJNyw00inJRmKqOHjEaBn/5x6S1le2A3/pQ
         OZEsBFf55NCKpb9GBQx0+o5QevYYI8rGDeWLoy5xPgnyHSe+UMDwN85rJbE23ogfeMmF
         vCObSk6L+7/UsFfdfAFEQhwvKIumJUde8ETdspRB4SwPmpm+jvd3cYYK48L7ju9D5HY0
         5rcU5IWuX+bzE+OiUiUlRk5kNr3h2fKLW1jcZa0X3Mh2+mwP04gaXafjW4S6H3dnj3le
         R3yfkpY+6x+d7ExGN2+aKS9w1DOglL/7KpqLbk6kqoKTlfElNoC5Gv+YGZ+PIXhrpgWh
         nOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737244296; x=1737849096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=soxmDpfsPRHjfp1Jyg8H4xyhMjTUxeXfJE8FbhFGqRo=;
        b=Bd0JDBZ1+VNltyi2xcjsaXF79iT26oDR2XcxXt3R1ya+dxy3h/5a6gqp2OjwTmScE+
         noH5R5auii0A3FY3AgUw5gftobkpSCyegnSSiNGZMkoS1z0mxmIkVvLbVOF1dFCP0B6T
         pZH0PI2EA8YaAK6K8krnR8yeiCrrN/YlOHHbE/oBCE+vjXm+ZPWwUNB0+FgC4ru0hUJK
         VS7vq/BPeEbXicwS0FjCyX3w0Uuc4IJokJWI+mXpXystPds11uR6rMM9qfnyZxnqWkWc
         KVuyCj13QthXDvln2YjT32zFmWBI4PbJep7YoXUxLyoS/AUTj1Zq0zi3GA3S+lCSj7x5
         waiA==
X-Gm-Message-State: AOJu0YxneLdMd8U/5noTLclMjCdeBZ1peCKFjJZT7dRELLIc+JaTXY+0
	wp8b2DjrIeNAOOxwuUTJkaUIHZipaO+625OHm+1BJvS/Exz7mWZNuU+7yNgIdfxZCGC/xs81lfI
	vSalcejbqBnxq5ptR4Y+p2xZ0lJI=
X-Gm-Gg: ASbGnct2jMpYGfJHYg4ZzIeebSSAliGQxMwacxJzlB10a1+AQzccR/KdEcwKnvlLR6h
	6CubHwg2gBvOaaWmfiGaI8XNzfYXhkiTJWnxJa7vkTni4NQlt7Q==
X-Google-Smtp-Source: AGHT+IGwHznCWPCMEtKzz1qYgJaLAWBAMHAuQBOOHG7z9p33G2GNsuh4gWJMyoBHj0Fo6hK1zzGKEu5a0Hx0ei27G0g=
X-Received: by 2002:a67:e70d:0:b0:4b2:cc94:187a with SMTP id
 ada2fe7eead31-4b690bb130fmr6898268137.1.1737244296437; Sat, 18 Jan 2025
 15:51:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <bug-219504-201763@https.bugzilla.kernel.org/> <bug-219504-201763-n9qDuhTcDb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219504-201763-n9qDuhTcDb@https.bugzilla.kernel.org/>
From: Marco Nelissen <marco.nelissen@gmail.com>
Date: Sat, 18 Jan 2025 15:51:25 -0800
X-Gm-Features: AbW1kvZ4m7mLf0cmDdWA2MC-4xSU-c9DlGIT7jXHRZtxhS8w5xIbC-E4XNGc_9g
Message-ID: <CAH2+hP5mkAR4LXfMRONd0KfMq4yWRHS2CRoAZtGnmqVhJ2dKdg@mail.gmail.com>
Subject: Re: [Bug 219504] iomap/buffered-io/XFS crashes with kernel Version >
 6.1.91. Perhaps Changes in kernel 6.1.92 (and up) for XFS/iomap causing the problems?
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 18, 2025 at 6:00=E2=80=AFAM <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219504
>
> --- Comment #6 from Mike-SPC (speedcracker@hotmail.com) ---
> I am experiencing the same issue on a 32-bit system when using Kernel ver=
sion
> 6.1.92 and above.
>
> As a non-programmer, I find this problem challenging to address independe=
ntly.
>
> It would be greatly appreciated if a fix could be provided in the form of=
 a
> patch. Could the maintainers consider releasing one?

There are patches for 2 separate 32-bit issues, both of which are in linux-=
next,
though only one of them appears to have been selected for 6.1, 6.6 and 6.12=
.
These patches are:
https://lore.kernel.org/linux-xfs/20250102190540.1356838-1-marco.nelissen@g=
mail.com/
https://lore.kernel.org/linux-xfs/20250109041253.2494374-1-marco.nelissen@g=
mail.com/
