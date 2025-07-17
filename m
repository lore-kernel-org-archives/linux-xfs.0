Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290DF1F95C;
	Thu, 17 Jul 2025 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752773802; cv=none; b=idNuiHP6OZt4CkbawgxqtQk/ifPC6fN2bHnuQRrYHU3SQcUDFdmJntMcukMN1fAlwwL5hufKR3PwzCrjDmFRAozyUZKv2tLG2pwk6eifhLII1kASQFuTYS0Wyi0c1d74W0wdJalUEX7zv4jGEWi5NYDZbef2Gj1CFaCQ8LsL0kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752773802; c=relaxed/simple;
	bh=cB6DQZZHGeGf9lhOToyZC9Jks80AC8cDhzlt0qfdW5g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tgx/fD64n87C5WWaqLgT9q9zwmHNnvjfbIQHtECLCEzPYZaeQVmDoS0BwdRXX9ZPYbPn9vtNmhOCmKBrKjle1LgfzjiKW8JhCBzOkF/Boct3kMTH5fUgdvSMKPnCDrjTY+A6h5m17/i1fsE4RTHUpjcpUgW9eFZKMU9ieJKUgAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QtBFdYPP; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtBFdYPP"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-615a256240bso548547eaf.3;
        Thu, 17 Jul 2025 10:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752773800; x=1753378600; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWnTwg7QjqvfjwMKttxZ6TeT8zZsjInkESBYkju/BoY=;
        b=QtBFdYPPhqTXHhlt6rjn/12uMaZxfXAq0Rm5bqcjOFzDNh2dYvwh5gIBt1XUIf8L4+
         LaHlPCLlKSiosq0i2Q8VN7hDKiVE4Jb7pFgiUWzjep/OiIf/8Szkg8wUeczi8XyOARFE
         EZO271JaaSHek9DTli5rAJj4lfA447H4aUpLOSpkfSPzpu1uALBcJ7DcGkeabf3a7FFj
         aCXwbncwGX5DJ9XKF3WExsSbxZyJEDsccaONA2qSvWkYhNcqB5wMtX/ABZu5L9E3u5v0
         Wu+OMMlAMFIqvF+URU1QLuwCLoGd91sNlG4ktR35xlzH8RecoRbLC0WZjii3s73pQkeh
         hncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752773800; x=1753378600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pWnTwg7QjqvfjwMKttxZ6TeT8zZsjInkESBYkju/BoY=;
        b=DLpZ9ddMmbIOI9/CY6Bk5mNTc3SllcHGUsexy+zME/HoJR5zNHDAypFeN3LzB7ucgH
         +iEZlbdmJniz9y++MOimANQqzqYbIkS+qDS1wzwdv/h+z4vbzBboJfimCNycoPHVeocC
         x1/mKf9lJiBIALv0sMJ+0yY72RKSrC3DIwUSN1v1LgavVQcTUp1zh5uSQR5zT4hn06r0
         O4x7IcTU/gpFrhr6eojb4ADFc7j7fidb55kIuDpKaDOT7VYkPLrv/QZv8j8ZNtFUaQEu
         cqa6Sc6gVypOH5eKOtAkdapF4//2COmuR/3X0hS9yXD48TCHVEHDB4Owstz0Anjdlf6B
         hSOg==
X-Forwarded-Encrypted: i=1; AJvYcCV+rIgj/3q2nEgYaipWRTp514V+ljdwqI5zOgu/Wauf4SwrgZ3sFaSHhWpvV/1Fs64PSRg+3sEjfsGy@vger.kernel.org, AJvYcCXDanunnmcF9NUnqeRRWGzeshRfQVvgS/Sxgd2Ntd9kUDTGoXwAy3BtbwZlnTSw4dhPSuGjj2R/xOQp0oc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu7nCWC3y8Os+mxZDZtM+qwX/c2fz36W5fjPf16UxJh3Jf1UqV
	v2Gehacobn3zOEzjITCQCcx8SouabF6Wrh1OvFtJtQsGZpXdJswyJOeVCWAtkNAcTdEm7H4/sKa
	yseBV9BwU/uAwUh0Bt6x8TQAou9jrZDU=
