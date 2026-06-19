Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE7B3148C5
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jun 2026 07:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854126; cv=pass; b=c2AtUI1Evn/X1JwbmXnhWM/emCIYGPEtf8S9W136QH8CPLQt8LT3zyqEy77KGRlxig/yIFrUPESPe8dFakqEmE6DEwL+NBvXolDt2LxPSCVii2GuCcreDHyycuHdgm46lJlEVvcIm7kIU+P3QOyCXmXPYMCMDsLeSkjpCEiRnyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854126; c=relaxed/simple;
	bh=PLjuf5U1Ldp+lKMspivltGTyqfvutQwDbWwFfF6CvPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBeLyryBmqRviRnju4nkmhg9HpOdKw02F4Ra+gdXlyXxaHYJcZfeuIzwX19e4htO2wEh/+lIuFf/XMxOtDtHE2eEBOIhH4Jd5pxtahqz6Rgh/A2tb2qUpR+PYwLk6jA3LibGolC0f2M1hiTHZlGGjQnZUwf6stnupN3F4i4l0FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKTQcXfm; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKTQcXfm"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-695427c153fso2478255a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jun 2026 00:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781854123; cv=none;
        d=google.com; s=arc-20240605;
        b=B8OTpVaoeyN7aOx1q4/lnSlFyRJ6WIU2JhAsUcp6F22fYo4fvf4cWwUH/z3Y8a3AvV
         LpL+lPT3DddW5+eDY0h4Yqx41SwV1n6i+fZqF3wlZkbViadgOSgNRHfqbT9bYypUv01g
         ABJ1cG8/I0yZS7MR47erlb0qlzrA9GY8y+fjeG3zcukV1OYTtevvXfKguNPJ4aN9RwyG
         GasckmgfmIv44ezv1+NC9Ci2tMcG+a6W9dmakd7ZTk6lhnJz3E0eX1NQSheaLiTCAOBH
         46fhCn+b630j7gLbBxcNrmdhpU1hyTnu6ADAoqLl/7ieL+Hwu+dws84EQU0UEK8t4b+X
         JhcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        fh=jL045auBh6ig1bWjfj0inyRWqB+BZJsfAnQVDeZ/f7o=;
        b=k27kXzhO6eWN/yNs5xYsJBF4+z4s2DTk1D+gosGOlGFEAUF2JNrwKpGjg32elgCpou
         kFPpLVq71Pe/w1ihBpFKjCdMCd0fzdy/kB24tS+Sf/5AYLyyvtmMCYZ5qz3Ya4L+NKf2
         YJs97oNeQmWrm9sN3ML4i2gGsE94OTD/wRwfrXLRsqJ/wK1UjNkkEuZfOL2UefMFuEPw
         FzidNhtkfhPHzU9IiiYc9bNqO4shXnOxWzC0849sEAM9qbmv24VspczRRIdKpTjf0PIG
         +b2GKVRydU3JNrzwif/faUyBZvC2NxBQRs0rgtm47lye3BYBk1axPGEiscyxlNfVvm1v
         RwEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781854123; x=1782458923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        b=EKTQcXfmTpSi/O7oXABloqzK4/JL++I7lANtSI92FSwbPSaHSyI+Ly8uLgGGwc1czJ
         YtYQI1UH6Uizdt0GwLZqdw2hO65NG7CfVB0eP71OayhIh1bgU1DaOg15/9a9kMa2zgBW
         zdQNfNRTcXpnOjFC0pWD2Qy8AAunFSt5GVlRmax9ecbpzBv06uE4YFJ4+8celdU/Mj1B
         MGNL1NDGi6M4Os0QZhfGMRwpocG1MmdFdOgNugrBvNpnHeADOFto20dQ5EA6cQgJtC5/
         S6OL7JKPrJ0cmvFh1esu4XnUeP+wn0wTEaOxYUfcyAwVCO0NjXfBZnXTUOLQKFc0fC2I
         AXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781854123; x=1782458923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        b=ddxaP3NLGX17pny30OCJI5E/uuPSpScDE0e6Na9ThQM+YHMoUT04g+obX6t3ByvpNu
         Ut14bjEkJtVdC4GwjjIfZAL7gmjHj4DUMmpV3prx/MiK62ZY+jLnFZe+kvMdN/z68zte
         2g8+WhB2LwkjO7sE2qYNVA3cYzddvaoCiIa+j0PxQ7o8UqNlb3ow8LQguN4Hneb/eotU
         /6z4kMQuVI3hcC4QVzh7aRcRx0rpkwrdft65+nTHmRkZ6jRAo0h+lwf/XMYHuogWwyuN
         8WuhcfU5ViUYaQSa2M2jMqnjWVVlvFApaSj04ayxsa7PhGYkPEeFtEHnOsMQ62ZC8JhB
         j1Xw==
