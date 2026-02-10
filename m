Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC029387575
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740675; cv=pass; b=Xpb460K3qjp+IbPn7tW6uFuc0nZSFsizYR2kgQuyXKdldOHvCuWRoyUUXBTOzACOgGBPdgC8CTLJPXfNnScV2n6/ngP//psWfZHyDd62Q9X6QAgpMm3je6IkmnovoeRgJvRNHMhdSBe4iO9IpQxCkkgsz88acTwHpdw4o3xTXxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740675; c=relaxed/simple;
	bh=BkWtyYpqejlmByRC727LdbfV/RYqAERDreFY/UP2Aa4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FiOSAxCpqrkF0So9EGLnrz848rxo0cfWT0UKvSmCZnC+x01h9HLH6iWjOZ8UsbRueGp6NGDrxTflHyMD/ozqlukrd4MUiS1lufd4L+SvDHBMfXXWzghhkKiyHm3ULaFLikkcAzhxKsx7/WnRajirePpQQdLsRu/rZscQ+5LJxWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jXoHp7nY; arc=pass smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jXoHp7nY"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-45c9fdf2a06so3857438b6e.2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 08:24:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770740674; cv=none;
        d=google.com; s=arc-20240605;
        b=Q7NZe65kCwzNr73EzKI+pau/267Tc+AyQR23lQ6WW4cbTRCk77spDJbmBEXVErLPrJ
         cCFUic0LaOMlk77uPUNPXVE7bP4ci30t808N4cNWUMbnNI1KNz/qaMl3k3mZc/JZx9yD
         fOgcpJ9F8ODXdVQwHF3a6B0rjsre9hactk6UBPBe7DT6aXH+Hvh5JdJLuYYiS6/KGgcw
         j2YyJossBY59pTZBjechfrbo8Jlk+fjrVjJpQNcrry/OeBabZ2bz6/BB9njKeQxeV/DI
         mm6KP6pqg42lUfgACEAVk/JHDeOoklVdaGVWL02lp9DIYxyn48/3Z5OFIn4c4BHYrHPy
         I1tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e87k8iFish9q2Uq3v9Uy7Fjw166hMufB5O7qErb387U=;
        fh=LNM2MLq2RHw43tZKNgnqPLVOkcNkeHhlCxQKkA5VI60=;
        b=gO7WY/Z84iQwdOhYonptIcrJskdnUJtXpHQWkH6ei81gWH+hM6DcYt8u0iAtmqDzJE
         82q8f3ta13VE0yKlC5B5zA0CSyGiXt+9L+Eql32G1Ahvl8EnK8BMOaniK1L5nygJjT0K
         dSd3wuEp7TTl18mNt5MwVg9GpvnCEHtQoYPmSNHLF5j3uAWQ31lBdCSL9TEty+K/qRB2
         GX5xJBeSJgXTrn/RT4iDmIK6bPR7hd7K6A0jymHT1TkrfKPdnCgFtu1+KpUiXeXUBy+c
         7cgexrqSW3hltHXoT8eaStOau/vik93al11IFHdXG+hGpYEX/mH+HRI+MxsrOEN4cYJb
         h72w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770740674; x=1771345474; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e87k8iFish9q2Uq3v9Uy7Fjw166hMufB5O7qErb387U=;
        b=jXoHp7nY23Kq85huTPiHL1JsEK6nChfn2n6ItO9mJhQQLQMLKOQUwAVBSk5naFxJhY
         R/CAa71VMkrHO+oF8K/OeGmgfjlswwdenQw7JEPsknyqg9LfdHHw0qjAjeMFHb7LmAQ0
         sJGdIejhGm1kpLSexdcYBGDFglcXyj/uHKnuemJHLlww8nLSGLHYaDtZaLpyytNS4u7q
         5lZFsffLsIby593IrGgzTQKuGXwsc2GUrRsA2zUNcdHq2LR4zmXIHCTuBkFVCbD5V0Zm
         maODHoWpBu+PpgywObJIsMVDxwDufhdioUxtB/jrMD9+mMy1p548uzR+djRpr1ECBXDU
         x+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770740674; x=1771345474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e87k8iFish9q2Uq3v9Uy7Fjw166hMufB5O7qErb387U=;
        b=P6l98aLaHc2xD86PzMZNJdXO7bpN22AHt0hrAq0DZjj5Luo4IbWWCD2unW4/TEUO5Q
         xxg6kqmdq3zfdHZv+d/61KKXW5bVwvLJI8Lwzu1omRjP/vwnVsGwk2t9cZwam1vVjR61
         k9c3/WABeLEJzbye9OoC6/ULjmWAYZlj0ibh3euAP6S3EdsC3mFLVv1/N4Kw0Y+U4pHV
         U+auA2fwGAFqkhuwbCqzYWCKjG0jtN/ekp9UHewKsiRJpf2LmMlU2WdLnvAwskKDfYiL
         q0cbgYnkYhlSLPFUTbcMCLIpY9Wvb6438GkkFImzRl8hcxorOxHhcz9Q7/byFghviWTd
         8FkA==