X-Gm-Gg: ASbGnctb7MNCSKq+xr6vM0vZDn6/ojharU3QEeRKff9LwtXTU+Zs3kd3AbVpbUQMvsU
	00ce6dRru1IUNM5v7rZxBAwSZcn70ShZhd89/sJ9uDUVWGhRav216wsp4/Tu3+HtgT2iTDs55WZ
	GBF1FQxEoUddxp5rYIPdu423+gdRUGky9K4q6sufXxkxc/Th/kcA5OB/mpKEJQ/qh8odJRzm1lk
	yn13BwfASVTGpNf/Rg=
X-Google-Smtp-Source: AGHT+IHrb3+kGA/Pf4+/HuAwQiwxkAKO5ok2v8Yqtp10nkrGuuIA/Mbn0z5PrudGEVL+q9uWRjlr6OOW/MUOkxDA85g=
X-Received: by 2002:a05:6820:f04:b0:611:a81d:bdf1 with SMTP id
 006d021491bc7-615ad9d97c1mr2878741eaf.6.1752773800093; Thu, 17 Jul 2025
 10:36:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716182220.203631-1-marcelomoreira1905@gmail.com> <20250717163916.GR2672049@frogsfrogsfrogs>
In-Reply-To: <20250717163916.GR2672049@frogsfrogsfrogs>
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
Date: Thu, 17 Jul 2025 14:36:28 -0300
X-Gm-Features: Ac12FXw5w1_9i4hyD-LbPxtSt7tFawOjHh2b0UFI2vkNqVhxdpsfk6PFyygcq64
Message-ID: <CAPZ3m_jXwp1FfsvtR2s3nwATT3fER=Mc6qj+GzKuUhY5tjQFNQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: Replace strncpy with strscpy
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em qui., 17 de jul. de 2025 =C3=A0s 13:39, Darrick J. Wong
<djwong@kernel.org> escreveu:
>
> On Wed, Jul 16, 2025 at 03:20:37PM -0300, Marcelo Moreira wrote:
> > The `strncpy` function is deprecated for NUL-terminated strings as
> > explained in the "strncpy() on NUL-terminated strings" section of
> > Documentation/process/deprecated.rst.
> >
> > In `xrep_symlink_salvage_inline()`, the `target_buf` (which is `sc->buf=
`)
> > is intended to hold a NUL-terminated symlink path. The original code
> > used `strncpy(target_buf, ifp->if_data, nr)`, where `nr` is the maximum
> > number of bytes to copy. This approach is problematic because `strncpy(=
)`
> > does not guarantee NUL-termination if the source string is truncated
> > exactly at `nr` bytes, which can lead to out-of-bounds read issues
> > if the buffer is later treated as a NUL-terminated string.
> > Evidence from `fs/xfs/scrub/symlink.c` (e.g., `strnlen(sc->buf,
> > XFS_SYMLINK_MAXLEN)`) confirms that `sc->buf` is indeed expected to be
> > NUL-terminated. Furthermore, `sc->buf` is allocated with
> > `kvzalloc(XFS_SYMLINK_MAXLEN + 1, ...)`, explicitly reserving space for
> > the NUL terminator.
> >
> > `strscpy()` is the proper replacement because it guarantees NUL-termina=
tion
> > of the destination buffer, correctly handles the copy limit, and aligns
> > with current kernel string-copying best practices.
> > Other recommended functions like `strscpy_pad()`, `memcpy()`, or
> > `memcpy_and_pad()` were not used because:
> > - `strscpy_pad()` would unnecessarily zero-pad the entire buffer beyond=
 the
> >   NUL terminator, which is not required as the function returns `nr` by=
tes.
> > - `memcpy()` and `memcpy_and_pad()` do not guarantee NUL-termination, w=
hich
> >   is critical given `target_buf` is used as a NUL-terminated string.
> >
> > This change improves code safety and clarity by using a safer function =
for
> > string copying.
>
> Did you find an actual bug in online fsck, or is this just
> s/strncpy/strscpy/ ?  If the code already works correctly, please leave
> it alone.  Unless you want to take on all the online fsck and fuzz
> testing to make sure the changes don't break anything.

This was s/strncpy/strscpy/ , no real bug.

--=20
Cheers,
Marcelo Moreira