X-Forwarded-Encrypted: i=1; AFNElJ8n+QLU8ystd4zppvNZYK9+m44IH89Iex4D0N0mLUja8fKskTW08n1qW9avdGg3XNxfJWSk2nSNaRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLhFXdOFz3BwBHFxzxD1vR6x6G6k+7DZdtBF/xZLdT9N2WpM7M
	Ymmyenr+AkhRoPaCTTUJe5oPfVAWcdxHTKZjcpSLaEMhs9jhhTc/cK9T5W+ZOtwtnPRw04mIXlf
	MhWC82LwEtSQYYw8Cpq+3w+ZYac0vcIo=
X-Gm-Gg: AfdE7cmdOlWD5OjphDxFcdGWFki0WvfwrsZcyxlY4LbCMpWw3PYDrmLypsdTlZgMGnJ
	m18z0JT8+wsIF/x2f9zT+YIaM19b9hTM6gBQiPNaJI2VYjDm35hertp/7IL5CnAzWWQndNRluyb
	j7kYHiB7mWq3X8+Wknp23Lx/JLJVGtu+rckTiU/6wCiAkzbNRZTwLGF9bTjjQZYYoKo1Vu8ELu+
	B66uIDZnpywUT3E1fGgpqgo3IU3Zzuq8iJl2V6BpKD9qQ1exrwi1EGseQQMgKCeyT6yjVyJsYOE
	UpY7zBS7juC9A8mdXGpiYrfDJ/JKO+zHfbQSdMxrSw==
X-Received: by 2002:a05:6402:5107:b0:695:572a:7ab5 with SMTP id
 4fb4d7f45d1cf-69711e00675mr1216968a12.19.1781854123208; Fri, 19 Jun 2026
 00:28:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520123722.405752-1-aalbersh@kernel.org> <20260520123722.405752-4-aalbersh@kernel.org>
 <20260520190719.GB3424023@google.com>
In-Reply-To: <20260520190719.GB3424023@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 Jun 2026 09:28:31 +0200
X-Gm-Features: AVVi8CcyPPKNjODd0CeG8qbXXsZeOsRanxA9PmKFMYeTLACw7w0uBX2gqOCDc0w
Message-ID: <CAOQ4uxh_hfiSwMw8ABhhrz7GguZWjHEiBmvb3eq16Wfqw0+ZrQ@mail.gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 9:07=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Wed, May 20, 2026 at 02:37:01PM +0200, Andrey Albershteyn wrote:
> > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > instead of opening file to ensure that fsverity info is loaded and
> > attached to inode.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/util.c | 14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
>
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
>
> I'm still confused by the new implementation of fsverity_active() that
> got introduced by "fsverity: use a hashtable to find the fsverity_info",
> though.  I should have caught this during review of that commit.  For
> one its comment is outdated, but also the memory barrier seems to be
> specific to the fsverity_get_info() caller and probably should be moved
> to there.  Anyway, that's not directly related to this patch.

Eric, Andrey,

Did you see the Sashiko review for this patch and others in this series?

https://sashiko.dev/#/patchset/20260520123722.405752-1-aalbersh%40kernel.or=
g

It annotated some review comments as high and critical.
For this patch it is about interaction with fscrypt.

Please take a look and say if this is concerning or false positive.

Thanks,
Amir.