X-Forwarded-Encrypted: i=1; AJvYcCWbkYt+u2iwldSg3lVN3EenaNuM8uRcVVTyZs8rliKQtyGO1U7Robp/QzZnxE1IYO8Cz8SHVbWhOSA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwF7bth/B1UL+YcMy+WkLjSw923LXMQ6t32wW3U9KVthTzCXvin
	Rm/C8X7Vr833AulghlUMBXNDrq6nD2+1kubOlBn67tf6NWfhH8dTZRu1YjC/UXO0kv7qztiLPWt
	V3Zh14c7ZDexOMeL/owkSj99mAzgn+OQ=
X-Gm-Gg: AZuq6aKAdVir4aHejl53QG5PgHgB5Kma0Ghwbv3wiGP9Pcl3T6RTNpft4IHbCYhNSvN
	jgCSb5/NzYZmYUV+i0Ep6dOr0c2wFlMWEl+/npVtMQlwJjMjERPidPe3z+qhyweggMbGdETXfbk
	AXuseIrNw5p+o0AZKap9cb2+neAZ6AYRSxfoKOTsSecWSsUY0G6sOQpMKqKvqYKklJ68L3QicPE
	AM+5N+hlUc9gBZajJwiStjI5miXKWCWggFp618ZHkq+qaFnGVmKjvVby24pzd5RELuxWMNXmI+o
	I7adwdY=
X-Received: by 2002:a05:6808:4f23:b0:45f:42d6:2ffb with SMTP id
 5614622812f47-462fd051fdamr6992569b6e.41.1770740673692; Tue, 10 Feb 2026
 08:24:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120142439.1821554-1-cel@kernel.org> <20260123-zwirn-verfassen-c93175b7a1ee@brauner>
 <41b1274b-0720-451d-80db-210697cdb6ac@app.fastmail.com> <20260124-gezollt-vorbild-4f65079ab1f1@brauner>
 <a1692040-58d0-412d-b0fc-c7b7a62585c4@app.fastmail.com>
In-Reply-To: <a1692040-58d0-412d-b0fc-c7b7a62585c4@app.fastmail.com>
From: Cedric Blancher <cedric.blancher@gmail.com>
Date: Tue, 10 Feb 2026 17:23:57 +0100
X-Gm-Features: AZwV_Qjy3M0uZY-NRx3otdHnq6x-9RSVjw1ETeNOu6B1p4FZNE0JCUf2MFslsk8
Message-ID: <CALXu0UcJf+R3HuzwUrUTjsuYWdFrLZOwAsEtSyto2T9Rtg4rsw@mail.gmail.com>
Subject: Re: [PATCH v6 00/16] Exposing case folding behavior
To: linux-nfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"

On Sun, 25 Jan 2026 at 23:05, Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Sat, Jan 24, 2026, at 7:52 AM, Christian Brauner wrote:
> > On Fri, Jan 23, 2026 at 10:39:55AM -0500, Chuck Lever wrote:
> >>
> >>
> >> On Fri, Jan 23, 2026, at 7:12 AM, Christian Brauner wrote:
> >> >> Series based on v6.19-rc5.
> >> >
> >> > We're starting to cut it close even with the announced -rc8.
> >> > So my current preference would be to wait for the 7.1 merge window.
> >>
> >> Hi Christian -
> >>
> >> Do you have a preference about continuing to post this series
> >> during the merge window? I ask because netdev generally likes
> >> a quiet period during the merge window.
> >
> > It's usually most helpful if people resend after -rc1 is out because
> > then I can just pull it without having to worry about merge conflicts.
> > But fwiw, I have you series in vfs-7.1.casefolding already. Let me push
> > it out so you can see it.
>
> There will be at least one more revision of this series (and it can
> happen in a few weeks) to split 1/16 as Darrick requested, and
> address the nit that Jan noted.

Are you targeting LInux 7.0 or Linux 7.1?

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
[https://plus.google.com/u/0/+CedricBlancher/]
Institute Pasteur
